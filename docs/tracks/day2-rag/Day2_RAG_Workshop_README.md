# Day 2 – RAG Workshop
## Complete Guide

---

## Workshop Overview {data-background-color="#0f172a"}

Master Retrieval Augmented Generation

### Tutor

**Ruslan Idelfonso Magana Vsevolodovna**  
*PhD in Physics · AI Engineer*  

📧 [contact@ruslamv.com](mailto:contact@ruslamv.com)

<p style="text-align:right; margin-top:1.5rem;">
  <img
    src="../../../themes/assets/tutor.png"
    alt="Tutor: Ruslan Idelfonso Magana Vsevolodovna"
    style="
      border-radius:50%;
      width:130px;
      height:130px;
      object-fit:cover;
      box-shadow:0 12px 30px rgba(0,0,0,0.45);
      border:3px solid rgba(248,250,252,0.9);
    "
  >
</p>

::: notes
Welcome to Day 2. Building on Day 1 LLM foundations.
:::

---

### Workshop Structure

**Duration:** 8 hours total

<span class="fragment">Morning Session (4 hours): Theory and Concepts</span>

<span class="fragment">Afternoon Session (4 hours): Hands-on Labs</span>

::: notes
Balanced approach. Learn concepts, then apply them.
:::

---

### Workshop Objective

<span class="fragment">Master Retrieval Augmented Generation (RAG) implementation</span>

<span class="fragment">Using local models (Ollama)</span>

<span class="fragment">Using watsonx.ai</span>

<span class="fragment">With evaluation and production deployment patterns</span>

::: notes
Complete RAG skill set by end of day
:::

---

## 📚 Part 1: Theory (4 hours) {data-background-color="#1e1e1e"}

Building conceptual foundation

---

### Module 1: RAG Architecture Overview (1 hour)

**What is RAG?**
<span class="fragment">Definition and motivation</span>
<span class="fragment">Reducing hallucinations through grounding</span>
<span class="fragment">Real-world use cases</span>

::: notes
Start with the why before the how
:::

---

### Module 1: Core Components

<span class="fragment">Document store and corpus management</span>

<span class="fragment">Chunking strategies</span>

<span class="fragment">Embedding models</span>

<span class="fragment">Vector databases</span>

<span class="fragment">Retrieval mechanisms</span>

<span class="fragment">LLM integration</span>

::: notes
Six core components. Each one critical.
:::

---

### Module 1: RAG Pipeline Flow

<span class="fragment">Ingestion phase</span>

<span class="fragment">Indexing phase</span>

<span class="fragment">Retrieval phase</span>

<span class="fragment">Generation phase</span>

::: notes
Four-phase pipeline. Memorize this flow.
:::

---

### Module 1: Trade-offs and Considerations

<span class="fragment">Latency vs accuracy</span>

<span class="fragment">Embedding model selection</span>

<span class="fragment">Index size and refresh strategies</span>

::: notes
Engineering decisions with real consequences
:::

---

### Module 2: Embedding Models (45 minutes) {data-background-color="#0f172a"}

Understanding semantic representations

---

### Embedding Topics

<span class="fragment">Understanding dense vector representations</span>

<span class="fragment">Popular embedding models (sentence-transformers, OpenAI, watsonx)</span>

<span class="fragment">Embedding dimensions and trade-offs</span>

<span class="fragment">Semantic similarity metrics</span>

::: notes
Deep dive into how text becomes numbers
:::

---

### Module 3: Vector Databases (1 hour) {data-background-color="#1e1e1e"}

Specialized storage for embeddings

---

### Vector Database Topics

<span class="fragment">Introduction to vector stores</span>

<span class="fragment">**Chroma:** Local lightweight option</span>

<span class="fragment">**Elasticsearch:** Production-grade distributed search</span>

<span class="fragment">**FAISS:** High-performance similarity search</span>

<span class="fragment">Index types and search strategies</span>

::: notes
Different tools for different scales and requirements
:::

---

### Module 4: Accelerator Architecture (1h 15min) {data-background-color="#0f172a"}

Production deployment patterns

---

### Accelerator Components

<span class="fragment">Ingestion tools (`chunk.py`, `extract.py`, `embed_index.py`)</span>

<span class="fragment">Retrieval components (`retriever.py`)</span>

<span class="fragment">Pipeline orchestration (`pipeline.py`)</span>

<span class="fragment">Prompt templates (`prompt.py`)</span>

<span class="fragment">Production deployment patterns</span>

::: notes
How to structure production-ready RAG systems
:::

---

## 🔬 Part 2: Hands-on Labs (4 hours) {data-background-color="#1e1e1e" data-transition="zoom"}

Apply what you learned

---

### Lab 2.1: Local RAG with Ollama (1 hour)

**Objective:** Build complete RAG pipeline using local Ollama models

---

### Lab 2.1: What You'll Build

<span class="fragment">Document corpus preparation</span>

<span class="fragment">Local embedding generation</span>

<span class="fragment">Chroma vector store setup</span>

<span class="fragment">Query-response pipeline</span>

<span class="fragment">Source attribution</span>

::: notes
End-to-end RAG in one lab. Foundation for everything else.
:::

---

### Lab 2.1: Skills Learned

<span class="fragment">Chunking strategies</span>

<span class="fragment">Local vector store management</span>

<span class="fragment">Ollama model integration</span>

<span class="fragment">End-to-end RAG flow</span>

::: notes
Practical skills you'll use in every RAG project
:::

---

### Lab 2.2: RAG with watsonx.ai (1 hour) {data-background-color="#0f172a"}

**Objective:** Implement enterprise-grade RAG using IBM watsonx.ai

---

### Lab 2.2: What You'll Build

<span class="fragment">watsonx.ai authentication setup</span>

<span class="fragment">Granite model integration</span>

<span class="fragment">Elasticsearch vector store</span>

<span class="fragment">Production-ready retrieval</span>

<span class="fragment">Performance comparison</span>

::: notes
Scale up from local to enterprise-grade
:::

---

### Lab 2.2: Skills Learned

<span class="fragment">watsonx.ai API usage</span>

<span class="fragment">Enterprise vector store setup</span>

<span class="fragment">Prompt engineering for Granite</span>

<span class="fragment">Scalable RAG patterns</span>

::: notes
Enterprise skills for production deployment
:::

---

### Lab 2.3: Twin RAG Pipelines (1 hour) {data-background-color="#1e1e1e"}

**Objective:** Compare Ollama and watsonx implementations side-by-side

---

### Lab 2.3: What You'll Build

<span class="fragment">Unified comparison framework</span>

<span class="fragment">Test query suite</span>

<span class="fragment">Results aggregation</span>

<span class="fragment">Qualitative analysis</span>

::: notes
Learn to evaluate different approaches scientifically
:::

---

### Lab 2.3: Skills Learned

<span class="fragment">Multi-backend orchestration</span>

<span class="fragment">Comparative evaluation</span>

<span class="fragment">Response quality assessment</span>

<span class="fragment">Trade-off analysis</span>

::: notes
Critical thinking about RAG system design
:::

---

### Lab 2.4: RAG Evaluation Harness (1 hour) {data-background-color="#0f172a"}

**Objective:** Build automated evaluation pipeline for RAG systems

---

### Lab 2.4: What You'll Build

<span class="fragment">Ground truth dataset</span>

<span class="fragment">Retrieval metrics (hit rate, precision@k)</span>

<span class="fragment">Answer quality metrics (ROUGE, semantic similarity)</span>

<span class="fragment">Automated scoring pipeline</span>

<span class="fragment">Visualization dashboard</span>

::: notes
Production RAG requires measurement and monitoring
:::

---

### Lab 2.4: Skills Learned

<span class="fragment">RAG evaluation methodologies</span>

<span class="fragment">Metrics computation</span>

<span class="fragment">Automated testing</span>

<span class="fragment">Performance tracking</span>

::: notes
Essential for continuous improvement
:::

---

## Prerequisites {data-background-color="#1e1e1e" data-transition="slide"}

Ensure you're ready

---

### Required Knowledge

<span class="fragment">Python programming (intermediate level)</span>

<span class="fragment">Basic understanding of LLMs</span>

<span class="fragment">Familiarity with APIs</span>

<span class="fragment">Command line basics</span>

::: notes
Self-assess before starting. Ask for help if gaps exist.
:::

---

### Technical Setup {data-background-color="#0f172a"}

Software requirements

---

### Install Core Dependencies

```bash {data-line-numbers="1-2|4-9"}
# Python 3.10 or higher
python --version

# Install core dependencies
pip install langchain langchain-community
pip install sentence-transformers
pip install chromadb
pip install ollama
pip install ibm-watsonx-ai
```

::: notes
Run these before workshop starts. Save time.
:::

---

### Additional Dependencies

```bash {data-line-numbers="1-2|3|4"}
pip install elasticsearch
pip install pandas numpy
pip install rouge-score evaluate
```

::: notes
For enterprise labs and evaluation
:::

---

### Environment Setup: Ollama

```bash {data-line-numbers="1-2|4-6"}
# Install Ollama
curl https://ollama.ai/install.sh | sh

# Pull models
ollama pull llama2
ollama pull mistral
```

::: notes
Local models for Lab 2.1. Test before workshop.
:::

---

### Environment Setup: watsonx.ai

<span class="fragment">IBM Cloud account</span>

<span class="fragment">watsonx.ai service instance</span>

<span class="fragment">API key generation</span>

::: notes
Enterprise credentials. Get these in advance.
:::

---

### Credentials Configuration

Create `.env` file:

```bash {data-line-numbers="1-4|6-9"}
# watsonx.ai credentials
WATSONX_APIKEY=your_api_key_here
WATSONX_PROJECT_ID=your_project_id
WATSONX_URL=https://us-south.ml.cloud.ibm.com

# Elasticsearch (if using)
ELASTICSEARCH_URL=your_elasticsearch_url
ELASTICSEARCH_USER=your_username
ELASTICSEARCH_PASSWORD=your_password
```

::: notes
Keep credentials secure. Never commit to git.
:::

---

## Workshop Materials Structure {data-background-color="#1e1e1e"}

Navigation guide

---

### Directory Structure

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
│   ├── lab_2.2_rag_watsonx/
│   ├── lab_2.3_twin_pipelines/
│   └── lab_2.4_evaluation_harness/
```

::: notes
Organized by learning phase. Easy to navigate.
:::

---

### Each Lab Contains

```
lab_2.1_local_rag_ollama/
├── lab_instructions.md
├── starter_notebook.ipynb
└── solution_notebook.ipynb
```

<span class="fragment">Clear instructions, starter code, and full solutions</span>

::: notes
Everything you need to succeed in each lab
:::

---

### Additional Materials

```
├── data/
│   ├── sample_documents/
│   ├── test_queries.csv
│   └── ground_truth.json
│
├── reference_notebooks/
│   └── elasticsearch_watsonx_example.ipynb
│
└── accelerator_integration/
    ├── chunk.py
    └── pipeline.py
```

::: notes
Extra resources for deeper learning
:::

---

## Learning Outcomes {data-background-color="#0f172a" data-transition="zoom"}

What you'll achieve

---

### By the End of This Workshop

You will be able to:

---

### Core Competencies (1-5)

<span class="fragment">1. ✅ Explain RAG architecture and components</span>

<span class="fragment">2. ✅ Implement local RAG pipelines with Ollama</span>

<span class="fragment">3. ✅ Build enterprise RAG systems with watsonx.ai</span>

<span class="fragment">4. ✅ Choose appropriate embedding models and vector stores</span>

<span class="fragment">5. ✅ Implement effective chunking strategies</span>

::: notes
Foundation skills for any RAG project
:::

---

### Advanced Competencies (6-10)

<span class="fragment">6. ✅ Evaluate RAG system performance</span>

<span class="fragment">7. ✅ Compare different RAG implementations</span>

<span class="fragment">8. ✅ Deploy production-grade RAG services</span>

<span class="fragment">9. ✅ Integrate with the AI Accelerator framework</span>

<span class="fragment">10. ✅ Monitor and improve RAG systems</span>

::: notes
Production-ready skills for enterprise deployment
:::

---

## Workshop Timeline {data-background-color="#1e1e1e"}

Detailed schedule

---

### Morning Session (9:00 AM - 1:00 PM)

| Time | Activity | Duration |
|------|----------|----------|
| 9:00 - 10:00 | Module 1: RAG Architecture | 60 min |
| 10:00 - 10:45 | Module 2: Embedding Models | 45 min |
| 10:45 - 11:00 | ☕ Break | 15 min |

::: notes
Theory foundation in the morning
:::

---

### Morning Session (Continued)

| Time | Activity | Duration |
|------|----------|----------|
| 11:00 - 12:00 | Module 3: Vector Databases | 60 min |
| 12:00 - 1:00 | Module 4: Accelerator | 60 min |

::: notes
Complete theory by lunch
:::

---

### Afternoon Session (2:00 PM - 6:00 PM)

| Time | Activity | Duration |
|------|----------|----------|
| 2:00 - 3:00 | Lab 2.1: Local RAG | 60 min |
| 3:00 - 4:00 | Lab 2.2: watsonx RAG | 60 min |
| 4:00 - 4:15 | ☕ Break | 15 min |

::: notes
Hands-on practice in the afternoon
:::

---

### Afternoon Session (Continued)

| Time | Activity | Duration |
|------|----------|----------|
| 4:15 - 5:15 | Lab 2.3: Twin Pipelines | 60 min |
| 5:15 - 6:00 | Lab 2.4: Evaluation | 45 min |

::: notes
Build toward production-ready systems
:::

---

## Additional Resources {data-background-color="#0f172a"}

Expand your learning

---

### Documentation

<span class="fragment">LangChain: https://python.langchain.com/docs/get_started/introduction</span>

<span class="fragment">watsonx.ai: https://ibm.com/docs/watsonx-as-a-service</span>

<span class="fragment">Chroma: https://docs.trychroma.com/</span>

<span class="fragment">Elasticsearch Vector Search: https://elastic.co/guide/</span>

::: notes
Official documentation. Bookmark these.
:::

---

### Example Repositories

<span class="fragment">IBM Watson ML Samples: GitHub</span>

<span class="fragment">LangChain Templates: GitHub</span>

::: notes
Learn from working examples
:::

---

### Research Papers

<span class="fragment">"Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020)</span>

<span class="fragment">"Dense Passage Retrieval for Open-Domain QA" (Karpukhin et al., 2020)</span>

::: notes
Foundational research. Understand the theory.
:::

---

## Support and Troubleshooting {data-background-color="#1e1e1e"}

Get help when needed

---

### Common Issue 1: Ollama Connection Errors

<span class="fragment">Ensure Ollama service is running: `ollama serve`</span>

<span class="fragment">Check model is pulled: `ollama list`</span>

::: notes
Most common local development issue
:::

---

### Common Issue 2: watsonx.ai Authentication

<span class="fragment">Verify API key is correct</span>

<span class="fragment">Check project/space permissions</span>

<span class="fragment">Ensure region matches your instance</span>

::: notes
Enterprise credential issues
:::

---

### Common Issue 3: Vector Store Issues

<span class="fragment">Elasticsearch connection timeouts: Check network/firewall</span>

<span class="fragment">Chroma persistence: Verify directory permissions</span>

<span class="fragment">Out of memory: Reduce batch size or chunk count</span>

::: notes
Database-related problems
:::

---

### Common Issue 4: Performance Issues

<span class="fragment">Slow embedding: Use smaller models or GPU acceleration</span>

<span class="fragment">Large index size: Implement incremental updates</span>

<span class="fragment">Query latency: Optimize retrieval parameters (top_k, threshold)</span>

::: notes
Production performance tuning
:::

---

### Getting Help

<span class="fragment">Workshop facilitators: Available during lab sessions</span>

<span class="fragment">Slack channel: #day2-rag-workshop</span>

<span class="fragment">Office hours: Schedule via workshop portal</span>

::: notes
Multiple support channels available
:::

---

## Next Steps After Workshop {data-background-color="#0f172a"}

Continue your learning journey

---

### Immediate Actions

<span class="fragment">1. Implement your own use case</span>

<span class="fragment">2. Customize chunking strategy for your domain</span>

<span class="fragment">3. Fine-tune retrieval parameters</span>

::: notes
Apply to your actual work immediately
:::

---

### Production Deployment

<span class="fragment">1. Review accelerator deployment patterns</span>

<span class="fragment">2. Set up monitoring and logging</span>

<span class="fragment">3. Implement user feedback loops</span>

::: notes
Move from prototype to production
:::

---

### Advanced Topics (Day 3)

<span class="fragment">Multi-modal RAG</span>

<span class="fragment">Agentic RAG systems</span>

<span class="fragment">Governed AI tooling</span>

<span class="fragment">Advanced evaluation techniques</span>

::: notes
Next level of RAG mastery
:::

---

## Workshop Survey {data-background-color="#1e1e1e"}

Your feedback helps us improve

<span class="fragment">Survey Link: [To be provided]</span>

::: notes
Please complete the survey. Your input is valuable.
:::

---

## Ready to Begin! {data-background-color="#0f172a" data-transition="zoom"}

**Workshop Version**: 1.0
**Last Updated**: January 2025
**Maintained by**: IBM watsonx.ai Education Team

Let's build amazing RAG systems! 🚀

::: notes
Energy and enthusiasm. Set positive tone for the day.
:::