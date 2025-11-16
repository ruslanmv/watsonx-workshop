# 📓 Workshop Notebooks Index

Complete guide to all Jupyter notebooks in the watsonx workshop series.

## 🎯 Quick Access

| Workshop Day | Notebooks | Location | Status |
|--------------|-----------|----------|--------|
| **Day 0** | Environment Setup | External repos | ✅ Available |
| **Day 1** | LLM & Prompting (3 notebooks) | [/docs/assets/notebooks/day1](assets/notebooks/day1/) | ✅ Complete |
| **Day 2** | RAG Systems (9 notebooks) | [/docs/assets/notebooks/day2](assets/notebooks/day2/) | 🚧 Partial |
| **Day 3** | Agents & Orchestration (3 notebooks) | [/docs/assets/notebooks/day3](assets/notebooks/day3/) | ✅ Complete |

## 📚 Detailed Notebook List

### Day 1: LLM Fundamentals & Prompt Engineering

**Location**: `docs/assets/notebooks/day1/`

1. **`prompt_patterns_ollama.ipynb`** ✅
   - Lab 1.2 - Part A
   - Create prompt templates with Ollama
   - Topics: Summarization, style transfer, Q&A
   - [View Notebook](assets/notebooks/day1/prompt_patterns_ollama.ipynb)

2. **`prompt_patterns_watsonx.ipynb`** ✅
   - Lab 1.2 - Part B
   - Create prompt templates with watsonx.ai
   - Topics: Granite model usage, enterprise patterns
   - [View Notebook](assets/notebooks/day1/prompt_patterns_watsonx.ipynb)

3. **`micro_evaluation.ipynb`** ✅
   - Lab 1.3
   - Build systematic evaluation framework
   - Topics: Metrics, comparison, analysis
   - [View Notebook](assets/notebooks/day1/micro_evaluation.ipynb)

### Day 2: Retrieval-Augmented Generation (RAG)

#### Lab 2.1: Local RAG with Ollama

**Location**: `docs/assets/notebooks/day2/lab_2.1_local_rag_ollama/`

1. **`starter_notebook.ipynb`** ✅
   - Guided lab with TODOs
   - Build RAG from scratch
   - [View Notebook](assets/notebooks/day2/lab_2.1_local_rag_ollama/starter_notebook.ipynb)

2. **`solution_notebook.ipynb`** ✅
   - Complete working solution
   - Reference implementation
   - [View Notebook](assets/notebooks/day2/lab_2.1_local_rag_ollama/solution_notebook.ipynb)

#### Lab 2.2: RAG with watsonx.ai

**Location**: `docs/assets/notebooks/day2/lab_2.2_rag_watsonx/`

1. **`starter_notebook.ipynb`** 📝 *To be created*
   - Enterprise RAG with watsonx
   - Granite models

2. **`solution_notebook.ipynb`** 📝 *To be created*
   - Complete watsonx RAG solution

#### Lab 2.3: Twin RAG Pipelines

**Location**: `docs/assets/notebooks/day2/lab_2.3_twin_pipelines/`

1. **`starter_notebook.ipynb`** 📝 *To be created*
   - Compare Ollama vs watsonx

2. **`solution_notebook.ipynb`** 📝 *To be created*
   - Complete comparison framework

#### Lab 2.4: RAG Evaluation Harness

**Location**: `docs/assets/notebooks/day2/lab_2.4_evaluation_harness/`

1. **`starter_notebook.ipynb`** 📝 *To be created*
   - Automated evaluation pipeline

2. **`solution_notebook.ipynb`** 📝 *To be created*
   - Complete evaluation system

#### Reference Notebooks

**Location**: `docs/assets/notebooks/day2/reference_notebooks/`

1. **`elasticsearch_watsonx_example.ipynb`** ✅
   - Production RAG with Elasticsearch
   - watsonx.ai integration
   - Scalable architecture
   - [View Notebook](assets/notebooks/day2/reference_notebooks/elasticsearch_watsonx_example.ipynb)

### Day 3: Orchestration & Agents

**Location**: `docs/assets/notebooks/day3/`

1. **`agent_watsonx.ipynb`** ✅
   - Lab 3.1
   - Build agent with watsonx
   - Tool-using patterns
   - [View Notebook](assets/notebooks/day3/agent_watsonx.ipynb)

2. **`agent_crewai.ipynb`** ✅
   - Lab 3.2 - CrewAI Framework
   - Multi-agent systems
   - [View Notebook](assets/notebooks/day3/agent_crewai.ipynb)

3. **`agent_langgraph.ipynb`** ✅
   - Lab 3.2 - LangGraph Framework
   - Workflow orchestration
   - [View Notebook](assets/notebooks/day3/agent_langgraph.ipynb)

## 🏭 Production Notebooks

### In labs-src/

Complete RAG implementations and governance examples:

1. `use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`
2. `use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`
3. `use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb`
4. `ibm-watsonx-governance-evaluation-studio-getting-started.ipynb`
5. `ibm-watsonx-governance-governed-agentic-catalog.ipynb`

### In accelerator/assets/notebook/

Production deployment patterns:

1. `notebook:Process_and_Ingest_Data_into_Vector_DB.ipynb`
2. `notebook:QnA_with_RAG.ipynb`
3. `notebook:Test_Queries_for_Vector_DB.ipynb`
4. `notebook:Create_and_Deploy_QnA_AI_Service.ipynb`
5. `notebook:Analyze_Log_and_Feedback.ipynb`
6. `notebook:Process_and_Ingest_Data_from_COS_into_vector_DB.ipynb`
7. `notebook:Ingestion_of_Expert_Profile_data_to_Vector_DB.ipynb`

## 📊 Workshop Progress Tracker

### Completed ✅ (12 notebooks)

- Day 1: 3/3 notebooks
- Day 2: 3/9 notebooks (Lab 2.1 + elasticsearch reference)
- Day 3: 3/3 notebooks
- Production: 12 notebooks (labs-src + accelerator)

### In Development 📝 (6 notebooks)

- Day 2 Lab 2.2: 2 notebooks (starter + solution)
- Day 2 Lab 2.3: 2 notebooks (starter + solution)
- Day 2 Lab 2.4: 2 notebooks (starter + solution)

## 🚀 Getting Started

### Prerequisites

```bash
# Core dependencies
pip install jupyter langchain chromadb sentence-transformers
pip install ollama ibm-watsonx-ai elasticsearch pandas numpy

# Agent frameworks (Day 3)
pip install crewai langgraph
```

### Environment Setup

Create `.env` file:

```bash
# watsonx.ai
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_APIKEY=your_api_key
WATSONX_PROJECT_ID=your_project_id

# Elasticsearch (optional)
ELASTICSEARCH_URL=http://localhost:9200
ELASTICSEARCH_USER=username
ELASTICSEARCH_PASSWORD=password
```

### Running Notebooks

```bash
# Start Jupyter
jupyter notebook

# Or use JupyterLab
jupyter lab

# Navigate to notebooks directory
cd docs/assets/notebooks/
```

## 📖 Learning Paths

### Path 1: Complete Workshop (Recommended)

1. **Day 1**: `prompt_patterns_ollama.ipynb` → `prompt_patterns_watsonx.ipynb` → `micro_evaluation.ipynb`
2. **Day 2**: Lab 2.1 → Lab 2.2 → Lab 2.3 → Lab 2.4
3. **Day 3**: `agent_watsonx.ipynb` → Framework examples
4. **Production**: Explore labs-src and accelerator notebooks

### Path 2: Quick Start (Local Only)

1. `prompt_patterns_ollama.ipynb`
2. `lab_2.1_local_rag_ollama/starter_notebook.ipynb`
3. `agent_watsonx.ipynb` (if accelerator API available)

### Path 3: Enterprise Focus (watsonx.ai)

1. `prompt_patterns_watsonx.ipynb`
2. `elasticsearch_watsonx_example.ipynb`
3. `labs-src/use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`
4. Governance notebooks in labs-src

## 🔗 Related Resources

- [Workshop Portal](portal.md)
- [Day 1 Portal](portal/day1-portal.md)
- [Day 2 Portal](portal/day2-portal.md)
- [Day 3 Portal](portal/day3-portal.md)
- [Detailed Notebook README](assets/notebooks/README.md)

## 💡 Tips

### For Students

- Start with starter notebooks
- Check solutions only after attempting
- Experiment with different parameters
- Save your work frequently

### For Instructors

- Review solutions before class
- Use starter notebooks for live coding
- Reference production notebooks for best practices
- Encourage experimentation

## 📞 Support

- **Documentation Issues**: Check the relevant portal page
- **Code Issues**: Review solution notebooks
- **Environment Issues**: See setup guides in Day 0 docs
- **General Questions**: Workshop Slack channel

## 📈 Status Summary

| Category | Available | In Development | Total |
|----------|-----------|----------------|-------|
| Workshop Notebooks | 12 | 6 | 18 |
| Production Notebooks | 12 | 0 | 12 |
| **Grand Total** | **24** | **6** | **30** |

---

**Last Updated**: January 2025
**Maintained By**: watsonx Workshop Team
**Version**: 1.0
