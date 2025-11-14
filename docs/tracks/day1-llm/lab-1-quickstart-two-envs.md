# 🧪 Lab 1.1 – Quickstart in Both Environments

Get hands-on with Ollama and watsonx.ai

**Duration**: 45 minutes | **Difficulty**: Beginner

::: notes
This is the first hands-on lab. Make sure all students have their environments set up before starting. Walk around and help those who encounter issues.
:::

---

## 🎯 Lab Overview {data-background-color="#0f172a"}

<span class="fragment">🔹 Send basic prompts to **Ollama** and **watsonx.ai**</span>

<span class="fragment">🔹 Modify key parameters (temperature, max_tokens)</span>

<span class="fragment">🔹 Compare outputs and latency</span>

<span class="fragment">🔹 Understand accelerator integration</span>

::: notes
By the end of this lab, students will be comfortable switching between environments and understanding the trade-offs.
:::

---

## ✅ Prerequisites Check

Before starting, ensure:

<span class="fragment">✅ `simple-ollama-environment` set up and working</span>

<span class="fragment">✅ `simple-watsonx-enviroment` set up with valid credentials</span>

<span class="fragment">✅ Both Jupyter environments accessible</span>

<span class="fragment">✅ Ollama has a model pulled (e.g., `qwen2.5:0.5b-instruct`)</span>

::: notes
Pause here and ask students to confirm their setups are working. Don't proceed until everyone is ready.
:::

---

## 🚀 Step 1: Ollama Warm-Up {data-transition="zoom"}

Let's start with the local environment

::: notes
Ollama is simpler to start with—no credentials needed. Success here builds confidence.
:::

---

## 📂 Open Ollama Notebook

Navigate to your Ollama environment:

```bash
cd ~/projects/watsonx-workshop/simple-ollama-environment
jupyter notebook
```

<span class="fragment">Open `notebooks/ollama_quickstart.ipynb`</span>

<span class="fragment">(Or create a new notebook)</span>

::: notes
Give students 2-3 minutes to navigate to the notebook. Help anyone who gets stuck.
:::

---

## 👋 Simple "Hello" Prompt

```python {data-line-numbers="1-11"}
import ollama

# Simple greeting
response = ollama.chat(
    model="qwen2.5:0.5b-instruct",
    messages=[
        {"role": "user", "content": "Hello! Who are you?"}
    ]
)

print(response["message"]["content"])
```

<span class="fragment">**Run this cell and observe the response**</span>

::: notes
Have students run this cell. Ask them to note the response time and style. Is it casual or formal? Fast or slow?
:::

---

## 🧠 Mini Exercise: Reasoning Prompt

```python {data-line-numbers="1-17"}
import ollama
import time

prompt = """A farmer has 17 sheep, and all but 9 die.
How many are left?

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

::: notes
The answer should be 9 sheep. "All but 9" means 9 survived. See if the model gets it right. Discuss any errors.
:::

---

## 💭 Reflection Questions

<span class="fragment">❓ Did the model reason correctly?</span>

<span class="fragment">❓ How long did it take?</span>

<span class="fragment">❓ Was the reasoning process clear?</span>

::: notes
Encourage students to share their results. Different models may give different answers. This is a good learning moment about model variability.
:::

---

## ☁️ Step 2: watsonx.ai Warm-Up {data-background-color="#1e293b"}

Now let's try the managed environment

::: notes
watsonx requires more setup (credentials) but offers enterprise features.
:::

---

## 📂 Open watsonx Notebook

Navigate to watsonx environment:

```bash
cd ~/projects/watsonx-workshop/simple-watsonx-enviroment
jupyter notebook
```

<span class="fragment">Open `notebooks/watsonx_quickstart.ipynb`</span>

::: notes
Again, give students time to navigate. Check that everyone has credentials configured.
:::

---

## 🔐 Verify Credentials

```python {data-line-numbers="1-13"}
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

<span class="fragment">**All three should show as set**</span>

::: notes
If anyone sees "Missing", help them fix their .env file before proceeding.
:::

---

## 👋 watsonx "Hello" Prompt

```python {data-line-numbers="1-26"}
import os
import time
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

::: notes
More verbose setup than Ollama, but this is production-grade code. Run the cell and compare results.
:::

---

## 🔍 Compare: Ollama vs watsonx

<span class="fragment">❓ How does the response differ in style?</span>

<span class="fragment">❓ Which was faster?</span>

<span class="fragment">❓ Which feels more "polished"?</span>

::: notes
Facilitate discussion. There's no single right answer. Trade-offs exist. Ollama is often faster for small models. watsonx responses may be more refined.
:::

---

## 🧠 watsonx Reasoning Prompt

```python {data-line-numbers="1-13"}
prompt = """A farmer has 17 sheep, and all but 9 die.
How many are left?

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

::: notes
Compare Granite's reasoning to Qwen's. Which was more accurate? Which showed clearer reasoning steps?
:::

---

## 🎛️ Step 3: Parameter Experiments {data-transition="zoom"}

See how parameters affect outputs

::: notes
This is where the learning deepens. Students will see firsthand how temperature and max_tokens change behavior.
:::

---

## 🌡️ Temperature Experiment (Ollama)

```python {data-line-numbers="1-15"}
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

::: notes
Run this and observe. At temp=0.0, you'll get the same response every time. At temp=1.5, responses are much more varied.
:::

---

## 🔎 Observations

<span class="fragment">❓ At temp=0.0, do you get the same response every time?</span>

<span class="fragment">❓ At temp=1.5, how much does creativity increase?</span>

<span class="fragment">❓ Which temperature is best for this task?</span>

::: notes
Creative writing benefits from higher temperature. Factual Q&A needs lower temperature. Discuss when to use which.
:::

---

## 🌡️ Temperature Experiment (watsonx)

```python {data-line-numbers="1-16"}
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

<span class="fragment">**Note**: Use `"sample"` not `"greedy"` for temperature > 0</span>

::: notes
Important: greedy ignores temperature. Must use sample decoding. This is a common mistake.
:::

---

## 📏 Max Tokens Experiment (Ollama)

```python {data-line-numbers="1-15"}
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

::: notes
At 20 tokens, the response will be cut off. At 100, much more complete. Discuss the trade-off: completeness vs. cost/latency.
:::

---

## 📏 Max Tokens Experiment (watsonx)

```python {data-line-numbers="1-14"}
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

::: notes
Same experiment, different backend. Compare quality at different token limits.
:::

---

## 💡 Key Insights

<span class="fragment">🔑 Temperature controls **randomness**: 0.0 = deterministic, 1.5 = creative</span>

<span class="fragment">🔑 Max tokens controls **length**: Set appropriately for task</span>

<span class="fragment">🔑 Trade-offs exist: **Quality vs. Speed vs. Cost**</span>

::: notes
These parameters are levers you'll use constantly. Understanding them deeply is critical for production systems.
:::

---

## 🏗️ Step 4 (Optional): Peek at Accelerator {data-background-color="#0f172a"}

See where we're headed on Day 2

::: notes
This is optional but valuable. It shows students the bigger picture.
:::

---

## 📁 Open accelerator/rag/pipeline.py

```bash
cd ~/projects/watsonx-workshop/accelerator
cat rag/pipeline.py  # or open in your editor
```

<span class="fragment">Look for: **`answer_question(question: str) -> str`**</span>

::: notes
This file might be a placeholder on Day 1. That's okay. The point is to see the structure.
:::

---

## 🔍 Current Placeholder

```python {data-line-numbers="1-5"}
def answer_question(question: str) -> str:
    """Answer a question (placeholder for now)"""
    # TODO: Add retrieval
    # TODO: Build prompt with context
    # TODO: Call LLM
    return "This is a placeholder response."
```

::: notes
Today it's simple. Tomorrow you'll add retrieval. The LLM call you just learned is the core building block.
:::

---

## 🔮 Day 2 Preview

```python {data-line-numbers="1-13"}
def answer_question(question: str) -> str:
    # 1. Retrieve relevant docs
    docs = retriever.search(question)

    # 2. Build prompt with context
    prompt = prompt_template.format(
        question=question,
        context=docs
    )

    # 3. Generate answer (same call you just learned!)
    response = model.generate_text(prompt=prompt)

    return response
```

::: notes
The LLM call is the same. RAG just adds context retrieval beforehand. Simple but powerful.
:::

---

## 🎯 Key Insight

**The LLM call you just learned is the same in RAG**

<span class="fragment">RAG = Retrieval + Prompt + LLM</span>

<span class="fragment">You've mastered the **LLM** part today</span>

<span class="fragment">Tomorrow: Add **Retrieval** and smarter **Prompts**</span>

::: notes
This connection is important. Students should see that today's work isn't throwaway—it's foundational.
:::

---

## 📚 Step 5 (Optional): Reference Notebooks

Check out production examples

::: notes
Again optional, but opening these notebooks shows real-world usage.
:::

---

## 📘 Open a RAG Notebook

Navigate to `labs-src/`:

```
labs-src/use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb
```

<span class="fragment">**Don't run it all**—just scroll to the LLM call section</span>

::: notes
These notebooks are comprehensive. Students shouldn't run them end-to-end today. Just peek at the LLM integration.
:::

---

## 🔍 What to Look For

```python
context = "...retrieved documents..."
prompt = f"""Based on this context:

{context}

Question: {question}

Answer:"""

response = llm.generate(prompt)
```

<span class="fragment">Notice: **Context is injected before the question**</span>

::: notes
This is the RAG pattern. Context first, then question. This structure will become familiar on Day 2.
:::

---

## 💭 Reflection Time {data-background-color="#1e293b"}

Take a few minutes to discuss

::: notes
Facilitate a brief discussion. Encourage students to share what surprised them or what clicked.
:::

---

## 💬 Discussion Questions

<span class="fragment">❓ What differences did you notice between Ollama and watsonx?</span>

<span class="fragment">❓ Which felt faster? More flexible? Easier to use?</span>

<span class="fragment">❓ When would you choose one over the other?</span>

<span class="fragment">❓ How did parameter changes affect outputs?</span>

::: notes
No wrong answers. This is about building intuition. Local vs managed is a real architectural decision teams face.
:::

---

## 💡 Typical Answers

<span class="fragment">⚡ **Ollama**: Faster for small models, easier setup, works offline</span>

<span class="fragment">☁️ **watsonx**: More polished outputs, enterprise features, better for scale</span>

<span class="fragment">🎯 **Choice depends on**: Privacy needs, scale, team expertise, budget</span>

::: notes
There's no universal answer. Both have valid use cases. Production systems might even use both: Ollama for dev, watsonx for prod.
:::

---

## ✅ Checkpoint {data-background-color="#0f172a"}

Before moving on, confirm:

<span class="fragment">✅ You can run notebooks in **both environments**</span>

<span class="fragment">✅ You successfully generated responses from **both backends**</span>

<span class="fragment">✅ You experimented with **temperature and max_tokens**</span>

<span class="fragment">✅ You've seen where the **accelerator calls the LLM**</span>

::: notes
Pause here. Make sure everyone checks all boxes. Those who finish early can explore additional prompts or help peers.
:::

---

## 🚧 Troubleshooting

Common issues and solutions

::: notes
Have these solutions ready for common problems.
:::

---

### 🔧 Ollama Issues

**"Connection refused":**

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not, start it
ollama serve  # or restart Docker container
```

**"Model not found":**

```bash
ollama pull qwen2.5:0.5b-instruct
```

::: notes
Most Ollama issues are either service not running or model not pulled. These two fixes solve 90% of problems.
:::

---

### 🔧 watsonx Issues

**"Invalid API key":**
- Check your `.env` file
- Verify key in IBM Cloud console
- Ensure no extra spaces

**"Project not found":**
- Verify `PROJECT_ID` in IBM Cloud
- Ensure you have project access

::: notes
Credential issues are the most common watsonx problems. Double-check .env formatting—no quotes, no extra whitespace.
:::

---

## 🎉 Lab 1.1 Complete!

<span class="fragment">✅ You've run prompts in **both environments**</span>

<span class="fragment">✅ You understand **key parameters**</span>

<span class="fragment">✅ You can **compare outputs** systematically</span>

<span class="fragment">✅ You've seen the **accelerator structure**</span>

::: notes
Congratulations! This foundation is critical for everything that follows.
:::

---

## 🚀 Next: Lab 1.2 – Prompt Templates

Build reusable prompt patterns

::: notes
Take a short break (5 minutes), then move on to Lab 1.2. The momentum should carry forward nicely.
:::