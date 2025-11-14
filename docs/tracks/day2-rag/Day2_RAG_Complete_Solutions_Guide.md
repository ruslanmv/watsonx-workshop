# Day 2 RAG Workshop
## Complete Code & Solutions Guide

---

## 📋 Table of Contents {data-background-color="#0f172a"}

Your complete reference

::: notes
Comprehensive solutions for all labs
:::

---

### What's Included

<span class="fragment">1. Theory Summary</span>

<span class="fragment">2. Lab 2.1: Local RAG with Ollama - Complete Solution</span>

<span class="fragment">3. Lab 2.2: RAG with watsonx.ai - Complete Solution</span>

<span class="fragment">4. Lab 2.3: Twin RAG Pipelines - Complete Solution</span>

<span class="fragment">5. Lab 2.4: Evaluation Harness - Complete Solution</span>

<span class="fragment">6. Production Deployment Code</span>

<span class="fragment">7. Troubleshooting Guide</span>

::: notes
Everything you need for success
:::

---

## Theory Summary {data-background-color="#1e1e1e"}

Quick reference

---

### RAG Core Concepts

```python
"""
RAG Pipeline Flow:
1. INGESTION: Documents → Text → Chunking
2. INDEXING: Chunks → Embeddings → Vector Store
3. RETRIEVAL: Query → Embedding → Search → Chunks
4. GENERATION: Query + Context → LLM → Answer
"""
```

::: notes
Four-phase pipeline. Foundation for all labs.
:::

---

### Key Components

```python
COMPONENTS = {
    "Document Store": "Repository of knowledge",
    "Chunker": "Splits docs into units",
    "Embeddings": "Dense vector representations",
    "Vector Store": "Similarity search database",
    "Retriever": "Finds relevant chunks",
    "LLM": "Generates answers",
    "Prompt": "Combines context + question"
}
```

::: notes
Seven core components. Each one matters.
:::

---

## Lab 2.1 Solution: Local RAG {data-background-color="#0f172a" data-transition="zoom"}

Complete working code

---

### Lab 2.1 Overview

**Goal:** Build complete RAG pipeline using local Ollama models

**Stack:**
<span class="fragment">Ollama (LLM)</span>
<span class="fragment">Chroma (Vector Store)</span>
<span class="fragment">HuggingFace (Embeddings)</span>

::: notes
All local. No cloud dependencies for this lab.
:::

---

### Lab 2.1: Configuration

```python {data-line-numbers="1-9"}
CONFIG = {
    "corpus_path": "data/corpus",
    "chunk_size": 1000,
    "chunk_overlap": 200,
    "embedding_model": "all-MiniLM-L6-v2",
    "llm_model": "llama2",
    "vector_db_path": "./chroma_db",
    "top_k": 5
}
```

::: notes
Centralized config. Easy to adjust parameters.
:::

---

### Lab 2.1: Document Loading

```python {data-line-numbers="1-5|7-8"}
from langchain.document_loaders import DirectoryLoader

loader = DirectoryLoader(
    CONFIG["corpus_path"],
    glob="**/*.txt"
)

documents = loader.load()
```

::: notes
Load all text files from directory. Simple and effective.
:::

---

### Lab 2.1: Chunking

```python {data-line-numbers="1-6|8"}
splitter = RecursiveCharacterTextSplitter(
    chunk_size=CONFIG["chunk_size"],
    chunk_overlap=CONFIG["chunk_overlap"],
    separators=["\n\n", "\n", ". ", " "]
)

chunks = splitter.split_documents(documents)
```

::: notes
Recursive splitting. Tries semantic boundaries first.
:::

---

### Lab 2.1: Embeddings

```python {data-line-numbers="1-5"}
embeddings = HuggingFaceEmbeddings(
    model_name=CONFIG["embedding_model"],
    model_kwargs={'device': 'cpu'},
    encode_kwargs={'normalize_embeddings': True}
)
```

::: notes
Local embeddings. No API calls needed.
:::

---

### Lab 2.1: Vector Store

```python {data-line-numbers="1-5|7"}
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory=CONFIG["vector_db_path"]
)

vectorstore.persist()
```

::: notes
Create and persist. Can reload later without re-indexing.
:::

---

### Lab 2.1: RAG Pipeline

```python {data-line-numbers="1-2|4-10"}
llm = Ollama(model=CONFIG["llm_model"])

qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(
        search_kwargs={"k": CONFIG["top_k"]}
    ),
    return_source_documents=True
)
```

::: notes
Chain connects retriever to LLM. Returns answer + sources.
:::

---

### Lab 2.1: Query Function

```python {data-line-numbers="1-3|5-6|8-10"}
def answer_question(query: str):
    result = qa_chain({"query": query})

    return {
        "answer": result['result'],
        "sources": [d.metadata['source']
                    for d in result['source_documents']]
    }
```

::: notes
Clean interface. Returns structured result.
:::

---

### Lab 2.1: Key Achievements ✅

<span class="fragment">Loaded and chunked documents</span>

<span class="fragment">Created embeddings and vector store</span>

<span class="fragment">Built working RAG pipeline</span>

<span class="fragment">Tested with multiple questions</span>

<span class="fragment">Evaluated answer quality</span>

::: notes
Complete local RAG system. Foundation for enterprise version.
:::

---

## Lab 2.2 Solution: watsonx RAG {data-background-color="#1e1e1e" data-transition="slide"}

Enterprise implementation

---

### Lab 2.2 Overview

**Goal:** Implement enterprise-grade RAG using IBM watsonx.ai

**Stack:**
<span class="fragment">watsonx.ai (LLM - Granite)</span>
<span class="fragment">Elasticsearch or Chroma (Vector Store)</span>
<span class="fragment">watsonx Embeddings (slate-30m)</span>

::: notes
Enterprise stack. Production-ready components.
:::

---

### Lab 2.2: Credentials Setup

```python {data-line-numbers="1-4|6-10"}
from dotenv import load_dotenv
load_dotenv()

# Load credentials
credentials = Credentials(
    url=os.getenv("WATSONX_URL"),
    api_key=os.getenv("WATSONX_APIKEY")
)

PROJECT_ID = os.getenv("WATSONX_PROJECT_ID")
```

::: notes
Secure credential management. Never hardcode keys.
:::

---

### Lab 2.2: watsonx Embeddings

```python {data-line-numbers="1-6"}
embeddings = WatsonxEmbeddings(
    model_id="ibm/slate-30m-english-rtrvr",
    url=WATSONX_URL,
    apikey=WATSONX_APIKEY,
    project_id=PROJECT_ID
)
```

::: notes
Enterprise embeddings. Optimized for retrieval.
:::

---

### Lab 2.2: Granite LLM

```python {data-line-numbers="1-5|7-13"}
model_parameters = {
    GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
    GenParams.MAX_NEW_TOKENS: 200,
}

granite_llm = WatsonxLLM(
    model_id="ibm/granite-13b-chat-v2",
    url=WATSONX_URL,
    apikey=WATSONX_APIKEY,
    project_id=PROJECT_ID,
    params=model_parameters
)
```

::: notes
Granite model. IBM's foundation model for enterprise.
:::

---

### Lab 2.2: Custom Prompt for Granite

```python {data-line-numbers="1-12"}
prompt_template = """<|system|>
You are a helpful AI assistant.
Use the provided context to answer accurately.
<|endofsystem|>

<|user|>
Context: {context}
Question: {question}
<|endofuser|>

<|assistant|>
"""
```

::: notes
Granite-specific format. Follow model's expected structure.
:::

---

### Lab 2.2: RAG Pipeline

```python {data-line-numbers="1-9"}
qa_chain = RetrievalQA.from_chain_type(
    llm=granite_llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(
        search_kwargs={"k": 5}
    ),
    return_source_documents=True,
    chain_type_kwargs={"prompt": PROMPT}
)
```

::: notes
Similar structure to Lab 2.1. Different components, same pattern.
:::

---

### Lab 2.2: Key Achievements ✅

<span class="fragment">Connected to watsonx.ai</span>

<span class="fragment">Used watsonx embeddings</span>

<span class="fragment">Integrated Granite model</span>

<span class="fragment">Built enterprise RAG pipeline</span>

::: notes
Enterprise-ready RAG. Scalable and production-grade.
:::

---

## Lab 2.3 Solution: Twin Pipelines {data-background-color="#0f172a" data-transition="zoom"}

Comparison framework

---

### Lab 2.3 Overview

**Goal:** Compare Ollama and watsonx implementations side-by-side

**Metrics:**
<span class="fragment">Response time</span>
<span class="fragment">Sources retrieved</span>
<span class="fragment">Answer quality</span>

::: notes
Scientific comparison. Data-driven decisions.
:::

---

### Lab 2.3: Comparison Function

```python {data-line-numbers="1-8|10-15"}
def compare_rag_backends(query, ollama_chain, granite_chain):
    # Ollama RAG
    start = time.time()
    ollama_result = ollama_chain({"query": query})
    ollama_time = time.time() - start

    # Granite RAG
    start = time.time()
    granite_result = granite_chain({"query": query})
    granite_time = time.time() - start

    return {
        "query": query,
        "ollama_time": ollama_time,
        "granite_time": granite_time,
        # ... more metrics
    }
```

::: notes
Time both systems. Collect comprehensive metrics.
:::

---

### Lab 2.3: Evaluation Queries

```python {data-line-numbers="1-11"}
evaluation_queries = [
    {
        "query": "What is RAG?",
        "category": "definition",
        "expected_concepts": ["retrieval",
                             "generation", "LLM"]
    },
    {
        "query": "What is the weather?",
        "category": "out-of-domain"
    }
]
```

::: notes
Mix of in-domain and out-of-domain. Test edge cases.
:::

---

### Lab 2.3: Visualization

```python {data-line-numbers="1-6"}
# Response time comparison
plt.bar(x - width/2, ollama_times, label='Ollama')
plt.bar(x + width/2, granite_times, label='Granite')
plt.ylabel('Response Time (seconds)')
plt.legend()
plt.savefig('comparison.png')
```

::: notes
Visual comparison. Makes patterns obvious.
:::

---

### Lab 2.3: Key Findings

<span class="fragment">Average response time difference measured</span>

<span class="fragment">Faster system identified</span>

<span class="fragment">Similar source retrieval counts</span>

<span class="fragment">Quality differences documented</span>

::: notes
Data-driven insights. Choose the right tool.
:::

---

## Lab 2.4 Solution: Evaluation Harness {data-background-color="#1e1e1e" data-transition="slide"}

Automated testing

---

### Lab 2.4 Overview

**Goal:** Build automated evaluation pipeline for RAG systems

**Metrics:**
<span class="fragment">Retrieval: Precision, Recall, F1, Hit Rate</span>
<span class="fragment">Answer: ROUGE-L, Concept Coverage</span>

::: notes
Production RAG needs continuous evaluation
:::

---

### Lab 2.4: Ground Truth

```python {data-line-numbers="1-8"}
ground_truth = [
    {
        "query": "What is RAG?",
        "gold_answer": "RAG enhances LLMs...",
        "relevant_doc_ids": ["rag_overview.txt"],
        "must_include_concepts": ["retrieval", "generation"]
    }
]
```

::: notes
Test cases with expected results. Foundation for metrics.
:::

---

### Lab 2.4: Retrieval Metrics

```python {data-line-numbers="1-9"}
def calculate_retrieval_metrics(retrieved, relevant):
    true_positives = len(set(retrieved) & set(relevant))

    precision = true_positives / len(retrieved)
    recall = true_positives / len(relevant)
    f1 = 2 * (precision * recall) / (precision + recall)

    return {"precision": precision, "recall": recall,
            "f1": f1}
```

::: notes
Standard information retrieval metrics
:::

---

### Lab 2.4: Answer Quality Metrics

```python {data-line-numbers="1-8"}
def calculate_answer_metrics(generated, gold, concepts):
    # ROUGE-L score
    scorer = rouge_scorer.RougeScorer(['rougeL'])
    rouge_l = scorer.score(gold, generated)

    # Concept coverage
    coverage = len([c for c in concepts
                   if c in generated]) / len(concepts)

    return {"rouge_l": rouge_l,
            "concept_coverage": coverage}
```

::: notes
Answer quality beyond exact match
:::

---

### Lab 2.4: Evaluation Pipeline

```python {data-line-numbers="1-13"}
def evaluate_rag_system(rag_chain, test_cases):
    results = []
    for test in test_cases:
        response = rag_chain({"query": test["query"]})

        retrieval_metrics = calculate_retrieval_metrics(
            response['source_documents'],
            test["relevant_doc_ids"]
        )

        answer_metrics = calculate_answer_metrics(
            response['result'], test["gold_answer"],
            test["must_include_concepts"]
        )

        results.append({**retrieval_metrics, **answer_metrics})

    return pd.DataFrame(results)
```

::: notes
Automated pipeline. Run on every change.
:::

---

### Lab 2.4: Key Achievements ✅

<span class="fragment">Defined ground truth test cases</span>

<span class="fragment">Implemented retrieval metrics (P/R/F1)</span>

<span class="fragment">Implemented answer quality metrics</span>

<span class="fragment">Evaluated both RAG backends</span>

<span class="fragment">Created visualizations</span>

::: notes
Complete evaluation framework. Production-ready.
:::

---

## Production Deployment Code {data-background-color="#0f172a"}

Accelerator patterns

---

### Production RAG Pipeline

```python {data-line-numbers="1-15"}
# accelerator/rag/pipeline.py
def answer_question(
    query: str,
    vectorstore,
    llm,
    top_k: int = 5
) -> Dict:
    """Production RAG pipeline"""
    retriever = create_retriever(vectorstore, k=top_k)
    prompt = get_rag_prompt()

    qa_chain = RetrievalQA.from_chain_type(
        llm=llm, retriever=retriever,
        return_source_documents=True
    )

    result = qa_chain({"query": query})
    return format_response(result)
```

::: notes
Production code. Error handling, logging, metrics.
:::

---

### FastAPI Endpoint

```python {data-line-numbers="1-15"}
# accelerator/service/api.py
@app.post("/ask")
async def ask_question(request: QuestionRequest):
    """Answer a question using RAG"""
    try:
        result = pipeline.answer_question(
            query=request.query,
            vectorstore=app.state.vectorstore,
            llm=app.state.llm
        )
        return AnswerResponse(**result)
    except Exception as e:
        raise HTTPException(500, detail=str(e))
```

::: notes
REST API. Production-ready deployment.
:::

---

## Troubleshooting Guide {data-background-color="#1e1e1e"}

Common issues and solutions

---

### Issue 1: Ollama Not Responding

```bash
# Check if running
ps aux | grep ollama

# Start if needed
ollama serve

# Test connection
curl http://localhost:11434/api/tags
```

::: notes
Most common local development issue
:::

---

### Issue 2: watsonx Authentication

```python
# Verify credentials
print(f"API Key length: {len(WATSONX_APIKEY)}")
print(f"Project ID valid: {len(PROJECT_ID) == 36}")

# Test simple call
from ibm_watsonx_ai import APIClient
client = APIClient(credentials, project_id)
client.foundation_models.get_model_specs()
```

::: notes
Credential validation. Catch early.
:::

---

### Issue 3: Out of Memory

```python
# Solution: Batch processing
batch_size = 100
for i in range(0, len(chunks), batch_size):
    batch = chunks[i:i+batch_size]
    vectorstore.add_documents(batch)
```

::: notes
Memory management for large corpora
:::

---

### Issue 4: Slow Performance

<span class="fragment">**Reduce top_k parameter**</span>

<span class="fragment">**Use smaller embedding model**</span>

<span class="fragment">**Implement caching**</span>

<span class="fragment">**Consider approximate search**</span>

::: notes
Performance tuning options
:::

---

## Summary {data-background-color="#0f172a" data-transition="zoom"}

What you've learned

---

### Workshop Completion Checklist

<span class="fragment">☑ Understand RAG architecture</span>

<span class="fragment">☑ Implement local RAG with Ollama</span>

<span class="fragment">☑ Build enterprise RAG with watsonx.ai</span>

<span class="fragment">☑ Compare different implementations</span>

<span class="fragment">☑ Create evaluation harness</span>

<span class="fragment">☑ Design production patterns</span>

<span class="fragment">☑ Map to AI Accelerator framework</span>

::: notes
Complete skill set. Ready for production.
:::

---

### Next Steps

**Day 3 Integration:**
<span class="fragment">Implement accelerator components</span>
<span class="fragment">Deploy FastAPI service</span>
<span class="fragment">Build Streamlit UI</span>
<span class="fragment">Set up monitoring</span>

::: notes
Continue the journey
:::

---

### Advanced Topics

<span class="fragment">**Multi-modal RAG** (images, tables)</span>

<span class="fragment">**Agentic RAG systems**</span>

<span class="fragment">**Hybrid search** (keyword + semantic)</span>

<span class="fragment">**Advanced evaluation metrics**</span>

::: notes
Next level of mastery
:::

---

## Congratulations! 🎉 {data-background-color="#0f172a" data-transition="zoom"}

You now have production-ready RAG implementation skills!

**Ready for enterprise AI applications**

::: notes
Celebrate success. Well-earned achievement.
:::