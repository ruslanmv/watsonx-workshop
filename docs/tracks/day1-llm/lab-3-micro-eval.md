# Lab 1.3 – Micro-Evaluation Exercise

**Duration**: 60 minutes  
**Difficulty**: Intermediate

---

## Lab Overview

Build a systematic evaluation framework to compare Ollama and watsonx.ai responses across multiple prompts. You'll create a test set, collect outputs, apply a rating rubric, and analyze results.

---

## Learning Objectives

- Programmatically collect and evaluate model outputs
- Design and apply a rating rubric
- Store results in structured format (DataFrame)
- Lay groundwork for production evaluation

---

## Prerequisites

- ✅ Labs 1.1 and 1.2 completed
- ✅ Basic Python & pandas familiarity
- ✅ Understanding of evaluation principles from section 1.3

---

## Step 1 – Define a Test Set

Create a diverse set of test prompts covering different task types.

**Create file**: `evaluation_test_set.py`

```python
# evaluation_test_set.py

TEST_PROMPTS = [
    {
        "prompt": "Summarize the following in 2 sentences: Machine learning is a subset of artificial intelligence that enables systems to learn from data without explicit programming.",
        "task_type": "summarization",
        "expected_keywords": ["machine learning", "AI", "data", "learn"]
    },
    {
        "prompt": "Extract the main entities from: 'IBM released watsonx.ai in 2023 as an enterprise AI platform.'",
        "task_type": "extraction",
        "expected_keywords": ["IBM", "watsonx.ai", "2023"]
    },
    {
        "prompt": "Rewrite formally: 'Hey team, the API is down, can someone check it ASAP?'",
        "task_type": "style_transfer",
        "expected_keywords": ["API", "unavailable", "investigate"]
    },
    {
        "prompt": "Answer: What is the capital of France?",
        "task_type": "qa_factual",
        "ground_truth": "Paris",
        "expected_keywords": ["Paris"]
    },
    {
        "prompt": "Explain in simple terms: What is a REST API?",
        "task_type": "explanation",
        "expected_keywords": ["API", "web", "HTTP", "request", "response"]
    },
    {
        "prompt": "List 3 benefits of cloud computing in bullet points.",
        "task_type": "list_generation",
        "expected_format": "bullets"
    },
    {
        "prompt": "Translate to Spanish: 'Good morning, how are you?'",
        "task_type": "translation",
        "ground_truth": "Buenos días, ¿cómo estás?",
        "expected_keywords": ["Buenos días", "cómo"]
    },
    {
        "prompt": "Write a haiku about artificial intelligence.",
        "task_type": "creative",
        "expected_format": "haiku"
    },
    {
        "prompt": "Calculate: If a product costs $100 and has a 20% discount, what is the final price?",
        "task_type": "reasoning",
        "ground_truth": "$80"
    },
    {
        "prompt": "Based on this context: 'Python 3.11 was released in October 2022.', answer: When was Python 3.11 released?",
        "task_type": "qa_context",
        "ground_truth": "October 2022"
    }
]
```

---

## Step 2 – Collect Outputs from Both Backends

Create a notebook that runs all prompts through both models.

**Create file**: `micro_evaluation.ipynb`

```python
import pandas as pd
import time
from typing import List, Dict
import ollama
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from dotenv import load_dotenv
import os

# Load test prompts
from evaluation_test_set import TEST_PROMPTS

# Setup watsonx.ai
load_dotenv()
api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

watsonx_model = ModelInference(
    model_id="ibm/granite-13b-instruct-v2",
    credentials=Credentials(url=url, api_key=api_key),
    project_id=project_id,
)
```

**Data collection function**:

```python
def collect_responses() -> List[Dict]:
    """Collect responses from both backends for all test prompts."""
    results = []
    
    for i, test_case in enumerate(TEST_PROMPTS, 1):
        prompt = test_case["prompt"]
        print(f"\n[{i}/{len(TEST_PROMPTS)}] Processing: {prompt[:50]}...")
        
        # Ollama response
        try:
            start = time.time()
            ollama_resp = ollama.chat(
                model="qwen2.5:0.5b-instruct",
                messages=[{"role": "user", "content": prompt}]
            )
            ollama_answer = ollama_resp["message"]["content"]
            ollama_time = time.time() - start
        except Exception as e:
            ollama_answer = f"ERROR: {str(e)}"
            ollama_time = 0
        
        # watsonx.ai response
        try:
            params = {
                GenParams.DECODING_METHOD: "greedy",
                GenParams.MAX_NEW_TOKENS: 200,
            }
            start = time.time()
            watsonx_answer = watsonx_model.generate_text(prompt=prompt, params=params)
            watsonx_time = time.time() - start
        except Exception as e:
            watsonx_answer = f"ERROR: {str(e)}"
            watsonx_time = 0
        
        # Store results for Ollama
        results.append({
            "prompt": prompt,
            "backend": "ollama",
            "model": "qwen2.5:0.5b-instruct",
            "answer": ollama_answer,
            "latency_ms": ollama_time * 1000,
            "task_type": test_case["task_type"],
            "ground_truth": test_case.get("ground_truth", ""),
            "expected_keywords": test_case.get("expected_keywords", []),
            "expected_format": test_case.get("expected_format", ""),
            # Evaluation fields (to be filled in next step)
            "correctness": None,
            "clarity": None,
            "style_match": None,
            "completeness": None,
            "notes": ""
        })
        
        # Store results for watsonx.ai
        results.append({
            "prompt": prompt,
            "backend": "watsonx",
            "model": "granite-13b-instruct-v2",
            "answer": watsonx_answer,
            "latency_ms": watsonx_time * 1000,
            "task_type": test_case["task_type"],
            "ground_truth": test_case.get("ground_truth", ""),
            "expected_keywords": test_case.get("expected_keywords", []),
            "expected_format": test_case.get("expected_format", ""),
            "correctness": None,
            "clarity": None,
            "style_match": None,
            "completeness": None,
            "notes": ""
        })
        
        time.sleep(0.5)  # Rate limiting
    
    return results

# Collect all responses
results = collect_responses()

# Create DataFrame
df = pd.DataFrame(results)
print(f"\n✓ Collected {len(df)} responses ({len(df)//2} prompts × 2 backends)")
df.head()
```

---

## Step 3 – Apply a Rating Rubric

Define evaluation functions and apply them:

```python
def evaluate_correctness(row: pd.Series) -> int:
    """
    Evaluate correctness (1-5 scale).
    5 = Fully correct, 3 = Partially correct, 1 = Incorrect
    """
    answer = row['answer'].lower()
    
    # If ground truth exists, check it
    if row['ground_truth']:
        gt = row['ground_truth'].lower()
        if gt in answer:
            return 5
        else:
            return 2  # Wrong but attempted
    
    # Otherwise, check for expected keywords
    if row['expected_keywords']:
        found = sum(1 for kw in row['expected_keywords'] if kw.lower() in answer)
        if found == len(row['expected_keywords']):
            return 5
        elif found > len(row['expected_keywords']) / 2:
            return 4
        elif found > 0:
            return 3
        else:
            return 2
    
    # Default (manual review needed)
    return 3

def evaluate_clarity(row: pd.Series) -> int:
    """
    Evaluate clarity (1-5 scale).
    5 = Crystal clear, 1 = Confusing/incoherent
    """
    answer = row['answer']
    
    # Simple heuristics
    if len(answer) < 10:
        return 2  # Too short
    if len(answer.split()) < 5:
        return 2
    if "ERROR" in answer:
        return 1
    
    # Check for coherent sentence structure
    if answer.strip().endswith(('.', '!', '?')):
        return 5
    else:
        return 4

def evaluate_style_match(row: pd.Series) -> int:
    """
    Evaluate style/format match (1-5 scale).
    5 = Perfect format, 1 = Wrong format
    """
    answer = row['answer']
    expected_format = row['expected_format']
    
    if not expected_format:
        return 5  # N/A, give benefit of doubt
    
    if expected_format == "bullets":
        if any(marker in answer for marker in ['-', '*', '•', '1.', '2.']):
            return 5
        else:
            return 2
    
    if expected_format == "haiku":
        lines = [l.strip() for l in answer.split('\n') if l.strip()]
        if len(lines) == 3:
            return 5
        else:
            return 3
    
    return 3  # Default

# Apply evaluations
df['correctness'] = df.apply(evaluate_correctness, axis=1)
df['clarity'] = df.apply(evaluate_clarity, axis=1)
df['style_match'] = df.apply(evaluate_style_match, axis=1)

print("✓ Evaluations applied")
df[['prompt', 'backend', 'answer', 'correctness', 'clarity', 'style_match']].head(10)
```

---

## Step 4 – Analyze Results

Compute statistics and visualize:

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Summary statistics by backend
summary = df.groupby('backend').agg({
    'correctness': 'mean',
    'clarity': 'mean',
    'style_match': 'mean',
    'latency_ms': ['mean', 'median']
}).round(2)

print("Summary by Backend:")
print(summary)
print()

# Summary by task type
task_summary = df.groupby(['backend', 'task_type']).agg({
    'correctness': 'mean',
    'clarity': 'mean'
}).round(2)

print("Summary by Task Type:")
print(task_summary)

# Visualizations
fig, axes = plt.subplots(1, 3, figsize=(15, 4))

# Correctness comparison
df.groupby('backend')['correctness'].mean().plot(kind='bar', ax=axes[0], color=['#1f77b4', '#ff7f0e'])
axes[0].set_title('Average Correctness Score')
axes[0].set_ylabel('Score (1-5)')
axes[0].set_ylim(0, 5)

# Clarity comparison
df.groupby('backend')['clarity'].mean().plot(kind='bar', ax=axes[1], color=['#1f77b4', '#ff7f0e'])
axes[1].set_title('Average Clarity Score')
axes[1].set_ylabel('Score (1-5)')
axes[1].set_ylim(0, 5)

# Latency comparison
df.groupby('backend')['latency_ms'].median().plot(kind='bar', ax=axes[2], color=['#1f77b4', '#ff7f0e'])
axes[2].set_title('Median Latency')
axes[2].set_ylabel('Milliseconds')

plt.tight_layout()
plt.show()
```

**Interpretation**:
- Which backend scored higher on correctness?
- Which was clearer?
- Which was faster?
- Were there task types where one significantly outperformed?

---

## Step 5 – Accelerator Alignment

Think ahead to production monitoring.

### Define Production Schema

```python
# This is the schema you'll use in accelerator/service/api.py

PRODUCTION_LOG_SCHEMA = {
    "timestamp": "2025-01-15T10:30:00Z",
    "request_id": "uuid",
    "question": "user's question",
    "answer": "generated answer",
    "retrieved_doc_ids": ["doc_1", "doc_2"],
    "latency_ms": 1250,
    "model": "granite-13b-instruct-v2",
    "backend": "watsonx",
    # Evaluation fields (filled by eval_small.py or user feedback)
    "correctness": None,
    "relevance": None,
    "user_feedback": None,  # "helpful", "not_helpful", etc.
    "notes": ""
}
```

**What goes where**:
- `service/api.py` logs this structure
- `tools/eval_small.py` reads logs and computes metrics
- `Analyze_Log_and_Feedback.ipynb` visualizes trends

---

## Step 6 – Save Results

```python
# Save to CSV
df.to_csv('micro_evaluation_results.csv', index=False)
print("✓ Results saved to micro_evaluation_results.csv")

# Also save summary
with open('micro_evaluation_summary.txt', 'w') as f:
    f.write("Micro-Evaluation Summary\n")
    f.write("="*60 + "\n\n")
    f.write(str(summary))
    f.write("\n\n")
    f.write("Task Type Breakdown:\n")
    f.write(str(task_summary))

print("✓ Summary saved to micro_evaluation_summary.txt")
```

---

## Wrap-Up Questions

1. **What patterns did you observe?**
   - Were certain task types harder for one backend?
   - Latency vs. quality trade-offs?

2. **What would you improve?**
   - More test cases?
   - Better evaluation metrics?
   - Automated correctness checking?

3. **How does this connect to production?**
   - This mini-framework → `eval_small.py`
   - Manual rubrics → automated metrics
   - 10 prompts → 1000+ prompts

---

## Checkpoint

Before moving on:
- ✅ DataFrame with prompts, outputs, and ratings created
- ✅ Basic summary statistics computed
- ✅ Visualizations generated
- ✅ Draft schema for production logs defined

If all boxes are checked, congratulations! You've completed Day 1 labs.

---

## Next Steps

**Day 2**: We'll add retrieval (RAG) to the mix and integrate with the accelerator.

**Optional homework**: 
- Expand test set to 20-30 prompts
- Implement more sophisticated evaluation metrics
- Try different models (if available)
