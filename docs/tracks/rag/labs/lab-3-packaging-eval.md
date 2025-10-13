# Lab 3 — Grounded Q&A Agent, Packaging & Evaluation

**Track:** RAG → Lab 3  
**Why:** Turn your Lab 2 prototype into a small, reusable *app/CLI*, then evaluate multiple model runs in **watsonx.governance – Evaluation Studio** to pick the best configuration.

**What you’ll build:**
- Grounded Q&A agent (Elasticsearch or Chroma backend) + watsonx.ai LLM
- Simple CLI and optional FastAPI service
- Evaluation Studio experiment to compare models/params

---

## 0) Prerequisites

- IBM Cloud account with **watsonx.ai / WML** and a **Project**
- A vector index from **Lab 2** (ES or Chroma)
- Python 3.11+

---

## 1) App structure

```
rag-app/
  app/
    __init__.py
    chain.py
    settings.py
    elastic_backend.py
    chroma_backend.py
  cli/
    rag_cli.py
  api/
    server.py
  .env.sample
  es.env.sample
  requirements.txt
  Dockerfile
```

---

## 2) Sample configs

### `.env.sample`

```bash
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_APIKEY=__YOUR_IBM_CLOUD_API_KEY__
WATSONX_PROJECT_ID=__YOUR_WX_PROJECT_ID__

LLM_MODEL_ID=ibm/granite-3-3-8b-instruct
LLM_TEMPERATURE=0.2
LLM_MAX_NEW_TOKENS=128

RAG_BACKEND=elastic
CHROMA_DIR=.chroma
EMBEDDINGS_MODEL=sentence-transformers/all-MiniLM-L6-v2
```

### `es.env.sample`

```bash
ES_CLOUD_ID=__ELASTIC_CLOUD_ID__
ES_API_KEY=__ES_API_KEY__

ES_HOST=https://localhost:9200
ES_USERNAME=elastic
ES_PASSWORD=changeme

ES_INDEX=elastic_index_2024_11_05_114707
ES_VECTOR_DIMS=384
```

---

## 3) Backends

Create `app/elastic_backend.py` and `app/chroma_backend.py` (see project files) to build retrievers for ES or Chroma. Use `app/settings.py` to read envs.

---

## 4) Chain + CLI/API

- `app/chain.py` wires retriever + `WatsonxLLM` into a `RetrievalQA` chain.  
- `cli/rag_cli.py` exposes a command-line interface.  
- `api/server.py` provides a simple FastAPI `/ask` endpoint.

Run locally:

```bash
# CLI (elastic)
export RAG_BACKEND=elastic
python -m cli.rag_cli "What is Retrieval Augmented Generation?" --show-sources

# API
uvicorn api.server:app --reload --port 8001
```

---

## 5) Evaluation Studio (watsonx.governance)

Use the separate `eval/run_experiments.py` or a notebook to:
- Create an Experiment
- Start runs for different `model_id`/params
- Invoke your chain on a small dataset
- Log predictions/references and compare in the UI
