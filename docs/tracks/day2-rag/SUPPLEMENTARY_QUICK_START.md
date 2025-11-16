# Day 2 Supplementary Materials
## Quick Start Guide

---

## 🎯 What's in the Supplementary Package? {data-background-color="#0f172a"}

Beyond the core workshop

::: notes
Additional IBM-specific content and advanced topics
:::

---

### Topics Covered

<span class="fragment">1. **Accelerator Project Integration** - Production code structure</span>

<span class="fragment">2. **IBM Reference Notebooks** - Examples from labs-src/</span>

<span class="fragment">3. **Docker Setup** - Container-based development</span>

<span class="fragment">4. **watsonx_quickstart.ipynb** - Environment verification</span>

<span class="fragment">5. **Governed Agentic Catalog** - Custom tool registration</span>

<span class="fragment">6. **Evaluation Studio** - Experiment tracking</span>

<span class="fragment">7. **Advanced Examples** - Banking & HR assistants</span>

::: notes
Enterprise-focused content. Production patterns.
:::

---

## 🚀 Quick Navigation {data-background-color="#1e1e1e"}

Find what you need fast

---

### I want to...

| Goal | Section | Time |
|------|---------|------|
| <span class="fragment">Understand accelerator structure</span> | <span class="fragment">Section 1</span> | <span class="fragment">10 min</span> |
| <span class="fragment">See IBM notebook examples</span> | <span class="fragment">Section 2</span> | <span class="fragment">15 min</span> |
| <span class="fragment">Set up Docker environment</span> | <span class="fragment">Section 3</span> | <span class="fragment">20 min</span> |

::: notes
Self-service navigation. Choose your path.
:::

---

### I want to... (Continued)

| Goal | Section | Time |
|------|---------|------|
| <span class="fragment">Verify watsonx setup</span> | <span class="fragment">Section 4</span> | <span class="fragment">10 min</span> |
| <span class="fragment">Register custom tools</span> | <span class="fragment">Section 5</span> | <span class="fragment">15 min</span> |
| <span class="fragment">Track experiments</span> | <span class="fragment">Section 6</span> | <span class="fragment">20 min</span> |
| <span class="fragment">Build LangGraph agent</span> | <span class="fragment">Section 7</span> | <span class="fragment">30 min</span> |

::: notes
Estimated times for planning
:::

---

## ✅ Prerequisites {data-background-color="#0f172a"}

Before using supplementary materials

---

### Required

<span class="fragment">☑ Completed main Day 2 workshop (or Labs 2.1-2.4)</span>

<span class="fragment">☑ watsonx.ai account and credentials</span>

<span class="fragment">☑ Basic understanding of RAG concepts</span>

::: notes
Build on core workshop knowledge
:::

---

### Optional

<span class="fragment">☐ Docker installed (for Section 3)</span>

<span class="fragment">☐ watsonx.governance access (for Sections 5-6)</span>

<span class="fragment">☐ Elasticsearch instance (for reference notebooks)</span>

::: notes
Enterprise features. Not required for learning.
:::

---

## 🎓 Learning Paths {data-background-color="#1e1e1e"}

Choose your journey

---

### Path 1: Quick Integration (30 minutes)

```
1. Lab-to-Accelerator Mapping (10 min)
2. Run watsonx_quickstart.ipynb (10 min)
3. Review FastAPI endpoint (10 min)
```

::: notes
Fastest path to production integration
:::

---

### Path 2: IBM Tooling Deep Dive (2 hours)

```
1. Review reference notebooks (30 min)
2. Register custom tool (30 min)
3. Set up experiment tracking (30 min)
4. Build example agent (30 min)
```

::: notes
Enterprise tooling mastery
:::

---

### Path 3: Production Deployment (4 hours)

```
1. Full accelerator integration (1 hour)
2. Docker setup (1 hour)
3. Accelerator notebooks (1 hour)
4. Troubleshooting (1 hour)
```

::: notes
Complete production deployment
:::

---

## 📁 File Structure {data-background-color="#0f172a"}

Understanding the layout

---

### Supplementary Materials

```
supplementary-materials/
├── SUPPLEMENTARY_QUICK_START.md      ← You are here
└── Day2_Supplementary_Material...    ← Full guide

accelerator/
├── rag/
│   ├── retriever.py
│   ├── pipeline.py
│   └── prompt.py
├── service/
│   └── api.py
└── tools/
    └── eval_small.py
```

::: notes
Production code structure. Well-organized.
:::

---

### Environment Setup

```
simple-watsonx-environment/
├── .env                              ← YOUR CREDENTIALS
└── notebooks/
    └── watsonx_quickstart.ipynb      ← START HERE
```

::: notes
Credentials in .env. Never commit to git!
:::

---

## 🔧 Quick Setup {data-background-color="#1e1e1e"}

Get started in 5 minutes

---

### Step 1: Verify watsonx.ai Access

```bash {data-line-numbers="1-2|4-8|10-11"}
# Clone if needed
git clone <your-repo>

# Create .env file
cat > .env << 'EOF'
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_APIKEY=your_key_here
WATSONX_PROJECT_ID=your_project_id_here
EOF

# Run quickstart
jupyter notebook notebooks/watsonx_quickstart.ipynb
```

::: notes
Simple setup. Verify credentials work.
:::

---

### Expected Output

```
✓ Credentials loaded
✓ API client initialized
✓ Found 50+ available models
✓ Granite model: Working
✓ Embeddings: Working
Ready for Day 2 labs! 🚀
```

::: notes
Green checkmarks mean success!
:::

---

### Step 2: Try a Reference Notebook {data-background-color="#0f172a"}

See RAG in action

---

### Open Chroma Example

```bash {data-line-numbers="1-2|4-5|7-10"}
# Navigate to reference notebooks
cd labs-src/

# Open Chroma example (easiest to start)
jupyter notebook use-watsonx-chroma-...ipynb

# It demonstrates:
# - Chroma setup with watsonx embeddings
# - Granite model integration
# - Full RAG pipeline
```

::: notes
Learn by example. IBM's tested patterns.
:::

---

### Step 3: Register Your First Tool {data-background-color="#1e1e1e"}

15 minutes to custom tools

---

### Simple Tool Example

```python {data-line-numbers="1-2|4-6|8-17|19-23"}
from ibm_watsonx_gov.tools.clients import
    register_tool, ToolRegistrationPayload

# Simple example tool
tool_code = """
def hello_world(name: str) -> str:
    return f"Hello, {name}!"
"""

tool_schema = {
    "type": "object",
    "properties": {
        "name": {"type": "string"}
    },
    "required": ["name"]
}

payload = ToolRegistrationPayload(
    tool_name="hello_world",
    description="A simple greeting tool",
    code={"source_code_base64": tool_code},
    schema=tool_schema
)

response = register_tool(payload)
print(f"✓ Registered: {response['metadata']['asset_id']}")
```

::: notes
Custom tools extend agent capabilities
:::

---

## 💡 Key Concepts {data-background-color="#0f172a"}

Understanding the patterns

---

### Accelerator Pattern

```
Labs (Prototype)          →    Accelerator (Production)
------------------------       ---------------------------
Notebook cells            →    Python modules
Inline functions          →    Classes with error handling
Manual testing            →    Automated tests
Single file               →    Structured project
Local only                →    Docker + cloud deployment
```

::: notes
Evolution from prototype to production
:::

---

### IBM Reference Notebooks {data-background-color="#1e1e1e"}

Three types to know

---

### Notebook Types

**1. labs-src/**
<span class="fragment">RAG patterns (Elasticsearch, Chroma, LangChain)</span>

**2. accelerator/assets/notebook/**
<span class="fragment">Ingestion, deployment, evaluation</span>

**3. Your notebooks**
<span class="fragment">Custom implementations</span>

::: notes
Different notebooks for different stages
:::

---

### When to Use Each

<span class="fragment">**Starting out?** → Use labs-src/ examples</span>

<span class="fragment">**Building ingestion?** → Use accelerator ingestion notebooks</span>

<span class="fragment">**Deploying?** → Use Create_and_Deploy notebooks</span>

<span class="fragment">**Testing?** → Use Test_Queries notebooks</span>

::: notes
Right tool for the right job
:::

---

### Governed Tools {data-background-color="#0f172a"}

Central catalog concept

---

### What Are Governed Tools?

**Tools in a central catalog with:**

<span class="fragment">✅ Version control</span>

<span class="fragment">✅ Access governance</span>

<span class="fragment">✅ Usage tracking</span>

<span class="fragment">✅ Audit logs</span>

::: notes
Enterprise governance built-in
:::

---

### Benefits

<span class="fragment">**Reuse** across projects</span>

<span class="fragment">**Consistent** tool behavior</span>

<span class="fragment">**Governance** compliance</span>

<span class="fragment">**Easy** updates</span>

::: notes
Enterprise-grade tool management
:::

---

## 🎯 Common Tasks {data-background-color="#1e1e1e"}

Step-by-step guides

---

### Task 1: Map Lab Code to Accelerator

```python {data-line-numbers="1-7|9-13|15-19"}
# Your Lab 2.2 notebook
def retrieve(query):
    return vectorstore.similarity_search(query, k=4)

def answer(query):
    docs = retrieve(query)
    prompt = build_prompt(query, docs)
    return llm(prompt)

# Becomes: accelerator/rag/retriever.py
class Retriever:
    def retrieve(self, query: str, k: int = 4):
        # Production version with error handling
        pass

# And: accelerator/rag/pipeline.py
class RAGPipeline:
    def answer_question(self, query: str) -> dict:
        # Production version with metrics
        pass
```

::: notes
Notebook to production code pattern
:::

---

### Task 2: Run Reference Notebook

```bash {data-line-numbers="1-2|4-5|7-8|10-11|13"}
# Navigate to labs-src
cd labs-src/

# Copy credentials
cp ../simple-watsonx-environment/.env .

# Install extra deps if needed
pip install elasticsearch

# Run notebook
jupyter notebook use-watsonx-elasticsearch-...ipynb

# Follow along and note patterns
```

::: notes
Learn from working examples
:::

---

### Task 3: Set Up Docker {data-background-color="#0f172a"}

Container-based development

---

### Docker Setup

```dockerfile {data-line-numbers="1-2|4|6-7|9|11"}
FROM python:3.11-slim

WORKDIR /workspace

# Copy and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

RUN pip install jupyter jupyterlab

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root"]
```

::: notes
Reproducible environment. Works everywhere.
:::

---

### Build and Run

```bash {data-line-numbers="1-2|4-5|7-8"}
# Build image
docker build -t watsonx-workspace .

# Run container
docker run -p 8888:8888 watsonx-workspace

# Access Jupyter
# Navigate to http://localhost:8888
```

::: notes
Simple Docker workflow
:::

---

## Quick Reference {data-background-color="#1e1e1e"}

Essential commands

---

### File Paths Cheat Sheet

```
watsonx-workshop/
├── simple-watsonx-environment/
│   ├── .env                          # YOU CREATE
│   └── notebooks/
│       └── watsonx_quickstart.ipynb  # START HERE
│
├── labs-src/                         # IBM examples
│   └── use-watsonx-elasticsearch-... # Reference
│
└── accelerator/                      # Production
    ├── rag/
    ├── service/
    └── tools/
```

::: notes
Know where everything lives
:::

---

### Command Cheat Sheet

```bash {data-line-numbers="1-3|5-7|9-10|12-14"}
# Environment setup
python -m venv venv
pip install -r requirements.txt

# Docker
docker build -t watsonx-workspace .
docker run -p 8888:8888 watsonx-workspace

# Run notebook
jupyter notebook watsonx_quickstart.ipynb

# Run accelerator service
cd accelerator
python -m service.api
```

::: notes
Most common commands. Bookmark these.
:::

---

### Essential Imports

```python {data-line-numbers="1-3|5-6|8-10|12-14|16-18"}
# watsonx.ai basics
from ibm_watsonx_ai import Credentials, APIClient
from ibm_watsonx_ai.foundation_models import Model

# LangChain with watsonx
from langchain_ibm import WatsonxLLM, WatsonxEmbeddings

# Vector stores
from langchain_chroma import Chroma
from langchain_elasticsearch import ElasticsearchStore

# Governance
from ibm_watsonx_gov.tools import load_tool
from ibm_watsonx_gov.evaluators.agentic_evaluator import AgenticEvaluator

# LangGraph
from langgraph.graph import START, END, StateGraph
from langgraph.prebuilt import create_react_agent
```

::: notes
Copy-paste ready. Essential imports.
:::

---

## Next Steps {data-background-color="#0f172a"}

Continue your journey

---

### Immediate (Right Now)

<span class="fragment">1. ✅ Run `watsonx_quickstart.ipynb` successfully</span>

<span class="fragment">2. ✅ Register at least one custom tool</span>

<span class="fragment">3. ✅ Review one reference notebook from labs-src/</span>

::: notes
Quick wins to build momentum
:::

---

### This Week

<span class="fragment">1. ✅ Implement Docker-based workflow</span>

<span class="fragment">2. ✅ Set up experiment tracking</span>

<span class="fragment">3. ✅ Build a simple governed agent</span>

::: notes
Weekly goals for skill building
:::

---

### This Month

<span class="fragment">1. ✅ Integrate accelerator components</span>

<span class="fragment">2. ✅ Deploy RAG service with FastAPI</span>

<span class="fragment">3. ✅ Set up continuous evaluation pipeline</span>

::: notes
Production deployment goals
:::

---

## Additional Resources {data-background-color="#1e1e1e"}

Expand your knowledge

---

### Documentation

<span class="fragment">**watsonx.ai:** https://ibm.com/docs/watsonx-as-a-service</span>

<span class="fragment">**watsonx.governance:** https://ibm.com/docs/watsonx/governance</span>

<span class="fragment">**LangGraph:** https://langchain-ai.github.io/langgraph/</span>

<span class="fragment">**FastAPI:** https://fastapi.tiangolo.com/</span>

::: notes
Official documentation. Bookmark these.
:::

---

### IBM-Specific

<span class="fragment">**Tool Catalog:** https://dataplatform.cloud.ibm.com/aigov/</span>

<span class="fragment">**Evaluation Studio:** Access via watsonx.governance UI</span>

<span class="fragment">**Cloud API Keys:** https://cloud.ibm.com/iam/apikeys</span>

::: notes
IBM platform resources
:::

---

### Community

<span class="fragment">**IBM Community:** https://community.ibm.com/watsonx/</span>

<span class="fragment">**Stack Overflow:** Tag `ibm-watsonx`</span>

::: notes
Get help from the community
:::

---

## Production Integration Tips {data-background-color="#0f172a"}

Real-world deployment guidance

---

### Tip 1: Accelerator Integration Workflow

**Step-by-step migration from labs to production:**

```python
# 1. Start with lab code (Lab 2.1-2.4)
def simple_rag(query):
    docs = vectorstore.similarity_search(query)
    return llm(build_prompt(query, docs))

# 2. Refactor to accelerator structure
# accelerator/rag/pipeline.py
class RAGPipeline:
    def __init__(self, config):
        self.retriever = self._init_retriever(config)
        self.llm = self._init_llm(config)

    def answer_question(self, query: str) -> dict:
        # Production-ready with error handling
        pass
```

::: notes
Lab code teaches concepts. Accelerator code is production-ready.
:::

---

### Tip 2: Environment Management

**Keep environments separate:**

```bash
# Development
.env.dev
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_PROJECT_ID=dev_project_123

# Production
.env.prod
WATSONX_URL=https://eu-de.ml.cloud.ibm.com
WATSONX_PROJECT_ID=prod_project_456
```

<span class="fragment">Never mix dev/prod credentials!</span>

::: notes
Separate credentials prevent costly mistakes
:::

---

### Tip 3: Docker Best Practices {data-background-color="#1e1e1e"}

Container optimization

---

### Optimized Dockerfile

```dockerfile {data-line-numbers="1-3|5-8|10-13|15-18"}
# Multi-stage build for smaller images
FROM python:3.11-slim as builder
WORKDIR /build

# Install dependencies
COPY requirements.txt .
RUN pip install --user --no-cache-dir \
    -r requirements.txt

# Runtime stage
FROM python:3.11-slim
WORKDIR /app

# Copy only what's needed
COPY --from=builder /root/.local /root/.local
COPY accelerator/ ./accelerator/
ENV PATH=/root/.local/bin:$PATH

CMD ["python", "-m", "accelerator.service.api"]
```

::: notes
Multi-stage builds reduce image size by 50%+
:::

---

### Tip 4: Governed Tools Best Practices

**Versioning strategy:**

```python
# Register tool with version
payload = ToolRegistrationPayload(
    tool_name="company_search_v2",  # Include version
    version="2.0.0",  # Semantic versioning
    description="Enhanced search with filters",
    code={"source_code_base64": tool_code},
    schema=tool_schema
)

# Always specify version when loading
tool = load_tool(
    tool_id="company_search_v2",
    version="2.0.0"  # Explicit version
)
```

::: notes
Version everything. Enables rollback and A/B testing.
:::

---

### Tip 5: Evaluation Studio Integration {data-background-color="#0f172a"}

Track experiments systematically

---

### Experiment Tracking Pattern

```python {data-line-numbers="1-8|10-18"}
from ibm_watsonx_gov.evaluators import AgenticEvaluator

# Set up experiment
experiment_config = {
    "name": "RAG_chunking_comparison",
    "description": "Compare 500 vs 1000 token chunks",
    "metrics": ["correctness", "relevance", "latency"]
}

# Run evaluation
evaluator = AgenticEvaluator(config=experiment_config)

results = evaluator.evaluate(
    test_cases=test_dataset,
    rag_pipeline=my_pipeline
)

# Results automatically logged to Evaluation Studio
```

::: notes
Automated tracking enables data-driven optimization
:::

---

### Tip 6: FastAPI Deployment

**Production API structure:**

```python {data-line-numbers="1-7|9-19"}
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="RAG Service")

class QueryRequest(BaseModel):
    question: str
    max_chunks: int = 5

@app.post("/answer")
async def answer_question(request: QueryRequest):
    try:
        result = rag_pipeline.answer(
            request.question,
            k=request.max_chunks
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

::: notes
FastAPI provides automatic API docs and validation
:::

---

## Troubleshooting Guide {data-background-color="#1e1e1e"}

Common issues and solutions

---

### Issue 1: Credential Errors

**Problem:**
```
Error: Invalid API key
```

**Solutions:**

<span class="fragment">1. Check `.env` file exists and is loaded</span>

<span class="fragment">2. Verify no extra spaces in API key</span>

<span class="fragment">3. Ensure API key has correct permissions</span>

```python
# Test credentials
from dotenv import load_dotenv
import os

load_dotenv()
print(f"API Key: {os.getenv('WATSONX_APIKEY')[:10]}...")
```

::: notes
Most common issue. Always validate credentials first.
:::

---

### Issue 2: Import Errors

**Problem:**
```
ModuleNotFoundError: No module named 'ibm_watsonx_gov'
```

**Solution:**

```bash {data-line-numbers="1-2|4-5|7-8"}
# Verify installation
pip list | grep watsonx

# Reinstall if needed
pip install --upgrade ibm-watsonx-ai ibm-watsonx-gov

# Check Python environment
which python
```

::: notes
Environment mismatch is common in Jupyter notebooks
:::

---

### Issue 3: Elasticsearch Connection {data-background-color="#0f172a"}

Connection timeouts

---

### Elasticsearch Debugging

**Problem:**
```
ConnectionError: Connection refused
```

**Solutions:**

```python {data-line-numbers="1-7"}
# Test connection
from elasticsearch import Elasticsearch

es = Elasticsearch(
    cloud_id=os.getenv("ELASTIC_CLOUD_ID"),
    api_key=os.getenv("ELASTIC_API_KEY")
)

print(es.info())  # Should return cluster info
```

<span class="fragment">Check firewall rules</span>

<span class="fragment">Verify cloud_id format</span>

<span class="fragment">Test with curl first</span>

::: notes
Network issues often masquerade as code problems
:::

---

### Issue 4: Slow Queries

**Problem:**
```
Query taking 30+ seconds
```

**Diagnostic steps:**

<span class="fragment">1. Profile each component separately</span>

```python
import time

start = time.time()
docs = retriever.get_relevant_documents(query)
print(f"Retrieval: {time.time() - start:.2f}s")

start = time.time()
answer = llm(prompt)
print(f"Generation: {time.time() - start:.2f}s")
```

<span class="fragment">2. Optimize the slowest component first</span>

::: notes
Measure before optimizing. Don't guess!
:::

---

### Issue 5: Docker Build Failures

**Problem:**
```
ERROR: Failed building wheel for package
```

**Solutions:**

```dockerfile
# Add build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3-dev

# Then install Python packages
RUN pip install -r requirements.txt
```

::: notes
Some packages need compilation tools
:::

---

## Extended Resources {data-background-color="#1e1e1e"}

Beyond the basics

---

### Advanced RAG Patterns

**Hybrid Search:**
<span class="fragment">📚 Combining dense + sparse retrieval: https://www.elastic.co/blog/improving-information-retrieval-elastic-stack-hybrid</span>

**Parent Document Retrieval:**
<span class="fragment">📚 LangChain Parent Doc: https://python.langchain.com/docs/modules/data_connection/retrievers/parent_document_retriever</span>

**Self-Querying Retrieval:**
<span class="fragment">📚 Metadata-aware retrieval: https://python.langchain.com/docs/modules/data_connection/retrievers/self_query</span>

::: notes
Advanced techniques for complex use cases
:::

---

### LangGraph Deep Dive

**Official Resources:**
<span class="fragment">🔗 LangGraph Docs: https://langchain-ai.github.io/langgraph/</span>
<span class="fragment">🔗 LangGraph Tutorial: https://github.com/langchain-ai/langgraph/tree/main/examples</span>
<span class="fragment">🔗 Agent Architectures: https://blog.langchain.dev/langgraph-multi-agent-workflows/</span>

**Example Patterns:**
<span class="fragment">💡 Banking Assistant (from supplementary materials)</span>
<span class="fragment">💡 HR Assistant with tool calling</span>
<span class="fragment">💡 Multi-step reasoning agents</span>

::: notes
LangGraph enables sophisticated agentic workflows
:::

---

### watsonx.governance Deep Dive {data-background-color="#0f172a"}

Enterprise governance

---

### Governance Resources

**Official Documentation:**
<span class="fragment">📖 watsonx.governance Guide: https://www.ibm.com/docs/en/watsonx/governance</span>
<span class="fragment">📖 Tool Registration API: https://cloud.ibm.com/apidocs/watsonx-governance</span>

**Use Cases:**
<span class="fragment">✅ Centralized tool catalog</span>
<span class="fragment">✅ Access control and audit logs</span>
<span class="fragment">✅ Version management</span>
<span class="fragment">✅ Compliance tracking</span>

::: notes
Critical for enterprise AI governance
:::

---

### Docker & Kubernetes

**Container Orchestration:**
<span class="fragment">🐳 Docker Compose for local dev: https://docs.docker.com/compose/</span>
<span class="fragment">☸️ Kubernetes deployment: https://kubernetes.io/docs/tutorials/stateless-application/</span>
<span class="fragment">🚀 Helm charts for watsonx: Contact IBM support</span>

**Monitoring:**
<span class="fragment">📊 Prometheus + Grafana: https://prometheus.io/docs/visualization/grafana/</span>

::: notes
Production deployment needs orchestration
:::

---

### Performance Optimization

**Caching Strategies:**
<span class="fragment">💾 Redis for embeddings cache: https://redis.io/docs/</span>
<span class="fragment">💾 LangChain caching: https://python.langchain.com/docs/modules/model_io/llms/llm_caching</span>

**Batching:**
<span class="fragment">⚡ Batch embedding generation</span>
<span class="fragment">⚡ Async processing with FastAPI</span>

::: notes
Caching and batching are low-hanging fruit
:::

---

### Security Best Practices {data-background-color="#1e1e1e"}

Protecting production systems

---

### Security Checklist

**Credentials:**
<span class="fragment">✅ Use environment variables, never hardcode</span>
<span class="fragment">✅ Rotate API keys regularly</span>
<span class="fragment">✅ Use secret management (Vault, Secrets Manager)</span>

**API Security:**
<span class="fragment">✅ Implement rate limiting</span>
<span class="fragment">✅ Use HTTPS only</span>
<span class="fragment">✅ Validate all inputs</span>

**Data:**
<span class="fragment">✅ Encrypt sensitive data at rest</span>
<span class="fragment">✅ Sanitize logs (no PII)</span>

::: notes
Security must be baked in, not bolted on
:::

---

### Testing Strategies

**Unit Tests:**
```python
def test_retriever():
    retriever = RAGRetriever(config)
    docs = retriever.retrieve("test query")
    assert len(docs) > 0
    assert all(hasattr(d, 'page_content') for d in docs)
```

**Integration Tests:**
```python
def test_end_to_end():
    result = rag_pipeline.answer("What is the policy?")
    assert 'answer' in result
    assert result['answer'] != ""
```

::: notes
Test retrieval and generation separately, then together
:::

---

## Navigation & Next Steps {data-background-color="#0f172a"}

Continue your journey

---

### 🏠 Return to Workshop Portal

**[Interactive Workshop Portal](https://ruslanmv.com/watsonx-workshop/portal/)**

Complete workshop navigation and daily guides

::: notes
Central hub for all materials
:::

---

### 📚 Day 2 Core Materials

**Return to Theory:**
<span class="fragment">📖 [RAG Architecture Overview](./Theory_01_RAG_Architecture_Overview.md)</span>
<span class="fragment">Comprehensive RAG concepts and components</span>

**Day 2 Portal:**
<span class="fragment">🗓️ [Day 2 Schedule](../../portal/day2-portal.md)</span>
<span class="fragment">Complete Day 2 timeline and materials</span>

**Lab Sequence:**
<span class="fragment">🧪 [Lab 2.1: Local RAG](./lab-1-intro-rag.md)</span>
<span class="fragment">🧪 [Lab 2.2: watsonx RAG](./lab-2-watsonx-rag.md)</span>
<span class="fragment">🧪 [Lab 2.3: Twin Pipelines](./lab-3-dual-mode-rag.md)</span>
<span class="fragment">🧪 [Lab 2.4: RAG Evaluation](./lab-4-compare-evals.md)</span>

::: notes
Complete the core labs before diving into supplementary materials
:::

---

### 🔗 Workshop Progression

**Previous Content:**
<span class="fragment">← [Day 1: LLM Foundations](../day1-llm/README.md)</span>
<span class="fragment">Prompting, templates, and evaluation basics</span>

**Current Focus:**
<span class="fragment">📍 Day 2: RAG + Supplementary Materials</span>
<span class="fragment">Building production-ready RAG systems</span>

**Next Steps:**
<span class="fragment">→ [Day 3: Agent Orchestration](../day3-orchestrate/README.md)</span>
<span class="fragment">LangGraph and agentic workflows</span>

**Environment Setup:**
<span class="fragment">🔧 [Day 0: Prerequisites](../day0-env/prereqs-and-accounts.md)</span>

::: notes
Progressive learning path through the workshop
:::

---

### 📦 Accelerator Integration

**Production Code:**
<span class="fragment">🏗️ Explore `accelerator/rag/` directory</span>
<span class="fragment">🏗️ Review `accelerator/service/api.py`</span>
<span class="fragment">🏗️ Study `accelerator/tools/` utilities</span>

**Reference Notebooks:**
<span class="fragment">📓 `accelerator/assets/notebook/Process_and_Ingest_Data_into_Vector_DB.ipynb`</span>
<span class="fragment">📓 `accelerator/assets/notebook/QnA_with_RAG.ipynb`</span>
<span class="fragment">📓 `accelerator/assets/notebook/Test_Queries_for_Vector_DB.ipynb`</span>

::: notes
Accelerator provides production-ready patterns
:::

---

### 🎯 Recommended Learning Path

**Quick Start (1 hour):**
<span class="fragment">1. Run `watsonx_quickstart.ipynb`</span>
<span class="fragment">2. Review one labs-src/ notebook</span>
<span class="fragment">3. Map concepts to accelerator code</span>

**Deep Dive (1 day):**
<span class="fragment">1. Complete all Day 2 labs</span>
<span class="fragment">2. Register custom tool</span>
<span class="fragment">3. Set up evaluation tracking</span>
<span class="fragment">4. Deploy FastAPI service</span>

**Production Ready (1 week):**
<span class="fragment">1. Integrate accelerator components</span>
<span class="fragment">2. Set up Docker environment</span>
<span class="fragment">3. Implement CI/CD pipeline</span>
<span class="fragment">4. Deploy to production</span>

::: notes
Choose path based on your timeline and goals
:::

---

### 💡 Pro Tips

**Development:**
<span class="fragment">🔸 Always use virtual environments</span>
<span class="fragment">🔸 Pin dependency versions in production</span>
<span class="fragment">🔸 Keep dev/prod configs separate</span>

**Testing:**
<span class="fragment">🔸 Test retrieval quality regularly</span>
<span class="fragment">🔸 Monitor latency percentiles (p95, p99)</span>
<span class="fragment">🔸 Use evaluation frameworks (RAGAS, TruLens)</span>

**Deployment:**
<span class="fragment">🔸 Start with Docker, scale to Kubernetes</span>
<span class="fragment">🔸 Implement health checks and monitoring</span>
<span class="fragment">🔸 Use managed services when possible</span>

::: notes
Hard-earned lessons from production deployments
:::

---

### 📞 Getting Help

**Official Support:**
<span class="fragment">💬 IBM watsonx Community: https://community.ibm.com/watsonx/</span>
<span class="fragment">📧 watsonx Support: https://www.ibm.com/support/</span>

**Community Resources:**
<span class="fragment">🗨️ Stack Overflow: Tag `ibm-watsonx`</span>
<span class="fragment">🗨️ LangChain Discord: https://discord.gg/langchain</span>

**Documentation:**
<span class="fragment">📚 watsonx.ai Docs: https://www.ibm.com/docs/en/watsonx-as-a-service</span>
<span class="fragment">📚 LangChain Docs: https://python.langchain.com/</span>

::: notes
Don't struggle alone. Community is helpful!
:::

---

## Supplementary Guide Complete! {data-background-color="#0f172a" data-transition="zoom"}

**This guide complements the main Day 2 RAG workshop**

**with IBM-specific tooling and production patterns**

**You've learned:**
- Accelerator integration patterns
- Docker and deployment strategies
- Governed tools and evaluation studio
- Production tips and troubleshooting
- Advanced RAG techniques

**Ready to build production RAG systems!**

**Version:** 1.1
**Last Updated:** January 2025
**Maintained by:** IBM watsonx.ai Education Team

::: notes
Advanced content for enterprise deployment.
You're now ready for production!
:::