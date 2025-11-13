---
template: home.html
title: watsonx Workshop Series
description: Hands-on labs for LLMs, RAG, Agents, and Orchestrate — built with MkDocs Material.
---


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

## Welcome

The **watsonx Workshop Series** is a hands-on set of tracks that show how to build with IBM watsonx:

- **Day 0 – Environment** — local & cloud setup for the whole week  
- **Day 1 – LLMs & Prompting** — Granite concepts, patterns, and safe prompting  
- **Day 2 – RAG** — retrieval-augmented generation from zero to API & UI  
- **Day 3 – Orchestrate & Agents** — tool-using agents and governance, end-to-end

!!! note "Markdown-First Approach"
    Everything is **Markdown-first** for clean builds. Day-specific notebooks live under:
    
    - `labs-src/` (governance & RAG examples)
    - `docs/assets/notebooks/day3/` (agent notebooks reference)

---

## Quick Start

=== "Browse the Docs"

    1. Use the left sidebar to pick a **Day**.
    2. Follow the pages top-to-bottom; theory first, then labs with solutions.
    3. Start at **Day 0** to prepare both environments.

=== "Run the Accelerator (RAG) Locally"

    ```bash
    # Minimal end-to-end run
    cd accelerator
    python -m venv .venv
    source .venv/bin/activate         # Windows: .venv\Scripts\activate
    pip install -U pip && pip install -e .
    cp .env.sample .env               # fill watsonx + vector backend settings
    make all                          # extract → chunk → index
    make api                          # FastAPI at http://localhost:8001/health
    # in a second terminal:
    make ui                           # Streamlit at http://localhost:8501
    ```

---

## Choose a Track

<div class="grid cards" markdown>

-   :material-laptop-account: __Day 0 – Environment Setup__

    ---

    Prepare **simple-ollama** and **simple-watsonx** envs; verify both.
    
    [:octicons-arrow-right-16: Open](tracks/day0-env/prereqs-and-accounts.md){ .md-button .md-button--primary }

-   :material-brain: __Day 1 – LLMs & Prompting__

    ---

    LLM concepts, prompt patterns & templates, lightweight eval & safety.
    
    [:octicons-arrow-right-16: Open](tracks/day1-llm/llm-concepts.md){ .md-button .md-button--primary }

-   :material-magnify-expand: __Day 2 – RAG__

    ---

    Build a grounded Q&A app (Elasticsearch/Chroma + watsonx.ai), package and evaluate.
    
    [:octicons-arrow-right-16: START HERE](tracks/day2-rag/START_HERE.md){ .md-button .md-button--primary }

-   :material-robot-outline: __Day 3 – Orchestrate & Agents__

    ---

    Agentic AI: CrewAI/LangGraph patterns → **watsonx Orchestrate** with governance.
    
    [:octicons-arrow-right-16: Open](tracks/day3-orchestrate/agentic-ai-overview.md){ .md-button .md-button--primary }

-   :material-rocket-launch-outline: __Capstone (Optional)__

    ---

    Team up to ship a mini project using the accelerator & governance workflow.
    
    [:octicons-arrow-right-16: Open](tracks/capstone/capstone-overview.md){ .md-button }

</div>

---

## Presentation Slides

Use the docs for **step-by-step labs**, and the **slides** for live delivery or sharing with participants.

### HTML Decks (Interactive)

<div class="grid cards" markdown>

-   :material-presentation: __Day 0 – Environment Setup__

    ---

    Environment overview, accounts, and validation of both stacks.

    [:material-monitor-dashboard: View Slides](slides/day0-prereqs-and-accounts.html){ .md-button .md-button--primary }

-   :material-presentation: __Day 1 – LLMs & Prompting__

    ---

    LLM concepts, prompt patterns & templates, eval & safety.

    [:material-monitor-dashboard: View Slides](slides/day1-llm-concepts.html){ .md-button .md-button--primary }

-   :material-presentation: __Day 2 – RAG__

    ---

    RAG architecture, retrieval patterns, and accelerator alignment.

    [:material-monitor-dashboard: View Slides](slides/day2-rag-architecture-overview.html){ .md-button .md-button--primary }

-   :material-presentation: __Day 3 – Orchestrate & Agents__

    ---

    Agentic AI, orchestration, and governance recap.

    [:material-monitor-dashboard: View Slides](slides/day3-agentic-ai-overview.html){ .md-button .md-button--primary }

-   :material-presentation: __Capstone__

    ---

    Project overview, ideas, and framing for the final exercise.

    [:material-monitor-dashboard: View Slides](slides/capstone-overview.html){ .md-button .md-button--primary }

</div>

!!! tip "PDF Export"
    To export slides as PDF, open any HTML deck and use your browser's print function (Ctrl+P / Cmd+P) with "Save as PDF" option.

---

## RAG Track at a Glance

- **Pre-work**: environment, credentials, and sample data  
- **Lab 1**: end-to-end accelerator (HTML/PDF → vectors → API + Streamlit)  
- **Lab 2** *(choose or compare)*:
  - 2A: **Elasticsearch + LangChain**
  - 2B: **Elasticsearch Python SDK** (no LangChain)
  - 2C: **Chroma + LangChain** (local/dev)
- **Lab 3**: **Packaging & Evaluation** with watsonx.governance

```mermaid
flowchart TD
  subgraph ING[Ingestion]
    direction TB
    A[Docs: HTML • PDF] --> B[Extractor & Cleaner]
    B --> C[Chunker]
  end
  subgraph RET[Retrieval]
    direction TB
    C --> D[Embeddings]
    D -->|dense vectors| E[(Vector Store ES/Chroma)]
    E -->|top-k| F[Reranker optional]
  end
  subgraph GEN[Generation]
    direction TB
    F --> G[Prompt Composer]
    G --> H[LLM on watsonx.ai]
    H --> I[Answer + Citations]
  end
  subgraph SRV[Serving]
    direction TB
    I --> J[FastAPI /ask]
    J --> K[Streamlit Chat UI]
  end
  classDef source fill:#E3F2FD,stroke:#1E88E5,color:#0D47A1,stroke-width:1px;
  classDef process fill:#F1F8E9,stroke:#7CB342,color:#2E7D32,stroke-width:1px;
  classDef store fill:#FFF3E0,stroke:#FB8C00,color:#E65100,stroke-width:1px;
  classDef model fill:#F3E5F5,stroke:#8E24AA,color:#4A148C,stroke-width:1px;
  classDef output fill:#E0F7FA,stroke:#00ACC1,color:#006064,stroke-width:1px;
  class A source; class B,C,D,F,G,J,K process; class E store; class H model; class I output;
```

---

## Day 3 Agent Notebooks (Reference)

Agent implementation examples for different frameworks:

- `docs/assets/notebooks/day3/agent_crewai.ipynb` — Multi-agent collaboration
- `docs/assets/notebooks/day3/agent_langgraph.ipynb` — Stateful workflows
- `docs/assets/notebooks/day3/agent_watsonx.ipynb` — watsonx Orchestrate integration

!!! info "Lab Integration"
    Use these alongside **Lab 3.1**: [Agent + Accelerator API](tracks/day3-orchestrate/lab-1-agent-watsonx.md).

---

## What's Included

- **Production-ready samples** — FastAPI + Streamlit, CLI, Dockerfiles
- **Reproducible configs** — `.env.sample`, `requirements.txt` / `pyproject.toml`
- **Evaluation workflows** — watsonx.governance for model comparison

!!! tip "Everything is Markdown"
    All labs are follow-along pages. Copy-paste commands and code blocks; notebooks are optional helpers.

---

## Next Steps

<div class="grid cards" markdown>

-   :material-play-circle: __Begin Day 0__
    
    ---
    
    Set up and verify both environments
    
    [:octicons-arrow-right-16: Start](tracks/day0-env/prereqs-and-accounts.md){ .md-button .md-button--primary }

-   :material-rocket-launch: __Jump to RAG__
    
    ---
    
    Start building immediately if ready
    
    [:octicons-arrow-right-16: Go](tracks/day2-rag/START_HERE.md){ .md-button .md-button--primary }

-   :material-book-open-variant: __Resources__
    
    ---
    
    Additional learning materials
    
    [:octicons-arrow-right-16: Browse](resources.md){ .md-button }

</div>

---

<div align="center">
  <p><strong>Built with ❤️ for the watsonx Community</strong></p>
  <p>
    <a href="https://github.com/ruslanmv/watsonx-workshop">⭐ Star on GitHub</a> •
    <a href="https://github.com/ruslanmv/watsonx-workshop/issues">Report Issue</a> •
    <a href="https://github.com/ruslanmv/watsonx-workshop/discussions">Discussions</a>
  </p>
</div>