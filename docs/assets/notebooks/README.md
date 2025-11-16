# watsonx Workshop Notebooks

This directory contains all Jupyter notebooks for the watsonx workshop series.

## 📁 Directory Structure

```
notebooks/
├── day0/              # Environment setup and verification
├── day1/              # LLM fundamentals and prompt engineering
├── day2/              # RAG (Retrieval-Augmented Generation)
│   ├── lab_2.1_local_rag_ollama/
│   ├── lab_2.2_rag_watsonx/
│   ├── lab_2.3_twin_pipelines/
│   ├── lab_2.4_evaluation_harness/
│   └── reference_notebooks/
└── day3/              # Orchestration and agents
```

## 📚 Notebook Inventory

### Day 0: Environment Setup

| Notebook | Description | Status |
|----------|-------------|--------|
| `verify_envs.ipynb` | Verify Ollama and watsonx environments | Template provided |

**Location**: Students create these in their own environments (external repos)

### Day 1: LLM Fundamentals

| Notebook | Description | Lab | Status |
|----------|-------------|-----|--------|
| `prompt_patterns_ollama.ipynb` | Prompt templates with Ollama | Lab 1.2 | ✅ Complete |
| `prompt_patterns_watsonx.ipynb` | Prompt templates with watsonx.ai | Lab 1.2 | ✅ Complete |
| `micro_evaluation.ipynb` | Evaluation framework for LLMs | Lab 1.3 | ✅ Complete |

**Path**: `docs/assets/notebooks/day1/`

**Topics Covered**:
- Summarization patterns
- Style transfer
- Q&A with context
- Systematic evaluation
- Metrics and comparison

### Day 2: Retrieval-Augmented Generation (RAG)

#### Lab 2.1: Local RAG with Ollama

| Notebook | Description | Status |
|----------|-------------|--------|
| `starter_notebook.ipynb` | Starter template with TODOs | ✅ Complete |
| `solution_notebook.ipynb` | Complete working solution | ✅ Complete |

**Path**: `docs/assets/notebooks/day2/lab_2.1_local_rag_ollama/`

**Topics**:
- Document loading and chunking
- Local embeddings (HuggingFace)
- Vector store (Chroma)
- RAG pipeline with Ollama
- Source attribution

#### Lab 2.2: RAG with watsonx.ai

| Notebook | Description | Status |
|----------|-------------|--------|
| `starter_notebook.ipynb` | Starter template for watsonx RAG | 📝 To create |
| `solution_notebook.ipynb` | Complete watsonx RAG solution | 📝 To create |

**Path**: `docs/assets/notebooks/day2/lab_2.2_rag_watsonx/`

**Topics**:
- watsonx.ai authentication
- Granite models
- watsonx embeddings
- Enterprise vector stores
- Production-ready RAG

#### Lab 2.3: Twin RAG Pipelines

| Notebook | Description | Status |
|----------|-------------|--------|
| `starter_notebook.ipynb` | Compare Ollama vs watsonx | 📝 To create |
| `solution_notebook.ipynb` | Complete comparison solution | 📝 To create |

**Path**: `docs/assets/notebooks/day2/lab_2.3_twin_pipelines/`

**Topics**:
- Side-by-side comparison
- Performance metrics
- Quality evaluation
- Trade-off analysis

#### Lab 2.4: RAG Evaluation Harness

| Notebook | Description | Status |
|----------|-------------|--------|
| `starter_notebook.ipynb` | Evaluation framework starter | 📝 To create |
| `solution_notebook.ipynb` | Complete evaluation system | 📝 To create |

**Path**: `docs/assets/notebooks/day2/lab_2.4_evaluation_harness/`

**Topics**:
- Ground truth datasets
- Retrieval metrics (Precision, Recall, F1)
- Answer quality metrics (ROUGE, semantic similarity)
- Automated testing

#### Reference Notebooks

| Notebook | Description | Status |
|----------|-------------|--------|
| `elasticsearch_watsonx_example.ipynb` | Enterprise RAG with Elasticsearch | ✅ Complete |

**Path**: `docs/assets/notebooks/day2/reference_notebooks/`

**Topics**:
- Elasticsearch vector search
- watsonx.ai integration
- Production deployment patterns
- Scalable architecture

### Day 3: Orchestration and Agents

| Notebook | Description | Lab | Status |
|----------|-------------|-----|--------|
| `agent_watsonx.ipynb` | Agent with watsonx + RAG | Lab 3.1 | ✅ Exists |
| `agent_crewai.ipynb` | CrewAI multi-agent framework | Lab 3.2 | ✅ Exists |
| `agent_langgraph.ipynb` | LangGraph workflow framework | Lab 3.2 | ✅ Exists |

**Path**: `docs/assets/notebooks/day3/`

**Topics**:
- Tool-using agents
- Multi-agent systems
- Workflow orchestration
- Production agent patterns

## 🎯 Existing Production Notebooks

These notebooks already exist in other directories and demonstrate production patterns:

### labs-src/ (5 notebooks)

1. `use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`
2. `use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`
3. `use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb`
4. `ibm-watsonx-governance-evaluation-studio-getting-started.ipynb`
5. `ibm-watsonx-governance-governed-agentic-catalog.ipynb`

### accelerator/assets/notebook/ (7 notebooks)

1. `notebook:Process_and_Ingest_Data_into_Vector_DB.ipynb`
2. `notebook:QnA_with_RAG.ipynb`
3. `notebook:Test_Queries_for_Vector_DB.ipynb`
4. `notebook:Create_and_Deploy_QnA_AI_Service.ipynb`
5. `notebook:Analyze_Log_and_Feedback.ipynb`
6. `notebook:Process_and_Ingest_Data_from_COS_into_vector_DB.ipynb`
7. `notebook:Ingestion_of_Expert_Profile_data_to_Vector_DB.ipynb`

## 🚀 Quick Start Guide

### For Students

**Day 1 Labs**:
1. Start with `prompt_patterns_ollama.ipynb`
2. Continue with `prompt_patterns_watsonx.ipynb`
3. Complete with `micro_evaluation.ipynb`

**Day 2 Labs**:
1. Lab 2.1: Open `lab_2.1_local_rag_ollama/starter_notebook.ipynb`
2. Lab 2.2: TBD - watsonx RAG (coming soon)
3. Lab 2.3: TBD - Comparison (coming soon)
4. Lab 2.4: TBD - Evaluation (coming soon)

**Day 3 Labs**:
1. Explore `agent_watsonx.ipynb`
2. Try framework examples: `agent_crewai.ipynb`, `agent_langgraph.ipynb`

### For Instructors

- Solutions are provided in `solution_notebook.ipynb` files
- Use starter notebooks for guided instruction
- Reference notebooks demonstrate production patterns
- All notebooks include learning objectives and key takeaways

## 📊 Notebook Status Summary

| Category | Complete | In Progress | Planned | Total |
|----------|----------|-------------|---------|-------|
| Day 0 | 0 | 0 | 1 | 1 |
| Day 1 | 3 | 0 | 0 | 3 |
| Day 2 Labs | 3 | 0 | 6 | 9 |
| Day 3 | 3 | 0 | 0 | 3 |
| **Total** | **9** | **0** | **7** | **16** |

### Additional Production Notebooks

- **labs-src**: 5 notebooks (RAG examples, governance)
- **accelerator**: 7 notebooks (production deployment)
- **Total Production**: 12 notebooks

## 🔗 Related Documentation

- [Day 1 LLM Concepts](../../tracks/day1-llm/llm-concepts.md)
- [Day 2 RAG Architecture](../../tracks/day2-rag/Theory_01_RAG_Architecture_Overview.md)
- [Day 2 Complete Solutions](../../tracks/day2-rag/Day2_RAG_Complete_Solutions_Guide.md)
- [Day 3 Agentic AI](../../tracks/day3-orchestrate/agentic-ai-overview.md)

## 💡 Tips for Using Notebooks

### Running Locally

```bash
# Install dependencies
pip install jupyter langchain chromadb sentence-transformers ollama ibm-watsonx-ai

# Start Jupyter
jupyter notebook

# Navigate to the notebook directory
cd docs/assets/notebooks/
```

### Environment Variables

Create a `.env` file with:

```bash
# watsonx.ai credentials
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_APIKEY=your_api_key_here
WATSONX_PROJECT_ID=your_project_id

# Elasticsearch (optional)
ELASTICSEARCH_URL=http://localhost:9200
ELASTICSEARCH_USER=ruslanmv
ELASTICSEARCH_PASSWORD=your_password
```

### Prerequisites by Day

**Day 1**:
- Python 3.10+
- Ollama running locally
- watsonx.ai credentials

**Day 2**:
- All Day 1 prerequisites
- Vector database (Chroma and/or Elasticsearch)
- Additional packages: chromadb, elasticsearch

**Day 3**:
- All Day 2 prerequisites
- Agent frameworks: crewai, langgraph
- Accelerator API running (optional)

## 📝 Contributing

To add new notebooks:

1. Follow the existing structure (starter + solution)
2. Include learning objectives
3. Add code comments
4. Provide key takeaways
5. Update this README

## 🏗️ Future Enhancements

### Planned Notebooks

- [ ] Lab 2.2 starter and solution (watsonx RAG)
- [ ] Lab 2.3 starter and solution (Twin pipelines)
- [ ] Lab 2.4 starter and solution (Evaluation harness)
- [ ] Day 0 environment verification template
- [ ] Advanced RAG techniques notebook
- [ ] Multi-modal RAG notebook
- [ ] Hybrid search notebook

### Potential Additions

- Interactive widgets for parameter tuning
- Automated testing cells
- Performance benchmarking
- Cost estimation calculators
- Cloud deployment guides

## 📞 Support

For issues or questions about notebooks:

1. Check the solution notebooks for reference
2. Review the documentation links above
3. Consult the troubleshooting section in each notebook
4. Reach out via workshop Slack channel

## 📄 License

All notebooks are part of the watsonx workshop series.
Copyright © 2025 - Ruslan Magana Vsevolodovna
---

**Last Updated**: January 2025
**Maintained By**: watsonx Workshop Team
