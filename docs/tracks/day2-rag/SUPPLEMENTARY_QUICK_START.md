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

## Supplementary Guide Complete! {data-background-color="#0f172a" data-transition="zoom"}

**This guide complements the main Day 2 RAG workshop**

**with IBM-specific tooling and production patterns**

**Version:** 1.0
**Last Updated:** January 2025
**Maintained by:** IBM watsonx.ai Education Team

::: notes
Advanced content for enterprise deployment
:::