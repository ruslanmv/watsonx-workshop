# 🎨 Lab 1.2 – Prompt Templates

Build reusable prompt patterns across both environments

**Duration**: 60 minutes | **Difficulty**: Intermediate

::: notes
This lab puts theory into practice. Students will create actual templates they can reuse in production.
:::

---

## 🎯 Lab Overview {data-background-color="#0f172a"}

<span class="fragment">🔹 Create **reusable prompt templates** in Python</span>

<span class="fragment">🔹 Implement templates in **both Ollama and watsonx**</span>

<span class="fragment">🔹 Compare outputs **systematically**</span>

<span class="fragment">🔹 Design prompts for the **accelerator's RAG system**</span>

::: notes
By the end, students will have working templates and understand how to compare LLM outputs across backends.
:::

---

## ✅ Prerequisites

<span class="fragment">✅ Lab 1.1 completed</span>

<span class="fragment">✅ Understanding of prompt patterns from theory section 1.2</span>

<span class="fragment">✅ Both environments working</span>

::: notes
Make sure everyone completed Lab 1.1 before proceeding. The skills build on each other.
:::

---

## 📋 Lab Structure

**Part A**: Ollama Templates (20 min)

**Part B**: watsonx Templates (20 min)

**Part C**: Comparative Experiments (15 min)

**Part D**: Accelerator Integration Planning (5 min)

::: notes
Clear structure helps students pace themselves. They should aim to complete Part A in 20 minutes.
:::

---

## 🚀 Part A: Ollama Templates {data-transition="zoom"}

Build three core templates

::: notes
Start with Ollama since it's simpler. Success here builds confidence for watsonx.
:::

---

## 📝 Template 1: Summarization

```python {data-line-numbers="1-16"}
import ollama

def summarize_ollama(text: str, num_sentences: int = 3) -> str:
    """Summarize text using Ollama."""
    template = f"""Summarize the following text in {num_sentences} sentences.
Focus on the main points and key takeaways.

Text:
{text}

Summary:"""

    response = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": template}]
    )

    return response["message"]["content"]
```

::: notes
This is a function-based template. It's reusable and testable. The num_sentences parameter makes it flexible.
:::

---

## 🧪 Test Summarization Template

```python {data-line-numbers="1-9"}
test_text = """
Machine learning is a subset of artificial intelligence that
enables systems to learn from data without explicit programming.
It uses algorithms to identify patterns and make predictions.
Applications include image recognition, natural language processing,
and recommendation systems.
"""

summary = summarize_ollama(test_text, num_sentences=2)
print(summary)
```

::: notes
Have students run this test. The output should be roughly 2 sentences summarizing ML.
:::

---

## ✍️ Template 2: Style Transfer

```python {data-line-numbers="1-17"}
def rewrite_style_ollama(text: str, target_tone: str) -> str:
    """Rewrite text in a different style using Ollama."""
    template = f"""Rewrite the following text in a {target_tone} tone:

Original text:
{text}

Rewritten text:"""

    response = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": template}]
    )

    return response["message"]["content"]
```

::: notes
Style transfer is powerful for content adaptation. Same info, different audiences.
:::

---

## 🧪 Test Style Transfer

```python {data-line-numbers="1-7"}
original = "Hey team, the API is down. Can someone check it ASAP?"

formal = rewrite_style_ollama(original, "formal business")
print("Formal:", formal)

casual = rewrite_style_ollama(original, "very casual and friendly")
print("Casual:", casual)
```

::: notes
Students should see dramatic tone changes. The formal version should sound professional. The casual version should be very relaxed.
:::

---

## 🤔 Template 3: Q&A with Context

```python {data-line-numbers="1-20"}
def qa_with_context_ollama(context: str, question: str) -> str:
    """Answer a question based on provided context using Ollama."""
    template = f"""Based on the following information, answer the question.
If the information doesn't contain the answer, say "I don't have enough information."

Information:
{context}

Question: {question}

Answer:"""

    response = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": template}]
    )

    return response["message"]["content"]
```

::: notes
This is a mini-RAG template. You're manually providing context now. Tomorrow, you'll retrieve it automatically.
:::

---

## 🧪 Test Q&A Template

```python {data-line-numbers="1-7"}
context = """
watsonx.ai was released by IBM in 2023 as an enterprise AI platform.
It provides access to IBM Granite models and integrates with IBM Cloud services.
"""

question = "When was watsonx.ai released?"

answer = qa_with_context_ollama(context, question)
print(answer)
```

::: notes
The answer should be "2023" or similar. If the model hallucinates, discuss why context matters and how RAG helps.
:::

---

## ✅ Part A Checkpoint

You should now have:

<span class="fragment">✅ `summarize_ollama()` function</span>

<span class="fragment">✅ `rewrite_style_ollama()` function</span>

<span class="fragment">✅ `qa_with_context_ollama()` function</span>

<span class="fragment">✅ Test cases for each</span>

::: notes
Pause here. Make sure everyone has completed Part A before moving to Part B.
:::

---

## ☁️ Part B: watsonx Templates {data-background-color="#1e293b"}

Same templates, different backend

::: notes
Now implement the same templates for watsonx. This teaches students how to write backend-agnostic code.
:::

---

## 📝 Setup watsonx Connection

```python {data-line-numbers="1-14"}
import os
from dotenv import load_dotenv
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

load_dotenv()

api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

credentials = Credentials(url=url, api_key=api_key)

model = ModelInference(
    model_id="ibm/granite-13b-instruct-v2",
    credentials=credentials,
    project_id=project_id,
)
```

::: notes
This setup is verbose but it's standard boilerplate for watsonx. Copy-paste is fine here.
:::

---

## 📝 Template 1: Summarization (watsonx)

```python {data-line-numbers="1-16"}
def summarize_watsonx(text: str, num_sentences: int = 3) -> str:
    """Summarize text using watsonx."""
    template = f"""Summarize the following text in {num_sentences} sentences.
Focus on the main points and key takeaways.

Text:
{text}

Summary:"""

    params = {
        GenParams.DECODING_METHOD: "greedy",
        GenParams.MAX_NEW_TOKENS: 200,
    }

    return model.generate_text(prompt=template, params=params)
```

::: notes
Notice: the template string is identical to Ollama. Only the LLM call syntax changes. This is good design.
:::

---

## ✍️ Template 2: Style Transfer (watsonx)

```python {data-line-numbers="1-17"}
def rewrite_style_watsonx(text: str, target_tone: str) -> str:
    """Rewrite text in a different style using watsonx."""
    template = f"""Rewrite the following text in a {target_tone} tone:

Original text:
{text}

Rewritten text:"""

    params = {
        GenParams.DECODING_METHOD: "greedy",
        GenParams.MAX_NEW_TOKENS: 200,
    }

    return model.generate_text(prompt=template, params=params)
```

::: notes
Same pattern. Template is identical, only the call changes.
:::

---

## 🤔 Template 3: Q&A with Context (watsonx)

```python {data-line-numbers="1-18"}
def qa_with_context_watsonx(context: str, question: str) -> str:
    """Answer a question based on provided context using watsonx."""
    template = f"""Based on the following information, answer the question.
If the information doesn't contain the answer, say "I don't have enough information."

Information:
{context}

Question: {question}

Answer:"""

    params = {
        GenParams.DECODING_METHOD: "greedy",
        GenParams.MAX_NEW_TOKENS: 150,
    }

    return model.generate_text(prompt=template, params=params)
```

::: notes
Complete the trilogy. Same template, different backend.
:::

---

## ✅ Part B Checkpoint

You should now have:

<span class="fragment">✅ `summarize_watsonx()` function</span>

<span class="fragment">✅ `rewrite_style_watsonx()` function</span>

<span class="fragment">✅ `qa_with_context_watsonx()` function</span>

<span class="fragment">✅ Test cases for each</span>

::: notes
Students now have parallel implementations. This sets up Part C perfectly.
:::

---

## 📊 Part C: Comparative Experiments {data-background-color="#0f172a" data-transition="zoom"}

Run same prompts, compare results

::: notes
This is where the learning gets interesting. Side-by-side comparison reveals strengths and weaknesses.
:::

---

## 🔬 Experiment Setup

```python {data-line-numbers="1-17"}
import pandas as pd
import time

# Test data
test_cases = [
    {
        "task": "summarize",
        "text": "Machine learning is a subset of AI...",
        "params": {"num_sentences": 2}
    },
    {
        "task": "style_transfer",
        "text": "Hey, the API is down!",
        "params": {"target_tone": "formal business"}
    },
    # Add more test cases
]

results = []
```

::: notes
Structured test cases enable systematic comparison. This is evaluation thinking applied to prompt engineering.
:::

---

## 🔬 Run Comparison

```python {data-line-numbers="1-28"}
for test in test_cases:
    # Ollama
    start = time.time()
    if test["task"] == "summarize":
        ollama_output = summarize_ollama(test["text"], **test["params"])
    elif test["task"] == "style_transfer":
        ollama_output = rewrite_style_ollama(test["text"], **test["params"])
    ollama_time = time.time() - start

    # watsonx
    start = time.time()
    if test["task"] == "summarize":
        watsonx_output = summarize_watsonx(test["text"], **test["params"])
    elif test["task"] == "style_transfer":
        watsonx_output = rewrite_style_watsonx(test["text"], **test["params"])
    watsonx_time = time.time() - start

    results.append({
        "task": test["task"],
        "input": test["text"][:50] + "...",
        "ollama_output": ollama_output,
        "ollama_time": ollama_time,
        "watsonx_output": watsonx_output,
        "watsonx_time": watsonx_time,
    })

df = pd.DataFrame(results)
df
```

::: notes
This code systematically compares both backends. Students will see real differences in speed and quality.
:::

---

## 📊 Analysis Questions

<span class="fragment">❓ Which backend was faster?</span>

<span class="fragment">❓ Which produced higher quality outputs?</span>

<span class="fragment">❓ Were there tasks where one clearly outperformed?</span>

<span class="fragment">❓ How consistent were the outputs?</span>

::: notes
Facilitate discussion. Insights will vary based on test cases. The process of systematic comparison is what matters most.
:::

---

## 💾 Save Results

```python {data-line-numbers="1-5"}
# Save for later reference
df.to_csv('lab1_2_comparison_results.csv', index=False)

print(f"✓ Saved {len(df)} comparison results")
print(f"Average Ollama time: {df['ollama_time'].mean():.2f}s")
print(f"Average watsonx time: {df['watsonx_time'].mean():.2f}s")
```

::: notes
Saving results lets students refer back later. It's also good practice for reproducibility.
:::

---

## 🏗️ Part D: Accelerator Integration {data-background-color="#1e293b"}

Planning for production

::: notes
This quick planning exercise helps students think about production deployment.
:::

---

## 📝 Design Exercise

**Question**: How would you integrate these templates into `accelerator/rag/prompt.py`?

<span class="fragment">💭 Discuss with a neighbor (2 minutes)</span>

::: notes
Give students time to think. This is about architectural thinking, not coding.
:::

---

## 💡 Suggested Design

```python {data-line-numbers="1-15"}
# accelerator/rag/prompt.py

SUMMARIZE_TEMPLATE = """Summarize the following text in {num_sentences} sentences.
Focus on the main points and key takeaways.

Text:
{text}

Summary:"""

QA_TEMPLATE = """Based on the following information, answer the question.
If the information doesn't contain the answer, say "I don't have enough information."

Information:
{context}

Question: {question}

Answer:"""

# More templates...
```

::: notes
Centralize templates as constants. They're configuration, not code. Easy to update and version control.
:::

---

## 🔌 Integration in pipeline.py

```python {data-line-numbers="1-10"}
# accelerator/rag/pipeline.py
from .prompt import QA_TEMPLATE

def answer_question(question: str, context: str) -> str:
    # Use the template
    prompt = QA_TEMPLATE.format(context=context, question=question)

    # Call LLM (backend-agnostic)
    response = llm.generate(prompt)

    return response
```

::: notes
Clean separation: templates in prompt.py, usage in pipeline.py. This is maintainable architecture.
:::

---

## ✅ Lab 1.2 Complete! {data-background-color="#0f172a"}

You've accomplished:

<span class="fragment">✅ Built **3 reusable templates** in both environments</span>

<span class="fragment">✅ Ran **systematic comparisons**</span>

<span class="fragment">✅ Analyzed **quality and performance trade-offs**</span>

<span class="fragment">✅ Planned **accelerator integration**</span>

::: notes
Excellent work! These templates are production-ready patterns students can use immediately.
:::

---

## 📦 Deliverables

You should have:

<span class="fragment">✅ `prompt_patterns_ollama.ipynb` - working templates</span>

<span class="fragment">✅ `prompt_patterns_watsonx.ipynb` - working templates</span>

<span class="fragment">✅ `lab1_2_comparison_results.csv` - comparison data</span>

<span class="fragment">✅ Notes on accelerator integration strategy</span>

::: notes
Make sure students save their work. These notebooks will be useful references.
:::

---

## 💡 Key Takeaways

<span class="fragment">🔑 **Templates enable reusability** and consistency</span>

<span class="fragment">🔑 **Backend-agnostic design** makes switching easy</span>

<span class="fragment">🔑 **Systematic comparison** reveals trade-offs</span>

<span class="fragment">🔑 **Production patterns** apply to real systems</span>

::: notes
These aren't just lab exercises—they're real skills for production LLM systems.
:::

---

## 🚀 Next: Lab 1.3 – Micro-Evaluation

Build a systematic evaluation framework

::: notes
Take a short break (5-10 minutes), then proceed to Lab 1.3 to learn how to evaluate LLM outputs systematically.
:::