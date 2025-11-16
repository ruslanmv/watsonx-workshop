# Module 1: RAG Architecture Overview

---

## 📚 Learning Objectives

By the end of this module, you will be able to:

---

### What You'll Master

<span class="fragment">Define Retrieval Augmented Generation and explain its value</span>

<span class="fragment">Identify the core components of a RAG system</span>

<span class="fragment">Describe the typical RAG flow from ingestion to generation</span>

<span class="fragment">Understand trade-offs in RAG system design</span>

<span class="fragment">Map RAG concepts to the AI Accelerator framework</span>

::: notes
Set clear learning objectives. Students know what to expect.
:::

---

## 1. What is RAG? {data-background-color="#0f172a"}

Understanding the fundamentals

::: notes
Start with the problem, then introduce the solution
:::

---

### Definition

**Retrieval Augmented Generation (RAG)**

A technique that enhances Large Language Models by providing them with relevant external knowledge retrieved from a document corpus.

::: notes
Simple, clear definition. Foundation for everything that follows.
:::

---

### Visual Comparison

```
Traditional LLM:           RAG-Enhanced LLM:

User Query                User Query
    ↓                          ↓
   LLM  →  Answer          Retriever → Relevant Docs
                                ↓
                            LLM + Context  →  Grounded Answer
```

::: notes
Visual learners appreciate the flow diagram. Shows the difference clearly.
:::

---

## The Problem RAG Solves {data-transition="slide"}

Why do we need RAG?

---

### LLM Challenges

<span class="fragment">**1. Knowledge Cutoff** - Training data is frozen at a point in time</span>

<span class="fragment">**2. Hallucinations** - Models may generate plausible but incorrect information</span>

<span class="fragment">**3. Domain Specificity** - Lack of specialized or proprietary knowledge</span>

<span class="fragment">**4. Attribution** - Difficulty in citing sources for generated content</span>

::: notes
Real problems that RAG addresses. Students can relate to these issues.
:::

---

### RAG Solutions

<span class="fragment">Retrieving up-to-date, relevant information at query time</span>

<span class="fragment">Grounding responses in actual source documents</span>

<span class="fragment">Enabling domain-specific knowledge without retraining</span>

<span class="fragment">Providing source attribution for transparency</span>

::: notes
One-to-one mapping of problems to solutions. Clear value proposition.
:::

---

## Real-World Use Cases {data-background-color="#1e1e1e"}

RAG in action

---

### 🎧 Customer Support Chatbot

**Query:** "How do I reset my password?"

<span class="fragment">**RAG retrieves:** Latest help documentation</span>

<span class="fragment">**Response:** Current, accurate reset procedure</span>

::: notes
Concrete example. Shows immediate practical value.
:::

---

### ⚖️ Legal Document Analysis

**Query:** "What are precedents for contract disputes?"

<span class="fragment">**RAG retrieves:** Relevant case law and contracts</span>

<span class="fragment">**Response:** Contextual legal analysis with citations</span>

::: notes
High-stakes domain where accuracy and attribution matter
:::

---

### 🏥 Medical Information Systems

**Query:** "Treatment options for condition X?"

<span class="fragment">**RAG retrieves:** Latest medical literature and guidelines</span>

<span class="fragment">**Response:** Evidence-based treatment recommendations</span>

::: notes
Safety-critical application. Must be grounded in facts.
:::

---

### 🏢 Enterprise Knowledge Management

**Query:** "What's our policy on remote work?"

<span class="fragment">**RAG retrieves:** Company policy documents</span>

<span class="fragment">**Response:** Accurate policy information with references</span>

::: notes
Common enterprise use case. Shows business value.
:::

---

## 2. Core Components of RAG {data-background-color="#0f172a" data-transition="zoom"}

Building blocks of RAG systems

::: notes
Now dive into the architecture. This is the meat of the module.
:::

---

### 2.1 Document Store / Corpus

**Purpose:** The knowledge base containing documents to be searched

---

### Document Store Characteristics

<span class="fragment">**Format:** PDFs, HTML, markdown, plain text, structured data</span>

<span class="fragment">**Scale:** From hundreds to millions of documents</span>

<span class="fragment">**Domain:** General knowledge, domain-specific, or proprietary data</span>

::: notes
Documents are the foundation. Quality in, quality out.
:::

---

### Document Structure Example

```python {data-line-numbers="1-2|3-4|5-10"}
# Document structure
document = {
    "id": "doc_12345",
    "title": "Employee Handbook 2024",
    "text": "Company policies and procedures...",
    "metadata": {
        "author": "HR Department",
        "date": "2024-01-15",
        "category": "policies"
    }
}
```

::: notes
Line-by-line: ID for tracking, title for context, text is the content, metadata for filtering
:::

---

### 2.2 Chunking / Preprocessing {data-background-color="#1e1e1e"}

**Purpose:** Split large documents into manageable, semantic units

---

### Why Chunking Matters

<span class="fragment">Embedding models have token limits (e.g., 512 tokens)</span>

<span class="fragment">Smaller chunks = more precise retrieval</span>

<span class="fragment">Balanced chunk size improves relevance</span>

::: notes
Chunking is critical. Too large misses specifics, too small misses context.
:::

---

### Chunking Strategy 1: Fixed-Size

```python {data-line-numbers="1-2"}
chunk_size = 500  # characters or tokens
chunk_overlap = 50  # overlap for context continuity
```

<span class="fragment">✅ **Pro:** Simple to implement</span>

<span class="fragment">❌ **Con:** May break semantic units</span>

::: notes
Simplest approach but can cut sentences mid-thought
:::

---

### Chunking Strategy 2: Semantic

<span class="fragment">Split by paragraphs, sections, or sentences</span>

<span class="fragment">Preserve natural text boundaries</span>

<span class="fragment">Better semantic coherence</span>

<span class="fragment">✅ **Pro:** Maintains meaning</span>

<span class="fragment">❌ **Con:** Variable chunk sizes</span>

::: notes
Better for comprehension but harder to implement
:::

---

### Chunking Strategy 3: Recursive

```python {data-line-numbers="1-6"}
# Try to split by:
# 1. Double newline (paragraphs)
# 2. Single newline (sentences)
# 3. Spaces (words)
# 4. Characters (last resort)
```

<span class="fragment">✅ **Best of both worlds**</span>

::: notes
LangChain's default. Tries semantic first, falls back to fixed if needed.
:::

---

### Chunking Best Practices

<span class="fragment">1. Include some overlap between chunks (10-20%)</span>

<span class="fragment">2. Preserve document metadata in each chunk</span>

<span class="fragment">3. Test different chunk sizes for your use case</span>

<span class="fragment">4. Typical range: 500-1500 tokens</span>

::: notes
Rules of thumb from production experience
:::

---

### 2.3 Embeddings {data-background-color="#0f172a"}

**Purpose:** Convert text into dense vector representations for semantic similarity

---

### How Embeddings Work

```
Text: "The cat sat on the mat"
       ↓
Embedding Model
       ↓
Vector: [0.23, -0.45, 0.67, ..., 0.12]
        384-1536 dimensions
```

::: notes
Text becomes numbers. Similar meanings = similar vectors.
:::

---

### Popular Embedding Models

| Model | Dimensions | Use Case |
|-------|-----------|----------|
| all-MiniLM-L6-v2 | 384 | Fast, lightweight |
| all-mpnet-base-v2 | 768 | Balanced performance |
| text-embedding-ada-002 | 1536 | High quality |
| slate-30m-english-rtrvr | 384 | Retrieval-optimized |

::: notes
Different models for different needs. Trade-offs between speed and quality.
:::

---

### Key Embedding Concepts

<span class="fragment">**Semantic Similarity:** Similar meanings = similar vectors</span>

<span class="fragment">**Cosine Similarity:** Measures angle between vectors (0-1)</span>

<span class="fragment">**Dense vs Sparse:** Dense = all dimensions used; Sparse = mostly zeros</span>

::: notes
Mathematical foundation. Don't need deep math, but understand the concepts.
:::

---

### 2.4 Vector Store {data-background-color="#1e1e1e"}

**Purpose:** Specialized database for storing and searching embeddings

---

### Why Not Regular Databases?

<span class="fragment">**Traditional DBs:** Exact match (WHERE clause)</span>

<span class="fragment">**Vector DBs:** Similarity search (nearest neighbors)</span>

<span class="fragment">Optimized for high-dimensional vector operations</span>

::: notes
Different problem requires different solution. SQL can't do semantic search efficiently.
:::

---

### Popular Vector Stores

**Chroma** - Local, lightweight
```python {data-line-numbers="1-2"}
from langchain_chroma import Chroma
vectorstore = Chroma.from_documents(docs, embeddings)
```

::: notes
Perfect for development and small deployments
:::

---

### Elasticsearch - Enterprise, scalable

```python {data-line-numbers="1-5"}
from langchain_elasticsearch import ElasticsearchStore
vectorstore = ElasticsearchStore(
    elasticsearch_url=url,
    index_name="my_index"
)
```

::: notes
Production-grade. Handles millions of vectors.
:::

---

### FAISS - High-performance, in-memory

```python {data-line-numbers="1-2"}
from langchain_community.vectorstores import FAISS
vectorstore = FAISS.from_documents(docs, embeddings)
```

::: notes
From Facebook AI Research. Ultra-fast for large-scale.
:::

---

### Vector Store Operations

```python {data-line-numbers="1-2|4-8|10-14"}
# Add documents
vectorstore.add_documents(documents)

# Similarity search
results = vectorstore.similarity_search(
    query="What is the refund policy?",
    k=5  # return top 5 results
)

# Similarity search with scores
results = vectorstore.similarity_search_with_score(
    query="What is the refund policy?",
    k=5
)
```

::: notes
Three key operations: add, search, search with scores
:::

---

### 2.5 Retriever {data-background-color="#0f172a"}

**Purpose:** Interface to query the vector store and return relevant documents

---

### Retrieval Strategy 1: Similarity Search

```python {data-line-numbers="1-4"}
retriever = vectorstore.as_retriever(
    search_type="similarity",
    search_kwargs={"k": 4}
)
```

<span class="fragment">Returns top-k most similar documents</span>

::: notes
Simplest retrieval. Just get the closest matches.
:::

---

### Retrieval Strategy 2: MMR

**MMR = Maximum Marginal Relevance**

```python {data-line-numbers="1-4"}
retriever = vectorstore.as_retriever(
    search_type="mmr",
    search_kwargs={"k": 4, "fetch_k": 20}
)
```

<span class="fragment">Balances relevance and diversity</span>

<span class="fragment">Avoids redundant results</span>

::: notes
Better for diverse results. Fetch 20, return 4 most diverse.
:::

---

### Retrieval Strategy 3: Threshold

```python {data-line-numbers="1-4"}
retriever = vectorstore.as_retriever(
    search_type="similarity_score_threshold",
    search_kwargs={"score_threshold": 0.7, "k": 4}
)
```

<span class="fragment">Only return results above threshold</span>

<span class="fragment">Ensures quality over quantity</span>

::: notes
Better to return nothing than bad results
:::

---

### 2.6 LLM + Prompt {data-background-color="#1e1e1e"}

**Purpose:** Generate answers using retrieved context

---

### Prompt Pattern for RAG

```python {data-line-numbers="1-11"}
prompt_template = """
Use the following context to answer the question.
If you don't know the answer, say you don't know,
don't try to make up an answer.

Context: {context}

Question: {question}

Answer:
"""
```

::: notes
Clear instructions reduce hallucinations. Give LLM an out.
:::

---

### LLM Options

**Local:**
<span class="fragment">Ollama (llama2, mistral)</span>

**Cloud:**
<span class="fragment">watsonx.ai (Granite)</span>
<span class="fragment">OpenAI (GPT)</span>
<span class="fragment">Anthropic (Claude)</span>

::: notes
Choose based on privacy, cost, and performance needs
:::

---

## 3. Typical RAG Flow {data-background-color="#0f172a" data-transition="zoom"}

Putting it all together

---

### Complete RAG Pipeline

```
Raw Documents →[Extract]→ Text Content
    ↓
[Chunk]→ Document Chunks
    ↓
[Embed]→ Vectors
    ↓
[Index]→ Vector Store

User Query →[Embed]→ Query Vector
    ↓
[Search]→ Vector Store → Relevant Chunks
    ↓
[Context] + [Question] → LLM → Answer
```

::: notes
End-to-end flow. Two phases: setup and query.
:::

---

### Phase 1: Ingestion (One-Time Setup) {data-background-color="#1e1e1e"}

Preparing your knowledge base

---

### Step 1: Extract

```python {data-line-numbers="1-6|8-9"}
# Extract text from various formats
from langchain.document_loaders import (
    PyPDFLoader,
    TextLoader,
    UnstructuredHTMLLoader
)

loader = PyPDFLoader("employee_handbook.pdf")
documents = loader.load()
```

::: notes
First step: get text out of files. Different loaders for different formats.
:::

---

### Step 2: Chunk

```python {data-line-numbers="1-2|4-7|8"}
from langchain.text_splitters import
    RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
chunks = splitter.split_documents(documents)
```

::: notes
Break documents into pieces. Overlap maintains context continuity.
:::

---

### Phase 2: Indexing (One-Time Setup) {data-background-color="#0f172a"}

Creating the vector database

---

### Step 3: Embed

```python {data-line-numbers="1-2|4-6"}
from langchain_community.embeddings import
    HuggingFaceEmbeddings

embeddings = HuggingFaceEmbeddings(
    model_name="all-MiniLM-L6-v2"
)
```

::: notes
Initialize embedding model. Will convert text to vectors.
:::

---

### Step 4: Index

```python {data-line-numbers="1|3-7"}
from langchain_chroma import Chroma

vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory="./chroma_db"
)
```

::: notes
Create vector store. Persist to disk for reuse.
:::

---

### Phase 3: Retrieval (Per Query) {data-background-color="#1e1e1e"}

Answering user questions

---

### Steps 5-7: Query & Retrieve

```python {data-line-numbers="1-2|4-6|8-10"}
# User asks a question
query = "What is the vacation policy?"

# Retrieve relevant chunks
retriever = vectorstore.as_retriever(k=4)
relevant_docs = retriever.get_relevant_documents(query)

# Each doc contains:
# - page_content: The text chunk
# - metadata: Document info
```

::: notes
Query phase happens for each user question. Fast because vectors are pre-computed.
:::

---

### Phase 4: Generation (Per Query) {data-background-color="#0f172a"}

Creating the final answer

---

### Steps 8-10: Generate Answer

```python {data-line-numbers="1-2|4|6-11|13-15"}
from langchain.chains import RetrievalQA
from langchain_community.llms import Ollama

llm = Ollama(model="llama2")

qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=retriever,
    return_source_documents=True
)

result = qa_chain({"query": query})
print(result['result'])  # Answer
print(result['source_documents'])  # Sources
```

::: notes
Chain connects retriever to LLM. Returns answer AND sources.
:::

---

## 4. Trade-Offs in RAG Design {data-background-color="#1e1e1e" data-transition="slide"}

Engineering decisions matter

---

### 4.1 Latency vs Accuracy

The eternal trade-off

---

### Latency Factors

<span class="fragment">Embedding model size</span>

<span class="fragment">Vector store query time</span>

<span class="fragment">Number of retrieved chunks (k)</span>

<span class="fragment">LLM size and parameters</span>

::: notes
Every component affects speed. Must balance all factors.
:::

---

### Optimization Strategies

```python {data-line-numbers="1-4|6-9"}
# Faster (lower latency)
embeddings = HuggingFaceEmbeddings("all-MiniLM-L6-v2")
k = 3  # fewer chunks
llm = Ollama("llama2:7b")  # smaller model

# More accurate (higher latency)
embeddings = HuggingFaceEmbeddings("all-mpnet-base-v2")
k = 10  # more chunks
llm = WatsonxLLM("ibm/granite-13b-chat-v2")
```

::: notes
Clear trade-off. Fast and cheap vs slow and accurate.
:::

---

### 4.2 Embedding Model Selection {data-background-color="#0f172a"}

Choosing the right model

---

### Selection Criteria

<span class="fragment">**Domain:** General vs specialized (legal, medical, etc.)</span>

<span class="fragment">**Language:** Multilingual support needed?</span>

<span class="fragment">**Dimensions:** Higher = more nuance, slower</span>

<span class="fragment">**License:** Open-source vs proprietary</span>

::: notes
No one-size-fits-all. Choose based on requirements.
:::

---

### Model Comparison

| Criteria | Small Model | Large Model |
|----------|-------------|-------------|
| Speed | ⚡⚡⚡ | ⚡ |
| Accuracy | ⭐⭐ | ⭐⭐⭐ |
| Memory | 💾 | 💾💾💾 |
| Cost | $ | $$$ |

::: notes
Visual comparison helps decision-making
:::

---

### 4.3 Index Size and Refresh {data-background-color="#1e1e1e"}

Managing your knowledge base

---

### Index Size Trade-offs

**Large Index:**
<span class="fragment">✅ More comprehensive knowledge</span>
<span class="fragment">❌ Slower queries, more storage</span>

**Small Index:**
<span class="fragment">✅ Faster queries, less storage</span>
<span class="fragment">❌ May miss relevant information</span>

::: notes
Size affects both quality and performance
:::

---

### Refresh Strategy 1: Batch Refresh

```python {data-line-numbers="1-3"}
# Full reindex (daily/weekly)
vectorstore.delete_collection()
vectorstore = Chroma.from_documents(new_docs, embeddings)
```

<span class="fragment">Simple but disruptive</span>

::: notes
Nuclear option. Rebuilds everything from scratch.
:::

---

### Refresh Strategy 2: Incremental Updates

```python {data-line-numbers="1-2|4-6"}
# Add new documents
vectorstore.add_documents(new_docs)

# Update existing
vectorstore.delete(ids=["doc_123"])
vectorstore.add_documents([updated_doc])
```

<span class="fragment">Efficient for small changes</span>

::: notes
Surgical updates. Better for production systems.
:::

---

### Refresh Strategy 3: Hot/Cold Separation

<span class="fragment">**Frequently accessed:** In-memory, fast index</span>

<span class="fragment">**Archival:** Disk-based, slower but comprehensive</span>

<span class="fragment">Best of both worlds</span>

::: notes
Tiered storage. Common pattern in production.
:::

---

## 5. RAG in the AI Accelerator {data-background-color="#0f172a" data-transition="zoom"}

Production patterns

---

### Accelerator Architecture

```
accelerator/
├── tools/
│   ├── chunk.py          # Document chunking
│   ├── extract.py        # Text extraction
│   └── embed_index.py    # Embedding & indexing
├── rag/
│   ├── retriever.py      # Retrieval logic
│   ├── pipeline.py       # End-to-end RAG
│   └── prompt.py         # Prompt templates
└── service/
    └── api.py            # FastAPI endpoints
```

::: notes
Production structure. Separation of concerns.
:::

---

### Component 1: Document Chunking

```python {data-line-numbers="1-7"}
# tools/chunk.py
def chunk_documents(
    documents: List[Document],
    chunk_size: int = 1000,
    chunk_overlap: int = 200
) -> List[Document]:
    """Split documents into chunks"""
```

::: notes
Reusable tool. Configuration via parameters.
:::

---

### Component 2: Text Extraction

```python {data-line-numbers="1-6"}
# tools/extract.py
def extract_text(
    file_path: str,
    file_type: str
) -> str:
    """Extract text from PDF, HTML, etc."""
```

::: notes
Abstraction layer. Handle different file types.
:::

---

### Component 3: Embedding & Indexing

```python {data-line-numbers="1-6"}
# tools/embed_index.py
def embed_and_index(
    chunks: List[Document],
    vector_store_config: dict
) -> VectorStore:
    """Embed chunks and store in vector DB"""
```

::: notes
Batch processing tool. Run offline for large corpora.
:::

---

### Component 4: Retrieval

```python {data-line-numbers="1-7"}
# rag/retriever.py
def retrieve(
    query: str,
    vectorstore: VectorStore,
    k: int = 5
) -> List[Document]:
    """Retrieve relevant documents"""
```

::: notes
Core RAG logic. Called on every query.
:::

---

### Component 5: RAG Pipeline

```python {data-line-numbers="1-12"}
# rag/pipeline.py
def answer_question(
    query: str,
    retriever: Retriever,
    llm: BaseLLM
) -> dict:
    """
    Returns:
        {"answer": str, "chunks": List[dict],
         "metadata": dict}
    """
```

::: notes
Orchestration layer. Connects all pieces.
:::

---

### Component 6: Prompt Templates

```python {data-line-numbers="1-3|5-11"}
# rag/prompt.py
SYSTEM_PROMPT = """
You are a helpful assistant that answers questions
based on the provided context.
"""

USER_TEMPLATE = """
Context: {context}
Question: {question}
Answer:
"""
```

::: notes
Centralized prompts. Easy to version and test.
:::

---

### Reference Notebooks {data-background-color="#1e1e1e"}

Located in `accelerator/assets/notebook/`

---

### Key Notebooks

<span class="fragment">**Process_and_Ingest_Data_into_Vector_DB.ipynb**
Complete ingestion pipeline</span>

<span class="fragment">**QnA_with_RAG.ipynb**
Query answering examples</span>

<span class="fragment">**Test_Queries_for_Vector_DB.ipynb**
Testing retrieval quality</span>

::: notes
Learn by example. These show production patterns.
:::

---

## 6. How Day 2 Labs Map to RAG Components {data-background-color="#0f172a"}

Your learning journey

---

### Lab Progression

```
Lab 2.1 (Local RAG)
    ↓
Learn: Basic RAG flow, Ollama, Chroma
Maps to: chunk.py, embed_index.py basics

Lab 2.2 (watsonx RAG)
    ↓
Learn: Enterprise RAG, Elasticsearch, watsonx.ai
Maps to: retriever.py, pipeline.py
```

::: notes
Labs build progressively toward production patterns
:::

---

### Lab Progression (Continued)

```
Lab 2.3 (Twin Pipelines)
    ↓
Learn: Multi-backend orchestration, comparison
Maps to: Service layer design, api.py

Lab 2.4 (Evaluation)
    ↓
Learn: Metrics, testing, optimization
Maps to: tools/eval_small.py, monitoring
```

::: notes
Each lab adds a layer of production readiness
:::

---

### Progressive Implementation

<span class="fragment">**Lab 2.1:** Core concepts in notebook</span>

<span class="fragment">**Lab 2.2:** Enterprise patterns</span>

<span class="fragment">**Lab 2.3:** Service design</span>

<span class="fragment">**Lab 2.4:** Quality assurance</span>

::: notes
By end of Day 2, ready for production integration
:::

---

### By End of Day 2

<span class="fragment">✅ Understand all RAG components</span>

<span class="fragment">✅ Implement multiple RAG backends</span>

<span class="fragment">✅ Ready to integrate into accelerator</span>

<span class="fragment">✅ Evaluate and optimize RAG systems</span>

::: notes
Complete skill set for enterprise RAG development
:::

---

## Summary {data-background-color="#0f172a" data-transition="slide"}

Key takeaways

---

### Key Takeaway 1

**RAG = Retrieval + Generation**

<span class="fragment">Grounds LLM responses in external knowledge</span>

<span class="fragment">Reduces hallucinations through factual context</span>

::: notes
Remember the core concept. Everything else builds on this.
:::

---

### Key Takeaway 2

**Core Pipeline:**

Ingest → Index → Retrieve → Generate

::: notes
Four phases. Memorize this flow.
:::

---

### Key Takeaway 3

**Critical Components:**

<span class="fragment">Chunking strategy</span>
<span class="fragment">Embedding model</span>
<span class="fragment">Vector store</span>
<span class="fragment">Retrieval mechanism</span>
<span class="fragment">LLM integration</span>

::: notes
Each component has trade-offs. Choose wisely.
:::

---

### Key Takeaway 4

**Trade-offs Matter**

<span class="fragment">Latency vs accuracy</span>
<span class="fragment">Index size vs freshness</span>
<span class="fragment">Cost vs performance</span>

::: notes
Engineering is about trade-offs. No perfect solution.
:::

---

### Key Takeaway 5

**Production-Ready**

<span class="fragment">Use accelerator patterns</span>
<span class="fragment">Implement evaluation</span>
<span class="fragment">Monitor and iterate</span>

::: notes
Production requires more than just working code
:::

---

## Next Steps {data-background-color="#1e1e1e"}

Your action items

---

### Immediate Next Steps

<span class="fragment">1. Review this theory document</span>

<span class="fragment">2. Explore reference notebooks</span>

<span class="fragment">3. Begin Lab 2.1: Local RAG implementation</span>

<span class="fragment">4. Map your learning to accelerator architecture</span>

::: notes
Concrete actions. Don't just consume, apply!
:::

---

## Production Best Practices {data-background-color="#0f172a"}

Real-world deployment tips

---

### Best Practice 1: Chunking Strategy

**Start with these defaults and tune:**

```python
chunk_size = 1000  # tokens
chunk_overlap = 200  # 20% overlap
```

<span class="fragment">Monitor retrieval quality and adjust</span>

<span class="fragment">Domain-specific content may need different sizes</span>

<span class="fragment">Legal/medical: Larger chunks for complete context</span>

<span class="fragment">FAQ/support: Smaller chunks for precision</span>

::: notes
No universal chunk size. Test with your data.
:::

---

### Best Practice 2: Embedding Model Selection

**Decision Matrix:**

<span class="fragment">**Speed-critical apps** → all-MiniLM-L6-v2 (384d)</span>

<span class="fragment">**Balanced needs** → all-mpnet-base-v2 (768d)</span>

<span class="fragment">**Accuracy-critical** → text-embedding-ada-002 (1536d)</span>

<span class="fragment">**Domain-specific** → Fine-tuned models or watsonx slate</span>

::: notes
Match model to use case requirements
:::

---

### Best Practice 3: Vector Store Choice {data-background-color="#1e1e1e"}

Production considerations

---

### Vector Store Selection Guide

**Development/Testing:**
```python
# Chroma - local, simple
vectorstore = Chroma(persist_directory="./db")
```

**Production (< 1M docs):**
```python
# Elasticsearch - enterprise features
vectorstore = ElasticsearchStore(...)
```

**Production (> 1M docs):**
```python
# Specialized vector DB (Pinecone, Weaviate, Milvus)
```

::: notes
Scale determines technology choice
:::

---

### Best Practice 4: Retrieval Configuration

**Optimize retrieval parameters:**

```python {data-line-numbers="1-7|9-13"}
# Start conservative
retriever = vectorstore.as_retriever(
    search_type="similarity",
    search_kwargs={
        "k": 5,  # Retrieve 5 chunks
    }
)

# Add diversity if needed
retriever = vectorstore.as_retriever(
    search_type="mmr",
    search_kwargs={"k": 5, "fetch_k": 20, "lambda_mult": 0.7}
)
```

::: notes
Balance precision and recall. Monitor metrics.
:::

---

### Best Practice 5: Prompt Engineering {data-background-color="#0f172a"}

Critical for quality

---

### Effective RAG Prompts

**Include clear instructions:**

```python {data-line-numbers="1-4|6-8|10-12|14-15"}
prompt = """
You are an assistant answering questions using
the provided context. Follow these rules:

1. Answer ONLY based on the context provided.
2. If the answer is not in the context, say
   "I don't have enough information to answer that."

3. Cite the source document when possible.

4. Be concise but complete.

Context: {context}

Question: {question}
"""
```

::: notes
Clear rules reduce hallucinations significantly
:::

---

### Best Practice 6: Monitoring and Evaluation

**Track these metrics:**

<span class="fragment">**Retrieval Precision** - % relevant chunks retrieved</span>

<span class="fragment">**Retrieval Recall** - % of all relevant chunks found</span>

<span class="fragment">**Answer Correctness** - Human or LLM-based scoring</span>

<span class="fragment">**Latency** - p50, p95, p99 response times</span>

<span class="fragment">**Cost** - API calls, compute usage</span>

::: notes
You can't improve what you don't measure
:::

---

### Best Practice 7: Metadata Filtering {data-background-color="#1e1e1e"}

Improve retrieval precision

---

### Using Metadata Effectively

```python {data-line-numbers="1-8|10-15|17-20"}
# Add metadata during indexing
chunks = [
    Document(
        page_content="Policy text...",
        metadata={
            "source": "employee_handbook.pdf",
            "department": "HR",
            "date": "2024-01-15",
            "category": "benefits"
        }
    )
]

# Filter during retrieval
results = vectorstore.similarity_search(
    query="vacation policy",
    filter={"department": "HR", "category": "benefits"},
    k=5
)

# Much more precise results
# Avoids mixing unrelated domains
```

::: notes
Metadata filtering = surgical precision in retrieval
:::

---

### Best Practice 8: Error Handling

**Production code needs resilience:**

```python {data-line-numbers="1-17"}
def answer_question(query: str) -> dict:
    try:
        # Retrieve documents
        docs = retriever.get_relevant_documents(query)

        if not docs:
            return {"answer": "No relevant information found.",
                    "confidence": "low"}

        # Generate answer
        answer = qa_chain({"query": query})
        return answer

    except Exception as e:
        logger.error(f"RAG error: {e}")
        return {"answer": "Error processing request.",
                "error": str(e)}
```

::: notes
Always handle edge cases. Never crash on user input.
:::

---

### Best Practice 9: Caching {data-background-color="#0f172a"}

Optimize for repeated queries

---

### Implement Query Caching

```python {data-line-numbers="1-2|4-12"}
from functools import lru_cache
import hashlib

@lru_cache(maxsize=1000)
def cached_retrieval(query_hash: str, k: int):
    """Cache retrieval results for identical queries"""
    return retriever.get_relevant_documents(query, k=k)

def retrieve(query: str, k: int = 5):
    query_hash = hashlib.md5(query.encode()).hexdigest()
    return cached_retrieval(query_hash, k)
```

<span class="fragment">Significant speedup for common queries</span>

::: notes
Caching = free performance wins
:::

---

### Best Practice 10: Version Control

**Track these artifacts:**

<span class="fragment">✅ Embedding model version</span>

<span class="fragment">✅ Chunking configuration</span>

<span class="fragment">✅ Prompt templates</span>

<span class="fragment">✅ Vector store schema</span>

<span class="fragment">✅ Evaluation metrics and results</span>

::: notes
RAG systems are complex. Version everything.
:::

---

## RAG Architecture Cheat Sheet {data-background-color="#1e1e1e"}

Quick reference guide

---

### Component Quick Reference

| Component | Purpose | Popular Tools |
|-----------|---------|--------------|
| **Loader** | Extract text | PyPDF, Unstructured |
| **Splitter** | Chunk text | RecursiveCharacterTextSplitter |
| **Embeddings** | Vectorize | HuggingFace, OpenAI, watsonx |
| **Vector Store** | Index & search | Chroma, Elasticsearch, FAISS |
| **Retriever** | Query interface | LangChain retriever |
| **LLM** | Generate answer | Ollama, watsonx, OpenAI |

::: notes
Bookmark this table. Essential component mapping.
:::

---

### Typical Configuration Values

```python
# Chunking
chunk_size = 1000
chunk_overlap = 200

# Retrieval
k = 5  # number of chunks
search_type = "similarity"  # or "mmr"

# Embeddings
model = "all-MiniLM-L6-v2"  # 384 dimensions
device = "cpu"  # or "cuda"

# LLM
temperature = 0.0  # deterministic for Q&A
max_tokens = 512  # concise answers
```

::: notes
Copy-paste ready. Good starting defaults.
:::

---

### Performance Benchmarks {data-background-color="#0f172a"}

What to expect

---

### Latency Expectations

**Local RAG (Ollama + Chroma):**
<span class="fragment">Embedding: 50-200ms</span>
<span class="fragment">Retrieval: 10-50ms</span>
<span class="fragment">Generation: 2-10s (depends on model size)</span>
<span class="fragment">**Total: 3-11 seconds**</span>

**Cloud RAG (watsonx + Elasticsearch):**
<span class="fragment">Embedding: 100-500ms (API latency)</span>
<span class="fragment">Retrieval: 50-200ms</span>
<span class="fragment">Generation: 1-5s</span>
<span class="fragment">**Total: 2-6 seconds**</span>

::: notes
Ballpark numbers. Actual performance varies.
:::

---

### Cost Estimation

**Embedding Costs (per 1M tokens):**

<span class="fragment">Local (HuggingFace): **$0** (compute only)</span>

<span class="fragment">OpenAI ada-002: **$0.10**</span>

<span class="fragment">watsonx slate: **Variable** (check pricing)</span>

**LLM Generation Costs (per 1M tokens):**

<span class="fragment">Local (Ollama): **$0** (compute only)</span>

<span class="fragment">watsonx Granite: **~$0.50-2.00**</span>

<span class="fragment">OpenAI GPT-4: **$10-30**</span>

::: notes
Costs add up at scale. Monitor usage.
:::

---

## Common Pitfalls to Avoid {data-background-color="#1e1e1e"}

Learn from others' mistakes

---

### Pitfall 1: Ignoring Chunk Quality

**Problem:**
```python
# Bad: No overlap, arbitrary size
splitter = CharacterTextSplitter(chunk_size=100)
```

**Solution:**
```python
# Good: Semantic boundaries, overlap
splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ".", " "]
)
```

::: notes
Chunk quality directly impacts retrieval quality
:::

---

### Pitfall 2: Not Validating Retrieval

<span class="fragment">**Always inspect what you retrieve!**</span>

```python {data-line-numbers="1-7"}
# Add logging
docs = retriever.get_relevant_documents(query)
for i, doc in enumerate(docs):
    print(f"Doc {i}: {doc.page_content[:100]}...")
    print(f"Score: {doc.metadata.get('score', 'N/A')}")
    print(f"Source: {doc.metadata.get('source', 'Unknown')}")
```

::: notes
Garbage in, garbage out. Verify retrieval first.
:::

---

### Pitfall 3: Overloading Context {data-background-color="#0f172a"}

Too much context hurts

---

### Context Window Management

**Problem:**
```python
# Retrieving too many chunks
k = 20  # May exceed LLM context window
```

**Solution:**
```python
# Balance quantity and quality
k = 5  # Usually sufficient

# Or use token counting
def fit_to_context(docs, max_tokens=2000):
    """Select docs that fit in context"""
    # Implementation...
```

::: notes
More context ≠ better answers. Find the sweet spot.
:::

---

### Pitfall 4: Neglecting Prompt Engineering

<span class="fragment">**Generic prompts = poor results**</span>

```python
# Bad: Vague instructions
prompt = "Answer: {question} Context: {context}"

# Good: Clear, specific instructions
prompt = """
Answer the question using ONLY the context below.
If the context doesn't contain the answer, say so.
Cite the source document ID in your answer.

Context: {context}
Question: {question}
"""
```

::: notes
Prompt engineering is critical for RAG quality
:::

---

### Pitfall 5: No Evaluation Loop

<span class="fragment">**Build → Deploy → Monitor → Iterate**</span>

<span class="fragment">Without evaluation, you're flying blind</span>

<span class="fragment">Use Lab 2.4 patterns: correctness, relevance, latency</span>

<span class="fragment">A/B test different configurations</span>

::: notes
Continuous improvement requires measurement
:::

---

## Additional Resources {data-background-color="#0f172a"}

Comprehensive learning resources

---

### Essential Documentation

**LangChain RAG:**
<span class="fragment">📚 Official Guide: https://python.langchain.com/docs/use_cases/question_answering/</span>
<span class="fragment">📚 RAG Tutorial: https://python.langchain.com/docs/tutorials/rag/</span>
<span class="fragment">📚 Vector Store Guide: https://python.langchain.com/docs/modules/data_connection/vectorstores/</span>

**watsonx.ai:**
<span class="fragment">📚 watsonx RAG Patterns: https://ibm.com/docs/watsonx-as-a-service</span>
<span class="fragment">📚 Granite Models: https://www.ibm.com/granite</span>
<span class="fragment">📚 watsonx Embeddings: https://ibm.github.io/watsonx-ai-python-sdk/</span>

::: notes
Official documentation is your first resource
:::

---

### Vector Databases

**Comparison & Benchmarks:**
<span class="fragment">🔍 Vector DB Benchmark: https://benchmark.vectorview.ai/</span>
<span class="fragment">🔍 Choosing Vector DBs: https://www.pinecone.io/learn/vector-database/</span>

**Specific Tools:**
<span class="fragment">🛠️ Chroma Docs: https://docs.trychroma.com/</span>
<span class="fragment">🛠️ Elasticsearch Vector: https://www.elastic.co/elasticsearch/vector-database</span>
<span class="fragment">🛠️ FAISS Guide: https://github.com/facebookresearch/faiss/wiki</span>
<span class="fragment">🛠️ Pinecone: https://docs.pinecone.io/</span>
<span class="fragment">🛠️ Weaviate: https://weaviate.io/developers/weaviate</span>

::: notes
Each vector DB has trade-offs. Research before choosing.
:::

---

### Research Papers {data-background-color="#1e1e1e"}

Understanding the foundations

---

### Foundational Papers

**Original RAG Paper:**
<span class="fragment">📄 "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020)</span>
<span class="fragment">https://arxiv.org/abs/2005.11401</span>

**Dense Retrieval:**
<span class="fragment">📄 "Dense Passage Retrieval for Open-Domain Question Answering" (Karpukhin et al., 2020)</span>
<span class="fragment">https://arxiv.org/abs/2004.04906</span>

**Advanced RAG:**
<span class="fragment">📄 "Self-RAG: Learning to Retrieve, Generate, and Critique" (Asai et al., 2023)</span>
<span class="fragment">https://arxiv.org/abs/2310.11511</span>

::: notes
Read the papers to understand why, not just how
:::

---

### Embedding Models

**Model Comparison:**
<span class="fragment">🎯 MTEB Leaderboard: https://huggingface.co/spaces/mteb/leaderboard</span>
<span class="fragment">🎯 Sentence Transformers: https://www.sbert.net/</span>

**Popular Models:**
<span class="fragment">🤖 all-MiniLM-L6-v2: https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2</span>
<span class="fragment">🤖 all-mpnet-base-v2: https://huggingface.co/sentence-transformers/all-mpnet-base-v2</span>
<span class="fragment">🤖 BGE Models: https://huggingface.co/BAAI/bge-large-en-v1.5</span>
<span class="fragment">🤖 OpenAI Embeddings: https://platform.openai.com/docs/guides/embeddings</span>

::: notes
Embedding quality determines retrieval quality
:::

---

### RAG Evaluation {data-background-color="#0f172a"}

Measuring quality

---

### Evaluation Frameworks

**RAGAS (RAG Assessment):**
<span class="fragment">📊 GitHub: https://github.com/explodinggradients/ragas</span>
<span class="fragment">📊 Docs: https://docs.ragas.io/</span>
<span class="fragment">📊 Metrics: Context relevance, answer faithfulness, answer relevance</span>

**TruLens:**
<span class="fragment">📊 TruLens for RAG: https://www.trulens.org/</span>
<span class="fragment">📊 Comprehensive evaluation and tracking</span>

**Phoenix (Arize):**
<span class="fragment">📊 RAG Observability: https://docs.arize.com/phoenix</span>
<span class="fragment">📊 Trace retrieval and generation</span>

::: notes
Modern evaluation frameworks automate quality measurement
:::

---

### Production Tools

**Development & Debugging:**
<span class="fragment">🔧 LangSmith: https://docs.smith.langchain.com/</span>
<span class="fragment">🔧 RAG tracing and debugging</span>

**Experiment Tracking:**
<span class="fragment">🔬 Weights & Biases: https://wandb.ai/site/solutions/llmops</span>
<span class="fragment">🔬 MLflow: https://mlflow.org/docs/latest/llms/rag/index.html</span>

**Monitoring:**
<span class="fragment">📈 LangFuse: https://langfuse.com/</span>
<span class="fragment">📈 Open-source LLM observability</span>

::: notes
Production RAG needs monitoring and debugging tools
:::

---

### Learning Resources {data-background-color="#1e1e1e"}

Tutorials and courses

---

### Video Tutorials

**LangChain RAG:**
<span class="fragment">🎥 LangChain RAG Tutorial: https://www.youtube.com/watch?v=tcqEUSNCn8I</span>
<span class="fragment">🎥 Advanced RAG Techniques: https://www.youtube.com/watch?v=sVcwVQRHIc8</span>

**Enterprise RAG:**
<span class="fragment">🎥 Building Production RAG: https://www.deeplearning.ai/short-courses/building-applications-vector-databases/</span>
<span class="fragment">🎥 LangChain for LLM Apps: https://www.deeplearning.ai/short-courses/langchain-for-llm-application-development/</span>

::: notes
Video tutorials for visual learners
:::

---

### Community Resources

**Forums & Discussion:**
<span class="fragment">💬 LangChain Discord: https://discord.gg/langchain</span>
<span class="fragment">💬 r/LocalLLaMA: https://reddit.com/r/LocalLLaMA</span>
<span class="fragment">💬 Hugging Face Forums: https://discuss.huggingface.co/</span>

**Blogs & Articles:**
<span class="fragment">📝 LangChain Blog: https://blog.langchain.dev/</span>
<span class="fragment">📝 Pinecone Learning Center: https://www.pinecone.io/learn/</span>
<span class="fragment">📝 Elasticsearch Blog: https://www.elastic.co/blog/</span>

::: notes
Community resources for ongoing learning
:::

---

### IBM-Specific Resources

**watsonx Resources:**
<span class="fragment">🏢 watsonx.ai Documentation: https://www.ibm.com/docs/en/watsonx-as-a-service</span>
<span class="fragment">🏢 IBM Granite Models: https://www.ibm.com/granite</span>
<span class="fragment">🏢 watsonx.governance: https://www.ibm.com/docs/en/watsonx/governance</span>

**Sample Code:**
<span class="fragment">💻 watsonx Python SDK: https://ibm.github.io/watsonx-ai-python-sdk/</span>
<span class="fragment">💻 IBM Generative AI: https://github.com/IBM/ibm-generative-ai</span>

::: notes
Enterprise-specific resources for IBM stack
:::

---

## Navigation & Next Steps {data-background-color="#0f172a"}

Continue your learning journey

---

### 🏠 Return to Workshop Portal

**[Interactive Workshop Portal](https://ruslanmv.com/watsonx-workshop/portal/)**

Access daily guides, presentations, and labs

::: notes
Central hub for all workshop materials
:::

---

### 📚 Day 2 Materials

**[Day 2 RAG Overview](../../portal/day2-portal.md)**

Complete schedule and navigation for Day 2

**Day 2 Theory:**
<span class="fragment">✅ RAG Architecture Overview (Current)</span>
<span class="fragment">📖 [Supplementary Materials](./SUPPLEMENTARY_QUICK_START.md)</span>

**Day 2 Labs:**
<span class="fragment">🧪 [Lab 2.1: Local RAG](./lab-1-intro-rag.md) - Next up!</span>
<span class="fragment">🧪 [Lab 2.2: watsonx RAG](./lab-2-watsonx-rag.md)</span>
<span class="fragment">🧪 [Lab 2.3: Twin Pipelines](./lab-3-dual-mode-rag.md)</span>
<span class="fragment">🧪 [Lab 2.4: RAG Evaluation](./lab-4-compare-evals.md)</span>

::: notes
Complete Day 2 journey from theory to practice
:::

---

### 🔗 Related Workshop Content

**Previous Day:**
<span class="fragment">← [Day 1: LLM Foundations](../day1-llm/README.md)</span>
<span class="fragment">Review prompt engineering and evaluation basics</span>

**Next Day:**
<span class="fragment">→ [Day 3: Agent Orchestration](../day3-orchestrate/README.md)</span>
<span class="fragment">Build on RAG with agentic workflows</span>

**Prerequisites:**
<span class="fragment">🔧 [Day 0: Environment Setup](../day0-env/prereqs-and-accounts.md)</span>

::: notes
Workshop builds progressively. Review previous material if needed.
:::

---

### 📖 Additional Workshop Resources

**Supplementary Materials:**
<span class="fragment">📚 [Day 2 Supplementary Guide](./SUPPLEMENTARY_QUICK_START.md)</span>
<span class="fragment">Advanced topics, IBM tooling, production patterns</span>

**Accelerator Integration:**
<span class="fragment">🏗️ Reference notebooks in `accelerator/assets/notebook/`</span>
<span class="fragment">🏗️ Production code in `accelerator/rag/`</span>

**Community:**
<span class="fragment">💬 Workshop discussions and Q&A</span>
<span class="fragment">💬 Share your RAG implementations</span>

::: notes
Extensive supplementary materials available
:::

---

### ✅ Ready to Start Labs?

**Immediate Next Steps:**

<span class="fragment">1. **Review** this theory presentation</span>

<span class="fragment">2. **Bookmark** the additional resources</span>

<span class="fragment">3. **Begin** Lab 2.1: Build your first local RAG system</span>

<span class="fragment">4. **Experiment** with different configurations</span>

<span class="fragment">5. **Evaluate** your results using metrics from Lab 2.4</span>

::: notes
Theory complete. Time to build!
:::

---

## Theory Module Complete! ✅ {data-background-color="#0f172a" data-transition="zoom"}

**You now understand:**
- RAG architecture and components
- Design trade-offs and best practices
- Production patterns and pitfalls
- The complete RAG pipeline flow

**Proceed to [Lab 2.1](./lab-1-intro-rag.md) when ready!**

**Version:** 1.0
**Last Updated:** January 2025
**Part of:** watsonx AI Workshop Series

::: notes
Congratulations! Solid theoretical foundation established.
Now time to build and experiment!
:::