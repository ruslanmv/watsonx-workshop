# watsonx Workshop Series

<p align="center">
  <a href="https://www.ibm.com/products/watsonx-ai" target="_blank"><img src="https://img.shields.io/badge/built%20for-watsonx.ai-0b62a3?logo=ibm&logoColor=white" alt="watsonx.ai"></a>
  <a href="https://www.python.org" target="_blank"><img src="https://img.shields.io/badge/python-3.11%2B-3776AB?logo=python&logoColor=white" alt="Python 3.11+" /></a>
  <a href="https://squidfunk.github.io/mkdocs-material/" target="_blank"><img src="https://img.shields.io/badge/docs-MkDocs%20Material-000000?logo=markdown" alt="MkDocs Material" /></a>
</p>

<div align="center">
  <a href="https://www.python.org" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="Python" width="54" height="54"/></a>
  <a href="https://jupyter.org/" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/jupyter/jupyter-original-wordmark.svg" alt="Jupyter" width="64" height="64"/></a>
</div>

-----

## Purpose & Scope

**This repository is a practical, enterprise‑minded curriculum for IBM watsonx.** It focuses on the *essential knowledge and patterns* you need to design **stable, production‑ready solutions** for IBM clients operating at **high enterprise scale**.

We guide you along a clear path:

1.  **Granite** — learn the model families, prompting patterns, local runs, and the watsonx.ai SDK.
2.  **RAG** — build Retrieval‑Augmented Generation systems with clean ingestion, robust retrieval, and grounded answering.
3.  **Agents** — use LangGraph and **watsonx.governance** to build governed, tool‑using agents and evaluate them.
4.  **Orchestrate** — combine components into **multi‑agent** workflows for end‑to‑end business solutions.

Throughout, you’ll see **industry best practices**: configuration hygiene, reproducibility, observability hooks, evaluation workflows, and guidance for secure deployment.

> If you want additional background or updates from the author, visit **[ruslanmv.com](https://ruslanmv.com)**.

-----

## What You’ll Learn

  * How to select and operate **Granite** models for enterprise use cases
  * End‑to‑end **RAG**: extraction → chunking → embeddings → vector stores (Elasticsearch/Chroma) → LLM answering
  * Building **governed agents** with **LangGraph** + **watsonx.governance** (Evaluation Studio)
  * Packaging and deploying **CLIs, APIs (FastAPI), and simple UIs (Streamlit)**
  * **Evaluation** and comparison of model configurations to support evidence‑based choices

> The site is **Markdown-first** for reliability. Notebooks live under `labs-src/` only for reference so `mkdocs build --strict` stays clean.

-----

## Tracks (at a glance)

| | |
|---|---|
| 🔥 **Granite**<br>*Models & Prompting*<br><br>Explore Granite model families, prompting techniques, and the watsonx.ai SDK. Learn safe defaults, context windows, and token budgeting.<br><br>[**➡️ Open »**](https://www.google.com/search?q=docs/tracks/granite/labs/pre-work.md) | 🔎 **RAG**<br>*Grounded Q\&A from your data*<br><br>Build a clean ingestion pipeline for HTML/PDF, create embeddings, index in **Elasticsearch/Chroma**, and serve grounded answers with **Granite** on watsonx.ai.<br><br>[**➡️ Open »**](https://www.google.com/search?q=docs/tracks/rag/labs/pre-work.md) |
| 🤖 **Agents**<br>*Governed, tool-using agents*<br><br>Use LangGraph and **watsonx.governance** to build agents that call tools safely. Compare runs in **Evaluation Studio**.<br><br>[**➡️ Open »**](https://www.google.com/search?q=docs/tracks/agents/labs/lab-2-hr-assistant-governed-catalog.md) | ⚙️ **Orchestrate**<br>*Multi-agent solutions*<br><br>Combine multiple agents, RAG backends, and services into cohesive workflows with robust configuration.<br><br>[**➡️ Open »**](https://www.google.com/search?q=docs/tracks/orchestrate/orchestrate-workshop.md) |

-----

## Prerequisites

  * **IBM Cloud** account with **watsonx.ai** access and a Project
  * **Python 3.11** (or via Docker), **git**, and **Make**
  * (For RAG with ES) a reachable **Elasticsearch 8.x** instance or use local **Chroma**

> Everything can be run locally. Docker workflows are provided if you prefer isolated, reproducible environments.

-----

## Run the Docs Locally

```bash
# from repo root
pip install -r requirements-docs.txt  # if present; otherwise: pip install mkdocs-material
mkdocs serve
# open http://127.0.0.1:8000
```

Build static site:

```bash
mkdocs build --strict
```

-----

## Quick Start — RAG Accelerator (Lab 1)

```bash
# minimal local run
cd accelerator
python -m venv .venv
source .venv/bin/activate       # on Windows: .venv\Scripts\activate
pip install -U pip && pip install -e .
cp .env.sample .env             # set watsonx + backend (ES or Chroma)
make all                        # extract → chunk → index
make api                        # FastAPI at http://localhost:8001/health
# in another terminal
make ui                         # Streamlit UI at http://localhost:8501
```

-----

## Production‑Minded Patterns

  * **Config hygiene**: `.env.sample`, `es.env.sample`, environment‑driven settings, sensible defaults
  * **Evaluation first**: tiny harnesses + **Evaluation Studio** comparisons (temperature, model choice, retriever `k`)
  * **Observability**: log prompts/latency and store experiment metadata for reproducibility
  * **Secure by design**: avoid leaking secrets; choose private networks and TLS for ES; rate‑limit APIs
  * **Portability**: Dockerfiles and `requirements.txt`/`pyproject.toml` for deterministic builds

-----

## FAQ

**Q: Can I run everything without Elasticsearch?**
Yes. Use the **Chroma** path (local, persistent) and switch to ES later by changing `.env` and re‑indexing.

**Q: Which Granite model should I start with?**
Begin with a smaller **Granite Instruct** model for iteration. Compare against larger variants in Evaluation Studio.

**Q: How do I keep costs predictable?**
Use smaller models during development, reduce `max_new_tokens`, and evaluate retrieval quality before long prompts.

-----

## Contributing

Issues and improvements are welcome. Please open a discussion or PR with a clear description, steps to reproduce (if applicable), and proposed changes.

-----

## License

This project is distributed under an open‑source license. See **[LICENSE](https://www.google.com/search?q=LICENSE)** for details.

> IBM, watsonx, and other product names are trademarks or registered trademarks of IBM or their respective owners. Use of marks in this repository is solely for identification and does not imply endorsement.

-----

## Acknowledgments & Contact

Created and maintained by **Ruslan Magaña**. For updates, articles, and related projects, visit **[ruslanmv.com](https://ruslanmv.com)**.