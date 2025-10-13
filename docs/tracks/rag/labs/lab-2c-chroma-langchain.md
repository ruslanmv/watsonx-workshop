# Lab 2C — Use watsonx, Chroma & LangChain for RAG

**Goal:** Build a Retrieval-Augmented Generation (RAG) workflow using **IBM watsonx.ai** for LLM + embeddings, **LangChain** for orchestration, and a **local Chroma** vector database for fast similarity search. You’ll ingest a small corpus, chunk → embed → index in Chroma, then answer questions with sources.

**What you’ll learn**
* Preparing & chunking content for RAG
* Creating a **persistent** Chroma vector store
* Using **watsonx.ai** LLM + Embeddings with LangChain
* Retrieval strategies (similarity, MMR) and optional **hybrid** (BM25 + vector)
* A tiny evaluation harness and practical troubleshooting

---

## 0) Prerequisites

* IBM Cloud account with **watsonx.ai** enabled and a **Project** created
* Python 3.10+ (3.11 recommended)

---

## 1) Environment setup

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install   ibm-watsonx-ai   langchain langchain-community langchain-ibm   chromadb>=0.5.3   pypdf unstructured[all-docs] beautifulsoup4 lxml   python-dotenv tiktoken numpy pandas
```

Create `.env`:

```ini
WATSONX_API_KEY=YOUR_WATSONX_API_KEY
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_PROJECT_ID=YOUR_WATSONX_PROJECT_ID
WX_LLM_MODEL_ID=ibm/granite-13b-instruct-v2
WX_EMBEDDINGS_MODEL_ID=ibm/granite-embedding-278m
CHROMA_PERSIST_DIR=.chroma_store
CHROMA_COLLECTION=rag_workshop_chroma
```

---

## 2) Helper utils (save as `rag_chroma_utils.py`)

```python
import os
from typing import List, Optional
from dotenv import load_dotenv
from langchain_community.document_loaders import DirectoryLoader, TextLoader, PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_community.retrievers import BM25Retriever
from langchain.retrievers import EnsembleRetriever
from langchain_ibm import WatsonxEmbeddings, WatsonxLLM

load_dotenv()

WATSONX_URL = os.getenv("WATSONX_URL")
WATSONX_API_KEY = os.getenv("WATSONX_API_KEY")
WATSONX_PROJECT_ID = os.getenv("WATSONX_PROJECT_ID")
WX_LLM_MODEL_ID = os.getenv("WX_LLM_MODEL_ID", "ibm/granite-13b-instruct-v2")
WX_EMBEDDINGS_MODEL_ID = os.getenv("WX_EMBEDDINGS_MODEL_ID", "ibm/granite-embedding-278m")
CHROMA_PERSIST_DIR = os.getenv("CHROMA_PERSIST_DIR", ".chroma_store")
CHROMA_COLLECTION = os.getenv("CHROMA_COLLECTION", "rag_workshop_chroma")

def load_docs(corpus_dir="data/corpus"):
    docs = []
    tloader = DirectoryLoader(corpus_dir, glob="**/*.md", loader_cls=TextLoader, show_progress=True)
    docs.extend(tloader.load())
    try:
        pdf_loader = DirectoryLoader(corpus_dir, glob="**/*.pdf", loader_cls=PyPDFLoader, show_progress=True)
        docs.extend(pdf_loader.load())
    except Exception:
        pass
    return docs

def chunk_docs(docs, chunk_size=800, chunk_overlap=120):
    splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    return splitter.split_documents(docs)

def build_embeddings():
    return WatsonxEmbeddings(
        model_id=WX_EMBEDDINGS_MODEL_ID,
        url=WATSONX_URL,
        api_key=WATSONX_API_KEY,
        project_id=WATSONX_PROJECT_ID,
    )

def build_or_load_chroma(splits: Optional[list]=None, embeddings=None, reset=False):
    import shutil, os
    if reset and os.path.isdir(CHROMA_PERSIST_DIR):
        shutil.rmtree(CHROMA_PERSIST_DIR, ignore_errors=True)

    if splits is None:
        return Chroma(collection_name=CHROMA_COLLECTION, persist_directory=CHROMA_PERSIST_DIR,
                      embedding_function=embeddings or build_embeddings())

    vectordb = Chroma.from_documents(
        documents=splits,
        embedding=embeddings or build_embeddings(),
        collection_name=CHROMA_COLLECTION,
        persist_directory=CHROMA_PERSIST_DIR,
    )
    vectordb.persist()
    return vectordb

def build_llm():
    return WatsonxLLM(
        model_id=WX_LLM_MODEL_ID,
        url=WATSONX_URL,
        api_key=WATSONX_API_KEY,
        project_id=WATSONX_PROJECT_ID,
        params={"decoding_method": "greedy", "max_new_tokens": 350, "repetition_penalty": 1.05}
    )

def chroma_retriever(vectordb, k=5, search_type="similarity"):
    if search_type == "mmr":
        return vectordb.as_retriever(search_type="mmr", search_kwargs={"k": k, "fetch_k": 20, "lambda_mult": 0.5})
    return vectordb.as_retriever(search_kwargs={"k": k})

def hybrid_ensemble_retriever(vectordb, docs_for_bm25, k=5, alpha=0.5):
    bm25 = BM25Retriever.from_documents(docs_for_bm25); bm25.k = k
    vec = chroma_retriever(vectordb, k=k, search_type="similarity")
    return EnsembleRetriever(retrievers=[bm25, vec], weights=[alpha, 1.0 - alpha])
```

---

## 3) Index

```python
from rag_chroma_utils import load_docs, chunk_docs, build_embeddings, build_or_load_chroma

docs = load_docs("data/corpus")
splits = chunk_docs(docs, 800, 120)
emb = build_embeddings()
vectordb = build_or_load_chroma(splits=splits, embeddings=emb, reset=True)
print("Chroma collection ready.")
```

---

## 4) QA

```python
from rag_chroma_utils import build_llm, build_or_load_chroma, chroma_retriever
from langchain.chains import RetrievalQA

vectordb = build_or_load_chroma()
retriever = chroma_retriever(vectordb, k=5, search_type="similarity")
llm = build_llm()

qa = RetrievalQA.from_chain_type(llm=llm, retriever=retriever, chain_type="stuff", return_source_documents=True)

print(qa({"query": "What is IBM Granite?"})["result"])
```

---

## 5) Hybrid (optional)

```python
from rag_chroma_utils import load_docs, build_llm, build_or_load_chroma, hybrid_ensemble_retriever
from langchain.chains import RetrievalQA

raw_docs = load_docs("data/corpus")
vectordb = build_or_load_chroma()
retriever = hybrid_ensemble_retriever(vectordb, raw_docs, k=5, alpha=0.5)
llm = build_llm()
qa = RetrievalQA.from_chain_type(llm=llm, retriever=retriever, return_source_documents=True)
print(qa({"query": "Describe watsonx projects and prompt template assets."})["result"])
```

---

## 6) Eval mini-harness

```python
from rag_chroma_utils import build_llm, build_or_load_chroma, chroma_retriever
from langchain.chains import RetrievalQA

evalset = [
    ("What is watsonx.ai used for?", ["faq_watsonx.md"]),
    ("Summarize Granite in one sentence.", ["granite_overview.md"]),
]

vectordb = build_or_load_chroma()
qa = RetrievalQA.from_chain_type(llm=build_llm(), retriever=chroma_retriever(vectordb, 5), return_source_documents=True)

ok = 0
for q, expected in evalset:
    out = qa({"query": q})
    cites = [d.metadata.get("source") or "" for d in out["source_documents"]]
    hit = any(any(e in c for c in cites) for e in expected)
    ok += int(hit)
    print("Q:", q, "hit:", hit, "cites:", cites)

print(f"Pass rate: {ok}/{len(evalset)}")
```
