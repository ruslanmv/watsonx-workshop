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

## Additional Resources {data-background-color="#0f172a"}

Expand your knowledge

---

### Documentation

<span class="fragment">LangChain RAG Guide: https://python.langchain.com/docs/use_cases/question_answering/</span>

<span class="fragment">watsonx.ai RAG Patterns: https://ibm.com/docs/watsonx-as-a-service</span>

<span class="fragment">Vector Database Comparison: https://benchmark.vectorview.ai/</span>

::: notes
Bookmark these. Essential references.
:::

---

### Research Papers

<span class="fragment">"Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks"</span>

<span class="fragment">"Dense Passage Retrieval for Open-Domain Question Answering"</span>

::: notes
Read the original papers. Understand the research foundation.
:::

---

### Tools for RAG Development

<span class="fragment">**LangSmith** - RAG debugging and tracing</span>

<span class="fragment">**Weights & Biases** - Experiment tracking</span>

::: notes
Production tools. Will see these in advanced topics.
:::

---

## Theory Module Complete! ✅ {data-background-color="#0f172a" data-transition="zoom"}

Proceed to Lab 2.1 when ready

::: notes
Congratulations! Solid theoretical foundation established.
Now time to build!
:::