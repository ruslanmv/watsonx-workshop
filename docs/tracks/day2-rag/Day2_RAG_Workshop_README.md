# Day 2 – RAG Workshop: Complete Guide

## Workshop Overview

**Duration**: 8 hours total
- **Morning Session (4 hours)**: Theory and Concepts
- **Afternoon Session (4 hours)**: Hands-on Labs

**Objective**: Master Retrieval Augmented Generation (RAG) implementation using local models (Ollama) and watsonx.ai, with evaluation and production deployment patterns.

---

## Workshop Structure

### 📚 Part 1: Theory (4 hours)

#### Module 1: RAG Architecture Overview (1 hour)
- **What is RAG?**
  - Definition and motivation
  - Reducing hallucinations through grounding
  - Real-world use cases
  
- **Core Components**
  - Document store and corpus management
  - Chunking strategies
  - Embedding models
  - Vector databases
  - Retrieval mechanisms
  - LLM integration

- **RAG Pipeline Flow**
  - Ingestion phase
  - Indexing phase
  - Retrieval phase
  - Generation phase

- **Trade-offs and Considerations**
  - Latency vs accuracy
  - Embedding model selection
  - Index size and refresh strategies

#### Module 2: Embedding Models (45 minutes)
- Understanding dense vector representations
- Popular embedding models (sentence-transformers, OpenAI, watsonx)
- Embedding dimensions and trade-offs
- Semantic similarity metrics

#### Module 3: Vector Databases (1 hour)
- Introduction to vector stores
- Chroma: Local lightweight option
- Elasticsearch: Production-grade distributed search
- FAISS: High-performance similarity search
- Index types and search strategies

#### Module 4: Accelerator Architecture (1 hour 15 minutes)
- Ingestion tools (`chunk.py`, `extract.py`, `embed_index.py`)
- Retrieval components (`retriever.py`)
- Pipeline orchestration (`pipeline.py`)
- Prompt templates (`prompt.py`)
- Production deployment patterns

---

### 🔬 Part 2: Hands-on Labs (4 hours)

#### Lab 2.1: Local RAG with Ollama (1 hour)
**Objective**: Build a complete RAG pipeline using local Ollama models

**What You'll Build**:
- Document corpus preparation
- Local embedding generation
- Chroma vector store setup
- Query-response pipeline
- Source attribution

**Skills Learned**:
- Chunking strategies
- Local vector store management
- Ollama model integration
- End-to-end RAG flow

#### Lab 2.2: RAG with watsonx.ai (1 hour)
**Objective**: Implement enterprise-grade RAG using IBM watsonx.ai

**What You'll Build**:
- watsonx.ai authentication setup
- Granite model integration
- Elasticsearch vector store
- Production-ready retrieval
- Performance comparison

**Skills Learned**:
- watsonx.ai API usage
- Enterprise vector store setup
- Prompt engineering for Granite
- Scalable RAG patterns

#### Lab 2.3: Twin RAG Pipelines (1 hour)
**Objective**: Compare Ollama and watsonx implementations side-by-side

**What You'll Build**:
- Unified comparison framework
- Test query suite
- Results aggregation
- Qualitative analysis

**Skills Learned**:
- Multi-backend orchestration
- Comparative evaluation
- Response quality assessment
- Trade-off analysis

#### Lab 2.4: RAG Evaluation Harness (1 hour)
**Objective**: Build automated evaluation pipeline for RAG systems

**What You'll Build**:
- Ground truth dataset
- Retrieval metrics (hit rate, precision@k)
- Answer quality metrics (ROUGE, semantic similarity)
- Automated scoring pipeline
- Visualization dashboard

**Skills Learned**:
- RAG evaluation methodologies
- Metrics computation
- Automated testing
- Performance tracking

---

## Prerequisites

### Required Knowledge
- Python programming (intermediate level)
- Basic understanding of LLMs
- Familiarity with APIs
- Command line basics

### Technical Setup

#### Software Requirements
```bash
# Python 3.10 or higher
python --version

# Install core dependencies
pip install langchain langchain-community
pip install sentence-transformers
pip install chromadb
pip install ollama
pip install ibm-watsonx-ai
pip install elasticsearch
pip install pandas numpy
pip install rouge-score evaluate
```

#### Environment Setup
1. **Ollama Installation** (for local labs)
   ```bash
   # Install Ollama
   curl https://ollama.ai/install.sh | sh
   
   # Pull models
   ollama pull llama2
   ollama pull mistral
   ```

2. **watsonx.ai Access** (for enterprise labs)
   - IBM Cloud account
   - watsonx.ai service instance
   - API key generation

3. **Vector Store Setup**
   - Chroma: Included with Python install
   - Elasticsearch: Docker or cloud instance

#### Credentials Configuration
Create `.env` file:
```bash
# watsonx.ai credentials
WATSONX_APIKEY=your_api_key_here
WATSONX_PROJECT_ID=your_project_id
WATSONX_URL=https://us-south.ml.cloud.ibm.com

# Elasticsearch (if using)
ELASTICSEARCH_URL=your_elasticsearch_url
ELASTICSEARCH_USER=your_username
ELASTICSEARCH_PASSWORD=your_password

# OpenAI (if using)
OPENAI_API_KEY=your_openai_key
```

---

## Workshop Materials Structure

```
day2-rag-workshop/
├── theory/
│   ├── 01_rag_architecture_overview.md
│   ├── 02_embedding_models.md
│   ├── 03_vector_databases.md
│   └── 04_accelerator_architecture.md
│
├── labs/
│   ├── lab_2.1_local_rag_ollama/
│   │   ├── lab_instructions.md
│   │   ├── starter_notebook.ipynb
│   │   └── solution_notebook.ipynb
│   │
│   ├── lab_2.2_rag_watsonx/
│   │   ├── lab_instructions.md
│   │   ├── starter_notebook.ipynb
│   │   └── solution_notebook.ipynb
│   │
│   ├── lab_2.3_twin_pipelines/
│   │   ├── lab_instructions.md
│   │   ├── starter_notebook.ipynb
│   │   └── solution_notebook.ipynb
│   │
│   └── lab_2.4_evaluation_harness/
│       ├── lab_instructions.md
│       ├── starter_notebook.ipynb
│       └── solution_notebook.ipynb
│
├── data/
│   ├── sample_documents/
│   ├── test_queries.csv
│   └── ground_truth.json
│
├── reference_notebooks/
│   ├── elasticsearch_watsonx_example.ipynb
│   ├── chroma_langchain_example.ipynb
│   └── evaluation_studio_example.ipynb
│
└── accelerator_integration/
    ├── chunk.py
    ├── embed_index.py
    ├── retriever.py
    ├── pipeline.py
    └── prompt.py
```

---

## Learning Outcomes

By the end of this workshop, you will be able to:

1. ✅ Explain RAG architecture and components
2. ✅ Implement local RAG pipelines with Ollama
3. ✅ Build enterprise RAG systems with watsonx.ai
4. ✅ Choose appropriate embedding models and vector stores
5. ✅ Implement effective chunking strategies
6. ✅ Evaluate RAG system performance
7. ✅ Compare different RAG implementations
8. ✅ Deploy production-grade RAG services
9. ✅ Integrate with the AI Accelerator framework
10. ✅ Monitor and improve RAG systems

---

## Workshop Timeline

### Morning Session (9:00 AM - 1:00 PM)

| Time | Activity | Duration |
|------|----------|----------|
| 9:00 - 10:00 | Module 1: RAG Architecture Overview | 60 min |
| 10:00 - 10:45 | Module 2: Embedding Models | 45 min |
| 10:45 - 11:00 | ☕ Break | 15 min |
| 11:00 - 12:00 | Module 3: Vector Databases | 60 min |
| 12:00 - 1:00 | Module 4: Accelerator Architecture | 60 min |

### Afternoon Session (2:00 PM - 6:00 PM)

| Time | Activity | Duration |
|------|----------|----------|
| 2:00 - 3:00 | Lab 2.1: Local RAG with Ollama | 60 min |
| 3:00 - 4:00 | Lab 2.2: RAG with watsonx.ai | 60 min |
| 4:00 - 4:15 | ☕ Break | 15 min |
| 4:15 - 5:15 | Lab 2.3: Twin RAG Pipelines | 60 min |
| 5:15 - 6:00 | Lab 2.4: Evaluation Harness | 45 min |

---

## Additional Resources

### Documentation
- [LangChain Documentation](https://python.langchain.com/docs/get_started/introduction)
- [watsonx.ai Documentation](https://www.ibm.com/docs/en/watsonx-as-a-service)
- [Chroma Documentation](https://docs.trychroma.com/)
- [Elasticsearch Vector Search](https://www.elastic.co/guide/en/elasticsearch/reference/current/knn-search.html)

### Example Repositories
- IBM Watson ML Samples: [GitHub](https://github.com/IBM/watson-machine-learning-samples)
- LangChain Templates: [GitHub](https://github.com/langchain-ai/langchain/tree/master/templates)

### Research Papers
- "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020)
- "Dense Passage Retrieval for Open-Domain Question Answering" (Karpukhin et al., 2020)

---

## Support and Troubleshooting

### Common Issues

1. **Ollama Connection Errors**
   - Ensure Ollama service is running: `ollama serve`
   - Check model is pulled: `ollama list`

2. **watsonx.ai Authentication**
   - Verify API key is correct
   - Check project/space permissions
   - Ensure region matches your instance

3. **Vector Store Issues**
   - Elasticsearch connection timeouts: Check network/firewall
   - Chroma persistence: Verify directory permissions
   - Out of memory: Reduce batch size or chunk count

4. **Performance Issues**
   - Slow embedding: Use smaller models or GPU acceleration
   - Large index size: Implement incremental updates
   - Query latency: Optimize retrieval parameters (top_k, similarity threshold)

### Getting Help
- Workshop facilitators: Available during lab sessions
- Slack channel: #day2-rag-workshop
- Office hours: Schedule via workshop portal

---

## Next Steps After Workshop

1. **Implement Your Use Case**
   - Identify your domain documents
   - Customize chunking strategy
   - Fine-tune retrieval parameters

2. **Production Deployment**
   - Review accelerator deployment patterns
   - Set up monitoring and logging
   - Implement user feedback loops

3. **Advanced Topics** (Day 3)
   - Multi-modal RAG
   - Agentic RAG systems
   - Governed AI tooling
   - Advanced evaluation techniques

---

## Feedback

Please complete the workshop survey: [Survey Link]

Your feedback helps us improve future workshops!

---

**Workshop Version**: 1.0  
**Last Updated**: January 2025  
**Maintained by**: IBM watsonx.ai Education Team
