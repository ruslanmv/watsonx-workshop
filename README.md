# watsonx Workshop Series

<p align="center">
  <a href="https://www.ibm.com/products/watsonx-ai" target="_blank"><img src="https://img.shields.io/badge/built%20for-watsonx.ai-0b62a3?logo=ibm&logoColor=white" alt="watsonx.ai"></a>
  <a href="https://www.python.org" target="_blank"><img src="https://img.shields.io/badge/python-3.11%2B-3776AB?logo=python&logoColor=white" alt="Python 3.11+" /></a>
  <a href="https://ruslanmv.com/watsonx-workshop/" target="_blank"><img src="https://img.shields.io/badge/docs-MkDocs%20Material-000000?logo=markdown" alt="MkDocs Material" /></a>
</p>

<div align="center">
  <a href="https://www.python.org" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="Python" width="54" height="54"/></a>
  <a href="https://jupyter.org/" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/jupyter/jupyter-original-wordmark.svg" alt="Jupyter" width="64" height="64"/></a>
</div>

---

## Purpose & Scope

**This repository is a practical, enterprise-minded curriculum for IBM watsonx.**  
It focuses on the *essential knowledge and patterns* you need to design **stable, production-ready solutions** for IBM clients operating at **high enterprise scale**.

We guide you along a clear path:

1. **Granite** — learn the model families, prompting patterns, local runs, and the watsonx.ai SDK  
2. **RAG** — build Retrieval-Augmented Generation systems with clean ingestion, robust retrieval, and grounded answering  
3. **Agents** — use CrewAI / LangGraph and **watsonx.governance** to build governed, tool-using agents and evaluate them  
4. **Orchestrate** — combine components into **multi-agent** workflows for end-to-end business solutions

Throughout, you’ll see **industry best practices**: configuration hygiene, reproducibility, observability hooks, evaluation workflows, and guidance for secure deployment.

> For background and updates from the author, visit **[ruslanmv.com](https://ruslanmv.com)**.

---

## What You’ll Learn

- Selecting and operating **Granite** models for enterprise use cases  
- End-to-end **RAG**: extraction → chunking → embeddings → vector stores (Elasticsearch/Chroma) → LLM answering with citations  
- Building **governed agents** with **CrewAI / LangGraph** + **watsonx.governance** (Evaluation Studio)  
- Packaging and deploying **CLIs, APIs (FastAPI), and UIs (Streamlit)**  
- **Evaluation** and comparison of model configurations to support evidence-based choices

> The site is **Markdown-first** for reliability. Notebooks live under references (`labs-src/`, `docs/assets/notebooks/day3/`) so `mkdocs build --strict` stays clean.

---

## Who Is This For?

| Role | You’ll Gain |
|---|---|
| **Developers & ML Engineers** | Reproducible pipelines, clean APIs, and hands-on patterns you can ship |
| **Architects & Tech Leads** | Reference designs for secure, governed, and scalable LLM systems |
| **Data Scientists** | Prompting strategies, evaluation harnesses, and experiment discipline |
| **Consultants** | Client-ready accelerators and workshop materials for rapid value delivery |

---

## Curriculum Overview

| Day | Theme | Theory (≈4h) | Labs (≈4h) | Key Deliverable |
|---|---|---|---|---|
| **Day 0** | Environment Setup | Repos, environments, credentials | Verify *simple-ollama* & *simple-watsonx* | Two working environments |
| **Day 1** | LLMs & Prompting | Granite models, prompting patterns, safety | Multi-env quickstart + prompt templates + micro-eval | Prompting playbook |
| **Day 2** | Retrieval-Augmented Generation | RAG architecture, design trade-offs | Local RAG, Twin pipelines, Eval harness | Grounded Q&A + API/UI |
| **Day 3** | Orchestrate & Agents | Agentic patterns, governance, orchestration | Agent + Accelerator tool, Orchestrate ADK labs | Orchestrated agent demo |
| **Capstone** *(optional)* | Ship It! | Team planning | Build, test, demo | Portfolio-ready mini-project |

---

## Tracks (at a glance)

| | |
|---|---|
| 🔥 **Granite**<br>*Models & Prompting*<br><br>Explore Granite model families, prompting techniques, and the watsonx.ai SDK. Learn safe defaults, context windows, and token budgeting.<br><br>[**➡️ Open »**](docs/tracks/day1-llm/llm-concepts.md) | 🔎 **RAG**<br>*Grounded Q&A from your data*<br><br>Build a clean ingestion pipeline for HTML/PDF, create embeddings, index in **Elasticsearch/Chroma**, and serve grounded answers with **Granite** on watsonx.ai.<br><br>[**➡️ START HERE »**](docs/tracks/day2-rag/START_HERE.md) |
| 🤖 **Agents**<br>*Governed, tool-using agents*<br><br>Use CrewAI / LangGraph patterns and **watsonx.governance** to build and evaluate agents safely.<br><br>[**➡️ Open »**](docs/tracks/day3-orchestrate/agentic-ai-overview.md) | ⚙️ **Orchestrate**<br>*Multi-agent solutions*<br><br>Bridge your agent + RAG service into **watsonx Orchestrate** with connections, knowledge bases, and flows.<br><br>[**➡️ Open »**](docs/tracks/day3-orchestrate/watsonx-orchestrate-labs.md) |

---

## Prerequisites

- **IBM Cloud** account with **watsonx.ai** access and a Project  
- **Python 3.11**, **git**, and **Make** (or Docker)  
- (For RAG+ES) a reachable **Elasticsearch 8.x** instance — or use **Chroma** locally

> Everything can be run locally. Docker workflows are provided if you prefer isolated, reproducible environments.

---

## Repo Layout (high-level)

```text
.
├── accelerator/                 # Production-minded RAG service (FastAPI + Streamlit + tools)
├── docs/                        # MkDocs site content (Markdown-first)
│   ├── assets/                  # CSS/JS/images + reference notebooks
│   │   └── notebooks/day3/      # agent_crewai.ipynb, agent_langgraph.ipynb, agent_watsonx.ipynb
│   ├── blog/                    # Articles (optional)
│   └── tracks/
│       ├── day0-env/            # Day 0 – setup & verification
│       ├── day1-llm/            # Day 1 – LLM & prompting
│       ├── day2-rag/            # Day 2 – RAG (theory + labs)
│       ├── day3-orchestrate/    # Day 3 – Orchestration & agents
│       └── capstone/            # Optional project day
├── labs-src/                    # Reference notebooks (governance & RAG examples)
├── rag-app/                     # Minimal standalone RAG demo app (for comparison)
├── mkdocs.yml                   # Site config
└── site/                        # Built static site (generated)
````

---

## Run the Docs Locally

```bash
# from repo root
pip install mkdocs-material
mkdocs serve
# open http://127.0.0.1:8000
```

Build static site:

```bash
mkdocs build --strict
```

---

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

**Makefile targets (most used)**

| Target       | What it does                                    |
| ------------ | ----------------------------------------------- |
| `make all`   | Runs extraction → chunking → embeddings → index |
| `make api`   | Launches FastAPI service (`/ask`, `/health`)    |
| `make ui`    | Launches Streamlit chat UI                      |
| `make clean` | Removes temporary artifacts and caches          |

---

## Day 3 — Agentic AI (Reference Notebooks)

Use these along with **Lab 3.1** (Agent + Accelerator API):

* `docs/assets/notebooks/day3/agent_crewai.ipynb`
* `docs/assets/notebooks/day3/agent_langgraph.ipynb`
* `docs/assets/notebooks/day3/agent_watsonx.ipynb`

**Bridge to Orchestrate:**
Map the accelerator `/ask` endpoint and your agent’s tools to **watsonx Orchestrate** actions and knowledge bases. See:

* [Agentic AI Overview](docs/tracks/day3-orchestrate/agentic-ai-overview.md)
* [Lab 3.1 – Agent in simple-watsonx-enviroment + Accelerator API](docs/tracks/day3-orchestrate/lab-1-agent-watsonx.md)
* [watsonx Orchestrate Labs (ADK)](docs/tracks/day3-orchestrate/watsonx-orchestrate-labs.md)

---

## Production-Minded Patterns

* **Config hygiene** — `.env.sample`, `es.env.sample`, environment-driven settings, sensible defaults
* **Evaluation first** — tiny harnesses + **Evaluation Studio** comparisons (temperature, model choice, retriever `k`)
* **Observability** — log prompts/latency and store experiment metadata for reproducibility
* **Secure by design** — avoid leaking secrets; choose private networks and TLS for ES; rate-limit APIs
* **Portability** — Dockerfiles and `requirements.txt`/`pyproject.toml` for deterministic builds

---

## Success Outcomes (why teams love this course)

| Outcome                        | Measure                                                       |
| ------------------------------ | ------------------------------------------------------------- |
| Working RAG service (API + UI) | `/ask` endpoint + Streamlit demo with citations               |
| Faster iteration cycles        | Saved experiment configs, evaluation runs, and logs           |
| Better decisions               | Side-by-side model/retriever comparisons in Evaluation Studio |
| Production readiness           | Clean config, minimal attack surface, build & deploy scripts  |
| Team enablement                | Reusable patterns and reference notebooks for future projects |

---

## FAQ

**Q: Can I run everything without Elasticsearch?**
Yes. Use the **Chroma** path (local, persistent) and switch to ES later by changing `.env` and re-indexing.

**Q: Which Granite model should I start with?**
Begin with a smaller **Granite Instruct** model for iteration. Compare against larger variants in Evaluation Studio.

**Q: How do I keep costs predictable?**
Use smaller models during development, reduce `max_new_tokens`, and evaluate retrieval quality before long prompts.

**Q: Where are the notebooks?**

* RAG & governance examples: `labs-src/`
* Agent references: `docs/assets/notebooks/day3/`

---

## Contributing

We welcome issues and improvements!
Please open a discussion or PR with a clear description, repro steps (if applicable), and proposed changes.

## 📢 Workshop Feedback

Thank you for participating in the Watsonx Workshop. We are committed to the continuous improvement of our training materials.

Please take a brief moment to rate your experience and share your thoughts:

👉 [**Submit Course Evaluation Form**](https://github.com/ruslanmv/watsonx-workshop/issues/new?template=course_feedback.yml)


---

## License

This project is distributed under an open-source license. See **[LICENSE](LICENSE)**.

> IBM, watsonx, and other product names are trademarks or registered trademarks of IBM or their respective owners. Use of marks in this repository is solely for identification and does not imply endorsement.

---

## Acknowledgments & Contact

Created and maintained by **Ruslan Magaña**.
For updates, articles, and related projects, visit **[ruslanmv.com](https://ruslanmv.com)**.

