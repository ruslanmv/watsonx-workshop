\
# Lab 1 — Q&A with **RAG Accelerator** (End-to-End)

> **Goal:** convert a small corpus of **HTML/PDF** into a working **Q&A app** that retrieves passages and drafts grounded answers with an LLM.
> **You’ll build:** an ingestion pipeline → vector index (Elasticsearch or Chroma) → a FastAPI service → a simple Streamlit chat UI.
> **Time:** 90–120 minutes

---

## Outcomes

By the end, you will be able to:

* Prepare mixed **HTML/PDF** sources and extract clean text.
* **Chunk** and **embed** documents, and store vectors in **Elasticsearch** (preferred) or **Chroma** (local/dev).
* Implement a minimal **RAG pipeline** (retrieve → re-rank → synthesize) using a Granite LLM on **watsonx.ai** (for answer drafting).
* Expose the pipeline as a **/ask** API, and a **chat UI** users can try immediately.
* Measure quality with a tiny evaluation script (hit@k, answer length, citation coverage).

---

## Architecture (at a glance)

```mermaid
flowchart LR
  A[Docs: HTML/PDF] --> B[Extractor & Cleaner]
  B --> C[Chunker]
  C --> D[Embeddings]
  D -->|dense vectors| E{Vector Store}
  E -->|top-k docs| F[Reranker (optional)]
  F --> G[Prompt Composer]
  G --> H[LLM on watsonx.ai]
  H --> I[Answer + Citations]
  I --> J[FastAPI /ask]
  J --> K[Streamlit Chat UI]
```

---

## Prerequisites

* Python **3.10 or 3.11**
* (Preferred) **Elasticsearch 8.x** reachable via API  
  *Alternative*: local **Chroma** DB (no external service)
* An **IBM watsonx.ai** API key, project id, and base URL (for LLM inference)

> If you don’t have Elasticsearch yet, you can still complete the lab with Chroma. Switching later is just a config change.

---

## Project layout

We’ll keep all accelerator files under `accelerator/` (sibling to your `docs/` folder):

```
accelerator/
├─ .env.sample
├─ config.yaml
├─ pyproject.toml
├─ Makefile
├─ corpus/                      # place 10–20 short PDFs/HTML here
│  ├─ 01-overview.pdf
│  ├─ 02-faq.html
│  └─ ...
├─ data/
│  ├─ clean/                    # extracted & cleaned text (generated)
│  └─ chunks/                   # chunked JSONL (generated)
├─ index/
│  └─ chroma/                   # local Chroma DB (generated if used)
├─ tools/
│  ├─ extract.py                # PDF/HTML → text
│  ├─ chunk.py                  # text → chunks
│  ├─ embed_index.py            # chunks → vectors (ES or Chroma)
│  └─ eval_small.py             # tiny retrieval/answer sanity checks
├─ rag/
│  ├─ retriever.py              # unified retriever (ES/Chroma)
│  ├─ prompt.py                 # answer template
│  └─ pipeline.py               # retrieve → (rerank) → compose → LLM
├─ service/
│  ├─ api.py                    # FastAPI service with /ask
│  └─ deps.py                   # wiring (env, clients)
└─ ui/
   └─ app.py                    # Streamlit chat UI
```

> You can generate this skeleton from the snippets below. If you already unzipped a starter, align/rename files as needed and keep to this layout for the lab.

---

## Install & Configure

### 1) Create a virtual environment and install deps

`accelerator/pyproject.toml`:

```toml
[project]
name = "rag-accelerator"
version = "0.1.0"
description = "End-to-end RAG accelerator (HTML/PDF → Q&A app)"
requires-python = ">=3.10"
dependencies = [
  # core
  "python-dotenv>=1.0.1",
  "pydantic>=2.7",
  "pydantic-settings>=2.4",
  "pyyaml>=6.0.2",
  "tqdm>=4.66",
  "orjson>=3.10",

  # extraction / cleaning
  "pypdf>=4.2.0",
  "beautifulsoup4>=4.12.3",
  "lxml>=5.3.0",
  "html2text>=2024.2.26",
  "unstructured>=0.15.5; sys_platform != 'win32'",

  # chunking
  "nltk>=3.9.1",

  # embeddings & vector stores
  "sentence-transformers>=3.1.0",
  "chromadb>=0.5.5",
  "elasticsearch>=8.14.0",

  # LLM on watsonx
  "ibm-watsonx-ai>=1.1.6",   # SDK for Granite models

  # API & UI
  "fastapi>=0.115.0",
  "uvicorn[standard]>=0.30.6",
  "streamlit>=1.37.1",

  # optional reranker
  "rank-bm25>=0.2.2"
]

[tool.setuptools.packages.find]
where = ["."]
```

Install:

```bash
cd accelerator
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -U pip
pip install -e .
```

### 2) Environment variables

`accelerator/.env.sample`:

```bash
# ==== watsonx.ai (required for answer drafting) ====
WATSONX_API_KEY=your_api_key
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_PROJECT_ID=your_project_id
WATSONX_MODEL=ibm/granite-13b-instruct-v2   # choose an instruct model

# ==== embeddings ====
EMBED_MODEL=sentence-transformers/all-MiniLM-L6-v2
EMBED_DIM=384

# ==== vector backend ====
VECTOR_BACKEND=elasticsearch             # elasticsearch | chroma

# ---- Elasticsearch (if VECTOR_BACKEND=elasticsearch) ----
ES_HOST=https://localhost:9200
ES_API_KEY=your_es_api_key               # or set ES_USER/ES_PASS if basic auth
ES_INDEX=rag_corpus

# ---- Chroma (if VECTOR_BACKEND=chroma) ----
CHROMA_DIR=./index/chroma

# ==== retrieval ====
TOP_K=5
```

Copy it and fill values:

```bash
cp .env.sample .env
# edit .env with your keys and options
```

### 3) Global config

`accelerator/config.yaml`

```yaml
corpus_dir: ./corpus
clean_dir: ./data/clean
chunk_dir: ./data/chunks

chunking:
  # split by sentence windows
  target_chars: 800
  overlap_chars: 150
  min_chars: 200

retrieval:
  top_k: 5
  rerank_bm25: true
  bm25_top_k: 20
```

---

## Step 1 — Extract & Clean (HTML/PDF → text)

`accelerator/tools/extract.py`

```python
import os
import re
from pathlib import Path
from bs4 import BeautifulSoup
import html2text
from pypdf import PdfReader
from tqdm import tqdm
import argparse
import yaml

def read_pdf(path: Path) -> str:
    reader = PdfReader(str(path))
    pages = [p.extract_text() or "" for p in reader.pages]
    text = "\\n".join(pages)
    return text

def read_html(path: Path) -> str:
    raw = path.read_text(encoding="utf-8", errors="ignore")
    soup = BeautifulSoup(raw, "lxml")
    # remove script/style
    for tag in soup(["script", "style", "noscript"]):
        tag.decompose()
    # convert to markdown-ish text
    md = html2text.html2text(str(soup))
    return md

def clean_text(txt: str) -> str:
    txt = re.sub(r"[ \\t]+", " ", txt)
    txt = re.sub(r"\\n{3,}", "\\n\\n", txt)
    return txt.strip()

def main(config_path: str):
    cfg = yaml.safe_load(Path(config_path).read_text())
    corpus = Path(cfg["corpus_dir"])
    outdir = Path(cfg["clean_dir"])
    outdir.mkdir(parents=True, exist_ok=True)

    files = list(corpus.glob("**/*"))
    files = [f for f in files if f.suffix.lower() in {".pdf", ".html", ".htm"}]
    if not files:
        print(f"No PDF/HTML in {corpus}")
        return

    for f in tqdm(files, desc="Extracting"):
        try:
            if f.suffix.lower() == ".pdf":
                txt = read_pdf(f)
            else:
                txt = read_html(f)
            txt = clean_text(txt)
            rel = f.relative_to(corpus)
            outf = outdir / (rel.as_posix() + ".txt")
            outf.parent.mkdir(parents=True, exist_ok=True)
            outf.write_text(txt, encoding="utf-8")
        except Exception as e:
            print("WARN:", f, e)

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default="config.yaml")
    args = ap.parse_args()
    main(args.config)
```

Run:

```bash
python tools/extract.py --config config.yaml
```

Outputs `.txt` files under `data/clean/…`.

---

## Step 2 — Chunk (text → passages)

`accelerator/tools/chunk.py`

```python
from pathlib import Path
from typing import List, Dict
import json
import yaml
import re
from tqdm import tqdm
import argparse

def split_sentences(text: str) -> List[str]:
    # simple fallback sentence splitter (no external models)
    # good enough for tech docs
    sents = re.split(r'(?<=[.!?])\\s+', text.strip())
    return [s.strip() for s in sents if s.strip()]

def windowed_chunks(sents: List[str], target: int, overlap: int, min_chars: int):
    buf, size = [], 0
    i = 0
    while i < len(sents):
        buf.append(sents[i])
        size += len(sents[i]) + 1
        if size >= target:
            chunk = " ".join(buf)
            if len(chunk) >= min_chars:
                yield chunk
            # overlap tail
            tail = []
            count = 0
            j = len(buf) - 1
            while j >= 0 and count < overlap:
                tail.insert(0, buf[j])
                count += len(buf[j]) + 1
                j -= 1
            buf, size = tail, sum(len(x) + 1 for x in tail)
        i += 1
    if buf:
        chunk = " ".join(buf)
        if len(chunk) >= min_chars:
            yield chunk

def main(config_path: str):
    cfg = yaml.safe_load(Path(config_path).read_text())
    clean_dir = Path(cfg["clean_dir"])
    outdir = Path(cfg["chunk_dir"])
    outdir.mkdir(parents=True, exist_ok=True)

    target = int(cfg["chunking"]["target_chars"])
    overlap = int(cfg["chunking"]["overlap_chars"])
    min_chars = int(cfg["chunking"]["min_chars"])

    inputs = list(clean_dir.glob("**/*.txt"))
    if not inputs:
        print(f"No .txt in {clean_dir}, run extract step first.")
        return

    for f in tqdm(inputs, desc="Chunking"):
        text = f.read_text(encoding="utf-8")
        sents = split_sentences(text)
        chunks = list(windowed_chunks(sents, target, overlap, min_chars))
        rel = f.relative_to(clean_dir)
        out = (Path(str(outdir / rel).replace(".txt", ".jsonl")))
        out.parent.mkdir(parents=True, exist_ok=True)
        with out.open("w", encoding="utf-8") as wf:
            for idx, ch in enumerate(chunks):
                rec = {
                    "doc_id": str(rel),
                    "chunk_id": idx,
                    "text": ch
                }
                wf.write(json.dumps(rec, ensure_ascii=False) + "\\n")

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default="config.yaml")
    args = ap.parse_args()
    main(args.config)
```

Run:

```bash
python tools/chunk.py --config config.yaml
```

Outputs per-file `.jsonl` with chunk records under `data/chunks/…`.

---

## Step 3 — Embed & Index (chunks → vectors)

Supports **Elasticsearch** (recommended) or **Chroma** (no external service). Controlled by `.env` → `VECTOR_BACKEND`.

`accelerator/tools/embed_index.py`

```python
import os
import json
from pathlib import Path
from typing import List, Dict
from dotenv import load_dotenv
import yaml
from tqdm import tqdm

load_dotenv()

EMBED_MODEL = os.getenv("EMBED_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
EMBED_DIM   = int(os.getenv("EMBED_DIM", "384"))
BACKEND     = os.getenv("VECTOR_BACKEND", "elasticsearch")

# Embeddings (local by default)
from sentence_transformers import SentenceTransformer
_model = None
def embed_texts(texts: List[str]) -> List[List[float]]:
    global _model
    if _model is None:
        _model = SentenceTransformer(EMBED_MODEL)
    vecs = _model.encode(texts, normalize_embeddings=True, show_progress_bar=False)
    return [v.tolist() for v in vecs]

def iter_chunks(chunk_dir: Path):
    for f in chunk_dir.glob("**/*.jsonl"):
        with f.open("r", encoding="utf-8") as rf:
            for line in rf:
                rec = json.loads(line)
                yield rec

# --- Elasticsearch backend ---
def es_client():
    from elasticsearch import Elasticsearch
    host = os.getenv("ES_HOST")
    api_key = os.getenv("ES_API_KEY")
    if api_key:
        client = Elasticsearch(hosts=[host], api_key=api_key, verify_certs=True)
    else:
        user = os.getenv("ES_USER")
        pw   = os.getenv("ES_PASS")
        client = Elasticsearch(hosts=[host], basic_auth=(user, pw), verify_certs=True)
    return client

def es_ensure_index(client, index: str, dim: int):
    mapping = {
        "mappings": {
            "properties": {
                "doc_id": {"type": "keyword"},
                "chunk_id": {"type": "integer"},
                "text": {"type": "text"},
                "content_vector": {
                    "type": "dense_vector",
                    "dims": dim,
                    "index": True,
                    "similarity": "cosine"
                }
            }
        }
    }
    if not client.indices.exists(index=index):
        client.indices.create(index=index, **mapping)

def index_to_elasticsearch(cfg):
    from elasticsearch.helpers import bulk
    client = es_client()
    index = os.getenv("ES_INDEX", "rag_corpus")
    es_ensure_index(client, index, EMBED_DIM)

    chunk_dir = Path(cfg["chunk_dir"])
    batch_docs = []
    BATCH = 256

    for rec in tqdm(iter_chunks(chunk_dir), desc="Indexing to ES"):
        vec = embed_texts([rec["text"]])[0]
        doc = {
            "_index": index,
            "_source": {
                "doc_id": rec["doc_id"],
                "chunk_id": rec["chunk_id"],
                "text": rec["text"],
                "content_vector": vec
            }
        }
        batch_docs.append(doc)
        if len(batch_docs) >= BATCH:
            bulk(client, batch_docs)
            batch_docs.clear()
    if batch_docs:
        bulk(client, batch_docs)
    print("ES indexing done.")

# --- Chroma backend ---
def index_to_chroma(cfg):
    import chromadb
    from chromadb.config import Settings

    client = chromadb.Client(Settings(
       is_persistent=True,
       persist_directory=os.getenv("CHROMA_DIR", "./index/chroma")
    ))
    coll = client.get_or_create_collection(name="rag_corpus")  # cosine by default

    ids, texts, metas, vecs = [], [], [], []
    for rec in tqdm(iter_chunks(Path(cfg["chunk_dir"])), desc="Indexing to Chroma"):
        ids.append(f"{rec['doc_id']}#{rec['chunk_id']}")
        texts.append(rec["text"])
        metas.append({"doc_id": rec["doc_id"], "chunk_id": rec["chunk_id"]})
        if len(texts) >= 128:
            embs = embed_texts(texts)
            coll.add(ids=ids, documents=texts, embeddings=embs, metadatas=metas)
            ids, texts, metas = [], [], []
    if texts:
        embs = embed_texts(texts)
        coll.add(ids=ids, documents=texts, embeddings=embs, metadatas=metas)
    print("Chroma indexing done.")

def main():
    cfg = yaml.safe_load(Path("config.yaml").read_text())
    if BACKEND == "elasticsearch":
        index_to_elasticsearch(cfg)
    else:
        index_to_chroma(cfg)

if __name__ == "__main__":
    main()
```

Run:

```bash
# after extract & chunk
python tools/embed_index.py
```

---

## Step 4 — Retrieval & Answering (RAG pipeline)

### Prompt template

`accelerator/rag/prompt.py`

```python
from textwrap import dedent

SYSTEM = dedent(\"\"\"\
You are a careful assistant. Use ONLY the provided context to answer.
If the answer is not in the context, say “I don't know based on the provided documents.”
Always include a brief bullet list of the sources (doc_id#chunk_id).
\"\"\")

USER_TEMPLATE = dedent(\"\"\"\
Question:
{question}

Context:
{context}

Requirements:
- Be concise (80–150 words).
- Cite sources as [doc_id#chunk_id] inline where used.
\"\"\")
```

### Unified retriever (ES or Chroma)

`accelerator/rag/retriever.py`

```python
import os
from typing import List, Tuple, Dict
from dotenv import load_dotenv
load_dotenv()

BACKEND = os.getenv("VECTOR_BACKEND", "elasticsearch")
TOP_K = int(os.getenv("TOP_K", "5"))

from sentence_transformers import SentenceTransformer
_model = None
def embed_query(q: str):
    global _model
    em = os.getenv("EMBED_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
    if _model is None:
        _model = SentenceTransformer(em)
    v = _model.encode([q], normalize_embeddings=True)[0].tolist()
    return v

def search_elasticsearch(query: str) -> List[Dict]:
    from elasticsearch import Elasticsearch
    host = os.getenv("ES_HOST")
    index = os.getenv("ES_INDEX", "rag_corpus")
    api_key = os.getenv("ES_API_KEY")
    if api_key:
        es = Elasticsearch(hosts=[host], api_key=api_key, verify_certs=True)
    else:
        es = Elasticsearch(hosts=[host], basic_auth=(os.getenv("ES_USER"), os.getenv("ES_PASS")), verify_certs=True)
    qvec = embed_query(query)
    body = {
        "knn": {
            "field": "content_vector",
            "query_vector": qvec,
            "k": TOP_K,
            "num_candidates": 50
        },
        "_source": ["doc_id", "chunk_id", "text"]
    }
    res = es.search(index=index, knn=body["knn"], _source=body["_source"])
    hits = res["hits"]["hits"]
    out = [{"doc_id": h["_source"]["doc_id"], "chunk_id": h["_source"]["chunk_id"], "text": h["_source"]["text"], "score": h["_score"]} for h in hits]
    return out

def search_chroma(query: str) -> List[Dict]:
    import chromadb
    from chromadb.config import Settings
    client = chromadb.Client(Settings(
        is_persistent=True,
        persist_directory=os.getenv("CHROMA_DIR", "./index/chroma")
    ))
    coll = client.get_or_create_collection("rag_corpus")
    qvec = embed_query(query)
    res = coll.query(query_embeddings=[qvec], n_results=TOP_K, include=["documents", "metadatas", "distances"])
    docs  = res["documents"][0]
    metas = res["metadatas"][0]
    dists = res["distances"][0]
    out = []
    for doc, meta, dist in zip(docs, metas, dists):
        out.append({"doc_id": meta["doc_id"], "chunk_id": meta["chunk_id"], "text": doc, "score": 1.0 - dist})
    return out

def retrieve(query: str) -> List[Dict]:
    if BACKEND == "elasticsearch":
        return search_elasticsearch(query)
    return search_chroma(query)
```

### The RAG pipeline and LLM call (watsonx.ai)

`accelerator/rag/pipeline.py`

```python
import os
from typing import List, Dict
from dotenv import load_dotenv
from .retriever import retrieve
from .prompt import SYSTEM, USER_TEMPLATE

load_dotenv()

# watsonx.ai Granite via SDK
from ibm_watsonx_ai.foundation_models import Model
from ibm_watsonx_ai import Credentials

def build_context(chunks: List[Dict]) -> str:
    lines = []
    for ch in chunks:
        tag = f"[{ch['doc_id']}#{ch['chunk_id']}]"
        lines.append(f"{tag} {ch['text']}")
    return "\\n\\n".join(lines)

def answer_question(question: str) -> Dict:
    chunks = retrieve(question)
    context = build_context(chunks)

    creds = Credentials(
        api_key=os.getenv("WATSONX_API_KEY"),
        url=os.getenv("WATSONX_URL")
    )
    model_id = os.getenv("WATSONX_MODEL", "ibm/granite-13b-instruct-v2")
    project_id = os.getenv("WATSONX_PROJECT_ID")

    # generation settings (feel free to tweak)
    gen_params = dict(
        temperature=0.2,
        max_new_tokens=300,
        repetition_penalty=1.05
    )

    model = Model(
        model_id=model_id,
        credentials=creds,
        project_id=project_id,
        params=gen_params
    )

    user = USER_TEMPLATE.format(question=question, context=context)
    prompt = f"<s>[SYSTEM]\\n{SYSTEM}\\n[/SYSTEM]\\n[USER]\\n{user}\\n[/USER]\\n[ASSISTANT]"

    resp = model.generate_text(prompt=prompt)
    text = resp.get("results", [{}])[0].get("generated_text", "").strip()

    return {
        "question": question,
        "answer": text,
        "chunks": chunks
    }
```

---

## Step 5 — API service (FastAPI)

`accelerator/service/deps.py`

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    top_k: int = 5
    class Config:
        env_prefix = ""
        env_file = ".env"
        extra = "ignore"

settings = Settings()
```

`accelerator/service/api.py`

```python
from fastapi import FastAPI
from pydantic import BaseModel
from rag.pipeline import answer_question

app = FastAPI(title="RAG Accelerator API")

class AskReq(BaseModel):
    question: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/ask")
def ask(req: AskReq):
    out = answer_question(req.question)
    # keep only essentials for the UI
    return {
        "answer": out["answer"],
        "citations": [
            {"doc_id": c["doc_id"], "chunk_id": c["chunk_id"], "score": c["score"]}
            for c in out["chunks"]
        ]
    }
```

Run API:

```bash
uvicorn service.api:app --reload --port 8001
# GET http://localhost:8001/health
# POST http://localhost:8001/ask {"question": "What is the main purpose of the platform?"}
```

---

## Step 6 — Chat UI (Streamlit)

`accelerator/ui/app.py`

```python
import streamlit as st
import requests

API = "http://localhost:8001/ask"

st.set_page_config(page_title="RAG Accelerator", layout="wide")
st.title("🔎 RAG Accelerator — Q&A")

if "chat" not in st.session_state:
    st.session_state.chat = []

q = st.chat_input("Ask a question about the corpus…")
if q:
    st.session_state.chat.append(("user", q))
    try:
        r = requests.post(API, json={"question": q}, timeout=60)
        r.raise_for_status()
        data = r.json()
        st.session_state.chat.append(("assistant", data["answer"], data.get("citations", [])))
    except Exception as e:
        st.session_state.chat.append(("assistant", f"Error: {e}", []))

for role, msg, *rest in st.session_state.chat:
    with st.chat_message("user" if role == "user" else "assistant"):
        st.markdown(msg)
        if role != "user" and rest:
            citations = rest[0] or []
            if citations:
                st.caption("Sources:")
                for c in citations:
                    st.code(f"{c['doc_id']}#{c['chunk_id']} (score={c['score']:.3f})")
```

Run UI:

```bash
streamlit run ui/app.py
# open http://localhost:8501
```

---

## (Optional) Tiny quality check

`accelerator/tools/eval_small.py`

```python
from rag.retriever import retrieve

QUERIES = [
    "Summarize the core value proposition.",
    "List the supported components mentioned.",
    "How do I get started?"
]

for q in QUERIES:
    hits = retrieve(q)
    print("Q:", q)
    for i, h in enumerate(hits, 1):
        print(f"  {i:>2}. {h['doc_id']}#{h['chunk_id']} score={h['score']:.3f}")
    print()
```

Run:

```bash
python tools/eval_small.py
```

---

## Makefile (quality of life)

`accelerator/Makefile`

```make
VENV=.venv
PY=$(VENV)/bin/python
PIP=$(VENV)/bin/pip

.PHONY: venv install extract chunk index api ui all clean

venv:
	python -m venv $(VENV)

install: venv
	$(PIP) install -U pip
	$(PIP) install -e .

extract:
	$(PY) tools/extract.py --config config.yaml

chunk:
	$(PY) tools/chunk.py --config config.yaml

index:
	$(PY) tools/embed_index.py

api:
	$(VENV)/bin/uvicorn service.api:app --reload --port 8001

ui:
	$(VENV)/bin/streamlit run ui/app.py

all: extract chunk index
	@echo "✅ Pipeline ready. Now run: make api  (and in another terminal) make ui"

clean:
	rm -rf data/clean data/chunks index/chroma
```

---

## Screenshots (add after you run)

Create the folder and drop PNGs you capture:

```
docs/images/rag-accelerator/
├─ pipeline-arch.png              # architecture (UI capture or export mermaid from docs)
├─ streamlit-chat.png             # chat run with citations inline
└─ es-kibana-hit.png              # optional: ES hit list (Dev Tools) or vector preview
```

In your markdown pages (or here for reference), include:

```markdown
![Chat UI](../../images/rag-accelerator/streamlit-chat.png)
```

---

## Troubleshooting

* **No results / low scores**  
  Increase `retrieval.top_k` in `config.yaml` or reduce `chunking.target_chars` to make chunks smaller. Ensure your corpus isn’t empty and extraction succeeded.
* **Indexing fails on ES**  
  Check `ES_INDEX`, `ES_HOST`, and credentials. Verify mapping was created (dense_vector dims must match `EMBED_DIM`).
* **Long or off-topic answers**  
  Lower `temperature` to 0.1–0.2; tighten the prompt; reduce `max_new_tokens`.
* **Slow first request**  
  SentenceTransformer loads model on first embed; warm up with a dummy query.

---

## What you can iterate next

* Swap in **rerankers** (e.g., `rank_bm25` + cross-encoder re-rank for top-20 → top-k).
* Add **source quoting** (inline quotes from top passages).
* Persist **feedback** & thumbs-up/down to refine chunking or prompts.
* Add **auth** and **rate limiting** to the API.

---

## Lab checklist

* [ ] `.env` configured (watsonx + vector backend)
* [ ] `corpus/` contains at least 10 docs (PDF/HTML)
* [ ] `make all` ran (extract → chunk → index)
* [ ] `make api` up at `:8001/health`
* [ ] `make ui` chat answers with citations

---

### Appendix: Switching to Elasticsearch later

If you started with Chroma and now have Elasticsearch:

1. Edit `.env`:

   ```
   VECTOR_BACKEND=elasticsearch
   ES_HOST=https://localhost:9200
   ES_API_KEY=...
   ES_INDEX=rag_corpus
   ```
2. Re-index:

   ```bash
   make index
   ```
3. No other code changes needed—`retriever.py` switches automatically.

---

**You’re done!** This accelerator is your baseline. In **Lab 2**, you’ll deep-dive into ES + LangChain / ES Python SDK / Chroma + LangChain variants, and in **Lab 3** you’ll package + evaluate with watsonx.governance Evaluation Studio.
