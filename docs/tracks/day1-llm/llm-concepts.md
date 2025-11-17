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

A **Large Language Model (LLM)** is a neural network trained on vast amounts of text data to understand and generate human-like text.

<span class="fragment">Think of it as a powerful **pattern-matching engine** that has learned the statistical relationships between words, phrases, and concepts from billions of text examples.</span>

<span class="fragment">It doesn't "understand" in the human sense—it predicts the most likely next word based on patterns it learned during training.</span>

<span class="fragment">**Key insight**: LLMs are fundamentally prediction machines that excel at continuing patterns they've seen before.</span>

::: notes
Keep this high-level but add more context than before. Emphasize that LLMs are sophisticated pattern matchers, not truly "intelligent" systems. This understanding helps students set realistic expectations and debug issues later.
:::

---

## 📊 Scale Matters

**LLMs contain billions of parameters**—the "knobs" that encode learned knowledge

<span class="fragment">🔹 **GPT-3**: 175 billion parameters (2020)</span>

<span class="fragment">🔹 **Llama 3.2**: 1-3 billion parameters (efficient variants)</span>

<span class="fragment">🔹 **Granite 13B**: 13 billion parameters (enterprise sweet spot)</span>

<span class="fragment">**Why it matters**: More parameters generally mean better capabilities, but also exponentially higher computational costs and memory requirements.</span>

<span class="fragment">**Trade-off**: A 13B model can run on a single GPU, while a 175B model requires multiple enterprise GPUs in parallel.</span>

::: notes
Parameters are like the "knobs" that encode knowledge. More parameters generally mean better capabilities, but also higher computational costs. Granite 13B is a sweet spot for enterprise use—powerful enough for complex tasks, small enough to run efficiently.
:::

---

## 📚 Training Data Sources

Modern LLMs are trained on diverse text corpora, typically measured in **terabytes**:

<span class="fragment">📖 **Books, articles, and documentation** – Provides formal language patterns and structured knowledge</span>

<span class="fragment">🌐 **Web pages and forums** – Adds conversational tone and diverse perspectives</span>

<span class="fragment">💻 **Code repositories** – Enables programming capabilities and structured thinking</span>

<span class="fragment">🔬 **Scientific papers** – Contributes domain expertise and technical language</span>

<span class="fragment">⚠️ **Important consideration**: Training data diversity is what makes LLMs versatile, but it also means they can reflect biases, errors, and outdated information present in that data.</span>

::: notes
The diversity of training data is what makes LLMs versatile. However, this also means they can reflect biases present in the training data. We'll discuss safety and guardrails later. Emphasize that no LLM is perfectly unbiased—they reflect their training data.
:::

---

## 🚀 What Can LLMs Do?

LLMs are **general-purpose language processors** capable of:

<span class="fragment">✅ **Answer questions** – Synthesize information from learned patterns</span>

<span class="fragment">✅ **Summarize documents** – Extract key points and condense information</span>

<span class="fragment">✅ **Write code** – Generate, debug, and explain programming solutions</span>

<span class="fragment">✅ **Translate languages** – Convert text between natural languages</span>

<span class="fragment">✅ **Extract structured information** – Parse unstructured text into JSON, tables, etc.</span>

<span class="fragment">✅ **Reason through problems** – Follow logical chains (with varying success)</span>

<span class="fragment">⚠️ **Critical caveat**: LLMs excel at pattern matching but can struggle with true logical reasoning, especially on novel problems outside their training distribution.</span>

::: notes
Emphasize "varying success" on reasoning. LLMs are powerful but not perfect. They excel at pattern matching but can struggle with true logical reasoning, especially on novel problems. They can also confidently generate incorrect information (hallucinations).
:::

---

## 🔤 Tokens & Tokenization {data-transition="zoom"}

**Critical concept**: LLMs don't work with **words**—they work with **tokens**

<span class="fragment">A **token** is a sub-unit of text the model processes. It could be a whole word, part of a word, or even a single character.</span>

<span class="fragment">**Tokenization** is the process of breaking text into tokens using a learned vocabulary (typically 50,000-100,000 unique tokens).</span>

<span class="fragment">**Why this matters**: Every LLM limitation—context windows, API costs, processing speed—is measured in tokens, not characters or words.</span>

::: notes
This is a critical concept. Many beginners think LLMs process whole words. Understanding tokenization is key to working with context windows, API costs, and debugging unexpected behavior.
:::

---

## 🧩 Token Examples

Let's see how different text gets tokenized:

<span class="fragment">**"Hello"** → `[Hello]` → **1 token** (common word)</span>

<span class="fragment">**"watsonx.ai"** → `[watson, x, ., ai]` → **2-3 tokens** (depends on tokenizer; uncommon compound word)</span>

<span class="fragment">**"AI"** → `[AI]` → **1 token** (common abbreviation)</span>

<span class="fragment">**"supercalifragilisticexpialidocious"** → `[super, cal, if, rag, il, ist, ic, exp, ial, id, oc, ious]` → **~12 tokens** (rare word, heavily split)</span>

<span class="fragment">Spaces and punctuation often become separate tokens: **"Hello, world!"** → `[Hello, ,, , world, !]` → **5 tokens**</span>

<span class="fragment">**Pro tip**: Test your specific text with a tokenizer tool before estimating costs or context limits!</span>

::: notes
Show that tokenization isn't always intuitive. Special characters, URLs, and domain-specific terms often split into multiple tokens. This directly impacts costs and context window usage.
:::

---

## ⚠️ Why Tokens Matter

Understanding tokens is essential because:

<span class="fragment">📏 **Models have hard token limits** (context windows)
Example: If your model has an 8K token limit, you can't process more than ~6K words (accounting for overhead).</span>

<span class="fragment">💰 **API costs are calculated per token**
Example: GPT-4 charges ~$0.03 per 1K input tokens. A 10-page document (~5K tokens) costs $0.15 per query.</span>

<span class="fragment">✂️ **Long documents need chunking** to fit token limits
Example: A 100-page PDF must be split into smaller sections, each processed separately.</span>

<span class="fragment">📐 **Rule of thumb**: ~4 characters per token in English (~750 words per 1K tokens)
This is approximate—technical text and code often have worse ratios.</span>

<span class="fragment">⚡ **Processing speed scales with token count**
More tokens = longer inference time. A 1K token response takes ~10x longer than a 100 token response.</span>

::: notes
Token limits are hard constraints. Exceeding them causes truncation or errors. When building applications, always estimate token counts before API calls. Use tools like tiktoken (OpenAI) or the Hugging Face tokenizer library to count tokens accurately.
:::

---

## 🪟 Context Window: The LLM's "Working Memory"

The **context window** is the maximum number of tokens a model can process in a single request.

<span class="fragment">Think of it as the model's **working memory**—everything it can "see" at once.</span>

<span class="fragment">The context window includes **both**:
- 📥 **Your input (prompt)**: The question, instructions, and any provided context
- 📤 **Model's output**: The generated response</span>

<span class="fragment">**Critical constraint**: If you use 6K tokens for your prompt, you only have 2K tokens left for the response (in an 8K context window).</span>

<span class="fragment">**Important**: The model has **no memory** outside its context window. If information isn't in the current prompt, the model doesn't know it—even if you discussed it in a previous request.</span>

::: notes
This is bidirectional. If you use a long prompt, you have less space for the response. Plan accordingly. Many students don't realize the output counts against the context window too. This is why setting max_tokens is important.
:::

---

## 📏 Common Context Window Sizes

Context windows have grown dramatically in recent years:

<span class="fragment">**Llama 3.2 (1B)**: 128K tokens (~96,000 words, ~300 pages)
- Use case: Processing entire books, large codebases</span>

<span class="fragment">**Granite 13B**: 8K tokens (~6,000 words, ~15 pages)
- Use case: Standard enterprise documents, code files</span>

<span class="fragment">**GPT-4**: 8K-128K tokens (version dependent)
- Use case: Varies by tier—8K for standard, 128K for premium</span>

<span class="fragment">**Trend**: Newer models are moving toward 100K+ token windows, enabling entirely new use cases like analyzing full research papers or codebases in a single request.</span>

<span class="fragment">**Trade-off**: Larger context windows require more memory and are slower to process. A 128K context window can take 10x longer to process than an 8K window.</span>

::: notes
Newer models are trending toward larger context windows. 128K is enormous—enough for short novels! But most enterprise use cases work fine with 8K. Don't assume you need the largest context window—it's often overkill and more expensive.
:::

---

## ✂️ Truncation Risks

If your input exceeds the context window, you face serious problems:

<span class="fragment">🔴 **Silent information loss**: The model sees only part of your prompt, but doesn't tell you what it missed
```python
# Example: 10K token document with 8K context window
# Model silently drops the last 2K tokens
prompt = load_document("large_file.txt")  # 10K tokens
response = llm.generate(prompt)  # Only sees first 8K!
```
</span>

<span class="fragment">🔴 **Incomplete or incorrect responses**: Missing context leads to hallucinations or irrelevant answers</span>

<span class="fragment">🔴 **API errors**: Some providers reject requests exceeding limits rather than truncating</span>

<span class="fragment">**Best practice**: Always validate token counts before sending prompts
```python
import tiktoken

def count_tokens(text: str, model: str = "gpt-4") -> int:
    encoding = tiktoken.encoding_for_model(model)
    return len(encoding.encode(text))

# Check before calling API
if count_tokens(prompt) > 8000:
    raise ValueError("Prompt exceeds context window!")
```
</span>

::: notes
Truncation is silent and dangerous. The model won't tell you it couldn't see part of your prompt. Always validate token counts in production systems. Use tokenization libraries to check before making API calls.
:::

---

## 🌡️ Temperature {data-background-color="#1e293b"}

**Temperature** controls the **randomness** and **creativity** of model outputs

<span class="fragment">**Range**: 0.0 to 2.0 (though most use cases stay between 0.0-1.0)</span>

<span class="fragment">**How it works**: Temperature scales the probability distribution over next-token predictions
- **Low temperature**: Model strongly favors the most probable tokens
- **High temperature**: Probability is spread more evenly across many tokens</span>

<span class="fragment">**Analogy**: Think of temperature like a "creativity knob"
- Turn it down for consistency and accuracy
- Turn it up for variety and creative exploration</span>

::: notes
Temperature is one of the most important parameters. Understanding it is essential for getting the behavior you want. Most production systems use low temperatures for reliability.
:::

---

## ❄️ Low Temperature (0.0-0.3)

**Deterministic and focused outputs**

<span class="fragment">✅ **Use for**: Code generation, factual Q&A, structured data extraction, mathematical reasoning</span>

<span class="fragment">📊 **Output behavior**: Consistent, predictable, repeatable. At temperature=0.0, you get nearly identical responses for the same prompt.</span>

<span class="fragment">**Example**:
```python
# Temperature = 0.0 (deterministic)
prompt = "What is 2 + 2?"
response = llm.generate(prompt, temperature=0.0)
# Output: "4"
# Running again: "4" (identical)
```
</span>

<span class="fragment">**When to use**:
- Production systems where consistency is critical
- Code generation that must follow exact syntax
- Extracting structured data (JSON, CSV)
- Mathematical or logical tasks</span>

::: notes
At temperature 0.0, the model always picks the most probable next token. This gives you the same (or very similar) response every time. Great for production where consistency matters. Use low temps for anything factual or structured.
:::

---

## 🌤️ Medium Temperature (0.7-1.0)

**Balanced creativity and coherence**

<span class="fragment">✅ **Use for**: General conversation, content generation, chatbots, customer support</span>

<span class="fragment">📊 **Output behavior**: Varied but coherent. Responses feel natural and conversational without becoming unpredictable.</span>

<span class="fragment">**Example**:
```python
# Temperature = 0.7 (balanced)
prompt = "Explain photosynthesis to a 10-year-old"
response = llm.generate(prompt, temperature=0.7)
# Output 1: "Plants are like tiny factories that make their own food..."
# Output 2: "Imagine plants as solar panels that create energy from sunlight..."
# (Different metaphors, same accuracy)
```
</span>

<span class="fragment">**When to use**:
- Conversational AI and chatbots
- Content writing with personality
- Scenarios where variety improves user experience
- General-purpose assistance</span>

::: notes
This is the default for most conversational AI. It provides variety while maintaining coherence. Good for chatbots and general assistance. Temperature 0.7 is often the sweet spot for user-facing applications.
:::

---

## 🔥 High Temperature (1.5-2.0)

**Very creative, less predictable, higher risk**

<span class="fragment">✅ **Use for**: Creative writing, brainstorming, poetry, exploring unusual ideas</span>

<span class="fragment">📊 **Output behavior**: Diverse, sometimes surprising, occasionally incoherent or factually incorrect</span>

<span class="fragment">**Example**:
```python
# Temperature = 1.8 (highly creative)
prompt = "Describe a sunset"
response = llm.generate(prompt, temperature=1.8)
# Output: "The sky melts into liquid gold,
#          dripping through the fingers of ancient oaks,
#          while stars whisper secrets to the fading light..."
# (Poetic, creative, non-literal)
```
</span>

<span class="fragment">⚠️ **Risks**: High temperatures can produce hallucinations, nonsensical outputs, or break from instructions</span>

<span class="fragment">**When to use**:
- Fiction and creative writing
- Brainstorming sessions where "wild ideas" are welcome
- Exploring edge cases during testing
- **Avoid for**: Anything factual, structured, or production-critical</span>

::: notes
High temperatures can produce unexpected results. Use sparingly. Good for creative tasks but risky for factual or structured outputs. Above 1.2, outputs become increasingly unpredictable.
:::

---

## 🌡️ Temperature Example

```python
from ibm_watsonx_ai.foundation_models import Model

model = Model(model_id="ibm/granite-13b-chat-v2", ...)

# Temperature = 0.0 (deterministic)
response_low = model.generate(
    prompt="What is the capital of France?",
    params={"temperature": 0.0, "max_new_tokens": 50}
)
print(response_low)
# Output: "The capital of France is Paris."

# Temperature = 1.5 (creative)
response_high = model.generate(
    prompt="What is the capital of France?",
    params={"temperature": 1.5, "max_new_tokens": 50}
)
print(response_high)
# Output: "The capital of France? Ah, the City of Light—Paris!
#          A magnificent metropolis known for its iconic Eiffel Tower,
#          world-class museums, charming cafes, and rich cultural history..."
```

::: notes
Same question, different temperatures. Notice how low temperature is direct and factual, while high temperature adds creative flair and elaboration. This is the power of the temperature parameter.
:::

---

## 🎲 Top-k Sampling

**Top-k sampling** limits the model to choose from the **top-k most probable** next tokens

<span class="fragment">**How it works**: At each step, the model considers only the k most likely tokens and ignores the rest
```python
# Example: Top-k = 5
# Possible next tokens: ["the", "a", "an", "this", "that", "some", "any", ...]
# Model considers only: ["the", "a", "an", "this", "that"]
```
</span>

<span class="fragment">**Low k (1-10)**: Very focused, conservative choices. Output is predictable but potentially repetitive.</span>

<span class="fragment">**High k (50-100)**: More diverse options included. Balances creativity with coherence.</span>

<span class="fragment">**Trade-off**: Top-k is a blunt instrument—it cuts off at exactly k tokens regardless of their probability distribution.</span>

::: notes
Top-k is less commonly adjusted than temperature. It's another way to control randomness. Useful when you want to restrict the model's vocabulary to highly probable choices. Most modern systems prefer top-p (next slide) because it's more adaptive.
:::

---

## 🎯 Top-p (Nucleus Sampling)

**Top-p sampling** dynamically selects from the **smallest set of tokens** whose cumulative probability exceeds **p**

<span class="fragment">**How it works**: Instead of a fixed number of tokens, select the most probable tokens until their combined probability reaches p
```python
# Example: Top-p = 0.9
# Token probabilities: ["the": 0.4, "a": 0.3, "an": 0.15, "this": 0.10, "that": 0.05]
# Cumulative: 0.4 + 0.3 + 0.15 + 0.10 = 0.95 > 0.9
# Model considers: ["the", "a", "an", "this"] (4 tokens, not fixed)
```
</span>

<span class="fragment">**Low p (0.1-0.5)**: Conservative, focused. Only the most probable tokens are considered.</span>

<span class="fragment">**High p (0.9-0.95)**: More diverse. Includes less probable but still reasonable tokens.</span>

<span class="fragment">**Advantage over top-k**: Adapts to the probability distribution. If one token is very probable (like "the" after "go to"), top-p naturally focuses. If many tokens are equally probable, it considers more options.</span>

<span class="fragment">**Best practice**: Most modern systems use top-p instead of top-k because it's more adaptive to context.</span>

::: notes
Top-p is more adaptive than top-k. It adjusts the candidate set based on the probability distribution. Most modern systems use top-p rather than top-k. It's the default in OpenAI, Anthropic, and IBM watsonx models.
:::

---

## ⚙️ Typical Parameter Settings

**For factual, structured tasks**:
```python
# Code generation, data extraction, Q&A
params = {
    "temperature": 0.2,      # Low randomness
    "top_p": 0.1,            # Very focused
    "max_new_tokens": 500    # Reasonable limit
}

response = model.generate(
    prompt="Extract JSON from this text: ...",
    params=params
)
```

**For creative, conversational tasks**:
```python
# Content writing, chatbots, brainstorming
params = {
    "temperature": 0.9,      # Higher creativity
    "top_p": 0.9,            # More diverse
    "max_new_tokens": 1000   # Allow longer responses
}

response = model.generate(
    prompt="Write a story about a time traveler...",
    params=params
)
```

::: notes
These are good starting points. In the labs, students will experiment with these parameters to see the effects firsthand. Emphasize that these aren't magic numbers—they should be tuned based on empirical testing for each use case.
:::

---

## ⏱️ Latency & Throughput

**Two critical performance metrics for LLM deployments**:

<span class="fragment">**Latency**: Time from sending a request to receiving the complete response
- Measured in seconds or milliseconds
- Critical for user-facing applications (chatbots, autocomplete)
- Target: < 2 seconds for good UX</span>

<span class="fragment">**Throughput**: Number of requests the system can process per unit time
- Measured in requests/second or tokens/second
- Critical for batch processing and high-traffic applications
- Target: Depends on load (10s to 1000s of requests/second)</span>

<span class="fragment">**Trade-offs**: Lower latency often means lower throughput
- Optimizing for one often degrades the other
- Example: Processing requests one-at-a-time (low latency) vs. batching them (high throughput)</span>

::: notes
For user-facing applications, latency is critical. For batch processing, throughput matters more. You can't optimize for both simultaneously. Understanding this trade-off is essential for architecture decisions.
:::

---

## 🎛️ Factors Affecting Performance

<span class="fragment">🔹 **Model size**: Larger models = slower inference
- 7B model: ~50-100 tokens/second
- 70B model: ~5-10 tokens/second (10x slower)
- Memory bandwidth becomes the bottleneck</span>

<span class="fragment">🔹 **Batch size**: Processing multiple requests together improves throughput
- Batch size 1: 100 tokens/second
- Batch size 8: 600 tokens/second (not 800 due to overhead)
- But increases latency for individual requests</span>

<span class="fragment">🔹 **Hardware**: GPUs provide 10-100x faster inference than CPUs
- CPU (Intel Xeon): 1-2 tokens/second for 7B model
- GPU (NVIDIA A100): 50-100 tokens/second for 7B model
- GPU memory size determines maximum model size</span>

<span class="fragment">🔹 **Context length**: Longer prompts = slower processing
- Attention mechanism scales O(n²) with sequence length
- Doubling prompt length can quadruple processing time</span>

::: notes
Model size is the biggest factor. A 70B parameter model is significantly slower than a 7B model, even with the same hardware. This is why model selection is so important—use the smallest model that achieves your quality bar.
:::

---

## 🏠 Local vs Managed LLMs {data-background-color="#0f172a" data-transition="slide"}

**Two fundamental deployment options with different trade-offs**:

<span class="fragment">**Local (Self-Hosted)**: Run models on your own infrastructure
- Examples: Ollama, vLLM, LM Studio, HuggingFace Transformers</span>

<span class="fragment">**Managed (Cloud APIs)**: Use cloud-hosted LLM services
- Examples: watsonx.ai, OpenAI, Anthropic, Google Vertex AI</span>

<span class="fragment">**Critical decision**: This choice affects cost, privacy, scalability, and operational complexity for years to come.</span>

::: notes
This is a critical architectural decision. Each has pros and cons. We'll explore both in depth. Many organizations start with managed and move to hybrid (managed for experimentation, local for production) as they scale.
:::

---

## 🖥️ Local LLMs (e.g., Ollama)

**Running models on your own infrastructure**

<span class="fragment">**What it means**:
- Download model weights to your servers
- Run inference on your own hardware (laptop, on-prem servers, private cloud)
- Full control over the deployment stack</span>

<span class="fragment">**Popular tools**:
- **Ollama**: Beginner-friendly, Docker-like CLI for running models locally
- **vLLM**: High-performance inference server for production
- **LM Studio**: GUI-based tool for Mac/Windows users
- **HuggingFace Transformers**: Full Python library for customization</span>

::: notes
Ollama is our example tool for local deployment. It's beginner-friendly and works well for development. Other options include LM Studio (great for non-technical users) and vLLM (best for production at scale).
:::

---

## ✅ Local LLMs: Pros

<span class="fragment">🔒 **Privacy**: Data never leaves your environment
- Critical for healthcare (HIPAA), finance (PCI-DSS), government
- No risk of data leakage through cloud APIs
- Full audit trail under your control</span>

<span class="fragment">🎯 **Control**: Full control over model versions, updates, and configuration
- Pin specific model versions
- Customize tokenization, prompts, and post-processing
- No surprise changes from cloud providers</span>

<span class="fragment">💵 **Cost**: No per-token charges after initial setup
- Pay once for hardware, use indefinitely
- Predictable costs (electricity + maintenance)
- Economical at high volumes (>10M tokens/day)</span>

<span class="fragment">🔧 **Customization**: Can fine-tune models on proprietary data
- Adapt models to domain-specific language
- Improve performance on your specific tasks
- Keep fine-tuned models private</span>

<span class="fragment">📡 **Offline**: Works without internet connectivity
- Critical for air-gapped environments
- No dependency on cloud provider uptime
- Deploy to edge devices, remote locations</span>

::: notes
Privacy is the #1 reason enterprises choose local deployment. If you're handling sensitive data (healthcare, finance), local deployment is often required by regulation. Cost advantages kick in at high scale—if you're processing millions of tokens per day, local can be cheaper than managed.
:::

---

## ❌ Local LLMs: Cons

<span class="fragment">💻 **Hardware**: Need GPUs for acceptable performance
- Entry cost: $2,000-$10,000 per GPU
- 13B model: Minimum 1x A100/H100 GPU (24GB+ VRAM)
- 70B model: Minimum 2-4x A100/H100 GPUs (80GB+ VRAM each)
- Must replace every 3-5 years as models grow</span>

<span class="fragment">🔧 **Maintenance**: You manage everything
- OS updates, driver updates, model updates
- Monitoring, logging, debugging
- 24/7 on-call for production systems
- Requires ML infrastructure expertise</span>

<span class="fragment">📏 **Scale**: Constrained by your hardware
- Can't instantly scale to handle traffic spikes
- Must provision for peak load (expensive idle time)
- Adding capacity takes weeks (order, ship, install GPUs)</span>

<span class="fragment">🎛️ **Model selection**: Limited to what fits in your hardware
- Can't easily try new models without buying new GPUs
- Stuck with older models if you can't afford upgrades
- Limited access to cutting-edge capabilities</span>

::: notes
The biggest barrier is hardware. A good GPU costs thousands of dollars. For teams without GPU infrastructure, local deployment can be challenging. Also consider operational costs—you need people who know how to deploy, monitor, and debug ML systems.
:::

---

## 🏢 Best Use Cases for Local LLMs

<span class="fragment">🧪 **Prototyping and development**
- Experiment without API costs
- Iterate quickly on prompts and parameters
- Learn LLM behavior hands-on</span>

<span class="fragment">🔒 **Privacy-sensitive applications**
- Healthcare: Patient records, clinical notes
- Finance: Transaction data, customer PII
- Legal: Case files, contracts
- Any regulated industry with data residency requirements</span>

<span class="fragment">🏗️ **Organizations with existing GPU infrastructure**
- Already have GPUs for training ML models
- Can repurpose underutilized compute
- ML platform team in place</span>

<span class="fragment">📊 **Small to medium workloads with predictable traffic**
- < 1M tokens/day: Managed is usually cheaper
- 1M-10M tokens/day: Break-even point
- > 10M tokens/day: Local becomes economical</span>

::: notes
Local is great for "getting started" and for specific use cases. If you need to scale to thousands of concurrent users, managed services are usually better. Many teams use local for development and managed for production.
:::

---

## ☁️ Managed LLMs (e.g., watsonx.ai)

**Using LLMs via cloud APIs—provider handles all infrastructure**

<span class="fragment">**What it means**:
- Models run on vendor's infrastructure
- You send prompts via API, receive responses
- Pay per use (per token)</span>

<span class="fragment">**Popular platforms**:
- **watsonx.ai**: IBM's enterprise AI platform (Granite models + governance)
- **OpenAI**: GPT-4, GPT-3.5 (most popular)
- **Anthropic**: Claude models (long context windows)
- **Google Vertex AI**: PaLM, Gemini models
- **AWS Bedrock**: Multi-model platform (Claude, Llama, etc.)</span>

::: notes
watsonx.ai is IBM's enterprise AI platform. It offers Granite models with built-in governance features. We'll use it extensively in this workshop because it's designed for enterprise use cases with compliance requirements.
:::

---

## ✅ Managed LLMs: Pros

<span class="fragment">📈 **Scale**: Handle any workload, automatic scaling
- 1 request/second or 10,000 requests/second—no infrastructure changes
- Provider handles load balancing, redundancy
- Scale instantly for traffic spikes (Black Friday, product launches)</span>

<span class="fragment">🛡️ **Governance**: Built-in compliance, audit trails
- SOC 2, HIPAA, PCI-DSS certified infrastructure
- Audit logs for every API call
- Data retention and deletion policies
- watsonx specifically designed for regulated industries</span>

<span class="fragment">📚 **Model catalog**: Access to multiple models instantly
- Try different models without re-deployment
- Upgrade to new models as they're released
- A/B test models in production</span>

<span class="fragment">📜 **SLAs**: Guaranteed uptime and performance
- 99.9% uptime guarantees
- Performance SLAs (latency, throughput)
- Financial penalties if SLAs are breached</span>

<span class="fragment">🔄 **No maintenance**: Provider handles everything
- No OS updates, driver updates, model deployments
- No on-call burden
- Focus on building applications, not infrastructure</span>

::: notes
For production at scale, managed services are hard to beat. You get enterprise features out of the box. watsonx.ai specifically offers governance features that are hard to replicate in local deployments.
:::

---

## ❌ Managed LLMs: Cons

<span class="fragment">💰 **Cost**: Pay per token (can add up at scale)
- $0.0001-$0.01 per token (varies by model)
- Can exceed $10,000/month for high-volume applications
- Unpredictable costs if usage spikes</span>

<span class="fragment">🔒 **Data privacy**: Data sent to cloud (even if not stored)
- Prompts and responses transit over internet
- Must trust vendor's security practices
- Some regulations prohibit cloud processing (ITAR, certain healthcare)</span>

<span class="fragment">⏱️ **Latency**: Network overhead for each request
- 50-200ms network latency added to each call
- Can't optimize below network round-trip time
- Problematic for real-time applications (autocomplete, gaming)</span>

<span class="fragment">🎯 **Less control**: Dependent on provider
- Can't control model versions (forced upgrades)
- Limited customization (no fine-tuning in most cases)
- Vendor lock-in (prompts optimized for specific models)</span>

::: notes
Cost can be a concern at very high volumes. However, when you factor in infrastructure costs for local deployment (hardware, electricity, personnel), managed services are often competitive up to millions of tokens per day.
:::

---

## 🏢 Best Use Cases for Managed LLMs

<span class="fragment">🚀 **Production applications at scale**
- High-traffic applications (chatbots, content generation)
- Unpredictable or spiky traffic patterns
- Global user base (leverage provider's edge network)</span>

<span class="fragment">👥 **Teams without ML infrastructure expertise**
- No dedicated ML platform team
- Want to focus on application logic, not infrastructure
- Startup or small teams</span>

<span class="fragment">📋 **Regulated industries needing governance**
- Finance, healthcare, insurance
- Need audit trails, compliance certifications
- watsonx.ai specifically designed for this</span>

<span class="fragment">🎨 **Applications requiring multiple models**
- A/B testing different models
- Ensemble approaches (query multiple models, combine answers)
- Specialized models for different tasks (coding vs. creative writing)</span>

::: notes
If you're building for production and don't have a dedicated ML infrastructure team, start with managed services. You can always move to local later if needed. Many enterprises use a hybrid approach: managed for experimentation, local for high-volume production workloads.
:::

---

## 💰 Cost Considerations {data-background-color="#1e293b"}

**Understanding the total cost of ownership (TCO) for LLM deployments**

<span class="fragment">**Local deployments**: Upfront capital costs + ongoing operational costs</span>

<span class="fragment">**Managed deployments**: Pay-per-use with no upfront investment</span>

<span class="fragment">**Hybrid approaches**: Combine both for optimal cost at different scales</span>

<span class="fragment">Let's break down the cost dimensions so you can make informed decisions...</span>

::: notes
Cost is often a deciding factor. Let's break down the dimensions. TCO analysis must include hardware, electricity, personnel, and opportunity cost—not just the sticker price of GPUs or API calls.
:::

---

## 🖥️ GPU vs CPU

**GPU (Graphics Processing Unit)**:

<span class="fragment">⚡ **Performance**: 10-100x faster than CPU for LLMs
- Parallel architecture ideal for matrix operations
- Example: 13B model runs at 50 tokens/sec on GPU vs. 1 token/sec on CPU</span>

<span class="fragment">💵 **Cost**: $1,000 - $40,000+ per card
- Consumer GPUs (RTX 4090): $1,500-$2,000 (24GB VRAM, sufficient for 7B models)
- Enterprise GPUs (A100): $10,000-$15,000 (80GB VRAM, sufficient for 70B models)
- Latest GPUs (H100): $30,000-$40,000 (80GB VRAM, 2x faster than A100)</span>

<span class="fragment">**CPU (Central Processing Unit)**:

🐢 **Performance**: Can run small models (1-7B parameters) but very slowly
- Example: 7B model runs at 1-2 tokens/sec on high-end CPU
- Acceptable only for development, not production</span>

<span class="fragment">💵 **Cost**: Cheaper, already available in most servers
- Already sunk cost in most infrastructure
- But too slow for production LLM workloads</span>

::: notes
For anything beyond toy models, you need a GPU. CPUs are fine for development with very small models, but not for production. The performance gap is too large to overcome with more CPUs—you'd need 50-100 CPU cores to match one GPU.
:::

---

## 💾 Memory Requirements

**Critical constraint**: Model size determines minimum GPU memory

<span class="fragment">**Rule of thumb**: Model needs ~2 bytes per parameter in FP16 precision
```python
# Calculate GPU memory needed
model_params = 13_000_000_000  # 13B parameters
bytes_per_param = 2            # FP16 precision
memory_needed = model_params * bytes_per_param / (1024**3)  # Convert to GB
print(f"{memory_needed:.1f} GB")  # Output: 26.0 GB
```
</span>

<span class="fragment">**Real-world examples**:
- **7B model**: ~14 GB GPU memory (fits RTX 4090)
- **13B model**: ~26 GB GPU memory (needs A100 40GB or better)
- **70B model**: ~140 GB GPU memory (needs 2x A100 80GB or 4x A100 40GB)</span>

<span class="fragment">**Optimization techniques**:
- **Quantization (INT8)**: Reduces memory by 2x (1 byte per param)
- **Quantization (INT4)**: Reduces memory by 4x (0.5 bytes per param)
- Trade-off: Lower precision = faster but slightly lower quality</span>

::: notes
This is why you can't run large models on consumer GPUs. A 70B model needs ~140GB of memory, which requires multiple enterprise GPUs. Quantization helps but has quality trade-offs.
:::

---

## ☁️ Cloud Pricing Model

**Token-based pricing** is the standard for managed LLM services:

<span class="fragment">📥 **Input tokens**: Text you send to the model
- Includes prompt, system messages, few-shot examples
- Typically cheaper than output tokens</span>

<span class="fragment">📤 **Output tokens**: Text generated by the model
- The response you receive
- Typically 2-3x more expensive than input tokens</span>

<span class="fragment">💲 **Typical pricing** (varies by model and provider):
```python
# Example pricing (as of 2024)
input_cost = 0.0002   # $0.0002 per token
output_cost = 0.0006  # $0.0006 per token

prompt_tokens = 1000
response_tokens = 500

total_cost = (prompt_tokens * input_cost) + (response_tokens * output_cost)
print(f"${total_cost:.4f}")  # Output: $0.5000
```
</span>

<span class="fragment">**Cost varies dramatically by model**:
- Small models (7B): $0.0001/token
- Medium models (13B-40B): $0.0003/token
- Large models (70B+): $0.001/token or more</span>

::: notes
Pricing varies by model and provider. Larger, more capable models cost more per token. Always check current pricing—it changes frequently as competition increases.
:::

---

## 💵 Example Cost Calculation

**Scenario**: A customer support chatbot processing 10,000 conversations/day

```python
# Parameters
conversations_per_day = 10_000
prompt_tokens = 1_000        # Customer question + conversation history
response_tokens = 500         # AI response
input_cost = 0.0002          # $ per input token
output_cost = 0.0006         # $ per output token

# Calculate daily cost
cost_per_conversation = (
    (prompt_tokens * input_cost) +
    (response_tokens * output_cost)
)
daily_cost = conversations_per_day * cost_per_conversation
monthly_cost = daily_cost * 30
yearly_cost = monthly_cost * 12

print(f"Per conversation: ${cost_per_conversation:.4f}")
print(f"Daily: ${daily_cost:,.2f}")
print(f"Monthly: ${monthly_cost:,.2f}")
print(f"Yearly: ${yearly_cost:,.2f}")
```

**Output**:
```
Per conversation: $0.5000
Daily: $5,000.00
Monthly: $150,000.00
Yearly: $1,800,000.00
```

<span class="fragment">⚠️ **Costs scale linearly with volume**. At this scale, local deployment (even with $100K GPU investment) becomes economical.</span>

::: notes
Costs can add up quickly at scale. This is why optimization matters: smaller prompts, shorter responses, caching, etc. At 10,000 conversations/day, you'd break even on local deployment in less than a year.
:::

---

## 🎯 Cost Optimization Strategies

<span class="fragment">📉 **Use smaller models when appropriate**
```python
# Don't use a 70B model for simple tasks
# Bad: Using GPT-4 for sentiment analysis
# Good: Using Granite 7B for sentiment analysis
# Potential savings: 10x reduction in cost
```
</span>

<span class="fragment">💾 **Cache common responses**
```python
from functools import lru_cache

@lru_cache(maxsize=1000)
def get_faq_answer(question: str) -> str:
    # Only call LLM if not cached
    return llm.generate(question)

# Savings: 50-80% for FAQ-style applications
```
</span>

<span class="fragment">🗜️ **Implement prompt compression**
```python
# Bad: Verbose prompt (1500 tokens)
prompt = "Please provide a comprehensive analysis..."

# Good: Concise prompt (500 tokens)
prompt = "Analyze: ..."

# Savings: 66% reduction in input tokens
```
</span>

<span class="fragment">📦 **Use batch processing for non-real-time workloads**
```python
# Process 100 documents overnight instead of real-time
# Many providers offer 50% discounts for batch APIs
```
</span>

<span class="fragment">🎚️ **Set max_tokens limits**
```python
# Prevent runaway generation
response = llm.generate(prompt, max_new_tokens=200)
# Ensures responses don't exceed budget
```
</span>

::: notes
Don't use a 70B model when a 7B model will do. Always set max_tokens to prevent runaway generation. Caching can reduce costs by 50-80% for common queries. These optimizations are essential at scale.
:::

---

## 🏗️ RAG Accelerator Architecture {data-transition="zoom"}

**Understanding where LLMs fit in a production AI system**

<span class="fragment">The **RAG Accelerator** is the codebase you'll work with in this workshop. It's a production-ready implementation of Retrieval-Augmented Generation.</span>

<span class="fragment">**What is an accelerator?**
- Pre-built, production-quality code that solves common AI patterns
- Reduces development time from months to weeks
- Incorporates best practices and battle-tested architectures</span>

<span class="fragment">**Why it matters**:
- You're not building from scratch—you're customizing proven patterns
- Understanding the architecture helps you extend it for your use cases
- The LLM is just one component in a larger system</span>

::: notes
Let's connect what we've learned to the actual codebase you'll be working with. This is the RAG Accelerator. Understanding its architecture will help you navigate the labs and extend it for your own projects.
:::

---

## 📁 Accelerator Structure

The accelerator is organized by **functional layers**:

```bash
accelerator/
├── rag/              # RAG core logic (retrieval + generation)
│   ├── pipeline.py   # Orchestrates retrieval + LLM
│   ├── prompt.py     # Prompt templates
│   └── retriever.py  # Vector search logic
├── service/          # Production API layer
│   ├── api.py        # FastAPI endpoints
│   └── deps.py       # Dependency injection (model loading)
├── tools/            # CLI utilities
│   ├── eval_small.py # Evaluation harness
│   └── ingest.py     # Document ingestion
├── ui/               # User interface (Streamlit/Gradio)
└── config.yaml       # Configuration (model selection, etc.)
```

<span class="fragment">**Key insight**: Each layer has a specific responsibility. LLM calls happen in `rag/pipeline.py`, but configuration is in `config.yaml`, and the API is in `service/api.py`.</span>

::: notes
The accelerator is organized by function. Today we focus on the LLM layer. Tomorrow we add retrieval. Understanding this structure will help you navigate the codebase efficiently.
:::

---

## 🧩 Key Components

<span class="fragment">**`rag/pipeline.py`**: Orchestrates retrieval + LLM generation
```python
def answer_question(question: str) -> str:
    # 1. Retrieve relevant documents
    context = retriever.search(question, top_k=5)
    # 2. Build prompt with context
    prompt = prompt_template.format(question=question, context=context)
    # 3. Call LLM
    response = llm.generate(prompt)
    return response
```
This is where the magic happens—combining retrieval with generation.</span>

<span class="fragment">**`rag/prompt.py`**: Shared prompt templates
```python
QA_TEMPLATE = """
Use the following context to answer the question.
Context: {context}
Question: {question}
Answer:
"""
```
Centralized prompt management ensures consistency across the application.</span>

<span class="fragment">**`service/api.py`**: FastAPI microservice
```python
@app.post("/query")
def query(request: QueryRequest):
    response = pipeline.answer_question(request.question)
    return {"answer": response}
```
Exposes the RAG pipeline as a RESTful API.</span>

<span class="fragment">**`tools/eval_small.py`**: Evaluation harness
```python
def evaluate(questions: list, ground_truth: list):
    for q, gt in zip(questions, ground_truth):
        answer = pipeline.answer_question(q)
        score = compute_similarity(answer, gt)
        print(f"Question: {q}, Score: {score}")
```
Systematically measures LLM output quality.</span>

::: notes
These are the files you'll be editing on Days 2 and 3. Today, we're focusing on understanding the LLM building block. Tomorrow, you'll wire up the retrieval component.
:::

---

## 🔄 Day 1 Architecture (No RAG)

**Today's focus**: Direct LLM calls without retrieval

```python
# Simplified version (what you'll do in Lab 1.1)
def answer_question(question: str) -> str:
    """
    Direct LLM call—no external knowledge, just the model's
    learned patterns from training
    """
    response = llm.generate(prompt=question)
    return response

# Example usage
question = "What is watsonx?"
answer = answer_question(question)
print(answer)
# Output: "watsonx is IBM's enterprise AI platform..."
# (May be incorrect or outdated—model only knows training data)
```

<span class="fragment">**Limitations**:
- Model only knows what was in training data (outdated information)
- No access to proprietary company documents
- Prone to hallucinations when asked about specific facts</span>

::: notes
This is where we are today: direct LLM calls with no retrieval. Simple but limited. The model can only answer from its training data, which is frozen in time and doesn't include your proprietary knowledge.
:::

---

## 🔄 Day 2-3 Architecture (With RAG)

**Tomorrow's enhancement**: Add retrieval to provide relevant context

```python
# Full RAG pipeline (what you'll build on Day 2)
def answer_question(question: str) -> str:
    """
    RAG: Retrieve relevant documents, then generate an answer
    based on those documents
    """
    # 1. Retrieve relevant context from your document store
    context_docs = retriever.search(
        query=question,
        top_k=5  # Retrieve top 5 most relevant documents
    )
    context = "\n\n".join([doc.content for doc in context_docs])

    # 2. Build prompt with retrieved context
    prompt = f"""
    Use the following context to answer the question.

    Context:
    {context}

    Question: {question}

    Answer:
    """

    # 3. Generate answer using LLM (same as Day 1!)
    response = llm.generate(prompt=prompt)
    return response

# Example usage
question = "What is our company's refund policy?"
answer = answer_question(question)
# Output: "According to the employee handbook (retrieved),
#          the refund policy is..." (factually correct!)
```

<span class="fragment">**Advantages**:
- Model has access to current, proprietary information
- Answers are grounded in retrieved documents (reduces hallucinations)
- Can cite sources for transparency</span>

::: notes
Tomorrow, we add retrieval. The LLM call is the same—we just give it better context. This is the power of RAG: you don't need to retrain the model, just provide it with relevant information at query time.
:::

---

## 🔗 Integration Points

**Where your LLM knowledge from today will be applied**:

<span class="fragment">**1. Model Selection** (`service/deps.py`)
```python
# You'll configure which model to use based on today's lessons
def get_llm():
    if USE_LOCAL:
        return OllamaModel(model="llama3.2:1b")
    else:
        return WatsonxModel(model="ibm/granite-13b-chat-v2")
```
Decision factors: cost, latency, quality (all from today's module!)</span>

<span class="fragment">**2. Prompt Engineering** (`rag/prompt.py`)
```python
# You'll design prompts using temperature, max_tokens, etc.
QA_TEMPLATE = """
{context}

Question: {question}
Answer concisely in 2-3 sentences.
"""
# Parameters: temperature=0.2, max_new_tokens=100
```
Parameter tuning from today's lessons applied here.</span>

<span class="fragment">**3. Response Handling** (`rag/pipeline.py`)
```python
# You'll handle token limits, truncation, errors
if count_tokens(prompt) > MAX_CONTEXT:
    # Truncate or chunk the context
    context = truncate_to_fit(context, MAX_CONTEXT - 500)
```
Token management from today's module is critical here.</span>

::: notes
These are the files where your LLM knowledge will be applied. Understanding the concepts from today's session will help you work with these components effectively. You're building real production skills.
:::

---

## 📚 Reference Notebooks

The workshop includes **reference Jupyter notebooks** that demonstrate production RAG patterns:

<span class="fragment">📘 **`use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`**
- Full RAG pipeline using watsonx.ai + Elasticsearch
- Shows how to: ingest documents → create embeddings → retrieve → generate answers
- Production-quality error handling and logging
- **When to use**: As a reference when building your Day 2 RAG pipeline</span>

<span class="fragment">📘 **`QnA_with_RAG.ipynb`**
- Simplified RAG tutorial for learning concepts
- Step-by-step explanations of each component
- Includes evaluation metrics (precision, recall, answer quality)
- **When to use**: If you get stuck in labs, review this for examples</span>

<span class="fragment">**Pro tip**: Don't run these today—they're references for Days 2-3. But skim them to see how LLMs are called in production contexts: prompt structure, error handling, parameter tuning, and integration patterns.</span>

::: notes
You don't need to run these today. But open them to see how LLMs are called in production contexts. They show prompt structure, error handling, and integration patterns. These notebooks are your "cheat sheet" for the labs.
:::

---

## 🧪 Today's Labs {data-background-color="#0f172a"}

### Lab 1.1: Quickstart

**Objective**: Get hands-on with LLM calls in both Ollama (local) and watsonx (managed)

<span class="fragment">🎯 **What you'll do**:
- Make your first LLM API call (both local and cloud)
- Experiment with temperature (0.0 vs. 1.5) and observe output differences
- Adjust `max_tokens` to control response length
- Compare latency between local and managed deployments</span>

<span class="fragment">🎯 **What you'll learn**:
- How to configure and call LLMs programmatically
- The practical impact of parameter tuning (temperature, max_tokens, top_p)
- Trade-offs between local (Ollama) and managed (watsonx) deployments</span>

<span class="fragment">🎯 **Key takeaway**: No retrieval yet—just direct prompt → response. This is the foundation for everything else.</span>

::: notes
Lab 1.1 is your chance to get hands-on with what we've discussed. You'll see temperature effects, token limits, and latency differences firsthand. This is where theory becomes practical.
:::

---

## 📋 Lab 1.2: Prompt Templates

**Objective**: Build reusable, production-quality prompt patterns

<span class="fragment">🎯 **What you'll do**:
- Create reusable prompt templates with variables (e.g., `{question}`, `{context}`)
- Implement prompt templates for different tasks: Q&A, summarization, code generation
- Test the same prompt template across Ollama and watsonx
- Compare output quality and consistency across backends</span>

<span class="fragment">🎯 **What you'll learn**:
- How to structure prompts for consistency and maintainability
- The impact of prompt phrasing on output quality
- Differences in how models (Llama vs. Granite) interpret the same prompt
- Best practices for production prompt management</span>

<span class="fragment">🎯 **Key takeaway**: Templates are critical for production. They ensure consistency, make prompts testable, and enable A/B testing.</span>

<span class="fragment">**Example template you'll build**:
```python
SUMMARY_TEMPLATE = """
Summarize the following text in {num_sentences} sentences.
Focus on the main points.

Text: {text}

Summary:
"""
```
</span>

::: notes
Templates are critical for production. You'll learn to build them in Lab 1.2. They make prompts reusable, testable, and easier to optimize. This is how real LLM applications are built.
:::

---

## 📊 Lab 1.3: Micro-Evaluation

**Objective**: Systematically measure and improve LLM output quality

<span class="fragment">🎯 **What you'll do**:
- Create a small evaluation dataset (10-20 questions with ground truth answers)
- Write Python code to: query the LLM → compare output to ground truth → calculate scores
- Implement simple evaluation metrics:
  - **Exact match**: Does the output exactly match the expected answer?
  - **Semantic similarity**: How close is the output to the expected answer? (using embeddings)
  - **Custom scoring**: Rate outputs on a 1-5 scale for relevance and accuracy</span>

<span class="fragment">🎯 **What you'll learn**:
- How to measure LLM quality systematically (not just "eyeballing" outputs)
- The impact of parameter changes (temperature, max_tokens) on quality scores
- How to build a simple evaluation framework for iterative improvement
- Why evaluation is essential for production LLM systems</span>

<span class="fragment">🎯 **Key takeaway**: You can't improve what you don't measure. Evaluation is the foundation of reliable LLM applications.</span>

<span class="fragment">**Example evaluation code you'll write**:
```python
def evaluate_llm(questions, ground_truth):
    scores = []
    for q, gt in zip(questions, ground_truth):
        answer = llm.generate(q, temperature=0.2)
        score = compute_similarity(answer, gt)  # 0.0 to 1.0
        scores.append(score)
    avg_score = sum(scores) / len(scores)
    print(f"Average score: {avg_score:.2f}")
```
</span>

::: notes
You can't improve what you don't measure. Lab 1.3 introduces evaluation, which is essential for production LLM systems. You'll build a simple framework to score outputs and iterate toward better quality.
:::

---

## 🗺️ Learning Progression

**This workshop is carefully structured to build skills incrementally**:

<span class="fragment">**Day 1: Understanding the LLM Building Block**
- Learn what LLMs are and how they work
- Master key parameters (temperature, tokens, context windows)
- Get hands-on with local (Ollama) and managed (watsonx) deployments
- **Output**: Ability to call LLMs and tune parameters for different tasks</span>

<span class="fragment">**Day 2: LLM + Retrieval (RAG)**
- Add retrieval to provide external knowledge to LLMs
- Build a vector database (Elasticsearch/Milvus) to store documents
- Implement semantic search to find relevant context
- Combine retrieval + generation for grounded answers
- **Output**: A working RAG pipeline that answers questions from your documents</span>

<span class="fragment">**Day 3: LLM + Retrieval + Orchestration (Agents)**
- Add multi-step reasoning and tool use
- Implement agents that can plan, execute, and reflect
- Chain multiple LLM calls together for complex tasks
- Build production-ready systems with error handling and monitoring
- **Output**: An agentic system that can solve complex, multi-step problems</span>

<span class="fragment">**Key insight**: Each day builds on the previous. Today's foundation (direct LLM calls) is essential for tomorrow's RAG pipeline, which is essential for Day 3's agentic systems.</span>

::: notes
Each day builds on the previous. Today's foundation is critical for success on Days 2 and 3. Don't skip ahead—mastering the fundamentals today will make the advanced topics much easier.
:::

---

## 📖 Further Reading

**Deepen your understanding with these curated resources**:

<span class="fragment">📘 **[IBM Granite Models Documentation](https://www.ibm.com/granite/docs)**
- Official Granite model family docs
- Model capabilities, benchmarks, and best practices
- When to use which Granite variant (7B vs. 13B vs. 34B)</span>

<span class="fragment">📘 **[watsonx.ai Documentation](https://www.ibm.com/docs/en/watsonx-as-a-service)**
- Complete platform overview and tutorials
- API reference and SDK documentation
- Governance and compliance features</span>

<span class="fragment">📘 **[Ollama Documentation](https://ollama.com/docs)**
- Complete Ollama CLI reference
- Model library and customization options
- Deployment patterns and performance tuning</span>

<span class="fragment">📘 **[OpenAI Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)**
- Battle-tested prompt engineering techniques
- Applies to all LLMs, not just OpenAI
- Zero-shot, few-shot, chain-of-thought prompting</span>

::: notes
These resources are excellent for deeper dives. Bookmark them for reference. The Prompt Engineering Guide especially is valuable—it contains techniques that apply to any LLM, not just OpenAI models.
:::

---

## ✅ Summary {data-background-color="#0f172a"}

**You now understand the foundational concepts of Large Language Models**:

<span class="fragment">✅ **What LLMs are and how they work**
- Pattern-matching engines trained on vast text data
- Parameters encode learned knowledge
- Predict next tokens based on statistical patterns</span>

<span class="fragment">✅ **Key concepts: tokens, context windows, temperature**
- Tokens are the atomic units LLMs process
- Context windows define the model's "working memory"
- Temperature controls randomness and creativity</span>

<span class="fragment">✅ **Trade-offs between local and managed deployments**
- Local: Privacy, control, upfront costs
- Managed: Scalability, governance, pay-per-use
- Hybrid approaches often optimal</span>

<span class="fragment">✅ **Cost considerations for LLM applications**
- Token-based pricing for managed services
- GPU hardware costs for local deployment
- Optimization strategies (caching, smaller models, prompt compression)</span>

<span class="fragment">✅ **How LLMs fit into the accelerator architecture**
- LLM is one component in a RAG pipeline
- Integration points: model selection, prompt engineering, response handling
- Tomorrow we add retrieval to make LLMs truly powerful</span>

::: notes
Congratulations! You've completed the LLM concepts module. Take a short break, then we'll dive into the hands-on labs. Make sure you understand these concepts—they underpin everything in Days 2-3.
:::

---

## 🚀 Next: Lab 1.1 {data-background-color="#0f172a"}

**Let's put this knowledge into practice!**

<span class="fragment">You'll now move to **Lab 1.1: Quickstart**, where you'll:
- Make your first LLM API calls
- Experiment with temperature, max_tokens, and other parameters
- Compare Ollama (local) and watsonx (managed) deployments
- See the concepts from this module in action</span>

<span class="fragment">**Before you start**:
- Ensure your Jupyter environment is running
- Verify Ollama is installed and models are downloaded
- Confirm watsonx API credentials are configured
- Open the lab notebook: `labs/lab-1-quickstart-two-envs.ipynb`</span>

<span class="fragment">**Questions before we transition to hands-on work?**</span>

::: notes
Transition to the lab. Make sure everyone has their environments set up before starting. Poll the room: "Any questions on LLM concepts before we code?" Take 2-3 questions max, then move to labs.
:::

---

## 🔗 Navigation & Resources {data-background-color="#0f172a"}

**Navigate the workshop:**

### 🏠 [Workshop Portal Home](/watsonx-workshop/portal/)
Interactive daily guides and presentations

### 📚 [Return to Day 1 Overview](/watsonx-workshop/tracks/day1-llm/README/)
Review Day 1 schedule and learning objectives

### ▶️ [Next: Prompt Patterns Theory](/watsonx-workshop/tracks/day1-llm/prompt-patterns-theory/)
Learn effective prompt engineering patterns

### 🧪 [Jump to Lab 1.1: Quickstart](/watsonx-workshop/tracks/day1-llm/lab-1-quickstart-two-envs/)
Start hands-on work with Ollama and watsonx.ai

### 📖 [All Workshop Materials](/watsonx-workshop/portal/)
Access complete workshop resources

::: notes
**Instructor guidance:**
- Remind students to bookmark the workshop portal
- Ensure all students have completed environment setup
- Take questions before proceeding to labs
- Emphasize that concepts from this module underpin everything in Days 2-3

**If students want to go deeper:**
- Explore the reference notebooks in `labs-src/`
- Read the Granite model documentation
- Experiment with different context window sizes
- Research token optimization techniques

**Before proceeding to labs:**
- Verify everyone can access Jupyter notebooks
- Confirm Ollama and watsonx environments are functional
- Quick poll: "Any questions on LLM concepts before we code?"
:::

---

## 📖 Additional Learning Resources

**Deepen your understanding of LLMs**:

### Core LLM Concepts
- 📘 **[Attention Is All You Need](https://arxiv.org/abs/1706.03762)** – The foundational transformer paper
- 📘 **[LLM Visualization](https://bbycroft.net/llm)** – Interactive 3D visualization of how LLMs work
- 📘 **[The Illustrated Transformer](https://jalammar.github.io/illustrated-transformer/)** – Visual guide to transformer architecture

### IBM watsonx Platform
- 📘 **[IBM Granite Models Documentation](https://www.ibm.com/granite/docs)** – Official Granite model family docs
- 📘 **[watsonx.ai Python SDK](https://ibm.github.io/watsonx-ai-python-sdk/)** – Complete API reference
- 📘 **[watsonx.ai Getting Started](https://www.ibm.com/docs/en/watsonx-as-a-service)** – Platform overview and tutorials

### Local LLM Development
- 📘 **[Ollama Documentation](https://ollama.com/docs)** – Complete Ollama reference
- 📘 **[Ollama Model Library](https://ollama.com/library)** – Browse available models
- 📘 **[Running LLMs Locally](https://www.promptingguide.ai/models/running-llms-locally)** – Comprehensive guide

### Token Optimization
- 🔧 **[OpenAI Tokenizer](https://platform.openai.com/tokenizer)** – Visualize how text is tokenized
- 🔧 **[tiktoken Library](https://github.com/openai/tiktoken)** – Fast BPE tokenizer from OpenAI
- 🔧 **[Token Counting Best Practices](https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them)** – Practical tips

::: notes
Share these resources in the workshop chat/LMS. Students often want to dive deeper into the technical details after understanding the basics.

The LLM Visualization link is particularly valuable—it shows how tokens flow through the model in an intuitive 3D interface.
:::

---

## 💡 Practical Tips for Working with LLMs

**Lessons from production experience**:

<span class="fragment">**💰 Cost Management**
Always set `max_tokens` limits to prevent runaway generation. Track token usage per request with logging. Implement caching for common queries (can reduce costs by 50-80%).</span>

<span class="fragment">**⚡ Performance Optimization**
Use smaller models when appropriate—a 7B model is often sufficient for simple tasks. Batch requests when possible to improve throughput. Consider async processing for non-real-time use cases.</span>

<span class="fragment">**🔍 Debugging**
Always log prompts and responses in development. Use `temperature=0.0` for reproducibility during debugging. Test with edge cases: empty inputs, very long inputs, special characters.</span>

<span class="fragment">**🛡️ Error Handling**
Always handle timeout errors (network issues, slow models). Implement retry logic with exponential backoff for transient failures. Validate responses before using them (check for empty outputs, errors).</span>

<span class="fragment">**📊 Monitoring**
Track latency percentiles (p50, p95, p99)—not just averages. Monitor token usage trends to catch cost spikes early. Set up alerts for quality degradation (e.g., sudden increase in empty responses).</span>

::: notes
These tips come from hard-won production experience. Share war stories if you have them:
- A case where lack of max_tokens limits caused runaway costs
- An example of how caching reduced API bills by 80%
- A situation where async processing improved UX

Make these lessons stick by connecting them to real-world consequences.
:::

---

## 🙏 Thank You!

**Questions before we move to labs?**

Remember:
- LLMs are powerful tools, but understanding their fundamentals is key
- The concepts learned here apply across all LLM providers
- Tomorrow's RAG techniques build directly on today's foundation
- Keep experimenting and asking questions!

**Let's put this knowledge into practice!** 🚀

<div style="margin-top: 40px; text-align: center;">
<a href="https://ruslanmv.com/watsonx-workshop/portal/" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Workshop Portal</a>
<a href="./lab-1-quickstart-two-envs.md" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">🧪 Start Lab 1.1</a>
</div>

::: notes
**For instructors:**
Before transitioning to labs, ask:
- "What surprised you most about LLM architecture?"
- "Any concerns about token limits or costs for your use cases?"
- "Questions on local vs. managed deployment?"
- "Everyone ready to code?"

**Transition smoothly:**
"Great! You now understand the foundational concepts. Let's apply them hands-on. Open your Ollama environment and let's send our first LLM call!"

Take note of any common questions for future workshop improvements.
:::