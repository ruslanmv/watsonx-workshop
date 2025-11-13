# watsonx Workshop Series

<p align="center">
  <a href="https://www.ibm.com/products/watsonx-ai" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/built%20for-watsonx.ai-0b62a3?logo=ibm&logoColor=white" alt="watsonx.ai">
  </a>
  <a href="https://www.python.org" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/python-3.11+-3776AB?logo=python&logoColor=white" alt="Python 3.11+">
  </a>
  <a href="https://ruslanmv.com/watsonx-workshop/" target="_blank" rel="noopener">
    <img src="https://img.shields.io/badge/docs-MkDocs%20Material-000000?logo=markdown" alt="MkDocs Material">
  </a>
</p>

<div align="center">
  <a href="https://www.python.org" target="_blank" rel="noopener">
    <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="Python" width="54" height="54"/>
  </a>
  <a href="https://jupyter.org/" target="_blank" rel="noopener">
    <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/jupyter/jupyter-original-wordmark.svg" alt="Jupyter" width="64" height="64"/>
  </a>
</div>

---

## Purpose & Scope

**A practical, enterprise-minded curriculum for IBM watsonx.**  
You’ll learn the essentials to design **stable, production-ready solutions** that scale for real customers:

1) **Day 0 – Environment**: local & cloud setup for the week  
2) **Day 1 – LLMs & Prompting**: Granite concepts, patterns, safe prompting  
3) **Day 2 – RAG**: from ingestion to **FastAPI** + **Streamlit** UI  
4) **Day 3 – Orchestrate & Agents**: tool-using agents, governance, and multi-step flows

Along the way we emphasize **configuration hygiene, reproducibility, observability, evaluation**, and secure deployment.

> Author updates & articles: **[ruslanmv.com](https://ruslanmv.com)**

---

## What You’ll Learn

- Selecting and operating **Granite** models for enterprise use
- End-to-end **RAG**: extract → chunk → embed → (Elasticsearch/Chroma) → LLM answer with citations
- Building **agents** (CrewAI/LangGraph patterns) and bridging to **watsonx Orchestrate**
- Packaging **CLIs/APIs (FastAPI)** and simple **UIs (Streamlit)**
- **Evaluation** using **watsonx.governance** (e.g., Evaluation Studio)

> The site is **Markdown-first**. Notebooks are references only so `mkdocs build --strict` stays clean:
> - Governance & RAG refs under `labs-src/`
> - Agent notebooks under `docs/assets/notebooks/day3/`

---

## Documentation

The published docs mirror the structure below. You can also browse the Markdown under `docs/`.

- **Day 0 – Environment Setup**  
  `docs/tracks/day0-env/…`  
- **Day 1 – LLMs & Prompting**  
  `docs/tracks/day1-llm/…`  
- **Day 2 – RAG**  
  `docs/tracks/day2-rag/…`  
- **Day 3 – Orchestrate & Agents**  
  `docs/tracks/day3-orchestrate/…`  
- **Capstone (Optional)**  
  `docs/tracks/capstone/…`

Quick links:

- Day 0: [Prereqs & Accounts](docs/tracks/day0-env/prereqs-and-accounts.md)
- Day 1: [LLM Concepts & Architecture](docs/tracks/day1-llm/llm-concepts.md)
- Day 2: [START HERE](docs/tracks/day2-rag/START_HERE.md)
- Day 3: [Orchestration & Agents Overview](docs/tracks/day3-orchestrate/agentic-ai-overview.md)
- Capstone: [Overview](docs/tracks/capstone/capstone-overview.md)

---

## Run the Docs Locally

```bash
# from repo root
pip install mkdocs-material
mkdocs serve
# open http://127.0.0.1:8000
````

Build static site:

```bash
mkdocs build --strict
```

---

## Quick Start — RAG Accelerator (Day 2, Lab 1)

```bash
# minimal local run
cd accelerator
python -m venv .venv
source .venv/bin/activate         # Windows: .venv\Scripts\activate
pip install -U pip && pip install -e .
cp .env.sample .env               # set watsonx + backend (Elasticsearch or Chroma)
make all                          # extract → chunk → index
make api                          # FastAPI at http://localhost:8001/health
# in another terminal
make ui                           # Streamlit at http://localhost:8501
```

---

## Day 3 Agent Notebooks (Reference)

Use these alongside **Lab 3.1** (Agent + Accelerator API):

* `docs/assets/notebooks/day3/agent_crewai.ipynb`
* `docs/assets/notebooks/day3/agent_langgraph.ipynb`
* `docs/assets/notebooks/day3/agent_watsonx.ipynb`

---

## Production-Minded Patterns

* **Config hygiene**: `.env.sample`, environment-driven settings, sensible defaults
* **Evaluation first**: small harnesses + **Evaluation Studio** comparisons
* **Observability**: log prompts/latency, store experiment metadata
* **Security**: avoid secret leaks; prefer private networking/TLS to ES; rate-limit public APIs
* **Portability**: Dockerfiles + `requirements.txt` / `pyproject.toml` for deterministic builds

---

## FAQ

**Can I run without Elasticsearch?**
Yes. Use **Chroma** locally, then switch to ES by updating `.env` and re-indexing.

**Which Granite model should I start with?**
Begin with a smaller **Granite Instruct** model, then compare larger variants in Evaluation Studio.

**How do I control costs?**
Iterate with smaller models, tune `max_new_tokens`, and optimize retrieval quality before long prompts.

---

## Contributing

Issues and improvements are welcome! Open a discussion or PR with a clear description, repro steps (if applicable), and proposed changes.

---

## License

This project is distributed under an open-source license. See **[LICENSE](LICENSE)**.

> IBM, watsonx, and other product names are trademarks or registered trademarks of IBM or their respective owners.

---

## Acknowledgments & Contact

Created and maintained by **Ruslan Magaña**.
For updates and related work, visit **[ruslanmv.com](https://ruslanmv.com)**.


