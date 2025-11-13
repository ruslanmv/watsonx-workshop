# Day 2 RAG Workshop - Complete Code & Solutions Guide

## 📋 Table of Contents

1. [Theory Summary](#theory-summary)
2. [Lab 2.1: Local RAG with Ollama - Complete Solution](#lab-21-solution)
3. [Lab 2.2: RAG with watsonx.ai - Complete Solution](#lab-22-solution)
4. [Lab 2.3: Twin RAG Pipelines - Complete Solution](#lab-23-solution)
5. [Lab 2.4: Evaluation Harness - Complete Solution](#lab-24-solution)
6. [Production Deployment Code](#production-code)
7. [Troubleshooting Guide](#troubleshooting)

---

## Theory Summary

### RAG Core Concepts

```python
"""
RAG Pipeline Flow:
1. INGESTION: Documents → Text Extraction → Chunking
2. INDEXING: Chunks → Embeddings → Vector Store
3. RETRIEVAL: Query → Embedding → Similarity Search → Relevant Chunks
4. GENERATION: Query + Context → LLM → Answer
"""

# Key Components
COMPONENTS = {
    "Document Store": "Repository of knowledge (PDFs, text, web pages)",
    "Chunker": "Splits documents into semantic units",
    "Embeddings": "Dense vector representations of text",
    "Vector Store": "Database optimized for similarity search",
    "Retriever": "Finds relevant chunks for a query",
    "LLM": "Generates answers from retrieved context",
    "Prompt": "Template combining context and question"
}

# Popular Tools
TOOLS = {
    "Embeddings": ["all-MiniLM-L6-v2", "text-embedding-ada-002", "slate-30m"],
    "Vector Stores": ["Chroma", "FAISS", "Elasticsearch", "Pinecone"],
    "LLMs": ["Ollama (llama2, mistral)", "watsonx.ai (Granite)", "OpenAI (GPT)"]
}
```

---

## Lab 2.1 Solution: Local RAG with Ollama

### Complete Working Code

```python
# ============================================================================
# LAB 2.1: LOCAL RAG WITH OLLAMA - COMPLETE SOLUTION
# ============================================================================

# Cell 1: Setup and Imports
"""
Install required packages:
pip install langchain langchain-community chromadb sentence-transformers ollama
"""

from langchain.document_loaders import DirectoryLoader, TextLoader
from langchain.text_splitters import RecursiveCharacterTextSplitter
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_chroma import Chroma
from langchain_community.llms import Ollama
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate
import pandas as pd
from pathlib import Path
import time

# Cell 2: Configuration
CONFIG = {
    "corpus_path": "data/corpus",
    "chunk_size": 1000,
    "chunk_overlap": 200,
    "embedding_model": "all-MiniLM-L6-v2",
    "llm_model": "llama2",
    "vector_db_path": "./chroma_db",
    "top_k": 5,
    "temperature": 0.0
}

# Cell 3: Prepare Sample Corpus
def create_sample_corpus():
    """Create sample documents for testing"""
    corpus_dir = Path(CONFIG["corpus_path"])
    corpus_dir.mkdir(parents=True, exist_ok=True)
    
    documents = {
        "rag_overview.txt": """
# Retrieval Augmented Generation Overview

Retrieval Augmented Generation (RAG) is a technique that enhances Large Language Models 
by providing them with relevant external knowledge retrieved from a document corpus.

## Key Benefits
1. Reduces hallucinations by grounding responses in factual data
2. Enables access to current information beyond training cutoff
3. Allows domain-specific knowledge without retraining
4. Provides source attribution for transparency

## Core Components
- Document Store: Repository of knowledge
- Embeddings: Convert text to vectors
- Vector Store: Database for similarity search
- Retriever: Finds relevant documents
- LLM: Generates final answer
""",
        "chunking_strategies.txt": """
# Chunking Strategies in RAG

Chunking is the process of splitting documents into smaller units for better retrieval.

## Fixed-Size Chunking
- Split by character or token count
- Simple but may break semantic units
- Typical size: 500-1500 tokens

## Semantic Chunking
- Split by paragraphs or sections
- Preserves meaning and context
- Better for coherent retrieval

## Recursive Chunking
- Tries multiple separators in order
- First tries paragraphs, then sentences, then words
- Best of both worlds

## Best Practices
- Include overlap between chunks (10-20%)
- Preserve metadata with each chunk
- Test different sizes for your use case
""",
        "vector_stores.txt": """
# Vector Stores for RAG

Vector stores are specialized databases for storing and searching embeddings.

## Chroma
- Lightweight and easy to use
- Great for local development
- Persistent storage option
- Open source

## Elasticsearch
- Enterprise-grade and scalable
- Supports hybrid search (keyword + vector)
- Production-ready
- Distributed architecture

## FAISS
- High-performance similarity search
- In-memory or disk-based
- From Facebook AI Research
- Excellent for large-scale

## Pinecone
- Fully managed cloud service
- Auto-scaling
- Simple API
- Pay-as-you-go pricing
"""
    }
    
    for filename, content in documents.items():
        with open(corpus_dir / filename, "w") as f:
            f.write(content)
    
    print(f"Created {len(documents)} sample documents in {corpus_dir}")
    return corpus_dir

# Create corpus
corpus_path = create_sample_corpus()

# Cell 4: Load Documents
print("=" * 80)
print("STEP 1: LOADING DOCUMENTS")
print("=" * 80)

loader = DirectoryLoader(
    CONFIG["corpus_path"],
    glob="**/*.txt",
    loader_cls=TextLoader
)

documents = loader.load()
print(f"✓ Loaded {len(documents)} documents")

for i, doc in enumerate(documents):
    print(f"\nDocument {i+1}:")
    print(f"  Source: {doc.metadata['source']}")
    print(f"  Length: {len(doc.page_content)} characters")
    print(f"  Preview: {doc.page_content[:100]}...")

# Cell 5: Chunk Documents
print("\n" + "=" * 80)
print("STEP 2: CHUNKING DOCUMENTS")
print("=" * 80)

text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=CONFIG["chunk_size"],
    chunk_overlap=CONFIG["chunk_overlap"],
    length_function=len,
    separators=["\n\n", "\n", ". ", " ", ""]
)

chunks = text_splitter.split_documents(documents)
print(f"✓ Created {len(chunks)} chunks from {len(documents)} documents")

# Analyze chunks
chunk_lengths = [len(chunk.page_content) for chunk in chunks]
print(f"\nChunk Statistics:")
print(f"  Average length: {sum(chunk_lengths)/len(chunk_lengths):.0f} chars")
print(f"  Min length: {min(chunk_lengths)} chars")
print(f"  Max length: {max(chunk_lengths)} chars")

# Show sample chunk
print(f"\nSample Chunk:")
print(f"  Content: {chunks[0].page_content[:200]}...")
print(f"  Metadata: {chunks[0].metadata}")

# Cell 6: Create Embeddings
print("\n" + "=" * 80)
print("STEP 3: CREATING EMBEDDINGS")
print("=" * 80)

embeddings = HuggingFaceEmbeddings(
    model_name=CONFIG["embedding_model"],
    model_kwargs={'device': 'cpu'},
    encode_kwargs={'normalize_embeddings': True}
)

# Test embedding
test_text = "What is RAG?"
test_embedding = embeddings.embed_query(test_text)
print(f"✓ Embedding model loaded: {CONFIG['embedding_model']}")
print(f"  Embedding dimension: {len(test_embedding)}")
print(f"  Sample values: {test_embedding[:5]}")

# Cell 7: Build Vector Store
print("\n" + "=" * 80)
print("STEP 4: BUILDING VECTOR STORE")
print("=" * 80)

start_time = time.time()

vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory=CONFIG["vector_db_path"]
)

build_time = time.time() - start_time
print(f"✓ Vector store created in {build_time:.2f} seconds")
print(f"  Total vectors: {vectorstore._collection.count()}")
print(f"  Storage path: {CONFIG['vector_db_path']}")

# Persist
vectorstore.persist()
print("✓ Vector store persisted to disk")

# Cell 8: Test Retrieval
print("\n" + "=" * 80)
print("STEP 5: TESTING RETRIEVAL")
print("=" * 80)

test_queries = [
    "What is RAG?",
    "How does chunking work?",
    "What are the benefits of using vector stores?"
]

for query in test_queries:
    print(f"\n Query: {query}")
    results = vectorstore.similarity_search_with_score(query, k=2)
    
    for i, (doc, score) in enumerate(results, 1):
        print(f"  Result {i} (score: {score:.3f}):")
        print(f"    {doc.page_content[:150]}...")
        print(f"    Source: {doc.metadata['source']}")

# Cell 9: Initialize LLM
print("\n" + "=" * 80)
print("STEP 6: INITIALIZING LLM")
print("=" * 80)

try:
    llm = Ollama(
        model=CONFIG["llm_model"],
        temperature=CONFIG["temperature"]
    )
    
    # Test LLM
    test_response = llm("Say 'Hello, I am ready!'")
    print(f"✓ LLM initialized: {CONFIG['llm_model']}")
    print(f"  Test response: {test_response}")
except Exception as e:
    print(f"✗ Error initializing LLM: {e}")
    print("  Make sure Ollama is running: ollama serve")
    print(f"  And model is pulled: ollama pull {CONFIG['llm_model']}")

# Cell 10: Build RAG Pipeline
print("\n" + "=" * 80)
print("STEP 7: BUILDING RAG PIPELINE")
print("=" * 80)

# Custom prompt template
prompt_template = """Use the following pieces of context to answer the question at the end.
If you don't know the answer based on the context, just say that you don't know, don't try to make up an answer.

Context:
{context}

Question: {question}

Answer: """

PROMPT = PromptTemplate(
    template=prompt_template,
    input_variables=["context", "question"]
)

# Create QA chain
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(
        search_kwargs={"k": CONFIG["top_k"]}
    ),
    return_source_documents=True,
    chain_type_kwargs={"prompt": PROMPT}
)

print("✓ RAG pipeline built successfully")

# Cell 11: Answer Questions
print("\n" + "=" * 80)
print("STEP 8: TESTING RAG PIPELINE")
print("=" * 80)

def answer_question(query: str, verbose: bool = True):
    """Answer a question using the RAG pipeline"""
    start_time = time.time()
    
    result = qa_chain({"query": query})
    
    elapsed_time = time.time() - start_time
    
    if verbose:
        print(f"\n{'='*80}")
        print(f"Question: {query}")
        print(f"{'='*80}")
        print(f"\nAnswer:\n{result['result']}")
        print(f"\nSources:")
        for i, doc in enumerate(result['source_documents'], 1):
            print(f"  {i}. {doc.metadata['source']}")
            print(f"     {doc.page_content[:100]}...\n")
        print(f"Response time: {elapsed_time:.2f} seconds")
    
    return {
        "question": query,
        "answer": result['result'],
        "sources": [doc.metadata['source'] for doc in result['source_documents']],
        "num_sources": len(result['source_documents']),
        "response_time": elapsed_time
    }

# Test questions
test_questions = [
    "What is Retrieval Augmented Generation?",
    "What are the main benefits of RAG?",
    "Explain different chunking strategies",
    "What is Chroma and when should I use it?",
    "What are the core components of RAG?"
]

results = []
for question in test_questions:
    result = answer_question(question)
    results.append(result)

# Cell 12: Analyze Results
print("\n" + "=" * 80)
print("STEP 9: ANALYZING RESULTS")
print("=" * 80)

results_df = pd.DataFrame(results)

print("\nSummary Statistics:")
print(f"  Total questions: {len(results)}")
print(f"  Average response time: {results_df['response_time'].mean():.2f} seconds")
print(f"  Average sources per answer: {results_df['num_sources'].mean():.1f}")

# Save results
results_df.to_csv("lab_2.1_results.csv", index=False)
print(f"\n✓ Results saved to lab_2.1_results.csv")

# Cell 13: Evaluation Function
def evaluate_answer(question: str, answer: str, expected_keywords: list):
    """
    Simple evaluation: check if answer contains expected keywords
    
    Args:
        question: The query
        answer: Generated answer
        expected_keywords: List of keywords that should appear
    
    Returns:
        dict with evaluation metrics
    """
    answer_lower = answer.lower()
    found_keywords = [kw for kw in expected_keywords if kw.lower() in answer_lower]
    
    score = len(found_keywords) / len(expected_keywords) if expected_keywords else 0
    
    return {
        "question": question,
        "contains_all_keywords": len(found_keywords) == len(expected_keywords),
        "keyword_coverage": score,
        "found_keywords": found_keywords,
        "missing_keywords": [kw for kw in expected_keywords if kw not in found_keywords]
    }

# Example evaluation
eval_result = evaluate_answer(
    question="What is RAG?",
    answer=results[0]['answer'],
    expected_keywords=["retrieval", "generation", "language model", "knowledge"]
)

print("\nEvaluation Example:")
print(f"  Keyword coverage: {eval_result['keyword_coverage']:.0%}")
print(f"  Found: {eval_result['found_keywords']}")
print(f"  Missing: {eval_result['missing_keywords']}")

print("\n" + "=" * 80)
print("LAB 2.1 COMPLETE! ✅")
print("=" * 80)
print("\nKey Achievements:")
print("  ✓ Loaded and chunked documents")
print("  ✓ Created embeddings and vector store")
print("  ✓ Built working RAG pipeline")
print("  ✓ Tested with multiple questions")
print("  ✓ Evaluated answer quality")
print("\nNext: Lab 2.2 - RAG with watsonx.ai")
```

---

## Lab 2.2 Solution: RAG with watsonx.ai

### Complete Working Code

```python
# ============================================================================
# LAB 2.2: RAG WITH WATSONX.AI - COMPLETE SOLUTION
# ============================================================================

# Cell 1: Setup and Imports
"""
Install required packages:
pip install ibm-watsonx-ai langchain langchain-ibm
pip install elasticsearch langchain-elasticsearch
pip install python-dotenv
"""

import os
import getpass
from dotenv import load_dotenv
from pathlib import Path
import time
import pandas as pd

from ibm_watsonx_ai import APIClient, Credentials
from ibm_watsonx_ai.foundation_models.utils.enums import ModelTypes, DecodingMethods
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

from langchain_ibm import WatsonxLLM, WatsonxEmbeddings
from langchain.text_splitters import RecursiveCharacterTextSplitter
from langchain.document_loaders import DirectoryLoader, TextLoader
from langchain_elasticsearch import ElasticsearchStore
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate

# Cell 2: Configuration and Credentials
print("=" * 80)
print("WATSONX.AI RAG SETUP")
print("=" * 80)

# Load environment variables
load_dotenv()

# Prompt for credentials if not in environment
def get_credential(var_name: str, prompt_text: str):
    value = os.getenv(var_name)
    if not value:
        value = getpass.getpass(f"{prompt_text}: ")
        os.environ[var_name] = value
    return value

# watsonx.ai credentials
WATSONX_APIKEY = get_credential("WATSONX_APIKEY", "Enter your watsonx.ai API key")
PROJECT_ID = get_credential("PROJECT_ID", "Enter your watsonx.ai project ID")
WATSONX_URL = os.getenv("WATSONX_URL", "https://us-south.ml.cloud.ibm.com")

# Elasticsearch credentials (optional - can use Chroma instead)
USE_ELASTICSEARCH = input("Use Elasticsearch? (y/n, default=n): ").lower() == 'y'

if USE_ELASTICSEARCH:
    ES_URL = get_credential("ES_URL", "Enter Elasticsearch URL")
    ES_USER = get_credential("ES_USER", "Enter Elasticsearch username")
    ES_PASSWORD = get_credential("ES_PASSWORD", "Enter Elasticsearch password")

CONFIG = {
    "corpus_path": "data/corpus",  # Reuse from Lab 2.1
    "chunk_size": 1000,
    "chunk_overlap": 200,
    "embedding_model": "ibm/slate-30m-english-rtrvr",
    "llm_model": ModelTypes.GRANITE_13B_CHAT_V2,
    "index_name": "watsonx_rag_index",
    "top_k": 5
}

print("\n✓ Configuration loaded")

# Cell 3: Initialize watsonx.ai Client
print("\n" + "=" * 80)
print("INITIALIZING WATSONX.AI CLIENT")
print("=" * 80)

credentials = Credentials(
    url=WATSONX_URL,
    api_key=WATSONX_APIKEY
)

api_client = APIClient(
    credentials=credentials,
    project_id=PROJECT_ID
)

print("✓ watsonx.ai client initialized")
print(f"  URL: {WATSONX_URL}")
print(f"  Project ID: {PROJECT_ID[:8]}...")

# Cell 4: Setup Embeddings
print("\n" + "=" * 80)
print("SETTING UP EMBEDDINGS")
print("=" * 80)

embeddings = WatsonxEmbeddings(
    model_id=CONFIG["embedding_model"],
    url=WATSONX_URL,
    apikey=WATSONX_APIKEY,
    project_id=PROJECT_ID
)

# Test embedding
test_text = "Granite is IBM's foundation model"
test_embedding = embeddings.embed_query(test_text)

print(f"✓ watsonx embeddings initialized")
print(f"  Model: {CONFIG['embedding_model']}")
print(f"  Embedding dimension: {len(test_embedding)}")

# Cell 5: Load and Chunk Documents
print("\n" + "=" * 80)
print("LOADING AND CHUNKING DOCUMENTS")
print("=" * 80)

# Load documents (reuse corpus from Lab 2.1)
loader = DirectoryLoader(
    CONFIG["corpus_path"],
    glob="**/*.txt",
    loader_cls=TextLoader
)

documents = loader.load()
print(f"✓ Loaded {len(documents)} documents")

# Chunk documents
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=CONFIG["chunk_size"],
    chunk_overlap=CONFIG["chunk_overlap"]
)

chunks = text_splitter.split_documents(documents)
print(f"✓ Created {len(chunks)} chunks")

# Cell 6: Build Vector Store
print("\n" + "=" * 80)
print("BUILDING VECTOR STORE")
print("=" * 80)

if USE_ELASTICSEARCH:
    # Elasticsearch setup
    vectorstore = ElasticsearchStore(
        es_url=ES_URL,
        index_name=CONFIG["index_name"],
        embedding=embeddings,
        es_user=ES_USER,
        es_password=ES_PASSWORD
    )
    vectorstore.add_documents(chunks)
    print(f"✓ Elasticsearch vector store created")
    print(f"  Index: {CONFIG['index_name']}")
else:
    # Fallback to Chroma for local testing
    from langchain_chroma import Chroma
    vectorstore = Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        persist_directory="./chroma_watsonx_db"
    )
    print("✓ Chroma vector store created (local)")

# Cell 7: Initialize Granite LLM
print("\n" + "=" * 80)
print("INITIALIZING GRANITE MODEL")
print("=" * 80)

# Model parameters
model_parameters = {
    GenParams.DECODING_METHOD: DecodingMethods.GREEDY,
    GenParams.MIN_NEW_TOKENS: 1,
    GenParams.MAX_NEW_TOKENS: 200,
    GenParams.STOP_SEQUENCES: ["<|endoftext|>"]
}

# Initialize Granite
granite_llm = WatsonxLLM(
    model_id=CONFIG["llm_model"].value,
    url=WATSONX_URL,
    apikey=WATSONX_APIKEY,
    project_id=PROJECT_ID,
    params=model_parameters
)

# Test Granite
test_response = granite_llm("What is 2+2? Answer with just the number.")
print("✓ Granite model initialized")
print(f"  Model: {CONFIG['llm_model'].value}")
print(f"  Test response: {test_response}")

# Cell 8: Build RAG Pipeline
print("\n" + "=" * 80)
print("BUILDING RAG PIPELINE")
print("=" * 80)

# Custom prompt for Granite
prompt_template = """<|system|>
You are a helpful AI assistant. Use the provided context to answer questions accurately.
If the answer is not in the context, say "I don't have enough information to answer that."
<|endofsystem|>

<|user|>
Context:
{context}

Question: {question}
<|endofuser|>

<|assistant|>
"""

PROMPT = PromptTemplate(
    template=prompt_template,
    input_variables=["context", "question"]
)

# Create QA chain
qa_chain = RetrievalQA.from_chain_type(
    llm=granite_llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(
        search_kwargs={"k": CONFIG["top_k"]}
    ),
    return_source_documents=True,
    chain_type_kwargs={"prompt": PROMPT}
)

print("✓ RAG pipeline with Granite built successfully")

# Cell 9: Test Pipeline
print("\n" + "=" * 80)
print("TESTING WATSONX.AI RAG PIPELINE")
print("=" * 80)

def answer_with_granite(query: str):
    """Answer using watsonx.ai RAG pipeline"""
    start_time = time.time()
    
    result = qa_chain({"query": query})
    
    elapsed_time = time.time() - start_time
    
    print(f"\n{'='*80}")
    print(f"Question: {query}")
    print(f"{'='*80}")
    print(f"\nGranite Answer:\n{result['result']}")
    print(f"\nSources:")
    for i, doc in enumerate(result['source_documents'], 1):
        print(f"  {i}. {doc.metadata['source']}")
    print(f"\nResponse time: {elapsed_time:.2f}s")
    
    return {
        "question": query,
        "answer": result['result'],
        "sources": [d.metadata['source'] for d in result['source_documents']],
        "response_time": elapsed_time,
        "model": "granite-13b-chat-v2"
    }

# Test questions
test_questions = [
    "What is RAG and why is it useful?",
    "Explain the different chunking strategies",
    "Compare Chroma and Elasticsearch vector stores"
]

watsonx_results = []
for question in test_questions:
    result = answer_with_granite(question)
    watsonx_results.append(result)

# Cell 10: Save Results
results_df = pd.DataFrame(watsonx_results)
results_df.to_csv("lab_2.2_watsonx_results.csv", index=False)

print("\n" + "=" * 80)
print("LAB 2.2 COMPLETE! ✅")
print("=" * 80)
print("\nKey Achievements:")
print("  ✓ Connected to watsonx.ai")
print("  ✓ Used watsonx embeddings")
print("  ✓ Integrated Granite model")
print("  ✓ Built enterprise RAG pipeline")
print("\nNext: Lab 2.3 - Compare Ollama vs watsonx")
```

---

## Lab 2.3 Solution: Twin RAG Pipelines

### Complete Comparison Framework

```python
# ============================================================================
# LAB 2.3: TWIN RAG PIPELINES - COMPLETE SOLUTION
# ============================================================================

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from typing import List, Dict
import time

# Cell 1: Setup Comparison Framework
print("=" * 80)
print("TWIN RAG PIPELINE COMPARISON")
print("=" * 80)

# Assume qa_chain_ollama and qa_chain_granite are already initialized
# from Labs 2.1 and 2.2

# Cell 2: Define Test Queries
evaluation_queries = [
    {
        "query": "What is Retrieval Augmented Generation?",
        "category": "definition",
        "expected_concepts": ["retrieval", "generation", "LLM", "knowledge"]
    },
    {
        "query": "What are the benefits of RAG?",
        "category": "benefits",
        "expected_concepts": ["hallucination", "current", "domain-specific"]
    },
    {
        "query": "Explain chunking strategies in detail",
        "category": "technical",
        "expected_concepts": ["fixed-size", "semantic", "overlap"]
    },
    {
        "query": "When should I use Chroma vs Elasticsearch?",
        "category": "comparison",
        "expected_concepts": ["local", "production", "scalable"]
    },
    {
        "query": "What is the weather today?",  # Out of domain
        "category": "out-of-domain",
        "expected_concepts": []
    }
]

# Cell 3: Comparison Function
def compare_rag_backends(
    query: str,
    ollama_chain,
    granite_chain
) -> Dict:
    """
    Compare responses from both RAG backends
    
    Returns:
        dict with results from both systems
    """
    print(f"\nComparing: {query}")
    print("-" * 80)
    
    # Ollama RAG
    start = time.time()
    ollama_result = ollama_chain({"query": query})
    ollama_time = time.time() - start
    
    # watsonx Granite RAG
    start = time.time()
    granite_result = granite_chain({"query": query})
    granite_time = time.time() - start
    
    comparison = {
        "query": query,
        "ollama_answer": ollama_result['result'],
        "ollama_time": ollama_time,
        "ollama_sources": len(ollama_result['source_documents']),
        "granite_answer": granite_result['result'],
        "granite_time": granite_time,
        "granite_sources": len(granite_result['source_documents']),
        "time_difference": abs(ollama_time - granite_time),
        "faster_backend": "Ollama" if ollama_time < granite_time else "Granite"
    }
    
    print(f"Ollama: {ollama_time:.2f}s ({comparison['ollama_sources']} sources)")
    print(f"Granite: {granite_time:.2f}s ({comparison['granite_sources']} sources)")
    
    return comparison

# Cell 4: Run Comparisons
print("\n" + "=" * 80)
print("RUNNING COMPARISONS")
print("=" * 80)

comparisons = []
for eval_query in evaluation_queries:
    comparison = compare_rag_backends(
        eval_query["query"],
        qa_chain_ollama,  # from Lab 2.1
        qa_chain_granite   # from Lab 2.2
    )
    comparison["category"] = eval_query["category"]
    comparisons.append(comparison)

# Cell 5: Analyze Results
results_df = pd.DataFrame(comparisons)

print("\n" + "=" * 80)
print("COMPARISON ANALYSIS")
print("=" * 80)

print("\nResponse Time Comparison:")
print(f"  Ollama average: {results_df['ollama_time'].mean():.2f}s")
print(f"  Granite average: {results_df['granite_time'].mean():.2f}s")
print(f"  Winner: {results_df['faster_backend'].mode()[0]}")

print("\nSource Retrieval:")
print(f"  Ollama average sources: {results_df['ollama_sources'].mean():.1f}")
print(f"  Granite average sources: {results_df['granite_sources'].mean():.1f}")

# Cell 6: Visualizations
fig, axes = plt.subplots(1, 2, figsize=(14, 5))

# Response time comparison
ax1 = axes[0]
x = range(len(results_df))
width = 0.35
ax1.bar([i - width/2 for i in x], results_df['ollama_time'], width, label='Ollama', alpha=0.8)
ax1.bar([i + width/2 for i in x], results_df['granite_time'], width, label='Granite', alpha=0.8)
ax1.set_xlabel('Query')
ax1.set_ylabel('Response Time (seconds)')
ax1.set_title('Response Time Comparison')
ax1.set_xticks(x)
ax1.set_xticklabels(range(1, len(results_df)+1))
ax1.legend()
ax1.grid(axis='y', alpha=0.3)

# Sources retrieved
ax2 = axes[1]
ax2.bar([i - width/2 for i in x], results_df['ollama_sources'], width, label='Ollama', alpha=0.8)
ax2.bar([i + width/2 for i in x], results_df['granite_sources'], width, label='Granite', alpha=0.8)
ax2.set_xlabel('Query')
ax2.set_ylabel('Number of Sources')
ax2.set_title('Sources Retrieved')
ax2.set_xticks(x)
ax2.set_xticklabels(range(1, len(results_df)+1))
ax2.legend()
ax2.grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.savefig('lab_2.3_comparison.png', dpi=300, bbox_inches='tight')
print("\n✓ Visualization saved to lab_2.3_comparison.png")

# Cell 7: Side-by-Side Answer Comparison
def display_comparison(query_idx: int):
    """Display side-by-side comparison for a specific query"""
    comp = comparisons[query_idx]
    
    print(f"\n{'='*80}")
    print(f"QUERY {query_idx + 1}: {comp['query']}")
    print(f"{'='*80}")
    
    print(f"\n{'OLLAMA':^40} | {'GRANITE':^40}")
    print(f"{'-'*40}|{'-'*40}")
    
    # Split answers into lines for side-by-side display
    ollama_lines = comp['ollama_answer'].split('\n')
    granite_lines = comp['granite_answer'].split('\n')
    
    max_lines = max(len(ollama_lines), len(granite_lines))
    
    for i in range(max_lines):
        ollama_line = ollama_lines[i] if i < len(ollama_lines) else ""
        granite_line = granite_lines[i] if i < len(granite_lines) else ""
        
        # Truncate lines that are too long
        if len(ollama_line) > 38:
            ollama_line = ollama_line[:35] + "..."
        if len(granite_line) > 38:
            granite_line = granite_line[:35] + "..."
            
        print(f"{ollama_line:<40} | {granite_line:<40}")
    
    print(f"\n{'-'*80}")
    print(f"{'Time: ' + str(comp['ollama_time']) + 's':<40} | {'Time: ' + str(comp['granite_time']) + 's':<40}")
    print(f"{'Sources: ' + str(comp['ollama_sources']):<40} | {'Sources: ' + str(comp['granite_sources']):<40}")

# Display comparisons
for i in range(len(comparisons)):
    display_comparison(i)

# Cell 8: Qualitative Analysis
print("\n" + "=" * 80)
print("QUALITATIVE ANALYSIS")
print("=" * 80)

observations = {
    "verbosity": {
        "ollama": "More conversational and detailed",
        "granite": "More concise and factual"
    },
    "accuracy": {
        "ollama": "Good for general knowledge",
        "granite": "Better for technical accuracy"
    },
    "handling_out_of_domain": {
        "ollama": "May attempt to answer anyway",
        "granite": "Better at refusing gracefully"
    },
    "speed": {
        "ollama": f"{results_df['ollama_time'].mean():.2f}s average",
        "granite": f"{results_df['granite_time'].mean():.2f}s average"
    }
}

for aspect, comparison in observations.items():
    print(f"\n{aspect.replace('_', ' ').title()}:")
    for model, observation in comparison.items():
        print(f"  {model.capitalize()}: {observation}")

# Cell 9: Save Complete Results
results_df.to_csv("lab_2.3_twin_comparison.csv", index=False)

# Create detailed report
with open("lab_2.3_comparison_report.txt", "w") as f:
    f.write("TWIN RAG PIPELINE COMPARISON REPORT\n")
    f.write("=" * 80 + "\n\n")
    
    for i, comp in enumerate(comparisons):
        f.write(f"Query {i+1}: {comp['query']}\n")
        f.write("-" * 80 + "\n")
        f.write(f"Category: {comp['category']}\n\n")
        
        f.write("OLLAMA:\n")
        f.write(f"  Answer: {comp['ollama_answer']}\n")
        f.write(f"  Time: {comp['ollama_time']:.2f}s\n")
        f.write(f"  Sources: {comp['ollama_sources']}\n\n")
        
        f.write("GRANITE:\n")
        f.write(f"  Answer: {comp['granite_answer']}\n")
        f.write(f"  Time: {comp['granite_time']:.2f}s\n")
        f.write(f"  Sources: {comp['granite_sources']}\n")
        f.write("\n" + "=" * 80 + "\n\n")

print("\n✓ Detailed report saved to lab_2.3_comparison_report.txt")

print("\n" + "=" * 80)
print("LAB 2.3 COMPLETE! ✅")
print("=" * 80)
print("\nKey Findings:")
print(f"  • Average response time difference: {results_df['time_difference'].mean():.2f}s")
print(f"  • Faster system: {results_df['faster_backend'].mode()[0]}")
print(f"  • Both systems retrieved similar number of sources")
print("\nNext: Lab 2.4 - Build evaluation harness")
```

---

## Lab 2.4 Solution: RAG Evaluation Harness

### Complete Evaluation Framework

```python
# ============================================================================
# LAB 2.4: RAG EVALUATION HARNESS - COMPLETE SOLUTION
# ============================================================================

import pandas as pd
import numpy as np
from rouge_score import rouge_scorer
from typing import List, Dict, Tuple
import matplotlib.pyplot as plt
import seaborn as sns

# Cell 1: Define Ground Truth
print("=" * 80)
print("RAG EVALUATION HARNESS")
print("=" * 80)

ground_truth = [
    {
        "query": "What is Retrieval Augmented Generation?",
        "gold_answer": "RAG is a technique that enhances LLMs by retrieving relevant external knowledge from a document corpus to ground responses in factual data.",
        "relevant_doc_ids": ["rag_overview.txt"],
        "must_include_concepts": ["retrieval", "generation", "external knowledge", "LLM"]
    },
    {
        "query": "What are the benefits of RAG?",
        "gold_answer": "RAG reduces hallucinations, provides access to current information, enables domain-specific knowledge without retraining, and offers source attribution.",
        "relevant_doc_ids": ["rag_overview.txt"],
        "must_include_concepts": ["hallucination", "current information", "domain-specific"]
    },
    {
        "query": "Explain chunking strategies",
        "gold_answer": "Chunking strategies include fixed-size splitting by tokens, semantic chunking by paragraphs, and recursive chunking that tries multiple separators.",
        "relevant_doc_ids": ["chunking_strategies.txt"],
        "must_include_concepts": ["fixed-size", "semantic", "recursive"]
    }
]

print(f"✓ Created ground truth with {len(ground_truth)} test cases")

# Cell 2: Retrieval Metrics
def calculate_retrieval_metrics(
    retrieved_doc_ids: List[str],
    relevant_doc_ids: List[str]
) -> Dict:
    """
    Calculate retrieval quality metrics
    
    Metrics:
    - Precision: What % of retrieved docs are relevant?
    - Recall: What % of relevant docs were retrieved?
    - F1: Harmonic mean of precision and recall
    - Hit Rate: Was at least one relevant doc retrieved?
    """
    retrieved_set = set(retrieved_doc_ids)
    relevant_set = set(relevant_doc_ids)
    
    true_positives = len(retrieved_set & relevant_set)
    
    precision = true_positives / len(retrieved_set) if retrieved_set else 0
    recall = true_positives / len(relevant_set) if relevant_set else 0
    f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0
    hit_rate = 1 if true_positives > 0 else 0
    
    return {
        "precision": precision,
        "recall": recall,
        "f1": f1,
        "hit_rate": hit_rate,
        "retrieved_count": len(retrieved_set),
        "relevant_count": len(relevant_set)
    }

# Test retrieval metrics
test_retrieved = ["rag_overview.txt", "chunking_strategies.txt"]
test_relevant = ["rag_overview.txt"]
test_metrics = calculate_retrieval_metrics(test_retrieved, test_relevant)

print("\nRetrieval Metrics Example:")
for metric, value in test_metrics.items():
    print(f"  {metric}: {value:.3f}" if isinstance(value, float) else f"  {metric}: {value}")

# Cell 3: Answer Quality Metrics
def calculate_answer_metrics(
    generated_answer: str,
    gold_answer: str,
    must_include_concepts: List[str]
) -> Dict:
    """
    Calculate answer quality metrics
    
    Metrics:
    - ROUGE-L: Longest common subsequence similarity
    - Concept Coverage: % of required concepts present
    - Answer Length: Number of words
    """
    # ROUGE-L score
    scorer = rouge_scorer.RougeScorer(['rougeL'], use_stemmer=True)
    rouge_scores = scorer.score(gold_answer, generated_answer)
    rouge_l = rouge_scores['rougeL'].fmeasure
    
    # Concept coverage
    answer_lower = generated_answer.lower()
    concepts_found = [c for c in must_include_concepts if c.lower() in answer_lower]
    concept_coverage = len(concepts_found) / len(must_include_concepts) if must_include_concepts else 0
    
    # Length metrics
    word_count = len(generated_answer.split())
    
    return {
        "rouge_l": rouge_l,
        "concept_coverage": concept_coverage,
        "concepts_found": concepts_found,
        "concepts_missing": [c for c in must_include_concepts if c not in concepts_found],
        "word_count": word_count
    }

# Test answer metrics
test_answer = "RAG combines retrieval and generation using external knowledge for LLMs"
test_gold = "RAG enhances LLMs with retrieved external knowledge"
test_concepts = ["retrieval", "generation", "external knowledge"]
test_answer_metrics = calculate_answer_metrics(test_answer, test_gold, test_concepts)

print("\nAnswer Quality Metrics Example:")
for metric, value in test_answer_metrics.items():
    if isinstance(value, float):
        print(f"  {metric}: {value:.3f}")
    elif isinstance(value, list):
        print(f"  {metric}: {value}")
    else:
        print(f"  {metric}: {value}")

# Cell 4: Evaluate RAG System
def evaluate_rag_system(
    rag_chain,
    test_cases: List[Dict],
    backend_name: str
) -> pd.DataFrame:
    """
    Comprehensive RAG system evaluation
    
    Args:
        rag_chain: The RAG QA chain to evaluate
        test_cases: List of test cases with ground truth
        backend_name: Name of the backend (e.g., "Ollama", "Granite")
    
    Returns:
        DataFrame with evaluation results
    """
    print(f"\nEvaluating {backend_name} RAG system...")
    print("-" * 80)
    
    results = []
    
    for i, test_case in enumerate(test_cases, 1):
        query = test_case["query"]
        print(f"\n{i}. {query}")
        
        # Get RAG response
        response = rag_chain({"query": query})
        generated_answer = response['result']
        retrieved_docs = response['source_documents']
        
        # Extract doc IDs from retrieved documents
        retrieved_doc_ids = [
            doc.metadata['source'].split('/')[-1]
            for doc in retrieved_docs
        ]
        
        # Calculate retrieval metrics
        retrieval_metrics = calculate_retrieval_metrics(
            retrieved_doc_ids,
            test_case["relevant_doc_ids"]
        )
        
        # Calculate answer metrics
        answer_metrics = calculate_answer_metrics(
            generated_answer,
            test_case["gold_answer"],
            test_case["must_include_concepts"]
        )
        
        # Combine results
        result = {
            "backend": backend_name,
            "query": query,
            "generated_answer": generated_answer,
            **retrieval_metrics,
            **answer_metrics
        }
        
        results.append(result)
        
        # Print summary
        print(f"   Retrieval F1: {retrieval_metrics['f1']:.3f}")
        print(f"   Concept Coverage: {answer_metrics['concept_coverage']:.1%}")
        print(f"   ROUGE-L: {answer_metrics['rouge_l']:.3f}")
    
    return pd.DataFrame(results)

# Cell 5: Run Evaluations
print("\n" + "=" * 80)
print("RUNNING EVALUATIONS")
print("=" * 80)

# Evaluate Ollama
ollama_eval_results = evaluate_rag_system(
    qa_chain_ollama,  # from Lab 2.1
    ground_truth,
    "Ollama"
)

# Evaluate Granite
granite_eval_results = evaluate_rag_system(
    qa_chain_granite,  # from Lab 2.2
    ground_truth,
    "Granite"
)

# Combine results
all_eval_results = pd.concat([ollama_eval_results, granite_eval_results])

# Cell 6: Aggregate Analysis
print("\n" + "=" * 80)
print("EVALUATION SUMMARY")
print("=" * 80)

summary_metrics = all_eval_results.groupby('backend').agg({
    'precision': 'mean',
    'recall': 'mean',
    'f1': 'mean',
    'hit_rate': 'mean',
    'rouge_l': 'mean',
    'concept_coverage': 'mean',
    'word_count': 'mean'
}).round(3)

print("\nAverage Metrics by Backend:")
print(summary_metrics)

# Cell 7: Visualizations
fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Retrieval metrics
ax1 = axes[0, 0]
retrieval_metrics = ['precision', 'recall', 'f1']
x = np.arange(len(retrieval_metrics))
width = 0.35
ax1.bar(x - width/2, summary_metrics.loc['Ollama', retrieval_metrics], 
        width, label='Ollama', alpha=0.8)
ax1.bar(x + width/2, summary_metrics.loc['Granite', retrieval_metrics],
        width, label='Granite', alpha=0.8)
ax1.set_ylabel('Score')
ax1.set_title('Retrieval Metrics')
ax1.set_xticks(x)
ax1.set_xticklabels(retrieval_metrics)
ax1.legend()
ax1.set_ylim([0, 1])
ax1.grid(axis='y', alpha=0.3)

# Answer quality
ax2 = axes[0, 1]
answer_metrics = ['rouge_l', 'concept_coverage']
x = np.arange(len(answer_metrics))
ax2.bar(x - width/2, summary_metrics.loc['Ollama', answer_metrics],
        width, label='Ollama', alpha=0.8)
ax2.bar(x + width/2, summary_metrics.loc['Granite', answer_metrics],
        width, label='Granite', alpha=0.8)
ax2.set_ylabel('Score')
ax2.set_title('Answer Quality Metrics')
ax2.set_xticks(x)
ax2.set_xticklabels(answer_metrics)
ax2.legend()
ax2.set_ylim([0, 1])
ax2.grid(axis='y', alpha=0.3)

# Per-query F1 scores
ax3 = axes[1, 0]
query_numbers = range(1, len(ground_truth) + 1)
ollama_f1 = ollama_eval_results['f1'].values
granite_f1 = granite_eval_results['f1'].values
x = np.arange(len(query_numbers))
ax3.plot(x, ollama_f1, 'o-', label='Ollama', linewidth=2, markersize=8)
ax3.plot(x, granite_f1, 's-', label='Granite', linewidth=2, markersize=8)
ax3.set_xlabel('Query Number')
ax3.set_ylabel('F1 Score')
ax3.set_title('Per-Query Retrieval F1')
ax3.set_xticks(x)
ax3.set_xticklabels(query_numbers)
ax3.legend()
ax3.grid(alpha=0.3)
ax3.set_ylim([0, 1.1])

# Per-query concept coverage
ax4 = axes[1, 1]
ollama_coverage = ollama_eval_results['concept_coverage'].values
granite_coverage = granite_eval_results['concept_coverage'].values
ax4.plot(x, ollama_coverage, 'o-', label='Ollama', linewidth=2, markersize=8)
ax4.plot(x, granite_coverage, 's-', label='Granite', linewidth=2, markersize=8)
ax4.set_xlabel('Query Number')
ax4.set_ylabel('Concept Coverage')
ax4.set_title('Per-Query Concept Coverage')
ax4.set_xticks(x)
ax4.set_xticklabels(query_numbers)
ax4.legend()
ax4.grid(alpha=0.3)
ax4.set_ylim([0, 1.1])

plt.tight_layout()
plt.savefig('lab_2.4_evaluation_results.png', dpi=300, bbox_inches='tight')
print("\n✓ Evaluation visualizations saved")

# Cell 8: Design eval_small.py Script
eval_script_design = """
# accelerator/tools/eval_small.py

import argparse
import pandas as pd
from pathlib import Path
import requests
import json

def load_test_cases(csv_path: str) -> pd.DataFrame:
    '''Load test queries and ground truth from CSV'''
    return pd.read_csv(csv_path)

def call_rag_api(endpoint: str, query: str) -> dict:
    '''Call the RAG API endpoint'''
    response = requests.post(
        f"{endpoint}/ask",
        json={"query": query}
    )
    return response.json()

def evaluate_response(
    generated: str,
    gold: str,
    relevant_docs: list
) -> dict:
    '''Calculate metrics for a single response'''
    # Implementation from above
    pass

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--test-data', required=True)
    parser.add_argument('--api-endpoint', required=True)
    parser.add_argument('--output', default='eval_results.json')
    args = parser.parse_args()
    
    # Load test cases
    test_cases = load_test_cases(args.test_data)
    
    # Run evaluation
    results = []
    for _, test in test_cases.iterrows():
        response = call_rag_api(args.api_endpoint, test['query'])
        metrics = evaluate_response(
            response['answer'],
            test['gold_answer'],
            test['relevant_docs'].split(',')
        )
        results.append(metrics)
    
    # Save results
    with open(args.output, 'w') as f:
        json.dump(results, f, indent=2)
    
    # Print summary
    df = pd.DataFrame(results)
    print(df.describe())

if __name__ == '__main__':
    main()
"""

with open("eval_small.py.design", "w") as f:
    f.write(eval_script_design)

print("\n✓ Script design saved to eval_small.py.design")

# Cell 9: Save All Results
all_eval_results.to_csv("lab_2.4_full_evaluation.csv", index=False)
summary_metrics.to_csv("lab_2.4_summary_metrics.csv")

print("\n" + "=" * 80)
print("LAB 2.4 COMPLETE! ✅")
print("=" * 80)
print("\nKey Achievements:")
print("  ✓ Defined ground truth test cases")
print("  ✓ Implemented retrieval metrics (P/R/F1)")
print("  ✓ Implemented answer quality metrics (ROUGE, concept coverage)")
print("  ✓ Evaluated both RAG backends")
print("  ✓ Created visualizations")
print("  ✓ Designed eval_small.py script")
print("\nAll Labs Complete! Ready for production integration.")
```

---

## Production Deployment Code

### Accelerator Integration Examples

```python
# accelerator/rag/pipeline.py

from typing import Dict, List
from langchain.chains import RetrievalQA
from .retriever import create_retriever
from .prompt import get_rag_prompt

def answer_question(
    query: str,
    vectorstore,
    llm,
    top_k: int = 5
) -> Dict:
    """
    Production RAG pipeline
    
    Args:
        query: User question
        vectorstore: Vector database instance
        llm: Language model instance
        top_k: Number of documents to retrieve
    
    Returns:
        {
            "answer": str,
            "chunks": List[dict],
            "metadata": dict
        }
    """
    # Create retriever
    retriever = create_retriever(vectorstore, k=top_k)
    
    # Get prompt template
    prompt = get_rag_prompt()
    
    # Build QA chain
    qa_chain = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",
        retriever=retriever,
        return_source_documents=True,
        chain_type_kwargs={"prompt": prompt}
    )
    
    # Generate answer
    result = qa_chain({"query": query})
    
    # Format response
    return {
        "answer": result['result'],
        "chunks": [
            {
                "id": doc.metadata.get('id'),
                "text": doc.page_content,
                "source": doc.metadata.get('source'),
                "score": doc.metadata.get('score', 0)
            }
            for doc in result['source_documents']
        ],
        "metadata": {
            "model_id": llm.model_id if hasattr(llm, 'model_id') else "unknown",
            "num_chunks": len(result['source_documents']),
            "retrieval_k": top_k
        }
    }

# accelerator/service/api.py

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from ..rag import pipeline
from ..rag import retriever

app = FastAPI(title="RAG Service")

class QuestionRequest(BaseModel):
    query: str
    top_k: int = 5

class AnswerResponse(BaseModel):
    answer: str
    citations: List[Dict]
    metadata: Dict

@app.post("/ask", response_model=AnswerResponse)
async def ask_question(request: QuestionRequest):
    """
    Answer a question using RAG
    
    Example:
        POST /ask
        {
            "query": "What is RAG?",
            "top_k": 5
        }
    """
    try:
        result = pipeline.answer_question(
            query=request.query,
            vectorstore=app.state.vectorstore,
            llm=app.state.llm,
            top_k=request.top_k
        )
        
        return AnswerResponse(
            answer=result["answer"],
            citations=result["chunks"],
            metadata=result["metadata"]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

---

## Troubleshooting Guide

### Common Issues

```python
# Issue 1: Ollama not responding
# Solution:
"""
1. Check if Ollama is running:
   ps aux | grep ollama

2. Start Ollama:
   ollama serve

3. Test connection:
   curl http://localhost:11434/api/tags
"""

# Issue 2: watsonx.ai authentication errors
# Solution:
"""
1. Verify API key:
   echo $WATSONX_APIKEY

2. Check project ID:
   # Should be in format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

3. Test credentials:
   from ibm_watsonx_ai import APIClient
   client = APIClient(credentials=creds, project_id=project_id)
   client.foundation_models.get_model_specs()
"""

# Issue 3: Slow retrieval
# Solution:
"""
1. Reduce top_k parameter
2. Use smaller embedding model
3. Implement caching
4. Consider approximate nearest neighbor search
"""

# Issue 4: Out of memory
# Solution:
"""
1. Process documents in batches
2. Use smaller chunk size
3. Clear unused variables:
   import gc
   gc.collect()
4. Use generators instead of lists
"""
```

---

## Summary

### Workshop Completion Checklist

- [x] Understand RAG architecture and components
- [x] Implement local RAG with Ollama and Chroma
- [x] Build enterprise RAG with watsonx.ai and Elasticsearch
- [x] Compare multiple RAG implementations
- [x] Create automated evaluation harness
- [x] Design production deployment patterns
- [x] Map concepts to AI Accelerator framework

### Next Steps

1. **Day 3 Integration**:
   - Implement accelerator components
   - Deploy FastAPI service
   - Build Streamlit UI
   - Set up monitoring

2. **Advanced Topics**:
   - Multi-modal RAG (images, tables)
   - Agentic RAG systems
   - Hybrid search (keyword + semantic)
   - Advanced evaluation metrics

3. **Production Considerations**:
   - Scaling strategies
   - Security and authentication
   - Cost optimization
   - User feedback loops

---

**Congratulations on completing Day 2! 🎉**

You now have production-ready RAG implementation skills and are prepared to build enterprise AI applications.
