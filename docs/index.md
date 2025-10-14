# watsonx Workshop Series

<p align="center">
  <a href="https://www.ibm.com/products/watsonx-ai" target="_blank"><img src="https://img.shields.io/badge/built%20for-watsonx.ai-0b62a3?logo=ibm&logoColor=white" alt="watsonx.ai"></a>
  <a href="https://www.python.org" target="_blank"><img src="https://img.shields.io/badge/python-3.11+-3776AB?logo=python&logoColor=white" alt="Python 3.11+"></a>
  <a href="https://www.docker.com/" target="_blank"><img src="https://img.shields.io/badge/docker-ready-2496ED?logo=docker&logoColor=white" alt="Docker Ready"></a>
  <a href="https://squidfunk.github.io/mkdocs-material/" target="_blank"><img src="https://img.shields.io/badge/docs-MkDocs%20Material-000000?logo=markdown" alt="MkDocs Material"></a>
</p>
<div align="center">
  <a href="https://www.python.org" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="Python" width="54" height="54"/></a>
  <a href="https://www.docker.com/" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="Docker" width="64" height="64"/></a>
  <a href="https://jupyter.org/" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/jupyter/jupyter-original-wordmark.svg" alt="Jupyter" width="64" height="64"/></a>
</div>

---

## Welcome

The **watsonx Workshop Series** is a hands-on collection of tracks that teach you how to build with IBM watsonx:

* **Granite** — model capabilities, prompting, local runs, and the watsonx.ai SDK
* **RAG** — retrieval-augmented generation from zero to production packaging
* **Agents** — governed, tool-using agents and evaluation workflows
* **Orchestrate** — end-to-end applied lab tying concepts together

> **Note:** This bundle is 100% **Markdown-first**. Notebooks are included only as references under `labs-src/` so that `mkdocs build --strict` passes cleanly.

---

## Quick Start

=== "Browse the Docs"

    1.  Use the left sidebar to select a **Track**.
    2.  Each track is organized as a sequence of **Labs** with copy-paste runnable code blocks.
    3.  Start with **Granite** if you’re new to watsonx, or jump straight to **RAG**.

=== "Run the RAG App Locally"

    ```bash
    # Lab 1 (Accelerator) — minimal local run
    cd accelerator
    python -m venv .venv
    source .venv/bin/activate         # Windows: .venv\Scripts\activate
    pip install -U pip && pip install -e .
    cp .env.sample .env               # fill in watsonx + vector backend settings
    make all                          # extract → chunk → index
    make api                          # FastAPI at http://localhost:8001/health
    # in a second terminal:
    make ui                           # Streamlit UI at http://localhost:8501
    ```

---

## Choose a Track

<div class="grid cards" markdown="1">
* :material-fire: **Granite**

    ^^^

    Explore Granite model families, prompting patterns, local HF/Ollama, and watsonx.ai SDK. <br><br>

    [:octicons-arrow-right-16: Open »](tracks/granite/labs/pre-work.md){ .md-button .md-button--primary }

* :material-magnify-expand: **RAG**

    ^^^

    Build a grounded Q&A app: ingest → chunk → embed → **Elasticsearch/Chroma** → LLM on **watsonx.ai**.
    Package a CLI/API and compare runs in **Evaluation Studio**. <br><br>

    [:octicons-arrow-right-16: Open »](tracks/rag/labs/pre-work.md){ .md-button .md-button--primary }

* :material-robot-outline: **Agents**

    ^^^

    Tool-using, governed assistants with LangGraph and watsonx.governance; evaluate for quality and risk. <br><br>

    [:octicons-arrow-right-16: Open »](tracks/agents/labs/lab-2-hr-assistant-governed-catalog.md){ .md-button .md-button--primary }

* :material-cube-outline: **Orchestrate**

    ^^^

    A full applied workshop combining components into a cohesive solution. <br><br>

    [:octicons-arrow-right-16: Open »](tracks/orchestrate/orchestrate-workshop.md){ .md-button .md-button--primary }
</div>

---

## RAG Track at a Glance

* **Pre-work**: environment, credentials, and sample data
* **Lab 1**: end-to-end accelerator (HTML/PDF → vectors → API + Streamlit)
* **Lab 2** *(pick one or compare)*:
    * 2A: **Elasticsearch + LangChain**
    * 2B: **Elasticsearch Python SDK** (no LangChain)
    * 2C: **Chroma + LangChain** (local/dev)
* **Lab 3**: **Packaging & Evaluation** with watsonx.governance

```mermaid
flowchart TD
  %% Improved appearance with subgraphs, color classes, and clearer shapes
  %% Now vertical (top → bottom)

  %% Ingestion
  subgraph ING[Ingestion]
    direction TB
    A[Docs: HTML • PDF] --> B[Extractor & Cleaner]
    B --> C[Chunker]
  end

  %% Retrieval
  subgraph RET[Retrieval]
    direction TB
    C --> D[Embeddings]
    D -->|dense vectors| E[(Vector Store ES/Chroma)]
    E -->|top-k| F[Reranker optional]
  end

  %% Generation
  subgraph GEN[Generation]
    direction TB
    F --> G[Prompt Composer]
    G --> H[LLM on watsonx.ai]
    H --> I[Answer + Citations]
  end

  %% Serving
  subgraph SRV[Serving]
    direction TB
    I --> J[FastAPI /ask]
    J --> K[Streamlit Chat UI]
  end

  %% Style definitions
  classDef source fill:#E3F2FD,stroke:#1E88E5,color:#0D47A1,stroke-width:1px;
  classDef process fill:#F1F8E9,stroke:#7CB342,color:#2E7D32,stroke-width:1px;
  classDef store fill:#FFF3E0,stroke:#FB8C00,color:#E65100,stroke-width:1px;
  classDef model fill:#F3E5F5,stroke:#8E24AA,color:#4A148C,stroke-width:1px;
  classDef output fill:#E0F7FA,stroke:#00ACC1,color:#006064,stroke-width:1px;

  %% Class assignments
  class A source;
  class B,C,D,F,G,J,K process;
  class E store;
  class H model;
  class I output;

```

---

## What’s Included

* **Production-ready samples** (FastAPI + Streamlit, CLI, Dockerfiles)
* **Reproducible configs** (`.env.sample`, `requirements.txt` / `pyproject.toml`)
* **Evaluation workflows** with **Evaluation Studio** to compare models & parameters

!!! tip "Everything is Markdown"
Each lab is designed to be followed directly from the page. Copy-paste commands and code blocks; notebooks are optional references only.

---

## Next steps

[Next → Granite Pre-work](tracks/granite/labs/pre-work.md){ .md-button .md-button--primary }

[Resources](resources.md){ .md-button .md-button--primary }
