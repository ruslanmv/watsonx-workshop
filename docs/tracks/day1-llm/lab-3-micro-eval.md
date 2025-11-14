# 📊 Lab 1.3 – Micro-Evaluation Exercise

Build a systematic evaluation framework

**Duration**: 60 minutes | **Difficulty**: Intermediate

::: notes
This is the capstone lab for Day 1. Students will create an evaluation system that's production-ready in miniature form.
:::

---

## 🎯 Lab Overview {data-background-color="#0f172a"}

<span class="fragment">🔹 Programmatically **collect and evaluate** model outputs</span>

<span class="fragment">🔹 Design and apply a **rating rubric**</span>

<span class="fragment">🔹 Store results in **structured format** (DataFrame)</span>

<span class="fragment">🔹 Lay groundwork for **production evaluation**</span>

::: notes
By the end, students will have a working evaluation framework they can extend for production use.
:::

---

## ✅ Prerequisites

<span class="fragment">✅ Labs 1.1 and 1.2 completed</span>

<span class="fragment">✅ Basic Python & pandas familiarity</span>

<span class="fragment">✅ Understanding of evaluation principles from section 1.3</span>

::: notes
This lab builds on everything learned so far. Make sure students are caught up before starting.
:::

---

## 📋 Lab Roadmap

**Step 1**: Define test set (10 min)

**Step 2**: Collect outputs from both backends (15 min)

**Step 3**: Apply rating rubric (20 min)

**Step 4**: Analyze results (10 min)

**Step 5**: Plan accelerator alignment (5 min)

::: notes
Clear roadmap helps students pace themselves. They should complete Step 1 in about 10 minutes.
:::

---

## 📝 Step 1: Define a Test Set {data-transition="zoom"}

Create diverse test prompts

::: notes
A good test set covers different task types. This ensures comprehensive evaluation.
:::

---

## 🗂️ Create evaluation_test_set.py

```python {data-line-numbers="1-15"}
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
    # More test cases...
]
```

::: notes
This structure is extensible. Each test case includes metadata for evaluation.
:::

---

## 📊 Test Set Diversity

Include varied task types:

<span class="fragment">🔹 **Summarization**: Condensing text</span>

<span class="fragment">🔹 **Extraction**: Pulling out entities</span>

<span class="fragment">🔹 **Style transfer**: Rewriting tone</span>

<span class="fragment">🔹 **Q&A**: Factual questions</span>

<span class="fragment">🔹 **Reasoning**: Math or logic problems</span>

::: notes
Diversity ensures you're testing the full range of LLM capabilities, not just one narrow skill.
:::

---

## 📝 Additional Test Cases

```python {data-line-numbers="1-40"}
TEST_PROMPTS = [
    # Previous cases...
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

::: notes
10 diverse test cases. This is enough for meaningful evaluation without overwhelming computation.
:::

---

## 🔬 Step 2: Collect Outputs {data-background-color="#1e293b"}

Run all prompts through both models

::: notes
Systematic data collection is the foundation of evaluation. Automate this process.
:::

---

## 📁 Create micro_evaluation.ipynb

```python {data-line-numbers="1-16"}
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

# Setup watsonx.ai (same as Lab 1.1)
load_dotenv()
# ... credentials setup ...
```

::: notes
Students should copy setup code from Lab 1.1. No need to retype everything.
:::

---

## 🤖 Data Collection Function

```python {data-line-numbers="1-26|28-45"}
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
            watsonx_answer = watsonx_model.generate_text(
                prompt=prompt, params=params
            )
            watsonx_time = time.time() - start
        except Exception as e:
            watsonx_answer = f"ERROR: {str(e)}"
            watsonx_time = 0

        # Store both results
        # ... (next slide)
```

::: notes
Error handling is important. Don't let one failed request stop the entire evaluation.
:::

---

## 💾 Store Results

```python {data-line-numbers="1-35"}
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
            # Evaluation fields (to be filled in Step 3)
            "correctness": None,
            "clarity": None,
            "style_match": None,
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
            "notes": ""
        })

        time.sleep(0.5)  # Rate limiting

    return results
```

::: notes
Rate limiting is courteous and prevents hitting API limits. 0.5 seconds between requests is reasonable.
:::

---

## 🏃 Run Collection

```python {data-line-numbers="1-6"}
# Collect all responses
results = collect_responses()

# Create DataFrame
df = pd.DataFrame(results)
print(f"\n✓ Collected {len(df)} responses ({len(df)//2} prompts × 2 backends)")
df.head()
```

<span class="fragment">**This will take a few minutes**</span>

::: notes
Students should run this and watch progress. It's satisfying to see the data collection happen in real-time.
:::

---

## 📏 Step 3: Apply Rating Rubric {data-background-color="#0f172a" data-transition="zoom"}

Systematically evaluate outputs

::: notes
This is where quantitative evaluation happens. Code can approximate human judgment.
:::

---

## ✅ Evaluation Function: Correctness

```python {data-line-numbers="1-23"}
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
        found = sum(1 for kw in row['expected_keywords']
                   if kw.lower() in answer)
        if found == len(row['expected_keywords']):
            return 5
        elif found > len(row['expected_keywords']) / 2:
            return 4
        elif found > 0:
            return 3
        else:
            return 2

    return 3  # Default (manual review needed)
```

::: notes
This is automated evaluation. It's not perfect but it's consistent and scalable.
:::

---

## 💬 Evaluation Function: Clarity

```python {data-line-numbers="1-17"}
def evaluate_clarity(row: pd.Series) -> int:
    """
    Evaluate clarity (1-5 scale).
    5 = Crystal clear, 1 = Confusing/incoherent
    """
    answer = row['answer']

    # Simple heuristics
    if len(answer) < 10:
        return 2  # Too short
    if "ERROR" in answer:
        return 1

    # Check for coherent sentence structure
    if answer.strip().endswith(('.', '!', '?')):
        return 5
    else:
        return 4
```

::: notes
Clarity is harder to measure automatically. These heuristics are basic but informative.
:::

---

## 🎨 Evaluation Function: Style Match

```python {data-line-numbers="1-21"}
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
```

::: notes
Format checking can be automated. This catches models that ignore format instructions.
:::

---

## 🔄 Apply All Evaluations

```python {data-line-numbers="1-6"}
# Apply evaluations
df['correctness'] = df.apply(evaluate_correctness, axis=1)
df['clarity'] = df.apply(evaluate_clarity, axis=1)
df['style_match'] = df.apply(evaluate_style_match, axis=1)

print("✓ Evaluations applied")
df[['prompt', 'backend', 'answer', 'correctness', 'clarity', 'style_match']].head(10)
```

::: notes
Pandas apply() runs the evaluation functions on every row. This is where the magic happens.
:::

---

## 📊 Step 4: Analyze Results {data-background-color="#1e293b"}

Extract insights from the data

::: notes
Data without analysis is just numbers. Let's turn it into insights.
:::

---

## 📈 Summary Statistics

```python {data-line-numbers="1-17"}
import matplotlib.pyplot as plt
import seaborn as sns

# Summary by backend
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
```

::: notes
These aggregations reveal overall patterns. Which backend performed better? Were certain task types harder?
:::

---

## 📊 Visualizations

```python {data-line-numbers="1-20"}
fig, axes = plt.subplots(1, 3, figsize=(15, 4))

# Correctness comparison
df.groupby('backend')['correctness'].mean().plot(
    kind='bar', ax=axes[0], color=['#1f77b4', '#ff7f0e']
)
axes[0].set_title('Average Correctness Score')
axes[0].set_ylabel('Score (1-5)')
axes[0].set_ylim(0, 5)

# Clarity comparison
df.groupby('backend')['clarity'].mean().plot(
    kind='bar', ax=axes[1], color=['#1f77b4', '#ff7f0e']
)
axes[1].set_title('Average Clarity Score')
axes[1].set_ylabel('Score (1-5)')
axes[1].set_ylim(0, 5)

# Latency comparison
df.groupby('backend')['latency_ms'].median().plot(
    kind='bar', ax=axes[2], color=['#1f77b4', '#ff7f0e']
)
axes[2].set_title('Median Latency')
axes[2].set_ylabel('Milliseconds')

plt.tight_layout()
plt.show()
```

::: notes
Visualizations make patterns obvious. Share these charts with stakeholders to communicate findings.
:::

---

## 🤔 Interpretation Questions

<span class="fragment">❓ Which backend scored higher on **correctness**?</span>

<span class="fragment">❓ Which was **clearer**?</span>

<span class="fragment">❓ Which was **faster**?</span>

<span class="fragment">❓ Were there task types where one **significantly outperformed**?</span>

::: notes
Facilitate discussion. Students should articulate what they see in the data and what it means.
:::

---

## 🏗️ Step 5: Accelerator Alignment {data-background-color="#0f172a"}

Plan for production monitoring

::: notes
Connect this lab to production systems. Show students the path forward.
:::

---

## 📋 Production Log Schema

```python {data-line-numbers="1-14"}
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
    # Evaluation fields
    "correctness": None,
    "relevance": None,
    "user_feedback": None,
    "notes": ""
}
```

::: notes
Your micro-framework uses the same structure. Scaling is just a matter of automation and volume.
:::

---

## 🗺️ Evaluation Flow

**Development** (Today):
<span class="fragment">Manual test set → Manual evaluation → Insights</span>

**Production** (Day 2-3):
<span class="fragment">Automated test set → Automated evaluation → Continuous monitoring</span>

::: notes
Same principles, different scale. Students are learning production patterns in a beginner-friendly way.
:::

---

## 💾 Step 6: Save Results

```python {data-line-numbers="1-13"}
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

::: notes
Always save results. They're valuable for future reference and for reproducibility.
:::

---

## 💭 Wrap-Up Questions {data-transition="zoom"}

Reflection and learning consolidation

::: notes
End with reflection. This cements the learning.
:::

---

## 🤔 Reflection Questions

<span class="fragment">❓ What **patterns** did you observe?</span>

<span class="fragment">❓ Were certain task types **harder** for one backend?</span>

<span class="fragment">❓ **Latency vs. quality** trade-offs?</span>

<span class="fragment">❓ What would you **improve** in your evaluation?</span>

::: notes
Encourage honest discussion. There are no wrong answers. This is about building evaluation intuition.
:::

---

## 💡 Common Insights

<span class="fragment">✅ Larger models (Granite 13B) often more accurate but slower</span>

<span class="fragment">✅ Smaller models (Qwen 0.5B) faster but less consistent</span>

<span class="fragment">✅ Format adherence varies significantly by model</span>

<span class="fragment">✅ Latency vs. quality is a real trade-off</span>

::: notes
These are typical findings. Students may observe different patterns depending on their test cases.
:::

---

## 🔮 Connection to Production

**This mini-framework →**

<span class="fragment">📊 `tools/eval_small.py` (automated evaluation)</span>

<span class="fragment">📈 `Analyze_Log_and_Feedback.ipynb` (production analytics)</span>

<span class="fragment">🎯 Continuous monitoring dashboards</span>

::: notes
Students have built a production-ready pattern at a small scale. Scaling it is just engineering, not new concepts.
:::

---

## 🚀 Next Steps

**Day 2**: Add retrieval (RAG) and evaluate the full pipeline

**Homework** (Optional):
<span class="fragment">📈 Expand test set to 20-30 prompts</span>
<span class="fragment">🔬 Implement more sophisticated metrics</span>
<span class="fragment">🎨 Try different models (if available)</span>

::: notes
Optional homework for eager students. Don't make it mandatory—today was already full.
:::

---

## ✅ Checkpoint {data-background-color="#1e293b"}

Before finishing:

<span class="fragment">✅ DataFrame with prompts, outputs, and ratings created</span>

<span class="fragment">✅ Basic summary statistics computed</span>

<span class="fragment">✅ Visualizations generated</span>

<span class="fragment">✅ Draft schema for production logs defined</span>

::: notes
Make sure everyone has completed these deliverables. They're proof of learning.
:::

---

## 🎉 Lab 1.3 Complete!

<span class="fragment">✅ Built a **micro-evaluation framework**</span>

<span class="fragment">✅ Applied **systematic evaluation**</span>

<span class="fragment">✅ Generated **insights from data**</span>

<span class="fragment">✅ Planned for **production**</span>

::: notes
Congratulations! This is sophisticated work. Students should feel proud of what they've accomplished.
:::

---

## 🎓 Day 1 Complete! {data-background-color="#0f172a" data-transition="zoom"}

You've mastered:

<span class="fragment">🧠 **LLM fundamentals** and key concepts</span>

<span class="fragment">🎨 **Prompt engineering** patterns and templates</span>

<span class="fragment">📊 **Evaluation** frameworks and metrics</span>

<span class="fragment">🏗️ **Accelerator** integration points</span>

::: notes
Day 1 complete! This is a solid foundation for Day 2's RAG topics. Celebrate student success!
:::

---

## 🔜 Preview: Day 2

Tomorrow we'll add:

<span class="fragment">🔍 **Retrieval** (RAG)</span>

<span class="fragment">🗄️ **Vector databases** (Elasticsearch, Chroma)</span>

<span class="fragment">🎯 **Embeddings**</span>

<span class="fragment">🏗️ **Accelerator integration**</span>

::: notes
Give students a sense of what's coming. They should be excited, not anxious.
:::

---

## 🙏 Great Work Today!

See you tomorrow for Day 2!

::: notes
End on a positive note. Thank students for their engagement. Remind them to rest up for Day 2.
:::