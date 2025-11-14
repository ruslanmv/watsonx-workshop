# 🧠 LLM Concepts & Architecture

Welcome to Day 1 of the watsonx Workshop!

::: notes
Welcome students warmly. Set the tone for an engaging day. Mention that by the end of this module, they'll understand what makes LLMs tick and how to deploy them effectively.
:::

---

### Tutor

**Ruslan Idelfonso Magana Vsevolodovna**  
*PhD in Physics · AI Engineer*  

📧 [contact@ruslamv.com](mailto:contact@ruslamv.com)

<p style="text-align:right; margin-top:1.5rem;">
  <img
    src="https://raw.githubusercontent.com/ruslanmv/watsonx-workshop/refs/heads/master/themes/assets/tutor.png"
    alt="Tutor: Ruslan Idelfonso Magana Vsevolodovna"
    style="
      border-radius:50%;
      width:130px;
      height:130px;
      object-fit:cover;
      box-shadow:0 12px 30px rgba(0,0,0,0.45);
      border:3px solid rgba(248,250,252,0.9);
    "
  >
</p>

---


## 🎯 Learning Objectives {data-background-color="#0f172a"}

By the end of this module, you will:

<span class="fragment">✅ Understand core LLM terminology and constraints</span>

<span class="fragment">✅ Compare local vs managed LLM deployment models</span>

<span class="fragment">✅ Know how LLMs fit into production architectures</span>

<span class="fragment">✅ Understand key parameters that control model behavior</span>

::: notes
These are the concrete skills students will gain. Emphasize that this is practical knowledge they can apply immediately.
:::

---

## 🤔 What is a Large Language Model?

A **Large Language Model (LLM)** is a neural network trained on vast amounts of text data.

<span class="fragment">Think of it as a powerful **pattern-matching engine**</span>

<span class="fragment">It has learned statistical relationships between words, phrases, and concepts</span>

::: notes
Keep this high-level. Avoid diving into neural network architecture. Focus on the practical understanding: LLMs predict what text comes next based on patterns learned from training data.
:::

---

## 📊 Scale Matters

**LLMs contain billions of parameters**

<span class="fragment">🔹 GPT-3: **175 billion** parameters</span>

<span class="fragment">🔹 Llama 3.2: **1-3 billion** parameters (smaller variants)</span>

<span class="fragment">🔹 Granite 13B: **13 billion** parameters</span>

::: notes
Parameters are like the "knobs" that encode knowledge. More parameters generally mean better capabilities, but also higher computational costs. Granite 13B is a sweet spot for enterprise use.
:::

---

## 📚 Training Data Sources

Modern LLMs are trained on diverse text:

<span class="fragment">📖 Books, articles, and documentation</span>

<span class="fragment">🌐 Web pages and forums</span>

<span class="fragment">💻 Code repositories</span>

<span class="fragment">🔬 Scientific papers</span>

::: notes
The diversity of training data is what makes LLMs versatile. However, this also means they can reflect biases present in the training data. We'll discuss safety later.
:::

---

## 🚀 What Can LLMs Do?

<span class="fragment">✅ Answer questions</span>

<span class="fragment">✅ Summarize documents</span>

<span class="fragment">✅ Write code</span>

<span class="fragment">✅ Translate languages</span>

<span class="fragment">✅ Extract structured information</span>

<span class="fragment">✅ Reason through problems (with varying success)</span>

::: notes
Emphasize "varying success" on reasoning. LLMs are powerful but not perfect. They excel at pattern matching but can struggle with true logical reasoning, especially on novel problems.
:::

---

## 🔤 Tokens & Tokenization {data-transition="zoom"}

LLMs don't work with **words**—they work with **tokens**

<span class="fragment">A token is a sub-unit of text the model processes</span>

::: notes
This is a critical concept. Many beginners think LLMs process whole words. Understanding tokenization is key to working with context windows and API costs.
:::

---

## 🧩 Token Examples

<span class="fragment">**"Hello"** → 1 token</span>

<span class="fragment">**"watsonx.ai"** → 2-3 tokens (depends on tokenizer)</span>

<span class="fragment">**"AI"** → 1 token</span>

<span class="fragment">A space or punctuation can be its own token</span>

::: notes
Show that tokenization isn't always intuitive. Special characters, URLs, and domain-specific terms often split into multiple tokens.
:::

---

## ⚠️ Why Tokens Matter

<span class="fragment">📏 Models have **token limits** (context windows)</span>

<span class="fragment">💰 API costs are calculated **per token**</span>

<span class="fragment">✂️ Long documents need **chunking** to fit token limits</span>

<span class="fragment">📐 **Rule of thumb**: ~4 characters per token (English)</span>

::: notes
Token limits are hard constraints. Exceeding them causes truncation or errors. When building applications, always estimate token counts before API calls.
:::

---

## 🪟 Context Window

The **context window** is the maximum number of tokens a model can process at once

<span class="fragment">Includes both: **Your input (prompt)** + **Model's output**</span>

::: notes
This is bidirectional. If you use a long prompt, you have less space for the response. Plan accordingly.
:::

---

## 📏 Common Context Window Sizes

<span class="fragment">**Llama 3.2 (1B)**: 128K tokens</span>

<span class="fragment">**Granite 13B**: 8K tokens (some variants)</span>

<span class="fragment">**GPT-4**: 8K-32K tokens (version dependent)</span>

::: notes
Newer models are trending toward larger context windows. 128K is enormous—enough for short novels! But most enterprise use cases work fine with 8K.
:::

---

## ✂️ Truncation Risks

If your input exceeds the context window:

<span class="fragment">🔴 Missing important context</span>

<span class="fragment">🔴 Incomplete responses</span>

<span class="fragment">🔴 Errors</span>

<span class="fragment">**Best practice**: Always check token counts before sending prompts</span>

::: notes
Truncation is silent and dangerous. The model won't tell you it couldn't see part of your prompt. Always validate token counts in production systems.
:::

---

## 🌡️ Temperature {data-background-color="#1e293b"}

Controls the **randomness** and **creativity** of model outputs

Range: **0.0 to 2.0**

::: notes
Temperature is one of the most important parameters. Understanding it is essential for getting the behavior you want.
:::

---

## ❄️ Low Temperature (0.0-0.3)

**Deterministic and focused**

<span class="fragment">✅ Use for: Code generation, factual Q&A, structured outputs</span>

<span class="fragment">📊 Output: Consistent, predictable</span>

::: notes
At temperature 0.0, the model always picks the most probable next token. This gives you the same (or very similar) response every time. Great for production where consistency matters.
:::

---

## 🌤️ Medium Temperature (0.7-1.0)

**Balanced creativity**

<span class="fragment">✅ Use for: General conversation, content generation</span>

<span class="fragment">📊 Output: Varied but coherent</span>

::: notes
This is the default for most conversational AI. It provides variety while maintaining coherence. Good for chatbots and general assistance.
:::

---

## 🔥 High Temperature (1.5-2.0)

**Very creative, less predictable**

<span class="fragment">✅ Use for: Creative writing, brainstorming</span>

<span class="fragment">📊 Output: Diverse, sometimes surprising</span>

::: notes
High temperatures can produce unexpected results. Use sparingly. Good for creative tasks but risky for factual or structured outputs.
:::

---

## 🌡️ Temperature Example

```python
# Temperature = 0.0
"The capital of France is Paris."

# Temperature = 1.5
"The capital of France? Ah, the City of Light—Paris!
Known for its cafes, the Eiffel Tower, and rich history..."
```

::: notes
Same question, different temperatures. Notice how low temperature is direct, while high temperature adds creative flair.
:::

---

## 🎲 Top-k Sampling

Limits the model to choose from the **top-k most probable** next tokens

<span class="fragment">**Low k (1-10)**: Very focused, less diverse</span>

<span class="fragment">**High k (50-100)**: More diverse options</span>

::: notes
Top-k is less commonly adjusted than temperature. It's another way to control randomness. Useful when you want to restrict the model's vocabulary to highly probable choices.
:::

---

## 🎯 Top-p (Nucleus Sampling)

Dynamically selects from the **smallest set of tokens** whose cumulative probability exceeds **p**

<span class="fragment">**Low p (0.1-0.5)**: Conservative, focused</span>

<span class="fragment">**High p (0.9-0.95)**: More diverse</span>

::: notes
Top-p is more adaptive than top-k. It adjusts the candidate set based on the probability distribution. Most modern systems use top-p rather than top-k.
:::

---

## ⚙️ Typical Parameter Settings

**Factual tasks:**
```python
temperature=0.2, top_p=0.1
```

**Creative tasks:**
```python
temperature=0.9, top_p=0.9
```

::: notes
These are good starting points. In the labs, students will experiment with these parameters to see the effects firsthand.
:::

---

## ⏱️ Latency & Throughput

<span class="fragment">**Latency**: Time from request to complete response</span>

<span class="fragment">**Throughput**: Number of requests per unit time</span>

<span class="fragment">**Trade-offs**: Lower latency often means lower throughput</span>

::: notes
For user-facing applications, latency is critical. For batch processing, throughput matters more. You can't optimize for both simultaneously.
:::

---

## 🎛️ Factors Affecting Performance

<span class="fragment">🔹 **Model size**: Larger models = slower inference</span>

<span class="fragment">🔹 **Batch size**: Processing multiple requests together improves throughput</span>

<span class="fragment">🔹 **Hardware**: GPUs provide 10-100x faster inference than CPUs</span>

::: notes
Model size is the biggest factor. A 70B parameter model is significantly slower than a 7B model, even with the same hardware.
:::

---

## 🏠 Local vs Managed LLMs {data-background-color="#0f172a" data-transition="slide"}

Two main deployment options:

<span class="fragment">**Local**: Run on your own infrastructure</span>

<span class="fragment">**Managed**: Use cloud APIs</span>

::: notes
This is a critical architectural decision. Each has pros and cons. We'll explore both in depth.
:::

---

## 🖥️ Local LLMs (e.g., Ollama)

Running models on **your own infrastructure**

<span class="fragment">(Laptop, on-prem servers, private cloud)</span>

::: notes
Ollama is our example tool for local deployment. It's beginner-friendly and works well for development. Other options include LM Studio and vLLM.
:::

---

## ✅ Local LLMs: Pros

<span class="fragment">🔒 **Privacy**: Data never leaves your environment</span>

<span class="fragment">🎯 **Control**: Full control over model versions</span>

<span class="fragment">💵 **Cost**: No per-token charges after setup</span>

<span class="fragment">🔧 **Customization**: Can fine-tune models</span>

<span class="fragment">📡 **Offline**: Works without internet</span>

::: notes
Privacy is the #1 reason enterprises choose local deployment. If you're handling sensitive data (healthcare, finance), local deployment is often required.
:::

---

## ❌ Local LLMs: Cons

<span class="fragment">💻 **Hardware**: Need GPUs for acceptable performance</span>

<span class="fragment">🔧 **Maintenance**: You manage everything</span>

<span class="fragment">📏 **Scale**: Constrained by your hardware</span>

<span class="fragment">🎛️ **Model selection**: Limited to what fits in your hardware</span>

::: notes
The biggest barrier is hardware. A good GPU costs thousands of dollars. For teams without GPU infrastructure, local deployment can be challenging.
:::

---

## 🏢 Best Use Cases for Local LLMs

<span class="fragment">🧪 Prototyping and development</span>

<span class="fragment">🔒 Privacy-sensitive applications</span>

<span class="fragment">🏗️ Organizations with existing GPU infrastructure</span>

<span class="fragment">📊 Small to medium workloads</span>

::: notes
Local is great for "getting started" and for specific use cases. If you need to scale to thousands of concurrent users, managed services are usually better.
:::

---

## ☁️ Managed LLMs (e.g., watsonx.ai)

Using LLMs via **cloud APIs**

<span class="fragment">Provider handles all infrastructure</span>

::: notes
watsonx.ai is IBM's enterprise AI platform. It offers Granite models with built-in governance features.
:::

---

## ✅ Managed LLMs: Pros

<span class="fragment">📈 **Scale**: Handle any workload, automatic scaling</span>

<span class="fragment">🛡️ **Governance**: Built-in compliance, audit trails</span>

<span class="fragment">📚 **Model catalog**: Access to multiple models</span>

<span class="fragment">📜 **SLAs**: Guaranteed uptime and performance</span>

<span class="fragment">🔄 **No maintenance**: Provider handles everything</span>

::: notes
For production at scale, managed services are hard to beat. You get enterprise features out of the box.
:::

---

## ❌ Managed LLMs: Cons

<span class="fragment">💰 **Cost**: Pay per token (can add up)</span>

<span class="fragment">🔒 **Data privacy**: Data sent to cloud</span>

<span class="fragment">⏱️ **Latency**: Network overhead for each request</span>

<span class="fragment">🎯 **Less control**: Dependent on provider</span>

::: notes
Cost can be a concern at very high volumes. However, when you factor in infrastructure costs for local deployment, managed services are often competitive.
:::

---

## 🏢 Best Use Cases for Managed LLMs

<span class="fragment">🚀 Production applications at scale</span>

<span class="fragment">👥 Teams without ML infrastructure expertise</span>

<span class="fragment">📋 Regulated industries needing governance</span>

<span class="fragment">🎨 Applications requiring multiple models</span>

::: notes
If you're building for production and don't have a dedicated ML infrastructure team, start with managed services. You can always move to local later if needed.
:::

---

## 💰 Cost Considerations {data-background-color="#1e293b"}

Understanding the economics of LLM deployment

::: notes
Cost is often a deciding factor. Let's break down the dimensions.
:::

---

## 🖥️ GPU vs CPU

**GPU (Graphics Processing Unit)**:
<span class="fragment">⚡ 10-100x faster than CPU for LLMs</span>
<span class="fragment">💵 $1,000 - $10,000+ per card</span>

**CPU (Central Processing Unit)**:
<span class="fragment">🐢 Can run small models (1-3B parameters)</span>
<span class="fragment">💵 Cheaper, already available</span>

::: notes
For anything beyond toy models, you need a GPU. CPUs are fine for development with very small models, but not for production.
:::

---

## 💾 Memory Requirements

**Rule of thumb**: Model needs ~2 bytes per parameter (FP16)

<span class="fragment">**Example**: 13B model needs ~26 GB GPU memory</span>

::: notes
This is why you can't run large models on consumer GPUs. A 70B model needs ~140GB of memory, which requires multiple enterprise GPUs.
:::

---

## ☁️ Cloud Pricing Model

**Token-based pricing:**

<span class="fragment">📥 Input tokens: Text you send</span>

<span class="fragment">📤 Output tokens: Text generated</span>

<span class="fragment">💲 Typically: $0.0001 - $0.001 per token</span>

::: notes
Pricing varies by model and provider. Larger, more capable models cost more per token.
:::

---

## 💵 Example Cost Calculation

```python
Prompt: 1,000 tokens
Response: 500 tokens
Cost: (1000 + 500) × $0.0002 = $0.30 per request
```

<span class="fragment">For 10,000 requests/day: **$3,000/day** or **~$90,000/month**</span>

::: notes
Costs can add up quickly at scale. This is why optimization matters: smaller prompts, shorter responses, caching, etc.
:::

---

## 🎯 Cost Optimization Strategies

<span class="fragment">📉 Use **smaller models** when appropriate</span>

<span class="fragment">💾 **Cache** common responses</span>

<span class="fragment">🗜️ Implement **prompt compression**</span>

<span class="fragment">📦 Use **batch processing** for non-real-time workloads</span>

<span class="fragment">🎚️ Set **max_tokens** limits</span>

::: notes
Don't use a 70B model when a 7B model will do. Always set max_tokens to prevent runaway generation. Caching can reduce costs by 50-80% for common queries.
:::

---

## 🏗️ Accelerator Architecture {data-transition="zoom"}

Where does the LLM fit in a production system?

::: notes
Let's connect what we've learned to the actual codebase you'll be working with. This is the RAG Accelerator.
:::

---

## 📁 Accelerator Structure

```
accelerator/
├── rag/              # RAG core logic
├── service/          # Production API
├── tools/            # CLI utilities
├── ui/               # User interface
└── config.yaml       # Configuration
```

::: notes
The accelerator is organized by function. Today we focus on the LLM layer. Tomorrow we add retrieval.
:::

---

## 🧩 Key Components

<span class="fragment">**rag/pipeline.py**: Orchestrates retrieval + LLM</span>

<span class="fragment">**rag/prompt.py**: Shared prompt templates</span>

<span class="fragment">**service/api.py**: FastAPI microservice</span>

<span class="fragment">**tools/eval_small.py**: Evaluation harness</span>

::: notes
These are the files you'll be editing on Days 2 and 3. Today, we're focusing on understanding the LLM building block.
:::

---

## 🔄 Day 1 Architecture (No RAG)

```python {data-line-numbers="1-4"}
def answer_question(question: str) -> str:
    # Direct LLM call
    response = llm.generate(prompt=question)
    return response
```

::: notes
This is where we are today: direct LLM calls with no retrieval. Simple but limited.
:::

---

## 🔄 Day 2-3 Architecture (With RAG)

```python {data-line-numbers="1-11"}
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

::: notes
Tomorrow, we add retrieval. The LLM call is the same—we just give it better context. This is the power of RAG.
:::

---

## 🔗 Integration Points

<span class="fragment">**1. Model Selection** (`service/deps.py`)</span>

<span class="fragment">**2. Prompt Engineering** (`rag/prompt.py`)</span>

<span class="fragment">**3. Response Handling** (`rag/pipeline.py`)</span>

::: notes
These are the files where your LLM knowledge will be applied. Understanding the concepts from today's session will help you work with these components effectively.
:::

---

## 📚 Reference Notebooks

The workshop includes reference notebooks:

<span class="fragment">📘 `use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`</span>

<span class="fragment">📘 `QnA_with_RAG.ipynb`</span>

::: notes
You don't need to run these today. But open them to see how LLMs are called in production contexts. They show prompt structure, error handling, and integration patterns.
:::

---

## 🧪 Today's Labs {data-background-color="#0f172a"}

### Lab 1.1: Quickstart

<span class="fragment">🎯 Basic LLM calls in both Ollama and watsonx</span>

<span class="fragment">🎯 Parameter tuning (temperature, max_tokens)</span>

<span class="fragment">🎯 No retrieval—just prompts → responses</span>

::: notes
Lab 1.1 is your chance to get hands-on with what we've discussed. You'll see temperature effects, token limits, and latency differences firsthand.
:::

---

## 📋 Lab 1.2: Prompt Templates

<span class="fragment">🎯 Build reusable prompt patterns</span>

<span class="fragment">🎯 Compare behavior across backends</span>

::: notes
Templates are critical for production. You'll learn to build them in Lab 1.2.
:::

---

## 📊 Lab 1.3: Micro-Evaluation

<span class="fragment">🎯 Rate LLM outputs systematically</span>

<span class="fragment">🎯 Build a simple evaluation framework</span>

::: notes
You can't improve what you don't measure. Lab 1.3 introduces evaluation, which is essential for production LLM systems.
:::

---

## 🗺️ Learning Progression

**Day 1** = Understanding the LLM building block

**Day 2** = LLM + retrieval (RAG)

**Day 3** = LLM + retrieval + orchestration (agents)

::: notes
Each day builds on the previous. Today's foundation is critical for success on Days 2 and 3.
:::

---

## 📖 Further Reading

<span class="fragment">📘 [IBM Granite Models](https://www.ibm.com/granite/docs)</span>

<span class="fragment">📘 [watsonx.ai Documentation](https://www.ibm.com/docs/en/watsonx-as-a-service)</span>

<span class="fragment">📘 [Ollama Documentation](https://ollama.com/docs)</span>

<span class="fragment">📘 [OpenAI Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)</span>

::: notes
These resources are excellent for deeper dives. Bookmark them for reference.
:::

---

## ✅ Summary {data-background-color="#0f172a"}

You now understand:

<span class="fragment">✅ What LLMs are and how they work</span>

<span class="fragment">✅ Key concepts: tokens, context windows, temperature</span>

<span class="fragment">✅ Trade-offs between local and managed deployments</span>

<span class="fragment">✅ Cost considerations for LLM applications</span>

<span class="fragment">✅ How LLMs fit into the accelerator architecture</span>

::: notes
Congratulations! You've completed the LLM concepts module. Take a short break, then we'll dive into prompt patterns.
:::

---

## 🚀 Next: Lab 1.1

Let's get hands-on and actually run some prompts!

::: notes
Transition to the lab. Make sure everyone has their environments set up before starting.
:::