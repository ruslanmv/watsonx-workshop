# Lab 2A — Use watsonx, Elasticsearch & LangChain for RAG

**Goal:** Build a retrieval-augmented generation (RAG) app that ingests a small corpus into Elasticsearch, retrieves the most relevant chunks, and asks a watsonx.ai model to answer with citations.

**You’ll learn:**

* How to prepare and chunk documents
* How to store embeddings in Elasticsearch (ES) via LangChain
* How to query with a Retriever and answer with a watsonx.ai LLM
* How to run hybrid/bm25+vector retrieval and add simple evaluation hooks

---

## 0) Prereqs

* An **IBM Cloud** account with **watsonx.ai** access, project created (note the **Project ID**).
* An **Elasticsearch** cluster (Elastic Cloud, or self-hosted 8.x+).
* Python 3.10+ (recommended 3.11).

### Create & activate a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate   # (Windows) .venv\Scripts\activate
python -m pip install --upgrade pip
```

### Install dependencies

```bash
pip install   ibm-watsonx-ai   langchain langchain-community langchain-ibm   elasticsearch==8.*   tiktoken pydantic python-dotenv   pypdf unstructured[all-docs] beautifulsoup4 lxml   pandas numpy
```

> If you plan to render SVG/OpenGraph images with mkdocs-material’s **social** plugin later, also install:  
> `pip install "mkdocs-material[imaging]"`

---

## 1) Environment configuration

Create `es.env.sample` at your repo root:

```ini
# ---- watsonx.ai ----
WATSONX_API_KEY=YOUR_WATSONX_API_KEY
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_PROJECT_ID=YOUR_WATSONX_PROJECT_ID

# Choose a model you have access to in your project
# Example chat LLMs: "ibm/granite-13b-instruct-v2", "meta-llama/llama-3-70b-instruct"
WX_LLM_MODEL_ID=ibm/granite-13b-instruct-v2

# Example embeddings models vary; set to one you have:
# e.g., "ibm/granite-embedding-278m" or another available embedding model
WX_EMBEDDINGS_MODEL_ID=ibm/granite-embedding-278m

# ---- Elasticsearch (choose ONE option) ----

# Option A: Elastic Cloud
ES_CLOUD_ID=YOUR_ELASTIC_CLOUD_ID
ES_API_KEY=YOUR_ELASTIC_API_KEY

# Option B: Self-hosted
# ES_HOST=https://localhost:9200
# ES_USERNAME=elastic
# ES_PASSWORD=YOUR_PASSWORD
# ES_CA_CERT=./http_ca.crt     # optional, if using TLS with a custom CA
```

> Copy to `.env` and fill in values:
>
> ```bash
> cp es.env.sample .env
> ```

---

## 2) Small example corpus

Create a tiny corpus in `data/corpus/`—you can reuse the same files from **Lab 1** or create these now:

```
data/corpus/
├─ faq_watsonx.md
├─ granite_overview.md
└─ governance_intro.pdf     # optional PDF
```

Example content for `data/corpus/faq_watsonx.md`:

```md
# watsonx FAQ
watsonx.ai provides access to foundation models and tools for prompt engineering, tuning, and evaluation.
Prompts and deployments can be managed as reusable assets. Projects govern access and lineage.
```

Example content for `data/corpus/granite_overview.md`:

```md
# Granite Overview
IBM Granite is a family of open and proprietary language models for enterprise use.
Granite models are optimized for reasoning, instruction following, and enterprise safety.
```

(If you don’t have a PDF, just skip it.)

---

## 3) Indexing with LangChain → Elasticsearch

Create `rag_index_langchain.py` (or run cells interactively).

```python
import os
from dotenv import load_dotenv

load_dotenv()  # loads .env

# --- watsonx creds ---
WATSONX_URL = os.getenv("WATSONX_URL")
WATSONX_API_KEY = os.getenv("WATSONX_API_KEY")
WATSONX_PROJECT_ID = os.getenv("WATSONX_PROJECT_ID")
WX_EMBEDDINGS_MODEL_ID = os.getenv("WX_EMBEDDINGS_MODEL_ID", "ibm/granite-embedding-278m")

# --- ES creds ---
ES_CLOUD_ID = os.getenv("ES_CLOUD_ID")
ES_API_KEY = os.getenv("ES_API_KEY")

ES_HOST = os.getenv("ES_HOST")        # for self-hosted
ES_USERNAME = os.getenv("ES_USERNAME")
ES_PASSWORD = os.getenv("ES_PASSWORD")
ES_CA_CERT = os.getenv("ES_CA_CERT")

# ---- LangChain imports ----
from langchain_community.document_loaders import DirectoryLoader, TextLoader, PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import ElasticsearchStore
from langchain_ibm import WatsonxEmbeddings

# 1) Load docs
docs_dir = "data/corpus"

# Support .md, .txt
text_loader = DirectoryLoader(
    docs_dir,
    glob="**/*.md",
    loader_cls=TextLoader,
    show_progress=True
)

docs = text_loader.load()

# Optional: load PDFs if you have them
try:
    pdf_loader = DirectoryLoader(
        docs_dir,
        glob="**/*.pdf",
        loader_cls=PyPDFLoader,
        show_progress=True
    )
    docs.extend(pdf_loader.load())
except Exception as e:
    print("PDF load skipped:", e)

print(f"Loaded {len(docs)} docs")

# 2) Chunking
splitter = RecursiveCharacterTextSplitter(chunk_size=800, chunk_overlap=120)
splits = splitter.split_documents(docs)
print("Total chunks:", len(splits))

# 3) Embeddings (watsonx)
embeddings = WatsonxEmbeddings(
    model_id=WX_EMBEDDINGS_MODEL_ID,
    url=WATSONX_URL,
    api_key=WATSONX_API_KEY,
    project_id=WATSONX_PROJECT_ID,
)

# 4) ES client options (LangChain will create internal client)
es_kwargs = {}
if ES_CLOUD_ID and ES_API_KEY:
    es_kwargs.update(dict(
        cloud_id=ES_CLOUD_ID,
        api_key=ES_API_KEY
    ))
elif ES_HOST:
    es_kwargs.update(dict(
        es_url=ES_HOST,
        http_auth=(ES_USERNAME, ES_PASSWORD) if ES_USERNAME and ES_PASSWORD else None,
        ca_certs=ES_CA_CERT if ES_CA_CERT else None
    ))
else:
    raise RuntimeError("Please set Elastic Cloud ID/API key OR ES_HOST credentials.")

index_name = "rag_workshop_langchain"

# 5) Write to Elasticsearch
vectorstore = ElasticsearchStore.from_documents(
    documents=splits,
    embedding=embeddings,
    index_name=index_name,
    strategy=ElasticsearchStore.ApproxRetrievalStrategy()  # use ANN (KNN)
    # For exact: use ElasticsearchStore.BM25RetrievalStrategy() or combine hybrid (below)
)

print(f"Indexed into: {index_name}")
```

### (Optional) Hybrid retrieval (BM25 + vector)

```python
# Create hybrid store (re-using the same index or a new one)
hybrid_index = "rag_workshop_hybrid"

hybrid_store = ElasticsearchStore.from_documents(
    documents=splits,
    embedding=embeddings,
    index_name=hybrid_index,
    strategy=ElasticsearchStore.HybridRetrievalStrategy()  # BM25 + vector
)
print(f"Indexed into hybrid: {hybrid_index}")
```

---

## 4) Ask questions with a watsonx.ai LLM

```python
import os
from langchain.chains import RetrievalQA
from langchain_ibm import WatsonxLLM

WATSONX_URL = os.getenv("WATSONX_URL")
WATSONX_API_KEY = os.getenv("WATSONX_API_KEY")
WATSONX_PROJECT_ID = os.getenv("WATSONX_PROJECT_ID")
WX_LLM_MODEL_ID = os.getenv("WX_LLM_MODEL_ID", "ibm/granite-13b-instruct-v2")

# Re-create vectorstore pointing at existing index:
retrieval_store = ElasticsearchStore(
    embedding=embeddings,
    index_name=index_name,
    **es_kwargs
)

retriever = retrieval_store.as_retriever(search_kwargs={"k": 5})

llm = WatsonxLLM(
    model_id=WX_LLM_MODEL_ID,
    url=WATSONX_URL,
    api_key=WATSONX_API_KEY,
    project_id=WATSONX_PROJECT_ID,
    params={  # sampling params
        "decoding_method": "greedy",
        "max_new_tokens": 300,
        "repetition_penalty": 1.05
    }
)

qa = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=retriever,
    chain_type="stuff",  # or "map_reduce" if answers are long
    return_source_documents=True
)

question = "What is IBM Granite, and what is it optimized for?"
result = qa({"query": question})

print("Q:", question)
print("A:", result["result"])
print("\nSources:")
for i, d in enumerate(result["source_documents"], 1):
    print(f"{i}. {d.metadata.get('source')}")
```

**Tip:** Switch to the **hybrid** index for better lexical recall:

```python
hybrid_retriever = ElasticsearchStore(
    embedding=embeddings,
    index_name=hybrid_index,
    **es_kwargs
).as_retriever(search_kwargs={"k": 5})

qa_hybrid = RetrievalQA.from_chain_type(llm=llm, retriever=hybrid_retriever, return_source_documents=True)
print(qa_hybrid({"query": "What are prompt templates in watsonx.ai?"})["result"])
```

---

## 5) Quick quality checks

Add a few sanity checks before you proceed to packaging:

```python
tests = [
    "What is watsonx.ai used for?",
    "Summarize Granite in 2 sentences.",
    "Does the corpus mention evaluation or governance?"
]
for t in tests:
    ans = qa({"query": t})
    print("-" * 80)
    print("Q:", t)
    print("A:", ans["result"])
    print("Citations:", [d.metadata.get("source") for d in ans["source_documents"]])
```

If you see hallucinations (no relevant sources), prefer **hybrid** retrieval or increase `k`, tweak chunk sizes, or add a reranker stage later.

---

## 6) Common issues & fixes

* **401/403 from watsonx.ai** → Verify `WATSONX_API_KEY`, `WATSONX_PROJECT_ID`, and that your model IDs are available to the project.
* **Elasticsearch SSL** → If self-hosted with TLS, pass `ES_CA_CERT` and use `https://` host.
* **Dimension mismatch** → If ES mapping enforces dims, ensure your index was created by the vectorstore (it will set dims from the first embedding). If you pre-created the index, confirm `dims` equals length of `embeddings.embed_query("test")`.

---

## 7) Cleanup (optional)

```python
# delete indices when done experimenting
from elasticsearch import Elasticsearch

if ES_CLOUD_ID and ES_API_KEY:
    es = Elasticsearch(cloud_id=ES_CLOUD_ID, api_key=ES_API_KEY)
else:
    es = Elasticsearch(ES_HOST, basic_auth=(ES_USERNAME, ES_PASSWORD), ca_certs=ES_CA_CERT)

for idx in [index_name, hybrid_index]:
    try:
        es.indices.delete(index=idx, ignore_unavailable=True)
        print("Deleted:", idx)
    except Exception as e:
        print("Delete failed:", idx, e)
```

---

**You have a working RAG pipeline using watsonx.ai + Elasticsearch + LangChain.**
In **Lab 2B**, you’ll rebuild this with the raw Elasticsearch Python SDK for more control.
