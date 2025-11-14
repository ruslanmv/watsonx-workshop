# watsonx Workshop Series

<p align="center">
  <a href="https://www.ibm.com/products/watsonx-ai" target="_blank"><img src="https://img.shields.io/badge/built%20for-watsonx.ai-0b62a3?logo=ibm&logoColor=white" alt="watsonx.ai"></a>
  <a href="https://www.python.org" target="_blank"><img src="https://img.shields.io/badge/python-3.11%2B-3776AB?logo=python&logoColor=white" alt="Python 3.11+" /></a>
  <a href="https://ruslanmv.com/watsonx-workshop/" target="_blank"><img src="https://img.shields.io/badge/docs-MkDocs%20Material-000000?logo=markdown" alt="MkDocs Material" /></a>
  <a href="https://github.com/ruslanmv/watsonx-workshop/blob/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/license-Open%20Source-success" alt="License" /></a>
</p>

<div align="center">
  <a href="https://www.python.org" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="Python" width="54" height="54"/></a>
  <a href="https://jupyter.org/" target="_blank"><img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/jupyter/jupyter-original-wordmark.svg" alt="Jupyter" width="64" height="64"/></a>
</div>

<p align="center">
  <strong>Enterprise-ready hands-on training for building AI solutions with IBM watsonx</strong>
</p>

---

## Overview

A comprehensive, production-ready workshop curriculum designed for enterprise teams building AI applications with **IBM watsonx**. Master LLMs, RAG systems, AI agents, and orchestration through hands-on labs and real-world patterns.

### 🎯 What You'll Build

- **Enterprise LLM Applications** — Master Granite models and prompt engineering
- **Production RAG Systems** — Build retrieval-augmented generation pipelines with vector databases
- **Intelligent Agents** — Create tool-using agents with governance and orchestration
- **Complete APIs & UIs** — Deploy FastAPI backends and Streamlit interfaces

---

## 🚀 Quick Links

| Resource | Description | Link |
|----------|-------------|------|
| **📚 Documentation** | Complete workshop materials and guides | [View Docs](https://ruslanmv.com/watsonx-workshop/) |
| **🎓 Workshop Portal** | Interactive daily guides and presentations | [Enter Portal](https://ruslanmv.com/watsonx-workshop/portal/) |
| **🏗️ RAG Accelerator** | Production-ready RAG implementation | [Start Here](docs/tracks/day2-rag/START_HERE.md) |
| **💬 Discussions** | Community Q&A and support | [Join Discussion](https://github.com/ruslanmv/watsonx-workshop/discussions) |
| **🐛 Issues** | Report bugs or request features | [Report Issue](https://github.com/ruslanmv/watsonx-workshop/issues) |

---

## 📖 Workshop Structure

| Day | Focus Area | Duration | Key Deliverable |
|-----|------------|----------|-----------------|
| **[Day 0](docs/tracks/day0-env/prereqs-and-accounts.md)** | Environment Setup | 4 hours | Working local & cloud environments |
| **[Day 1](docs/tracks/day1-llm/llm-concepts.md)** | LLMs & Prompting | 6 hours | Prompting playbook & safe AI patterns |
| **[Day 2](docs/tracks/day2-rag/START_HERE.md)** | RAG Systems | 6 hours | Production RAG API + UI with citations |
| **[Day 3](docs/tracks/day3-orchestrate/agentic-ai-overview.md)** | Agents & Orchestration | 6 hours | Multi-agent system with governance |
| **[Capstone](docs/tracks/capstone/capstone-overview.md)** | Applied Project | 4 hours | Portfolio-ready enterprise application |

---

## ⚡ Quick Start

### Prerequisites

- IBM Cloud account with watsonx.ai access
- Python 3.11+
- Git and Docker (optional)
- Elasticsearch 8.x (for RAG) or Chroma locally

### Run the RAG Accelerator

```bash
# Clone repository
git clone https://github.com/ruslanmv/watsonx-workshop.git
cd watsonx-workshop/accelerator

# Set up environment
python -m venv .venv
source .venv/bin/activate         # Windows: .venv\Scripts\activate
pip install -U pip && pip install -e .

# Configure credentials
cp .env.sample .env               # Add your watsonx credentials

# Run the complete pipeline
make all                          # Extract → Chunk → Embed → Index

# Start services
make api                          # FastAPI at http://localhost:8001
make ui                           # Streamlit at http://localhost:8501
```

### View Documentation Locally

```bash
# From repository root
pip install mkdocs-material
mkdocs serve
# Open http://127.0.0.1:8000
```

---

## 🎓 Learning Paths

### For Instructors

- 📋 **[Workshop Portal](https://ruslanmv.com/watsonx-workshop/portal/)** — Complete daily guides with presentations and timing
- 🎬 **Interactive Slides** — HTML presentations with speaker notes
- 📝 **Instructor Notes** — Teaching tips and common troubleshooting

### For Self-Paced Learners

- 📚 **[Full Documentation](https://ruslanmv.com/watsonx-workshop/)** — Comprehensive written guides
- 💻 **Hands-On Labs** — Step-by-step tutorials with code examples
- 📓 **Reference Notebooks** — Jupyter notebooks for exploration

---

## 🏗️ Repository Structure

```text
watsonx-workshop/
├── accelerator/              # Production RAG service (FastAPI + Streamlit)
├── docs/
│   ├── portal/              # Daily workshop portals
│   ├── tracks/              # Detailed guides by day
│   ├── slides/              # Presentation slides (HTML)
│   └── assets/              # Images, CSS, reference notebooks
├── labs-src/                # Additional lab notebooks
├── mkdocs.yml               # Documentation configuration
└── README.md                # This file
```

---

## 🛠️ What's Included

- ✅ **Production Code** — FastAPI + Streamlit applications, CLIs, Dockerfiles
- ✅ **Hands-On Labs** — Step-by-step Markdown guides with solutions
- ✅ **Presentation Slides** — Interactive HTML decks with PDF export
- ✅ **Enterprise Patterns** — Security, governance, and deployment best practices
- ✅ **Reference Notebooks** — Jupyter notebooks for RAG, agents, and governance
- ✅ **Evaluation Tools** — Model comparison and quality metrics

---

## 🎯 Learning Outcomes

By completing this workshop, you will:

- ✓ Deploy and operate Granite LLMs on watsonx.ai
- ✓ Implement enterprise-grade RAG systems with vector databases
- ✓ Build governed, tool-using AI agents
- ✓ Orchestrate multi-agent workflows with watsonx Orchestrate
- ✓ Evaluate and compare model configurations
- ✓ Deploy production-ready APIs and UIs
- ✓ Apply security and governance best practices

---

## 👥 Who Is This For?

| Role | Benefits |
|------|----------|
| **Developers & ML Engineers** | Reproducible pipelines, clean APIs, production-ready patterns |
| **Architects & Tech Leads** | Reference designs for secure, governed, scalable LLM systems |
| **Data Scientists** | Prompting strategies, evaluation frameworks, experiment workflows |
| **Consultants** | Client-ready accelerators for rapid value delivery |

---

## 🔧 Key Technologies

- **IBM watsonx.ai** — Enterprise AI platform for LLMs and governance
- **Granite Models** — IBM's family of enterprise-grade language models
- **Elasticsearch/Chroma** — Vector databases for RAG
- **LangChain/CrewAI/LangGraph** — Agent frameworks and orchestration
- **FastAPI** — Modern Python API framework
- **Streamlit** — Interactive UI for AI applications

---

## 📊 Production Patterns

This workshop emphasizes enterprise-ready practices:

- **Configuration Hygiene** — Environment-driven settings with `.env` files
- **Evaluation First** — Model comparison with watsonx.governance
- **Observability** — Logging, metrics, and experiment tracking
- **Security** — Secret management, rate limiting, secure deployment
- **Portability** — Docker support for reproducible environments

---

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request with clear description

For bugs or feature requests, please [open an issue](https://github.com/ruslanmv/watsonx-workshop/issues).

---

## 📄 License

This project is distributed under an open-source license. See [LICENSE](LICENSE) for details.

> IBM, watsonx, and other product names are trademarks of their respective owners. Use of marks in this repository is for identification purposes only and does not imply endorsement.

---

## 📬 Contact & Support

- **Author**: Ruslan Magaña
- **Website**: [ruslanmv.com](https://ruslanmv.com)
- **Discussions**: [GitHub Discussions](https://github.com/ruslanmv/watsonx-workshop/discussions)
- **Issues**: [GitHub Issues](https://github.com/ruslanmv/watsonx-workshop/issues)

---

<div align="center">
  <p><strong>⭐ If you find this workshop helpful, please star the repository!</strong></p>
  <p>Built with care for the watsonx Community</p>
</div>