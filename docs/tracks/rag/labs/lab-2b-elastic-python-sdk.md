# Lab 2B — Use watsonx & Elasticsearch Python SDK for RAG (No LangChain)

**Goal:** Build the same RAG pattern, but directly with the **Elasticsearch Python client** and the **ibm-watsonx-ai** SDK. This gives full control over index mappings, bulk ingestion, and KNN queries.

---

## 0) Prereqs

* Same environment and `.env` as **Lab 2A** (re-use it).
* Python dependencies (if you skipped 2A):

```bash
pip install ibm-watsonx-ai elasticsearch==8.* python-dotenv pypdf unstructured[all-docs] beautifulsoup4 lxml pandas numpy tiktoken
```

---

## 1) Load configuration and create clients

```python
import os
from dotenv import load_dotenv
from elasticsearch import Elasticsearch, helpers

load_dotenv()  # loads .env

# ---- watsonx.ai ---
WATSONX_URL = os.getenv("WATSONX_URL")
WATSONX_API_KEY = os.getenv("WATSONX_API_KEY")
WATSONX_PROJECT_ID = os.getenv("WATSONX_PROJECT_ID")
WX_LLM_MODEL_ID = os.getenv("WX_LLM_MODEL_ID", "ibm/granite-13b-instruct-v2")
WX_EMBEDDINGS_MODEL_ID = os.getenv("WX_EMBEDDINGS_MODEL_ID", "ibm/granite-embedding-278m")

# ---- Elasticsearch ---
ES_CLOUD_ID = os.getenv("ES_CLOUD_ID")
ES_API_KEY = os.getenv("ES_API_KEY")

ES_HOST = os.getenv("ES_HOST")
ES_USERNAME = os.getenv("ES_USERNAME")
ES_PASSWORD = os.getenv("ES_PASSWORD")
ES_CA_CERT = os.getenv("ES_CA_CERT")

if ES_CLOUD_ID and ES_API_KEY:
    es = Elasticsearch(cloud_id=ES_CLOUD_ID, api_key=ES_API_KEY)
elif ES_HOST:
    es = Elasticsearch(ES_HOST, basic_auth=(ES_USERNAME, ES_PASSWORD) if ES_USERNAME and ES_PASSWORD else None,
                       ca_certs=ES_CA_CERT)
else:
    raise RuntimeError("Configure Elasticsearch credentials.")

print(es.info())
```

---

## 2) Helpers: load, chunk, embed, generate

```python
import pathlib
from typing import List, Dict
from pydantic import BaseModel
from ibm_watsonx_ai.foundation_models import Model
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from ibm_watsonx_ai import Credentials as WxCredentials

# 2.1 – Load text and PDFs
def load_corpus(corpus_dir="data/corpus") -> List[Dict]:
    from langchain_community.document_loaders import DirectoryLoader, TextLoader, PyPDFLoader
    docs = []
    loader = DirectoryLoader(corpus_dir, glob="**/*.md", loader_cls=TextLoader, show_progress=True)
    docs.extend(loader.load())
    try:
        pdf_loader = DirectoryLoader(corpus_dir, glob="**/*.pdf", loader_cls=PyPDFLoader, show_progress=True)
        docs.extend(pdf_loader.load())
    except Exception:
        pass
    return [{"text": d.page_content, "source": d.metadata.get("source")} for d in docs]

# 2.2 – Chunking
def chunk_texts(items: List[Dict], chunk_size=800, chunk_overlap=120) -> List[Dict]:
    from langchain.text_splitter import RecursiveCharacterTextSplitter
    splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    out = []
    for it in items:
        for ch in splitter.split_text(it["text"]):
            out.append({"text": ch, "source": it["source"]})
    return out

# 2.3 – watsonx Embeddings
class WxEmbeddings(BaseModel):
    model_id: str
    url: str
    api_key: str
    project_id: str

    def _client(self):
        creds = WxCredentials(url=self.url, api_key=self.api_key)
        return Model(
            model_id=self.model_id,
            credentials=creds,
            project_id=self.project_id,
            params={}
        )

    def embed(self, texts: List[str]) -> List[List[float]]:
        # The Model() class exposes `embed`, or you can call .generate with a special task, depending on model.
        # Here we try .embed for embeddings-capable models:
        client = self._client()
        vectors = client.embed(texts=texts)  # returns {"vectors": [[...], ...]} or just [[...]]
        if isinstance(vectors, dict) and "vectors" in vectors:
            return vectors["vectors"]
        return vectors

# 2.4 – watsonx LLM (generate answers)
def gen_answer(context: str, question: str) -> str:
    creds = WxCredentials(url=WATSONX_URL, api_key=WATSONX_API_KEY)
    gen = Model(
        model_id=WX_LLM_MODEL_ID,
        credentials=creds,
        project_id=WATSONX_PROJECT_ID,
        params={
            GenParams.DECODING_METHOD: "greedy",
            GenParams.MAX_NEW_TOKENS: 350,
            GenParams.REPETITION_PENALTY: 1.05
        }
    )
    prompt = f"""You are a helpful enterprise assistant. Use ONLY the context below to answer, be concise,
and cite the source filenames you used.

CONTEXT:
{context}

QUESTION: {question}

ANSWER:"""
    out = gen.generate_text(prompt=prompt)
    if isinstance(out, dict) and "results" in out:
        return out["results"][0]["generated_text"].strip()
    return str(out).strip()
```

> **Note:** The exact method names/return shapes can vary slightly by SDK release and model. If `embed()` isn’t available for your chosen embeddings model, switch to a supported embeddings endpoint or the `langchain_ibm.WatsonxEmbeddings` class (as in Lab 2A) to generate vectors, then push them via the raw ES client below.

---

## 3) Create index with dense_vector mapping

We’ll infer the vector **dimensions** from a sample embedding.

```python
# Build one test vector to learn dimensions
emb = WxEmbeddings(
    model_id=WX_EMBEDDINGS_MODEL_ID,
    url=WATSONX_URL,
    api_key=WATSONX_API_KEY,
    project_id=WATSONX_PROJECT_ID
)

sample_vec = emb.embed(["dim-check"])[0]
DIMS = len(sample_vec)
print("Embedding dims =", DIMS)

INDEX = "rag_workshop_sdk"

# Delete if exists
es.indices.delete(index=INDEX, ignore_unavailable=True)

mapping = {
  "mappings": {
    "properties": {
      "text": {"type": "text"},
      "source": {"type": "keyword"},
      "embedding": {
        "type": "dense_vector",
        "dims": DIMS,
        "similarity": "cosine"
      }
    }
  },
  "settings": {
    "index": {
      "knn": True
    }
  }
}

es.indices.create(index=INDEX, body=mapping)
print("Created index:", INDEX)
```

---

## 4) Ingest documents

```python
raw = load_corpus("data/corpus")
chunks = chunk_texts(raw)
print(f"Loaded {len(raw)} docs, created {len(chunks)} chunks")

# Batch in small groups to control cost/latency
BATCH = 64
for i in range(0, len(chunks), BATCH):
    batch = chunks[i:i+BATCH]
    vectors = emb.embed([b["text"] for b in batch])
    actions = []
    for doc, vec in zip(batch, vectors):
        actions.append({
            "_index": INDEX,
            "_source": {
                "text": doc["text"],
                "source": doc["source"],
                "embedding": vec
            }
        })
    helpers.bulk(es, actions)
    print(f"Indexed {i+len(batch)}/{len(chunks)}")
```

---

## 5) KNN retrieve + generate

```python
def retrieve(query: str, k=5, num_candidates=100):
    qvec = emb.embed([query])[0]
    body = {
        "knn": {
            "field": "embedding",
            "query_vector": qvec,
            "k": k,
            "num_candidates": num_candidates
        },
        "_source": ["text", "source"]
    }
    resp = es.search(index=INDEX, knn=body["knn"], _source=body["_source"])
    hits = resp["hits"]["hits"]
    return [
        {"text": h["_source"]["text"], "source": h["_source"]["source"], "score": h["_score"]}
        for h in hits
    ]

def answer(query: str) -> str:
    hits = retrieve(query, k=5)
    seen = set()
    contexts = []
    citations = []
    for h in hits:
        if h["source"] not in seen:
            contexts.append(h["text"])
            citations.append(h["source"])
            seen.add(h["source"])
    context = "\n\n".join(contexts[:4])
    ans = gen_answer(context=context, question=query)
    print("Citations:", citations)
    return ans, citations

q = "What is IBM Granite optimized for?"
ans, cites = answer(q)
print("Q:", q)
print("A:", ans)
print("Sources:", cites)
```

---

## 6) Hybrid retrieval (BM25 + vector) with simple blending

```python
from collections import defaultdict

def retrieve_hybrid(query: str, k_lex=5, k_vec=5, alpha=0.5):
    # BM25
    bm25_resp = es.search(
        index=INDEX,
        query={"match": {"text": {"query": query}}},
        size=k_lex,
        _source=["text", "source"]
    )
    bm25_hits = [{"id": h["_id"], "score": h["_score"], **h["_source"]} for h in bm25_resp["hits"]["hits"]]

    # KNN
    knn_hits = retrieve(query, k=k_vec)

    # Normalize and blend
    scores = defaultdict(float)
    payloads = {}
    max_bm = max([h["score"] for h in bm25_hits] + [1.0])
    max_knn = max([h["score"] for h in knn_hits] + [1.0])

    for h in bm25_hits:
        nid = f"bm25::{h['source']}::{hash(h['text'])}"
        scores[nid] += alpha * (h["score"] / max_bm)
        payloads[nid] = h

    for h in knn_hits:
        nid = f"knn::{h['source']}::{hash(h['text'])}"
        scores[nid] += (1 - alpha) * (h["score"] / max_knn)
        payloads[nid] = h

    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)
    merged = [payloads[_id] for _id, _ in ranked][:5]
    return merged

def answer_hybrid(query: str) -> str:
    hits = retrieve_hybrid(query)
    context = "\n\n".join(h["text"] for h in hits)
    ans = gen_answer(context, query)
    cites = [h["source"] for h in hits]
    print("Citations:", cites)
    return ans, cites

ans, cites = answer_hybrid("Describe watsonx projects and prompt template assets.")
print(ans)
```

---

## 7) Minimal evaluation harness

```python
evalset = [
    ("What is watsonx.ai used for?", ["faq_watsonx.md"]),
    ("Summarize Granite in one sentence.", ["granite_overview.md"]),
]

ok = 0
for q, expected_sources in evalset:
    ans, cites = answer_hybrid(q)
    got = any(any(exp in (c or "") for c in cites) for exp in expected_sources)
    ok += int(got)
    print("-" * 80)
    print("Q:", q)
    print("Expected files:", expected_sources, "Got:", cites, "Match:", got)

print(f"Eval pass rate: {ok}/{len(evalset)}")
```

---

## 8) Troubleshooting

* **`dense_vector` unsupported**: Your ES version might be too old. Use Elasticsearch 8.0+.
* **CORS / auth errors**: Validate credentials and TLS CA if self-hosted.
* **watsonx timeouts**: Reduce batch sizes for embedding; retries/backoff; cache vectors during iteration.

---

## 9) Cleanup

```python
es.indices.delete(index=INDEX, ignore_unavailable=True)
```

---

**You now have a pure-SDK RAG implementation with full control over ES.**
Next, package these steps into CLI/API and connect to your UI.
