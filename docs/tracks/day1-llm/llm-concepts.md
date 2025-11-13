# 1.0 LLM Concepts & Architecture

Welcome to Day 1 of the watsonx Workshop! Today we'll explore Large Language Models (LLMs), their architecture, and how to work with them effectively.

---

## Learning Objectives

By the end of this module, you will:

- Understand core LLM terminology and constraints
- Compare local vs managed LLM deployment models
- Know how LLMs fit into production architectures
- Understand key parameters that control model behavior

---

## What is a Large Language Model?

A **Large Language Model (LLM)** is a neural network trained on vast amounts of text data to understand and generate human-like text. Think of it as a powerful pattern-matching engine that has learned the statistical relationships between words, phrases, and concepts.

### Key Characteristics

**Scale**: LLMs contain billions of parameters (weights) that encode knowledge learned from training data. For example:
- GPT-3: 175 billion parameters
- Llama 3.2: 1-3 billion parameters (smaller variants)
- Granite 13B: 13 billion parameters

**Training Data**: Models are trained on diverse text sources including:
- Books, articles, and documentation
- Web pages and forums
- Code repositories
- Scientific papers

**Capabilities**: Modern LLMs can:
- Answer questions
- Summarize documents
- Write code
- Translate languages
- Extract structured information
- Reason through problems (with varying degrees of success)

---

## Key Concepts

### Tokens & Tokenization

LLMs don't work with words—they work with **tokens**. A token is a sub-unit of text that the model processes.

**Examples**:
- "Hello" → 1 token
- "watsonx.ai" → might be 2-3 tokens (depends on the tokenizer)
- "AI" → 1 token
- A space or punctuation can be its own token

**Why this matters**:
- Models have **token limits** (context windows)
- API costs are often calculated per token
- Long documents need to be chunked to fit within token limits

**Rule of thumb**: 
- English: ~4 characters per token on average
- Code: Often more tokens per line than natural language

### Context Window and Truncation

The **context window** is the maximum number of tokens a model can process at once. This includes both:
- Your input (prompt)
- The model's output (completion)

**Common context window sizes**:
- Llama 3.2 (1B): 128K tokens
- Granite 13B: 8K tokens (some variants)
- GPT-4: 8K-32K tokens (depending on version)

**Truncation**: If your input exceeds the context window, it gets truncated (cut off), which can lead to:
- Missing important context
- Incomplete responses
- Errors

**Best practice**: Always check token counts before sending prompts to ensure you stay within limits.

### Temperature, Top-k, Top-p

These parameters control the **randomness** and **creativity** of model outputs.

#### Temperature (0.0 to 2.0)

Controls output randomness:

- **Low (0.0-0.3)**: Deterministic, focused
  - Use for: Code generation, factual Q&A, structured outputs
  - Output: Consistent, predictable
  
- **Medium (0.7-1.0)**: Balanced creativity
  - Use for: General conversation, content generation
  - Output: Varied but coherent
  
- **High (1.5-2.0)**: Very creative, less predictable
  - Use for: Creative writing, brainstorming
  - Output: Diverse, sometimes surprising

**Example**:
```python
# Temperature = 0.0
"The capital of France is Paris."

# Temperature = 1.5
"The capital of France? Ah, the City of Light—Paris! 
Known for its cafes, the Eiffel Tower, and rich history..."
```

#### Top-k (integer)

Limits the model to choose from the top-k most probable next tokens.

- **Low k (1-10)**: Very focused, less diverse
- **High k (50-100)**: More diverse options

#### Top-p (0.0 to 1.0, also called "nucleus sampling")

Dynamically selects from the smallest set of tokens whose cumulative probability exceeds p.

- **Low p (0.1-0.5)**: Conservative, focused
- **High p (0.9-0.95)**: More diverse

**Typical settings**:
- Factual tasks: `temperature=0.2, top_p=0.1`
- Creative tasks: `temperature=0.9, top_p=0.9`

### Latency and Throughput

**Latency**: Time from sending a request to receiving the complete response.
- Affected by: Model size, prompt length, generation length, hardware

**Throughput**: Number of requests processed per unit time.
- Important for: Production systems, batch processing

**Factors affecting performance**:
- **Model size**: Larger models = slower inference
- **Batch size**: Processing multiple requests together improves throughput
- **Hardware**: GPUs provide much faster inference than CPUs

---

## Local vs Managed LLMs

You have two main deployment options for LLMs in production:

### Local LLMs (e.g., Ollama)

**What it is**: Running models on your own infrastructure (laptop, on-prem servers, private cloud).

**Pros**:
- ✅ **Privacy**: Data never leaves your environment
- ✅ **Control**: Full control over model versions and updates
- ✅ **Cost**: No per-token API charges after initial setup
- ✅ **Customization**: Can fine-tune models for specific use cases
- ✅ **Offline**: Works without internet connectivity

**Cons**:
- ❌ **Hardware requirements**: Need GPUs for acceptable performance
- ❌ **Maintenance**: You manage infrastructure, updates, scaling
- ❌ **Limited scale**: Constrained by your hardware resources
- ❌ **Model selection**: Limited to models that fit in your hardware

**Best for**:
- Prototyping and development
- Privacy-sensitive applications
- Organizations with existing GPU infrastructure
- Small to medium workloads

**Example tools**:
- **Ollama**: Easy local LLM management
- **LM Studio**: GUI for local models
- **vLLM**: High-performance inference server

### Managed LLMs (e.g., watsonx.ai)

**What it is**: Using LLMs via cloud APIs where the provider handles infrastructure.

**Pros**:
- ✅ **Scale**: Handle any workload, automatic scaling
- ✅ **Governance**: Built-in compliance, audit trails, guardrails
- ✅ **Model catalog**: Access to multiple models without hardware concerns
- ✅ **SLAs**: Guaranteed uptime and performance
- ✅ **No maintenance**: Provider handles infrastructure, updates, optimization
- ✅ **Enterprise features**: Multi-tenancy, access controls, monitoring

**Cons**:
- ❌ **Cost**: Pay per token (can add up at scale)
- ❌ **Data privacy**: Data sent to cloud (though providers like IBM offer security guarantees)
- ❌ **Latency**: Network overhead for each request
- ❌ **Less control**: Dependent on provider's model versions and availability

**Best for**:
- Production applications at scale
- Teams without deep ML infrastructure expertise
- Regulated industries needing governance
- Applications requiring multiple models

**watsonx.ai specifically offers**:
- IBM Granite models optimized for enterprise
- Built-in governance and compliance tracking
- Integration with IBM Cloud services
- Prompt template management
- Model deployment and monitoring

---

## Cost & Resource Considerations

### GPU vs CPU

**GPU (Graphics Processing Unit)**:
- Designed for parallel computations
- Essential for training LLMs
- Greatly accelerates inference (10-100x faster than CPU)
- **Cost**: $1,000 - $10,000+ per card (consumer to enterprise)

**CPU (Central Processing Unit)**:
- General-purpose computing
- Can run small models (1-3B parameters) acceptably
- Struggles with larger models (13B+)
- **Cost**: Cheaper, already available in most systems

**Memory requirements**:
- Rough estimate: Model needs ~2 bytes per parameter (for FP16)
- Example: 13B model needs ~26 GB GPU memory

### Cloud Cost Dimensions

When using managed services like watsonx.ai:

**Token-based pricing**:
- Input tokens: Text you send
- Output tokens: Text generated
- Typically: $0.0001 - $0.001 per token (varies by model)

**Example calculation**:
```
Prompt: 1,000 tokens
Response: 500 tokens
Cost: (1000 + 500) × $0.0002 = $0.30 per request
```

**Cost optimization strategies**:
- Use smaller models when appropriate
- Cache common responses
- Implement prompt compression
- Use batch processing for non-real-time workloads
- Set max_tokens limits to control costs

---

## Where the Accelerator Fits Architecturally

Throughout this workshop, we'll reference the **RAG Accelerator**—a production-ready skeleton for building LLM applications. Here's how it's structured:

### Core Architecture

```
accelerator/
├── rag/                    # RAG core logic
│   ├── pipeline.py        # Orchestrates retrieval + LLM
│   ├── retriever.py       # Vector DB queries (Elasticsearch/Chroma)
│   ├── prompt.py          # Shared prompt templates
│   └── embedder.py        # Text embedding logic
├── service/               # Production API
│   ├── api.py            # FastAPI microservice (POST /ask)
│   ├── deps.py           # Configuration & dependencies
│   └── models.py         # Request/response schemas
├── tools/                 # CLI utilities
│   ├── chunk.py          # Document chunking
│   ├── extract.py        # Text extraction from PDFs, docs
│   ├── embed_index.py    # Embedding and indexing pipeline
│   └── eval_small.py     # Evaluation harness
├── ui/                    # User interface
│   └── app.py            # Streamlit front-end
└── config.yaml           # Central configuration
```

### How LLMs Fit In

On Day 1, we're focusing on **pure LLM behavior** (no retrieval). This maps to:

**Current state** (Day 1):
```python
# pipeline.py (simplified)
def answer_question(question: str) -> str:
    # Direct LLM call
    response = llm.generate(prompt=question)
    return response
```

**Future state** (Day 2-3):
```python
# pipeline.py (with RAG)
def answer_question(question: str) -> str:
    # 1. Retrieve relevant context
    context = retriever.search(question, top_k=5)
    
    # 2. Build prompt with context
    prompt = prompt_template.format(
        question=question,
        context=context
    )
    
    # 3. Generate answer
    response = llm.generate(prompt=prompt)
    return response
```

### Key Integration Points

1. **Model Selection** (`service/deps.py`):
   - Switches between Ollama and watsonx.ai
   - Manages credentials and endpoints

2. **Prompt Engineering** (`rag/prompt.py`):
   - System instructions
   - Few-shot examples
   - Context injection patterns

3. **Response Handling** (`rag/pipeline.py`):
   - Parse structured outputs
   - Extract citations
   - Handle errors

---

## Reference Notebooks

The workshop includes several reference notebooks that show LLMs in production contexts:

### RAG Examples (`labs-src/`)

- `use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`
  - Full RAG pipeline with Elasticsearch
  - Shows prompt structure with context
  
- `use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`
  - Alternative vector DB (Chroma)
  - LangChain integration patterns

### Accelerator Notebooks (`accelerator/assets/notebook/`)

- `QnA_with_RAG.ipynb`
  - End-to-end Q&A with retrieval
  - Prompt engineering for RAG
  
- `Create_and_Deploy_QnA_AI_Service.ipynb`
  - Deploy RAG service to production
  - API endpoint creation

**How to use these**:
- Don't run them line-by-line on Day 1
- **Do** open them to see:
  - How prompts are structured
  - How LLM calls are instrumented
  - How outputs are validated

---

## How This Connects to the Labs

### Day 1 Labs (Today)
- **Lab 1.1**: Quick start with both Ollama and watsonx
  - Focus: Basic LLM calls, parameter tuning
  - No retrieval, just prompts → responses

- **Lab 1.2**: Prompt templates
  - Build reusable prompt patterns
  - Compare behavior across backends

- **Lab 1.3**: Micro-evaluation
  - Rate LLM outputs
  - Build a simple evaluation framework

### Day 2-3 Labs (Upcoming)
- Add retrieval (RAG)
- Integrate with the accelerator
- Build production-ready pipelines
- Add orchestration and agents

**Mental model**:
- **Day 1** = Understanding the LLM building block
- **Day 2** = LLM + retrieval (RAG)
- **Day 3** = LLM + retrieval + orchestration (agents)

---

## Further Reading

### Official Documentation
- [IBM Granite Models](https://www.ibm.com/granite/docs)
- [watsonx.ai Documentation](https://www.ibm.com/docs/en/watsonx-as-a-service)
- [Ollama Documentation](https://ollama.com/docs)

### Prompt Engineering
- [OpenAI Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)
- [Anthropic Prompt Engineering](https://docs.anthropic.com/claude/docs/prompt-engineering)
- [Granite Prompting Guide](https://www.ibm.com/granite/docs/models/granite/#chat-template)

### LLM Concepts
- [Hugging Face NLP Course](https://huggingface.co/learn/nlp-course)
- [LLM Training & Inference](https://www.deeplearning.ai/short-courses/)
- [Understanding Tokenization](https://huggingface.co/docs/transformers/tokenizer_summary)

### Responsible AI
- [IBM AI Ethics](https://www.ibm.com/artificial-intelligence/ethics)
- [Guardrails for LLMs](https://docs.guardrailsai.com/)

---

## Summary

You now understand:

- ✅ What LLMs are and how they work at a high level
- ✅ Key concepts: tokens, context windows, temperature, top-k/top-p
- ✅ Trade-offs between local and managed deployments
- ✅ Cost considerations for LLM applications
- ✅ How LLMs fit into the accelerator architecture

**Next**: Let's get hands-on with Lab 1.1 and actually run some prompts!
