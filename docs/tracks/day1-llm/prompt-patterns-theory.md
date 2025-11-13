# 1.2 Prompt Patterns & Templates

Understanding how to structure prompts effectively is crucial for getting reliable, high-quality outputs from LLMs. This module covers common prompt patterns and how to build reusable templates.

---

## Learning Objectives

By the end of this module, you will:

- Recognize common prompt patterns and when to use them
- Understand why structure matters in prompt engineering
- Know how to create reusable prompt templates
- See how the accelerator uses prompts in production

---

## Core Prompt Patterns

### 1. Instruction Prompts

The simplest pattern: give the model a clear instruction.

**Structure**:
```
[Instruction]
```

**Examples**:
```
Summarize this text in 3 sentences.

Extract all email addresses from the following document.

Translate this paragraph to French.
```

**Best for**:
- Simple, well-defined tasks
- When the model already knows what to do
- Single-step operations

**Tips**:
- Be specific and direct
- Use action verbs (summarize, extract, translate, list)
- Specify output format if needed

### 2. Few-Shot Examples

Provide examples of the task before asking the model to do it.

**Structure**:
```
[Instruction]

[Example 1 Input]
[Example 1 Output]

[Example 2 Input]
[Example 2 Output]

[Your Input]
```

**Example**:
```
Extract key entities from product reviews.

Review: "The new MacBook Pro is amazing! Great battery life."
Entities: {"product": "MacBook Pro", "sentiment": "positive", "feature": "battery life"}

Review: "The iPhone camera is disappointing in low light."
Entities: {"product": "iPhone", "sentiment": "negative", "feature": "camera"}

Review: "The Dell XPS has excellent build quality but the trackpad could be better."
Entities:
```

**Best for**:
- Tasks where the model needs clarification
- Structured outputs (JSON, CSV)
- Domain-specific tasks
- Reducing hallucinations

**Tips**:
- Use 2-5 examples (more isn't always better)
- Make examples diverse but representative
- Ensure examples match your desired output format exactly

### 3. Chain-of-Thought (CoT)

Encourage the model to reason step-by-step before answering.

**Structure**:
```
[Problem]

Let's think step by step:
```

**Example**:
```
Question: A store has 42 apples. They sell 15 in the morning and 8 in the afternoon. 
How many apples are left?

Let's think step by step:
1. Started with: 42 apples
2. Sold in morning: 15 apples
3. Remaining after morning: 42 - 15 = 27 apples
4. Sold in afternoon: 8 apples
5. Final remaining: 27 - 8 = 19 apples

Answer: 19 apples
```

**Best for**:
- Math problems
- Logical reasoning
- Complex multi-step tasks
- When you need to audit the reasoning process

**⚠️ Workshop Note**:
- We use CoT judiciously (it's powerful but can increase latency)
- For production, consider whether you need the reasoning or just the answer
- CoT uses more tokens = higher cost

### 4. Style Transfer

Ask the model to rewrite content in a different style or tone.

**Structure**:
```
Rewrite the following [current style] text in a [target style] style:

[Original text]
```

**Examples**:
```
Rewrite this technical documentation in a casual, beginner-friendly style:

Original: "The API implements RESTful principles with JWT-based authentication..."
Casual: "Our API is super easy to use! You just need to get a token first..."

---

Rewrite this casual email in a formal business tone:

Original: "Hey! Can you check out that bug? It's kinda urgent."
Formal: "Good afternoon. I would appreciate your prompt attention to the defect..."
```

**Best for**:
- Content adaptation
- Marketing copy variations
- Documentation at different reading levels

### 5. Summarization / Rewrite

Ask the model to condense or reformulate content.

**Common variants**:

**Abstractive summary**:
```
Summarize the following article in 3 sentences:

[Article text]
```

**Extractive summary**:
```
Extract the 5 most important sentences from this document:

[Document text]
```

**Length-constrained**:
```
Summarize this in exactly 50 words:

[Text]
```

**Audience-specific**:
```
Summarize this technical paper for a non-technical executive audience (2 paragraphs):

[Paper]
```

**Best for**:
- Long documents
- Content curation
- Executive summaries
- Social media posts from longer content

---

## Prompt Design Principles

### 1. Clarity and Specificity

**Bad**:
```
Tell me about AI.
```

**Good**:
```
Explain the difference between supervised and unsupervised machine learning 
in 3 paragraphs, with one example of each.
```

**Why it matters**: Vague prompts lead to vague, unfocused responses.

### 2. Role and Persona

Give the model a role to frame its responses.

**Structure**:
```
You are a [role] with expertise in [domain].

[Task]
```

**Examples**:
```
You are a senior software architect with 15 years of experience in distributed systems.

Design a scalable architecture for a real-time chat application.

---

You are a friendly customer support agent for a SaaS product.

Help the user understand why their payment failed.
```

**Best for**:
- Setting the right tone
- Accessing domain-specific knowledge
- Consistency across conversations

### 3. Constraints and Formatting

Explicitly state output requirements.

**Examples**:
```
List 5 key findings. Use bullet points. Keep each point under 20 words.

---

Respond in valid JSON format with keys: title, summary, tags (array).

---

Your response must be under 100 words and appropriate for a general audience.
```

**Why it matters**: LLMs will follow format constraints if clearly stated.

### 4. Providing Context and Examples

More context = better responses.

**Insufficient context**:
```
Fix this bug.
```

**Better**:
```
I have a Python function that's supposed to calculate discounts but returns negative values.
Here's the code:

[code]

Expected behavior: discount should be between 0-100.
Actual behavior: discount is -25.

Please identify the bug and provide a corrected version.
```

**When to provide context**:
- Always for technical tasks
- When the model needs background information
- For domain-specific questions

---

## Prompt Templates

### What is a Template?

A **prompt template** is a reusable pattern with placeholders for variable content.

**Benefits**:
- **Consistency**: Same structure every time
- **Maintainability**: Update once, apply everywhere
- **Testability**: Easier to evaluate prompt changes
- **Scalability**: Supports batch processing

### Simple Python Templates

**Using f-strings**:
```python
def summarize(text: str, length: int = 3) -> str:
    prompt = f"""Summarize the following text in {length} sentences:

{text}

Summary:"""
    return llm.generate(prompt)
```

**Using str.format()**:
```python
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

### LangChain Templates

LangChain provides more sophisticated templating:

```python
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

**Advanced: ChatPromptTemplate**:
```python
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

---

## How the Accelerator Uses Prompts

The accelerator centralizes prompt logic in `rag/prompt.py`:

### Current Structure

```python
# accelerator/rag/prompt.py

SYSTEM = """You are a careful and accurate assistant.
You answer questions based on provided context.
If you cannot find the answer in the context, say so."""

USER_TEMPLATE = """Context:
{context}

Question: {question}

Answer:"""
```

### On Day 2-3, You'll Extend This

**Multi-turn conversations**:
```python
CHAT_TEMPLATE = """You are a helpful assistant. Use the following context to answer questions.

Context:
{context}

Conversation history:
{history}

User: {question}
Assistant:"""
```

**Citation formatting**:
```python
USER_TEMPLATE_WITH_CITATIONS = """Context:
{context}

Question: {question}

Answer the question and cite your sources using [1], [2], etc.

Answer:"""
```

**Safety guidance**:
```python
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

### Integration Points

**In `pipeline.py`**:
```python
from .prompt import SYSTEM, USER_TEMPLATE

def answer_question(question: str, context: List[str]) -> str:
    # Format context
    context_str = "\n\n".join([f"[{i+1}] {doc}" for i, doc in enumerate(context)])
    
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

---

## Reference Notebooks

### RAG Prompt Examples

**`use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`**:
```python
# Example from the notebook
from langchain.prompts import PromptTemplate

rag_prompt = PromptTemplate(
    template="""Use the following pieces of context to answer the question at the end.
If you don't know the answer, just say that you don't know, don't try to make up an answer.

{context}

Question: {question}
Helpful Answer:""",
    input_variables=["context", "question"],
)
```

**`QnA_with_RAG.ipynb`** (accelerator):
- Shows how context is concatenated
- Demonstrates citation patterns
- Includes error handling for edge cases

### Key Observations

1. **Context injection**: Always happens before the question
2. **Structured formats**: JSON/XML for tool calling
3. **Safety prompts**: Explicitly state boundaries
4. **Few-shot in RAG**: Sometimes examples are included to show citation format

---

## Examples to Reuse in Lab 1.2

### Example 1: Summarization

**Template**:
```python
SUMMARIZE_TEMPLATE = """Summarize the following text in {num_sentences} sentences.
Focus on the main points and key takeaways.

Text:
{text}

Summary:"""
```

**Usage**:
```python
prompt = SUMMARIZE_TEMPLATE.format(
    num_sentences=3,
    text="[Your long text here]"
)
```

### Example 2: Style Transfer

**Template**:
```python
REWRITE_TEMPLATE = """Rewrite the following text in a {target_tone} tone:

Original text:
{original}

Rewritten text:"""
```

**Usage**:
```python
prompt = REWRITE_TEMPLATE.format(
    target_tone="formal business",
    original="Hey, can you check that out?"
)
```

### Example 3: Q&A with Context

**Template**:
```python
QA_TEMPLATE = """Based on the following information, answer the question.
If the information doesn't contain the answer, say "I don't have enough information."

Information:
{context}

Question: {question}

Answer:"""
```

**Usage**:
```python
prompt = QA_TEMPLATE.format(
    context="watsonx.ai was released by IBM in 2023...",
    question="When was watsonx.ai released?"
)
```

---

## Connection to Labs

### Lab 1.2: Prompt Templates

In this lab, you'll:

1. **Create templates** for:
   - Summarization
   - Style rewrite
   - Q&A with context

2. **Implement in both environments**:
   - `prompt_patterns_ollama.ipynb` (local)
   - `prompt_patterns_watsonx.ipynb` (managed)

3. **Compare results**:
   - Same template, different models
   - Measure quality and consistency

### Looking Ahead

**Day 2**: These templates become the foundation for RAG prompts
**Day 3**: Templates extended for multi-turn agents and tool calling

---

## Best Practices Summary

### ✅ Do

- Start with simple, clear instructions
- Use few-shot examples for structured outputs
- Specify output format explicitly
- Test prompts with edge cases
- Version control your templates
- Measure prompt performance systematically

### ❌ Don't

- Use vague or ambiguous language
- Mix multiple tasks in one prompt
- Assume the model knows your context
- Forget to handle error cases
- Over-engineer prompts prematurely

---

## Key Takeaways

- **Prompts are code**: Treat them with the same rigor as application code
- **Structure matters**: Well-structured prompts are more reliable
- **Templates enable scale**: Reusable patterns save time and improve consistency
- **Test and iterate**: Prompt engineering is empirical—what works for one task may not work for another

**Next**: Time to build these patterns hands-on in Lab 1.2!
