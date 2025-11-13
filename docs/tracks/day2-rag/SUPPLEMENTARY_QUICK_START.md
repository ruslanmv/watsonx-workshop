# Day 2 Supplementary Materials - Quick Start Guide

## 🎯 What's in the Supplementary Package?

This supplementary guide covers **IBM-specific tooling and production patterns** not included in the main workshop:

### 📦 Topics Covered

1. **Accelerator Project Integration** - Production code structure
2. **IBM Reference Notebooks** - Examples from labs-src/ and accelerator/assets/
3. **Docker Setup** - Container-based development
4. **watsonx_quickstart.ipynb** - Environment verification
5. **Governed Agentic Catalog** - Custom tool registration
6. **Evaluation Studio** - Experiment tracking
7. **Advanced Examples** - Banking & HR assistants

---

## 🚀 Quick Navigation

### I want to...

| Goal | Go to Section | Time |
|------|---------------|------|
| Understand accelerator structure | Section 1 | 10 min |
| See IBM notebook examples | Section 2 | 15 min |
| Set up Docker environment | Section 3 | 20 min |
| Verify watsonx setup | Section 4 | 10 min |
| Register custom tools | Section 5 | 15 min |
| Track experiments | Section 6 | 20 min |
| Build LangGraph agent | Section 7 | 30 min |

---

## ✅ Prerequisites

Before using supplementary materials:

**Required:**
- [x] Completed main Day 2 workshop (or Labs 2.1-2.4)
- [x] watsonx.ai account and credentials
- [x] Basic understanding of RAG concepts

**Optional:**
- [ ] Docker installed (for Section 3)
- [ ] watsonx.governance access (for Sections 5-6)
- [ ] Elasticsearch instance (for reference notebooks)

---

## 🎓 Learning Path

### Path 1: Quick Integration (30 minutes)
```
1. Section 1.2: Lab-to-Accelerator Mapping (10 min)
2. Section 4: Run watsonx_quickstart.ipynb (10 min)
3. Section 1.5: Review FastAPI endpoint (10 min)
```

### Path 2: IBM Tooling Deep Dive (2 hours)
```
1. Section 2.1: Review reference notebooks (30 min)
2. Section 5: Register custom tool (30 min)
3. Section 6: Set up experiment tracking (30 min)
4. Section 7: Build example agent (30 min)
```

### Path 3: Production Deployment (4 hours)
```
1. Section 1: Full accelerator integration (1 hour)
2. Section 3: Docker setup (1 hour)
3. Section 2.2: Accelerator notebooks (1 hour)
4. Section 8: Troubleshooting (1 hour)
```

---

## 📁 File Structure

```
supplementary-materials/
├── SUPPLEMENTARY_QUICK_START.md              ← You are here
└── Day2_Supplementary_Material_Accelerator_IBM_Tooling.md  ← Full guide

accelerator/                                   ← Production code
├── rag/
│   ├── retriever.py                          ← From Lab 2.1/2.2
│   ├── pipeline.py                           ← From Lab 2.2/2.3
│   └── prompt.py                             ← From Lab 2.2
├── service/
│   ├── api.py                                ← FastAPI endpoints
│   └── deps.py                               ← Configuration
└── tools/
    ├── eval_small.py                         ← From Lab 2.4

simple-watsonx-environment/
├── .env                                      ← YOUR CREDENTIALS
└── notebooks/
    └── watsonx_quickstart.ipynb              ← START HERE
```

---

## 🔧 Quick Setup

### 1. Verify watsonx.ai Access (5 minutes)

```bash
# Clone if needed
git clone <your-repo>
cd simple-watsonx-environment

# Create .env file
cat > .env << 'ENVEOF'
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_APIKEY=your_key_here
WATSONX_PROJECT_ID=your_project_id_here
ENVEOF

# Run quickstart
jupyter notebook notebooks/watsonx_quickstart.ipynb
```

**Expected Output:**
```
✓ Credentials loaded
✓ API client initialized
✓ Found 50+ available models
✓ Granite model: Working
✓ Embeddings: Working
Ready for Day 2 labs! 🚀
```

### 2. Try a Reference Notebook (10 minutes)

```bash
# Navigate to reference notebooks
cd labs-src/

# Open Chroma example (easiest to start)
jupyter notebook use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb

# Follow along - it demonstrates:
# - Chroma setup with watsonx embeddings
# - Granite model integration
# - Full RAG pipeline
```

### 3. Register Your First Tool (15 minutes)

```python
# In a notebook
from ibm_watsonx_gov.tools.clients import register_tool, ToolRegistrationPayload

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
    code={
        "source_code_base64": tool_code,
        "run_time_details": {"engine": "python 3.11"}
    },
    schema=tool_schema,
    category=["Example"]
)

response = register_tool(payload)
print(f"✓ Registered: {response['metadata']['asset_id']}")
```

---

## 💡 Key Concepts

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

### IBM Reference Notebooks

**Three Types:**

1. **labs-src/** - RAG patterns (Elasticsearch, Chroma, LangChain)
2. **accelerator/assets/notebook/** - Ingestion, deployment, evaluation
3. **Your notebooks** - Custom implementations

**When to Use Each:**
- **Starting out?** → Use labs-src/ examples
- **Building ingestion?** → Use accelerator ingestion notebooks
- **Deploying?** → Use Create_and_Deploy notebooks
- **Testing?** → Use Test_Queries notebooks

### Governed Tools

**Concept:** Tools in a central catalog with:
- ✅ Version control
- ✅ Access governance
- ✅ Usage tracking
- ✅ Audit logs

**Benefits:**
- Reuse across projects
- Consistent tool behavior
- Governance compliance
- Easy updates

---

## 🎯 Common Tasks

### Task 1: Map Lab Code to Accelerator

```python
# Your Lab 2.2 notebook
def retrieve(query):
    return vectorstore.similarity_search(query, k=4)

def answer(query):
    docs = retrieve(query)
    prompt = build_prompt(query, docs)
    return llm(prompt)

# Becomes: accelerator/rag/retriever.py
class Retriever:
    def retrieve(self, query: str, k: int = 4) -> List[Chunk]:
        # Production version with error handling
        pass

# And: accelerator/rag/pipeline.py
class RAGPipeline:
    def answer_question(self, query: str) -> dict:
        # Production version with metrics
        pass
```

### Task 2: Run Reference Notebook

```bash
# 1. Navigate to labs-src
cd labs-src/

# 2. Copy credentials
cp ../simple-watsonx-environment/.env .

# 3. Install extra deps if needed
pip install elasticsearch  # for ES examples

# 4. Run notebook
jupyter notebook use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb

# 5. Follow along and note patterns
```

### Task 3: Set Up Docker

```bash
# 1. Create Dockerfile (see Section 3.1)
cat > Dockerfile << 'EOF'
FROM python:3.11-slim
WORKDIR /workspace
COPY requirements.txt .
RUN pip install -r requirements.txt
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root"]
