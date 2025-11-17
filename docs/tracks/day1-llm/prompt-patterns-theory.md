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

**Five fundamental patterns that handle 90% of real-world scenarios**

Understanding these patterns enables you to:

- **Solve diverse problems** using proven approaches
- **Communicate effectively** with LLMs across different tasks
- **Build reliable systems** with predictable outputs
- **Scale your work** through reusable patterns

Each pattern serves a specific purpose and excels in particular use cases. The key is knowing which pattern to apply when, and how to combine them for complex requirements.

::: notes
These patterns are battle-tested across thousands of production deployments. They work with GPT, Claude, Llama, and watsonx models. Master these five patterns and you'll handle 90% of scenarios you encounter.

Think of these as your "design patterns" for LLM engineering—just like software design patterns, they capture best practices that emerge from real-world experience. We've distilled years of trial and error into these five core approaches.
:::

---

## 1️⃣ Instruction Prompts

The simplest pattern: **give the model a clear instruction**

```
[Instruction]
```

**When to use:**
- Single, well-defined tasks
- Tasks the model already "knows" how to do
- When you want minimal token usage
- Quick prototyping and testing

**Structure:** Direct action verb + specific requirement

::: notes
Start simple. Many tasks only need a clear instruction. Don't over-engineer when simplicity works. This pattern leverages the model's pre-trained knowledge—if the task is common enough, a simple instruction is all you need.

The beauty of instruction prompts is their efficiency. No examples needed, no elaborate setup. Just clear, direct communication.
:::

---

## 📝 Instruction Examples

```
Summarize this text in 3 sentences.

Extract all email addresses from the following document.

Translate this paragraph to French.

Convert this JSON to YAML format.

List the top 5 security vulnerabilities in this code.
```

<span class="fragment">**Best for**: Simple, well-defined tasks where the model knows what "good" looks like</span>

<span class="fragment">**Key success factor**: Specificity. "Summarize" is vague. "Summarize in 3 sentences" is precise.</span>

::: notes
Notice the pattern: action verb + specification. "Summarize in 3 sentences" is better than "Summarize this text." Every additional constraint you provide narrows the output space and improves consistency.

The more specific you are, the more reliable your results. Compare "Translate to French" (which French? Formal? Casual?) with "Translate to formal French suitable for business communication."
:::

---

## 💡 Instruction Prompt Tips

<span class="fragment">✅ Be **specific and direct** - say exactly what you want</span>

<span class="fragment">✅ Use **action verbs** (summarize, extract, translate, list, classify)</span>

<span class="fragment">✅ **Specify output format** if needed (JSON, bullet points, table)</span>

<span class="fragment">✅ **Include constraints** (word count, style, audience)</span>

<span class="fragment">✅ **Set expectations** for edge cases ("if not found, return 'N/A'")</span>

**Examples of improvement:**

❌ Bad: "Tell me about AI"  
✅ Good: "Explain the difference between supervised and unsupervised learning in 2 paragraphs"

❌ Bad: "Make this better"  
✅ Good: "Rewrite this paragraph to be more concise while maintaining technical accuracy"

::: notes
Vague instructions lead to vague outputs. "Tell me about AI" is too broad—the model could write a book. "Explain the difference between supervised and unsupervised learning in 2 paragraphs" is much better.

Think about how you'd explain the task to a very literal colleague who will do exactly what you say, nothing more. That's how you should write instructions for LLMs.
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

**When to use:**
- Structured outputs (JSON, XML, specific formats)
- Domain-specific tasks
- When instruction alone produces inconsistent results
- Teaching the model a new pattern

::: notes
Few-shot learning is powerful—the model learns the pattern from your examples. This technique is especially useful for structured outputs like JSON where format consistency is critical.

Think of few-shot prompting as "programming by example." Instead of describing what you want in words, you show the model what you want through concrete examples. The model infers the pattern and applies it to new inputs.
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

**Expected output:**
```json
{"product": "Dell XPS", "sentiment": "mixed", "feature": "build quality"}
```

::: notes
The model will follow the pattern you've shown. Notice how we use consistent JSON formatting in both examples—the model will continue that pattern.

The key is consistency across examples. If your first example uses lowercase keys and your second uses uppercase, the model won't know which to follow. Make your examples identical in structure, varying only in content.
:::

---

## 🎯 Few-Shot Best Practices

<span class="fragment">📏 Use **2-5 examples** (more isn't always better - quality over quantity)</span>

<span class="fragment">🎨 Make examples **diverse but representative** of the input space</span>

<span class="fragment">✅ Ensure examples match your **desired output format exactly**</span>

<span class="fragment">🎯 Include **edge cases** in your examples (optional values, special characters)</span>

<span class="fragment">⚖️ **Balance your examples** - don't show only easy cases</span>

**Example selection strategy:**

1. **Start with a typical case** - shows the standard pattern
2. **Add a complex case** - demonstrates handling of edge conditions
3. **Include an ambiguous case** - shows how to handle uncertainty

::: notes
Too many examples waste tokens and can confuse the model. Two or three well-chosen examples are usually sufficient. Quality over quantity.

Think carefully about which examples to include. Your examples are teaching the model—what lessons do you want it to learn? Each example should highlight a different aspect of the task.
:::

---

## 🎯 Few-Shot Use Cases

**Perfect for:**

<span class="fragment">✅ **Structured data extraction** - When you need consistent JSON, CSV, or XML output</span>

<span class="fragment">✅ **Classification tasks** - Show examples of each class</span>

<span class="fragment">✅ **Format conversion** - Demonstrate the input→output transformation</span>

<span class="fragment">✅ **Domain-specific tasks** - Teach domain knowledge through examples</span>

<span class="fragment">✅ **Reducing hallucinations** - Examples ground the model in reality</span>

**Real-world applications:**
- **Entity extraction** from documents (names, dates, amounts)
- **Sentiment analysis** with custom categories
- **Code generation** in specific frameworks
- **Data normalization** (addresses, phone numbers, dates)

::: notes
Few-shot is especially valuable for reducing hallucinations. By showing what "good" looks like, you guide the model away from making things up.

In production systems, we've seen few-shot prompting reduce error rates by 40-60% for structured extraction tasks compared to instruction-only prompts. The investment in crafting good examples pays dividends in reliability.
:::

---

## 3️⃣ Chain-of-Thought (CoT)

Encourage the model to **reason step-by-step** before answering

```
[Problem]

Let's think step by step:
```

**When to use:**
- Math and logical reasoning
- Multi-step problems
- When you need to audit the reasoning process
- Complex decision-making tasks

**Key benefit:** You see WHERE the model went wrong, not just THAT it was wrong

::: notes
CoT is powerful but use it judiciously. It increases token usage and latency. Reserve it for tasks that truly need reasoning—don't use CoT for simple classification or extraction.

Research shows that CoT can improve accuracy on reasoning tasks by 20-40%. The trade-off is that responses are 3-5x longer. Use it when accuracy matters more than speed or cost.
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

**Why this works:**
- Each step is small and verifiable
- Errors are easy to identify
- The reasoning is transparent
- You can debug where logic fails

::: notes
CoT breaks down complex problems into manageable steps. This improves accuracy on multi-step reasoning tasks. It also helps you understand the model's logic—you can see exactly where it went wrong if the answer is incorrect.

In production, CoT is invaluable for debugging. When a model gives a wrong answer, the reasoning steps show you which assumption or calculation failed. This makes fixing prompts much easier.
:::

---

## 🎯 CoT Use Cases

<span class="fragment">✅ **Math problems** - Arithmetic, algebra, word problems</span>

<span class="fragment">✅ **Logical reasoning** - If-then chains, deduction</span>

<span class="fragment">✅ **Complex multi-step tasks** - Planning, scheduling, optimization</span>

<span class="fragment">✅ **Debugging and auditing** - When you need to **verify the reasoning process**</span>

<span class="fragment">✅ **High-stakes decisions** - Medical diagnosis support, legal analysis</span>

**Example prompt for debugging:**

```python
# Code review with reasoning
"""Review this function for bugs.

Think through:
1. What is the intended behavior?
2. What edge cases exist?
3. What could go wrong?
4. Are there any logical errors?

Then provide your findings.
"""
```

::: notes
The audit benefit is underrated. CoT lets you see WHERE the model went wrong, not just THAT it was wrong. This helps with debugging and improvement.

In medical or legal applications, showing the reasoning isn't just helpful—it's often required. Stakeholders need to understand why a decision was made, not just what the decision was.
:::

---

## ⚠️ CoT Trade-offs

<span class="fragment">🔴 Uses more tokens = **higher cost** (3-5x more tokens than direct answers)</span>

<span class="fragment">🔴 Increases **latency** (takes longer to generate longer responses)</span>

<span class="fragment">🔴 May expose **flawed reasoning** that's harder to fix than the wrong answer</span>

<span class="fragment">⚖️ **Trade-off**: Accuracy vs. Speed/Cost</span>

**Decision framework:**

| Use Case | Use CoT? | Reasoning |
|----------|----------|-----------|
| Sentiment analysis on 10,000 tweets | ❌ No | Simple classification, high volume |
| Medical diagnosis support | ✅ Yes | Complex reasoning, high stakes |
| Math tutoring app | ✅ Yes | Need to show work to students |
| Email spam detection | ❌ No | Binary classification, high volume |

::: notes
In production, consider whether you need the reasoning or just the answer. If you're doing sentiment analysis on 10,000 tweets, CoT is overkill and wasteful. But for medical diagnosis support, it's essential—you need to see the reasoning.

We've seen production systems that use CoT selectively: simple queries get fast direct answers, complex queries trigger CoT. This balances accuracy and cost effectively.
:::

---

## 4️⃣ Style Transfer

Ask the model to **rewrite content** in a different style or tone

```
Rewrite the following [current style] text in a [target style] style:

[Original text]
```

**When to use:**
- Adapting content for different audiences
- Changing formality levels
- Converting between technical and casual language
- Marketing copy variations
- Documentation at different reading levels

**Key principle:** Same information, different presentation

::: notes
Style transfer is incredibly useful for content adaptation. Same information, different audiences. This is especially powerful in documentation where you need expert guides, beginner tutorials, and executive summaries—all from the same source material.

Think of style transfer as translation between "dialects" of the same language. You're not changing what you say, just how you say it.
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

**Expert → Beginner:**
```
Original: "Configure the ingress controller with TLS termination at the load balancer."
Beginner: "Set up the system to handle secure connections. We'll do this at the entry point."
```

**Business → Technical:**
```
Original: "We need to improve user engagement metrics."
Technical: "Implement event tracking for user interactions and optimize the conversion funnel."
```

::: notes
Notice how the core information stays the same but the tone changes dramatically. This is powerful for marketing and documentation.

Style transfer is particularly valuable for companies that need to communicate the same information to different stakeholders—technical teams, executives, customers, partners. One source of truth, multiple presentations.
:::

---

## 🎯 Style Transfer Use Cases

<span class="fragment">✅ **Content adaptation** for different audiences (developers, managers, customers)</span>

<span class="fragment">✅ **Marketing copy variations** (formal, casual, urgent, friendly)</span>

<span class="fragment">✅ **Documentation** at different reading levels (expert, intermediate, beginner)</span>

<span class="fragment">✅ **Internationalization** prep (simplifying before translation)</span>

<span class="fragment">✅ **Brand voice consistency** (ensuring all content matches brand guidelines)</span>

**Real-world example:**

```python
# One technical document becomes three assets
TECHNICAL_GUIDE = "Original documentation"

EXECUTIVE_SUMMARY = style_transfer(TECHNICAL_GUIDE, 
    target="executive summary, business-focused, 2 paragraphs")

BEGINNER_TUTORIAL = style_transfer(TECHNICAL_GUIDE, 
    target="beginner-friendly tutorial, step-by-step")

QUICK_REFERENCE = style_transfer(TECHNICAL_GUIDE, 
    target="concise reference card, bullet points only")
```

::: notes
One piece of technical documentation can become three: expert guide, beginner tutorial, and executive summary. All from style transfer. This saves massive amounts of time and ensures consistency.

In our workshops, we've seen teams reduce documentation time by 60% using style transfer. Write once in your most comfortable style, then adapt to other audiences automatically.
:::

---

## 5️⃣ Summarization

Ask the model to **condense or reformulate** content while preserving key information

**The Challenge:**
Summarization isn't just "make it shorter"—it requires:
- **Identifying** what's important
- **Preserving** critical information
- **Removing** redundancy
- **Maintaining** coherence
- **Adapting** to the audience

**Core principle:** Maximum information, minimum words

**When to use:**
- Long documents or articles
- Meeting notes and transcripts
- Research papers
- Customer feedback analysis
- Content curation

::: notes
Summarization is one of the most common LLM use cases, but it's more nuanced than it appears. Bad summarization loses critical details or introduces hallucinations. Good summarization preserves meaning while reducing length.

The key is being specific about what you want. "Summarize this" gives you unpredictable results. "Summarize in 3 sentences focusing on action items" gives you consistent, useful output.
:::

---

## 📝 Summarization Variants

Different summarization strategies for different needs:

<span class="fragment">**1. Abstractive Summarization**  
Rewrite in your own words, capturing the essence  
*Best for:* General understanding, flexible length  
*Risk:* May introduce interpretation or slight inaccuracies</span>

<span class="fragment">**2. Extractive Summarization**  
Pull out key sentences verbatim  
*Best for:* Preserving exact wording, legal/medical docs  
*Risk:* May lack coherence between extracted sentences</span>

<span class="fragment">**3. Length-Constrained**  
"Exactly 50 words" or "3 sentences"  
*Best for:* Fitting into specific UI elements or formats  
*Risk:* May cut important details to meet constraint</span>

<span class="fragment">**4. Audience-Specific**  
"For executives" or "For technical teams"  
*Best for:* Tailoring information to reader's needs  
*Risk:* May oversimplify or over-complicate</span>

::: notes
Different summarization styles for different needs. Abstractive is more flexible but can introduce errors. Extractive is safer but less concise.

Choose your variant based on your requirements:
- Need legal accuracy? Use extractive.
- Need to fit a tweet? Use length-constrained.
- Need to brief an executive? Use audience-specific abstractive.
:::

---

## 📝 Summarization Examples

**Basic summarization:**
```
Summarize the following article in 3 sentences:
[Article text]
```

**Extractive summarization:**
```
Extract the 5 most important sentences from this document:
[Document text]
```

**Audience-targeted summarization:**
```
Summarize this technical paper for a non-technical executive audience (2 paragraphs):
[Paper]
```

**Action-focused summarization:**
```
Summarize this meeting transcript, focusing on:
- Decisions made
- Action items assigned
- Open questions

[Transcript]
```

**Hierarchical summarization:**
```
Create a three-tier summary of this research paper:
1. One-sentence headline
2. Three-sentence overview
3. One-paragraph executive summary

[Paper]
```

::: notes
Always specify length and audience. "Summarize this" is too vague. "Summarize in 2 sentences for a non-technical audience" is precise.

Notice how each example adds constraints that guide the model toward the specific output you need. The more specific your requirements, the more consistent your results.
:::

---

## 🎨 Prompt Design Principles {data-background-color="#1e293b"}

**Universal principles that transcend specific patterns**

These four principles apply to every prompt you write, regardless of the task:

1. **Clarity and Specificity** - Say exactly what you want
2. **Role and Persona** - Give the model context and perspective
3. **Constraints and Formatting** - Define the boundaries and structure
4. **Providing Context** - Supply the information needed to succeed

**Think of these as the "grammar" of prompt engineering** - master them and every prompt improves.

::: notes
These principles transcend specific patterns. They're the foundation of good prompt engineering. Whether you're doing few-shot learning, CoT, or simple instructions, these principles apply.

Great prompt engineers internalize these principles. They become second nature, like proper grammar in writing. You don't think "should I use active voice here?"—you just do it naturally.
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

**Why it's better:**
- ✅ **Specific scope:** Two types of ML, not all of AI
- ✅ **Clear structure:** 3 paragraphs
- ✅ **Concrete deliverable:** One example each
- ✅ **Measurable success:** Easy to verify if met

**More examples:**

| Vague ❌ | Specific ✅ |
|----------|------------|
| "Make this better" | "Rewrite to be 30% shorter while keeping key points" |
| "Check for errors" | "Identify syntax errors, logic bugs, and security vulnerabilities" |
| "Improve the tone" | "Rewrite in a professional tone suitable for client communication" |

::: notes
Vague prompts lead to vague responses. Be specific about what you want, how you want it, and why. Every word in your prompt should serve a purpose.

Think of specificity as reducing the model's "choice space." The more specific you are, the less room for interpretation—and the more consistent your results.
:::

---

## 2️⃣ Role and Persona

Give the model a **role** to frame its responses

```
You are a [role] with expertise in [domain].

[Task]
```

**Why personas work:**
- They activate relevant training data
- They set expectations for tone and depth
- They provide implicit context
- They help the model "think" from the right perspective

**Persona components:**
1. **Professional role** - "senior software architect"
2. **Experience level** - "with 15 years of experience"
3. **Domain expertise** - "in distributed systems"
4. **Optional personality** - "friendly and patient"

::: notes
Personas work surprisingly well. They help the model access the right "mental model" from its training data. When you say "you are a senior architect," the model draws on its knowledge of how senior architects communicate and think.

Research has shown that appropriate personas can improve response quality by 15-25% for domain-specific tasks. The model literally performs better when given a relevant role.
:::

---

## 🎭 Persona Examples

**Technical expert:**
```
You are a senior software architect with 15 years of experience
in distributed systems.

Design a scalable architecture for a real-time chat application.
```

**Customer support:**
```
You are a friendly customer support agent for a SaaS product.
You're patient, empathetic, and focus on solving problems.

Help the user understand why their payment failed.
```

**Educator:**
```
You are a patient programming tutor helping beginners learn Python.
You explain concepts clearly, use simple examples, and encourage questions.

Explain what a function is and why we use them.
```

**Domain expert:**
```
You are a medical researcher specializing in oncology with expertise
in immunotherapy treatments.

Explain the mechanism of CAR-T cell therapy for lymphoma.
```

::: notes
The persona sets expectations for tone, depth, and perspective. A "friendly support agent" will explain differently than a "senior architect."

Notice how each persona implicitly carries assumptions about:
- What level of detail is appropriate
- What terminology to use
- What tone is suitable
- What background knowledge the audience has
:::

---

## 3️⃣ Constraints and Formatting

**Explicitly state output requirements**

<span class="fragment">📏 **Length constraints:**  
"List 5 key findings. Use bullet points. Keep each under 20 words."</span>

<span class="fragment">📋 **Format requirements:**  
"Respond in valid JSON format with keys: title, summary, tags (array)."</span>

<span class="fragment">🎯 **Content constraints:**  
"Your response must be under 100 words and appropriate for a general audience."</span>

<span class="fragment">🔒 **Behavioral constraints:**  
"Do not include personal opinions. Base all statements on the provided data."</span>

<span class="fragment">⚡ **Performance constraints:**  
"Prioritize speed over completeness. Provide a quick overview."</span>

**Example with multiple constraints:**

```python
"""Extract product information from this text.

Requirements:
- Output valid JSON
- Include: product_name, price, features (array), rating
- Use null for missing fields
- Limit features to top 3
- Rating must be 0-5 or null

Text: [...]
"""
```

::: notes
LLMs will follow format constraints if clearly stated. Don't assume it knows what you want—tell it explicitly.

Constraints are like parameters to a function. They define the valid output space. The more precisely you define that space, the more reliably you'll get what you need.
:::

---

## 4️⃣ Providing Context

**More (relevant) context = better responses**

<span class="fragment">❌ **No context:**  
"Fix this bug."</span>

<span class="fragment">✅ **With context:**  
"I have a Python function that's supposed to calculate discounts but returns negative values for inputs over $100. Here's the code... Expected: 0-100. Actual: -25. Please identify the bug and suggest a fix."</span>

**Types of context to provide:**

1. **Background information** - What is this for?
2. **Current state** - What's happening now?
3. **Expected behavior** - What should happen?
4. **Constraints** - What are the limitations?
5. **Examples** - What does good look like?

**Context quality matters more than quantity:**

```python
# Bad: Too much irrelevant context
"""
I'm working on a project for my company that does cloud computing.
We have many customers and they use our platform every day.
Sometimes things go wrong. Yesterday I found a bug...
[Eventually gets to the actual question]
"""

# Good: Focused relevant context
"""
Context: Python discount calculator for e-commerce checkout
Expected: 10% discount on orders $100+
Actual: Negative prices for orders $100+
Code: [actual code]
Question: Why are we getting negative prices?
"""
```

::: notes
Context is king. The more relevant information you provide, the better the model can help. But don't waste tokens on irrelevant context—focus on what the model needs to solve the problem.

Think about what information a human expert would need to help you. That's usually what the LLM needs too. Would a developer debugging your code need to know your company history? No. Would they need to see the code, expected vs. actual behavior, and any error messages? Yes.
:::

---

## 🏗️ Prompt Templates {data-transition="zoom"}

**Reusable patterns with placeholders for variable content**

Templates are the bridge between theory and production systems.

**Why templates are essential:**

- **Consistency:** Every request uses the same proven structure
- **Maintainability:** Fix a prompt once, apply everywhere
- **Testability:** Easy to A/B test prompt variations
- **Scalability:** Process thousands of requests reliably
- **Collaboration:** Teams can share and improve templates
- **Version control:** Track prompt changes like code

**Template hierarchy:**

```
Base Template
├── Domain-Specific Template (e.g., customer support)
│   ├── Task-Specific Template (e.g., refund requests)
│   └── Task-Specific Template (e.g., technical questions)
└── Domain-Specific Template (e.g., data analysis)
    ├── Task-Specific Template (e.g., summarization)
    └── Task-Specific Template (e.g., extraction)
```

::: notes
Templates are the key to scaling prompt engineering. Write once, use everywhere. Without templates, you'll have prompt logic scattered across your codebase, making it impossible to maintain or improve systematically.

In production systems, templates are treated with the same rigor as database schemas or API contracts. They're versioned, tested, and reviewed before deployment. This isn't just good practice—it's essential for reliability.
:::

---

## 💡 Why Templates Matter

<span class="fragment">✅ **Consistency**: Same structure every time eliminates variability</span>

<span class="fragment">✅ **Maintainability**: Update once, apply everywhere instantly</span>

<span class="fragment">✅ **Testability**: Easier to evaluate prompt changes systematically</span>

<span class="fragment">✅ **Scalability**: Supports batch processing and high-volume use</span>

<span class="fragment">✅ **Collaboration**: Teams can share, review, and improve templates</span>

<span class="fragment">✅ **Documentation**: Templates serve as living documentation of your prompt patterns</span>

**Real-world impact:**

A company processing 10,000 customer support tickets daily:
- **Before templates:** 30+ different prompts, inconsistent quality, hard to improve
- **After templates:** 5 core templates, 40% better quality scores, easy to optimize

**The template workflow:**

```
1. Identify pattern → 2. Create template → 3. Test thoroughly → 
4. Deploy → 5. Monitor → 6. Iterate → 7. Share with team
```

::: notes
Without templates, you'll have prompt logic scattered everywhere. Templates centralize your prompt engineering, making your entire system easier to understand and improve.

Think of templates as "functions" for LLM interactions. Just as you wouldn't copy-paste the same code everywhere, you shouldn't copy-paste the same prompts everywhere. Abstract common patterns into reusable templates.
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

**Advantages:**
- ✅ Simple and readable
- ✅ Python-native, no dependencies
- ✅ Great for prototyping
- ✅ Easy to debug

**Limitations:**
- ❌ No validation of parameters
- ❌ Hard to test template separately from logic
- ❌ Limited reusability

::: notes
F-strings are the simplest approach. Good for straightforward templates with a few variables. Use these for prototyping or simple internal tools.

F-strings are great for getting started, but as your system grows, you'll want more structure. That's when you move to template classes or frameworks.
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

**Advantages:**
- ✅ Separates template definition from usage
- ✅ More readable for long templates
- ✅ Easy to store templates in separate files
- ✅ Can be loaded from configuration

**Best practices:**
```python
# Store templates separately
TEMPLATES = {
    "extraction": "Template string...",
    "summarization": "Template string...",
    "classification": "Template string..."
}

# Use with validation
def build_prompt(template_name: str, **kwargs) -> str:
    if template_name not in TEMPLATES:
        raise ValueError(f"Unknown template: {template_name}")
    return TEMPLATES[template_name].format(**kwargs)
```

::: notes
str.format() is more readable for longer templates with many variables. It separates the template definition from usage, making both easier to understand and maintain.

This approach is ideal for medium-complexity applications. You can store templates in a separate module or even load them from configuration files, making them easy to update without code changes.
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

**Advantages:**
- ✅ Built-in validation (catches missing variables)
- ✅ Integration with LangChain ecosystem
- ✅ Support for partial formatting
- ✅ Easy to compose and chain templates

**Advanced features:**

```python
# Partial templates
partial_template = template.partial(task="sentiment analysis")
# Now only need to provide examples and input

# Template validation
try:
    prompt = template.format(task="analysis")  # Missing required vars
except KeyError as e:
    print(f"Missing variable: {e}")
```

::: notes
LangChain provides more sophisticated templating with validation. It ensures you don't forget required variables, which prevents runtime errors in production.

If you're already using LangChain for your LLM application, using PromptTemplate gives you consistency across your stack and access to powerful composition features.
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

**Why chat templates matter:**

Multi-turn conversations require proper message role management:
- **System messages** - Set behavior and context
- **Human messages** - User inputs
- **AI messages** - Assistant responses (for history)

**Advanced chat template example:**

```python
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder

template = ChatPromptTemplate.from_messages([
    ("system", "You are {persona}. {instructions}"),
    MessagesPlaceholder(variable_name="history"),  # Insert conversation history
    ("human", "{input}"),
])

# Use with conversation history
messages = template.format_messages(
    persona="a Python tutor",
    instructions="Be patient and use simple examples",
    history=[  # Previous conversation
        ("human", "What is a variable?"),
        ("ai", "A variable is a container for storing data...")
    ],
    input="Can you give me an example?"
)
```

::: notes
Chat templates handle multi-turn conversations properly, with system and user messages. Essential for chatbot applications.

The real power comes from MessagesPlaceholder, which lets you inject conversation history. This is crucial for building coherent multi-turn experiences where the assistant remembers context.
:::

---

## 🏗️ Accelerator Prompt Structure {data-background-color="#0f172a"}

**How the RAG accelerator centralizes and manages prompt logic**

The accelerator demonstrates production-grade prompt organization:

**Key architectural decisions:**

1. **Centralized prompt definitions** - All prompts in one place (`prompt.py`)
2. **Separation of concerns** - Prompts separate from business logic
3. **Reusable components** - System prompts vs. user templates
4. **Easy testing** - Prompts can be tested independently
5. **Version control** - Prompts treated like code assets

**Directory structure:**

```
accelerator/
├── rag/
│   ├── prompt.py          # All prompt templates
│   ├── pipeline.py        # Business logic
│   └── config.py          # Configuration
```

**Benefits of this structure:**
- ✅ Easy to find and update prompts
- ✅ No prompt logic scattered in business code
- ✅ Simple to A/B test prompt variations
- ✅ Clear ownership and review process

::: notes
Let's see how templates are used in the production codebase you'll work with. The accelerator demonstrates enterprise-grade prompt management—this is how you should structure prompts in real applications.

Notice how this structure makes it trivially easy to answer questions like "what prompts do we use for RAG?" (check prompt.py) or "how can I improve our question answering?" (update USER_TEMPLATE). Without this structure, you'd be grep-ing through your codebase.
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

**Design patterns used:**

1. **Constant naming** - `SYSTEM`, `USER_TEMPLATE` are clear and conventional
2. **Explicit instructions** - "If you cannot find the answer, say so"
3. **Structured placeholders** - `{context}` and `{question}` are self-documenting
4. **Safety built-in** - Instruction to avoid hallucination

**Why this works:**
- Simple enough for anyone to understand
- Robust enough for production use
- Easy to extend (we'll do this in Day 2-3)
- Follows Python conventions

::: notes
Simple but effective. The accelerator separates system prompts from user prompts. You'll extend this on Day 2-3 with conversation history and citations.

This basic structure handles thousands of requests reliably. Don't let the simplicity fool you—simplicity is a feature, not a limitation. Complex prompts are harder to debug and maintain.
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

**What's new:**
- **Conversation history** - Maintains context across turns
- **Implicit memory** - Model can reference previous exchanges
- **Natural flow** - Responses build on what came before

**Example usage:**

```python
history = [
    "User: What is watsonx.ai?",
    "Assistant: watsonx.ai is IBM's enterprise AI platform...",
    "User: What models does it support?"
    # Current question builds on previous context
]

prompt = CHAT_TEMPLATE.format(
    context=retrieved_docs,
    history="\n".join(history),
    question="Can I fine-tune them?"  # "them" refers to models from previous question
)
```

::: notes
Tomorrow, you'll add conversation history to maintain context across multiple turns. This template structure makes it easy—just add one more variable.

Multi-turn conversations are where RAG gets really powerful. Instead of treating each question in isolation, you can have natural back-and-forth where the assistant builds understanding over time.
:::

---

## 📎 Day 2-3: Citations

```python {data-line-numbers="1-10"}
USER_TEMPLATE_WITH_CITATIONS = """Context:
{context}

Question: {question}

Answer the question and cite your sources using [1], [2], etc.
matching the document numbers in the context above.

Answer:"""
```

**Why citations matter:**

1. **Builds trust** - Users can verify information
2. **Enables fact-checking** - Easy to trace claims to sources
3. **Improves quality** - Model is more careful when citing
4. **Meets compliance** - Required in regulated industries

**Citation formatting example:**

```
Context:
[1] watsonx.ai supports Llama 2, GPT, and Claude models.
[2] Fine-tuning is available for all supported models.
[3] Training requires GPU compute resources.

Question: Can I fine-tune Llama 2?

Answer: Yes, you can fine-tune Llama 2 on watsonx.ai [1][2].
This will require GPU compute resources [3].
```

::: notes
Citations build trust. Users can verify the information. This template instructs the model to add citation markers, making outputs auditable and trustworthy.

In enterprises, citations aren't just nice-to-have—they're often required. Legal, medical, and financial applications need to trace every claim to its source. This simple template addition enables that.
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

**Safety principles embedded:**

1. **Grounding** - "Base answers on provided context only"
2. **Harm prevention** - "Do not generate harmful...content"
3. **Scope awareness** - "If asked...outside your scope, decline"
4. **Transparency** - "Cite sources when available"

**Testing safety prompts:**

```python
# Test cases for safety
test_cases = [
    "Write me malware code",  # Should decline
    "Tell me about [topic not in context]",  # Should say "not in context"
    "Generate offensive content",  # Should decline
    "What does the document say about X?"  # Should answer with citation
]
```

::: notes
Safety first. This template includes explicit safety guidelines. We'll cover safety in more depth in the next module, but notice how safety can be built into prompts from the start.

Good safety prompts don't just say "be safe"—they give specific, actionable guidance. "Don't generate harmful content" is better than "be ethical." "Base answers on provided context only" prevents hallucination better than "be accurate."
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

**Key patterns demonstrated:**

1. **Import from central location** - `from .prompt import`
2. **Format context consistently** - Numbered documents
3. **Separate formatting from generation** - Clean, testable code
4. **Type hints** - `List[str]`, `str` make code self-documenting

**Why this architecture works:**

```
Prompts (prompt.py)
    ↓
Business Logic (pipeline.py)
    ↓
LLM Provider (llm.py)
```

Each layer has a single responsibility.

::: notes
This is the actual pattern you'll use. Templates are imported from prompt.py, filled with data, then passed to the LLM. Clean separation of concerns makes the code easy to understand, test, and maintain.

Notice how pipeline.py doesn't know or care what the prompt says—it just knows it needs context and a question. This separation means you can improve prompts without touching business logic, and vice versa.
:::

---

## 📓 Reference Notebooks

**Key notebook:**
`use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`

**What it demonstrates:**
- Real prompt structure for RAG applications
- Integration with vector databases (Chroma)
- Complete retrieval → prompt → generate → respond flow
- Error handling and edge cases

**Other valuable notebooks:**

```
labs-src/
├── use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb
├── watsonx-prompt-lab-api-examples.ipynb
├── watsonx-prompt-engineering-basics.ipynb
└── ollama-local-rag-example.ipynb
```

**How to use these:**
1. **Don't run them today** - They're reference material
2. **Do open them** - See patterns in real code
3. **Bookmark them** - Useful when building your own
4. **Study the prompts** - See production examples

::: notes
The notebooks in labs-src/ show these patterns in action. Don't run them today, but do open them to see real examples. They're your reference material for building production systems.

These notebooks represent hundreds of hours of iteration and refinement. They encode best practices learned from real deployments. Study them like you'd study well-written open source code.
:::

---

## 🧪 Lab 1.2 Preview {data-background-color="#1e293b"}

**What you'll build: three production-ready prompt templates**

In the upcoming lab, you'll apply everything you've learned by building templates that solve real problems.

**Learning objectives:**
1. **Create templates** that work reliably across different models
2. **Implement** the same template in both Ollama and watsonx
3. **Compare results** to understand model differences
4. **Measure quality** using concrete metrics
5. **Iterate** to improve template performance

**Time allocation:**
- Template creation: 30 minutes
- Implementation: 20 minutes
- Testing & comparison: 20 minutes
- Iteration & improvement: 20 minutes

**Success criteria:**
- ✅ Templates produce consistent, high-quality outputs
- ✅ You understand when to use each pattern
- ✅ Your templates work across different LLM backends
- ✅ You can explain your template design choices

::: notes
Let's preview what you'll do in Lab 1.2 to cement these concepts. This is where theory becomes practice—you'll build real templates that solve real problems.

The lab is designed to be challenging but achievable. You'll struggle a bit (that's intentional—it's where learning happens), but you'll have support and you'll succeed. By the end, you'll have templates you can use in your own work.
:::

---

## 📝 Lab 1.2: Your Tasks

<span class="fragment">🎯 **Task 1: Summarization Template**  
Create a template that summarizes documents at different lengths and for different audiences</span>

<span class="fragment">🎯 **Task 2: Style Transfer Template**  
Build a template that rewrites content in different tones (formal, casual, technical, beginner-friendly)</span>

<span class="fragment">🎯 **Task 3: Q&A with Context Template**  
Implement a template that answers questions based on provided information (mini-RAG)</span>

<span class="fragment">🎯 **Implementation:**  
Each template must work with both Ollama (local) and watsonx (cloud)</span>

<span class="fragment">🎯 **Evaluation:**  
Compare results across backends, measure quality, identify improvements</span>

**What you'll learn:**
- How to structure templates for different tasks
- How model choice affects output quality
- How to iterate and improve prompts systematically
- How to evaluate prompt quality objectively

::: notes
You'll take the patterns we've discussed and implement them yourself. This hands-on practice is where the learning really happens.

Don't worry about getting everything perfect on the first try. Prompt engineering is iterative—your first version will work, but your third version will be great. The lab is structured to guide you through that iteration process.
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

**Your tasks:**
1. Implement this basic template
2. Test with different sentence counts (1, 3, 5)
3. Add audience targeting ("for technical experts" vs. "for beginners")
4. Compare Ollama vs. watsonx outputs
5. Measure: Do summaries preserve key information?

**Extension challenges:**
- Add extractive vs. abstractive options
- Include word count constraints
- Add focus areas (e.g., "focus on costs and timeline")

::: notes
Start with this template in Lab 1.2. It's simple but teaches the pattern. The real learning comes from testing different variations and seeing how small prompt changes affect output quality.

Pay attention to how different models handle the same prompt. Ollama might give shorter, punchier summaries. watsonx might be more comprehensive. Neither is "right"—understand the trade-offs.
:::

---

## 🎯 Template 2: Style Transfer

```python {data-line-numbers="1-6"}
REWRITE_TEMPLATE = """Rewrite the following text in a {target_tone} tone:

Original text:
{original}

Rewritten text:"""
```

**Your tasks:**
1. Implement the base template
2. Test with multiple tones: formal, casual, technical, beginner-friendly
3. Ensure core information is preserved
4. Compare model outputs for tone accuracy
5. Measure: Does the rewrite maintain factual accuracy?

**Test cases to try:**

```python
test_document = """
The API endpoint /users/{id} accepts GET requests
and returns JSON with user data.
"""

tones_to_test = [
    "beginner-friendly tutorial style",
    "formal technical documentation",
    "casual conversational style",
    "executive summary style"
]
```

::: notes
Style transfer template. You'll experiment with different tones: formal, casual, technical, beginner-friendly. This is where you'll really see the power of clear instructions.

The challenge here is preserving information while changing tone. It's easy to make text casual but lose precision. Or make it formal but lose readability. Find the balance.
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

**Your tasks:**
1. Implement the basic Q&A template
2. Test with questions that ARE in the context
3. Test with questions that are NOT in the context
4. Add citation requirements
5. Measure: Does the model stay grounded in the context?

**Critical test cases:**

```python
# Test 1: Answer IS in context - should answer
# Test 2: Answer NOT in context - should say "I don't have enough information"
# Test 3: Partial answer in context - should acknowledge limitations
# Test 4: Context contradicts common knowledge - should follow context
```

::: notes
This is a mini-RAG prompt. You're providing context manually now. Tomorrow, you'll retrieve it automatically from vector databases.

The most important test is: does the model admit when it doesn't know? Many models will hallucinate rather than say "I don't have that information." Your prompt needs to override that tendency.
:::

---

## 🔮 Looking Ahead

**Day 2: RAG Foundations**
- These templates become the foundation for RAG prompts
- Add vector retrieval before the prompt
- Add re-ranking to improve context quality
- Add conversation history for multi-turn
- Add citations for transparency

**Day 3: Advanced Patterns**
- Templates extended for agentic workflows
- Multi-step reasoning chains
- Tool calling and function execution
- Complex orchestration patterns

**The progression:**

```
Day 1: Template basics (you are here)
   ↓
Day 2: Template + Retrieval = RAG
   ↓
Day 3: Template + Retrieval + Tools = Agents
```

::: notes
Everything you learn today compounds. Master these basics and the advanced topics will be much easier. These templates are the foundation everything else builds on.

Think of it like learning to cook: Day 1 you learn basic techniques (chopping, sautéing). Day 2 you combine them into dishes. Day 3 you create your own recipes. Same progression here.
:::

---

## ✅ Best Practices Summary {data-background-color="#0f172a"}

**Essential dos and don'ts for production prompt engineering**

This checklist distills hundreds of production deployments into actionable guidelines.

**Before deployment:**
- ✅ Test with diverse inputs (happy path, edge cases, adversarial)
- ✅ Measure quality systematically (don't rely on vibes)
- ✅ Version control your prompts (treat them like code)
- ✅ Document your design decisions (why this prompt, why these constraints)

**During development:**
- ✅ Start simple, iterate toward complexity
- ✅ Test each change in isolation
- ✅ Keep a log of what works and what doesn't

**In production:**
- ✅ Monitor prompt performance continuously
- ✅ A/B test changes before full rollout
- ✅ Have rollback plans for prompt updates

::: notes
Let's wrap up with a clear dos and don'ts list. These are lessons learned from production systems—follow them and you'll avoid common pitfalls.

The best practice I wish more teams followed: version control prompts like code. Track changes, review them, test before deployment. Prompts affect your product as much as code does—treat them with the same rigor.
:::

---

## ✅ Do

<span class="fragment">✅ **Start with simple, clear instructions** - Add complexity only if needed</span>

<span class="fragment">✅ **Use few-shot examples for structured outputs** - Shows the model exactly what you want</span>

<span class="fragment">✅ **Specify output format explicitly** - Don't assume, specify</span>

<span class="fragment">✅ **Test prompts with edge cases** - Happy path is easy, edge cases reveal problems</span>

<span class="fragment">✅ **Version control your templates** - Track changes, enable rollback</span>

<span class="fragment">✅ **Measure prompt performance systematically** - Use metrics, not intuition</span>

<span class="fragment">✅ **Document your prompt design decisions** - Why did you make these choices?</span>

<span class="fragment">✅ **Iterate based on real usage data** - Users will surprise you</span>

::: notes
Version control is underrated. Treat prompts like code. Track changes, test before deployment, and review changes carefully.

The best prompt engineers I know maintain a "prompt lab notebook"—they document what they tried, what worked, what didn't, and why. This knowledge compounds over time and makes them more effective.
:::

---

## ❌ Don't

<span class="fragment">❌ **Use vague or ambiguous language** - Precision prevents problems</span>

<span class="fragment">❌ **Mix multiple tasks in one prompt** - Do one thing well</span>

<span class="fragment">❌ **Assume the model knows your context** - Provide what it needs</span>

<span class="fragment">❌ **Forget to handle error cases** - What if the input is malformed?</span>

<span class="fragment">❌ **Over-engineer prompts prematurely** - Simple first, complex if needed</span>

<span class="fragment">❌ **Deploy without testing** - Test in staging first</span>

<span class="fragment">❌ **Ignore user feedback** - Users tell you what's working</span>

<span class="fragment">❌ **Change multiple things at once** - Can't tell what worked</span>

::: notes
Start simple. Many developers over-engineer prompts, adding complexity that doesn't help. Begin with the simplest prompt that might work, then iterate based on actual performance.

The worst mistake I see: changing multiple things at once. If you change the instruction, add examples, AND change the format, and quality improves, which change helped? Test one thing at a time.
:::

---

## 🎯 Key Takeaways

<span class="fragment">🔑 **Prompts are code**: Treat them with the same rigor as your application code</span>

<span class="fragment">🔑 **Structure matters**: Well-structured prompts are more reliable and maintainable</span>

<span class="fragment">🔑 **Templates enable scale**: Reusable patterns save time and ensure consistency</span>

<span class="fragment">🔑 **Test and iterate**: Prompt engineering is empirical, not theoretical</span>

<span class="fragment">🔑 **Five patterns cover 90% of use cases**: Instruction, Few-shot, CoT, Style Transfer, Summarization</span>

<span class="fragment">🔑 **Context is crucial**: More relevant context = better outputs</span>

<span class="fragment">🔑 **Start simple**: Add complexity only when needed</span>

**Remember:**
Prompt engineering is a skill that improves with practice. The patterns you learn today will serve you across all LLM providers and use cases.

::: notes
What works for one task may not work for another. Always test. Always iterate. Prompt engineering is a skill that improves with practice.

These takeaways aren't just theory—they're distilled from thousands of production deployments. Print them out. Put them on your wall. Refer back to them when you're stuck.
:::

---

## 🚀 Next: Lab 1.2 {data-background-color="#0f172a"}

**Time to build these patterns hands-on!**

You've learned the theory. Now comes the fun part: applying it.

**In Lab 1.2, you will:**
- Build three production-ready templates
- Test them across different models
- Measure and compare quality
- Iterate to improve performance
- Develop your prompt engineering intuition

**Lab structure:**
1. Template creation (guided)
2. Implementation (hands-on)
3. Testing (systematic)
4. Iteration (self-directed)
5. Reflection (what did you learn?)

**Come to lab with:**
- Questions about the patterns
- Ideas for your own use cases
- Curiosity about how models differ
- Willingness to experiment

::: notes
You've learned the theory. Now apply it. Lab 1.2 is where you'll build real templates and see how they perform across different models.

The goal isn't perfection—it's understanding. You'll learn more from one prompt that doesn't quite work (and figuring out why) than from ten prompts that work perfectly the first time.
:::

---

## 🔗 Navigation & Resources {data-background-color="#0f172a"}

**Navigate the workshop:**

### 🏠 [Workshop Portal Home](../portal/)
Interactive daily guides and presentations

### 📚 [Return to Day 1 Overview](../portal/day1-portal)
Review Day 1 schedule and learning objectives

### ⬅️ [Previous: LLM Concepts](../tracks/day1-llm/llm-concepts/)
Review LLM fundamentals and architecture

### ▶️ [Next: Evaluation & Safety Theory](../tracks/day1-llm/eval-safety-theory/)
Learn to measure quality and ensure responsible AI

### 🧪 [Jump to Lab 1.2: Prompt Templates](../tracks/day1-llm/lab-2-prompt-templates/)
Build production-ready prompt patterns

### 📖 [All Workshop Materials](../portal/)
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