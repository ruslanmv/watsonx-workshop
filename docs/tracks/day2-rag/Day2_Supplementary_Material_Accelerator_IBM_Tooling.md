# Day 2 Supplementary Material: Accelerator Integration & IBM Tooling

## 📋 Overview

This supplementary guide covers **additional topics** not included in the main Day 2 workshop materials:

1. **Accelerator Project Structure** - How labs map to production code
2. **IBM Reference Notebooks** - Detailed examples from labs-src/ and accelerator/assets/
3. **Docker Environment Setup** - Container-based development
4. **watsonx_quickstart.ipynb** - Initial setup notebook
5. **Governed Agentic Catalog** - Custom tool registration and usage
6. **Evaluation Studio Integration** - Experiment tracking with multiple LLMs
7. **Advanced Examples** - Banking Assistant and HR Assistant with LangGraph

---

## 1. Connection to the Accelerator Project

### 1.1 Understanding the Accelerator Structure

The `watsonx-workshop/accelerator/` directory contains production-grade RAG service components:

```
accelerator/
├── rag/                    # Core RAG logic
│   ├── retriever.py        # Vector store queries
│   ├── pipeline.py         # End-to-end RAG orchestration
│   └── prompt.py           # Prompt templates
│
├── service/                # API layer
│   ├── api.py             # FastAPI app with /ask endpoint
│   └── deps.py            # Configuration & dependencies
│
├── tools/                  # Batch processing scripts
│   ├── chunk.py           # Document chunking
│   ├── extract.py         # Text extraction
│   ├── embed_index.py     # Embedding & indexing
│   └── eval_small.py      # Evaluation harness
│
├── ui/                     # User interface
│   └── app.py             # Streamlit front-end
│
└── assets/                 # Reference materials
    ├── notebook/          # Example notebooks
    └── data_asset/        # Helper functions
        └── rag_helper_functions.py
```

### 1.2 Mapping Labs to Accelerator Components

| Lab Component | Becomes | Accelerator File |
|---------------|---------|------------------|
| Document loading | Batch tool | `tools/extract.py` |
| Chunking logic | Batch tool | `tools/chunk.py` |
| Embedding & indexing | Batch tool | `tools/embed_index.py` |
| Retrieval function | Core RAG | `rag/retriever.py` |
| RAG pipeline | Core RAG | `rag/pipeline.py` |
| Prompt templates | Core RAG | `rag/prompt.py` |
| Answer endpoint | API | `service/api.py` |
| Evaluation | Testing | `tools/eval_small.py` |

### 1.3 From Notebook to Production

**Lab 2.1/2.2 Pattern:**
```python
# In notebook (prototype)
def retrieve(query: str):
    docs = vectorstore.similarity_search(query, k=4)
    return docs

def answer(query: str):
    docs = retrieve(query)
    prompt = build_prompt(query, docs)
    answer = llm(prompt)
    return {"answer": answer, "chunks": docs}
```

**Accelerator Pattern:**
```python
# accelerator/rag/retriever.py (production)
class Retriever:
    def __init__(self, vectorstore_config: dict):
        self.vectorstore = self._init_vectorstore(vectorstore_config)
    
    def retrieve(self, query: str, k: int = 4) -> List[Chunk]:
        """Retrieve relevant chunks with error handling & logging"""
        try:
            results = self.vectorstore.similarity_search(query, k=k)
            return [self._format_chunk(r) for r in results]
        except Exception as e:
            logger.error(f"Retrieval failed: {e}")
            raise

# accelerator/rag/pipeline.py (production)
class RAGPipeline:
    def __init__(self, retriever: Retriever, llm: BaseLLM):
        self.retriever = retriever
        self.llm = llm
    
    def answer_question(self, query: str) -> dict:
        """End-to-end RAG with metrics & error handling"""
        start_time = time.time()
        
        chunks = self.retriever.retrieve(query)
        prompt = self.prompt_builder.build(query, chunks)
        answer = self.llm.generate(prompt)
        
        return {
            "answer": answer,
            "chunks": [c.to_dict() for c in chunks],
            "model_id": self.llm.model_id,
            "latency_ms": int((time.time() - start_time) * 1000)
        }
```

**Key Differences:**
- ✅ Configuration management via `deps.py`
- ✅ Error handling and logging
- ✅ Structured response format
- ✅ Metrics collection
- ✅ Type hints and validation

### 1.4 Service Configuration (deps.py)

```python
# accelerator/service/deps.py
from pydantic import BaseSettings

class Settings(BaseSettings):
    # watsonx.ai
    WATSONX_URL: str
    WATSONX_APIKEY: str
    WATSONX_PROJECT_ID: str
    LLM_MODEL_ID: str = "ibm/granite-3-3-8b-instruct"
    
    # Vector store
    VECTOR_STORE_TYPE: str = "elasticsearch"  # or "chroma"
    ES_URL: str = ""
    ES_INDEX: str = "rag_index"
    
    # RAG parameters
    RETRIEVAL_K: int = 5
    MAX_CONTEXT_TOKENS: int = 2000
    
    class Config:
        env_file = ".env"

settings = Settings()
```

### 1.5 FastAPI Endpoint (api.py)

```python
# accelerator/service/api.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from accelerator.rag.pipeline import RAGPipeline
from accelerator.service.deps import settings, get_pipeline

app = FastAPI(title="RAG Service")

class QuestionRequest(BaseModel):
    question: str
    k: int = 5

class AnswerResponse(BaseModel):
    answer: str
    citations: List[dict]
    model_id: str
    latency_ms: int

@app.post("/ask", response_model=AnswerResponse)
async def ask_question(request: QuestionRequest):
    """
    Answer a question using RAG
    
    Example:
        POST /ask
        {
            "question": "What is RAG?",
            "k": 5
        }
    """
    try:
        pipeline = get_pipeline()
        result = pipeline.answer_question(
            query=request.question,
            k=request.k
        )
        
        return AnswerResponse(
            answer=result["answer"],
            citations=result["chunks"],
            model_id=result["model_id"],
            latency_ms=result["latency_ms"]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

---

## 2. Reference Notebooks Deep Dive

### 2.1 Labs-src/ Notebooks (IBM Examples)

These notebooks demonstrate different RAG patterns with IBM tooling:

#### **Elasticsearch + LangChain Pattern**
**File:** `labs-src/use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`

**Key Learnings:**
- Using LangChain's `ElasticsearchStore` abstraction
- Configuring Elasticsearch with watsonx embeddings
- Chain construction with `RetrievalQA`

**Code Pattern:**
```python
from langchain_elasticsearch import ElasticsearchStore
from langchain_ibm import WatsonxLLM, WatsonxEmbeddings

# Setup embeddings
embeddings = WatsonxEmbeddings(
    model_id="ibm/slate-30m-english-rtrvr",
    url=watsonx_url,
    apikey=watsonx_apikey,
    project_id=project_id
)

# Setup vector store
vectorstore = ElasticsearchStore(
    es_url=elasticsearch_url,
    index_name="my_index",
    embedding=embeddings,
    es_user=es_user,
    es_password=es_password
)

# Create retrieval chain
llm = WatsonxLLM(model_id="ibm/granite-13b-chat-v2", ...)
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=vectorstore.as_retriever(),
    return_source_documents=True
)

# Query
result = qa_chain({"query": "What is RAG?"})
```

**When to Use:** Production deployments requiring scalable vector search

---

#### **Elasticsearch Python SDK Pattern**
**File:** `labs-src/use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb`

**Key Learnings:**
- Direct Elasticsearch client usage (no LangChain)
- Manual embedding and indexing
- Custom similarity search queries

**Code Pattern:**
```python
from elasticsearch import Elasticsearch
from sentence_transformers import SentenceTransformer

# Direct ES client
es_client = Elasticsearch(
    [f"https://{es_host}:{es_port}"],
    basic_auth=(es_user, es_password),
    ssl_assert_fingerprint=ssl_fingerprint
)

# Manual embedding
model = SentenceTransformer('all-MiniLM-L6-v2')
query_vector = model.encode(query)

# KNN search
response = es_client.search(
    index=index_name,
    knn={
        "field": "embedding",
        "query_vector": query_vector,
        "k": 5,
        "num_candidates": 50
    }
)
```

**When to Use:** Maximum control over Elasticsearch, custom search logic

---

#### **Chroma + LangChain Pattern**
**File:** `labs-src/use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`

**Key Learnings:**
- Local development with Chroma
- Persistent vs in-memory stores
- Integration with Granite models

**Code Pattern:**
```python
from langchain_chroma import Chroma
from langchain_ibm import WatsonxLLM, WatsonxEmbeddings

# Chroma setup
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=WatsonxEmbeddings(model_id="ibm/slate-30m-english-rtrvr"),
    persist_directory="./chroma_db"
)

# Granite LLM
llm = WatsonxLLM(
    model_id="ibm/granite-13b-chat-v2",
    url=watsonx_url,
    apikey=watsonx_apikey,
    project_id=project_id,
    params={
        "decoding_method": "greedy",
        "max_new_tokens": 200
    }
)

# Query
qa = RetrievalQA.from_chain_type(llm=llm, retriever=vectorstore.as_retriever())
result = qa({"query": "Explain RAG"})
```

**When to Use:** Prototyping, local development, small-scale deployments

---

### 2.2 Accelerator Notebooks

#### **Ingestion Notebooks**

**Process_and_Ingest_Data_into_Vector_DB.ipynb**
- Complete ingestion pipeline
- Error handling and validation
- Batch processing strategies
- Metadata management

**Process_and_Ingest_Data_from_COS_into_vector_DB.ipynb**
- Reading from IBM Cloud Object Storage
- Handling multiple file formats
- Incremental updates

**Ingestion_of_Expert_Profile_data_to_Vector_DB.ipynb**
- Structured data ingestion
- Custom metadata fields
- Domain-specific chunking

#### **RAG Q&A Notebooks**

**QnA_with_RAG.ipynb**
- End-to-end RAG example
- Multiple query patterns
- Response formatting

**Create_and_Deploy_QnA_AI_Service.ipynb**
- Packaging RAG as a service
- Deployment patterns
- Testing endpoints

**Test_Queries_for_Vector_DB.ipynb**
- Vector store validation
- Retrieval quality checks
- Performance benchmarking

#### **Evaluation Notebooks**

**Analyze_Log_and_Feedback.ipynb**
- Log analysis patterns
- User feedback integration
- Continuous improvement loop

---

## 3. Docker Environment Setup

### 3.1 Dockerfile for watsonx Environment

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /workspace

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Jupyter setup
RUN pip install jupyter jupyterlab

# Create notebook directory
RUN mkdir -p /workspace/notebooks

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
```

### 3.2 Docker Compose Setup

```yaml
# docker-compose.yml
version: '3.8'

services:
  watsonx-workspace:
    build: .
    ports:
      - "8888:8888"
    volumes:
      - ./notebooks:/workspace/notebooks
      - ./data:/workspace/data
      - ./accelerator:/workspace/accelerator
    env_file:
      - .env
    environment:
      - JUPYTER_ENABLE_LAB=yes
```

### 3.3 Makefile Commands

```makefile
# Makefile
.PHONY: help install build run stop clean

help:
	@echo "Available commands:"
	@echo "  make install  - Install dependencies locally"
	@echo "  make build    - Build Docker image"
	@echo "  make run      - Start Docker container"
	@echo "  make stop     - Stop Docker container"
	@echo "  make clean    - Clean up containers and images"

install:
	python -m venv venv
	. venv/bin/activate && pip install -r requirements.txt

build:
	docker-compose build

run:
	docker-compose up -d
	@echo "Jupyter Lab running at http://localhost:8888"

stop:
	docker-compose down

clean:
	docker-compose down -v
	docker system prune -f
```

### 3.4 Using Docker for Labs

```bash
# Build environment
make build

# Start container
make run

# Access Jupyter Lab
# Navigate to http://localhost:8888
# Token will be displayed in console

# Run notebooks inside container
docker-compose exec watsonx-workspace bash
cd notebooks
jupyter nbconvert --execute rag_local_ollama.ipynb

# Stop when done
make stop
```

---

## 4. watsonx_quickstart.ipynb - Initial Setup Notebook

### 4.1 Purpose

The quickstart notebook verifies your watsonx.ai setup before starting labs.

**Location:** `simple-watsonx-environment/notebooks/watsonx_quickstart.ipynb`

### 4.2 Complete Quickstart Code

```python
# %% [markdown]
# # watsonx.ai Quickstart - Environment Verification

# %% [markdown]
# ## 1. Install Dependencies

# %%
!pip install -U "ibm-watsonx-ai>=1.1.22" python-dotenv

# %% [markdown]
# ## 2. Load Credentials

# %%
import os
from dotenv import load_dotenv

# Load from .env file
load_dotenv()

# Verify credentials are set
WATSONX_URL = os.getenv("WATSONX_URL", "https://us-south.ml.cloud.ibm.com")
WATSONX_APIKEY = os.getenv("WATSONX_APIKEY")
WATSONX_PROJECT_ID = os.getenv("WATSONX_PROJECT_ID")

if not WATSONX_APIKEY:
    WATSONX_APIKEY = input("Enter your watsonx.ai API key: ")
    
if not WATSONX_PROJECT_ID:
    WATSONX_PROJECT_ID = input("Enter your watsonx.ai project ID: ")

print("✓ Credentials loaded")

# %% [markdown]
# ## 3. Initialize watsonx.ai Client

# %%
from ibm_watsonx_ai import Credentials, APIClient

credentials = Credentials(
    url=WATSONX_URL,
    api_key=WATSONX_APIKEY
)

api_client = APIClient(
    credentials=credentials,
    project_id=WATSONX_PROJECT_ID
)

print("✓ API client initialized")

# %% [markdown]
# ## 4. List Available Models

# %%
# Get foundation models
models = api_client.foundation_models.get_model_specs()

print(f"✓ Found {len(models)} available models\n")
print("Sample models:")
for model in models[:5]:
    print(f"  - {model['model_id']}")

# %% [markdown]
# ## 5. Test Granite Model

# %%
from ibm_watsonx_ai.foundation_models import Model
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods

# Model parameters
params = {
    GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
    GenParams.MAX_NEW_TOKENS: 100,
    GenParams.MIN_NEW_TOKENS: 1,
    GenParams.TEMPERATURE: 0.0,
}

# Initialize model
model = Model(
    model_id="ibm/granite-3-3-8b-instruct",
    credentials=credentials,
    project_id=WATSONX_PROJECT_ID,
    params=params
)

print("✓ Granite model initialized")

# %% [markdown]
# ## 6. Test Generation

# %%
test_prompt = "What is artificial intelligence? Answer in one sentence."

response = model.generate_text(prompt=test_prompt)

print("Test Prompt:")
print(f"  {test_prompt}")
print("\nGranite Response:")
print(f"  {response}")

# %% [markdown]
# ## 7. Test with Structured Output

# %%
structured_prompt = """List three benefits of RAG systems in JSON format:
{
  "benefits": [
    {"name": "...", "description": "..."},
    {"name": "...", "description": "..."},
    {"name": "...", "description": "..."}
  ]
}"""

response = model.generate_text(prompt=structured_prompt)
print("Structured Response:")
print(response)

# %% [markdown]
# ## 8. Verify Embeddings Access

# %%
from ibm_watsonx_ai.foundation_models import Embeddings

embeddings = Embeddings(
    model_id="ibm/slate-30m-english-rtrvr",
    credentials=credentials,
    project_id=WATSONX_PROJECT_ID
)

test_texts = ["Hello world", "RAG is useful"]
vectors = embeddings.embed_documents(test_texts)

print(f"✓ Embedded {len(test_texts)} texts")
print(f"  Embedding dimension: {len(vectors[0])}")
print(f"  Sample values: {vectors[0][:5]}")

# %% [markdown]
# ## 9. Environment Summary

# %%
print("\n" + "="*80)
print("ENVIRONMENT VERIFICATION SUMMARY")
print("="*80)
print(f"✓ watsonx.ai URL: {WATSONX_URL}")
print(f"✓ API Key: {'*' * 20} (hidden)")
print(f"✓ Project ID: {WATSONX_PROJECT_ID}")
print(f"✓ Available models: {len(models)}")
print(f"✓ Granite model: Working")
print(f"✓ Embeddings: Working")
print("\nReady for Day 2 labs! 🚀")
```

### 4.3 Troubleshooting Checklist

Use this when `watsonx_quickstart.ipynb` fails:

```python
# Troubleshooting cell
def diagnose_setup():
    issues = []
    
    # Check API key
    if not WATSONX_APIKEY or len(WATSONX_APIKEY) < 20:
        issues.append("❌ API key seems invalid or too short")
    else:
        print("✓ API key format looks valid")
    
    # Check project ID format
    if not WATSONX_PROJECT_ID or len(WATSONX_PROJECT_ID) != 36:
        issues.append("❌ Project ID should be 36 characters (UUID format)")
    else:
        print("✓ Project ID format looks valid")
    
    # Check network connectivity
    try:
        import requests
        response = requests.get(WATSONX_URL, timeout=5)
        print(f"✓ Can reach {WATSONX_URL}")
    except Exception as e:
        issues.append(f"❌ Network error: {e}")
    
    # Check authentication
    try:
        api_client.foundation_models.get_model_specs()
        print("✓ Authentication successful")
    except Exception as e:
        issues.append(f"❌ Authentication failed: {e}")
    
    # Summary
    if issues:
        print("\n⚠️  Issues found:")
        for issue in issues:
            print(f"  {issue}")
    else:
        print("\n✅ All checks passed!")

diagnose_setup()
```

---

## 5. Governed Agentic Catalog

### 5.1 Overview

The Governed Agentic Catalog allows you to:
- Register custom tools with code
- Use out-of-the-box IBM tools
- Build governed AI agents
- Track tool usage and governance

**Access:** https://dataplatform.cloud.ibm.com/aigov/modelinventory/ai-tools?context=wx

### 5.2 Registering Custom Tools

```python
# Register a custom RAG retrieval tool
from ibm_watsonx_gov.tools.clients import register_tool, ToolRegistrationPayload

tool_code = """
def rag_retriever(query: str, k: int = 5) -> str:
    '''Retrieve relevant documents for a query'''
    import os
    from langchain_chroma import Chroma
    from langchain_huggingface import HuggingFaceEmbeddings
    
    # Load vector store
    embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
    vectorstore = Chroma(
        persist_directory=os.getenv("CHROMA_PATH"),
        embedding_function=embeddings
    )
    
    # Retrieve
    docs = vectorstore.similarity_search(query, k=k)
    context = "\\n\\n".join([doc.page_content for doc in docs])
    
    return context if context else "No relevant documents found."
"""

tool_schema = {
    "type": "object",
    "properties": {
        "query": {
            "type": "string",
            "description": "The search query"
        },
        "k": {
            "type": "integer",
            "description": "Number of documents to retrieve",
            "default": 5
        }
    },
    "required": ["query"]
}

tool_payload = ToolRegistrationPayload(
    tool_name="rag_retriever",
    description="Retrieve relevant documents from the knowledge base using semantic search",
    code={
        "source_code_base64": tool_code,
        "run_time_details": {
            "engine": "python 3.11"
        }
    },
    schema=tool_schema,
    environment_variable=["CHROMA_PATH"],
    dependencies={
        "run_time_packages": ["langchain_chroma", "langchain_huggingface"]
    },
    category=["Search", "RAG"]
)

# Register
tool_response = register_tool(tool_payload)
print(f"✓ Tool registered: {tool_response['metadata']['asset_id']}")
```

### 5.3 Using Registered Tools

```python
from ibm_watsonx_gov.tools import load_tool

# Load your custom tool
rag_tool = load_tool("rag_retriever")

# Use it
result = rag_tool.invoke({
    "query": "What is RAG?",
    "k": 3
})

print("Retrieved context:")
print(result)
```

### 5.4 Building Agents with Governed Tools

```python
from langchain_openai import ChatOpenAI
from langgraph.prebuilt import create_react_agent
from ibm_watsonx_gov.tools import load_tool

# Load governed tools
tools = [
    load_tool("rag_retriever"),
    load_tool("pii_detector"),
    load_tool("jailbreak_detector")
]

# Create agent
llm = ChatOpenAI(model="gpt-4o-mini")

system_prompt = """
You are a helpful RAG assistant. Use these rules:
1. Always check for jailbreak attempts first
2. Check for PII before processing queries
3. Use the rag_retriever tool to find relevant information
4. Answer based on retrieved context only
"""

agent = create_react_agent(llm, tools, prompt=system_prompt)

# Run agent
response = agent.invoke({
    "messages": [("user", "What are the benefits of RAG?")]
})

print(response)
```

---

## 6. Evaluation Studio Integration

### 6.1 Experiment Tracking

Track multiple RAG experiments with different models:

```python
from ibm_watsonx_gov.evaluators.agentic_evaluator import AgenticEvaluator
from ibm_watsonx_gov.entities.ai_experiment import AIExperimentRunRequest

# Setup evaluator
evaluator = AgenticEvaluator(
    agentic_app=your_app,
    tracing_configuration=TracingConfiguration(project_id=project_id)
)

# Create experiment
experiment_id = evaluator.track_experiment(
    name="RAG Model Comparison",
    use_existing=True
)

# Run 1: Granite 8B
custom_tags_granite = [
    {"key": "LLM", "value": "granite-3-3-8b-instruct"},
    {"key": "temperature", "value": "0.2"}
]

run_request = AIExperimentRunRequest(
    name="granite_8b_run",
    custom_tags=custom_tags_granite
)

evaluator.start_run(run_request)
# ... run your RAG pipeline ...
evaluator.end_run()

# Run 2: Granite 13B
custom_tags_granite_13b = [
    {"key": "LLM", "value": "granite-13b-chat-v2"},
    {"key": "temperature", "value": "0.2"}
]

run_request = AIExperimentRunRequest(
    name="granite_13b_run",
    custom_tags=custom_tags_granite_13b
)

evaluator.start_run(run_request)
# ... run your RAG pipeline ...
evaluator.end_run()

# Compare results
evaluator.compare_ai_experiments(
    ai_experiments=[AIExperiment(asset_id=experiment_id, runs=[])]
)
```

### 6.2 Custom Metrics

```python
from ibm_watsonx_gov.metrics import ContextRelevanceMetric, FaithfulnessMetric, AnswerRelevanceMetric

# Define metrics for each node
retrieval_node = Node(
    name="Document Retrieval",
    metrics_configurations=[
        MetricsConfiguration(
            configuration=AgenticAIConfiguration(
                input_fields=["query"],
                context_fields=["retrieved_docs"]
            ),
            metrics=[ContextRelevanceMetric()]
        )
    ]
)

generation_node = Node(
    name="Answer Generation",
    metrics_configurations=[
        MetricsConfiguration(
            configuration=AgenticAIConfiguration(
                input_fields=["query"],
                context_fields=["retrieved_docs"],
                output_fields=["answer"]
            ),
            metrics=[FaithfulnessMetric()]
        )
    ]
)

# Agent-level metrics
agentic_app = AgenticApp(
    name="RAG Assistant",
    metrics_configuration=MetricsConfiguration(
        metrics=[AnswerRelevanceMetric()],
        metric_groups=[MetricGroup.CONTENT_SAFETY]
    ),
    nodes=[retrieval_node, generation_node]
)
```

---

## 7. Advanced Example: Banking Assistant with LangGraph

### 7.1 Complete Implementation

```python
# Banking Assistant with Experiment Tracking
from langgraph.graph import START, END, StateGraph
from typing_extensions import TypedDict
from langchain_openai import ChatOpenAI
from langchain_chroma import Chroma

# State definition
class BankingState(TypedDict):
    input_text: str
    context: list[str]
    generated_text: str

# Retrieval node
def retrieval_node(state: BankingState, config) -> dict:
    vectorstore = config["configurable"]["vectorstore"]
    retriever = vectorstore.as_retriever(
        search_type="similarity_score_threshold",
        search_kwargs={"k": 3, "score_threshold": 0.1}
    )
    
    context = retriever.invoke(state["input_text"])
    context_text = [doc.page_content for doc in context]
    
    return {"context": context_text}

# Generation node
def generation_node(state: BankingState, config) -> dict:
    llm = config["configurable"]["llm"]
    
    prompt = f"""You are a banking assistant. Answer using only the context:
    
Context: {chr(10).join(state['context'])}

Question: {state['input_text']}

Answer:"""
    
    result = llm.invoke(prompt)
    return {"generated_text": result.content}

# Build graph
def build_banking_app():
    graph = StateGraph(BankingState)
    
    graph.add_node("Bank VectorDb Retrieval", retrieval_node)
    graph.add_node("Bank VectorDb Answer Generation", generation_node)
    
    graph.add_edge(START, "Bank VectorDb Retrieval")
    graph.add_edge("Bank VectorDb Retrieval", "Bank VectorDb Answer Generation")
    graph.add_edge("Bank VectorDb Answer Generation", END)
    
    return graph.compile()

# Run with experiment tracking
banking_app = build_banking_app()

# Test data
test_queries = [
    {"input_text": "How do I open a savings account?"},
    {"input_text": "What is the overdraft protection policy?"},
    {"input_text": "How long does a wire transfer take?"}
]

# Run experiment
evaluator.start_run(run_request)

for query in test_queries:
    result = banking_app.invoke(
        query,
        config={
            "configurable": {
                "llm": ChatOpenAI(model="gpt-4o-mini"),
                "vectorstore": vectorstore
            }
        }
    )
    print(f"Q: {query['input_text']}")
    print(f"A: {result['generated_text']}\n")

evaluator.end_run()

# View results
results_df = evaluator.get_result().to_df()
print(results_df)
```

---

## 8. Troubleshooting Guide

### 8.1 Authentication Issues

**Problem:** 401 Unauthorized
```python
# Diagnose
import requests

def test_auth():
    url = f"{WATSONX_URL}/ml/v4/foundation_model_specs"
    headers = {
        "Authorization": f"Bearer {WATSONX_APIKEY}",
        "Content-Type": "application/json"
    }
    
    response = requests.get(f"{url}?version=2024-03-19", headers=headers)
    
    if response.status_code == 401:
        print("❌ API key is invalid or expired")
        print("   Check: https://cloud.ibm.com/iam/apikeys")
    elif response.status_code == 403:
        print("❌ API key is valid but lacks permissions")
        print("   Check project access in watsonx.ai UI")
    else:
        print(f"✓ Authentication working (status: {response.status_code})")

test_auth()
```

**Solution:**
1. Regenerate API key: https://cloud.ibm.com/iam/apikeys
2. Verify project permissions
3. Check API key hasn't expired

### 8.2 Project Not Found (404)

**Problem:** Invalid project ID
```python
def verify_project():
    try:
        api_client.projects.get_details(WATSONX_PROJECT_ID)
        print(f"✓ Project {WATSONX_PROJECT_ID} exists and is accessible")
    except Exception as e:
        print(f"❌ Project error: {e}")
        print("\nHow to find your project ID:")
        print("1. Go to watsonx.ai")
        print("2. Open your project")
        print("3. Click 'Manage' → 'General' → 'Details'")
        print("4. Copy the 'Project ID' (36 characters)")

verify_project()
```

### 8.3 Environment File Not Loading

**Problem:** `.env` variables not available
```python
import os
from pathlib import Path

def diagnose_env():
    env_path = Path(".env")
    
    if not env_path.exists():
        print("❌ .env file not found")
        print(f"   Expected location: {env_path.absolute()}")
        print("\nCreate .env file with:")
        print("""
WATSONX_URL=https://us-south.ml.cloud.ibm.com
WATSONX_APIKEY=your_key_here
WATSONX_PROJECT_ID=your_project_id_here
        """)
        return
    
    print(f"✓ .env file found at {env_path.absolute()}")
    
    # Check if dotenv is loaded
    from dotenv import load_dotenv
    load_dotenv()
    
    required_vars = ["WATSONX_URL", "WATSONX_APIKEY", "WATSONX_PROJECT_ID"]
    missing = [v for v in required_vars if not os.getenv(v)]
    
    if missing:
        print(f"❌ Missing variables: {missing}")
    else:
        print("✓ All required variables loaded")

diagnose_env()
```

### 8.4 Docker Issues

**Problem:** Port already in use
```bash
# Check what's using port 8888
lsof -i :8888

# Kill the process
kill -9 <PID>

# Or use different port
docker-compose run -p 8889:8888 watsonx-workspace
```

**Problem:** Container won't start
```bash
# Check logs
docker-compose logs watsonx-workspace

# Rebuild from scratch
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

---

## 9. Quick Reference

### 9.1 File Paths Cheat Sheet

```
watsonx-workshop/
├── simple-watsonx-environment/
│   ├── .env                          # Credentials (YOU CREATE)
│   ├── notebooks/
│   │   ├── watsonx_quickstart.ipynb  # Start here
│   │   ├── rag_watsonx.ipynb         # Lab 2.2
│   │   └── rag_twin_compare.ipynb    # Lab 2.3
│   └── data/
│       └── corpus/                   # Your documents
│
├── labs-src/                         # IBM reference notebooks
│   ├── use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb
│   ├── use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb
│   └── use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb
│
└── accelerator/                      # Production code
    ├── rag/
    │   ├── retriever.py
    │   ├── pipeline.py
    │   └── prompt.py
    ├── service/
    │   ├── api.py
    │   └── deps.py
    ├── tools/
    │   ├── chunk.py
    │   ├── extract.py
    │   ├── embed_index.py
    │   └── eval_small.py
    └── assets/
        └── notebook/                 # More IBM examples
```

### 9.2 Command Cheat Sheet

```bash
# Environment setup
python -m venv venv
source venv/bin/activate  # or: venv\Scripts\activate on Windows
pip install -r requirements.txt

# Docker
make build
make run
make stop

# Run notebook
jupyter notebook notebooks/watsonx_quickstart.ipynb

# Run accelerator service
cd accelerator
python -m service.api

# Run evaluation
python -m tools.eval_small \
    --api-url http://localhost:8000/ask \
    --input tests/eval_input.csv \
    --output results/eval_results.csv
```

### 9.3 Essential Imports

```python
# watsonx.ai basics
from ibm_watsonx_ai import Credentials, APIClient
from ibm_watsonx_ai.foundation_models import Model, Embeddings
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

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

---

## 10. Next Steps

After completing supplementary materials:

**Immediate:**
1. ✅ Run `watsonx_quickstart.ipynb` successfully
2. ✅ Register at least one custom tool
3. ✅ Review one reference notebook from labs-src/

**This Week:**
1. ✅ Implement Docker-based workflow
2. ✅ Set up experiment tracking
3. ✅ Build a simple governed agent

**This Month:**
1. ✅ Integrate accelerator components
2. ✅ Deploy RAG service with FastAPI
3. ✅ Set up continuous evaluation pipeline

---

## 11. Additional Resources

### Documentation
- **watsonx.ai Docs:** https://www.ibm.com/docs/en/watsonx-as-a-service
- **watsonx.governance:** https://www.ibm.com/docs/en/watsonx/saas?topic=governance-overview
- **LangGraph:** https://langchain-ai.github.io/langgraph/
- **FastAPI:** https://fastapi.tiangolo.com/

### IBM-Specific
- **Tool Catalog:** https://dataplatform.cloud.ibm.com/aigov/modelinventory/ai-tools
- **Evaluation Studio:** Access via watsonx.governance UI
- **Cloud API Keys:** https://cloud.ibm.com/iam/apikeys

### Community
- **IBM Community:** https://community.ibm.com/community/user/watsonx/home
- **Stack Overflow:** Tag `ibm-watsonx`

---

**Version:** 1.0  
**Last Updated:** January 2025  
**Maintained by:** IBM watsonx.ai Education Team

---

**This supplementary guide complements the main Day 2 RAG workshop materials with IBM-specific tooling and production deployment patterns.**
