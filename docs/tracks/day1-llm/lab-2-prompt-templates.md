# 🎨 Lab 1.2 – Building Production-Ready Prompt Templates

**Master the art of creating reusable, maintainable prompt patterns for enterprise AI applications**

**Duration**: 60-75 minutes | **Difficulty**: Intermediate | **Prerequisites**: Lab 1.1 completed

::: notes
This lab transforms theoretical knowledge into practical skills. Students will create actual templates they can reuse in production systems. This is where the magic of prompt engineering becomes systematic and scalable.

Key focus: Students should leave this lab with working code they can adapt for their own projects. Emphasize that prompt templates are one of the most valuable deliverables from any AI project—they embody domain knowledge and best practices.
:::

---

## 🎓 What You'll Learn in This Lab {data-background-color="#0f172a"}

By the end of this hands-on session, you will be able to:

<span class="fragment">📌 **Design reusable prompt templates** that work across different backends (Ollama, watsonx, OpenAI, etc.)</span>

<span class="fragment">📌 **Implement three essential patterns**: summarization, style transfer, and context-based Q&A</span>

<span class="fragment">📌 **Compare outputs systematically** across local and cloud environments using structured evaluation</span>

<span class="fragment">📌 **Architect production-ready code** with proper separation of concerns and maintainability</span>

<span class="fragment">📌 **Plan integration strategies** for incorporating templates into larger RAG applications</span>

::: notes
These learning objectives map directly to real-world AI engineering responsibilities. Students who master this lab can:
- Build template libraries for their organizations
- Create consistent AI experiences across products
- Maintain and version control prompt engineering knowledge
- Switch between LLM providers without rewriting application logic

Emphasize that prompt templates are IP—they represent valuable domain knowledge that should be version-controlled and shared across teams.
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

## 🎉 Congratulations! Lab 1.2 Complete! {data-background-color="#0f172a"}

**You've mastered production-ready prompt template engineering!**

<span class="fragment">✅ **Built three core template patterns** that work across multiple LLM backends</span>

<span class="fragment">✅ **Implemented systematic comparison** framework for evaluating outputs</span>

<span class="fragment">✅ **Analyzed quality-performance trade-offs** between local and cloud environments</span>

<span class="fragment">✅ **Designed production architecture** for template management and integration</span>

<span class="fragment">✅ **Created reusable code assets** you can apply to real-world projects immediately</span>

::: notes
Excellent work! Prompt templates are one of the most valuable and reusable components of any LLM application. The templates students built today are production-ready and can be adapted for countless use cases.

Students have now created:
- Reusable functions with clear interfaces
- Backend-agnostic design patterns
- Systematic evaluation methodology
- Foundation for RAG integration

These are resume-worthy skills!
:::

---

## 📊 What You've Accomplished {data-background-color="#1e293b"}

**Professional skills you can apply immediately:**

<span class="fragment">🎯 **Template Engineering**: Design prompts as reusable, parameterized functions instead of hardcoded strings</span>

<span class="fragment">🎯 **Backend Abstraction**: Write code that works across Ollama, watsonx, OpenAI, and other providers</span>

<span class="fragment">🎯 **Systematic Evaluation**: Compare LLM outputs using structured data and metrics</span>

<span class="fragment">🎯 **Production Architecture**: Separate template definitions from application logic for maintainability</span>

<span class="fragment">🎯 **Data-Driven Decisions**: Use empirical testing to choose the right LLM for each use case</span>

::: notes
These aren't just lab exercises—they're the exact patterns used by AI engineering teams at leading companies:
- Template libraries in version control
- A/B testing different providers
- Centralized prompt management
- Systematic quality evaluation

Students can now confidently discuss these topics in job interviews and implement them in their organizations.
:::

---

## 💡 Key Insights from This Lab

**Critical lessons for production LLM applications:**

<span class="fragment">🔑 **Templates are code assets** – Version control them, test them, document them like any other critical code</span>

<span class="fragment">🔑 **Backend agnosticism is valuable** – Don't lock yourself into a single provider; abstract the interface</span>

<span class="fragment">🔑 **Quality varies by task** – No single LLM is best for everything; test systematically for your use cases</span>

<span class="fragment">🔑 **Prompts embody domain knowledge** – Your templates represent your understanding of the problem domain</span>

<span class="fragment">🔑 **Evaluation must be systematic** – Anecdotes aren't enough; measure performance consistently</span>

::: notes
These insights come from hard-won experience in production AI systems. Share war stories if you have them:
- A critical product launch where template quality mattered
- A case where switching providers required minimal code changes due to good abstractions
- An example of how systematic evaluation caught a quality regression

Make these lessons stick by connecting them to real-world consequences.
:::

---

## 🔗 Navigation & Next Steps {data-background-color="#0f172a"}

**Where to go from here:**

### 🏠 [Return to Workshop Home](../../portal.md)
Access all workshop materials, labs, and resources

### 📚 [Day 1 Overview](./README.md)
Review Day 1 schedule and learning objectives

### ⬅️ [Previous: Lab 1.1 – Quickstart](./lab-1-quickstart-two-envs.md)
Review basics of working with Ollama and watsonx.ai

### ▶️ [Next: Lab 1.3 – Micro-Evaluation](./lab-3-micro-eval.md)
Build a systematic evaluation framework for LLM outputs

### 🔄 [Alternative: Prompt Patterns Theory](./prompt-patterns-theory.md)
Deep dive into advanced prompt engineering patterns

::: notes
**Instructor guidance:**
- Take a 5-10 minute break before Lab 1.3
- Check in with students about their comparison results
- Encourage sharing interesting findings from their experiments
- Remind everyone to save their notebooks and CSV results

**If students want to go deeper:**
- Add more template types (classification, extraction, translation)
- Experiment with system prompts and few-shot examples
- Try chain-of-thought reasoning templates
- Build a template library module they can import

**Next lab preview:**
Lab 1.3 introduces systematic evaluation frameworks—you'll learn to measure quality, not just observe it subjectively. This is crucial for production AI!
:::

---

## 📖 Additional Resources

**Deepen your prompt engineering skills:**

- 📘 **[Prompt Engineering Guide](https://www.promptingguide.ai/)** – Comprehensive guide to advanced techniques
- 📘 **[OpenAI Prompt Engineering Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)** – Industry-standard patterns
- 📘 **[Anthropic Prompt Library](https://docs.anthropic.com/claude/prompt-library)** – Real-world prompt examples
- 📘 **[LangChain Prompt Templates](https://python.langchain.com/docs/modules/model_io/prompts/prompt_templates/)** – Framework integration patterns

**Template Design Patterns:**
- 🎨 [Few-Shot Learning](https://www.promptingguide.ai/techniques/fewshot) – Improve accuracy with examples
- 🎨 [Chain-of-Thought](https://www.promptingguide.ai/techniques/cot) – Enhance reasoning capabilities
- 🎨 [ReAct Pattern](https://www.promptingguide.ai/techniques/react) – Combine reasoning and actions

**Workshop Materials:**
- 🔧 [Lab 1.1 – Quickstart](./lab-1-quickstart-two-envs.md) – Review the basics
- 🔧 Complete Notebooks – Full working examples are in the `labs-src/` directory in the workshop root
- 🔧 [Day 1 Theory Slides](./prompt-patterns-theory.md) – Theoretical foundations

::: notes
Share these resources in the workshop chat/LMS. Students who enjoyed this lab will appreciate the deep dives into advanced prompt engineering.

The Anthropic Prompt Library is especially valuable—it's full of production-tested prompts for common tasks.
:::

---

## 💾 Save Your Work!

**Before moving on, make sure you've saved:**

<span class="fragment">📁 **Notebook files** – `prompt_patterns_ollama.ipynb` and `prompt_patterns_watsonx.ipynb`</span>

<span class="fragment">📁 **Comparison results** – `lab1_2_comparison_results.csv`</span>

<span class="fragment">📁 **Your template functions** – Copy to a reusable module for future projects</span>

<span class="fragment">📁 **Notes on integration** – Document your architectural decisions</span>

**Pro tip:** Create a `my_prompt_library.py` file with your best templates for reuse across projects!

::: notes
Encourage students to build their personal prompt library. Many successful AI engineers maintain a collection of tested templates they can quickly adapt.

Suggest creating a GitHub repo for their prompt library—it's great portfolio material and incredibly useful for future projects.
:::

---

## 🙏 Thank You!

**Questions? Feedback? Insights to share?**

Feel free to:
- Discuss your comparison results with classmates
- Share interesting findings in the workshop chat
- Experiment with additional template variations
- Build on these patterns for your own projects

**Remember:** Great prompts are discovered through iteration. Keep experimenting! 🚀

<div style="margin-top: 40px; text-align: center;">
<a href="../../README.md" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Back to Workshop Home</a>
<a href="./lab-3-micro-eval.md" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">▶️ Next Lab: Micro-Evaluation</a>
</div>

::: notes
End on an encouraging note. Students have built something valuable today—templates they can use in real projects.

**For instructors:**
Before dismissing to break, ask:
- "What were your most interesting comparison findings?"
- "Which backend performed better for which tasks?"
- "Anyone discover a surprising result?"
- "Questions before we move to evaluation?"

Collect feedback for improving the lab in future workshops.
:::