# Lab 1.1 – Quickstart in Both Environments

**Duration**: 45 minutes  
**Difficulty**: Beginner

---

## Lab Overview

In this lab, you'll get hands-on experience with LLMs in both local (Ollama) and managed (watsonx.ai) environments. The goal is to become comfortable switching between repos, sending prompts, and observing differences in outputs.

---

## Learning Objectives

By the end of this lab, you will be able to:

- Send basic prompts to both Ollama and watsonx.ai
- Modify key parameters (temperature, max_tokens)
- Compare outputs and latency between backends
- Understand where the accelerator fits in

---

## Prerequisites

**Required** (from Day 0):
- ✅ `simple-ollama-environment` set up and working
- ✅ `simple-watsonx-enviroment` set up with valid credentials
- ✅ Both Jupyter environments accessible

**Optional but recommended**:
- Basic familiarity with Python and Jupyter notebooks
- `watsonx-workshop` repo cloned (for accelerator reference)

---

## Step 1 – Quick Warm-Up with Ollama

### 1.1 Open the Ollama Notebook

Navigate to your `simple-ollama-environment` repo:

```bash
cd ~/projects/watsonx-workshop/simple-ollama-environment
jupyter notebook
```

Open `notebooks/ollama_quickstart.ipynb` (or create a new notebook if you prefer).

### 1.2 Run a Simple "Hello" Prompt

Add and run this cell:

```python
import ollama

# Simple greeting
response = ollama.chat(
    model="qwen2.5:0.5b-instruct",  # or your preferred small model
    messages=[
        {"role": "user", "content": "Hello! Who are you?"}
    ]
)

print(response["message"]["content"])
```

**Expected output**: The model should introduce itself.

**Note the**:
- Response time (how fast was it?)
- Response style (casual, formal, verbose?)

### 1.3 Run a Short Reasoning Prompt

Now try a more challenging prompt:

```python
import ollama
import time

prompt = """A farmer has 17 sheep, and all but 9 die. How many are left?

Let's think step by step:"""

start_time = time.time()

response = ollama.chat(
    model="qwen2.5:0.5b-instruct",
    messages=[{"role": "user", "content": prompt}]
)

elapsed = time.time() - start_time

print(f"Response (took {elapsed:.2f}s):\n")
print(response["message"]["content"])
```

**Questions to consider**:
- Did the model reason correctly? (Answer should be 9 sheep)
- How long did it take?
- Was the reasoning process clear?

---

## Step 2 – Warm-Up with watsonx.ai

### 2.1 Open the watsonx Notebook

Navigate to your `simple-watsonx-enviroment` repo:

```bash
cd ~/projects/watsonx-workshop/simple-watsonx-enviroment
jupyter notebook
```

Open `notebooks/watsonx_quickstart.ipynb`.

### 2.2 Verify Credentials

Make sure your `.env` file is properly loaded:

```python
import os
from dotenv import load_dotenv

load_dotenv()

# Check credentials
api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

print(f"API Key: {'✓ Set' if api_key else '✗ Missing'}")
print(f"URL: {url}")
print(f"Project ID: {'✓ Set' if project_id else '✗ Missing'}")
```

All three should show as set.

### 2.3 Run the Same "Hello" Prompt

```python
import os
import time
from dotenv import load_dotenv
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

load_dotenv()

# Setup
api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

credentials = Credentials(url=url, api_key=api_key)

# Create model instance
model = ModelInference(
    model_id="ibm/granite-13b-instruct-v2",
    credentials=credentials,
    project_id=project_id,
)

# Simple greeting
prompt = "Hello! Who are you?"

params = {
    GenParams.DECODING_METHOD: "greedy",
    GenParams.MAX_NEW_TOKENS: 100,
}

start_time = time.time()
response = model.generate_text(prompt=prompt, params=params)
elapsed = time.time() - start_time

print(f"Response (took {elapsed:.2f}s):\n")
print(response)
```

**Compare to Ollama**:
- How does the response differ in style?
- Which was faster?
- Which feels more "polished"?

### 2.4 Run the Reasoning Prompt

```python
prompt = """A farmer has 17 sheep, and all but 9 die. How many are left?

Let's think step by step:"""

params = {
    GenParams.DECODING_METHOD: "greedy",
    GenParams.MAX_NEW_TOKENS: 200,
}

start_time = time.time()
response = model.generate_text(prompt=prompt, params=params)
elapsed = time.time() - start_time

print(f"Response (took {elapsed:.2f}s):\n")
print(response)
```

**Compare**:
- Did Granite reason correctly?
- Was the reasoning clearer than Ollama's?
- Latency difference?

---

## Step 3 – Modify Basic Parameters

Now let's see how parameters affect outputs.

### 3.1 Temperature Experiment (Ollama)

Run the same prompt with different temperatures:

```python
import ollama

prompt = "Write a creative opening line for a sci-fi novel."

for temp in [0.0, 0.5, 1.0, 1.5]:
    print(f"\n{'='*60}")
    print(f"Temperature: {temp}")
    print(f"{'='*60}")
    
    response = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": prompt}],
        options={"temperature": temp}
    )
    
    print(response["message"]["content"])
```

**Observations**:
- At temp=0.0, do you get the same response every time?
- At temp=1.5, how much does the creativity increase?

### 3.2 Temperature Experiment (watsonx.ai)

```python
prompt = "Write a creative opening line for a sci-fi novel."

for temp in [0.0, 0.5, 1.0, 1.5]:
    print(f"\n{'='*60}")
    print(f"Temperature: {temp}")
    print(f"{'='*60}")
    
    params = {
        GenParams.DECODING_METHOD: "sample",  # Note: sample, not greedy
        GenParams.TEMPERATURE: temp,
        GenParams.MAX_NEW_TOKENS: 50,
    }
    
    response = model.generate_text(prompt=prompt, params=params)
    print(response)
```

**Note**: For temperature > 0, use `DECODING_METHOD: "sample"` (not "greedy").

### 3.3 Max Tokens Experiment

See what happens when you limit output length:

**Ollama**:
```python
prompt = "Explain quantum computing in detail."

for max_tokens in [20, 50, 100]:
    print(f"\n{'='*40}")
    print(f"Max Tokens: {max_tokens}")
    print(f"{'='*40}")
    
    response = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": prompt}],
        options={"num_predict": max_tokens}  # Ollama uses 'num_predict'
    )
    
    print(response["message"]["content"])
```

**watsonx.ai**:
```python
prompt = "Explain quantum computing in detail."

for max_tokens in [20, 50, 100]:
    print(f"\n{'='*40}")
    print(f"Max Tokens: {max_tokens}")
    print(f"{'='*40}")
    
    params = {
        GenParams.DECODING_METHOD: "greedy",
        GenParams.MAX_NEW_TOKENS: max_tokens,
    }
    
    response = model.generate_text(prompt=prompt, params=params)
    print(response)
```

**Observations**:
- At 20 tokens, is the response complete?
- At 100 tokens, is there a noticeable quality difference?

---

## Step 4 (Optional) – Peek at Accelerator Pipeline

This step is **read-only**—just to see where we're headed on Day 2.

### 4.1 Open accelerator/rag/pipeline.py

Navigate to the `watsonx-workshop` repo and open `accelerator/rag/pipeline.py` in a text editor or Jupyter:

```bash
cd ~/projects/watsonx-workshop/accelerator
cat rag/pipeline.py  # or open in your editor
```

**Look for**:
- A function like `answer_question(question: str) -> str`
- Currently, it might be a **placeholder**:

```python
def answer_question(question: str) -> str:
    """Answer a question (placeholder for now)"""
    # TODO: Add retrieval
    # TODO: Build prompt with context
    # TODO: Call LLM
    return "This is a placeholder response."
```

### 4.2 Mental Mapping Exercise

Think about how the single LLM call you just made maps to the accelerator:

**Your notebook** (today):
```python
response = model.generate_text(prompt="What is RAG?")
```

**Accelerator** (Day 2):
```python
def answer_question(question: str) -> str:
    # 1. Retrieve relevant docs
    docs = retriever.search(question)
    
    # 2. Build prompt with context
    prompt = prompt_template.format(question=question, context=docs)
    
    # 3. Generate answer (same call you just learned!)
    response = model.generate_text(prompt=prompt)
    
    return response
```

**Key insight**: The LLM call is the same—RAG just adds context retrieval beforehand.

---

## Step 5 (Optional) – Peek at Reference Notebooks

### 5.1 Open a RAG Notebook

Navigate to `labs-src/` and open:

```
labs-src/use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb
```

**Don't run it all**—just:
- Scroll to the section with the LLM call
- Notice how context is injected into the prompt
- Compare to your simple prompts above

**Example structure** you'll see:
```python
context = "...retrieved documents..."
prompt = f"""Based on this context:

{context}

Question: {question}

Answer:"""

response = llm.generate(prompt)
```

---

## Reflection Questions

Take a few minutes to think about and discuss (if in a group):

1. **What did you notice about differences between Ollama and watsonx?**
   - Speed?
   - Answer quality?
   - Ease of use?

2. **Which one feels faster / more flexible?**
   - Local = faster for small models?
   - Managed = faster for large models?

3. **When would you choose one over the other?**
   - Privacy concerns → Ollama
   - Production scale → watsonx.ai
   - Prototyping → Either!

4. **How did parameter changes affect outputs?**
   - Temperature impact on creativity?
   - Max tokens impact on completeness?

---

## Checkpoint

Before moving on, confirm:

- ✅ You can run notebooks in both `simple-ollama-environment` and `simple-watsonx-enviroment`
- ✅ You successfully generated responses from both backends
- ✅ You experimented with temperature and max_tokens
- ✅ You've seen where the production pipeline (`accelerator/rag/pipeline.py`) will call the LLM

If all boxes are checked, you're ready for **Lab 1.2 – Prompt Templates**!

---

## Troubleshooting

### Ollama Issues

**"Connection refused"**:
```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not, start it
ollama serve  # or restart Docker container
```

**"Model not found"**:
```bash
# Pull the model
ollama pull qwen2.5:0.5b-instruct
```

### watsonx.ai Issues

**"Invalid API key"**:
- Check your `.env` file
- Verify the key in IBM Cloud console
- Ensure no extra spaces in the `.env` file

**"Project not found"**:
- Verify the `PROJECT_ID` in IBM Cloud
- Ensure you have access to the project

**"Rate limit exceeded"**:
- Wait a few seconds between requests
- If persistent, check your IBM Cloud quota

---

## Next Steps

Great work! You've completed Lab 1.1. 

**Next**: Move on to **Lab 1.2 – Prompt Templates** to learn how to build reusable prompt patterns.
