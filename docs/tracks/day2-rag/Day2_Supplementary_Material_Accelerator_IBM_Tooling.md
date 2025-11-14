# Day 2 Supplementary Material
## Accelerator Integration & IBM Tooling

---

## 📋 Overview {data-background-color="#0f172a"}

Advanced enterprise topics

::: notes
Deep dive into IBM-specific tooling and production patterns
:::

---

### Topics Covered

<span class="fragment">1. **Accelerator Project Structure** - Production code organization</span>

<span class="fragment">2. **IBM Reference Notebooks** - Detailed examples</span>

<span class="fragment">3. **Docker Environment Setup** - Container development</span>

<span class="fragment">4. **watsonx_quickstart.ipynb** - Initial setup</span>

<span class="fragment">5. **Governed Agentic Catalog** - Tool registration</span>

<span class="fragment">6. **Evaluation Studio** - Experiment tracking</span>

<span class="fragment">7. **Advanced Examples** - Banking & HR assistants</span>

::: notes
Enterprise-grade content for production deployment
:::

---

## 1. Accelerator Project Structure {data-background-color="#1e1e1e"}

Understanding production code

---

### Accelerator Directory Layout

```
accelerator/
├── rag/                    # Core RAG logic
│   ├── retriever.py        # Vector store queries
│   ├── pipeline.py         # End-to-end orchestration
│   └── prompt.py           # Prompt templates
│
├── service/                # API layer
│   ├── api.py             # FastAPI endpoints
│   └── deps.py            # Configuration
│
├── tools/                  # Batch processing
│   ├── chunk.py
│   ├── extract.py
│   ├── embed_index.py
│   └── eval_small.py
```

::: notes
Production structure. Separation of concerns.
:::

---

### Mapping Labs to Accelerator

| Lab Component | Becomes | Accelerator File |
|---------------|---------|------------------|
| <span class="fragment">Document loading</span> | <span class="fragment">Batch tool</span> | <span class="fragment">`tools/extract.py`</span> |
| <span class="fragment">Chunking logic</span> | <span class="fragment">Batch tool</span> | <span class="fragment">`tools/chunk.py`</span> |
| <span class="fragment">Retrieval function</span> | <span class="fragment">Core RAG</span> | <span class="fragment">`rag/retriever.py`</span> |

::: notes
Labs teach concepts. Accelerator shows production structure.
:::

---

### From Notebook to Production {data-background-color="#0f172a"}

The transformation

---

### Lab Pattern (Prototype)

```python {data-line-numbers="1-6"}
# In notebook
def retrieve(query: str):
    docs = vectorstore.similarity_search(query, k=4)
    return docs

def answer(query: str):
    docs = retrieve(query)
    prompt = build_prompt(query, docs)
    return llm(prompt)
```

::: notes
Simple notebook code. Good for learning.
:::

---

### Accelerator Pattern (Production)

```python {data-line-numbers="1-13"}
# accelerator/rag/retriever.py
class Retriever:
    def __init__(self, vectorstore_config: dict):
        self.vectorstore = self._init_vectorstore(config)

    def retrieve(self, query: str, k: int = 4):
        """Retrieve with error handling & logging"""
        try:
            results = self.vectorstore.similarity_search(
                query, k=k)
            return [self._format_chunk(r) for r in results]
        except Exception as e:
            logger.error(f"Retrieval failed: {e}")
            raise
```

::: notes
Production code. Error handling, logging, metrics.
:::

---

### Key Differences

<span class="fragment">✅ Configuration management via `deps.py`</span>

<span class="fragment">✅ Error handling and logging</span>

<span class="fragment">✅ Structured response format</span>

<span class="fragment">✅ Metrics collection</span>

<span class="fragment">✅ Type hints and validation</span>

::: notes
Production quality matters for enterprise
:::

---

### Service Configuration {data-background-color="#1e1e1e"}

deps.py pattern

---

### Configuration Module

```python {data-line-numbers="1-15"}
# accelerator/service/deps.py
from pydantic import BaseSettings

class Settings(BaseSettings):
    # watsonx.ai
    WATSONX_URL: str
    WATSONX_APIKEY: str
    WATSONX_PROJECT_ID: str
    LLM_MODEL_ID: str = "ibm/granite-3-3-8b-instruct"

    # Vector store
    VECTOR_STORE_TYPE: str = "elasticsearch"
    ES_URL: str = ""

    # RAG parameters
    RETRIEVAL_K: int = 5

    class Config:
        env_file = ".env"

settings = Settings()
```

::: notes
Centralized configuration. Environment-based.
:::

---

### FastAPI Endpoint {data-background-color="#0f172a"}

Production API

---

### REST API Implementation

```python {data-line-numbers="1-20"}
# accelerator/service/api.py
from fastapi import FastAPI, HTTPException

app = FastAPI(title="RAG Service")

@app.post("/ask")
async def ask_question(request: QuestionRequest):
    """Answer using RAG"""
    try:
        pipeline = get_pipeline()
        result = pipeline.answer_question(
            query=request.question,
            k=request.k
        )
        return AnswerResponse(
            answer=result["answer"],
            citations=result["chunks"]
        )
    except Exception as e:
        raise HTTPException(500, detail=str(e))
```

::: notes
RESTful API. Production-ready deployment.
:::

---

## 2. IBM Reference Notebooks {data-background-color="#1e1e1e" data-transition="slide"}

Learn from examples

---

### labs-src/ Notebooks

**Three main patterns:**

<span class="fragment">1. **Elasticsearch + LangChain** - Enterprise vector search</span>

<span class="fragment">2. **Elasticsearch Python SDK** - Direct control</span>

<span class="fragment">3. **Chroma + LangChain** - Local development</span>

::: notes
Different patterns for different needs
:::

---

### Pattern 1: Elasticsearch + LangChain

```python {data-line-numbers="1-8|10-17"}
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
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=vectorstore.as_retriever()
)
```

::: notes
High-level abstraction. Production-ready.
:::

---

### When to Use Each Pattern

<span class="fragment">**Elasticsearch + LangChain:** Production deployments, scalable search</span>

<span class="fragment">**Elasticsearch SDK:** Maximum control, custom search logic</span>

<span class="fragment">**Chroma + LangChain:** Prototyping, local development, small-scale</span>

::: notes
Choose based on requirements and scale
:::

---

### Accelerator Notebooks {data-background-color="#0f172a"}

Production patterns

---

### Key Accelerator Notebooks

**Ingestion:**
<span class="fragment">`Process_and_Ingest_Data_into_Vector_DB.ipynb`</span>
<span class="fragment">`Process_and_Ingest_Data_from_COS_into_vector_DB.ipynb`</span>

**RAG Q&A:**
<span class="fragment">`QnA_with_RAG.ipynb`</span>
<span class="fragment">`Create_and_Deploy_QnA_AI_Service.ipynb`</span>

**Testing:**
<span class="fragment">`Test_Queries_for_Vector_DB.ipynb`</span>

::: notes
Production-ready examples. Copy and adapt.
:::

---

## 3. Docker Environment Setup {data-background-color="#1e1e1e"}

Reproducible development

---

### Dockerfile for watsonx

```dockerfile {data-line-numbers="1-2|4|6-9|11-13|15|17"}
# Dockerfile
FROM python:3.11-slim

WORKDIR /workspace

# System dependencies
RUN apt-get update && apt-get install -y \
    git curl build-essential \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install jupyter jupyterlab

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0",
     "--allow-root"]
```

::: notes
Container-based development. Works everywhere.
:::

---

### Docker Compose Setup

```yaml {data-line-numbers="1-2|4-8|9-13|14-16"}
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

::: notes
Complete development environment in one command
:::

---

### Using Docker for Labs

```bash {data-line-numbers="1-2|4-5|7-10|12-13"}
# Build environment
docker-compose build

# Start container
docker-compose up -d

# Access Jupyter Lab
# Navigate to http://localhost:8888
# Token will be displayed in console

# Stop when done
docker-compose down
```

::: notes
Simple workflow. Consistent environment.
:::

---

## 4. watsonx_quickstart.ipynb {data-background-color="#0f172a"}

Initial setup notebook

---

### Purpose

<span class="fragment">Verify your watsonx.ai setup before starting labs</span>

<span class="fragment">Test credentials and connectivity</span>

<span class="fragment">Validate model access</span>

::: notes
Catch setup issues early. Save time later.
:::

---

### Key Steps

```python {data-line-numbers="1-4|6-11|13-16"}
# 1. Load credentials
from dotenv import load_dotenv
load_dotenv()

# 2. Initialize client
credentials = Credentials(
    url=WATSONX_URL,
    api_key=WATSONX_APIKEY
)
api_client = APIClient(credentials,
                       project_id=PROJECT_ID)

# 3. List models
models = api_client.foundation_models.get_model_specs()
print(f"Found {len(models)} models")
```

::: notes
Three critical validation steps
:::

---

### Test Granite Model

```python {data-line-numbers="1-8|10-11"}
model = Model(
    model_id="ibm/granite-3-3-8b-instruct",
    credentials=credentials,
    project_id=PROJECT_ID,
    params={
        GenParams.MAX_NEW_TOKENS: 100
    }
)

response = model.generate_text("What is AI?")
print(response)
```

::: notes
Verify model access and generation
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
Green checkmarks = ready to proceed
:::

---

## 5. Governed Agentic Catalog {data-background-color="#1e1e1e" data-transition="zoom"}

Enterprise tool management

---

### What is the Governed Catalog?

<span class="fragment">Central repository for AI tools</span>

<span class="fragment">Version control and governance</span>

<span class="fragment">Access control and auditing</span>

<span class="fragment">Reusable across projects</span>

::: notes
Enterprise-grade tool management
:::

---

### Registering Custom Tools

```python {data-line-numbers="1-9|11-17|19-26"}
tool_code = """
def rag_retriever(query: str, k: int = 5) -> str:
    '''Retrieve relevant documents'''
    embeddings = HuggingFaceEmbeddings()
    vectorstore = Chroma(persist_directory=os.getenv("CHROMA_PATH"))
    docs = vectorstore.similarity_search(query, k=k)
    context = "\\n\\n".join([doc.page_content for doc in docs])
    return context if context else "No docs found."
"""

tool_schema = {
    "type": "object",
    "properties": {
        "query": {"type": "string"},
        "k": {"type": "integer", "default": 5}
    },
    "required": ["query"]
}

payload = ToolRegistrationPayload(
    tool_name="rag_retriever",
    description="Retrieve docs from knowledge base",
    code={"source_code_base64": tool_code},
    schema=tool_schema,
    category=["Search", "RAG"]
)

response = register_tool(payload)
```

::: notes
Register custom RAG tool for reuse
:::

---

### Using Registered Tools

```python {data-line-numbers="1-2|4-8"}
from ibm_watsonx_gov.tools import load_tool

# Load your custom tool
rag_tool = load_tool("rag_retriever")

# Use it
result = rag_tool.invoke({
    "query": "What is RAG?",
    "k": 3
})
```

::: notes
Simple interface. Governed access.
:::

---

### Building Agents with Governed Tools {data-background-color="#0f172a"}

LangGraph integration

---

### Agent with Multiple Tools

```python {data-line-numbers="1-6|8-16|18-21"}
from langgraph.prebuilt import create_react_agent

# Load governed tools
tools = [
    load_tool("rag_retriever"),
    load_tool("pii_detector"),
    load_tool("jailbreak_detector")
]

system_prompt = """
You are a helpful RAG assistant. Rules:
1. Check for jailbreak attempts first
2. Check for PII before processing
3. Use rag_retriever to find information
4. Answer based on retrieved context only
"""

agent = create_react_agent(llm, tools,
                           prompt=system_prompt)

response = agent.invoke({
    "messages": [("user", "What are RAG benefits?")]
})
```

::: notes
Multi-tool agent. Governed and secure.
:::

---

## 6. Evaluation Studio Integration {data-background-color="#1e1e1e"}

Experiment tracking

---

### Experiment Tracking

```python {data-line-numbers="1-7|9-16|18-24"}
from ibm_watsonx_gov.evaluators.agentic_evaluator
    import AgenticEvaluator

evaluator = AgenticEvaluator(
    agentic_app=your_app,
    tracing_configuration=TracingConfiguration(
        project_id=project_id)
)

# Create experiment
experiment_id = evaluator.track_experiment(
    name="RAG Model Comparison",
    use_existing=True
)

# Run 1: Granite 8B
custom_tags = [
    {"key": "LLM", "value": "granite-8b"},
    {"key": "temperature", "value": "0.2"}
]

run_request = AIExperimentRunRequest(
    name="granite_8b_run",
    custom_tags=custom_tags
)

evaluator.start_run(run_request)
# ... run your RAG pipeline ...
evaluator.end_run()
```

::: notes
Track experiments. Compare models scientifically.
:::

---

### Custom Metrics

```python {data-line-numbers="1-12"}
from ibm_watsonx_gov.metrics import
    ContextRelevanceMetric, FaithfulnessMetric

retrieval_node = Node(
    name="Document Retrieval",
    metrics_configurations=[
        MetricsConfiguration(
            metrics=[ContextRelevanceMetric()]
        )
    ]
)

generation_node = Node(
    name="Answer Generation",
    metrics_configurations=[
        MetricsConfiguration(
            metrics=[FaithfulnessMetric()]
        )
    ]
)
```

::: notes
Node-level metrics. Track every stage.
:::

---

## 7. Advanced Example: Banking Assistant {data-background-color="#0f172a"}

LangGraph in action

---

### Banking Assistant Architecture

```python {data-line-numbers="1-6|8-15|17-21"}
class BankingState(TypedDict):
    input_text: str
    context: list[str]
    generated_text: str

# Retrieval node
def retrieval_node(state: BankingState, config):
    vectorstore = config["configurable"]["vectorstore"]
    retriever = vectorstore.as_retriever(k=3)

    context = retriever.invoke(state["input_text"])
    return {"context": [doc.page_content
                       for doc in context]}

# Generation node
def generation_node(state: BankingState, config):
    llm = config["configurable"]["llm"]
    prompt = build_prompt(state['context'],
                         state['input_text'])
    result = llm.invoke(prompt)
    return {"generated_text": result.content}
```

::: notes
Stateful graph. Multiple nodes.
:::

---

### Build and Run

```python {data-line-numbers="1-9|11-20"}
def build_banking_app():
    graph = StateGraph(BankingState)

    graph.add_node("Retrieval", retrieval_node)
    graph.add_node("Generation", generation_node)

    graph.add_edge(START, "Retrieval")
    graph.add_edge("Retrieval", "Generation")
    graph.add_edge("Generation", END)

    return graph.compile()

# Run
banking_app = build_banking_app()
result = banking_app.invoke(
    {"input_text": "How do I open a savings account?"},
    config={"configurable": {
        "llm": llm, "vectorstore": vectorstore
    }}
)
```

::: notes
Graph execution. Flexible and powerful.
:::

---

## 8. Troubleshooting Guide {data-background-color="#1e1e1e"}

Common issues

---

### Authentication Issues

```python {data-line-numbers="1-15"}
def test_auth():
    url = f"{WATSONX_URL}/ml/v4/foundation_model_specs"
    headers = {
        "Authorization": f"Bearer {WATSONX_APIKEY}"
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 401:
        print("❌ API key invalid or expired")
    elif response.status_code == 403:
        print("❌ API key lacks permissions")
    else:
        print("✓ Authentication working")

test_auth()
```

::: notes
Diagnose auth problems quickly
:::

---

### Project Not Found

```python {data-line-numbers="1-10"}
def verify_project():
    try:
        api_client.projects.get_details(PROJECT_ID)
        print(f"✓ Project {PROJECT_ID} accessible")
    except Exception as e:
        print(f"❌ Project error: {e}")
        print("\nFind your project ID:")
        print("1. Go to watsonx.ai")
        print("2. Open project → Manage → General")
        print("3. Copy 'Project ID' (36 chars)")
```

::: notes
Step-by-step project verification
:::

---

### Docker Issues

```bash {data-line-numbers="1-2|4-5|7-10"}
# Port already in use
lsof -i :8888

# Kill process
kill -9 <PID>

# Or use different port
docker-compose run -p 8889:8888
    watsonx-workspace
```

::: notes
Common Docker problems solved
:::

---

## Summary {data-background-color="#0f172a" data-transition="slide"}

Key takeaways

---

### What You've Learned

<span class="fragment">✅ Accelerator project structure and patterns</span>

<span class="fragment">✅ IBM reference notebooks and when to use them</span>

<span class="fragment">✅ Docker-based development workflow</span>

<span class="fragment">✅ watsonx.ai setup and verification</span>

<span class="fragment">✅ Governed tool registration and usage</span>

<span class="fragment">✅ Experiment tracking with Evaluation Studio</span>

<span class="fragment">✅ Advanced LangGraph agents</span>

::: notes
Enterprise-grade RAG development skills
:::

---

### Next Steps

**Immediate:**
<span class="fragment">Run watsonx_quickstart.ipynb</span>
<span class="fragment">Review one reference notebook</span>

**This Week:**
<span class="fragment">Set up Docker environment</span>
<span class="fragment">Register a custom tool</span>

**This Month:**
<span class="fragment">Deploy production RAG service</span>
<span class="fragment">Implement continuous evaluation</span>

::: notes
Concrete action items
:::

---

## Additional Resources {data-background-color="#1e1e1e"}

Links and documentation

---

### Documentation

<span class="fragment">**watsonx.ai:** https://ibm.com/docs/watsonx-as-a-service</span>

<span class="fragment">**watsonx.governance:** https://ibm.com/docs/watsonx/governance</span>

<span class="fragment">**LangGraph:** https://langchain-ai.github.io/langgraph/</span>

<span class="fragment">**FastAPI:** https://fastapi.tiangolo.com/</span>

::: notes
Essential documentation links
:::

---

### IBM Platform

<span class="fragment">**Tool Catalog:** https://dataplatform.cloud.ibm.com/aigov/</span>

<span class="fragment">**Cloud API Keys:** https://cloud.ibm.com/iam/apikeys</span>

<span class="fragment">**Community:** https://community.ibm.com/watsonx/</span>

::: notes
IBM-specific resources
:::

---

## Supplementary Material Complete! {data-background-color="#0f172a" data-transition="zoom"}

**Enterprise-ready RAG development with IBM tooling**

**Version:** 1.0
**Last Updated:** January 2025
**Maintained by:** IBM watsonx.ai Education Team

::: notes
Complete IBM tooling guide. Production-ready patterns.
:::