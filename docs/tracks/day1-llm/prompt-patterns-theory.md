# 🎨 Prompt Patterns & Templates

Understanding effective prompts is crucial for reliable, high-quality outputs

::: notes
Welcome to the prompt engineering module. This is where art meets science. We'll teach you proven patterns that work across different models and tasks.
:::

---

## 🎯 Learning Objectives {data-background-color="#0f172a"}

By the end of this module, you will:

<span class="fragment">✅ Recognize common prompt patterns and when to use them</span>

<span class="fragment">✅ Understand why structure matters in prompt engineering</span>

<span class="fragment">✅ Know how to create reusable prompt templates</span>

<span class="fragment">✅ See how the accelerator uses prompts in production</span>

::: notes
Prompt engineering is a skill that improves with practice. Today you'll learn the patterns; in the labs, you'll apply them.
:::

---

## 📋 Core Prompt Patterns {data-transition="zoom"}

Five fundamental patterns you'll use daily

::: notes
These patterns are battle-tested. They work across different models and use cases. Master these five and you'll handle 90% of scenarios.
:::

---

## 1️⃣ Instruction Prompts

The simplest pattern: **give the model a clear instruction**

```
[Instruction]
```

::: notes
Start simple. Many tasks only need a clear instruction. Don't over-engineer when simplicity works.
:::

---

## 📝 Instruction Examples

```
Summarize this text in 3 sentences.

Extract all email addresses from the following document.

Translate this paragraph to French.
```

<span class="fragment">**Best for**: Simple, well-defined tasks</span>

::: notes
Notice the pattern: action verb + specification. "Summarize in 3 sentences" is better than "Summarize this text."
:::

---

## 💡 Instruction Prompt Tips

<span class="fragment">✅ Be **specific and direct**</span>

<span class="fragment">✅ Use **action verbs** (summarize, extract, translate, list)</span>

<span class="fragment">✅ **Specify output format** if needed</span>

::: notes
Vague instructions lead to vague outputs. "Tell me about AI" is too broad. "Explain the difference between supervised and unsupervised learning in 2 paragraphs" is much better.
:::

---

## 2️⃣ Few-Shot Examples

Provide **examples of the task** before asking the model to do it

```
[Instruction]

[Example 1 Input]
[Example 1 Output]

[Example 2 Input]
[Example 2 Output]

[Your Input]
```

::: notes
Few-shot learning is powerful. The model learns the pattern from your examples. This is especially useful for structured outputs like JSON.
:::

---

## 📊 Few-Shot Example

```
Extract key entities from product reviews.

Review: "The new MacBook Pro is amazing! Great battery life."
Entities: {"product": "MacBook Pro", "sentiment": "positive", "feature": "battery life"}

Review: "The iPhone camera is disappointing in low light."
Entities: {"product": "iPhone", "sentiment": "negative", "feature": "camera"}

Review: "The Dell XPS has excellent build quality but the trackpad could be better."
Entities:
```

::: notes
The model will follow the pattern you've shown. Notice how we use consistent JSON formatting in both examples. The model will continue that pattern.
:::

---

## 🎯 Few-Shot Best Practices

<span class="fragment">📏 Use **2-5 examples** (more isn't always better)</span>

<span class="fragment">🎨 Make examples **diverse but representative**</span>

<span class="fragment">✅ Ensure examples match your **desired output format exactly**</span>

::: notes
Too many examples waste tokens and can confuse the model. Two or three well-chosen examples are usually sufficient. Quality over quantity.
:::

---

## 🎯 Few-Shot Use Cases

<span class="fragment">✅ Tasks where the model needs clarification</span>

<span class="fragment">✅ Structured outputs (JSON, CSV)</span>

<span class="fragment">✅ Domain-specific tasks</span>

<span class="fragment">✅ Reducing hallucinations</span>

::: notes
Few-shot is especially valuable for reducing hallucinations. By showing what "good" looks like, you guide the model away from making things up.
:::

---

## 3️⃣ Chain-of-Thought (CoT)

Encourage the model to **reason step-by-step** before answering

```
[Problem]

Let's think step by step:
```

::: notes
CoT is powerful but use it judiciously. It increases token usage and latency. Reserve it for tasks that truly need reasoning.
:::

---

## 🧮 CoT Example

```
Question: A store has 42 apples. They sell 15 in the morning
and 8 in the afternoon. How many apples are left?

Let's think step by step:
1. Started with: 42 apples
2. Sold in morning: 15 apples
3. Remaining after morning: 42 - 15 = 27 apples
4. Sold in afternoon: 8 apples
5. Final remaining: 27 - 8 = 19 apples

Answer: 19 apples
```

::: notes
CoT breaks down complex problems into manageable steps. This improves accuracy on multi-step reasoning tasks.
:::

---

## 🎯 CoT Use Cases

<span class="fragment">✅ Math problems</span>

<span class="fragment">✅ Logical reasoning</span>

<span class="fragment">✅ Complex multi-step tasks</span>

<span class="fragment">✅ When you need to **audit the reasoning process**</span>

::: notes
The audit benefit is underrated. CoT lets you see WHERE the model went wrong, not just THAT it was wrong. This helps with debugging and improvement.
:::

---

## ⚠️ CoT Trade-offs

<span class="fragment">🔴 Uses more tokens = **higher cost**</span>

<span class="fragment">🔴 Increases **latency**</span>

<span class="fragment">⚖️ **Trade-off**: Accuracy vs. Speed/Cost</span>

::: notes
In production, consider whether you need the reasoning or just the answer. If you're doing sentiment analysis on 10,000 tweets, CoT is overkill. But for medical diagnosis support, it's essential.
:::

---

## 4️⃣ Style Transfer

Ask the model to **rewrite content** in a different style or tone

```
Rewrite the following [current style] text in a [target style] style:

[Original text]
```

::: notes
Style transfer is incredibly useful for content adaptation. Same information, different audiences.
:::

---

## ✍️ Style Transfer Examples

**Technical → Casual:**
```
Original: "The API implements RESTful principles with JWT-based authentication..."
Casual: "Our API is super easy to use! You just need to get a token first..."
```

**Casual → Formal:**
```
Original: "Hey! Can you check out that bug? It's kinda urgent."
Formal: "Good afternoon. I would appreciate your prompt attention to the defect..."
```

::: notes
Notice how the core information stays the same but the tone changes dramatically. This is powerful for marketing and documentation.
:::

---

## 🎯 Style Transfer Use Cases

<span class="fragment">✅ Content adaptation for different audiences</span>

<span class="fragment">✅ Marketing copy variations</span>

<span class="fragment">✅ Documentation at different reading levels</span>

::: notes
One piece of technical documentation can become three: expert guide, beginner tutorial, and executive summary. All from style transfer.
:::

---

## 5️⃣ Summarization

Ask the model to **condense or reformulate** content

::: notes
Summarization is one of the most common LLM use cases. Let's explore different variants.
:::

---

## 📝 Summarization Variants

<span class="fragment">**Abstractive**: Rewrite in your own words</span>

<span class="fragment">**Extractive**: Pull out key sentences</span>

<span class="fragment">**Length-constrained**: "Exactly 50 words"</span>

<span class="fragment">**Audience-specific**: "For executives" or "For technical teams"</span>

::: notes
Different summarization styles for different needs. Abstractive is more flexible but can introduce errors. Extractive is safer but less concise.
:::

---

## 📝 Summarization Examples

```
Summarize the following article in 3 sentences:
[Article text]
```

```
Extract the 5 most important sentences from this document:
[Document text]
```

```
Summarize this technical paper for a non-technical executive audience (2 paragraphs):
[Paper]
```

::: notes
Always specify length and audience. "Summarize this" is too vague. "Summarize in 2 sentences for a non-technical audience" is precise.
:::

---

## 🎨 Prompt Design Principles {data-background-color="#1e293b"}

Universal principles that apply to all patterns

::: notes
These principles transcend specific patterns. They're the foundation of good prompt engineering.
:::

---

## 1️⃣ Clarity and Specificity

**Bad:**
```
Tell me about AI.
```

**Good:**
```
Explain the difference between supervised and unsupervised
machine learning in 3 paragraphs, with one example of each.
```

::: notes
Vague prompts lead to vague responses. Be specific about what you want, how you want it, and why.
:::

---

## 2️⃣ Role and Persona

Give the model a **role** to frame its responses

```
You are a [role] with expertise in [domain].

[Task]
```

::: notes
Personas work surprisingly well. They help the model access the right "mental model" from its training data.
:::

---

## 🎭 Persona Examples

```
You are a senior software architect with 15 years of experience
in distributed systems.

Design a scalable architecture for a real-time chat application.
```

```
You are a friendly customer support agent for a SaaS product.

Help the user understand why their payment failed.
```

::: notes
The persona sets expectations for tone, depth, and perspective. A "friendly support agent" will explain differently than a "senior architect."
:::

---

## 3️⃣ Constraints and Formatting

**Explicitly state output requirements**

<span class="fragment">📏 "List 5 key findings. Use bullet points. Keep each under 20 words."</span>

<span class="fragment">📋 "Respond in valid JSON format with keys: title, summary, tags (array)."</span>

<span class="fragment">🎯 "Your response must be under 100 words and appropriate for a general audience."</span>

::: notes
LLMs will follow format constraints if clearly stated. Don't assume it knows what you want—tell it explicitly.
:::

---

## 4️⃣ Providing Context

**More context = better responses**

<span class="fragment">❌ "Fix this bug."</span>

<span class="fragment">✅ "I have a Python function that's supposed to calculate discounts but returns negative values. Here's the code... Expected: 0-100. Actual: -25. Please identify the bug."</span>

::: notes
Context is king. The more relevant information you provide, the better the model can help. But don't waste tokens on irrelevant context.
:::

---

## 🏗️ Prompt Templates {data-transition="zoom"}

Reusable patterns with placeholders for variable content

::: notes
Templates are the key to scaling prompt engineering. Write once, use everywhere.
:::

---

## 💡 Why Templates Matter

<span class="fragment">✅ **Consistency**: Same structure every time</span>

<span class="fragment">✅ **Maintainability**: Update once, apply everywhere</span>

<span class="fragment">✅ **Testability**: Easier to evaluate prompt changes</span>

<span class="fragment">✅ **Scalability**: Supports batch processing</span>

::: notes
Without templates, you'll have prompt logic scattered everywhere. Templates centralize your prompt engineering.
:::

---

## 🐍 Simple Python Templates

**Using f-strings:**

```python {data-line-numbers="1-7"}
def summarize(text: str, length: int = 3) -> str:
    prompt = f"""Summarize the following text in {length} sentences:

{text}

Summary:"""
    return llm.generate(prompt)
```

::: notes
F-strings are the simplest approach. Good for straightforward templates with a few variables.
:::

---

## 🐍 String Formatting

```python {data-line-numbers="1-13"}
TEMPLATE = """You are a helpful assistant.

Task: {task}

Input: {input_text}

Output format: {output_format}
"""

prompt = TEMPLATE.format(
    task="Extract entities",
    input_text="IBM released watsonx.ai in 2023.",
    output_format="JSON with keys: organization, product, year"
)
```

::: notes
str.format() is more readable for longer templates with many variables. It separates the template definition from usage.
:::

---

## 🔗 LangChain Templates

```python {data-line-numbers="1-15"}
from langchain.prompts import PromptTemplate

template = PromptTemplate(
    input_variables=["task", "examples", "input"],
    template="""You are an AI assistant specializing in {task}.

Here are some examples:
{examples}

Now, process this input:
{input}
"""
)

prompt = template.format(
    task="sentiment analysis",
    examples="Positive: 'Great product!'\nNegative: 'Terrible experience.'",
    input="The service was okay."
)
```

::: notes
LangChain provides more sophisticated templating with validation. It ensures you don't forget required variables.
:::

---

## 💬 Chat Templates

```python {data-line-numbers="1-11"}
from langchain.prompts import ChatPromptTemplate

template = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant specialized in {domain}."),
    ("human", "{user_input}"),
])

messages = template.format_messages(
    domain="data analysis",
    user_input="How do I calculate correlation?"
)
```

::: notes
Chat templates handle multi-turn conversations properly, with system and user messages. Essential for chatbot applications.
:::

---

## 🏗️ Accelerator Prompt Structure {data-background-color="#0f172a"}

How the accelerator centralizes prompt logic

::: notes
Let's see how templates are used in the production codebase you'll work with.
:::

---

## 📁 Accelerator: Current Structure

```python {data-line-numbers="1-9"}
# accelerator/rag/prompt.py

SYSTEM = """You are a careful and accurate assistant.
You answer questions based on provided context.
If you cannot find the answer in the context, say so."""

USER_TEMPLATE = """Context:
{context}

Question: {question}

Answer:"""
```

::: notes
Simple but effective. The accelerator separates system prompts from user prompts. You'll extend this on Day 2-3.
:::

---

## 📋 Day 2-3: Multi-turn Conversations

```python {data-line-numbers="1-12"}
CHAT_TEMPLATE = """You are a helpful assistant.
Use the following context to answer questions.

Context:
{context}

Conversation history:
{history}

User: {question}
Assistant:"""
```

::: notes
Tomorrow, you'll add conversation history to maintain context across multiple turns. This template structure makes it easy.
:::

---

## 📎 Day 2-3: Citations

```python {data-line-numbers="1-10"}
USER_TEMPLATE_WITH_CITATIONS = """Context:
{context}

Question: {question}

Answer the question and cite your sources using [1], [2], etc.

Answer:"""
```

::: notes
Citations build trust. Users can verify the information. This template instructs the model to add citation markers.
:::

---

## 🛡️ Day 2-3: Safety Guidance

```python {data-line-numbers="1-12"}
SYSTEM_WITH_SAFETY = """You are a helpful and safe assistant.
- Base answers on provided context only
- Do not generate harmful, biased, or inappropriate content
- If asked to do something outside your scope, politely decline
- Cite sources when available

Context:
{context}

Question: {question}

Answer:"""
```

::: notes
Safety first. This template includes explicit safety guidelines. We'll cover safety in more depth in the next module.
:::

---

## 🔌 Integration in pipeline.py

```python {data-line-numbers="1-18"}
from .prompt import SYSTEM, USER_TEMPLATE

def answer_question(question: str, context: List[str]) -> str:
    # Format context
    context_str = "\n\n".join(
        [f"[{i+1}] {doc}" for i, doc in enumerate(context)]
    )

    # Build prompt
    user_prompt = USER_TEMPLATE.format(
        context=context_str,
        question=question
    )

    # Generate
    response = llm.generate(
        system=SYSTEM,
        prompt=user_prompt
    )

    return response
```

::: notes
This is the actual pattern you'll use. Templates are imported from prompt.py, filled with data, then passed to the LLM. Clean separation of concerns.
:::

---

## 📓 Reference Notebooks

**Key notebook:**
`use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`

Shows real prompt structure for RAG

::: notes
The notebooks in labs-src/ show these patterns in action. Don't run them today, but do open them to see real examples.
:::

---

## 🧪 Lab 1.2 Preview {data-background-color="#1e293b"}

What you'll build in the lab

::: notes
Let's preview what you'll do in Lab 1.2 to cement these concepts.
:::

---

## 📝 Lab 1.2: Your Tasks

<span class="fragment">🎯 Create templates for: Summarization, Style rewrite, Q&A with context</span>

<span class="fragment">🎯 Implement in both Ollama and watsonx</span>

<span class="fragment">🎯 Compare results across backends</span>

<span class="fragment">🎯 Measure quality and consistency</span>

::: notes
You'll take the patterns we've discussed and implement them yourself. This hands-on practice is where the learning really happens.
:::

---

## 🎯 Template 1: Summarization

```python {data-line-numbers="1-8"}
SUMMARIZE_TEMPLATE = """Summarize the following text in {num_sentences} sentences.
Focus on the main points and key takeaways.

Text:
{text}

Summary:"""
```

::: notes
Start with this template in Lab 1.2. It's simple but teaches the pattern.
:::

---

## 🎯 Template 2: Style Transfer

```python {data-line-numbers="1-6"}
REWRITE_TEMPLATE = """Rewrite the following text in a {target_tone} tone:

Original text:
{original}

Rewritten text:"""
```

::: notes
Style transfer template. You'll experiment with different tones: formal, casual, technical, beginner-friendly.
:::

---

## 🎯 Template 3: Q&A with Context

```python {data-line-numbers="1-9"}
QA_TEMPLATE = """Based on the following information, answer the question.
If the information doesn't contain the answer, say "I don't have enough information."

Information:
{context}

Question: {question}

Answer:"""
```

::: notes
This is a mini-RAG prompt. You're providing context manually now. Tomorrow, you'll retrieve it automatically.
:::

---

## 🔮 Looking Ahead

**Day 2**: These templates become the foundation for RAG prompts

**Day 3**: Templates extended for multi-turn agents and tool calling

::: notes
Everything you learn today compounds. Master these basics and the advanced topics will be much easier.
:::

---

## ✅ Best Practices Summary {data-background-color="#0f172a"}

What to do and what to avoid

::: notes
Let's wrap up with a clear dos and don'ts list.
:::

---

## ✅ Do

<span class="fragment">✅ Start with simple, clear instructions</span>

<span class="fragment">✅ Use few-shot examples for structured outputs</span>

<span class="fragment">✅ Specify output format explicitly</span>

<span class="fragment">✅ Test prompts with edge cases</span>

<span class="fragment">✅ Version control your templates</span>

<span class="fragment">✅ Measure prompt performance systematically</span>

::: notes
Version control is underrated. Treat prompts like code. Track changes, test before deployment, and review changes carefully.
:::

---

## ❌ Don't

<span class="fragment">❌ Use vague or ambiguous language</span>

<span class="fragment">❌ Mix multiple tasks in one prompt</span>

<span class="fragment">❌ Assume the model knows your context</span>

<span class="fragment">❌ Forget to handle error cases</span>

<span class="fragment">❌ Over-engineer prompts prematurely</span>

::: notes
Start simple. Many developers over-engineer prompts, adding complexity that doesn't help. Begin with the simplest prompt that might work, then iterate.
:::

---

## 🎯 Key Takeaways

<span class="fragment">🔑 **Prompts are code**: Treat them with the same rigor</span>

<span class="fragment">🔑 **Structure matters**: Well-structured prompts are more reliable</span>

<span class="fragment">🔑 **Templates enable scale**: Reusable patterns save time</span>

<span class="fragment">🔑 **Test and iterate**: Prompt engineering is empirical</span>

::: notes
What works for one task may not work for another. Always test. Always iterate. Prompt engineering is a skill that improves with practice.
:::

---

## 🚀 Next: Lab 1.2 {data-background-color="#0f172a"}

Time to build these patterns hands-on!

::: notes
You've learned the theory. Now apply it. Lab 1.2 is where you'll build real templates and see how they perform across different models.
:::

---

## 🔗 Navigation & Resources {data-background-color="#0f172a"}

**Navigate the workshop:**

### 🏠 [Workshop Portal Home](https://ruslanmv.com/watsonx-workshop/portal/)
Interactive daily guides and presentations

### 📚 [Return to Day 1 Overview](./README.md)
Review Day 1 schedule and learning objectives

### ⬅️ [Previous: LLM Concepts](./llm-concepts.md)
Review LLM fundamentals and architecture

### ▶️ [Next: Evaluation & Safety Theory](./eval-safety-theory.md)
Learn to measure quality and ensure responsible AI

### 🧪 [Jump to Lab 1.2: Prompt Templates](./lab-2-prompt-templates.md)
Build production-ready prompt patterns

### 📖 [All Workshop Materials](../../README.md)
Access complete workshop resources

::: notes
**Instructor guidance:**
- Remind students that prompt engineering is a skill that improves with practice
- Emphasize the connection between templates and production systems
- Encourage students to save their best prompts for reuse
- Point out that Day 2's RAG prompts build directly on these patterns

**If students want to go deeper:**
- Experiment with the reference notebooks
- Try chain-of-thought prompting on complex problems
- Build a personal prompt library
- Study the Anthropic and OpenAI prompt libraries

**Before proceeding to Lab 1.2:**
- Ensure everyone understands the five core patterns
- Quick poll: "Which pattern do you think you'll use most?"
- Remind students to version control their prompts
:::

---

## 📖 Prompt Engineering Resources

**Master the art of prompt engineering:**

### Comprehensive Guides
- 📘 **[Prompt Engineering Guide](https://www.promptingguide.ai/)** – The most complete prompt engineering resource
- 📘 **[OpenAI Prompt Engineering Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)** – Official guidelines from OpenAI
- 📘 **[Anthropic Prompt Engineering](https://docs.anthropic.com/claude/docs/prompt-engineering)** – Claude-specific techniques
- 📘 **[Google Cloud Prompt Design](https://cloud.google.com/vertex-ai/docs/generative-ai/learn/introduction-prompt-design)** – Enterprise prompt patterns

### Prompt Libraries & Examples
- 🎨 **[Anthropic Prompt Library](https://docs.anthropic.com/claude/prompt-library)** – Production-tested prompts for common tasks
- 🎨 **[OpenAI Examples](https://platform.openai.com/examples)** – Interactive prompt examples
- 🎨 **[LangChain Prompt Templates](https://python.langchain.com/docs/modules/model_io/prompts/prompt_templates/)** – Framework integration patterns
- 🎨 **[PromptBase](https://promptbase.com/)** – Marketplace for quality prompts

### Advanced Techniques
- 🔬 **[Chain-of-Thought Prompting](https://arxiv.org/abs/2201.11903)** – Research paper on CoT
- 🔬 **[ReAct: Reasoning + Acting](https://arxiv.org/abs/2210.03629)** – Combining reasoning with actions
- 🔬 **[Few-Shot Learning](https://arxiv.org/abs/2005.14165)** – Academic foundation for in-context learning
- 🔬 **[Tree of Thoughts](https://arxiv.org/abs/2305.10601)** – Advanced reasoning framework

### Tools & Platforms
- 🔧 **[LangSmith](https://www.langchain.com/langsmith)** – Prompt testing and debugging platform
- 🔧 **[PromptLayer](https://promptlayer.com/)** – Version control for prompts
- 🔧 **[Helicone](https://www.helicone.ai/)** – LLM observability and prompt analytics

::: notes
Share these in the workshop chat for students who want to go deeper. The Anthropic Prompt Library is particularly valuable—every prompt there has been tested in production.

The research papers are for students with academic interests. Don't require reading them, but make them available for those who want the theoretical foundation.
:::

---

## 💡 Prompt Engineering Best Practices

**Lessons from production systems:**

<span class="fragment">**🎯 Iteration is Key**
Your first prompt will rarely be your best. Plan for 3-5 iterations based on testing and feedback.</span>

<span class="fragment">**📝 Document Your Prompts**
Use comments to explain why you made specific choices. Future you (and your team) will thank you.</span>

<span class="fragment">**🧪 A/B Test Prompts**
When changing prompts in production, run A/B tests to measure impact on quality metrics.</span>

<span class="fragment">**📊 Version Control Everything**
Treat prompts like code. Use git to track changes. Tag versions deployed to production.</span>

<span class="fragment">**👥 Involve Domain Experts**
Domain experts know what "good" looks like. Have them review prompts for their area.</span>

<span class="fragment">**🔄 Regularly Re-evaluate**
Models change. User needs evolve. Re-test prompts quarterly to ensure they still perform well.</span>

::: notes
These practices separate amateur prompt engineering from professional deployment:

- **Iteration**: Show a before/after example of a prompt that improved through iteration
- **Documentation**: Share an example of a well-documented prompt template
- **A/B Testing**: Explain how to run simple A/B tests (send 50% traffic to each variant)
- **Version Control**: Demo a git commit message for a prompt change
- **Domain Experts**: Give an example where expert feedback improved a medical/legal prompt
- **Re-evaluation**: Share a case where a prompt that worked in January failed in June

Make these practices stick with concrete examples!
:::

---

## 🎨 Template Design Patterns

**Common patterns for organizing prompt templates:**

<span class="fragment">**1. Role-Context-Task Pattern**
```python
"""You are a [ROLE] with expertise in [DOMAIN].

Context: [BACKGROUND_INFO]

Task: [SPECIFIC_INSTRUCTION]

Constraints: [LIMITATIONS]
"""
```
Clear structure that sets expectations</span>

<span class="fragment">**2. Input-Processing-Output Pattern**
```python
"""Given: [INPUT_DESCRIPTION]

Process this input by: [STEPS]

Return: [OUTPUT_FORMAT]
"""
```
Explicit about what goes in and what should come out</span>

<span class="fragment">**3. Example-Driven Pattern**
```python
"""Task: [TASK_DESCRIPTION]

Examples:
Input: [EXAMPLE_1_INPUT]
Output: [EXAMPLE_1_OUTPUT]

Input: [EXAMPLE_2_INPUT]
Output: [EXAMPLE_2_OUTPUT]

Now process: [ACTUAL_INPUT]
"""
```
Let examples guide the model</span>

::: notes
These meta-patterns help organize your thinking about prompt structure. They're not rigid rules—mix and match as needed.

**Pattern 1** works well for customer support and conversational agents.
**Pattern 2** is ideal for data transformation and extraction tasks.
**Pattern 3** shines for structured outputs like JSON generation.

Have students identify which pattern each template in Lab 1.2 uses.
:::

---

## 🙏 Thank You!

**Questions on prompt patterns?**

Remember:
- Prompt engineering is both art and science
- Templates save time and ensure consistency
- The patterns you learn today work across all LLM providers
- Lab 1.2 is where you'll practice building real templates

**Ready to create some powerful prompts?** 🚀

<div style="margin-top: 40px; text-align: center;">
<a href="https://ruslanmv.com/watsonx-workshop/portal/" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Workshop Portal</a>
<a href="./lab-2-prompt-templates.md" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">🧪 Start Lab 1.2</a>
</div>

::: notes
**For instructors:**
Before transitioning to Lab 1.2, ask:
- "Which prompt pattern do you think you'll use most in your work?"
- "Anyone have a use case they're excited to build a template for?"
- "Questions on few-shot vs. chain-of-thought?"
- "Ready to build some templates?"

**Transition smoothly:**
"Excellent! Now you understand the core patterns and principles. In Lab 1.2, you'll build three production-ready templates: summarization, style transfer, and Q&A with context. These will form the foundation for tomorrow's RAG prompts. Let's dive in!"

Encourage students to be creative in Lab 1.2—prompt engineering has room for personal style.
:::