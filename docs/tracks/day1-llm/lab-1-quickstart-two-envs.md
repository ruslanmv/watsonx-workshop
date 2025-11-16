# 🧪 Lab 1.1 – Quickstart: Your First Steps with Ollama and watsonx.ai

**Master the fundamentals of working with Large Language Models in local and cloud environments**

**Duration**: 45-60 minutes | **Difficulty**: Beginner | **Prerequisites**: Completed Day 0 setup

::: notes
This is the first hands-on lab where students will interact directly with LLMs. Make sure all students have their environments set up before starting. Walk around and help those who encounter issues. This lab builds the foundation for all subsequent work.
:::

---

## 🎓 What You'll Learn in This Lab {data-background-color="#0f172a"}

By the end of this hands-on session, you will be able to:

<span class="fragment">📌 **Connect and authenticate** with both Ollama (local) and watsonx.ai (cloud) environments</span>

<span class="fragment">📌 **Send prompts programmatically** using Python SDKs and interpret responses</span>

<span class="fragment">📌 **Configure critical parameters** like temperature and max_tokens to control model behavior</span>

<span class="fragment">📌 **Compare and evaluate** outputs from different environments and understand trade-offs</span>

<span class="fragment">📌 **Build your first reusable code** that will integrate into larger RAG applications</span>

::: notes
These learning objectives align with real-world AI development skills. Students should feel confident after this lab that they can work with any LLM API. Emphasize that the patterns learned here (authentication, prompting, parameter tuning) apply across all LLM providers—not just Ollama and watsonx.
:::

---

## 🎯 Lab Overview & Architecture {data-background-color="#0f172a"}

**Understanding the Two-Environment Approach**

In this lab, you'll work with two complementary environments:

<span class="fragment">**🏠 Local Environment (Ollama)**
Run models on your machine for rapid prototyping, privacy-sensitive work, and offline development. Perfect for experimentation without API costs.</span>

<span class="fragment">**☁️ Cloud Environment (watsonx.ai)**
Access IBM's enterprise-grade models with built-in governance, scalability, and production-ready infrastructure. Ideal for deployment and team collaboration.</span>

<span class="fragment">**🎯 Your Mission Today**
Learn to work fluently in both environments, understand their trade-offs, and know when to use each approach in real-world projects.</span>

::: notes
This dual-environment approach mirrors real-world AI development. Many organizations use local models for development and sensitive data, then deploy to cloud for production scale. By mastering both, students become versatile AI developers who can adapt to any organizational requirement.
:::

---

## 🗺️ Lab Journey: What We'll Build {data-background-color="#1e293b"}

**Step-by-step progression from basics to practical applications**

<span class="fragment">**Part 1: Hello World** 🌍
Send your first prompts to both environments and verify connectivity</span>

<span class="fragment">**Part 2: Reasoning Experiments** 🧠
Test model reasoning capabilities with logic puzzles and compare accuracy</span>

<span class="fragment">**Part 3: Parameter Tuning** 🎛️
Explore how temperature and max_tokens transform model behavior</span>

<span class="fragment">**Part 4: Performance Analysis** ⚡
Measure and compare latency, quality, and resource usage</span>

<span class="fragment">**Part 5: Integration Preview** 🔮
See how today's code connects to tomorrow's RAG applications</span>

::: notes
This structured approach builds confidence progressively. Students start with simple "hello world" examples, then gradually tackle more complex scenarios. By the end, they'll understand not just how to call an LLM, but how to tune it for specific use cases and integrate it into larger applications.
:::

---

## ✅ Prerequisites Check {data-background-color="#0f172a"}

**Verify your environment before starting**

Before beginning this lab, confirm you have completed all setup steps:

<span class="fragment">✅ **Ollama Environment Ready**
`simple-ollama-environment` directory exists with working Jupyter installation</span>

<span class="fragment">✅ **watsonx Environment Ready**
`simple-watsonx-enviroment` directory exists with valid `.env` credentials file</span>

<span class="fragment">✅ **Jupyter Access Confirmed**
Both environments can launch Jupyter notebooks successfully</span>

<span class="fragment">✅ **Ollama Model Downloaded**
At least one model pulled (recommended: `qwen2.5:0.5b-instruct` for speed)</span>

<span class="fragment">✅ **Python Dependencies Installed**
Required packages: `ollama`, `ibm-watsonx-ai`, `python-dotenv`</span>

::: notes
Pause here and ask students to confirm their setups are working. Use this quick verification script if needed:

```bash
# Quick verification
cd ~/projects/watsonx-workshop
ls simple-ollama-environment simple-watsonx-enviroment  # Both should exist
ollama list  # Should show at least one model
cat simple-watsonx-enviroment/.env | grep -E "API_KEY|PROJECT_ID"  # Should show credentials
```

Don't proceed until everyone is ready. Those having issues should raise their hand for assistance.
:::

---

## 🧪 Quick Environment Test {data-background-color="#1e293b"}

**Run this quick test to verify everything works**

Open a terminal and run:

```bash
# Test Ollama
ollama run qwen2.5:0.5b-instruct "Say hello!"

# Should return a greeting in a few seconds
```

<span class="fragment">**Expected output:**
```
Hello! I'm Qwen, a large language model created by Alibaba Cloud...
```
</span>

<span class="fragment">**If this fails:**
- Check if Ollama service is running: `ollama serve` (or restart Docker)
- Verify model is downloaded: `ollama list`
- Pull the model if missing: `ollama pull qwen2.5:0.5b-instruct`
</span>

::: notes
This quick CLI test ensures Ollama is functional before we dive into Python code. If students can't get this working, they'll struggle with the notebook exercises. Take time here to troubleshoot any issues.
:::

---

## 🚀 PART 1: Ollama Warm-Up {data-transition="zoom" data-background-color="#0f172a"}

**Starting with the local environment**

We'll begin with Ollama because:

<span class="fragment">✅ **No API keys needed** – Simpler authentication flow</span>

<span class="fragment">✅ **Instant feedback** – Runs locally, no network latency</span>

<span class="fragment">✅ **Build confidence** – Success here validates your setup</span>

<span class="fragment">✅ **Learn patterns** – Same concepts apply to watsonx later</span>

::: notes
Ollama is the perfect starting point. There's no credential complexity, responses are fast, and students get immediate positive reinforcement. Success with Ollama builds confidence for tackling watsonx authentication next. Emphasize that the programming patterns (sending prompts, handling responses) are identical across platforms.
:::

---

## 📂 Launch Your Ollama Jupyter Environment

**Step 1: Navigate to the Ollama project directory**

```bash
cd ~/projects/watsonx-workshop/simple-ollama-environment
```

<span class="fragment">**Step 2: Start Jupyter Notebook**
```bash
jupyter notebook
```
</span>

<span class="fragment">**Step 3: Create or open the quickstart notebook**
- If `notebooks/ollama_quickstart.ipynb` exists, open it
- Otherwise, create a new notebook: Click **New** → **Python 3**
</span>

::: notes
Give students 2-3 minutes to navigate and open their notebook. Walk around to help anyone who gets stuck. Common issues:
- Jupyter not installed: `pip install jupyter`
- Browser doesn't auto-open: Copy the URL with token from terminal
- Wrong directory: Use `pwd` to verify location

Once everyone has a notebook open, proceed to the first code cell.
:::

---

## 🧩 Understanding the Ollama Python SDK

**Before we code, let's understand what we're about to do**

The Ollama Python SDK provides a simple interface:

```python
import ollama

response = ollama.chat(
    model="model-name",           # Which model to use
    messages=[{                   # Conversation format
        "role": "user",           # Who's speaking (user/assistant)
        "content": "Your prompt"  # What to ask
    }]
)
```

<span class="fragment">**Key concept:** Messages are structured as a conversation, not raw strings
This mirrors how ChatGPT and other modern LLMs work internally</span>

::: notes
This is the foundational pattern. Spend a minute explaining:
- `model`: Identifies which LLM to use (we're using the small Qwen model for speed)
- `messages`: List of conversation turns (user asks, assistant responds, user follows up, etc.)
- `role`: Either "user" (you) or "assistant" (the AI) - later we'll add "system"
- `content`: The actual text of the message

This message-based format is an industry standard (OpenAI, Anthropic, Google all use similar formats). Master this once, apply everywhere.
:::

---

## 👋 Your First LLM Call: "Hello World"

**Let's send our first prompt! Type this into a new code cell:**

```python
import ollama

# Simple greeting to test connectivity
response = ollama.chat(
    model="qwen2.5:0.5b-instruct",
    messages=[
        {"role": "user", "content": "Hello! Who are you?"}
    ]
)

print(response["message"]["content"])
```

<span class="fragment">**📝 Code explanation:**
- Line 1: Import the Ollama library
- Lines 4-8: Call the `chat()` function with our model name and message
- Line 10: Extract and print just the text response (response is a dictionary)
</span>

::: notes
Have students run this cell. Ask them to note:
1. Response time (should be 1-3 seconds)
2. Response style (casual or formal?)
3. Whether the model introduces itself correctly

This is their first successful LLM interaction! Celebrate this moment.
:::

---

## 📤 Expected Output

When you run the cell above, you should see something like:

```
Hello! I'm Qwen, a large language model created by Alibaba Cloud.
I'm designed to help answer questions, provide information, and
assist with various tasks. How can I help you today?
```

<span class="fragment">**🔍 What just happened?**
1. Your Python code connected to the local Ollama service
2. Ollama loaded the Qwen model into memory (if not already loaded)
3. The model processed your prompt and generated a response
4. The response was returned as a Python dictionary
5. You extracted the text content and printed it
</span>

<span class="fragment">**⏱️ Performance note:** First call may be slower (~5-10s) while the model loads. Subsequent calls are much faster.</span>

::: notes
If students see different output, that's okay! LLMs can vary their responses even at temperature=0 due to small floating-point differences. What matters is they got a reasonable greeting back.

If someone gets an error, check:
- Is Ollama service running? `ollama list` should work in terminal
- Is the model name correct? `ollama list` shows available models
- Network issues? Ollama uses localhost:11434 by default
:::

---

## 🔬 Exploring the Response Object

**The response contains more than just text. Let's explore:**

```python
import ollama

response = ollama.chat(
    model="qwen2.5:0.5b-instruct",
    messages=[{"role": "user", "content": "Hello! Who are you?"}]
)

# Print the entire response structure
print("Full response:")
print(response)
print("\n" + "="*60 + "\n")

# Access specific fields
print(f"Model used: {response['model']}")
print(f"Message content: {response['message']['content']}")
print(f"Message role: {response['message']['role']}")
print(f"Total duration (ns): {response.get('total_duration', 'N/A')}")
```

<span class="fragment">**Expected output structure:**
```python
{
  'model': 'qwen2.5:0.5b-instruct',
  'message': {
    'role': 'assistant',
    'content': '...'
  },
  'total_duration': 1234567890  # nanoseconds
}
```
</span>

::: notes
This teaches students that LLM responses are structured data, not just strings. Important fields:
- `model`: Confirms which model actually responded
- `message.role`: Always "assistant" for model responses
- `message.content`: The actual generated text
- `total_duration`: Performance metric (divide by 1e9 for seconds)

Understanding this structure is crucial for building robust applications that handle responses correctly.
:::

---

## 🧠 Exercise: Testing Reasoning Capabilities

**Now let's test if our model can solve a logic puzzle**

This exercise demonstrates:
- How LLMs handle reasoning tasks
- The importance of prompt structure
- How to measure response time

```python
import ollama
import time

# A classic logic puzzle to test reasoning
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

<span class="fragment">**🤔 What's the correct answer?**
"All but 9" means 9 survived, so the answer is **9 sheep**.</span>

::: notes
The answer should be 9 sheep. "All but 9" means 9 survived. Have students run this and see if the model gets it right. This is a good teaching moment:
- Small models might get confused and say 8 (17-9)
- The phrase "Let's think step by step" often improves reasoning (this is chain-of-thought prompting)
- Timing shows you how long reasoning takes

Discuss any errors. If the model gets it wrong, that's educational—shows the limits of small models on reasoning tasks.
:::

---

## 📊 Analyzing the Reasoning Response

**What did you observe?**

<span class="fragment">✅ **If the model answered 9 correctly:**
Great! The model understood "all but 9" means "except 9" or "9 remaining".</span>

<span class="fragment">❌ **If the model answered 8 (17-9):**
Common mistake! The model interpreted "all but 9 die" as a subtraction problem instead of understanding the phrase "all but 9" means "9 survive".</span>

<span class="fragment">**💡 Key Learning:**
- Small models (~500M parameters) often struggle with language nuances
- Larger models (13B+) typically get this right
- Prompt engineering matters: "step by step" improves accuracy
- This is why model selection matters for your use case!
</span>

::: notes
Use this to discuss model capabilities and limitations. Ask students:
- "Did your model get it right?"
- "How long did it take?"
- "What does the reasoning process look like?"

This teaches them to evaluate model outputs critically. Not all LLM responses are correct! Production systems need validation and testing.
:::

---

## 🔬 Experiment: Try Different Prompts

**Let's see how prompt structure affects accuracy**

```python
import ollama

# Try these different versions and compare results
prompts = [
    # Version 1: Direct question
    "A farmer has 17 sheep, and all but 9 die. How many are left?",

    # Version 2: With reasoning instruction
    """A farmer has 17 sheep, and all but 9 die.
    How many are left?

    Let's think step by step:""",

    # Version 3: With explicit clarification
    """A farmer has 17 sheep. All but 9 of them die.
    This means 9 survive. How many sheep are left?""",
]

for i, prompt in enumerate(prompts, 1):
    print(f"\n{'='*60}")
    print(f"PROMPT VERSION {i}")
    print(f"{'='*60}")

    response = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": prompt}]
    )

    print(response["message"]["content"])
```

<span class="fragment">**🎯 Observe:** Version 3 almost always gets it right because we made the logic explicit. This is prompt engineering in action!</span>

::: notes
This demonstrates the power of prompt engineering. Students should see:
- Version 1: May fail (ambiguous language)
- Version 2: Better (chain-of-thought helps)
- Version 3: Almost always correct (eliminates ambiguity)

Discuss: In production, which approach should you use? Answer: Depends on use case!
- Customer-facing: Use clear, explicit prompts (Version 3)
- Exploratory/creative: Allow ambiguity (Version 1-2)
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

## ☁️ PART 2: watsonx.ai Warm-Up {data-transition="zoom" data-background-color="#1e293b"}

**Moving to the enterprise cloud environment**

Now that you've mastered local LLM calls with Ollama, let's explore IBM watsonx.ai:

<span class="fragment">☁️ **Enterprise-grade infrastructure** – Built for production workloads</span>

<span class="fragment">🔒 **Built-in governance** – Audit trails, access controls, and compliance</span>

<span class="fragment">🌐 **Access to powerful models** – IBM Granite, Meta Llama, and more</span>

<span class="fragment">📊 **Integrated MLOps** – Monitoring, versioning, and deployment tools</span>

::: notes
watsonx requires more setup (credentials) but offers enterprise features that local models can't provide. This is where organizations deploy production AI applications. The authentication flow is more complex, but it teaches real-world cloud API patterns used across AWS, Azure, and GCP.

Key differences to emphasize:
- Ollama: Free, local, no credentials, limited models
- watsonx: Paid/trial, cloud, API key required, enterprise models
:::

---

## 📂 Launch Your watsonx Jupyter Environment

**Step 1: Navigate to the watsonx project directory**

```bash
cd ~/projects/watsonx-workshop/simple-watsonx-enviroment
```

<span class="fragment">**Step 2: Start Jupyter Notebook**
```bash
jupyter notebook
```
</span>

<span class="fragment">**Step 3: Create or open the watsonx quickstart notebook**
- If `notebooks/watsonx_quickstart.ipynb` exists, open it
- Otherwise, create a new notebook: Click **New** → **Python 3**
</span>

::: notes
Give students 2-3 minutes to navigate and open their notebook. Check that everyone has credentials configured in their `.env` file before proceeding. Common issues:
- `.env` file missing: Copy from `.env.example`
- Credentials not set: Need API key and project ID from IBM Cloud
- Typos in environment variable names (e.g., "APIKEY" vs "API_KEY")

Before moving forward, have everyone verify their `.env` file exists:
```bash
cat ~/projects/watsonx-workshop/simple-watsonx-enviroment/.env
```
:::

---

## 🔐 Understanding watsonx Authentication

**Before we call the API, we need three credentials:**

<span class="fragment">**1. API Key** 🔑
Your personal authentication token from IBM Cloud (like a password for API access)</span>

<span class="fragment">**2. Service URL** 🌐
The endpoint where watsonx.ai API is hosted (varies by region)</span>

<span class="fragment">**3. Project ID** 📁
Identifies which watsonx project to use (for resource organization and billing)</span>

::: notes
Explain each credential's purpose:
- **API Key**: Authenticates you. Keep this secret! Never commit to Git.
- **URL**: Usually `https://us-south.ml.cloud.ibm.com` for US region
- **Project ID**: Links API calls to your watsonx project for billing and resource management

These three credentials are the "keys to the kingdom" for watsonx access.
:::

---

## ✅ Verify Your Credentials

**Run this code to check your credentials are loaded correctly:**

```python
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Try multiple variable name patterns (for flexibility)
api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

# Print verification (without exposing full API key)
print(f"API Key: {'✓ Set' if api_key else '✗ Missing'}")
print(f"URL: {url}")
print(f"Project ID: {'✓ Set' if project_id else '✗ Missing'}")

# Additional validation
if not api_key:
    print("\n⚠️  API Key is missing! Check your .env file.")
if not project_id:
    print("\n⚠️  Project ID is missing! Check your .env file.")
```

<span class="fragment">**Expected output:**
```
API Key: ✓ Set
URL: https://us-south.ml.cloud.ibm.com
Project ID: ✓ Set
```
</span>

::: notes
If anyone sees "Missing", pause and help them fix their .env file. Common issues:

**Missing .env file:**
```bash
cd ~/projects/watsonx-workshop/simple-watsonx-enviroment
cp .env.example .env
nano .env  # or vim, or code .env
```

**Incorrect format:**
```bash
# WRONG (don't use quotes)
IBM_CLOUD_API_KEY="abc123"

# RIGHT
IBM_CLOUD_API_KEY=abc123
```

**Where to get credentials:**
- API Key: IBM Cloud → Manage → Access (IAM) → API keys
- Project ID: watsonx.ai → View all projects → Click project → Settings → General
- URL: Usually https://us-south.ml.cloud.ibm.com (or your region's URL)

Don't proceed until everyone's credentials are verified!
:::

---

## 👋 Your First watsonx.ai LLM Call

**Now let's send our first prompt to watsonx. Type this code:**

```python
import os
import time
from dotenv import load_dotenv
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

# Load credentials from .env file
load_dotenv()

api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

# Create credentials object
credentials = Credentials(url=url, api_key=api_key)

# Initialize the model
model = ModelInference(
    model_id="ibm/granite-13b-instruct-v2",
    credentials=credentials,
    project_id=project_id,
)

# Define prompt and parameters
prompt = "Hello! Who are you?"
params = {
    GenParams.DECODING_METHOD: "greedy",
    GenParams.MAX_NEW_TOKENS: 100,
}

# Generate response and measure time
start_time = time.time()
response = model.generate_text(prompt=prompt, params=params)
elapsed = time.time() - start_time

print(f"Response (took {elapsed:.2f}s):\n")
print(response)
```

::: notes
This is more verbose than Ollama, but it's production-grade code that follows enterprise patterns. Walk through each section:

**Lines 1-6:** Import required libraries
- `dotenv`: Loads environment variables from .env file
- `Credentials`: Handles authentication
- `ModelInference`: The main class for calling models
- `GenParams`: Type-safe parameter names

**Lines 9-15:** Set up authentication
- Load credentials from environment
- Create Credentials object (like a "login session")

**Lines 17-21:** Initialize the model
- Specify which model to use (IBM Granite 13B)
- Pass in credentials and project ID

**Lines 24-28:** Configure the generation
- Simple greeting prompt
- `greedy`: Deterministic decoding (picks most likely tokens)
- `MAX_NEW_TOKENS`: Limit response length

**Lines 31-36:** Generate and print
- Measure response time
- Call the model
- Display results

Run the cell and observe the response!
:::

---

## 🔍 Understanding the watsonx Code Structure

**Let's break down what each part does:**

<span class="fragment">**Step 1: Authentication** 🔐
```python
credentials = Credentials(url=url, api_key=api_key)
```
Creates a credentials object that will authenticate all API calls</span>

<span class="fragment">**Step 2: Model Initialization** 🤖
```python
model = ModelInference(
    model_id="ibm/granite-13b-instruct-v2",
    credentials=credentials,
    project_id=project_id
)
```
Creates a model object tied to a specific LLM (IBM Granite 13B)</span>

<span class="fragment">**Step 3: Parameter Configuration** ⚙️
```python
params = {
    GenParams.DECODING_METHOD: "greedy",
    GenParams.MAX_NEW_TOKENS: 100,
}
```
Defines how the model should generate text</span>

<span class="fragment">**Step 4: Generation** ✨
```python
response = model.generate_text(prompt=prompt, params=params)
```
Actually calls the API and gets the response</span>

::: notes
This four-step pattern (auth → initialize → configure → generate) is standard across most cloud LLM APIs. Once you understand this pattern for watsonx, you can easily adapt to OpenAI, Anthropic, Google, etc.
:::

---

## 📤 Expected watsonx Output

**When you run the code, you should see:**

```
Response (took 2.34s):

Hello! I'm Granite, an AI language model developed by IBM Research.
I'm designed to assist with information, answer questions, and help
with various tasks. How can I assist you today?
```

<span class="fragment">**🔍 Comparison with Ollama:**
- **Latency**: watsonx may be slightly slower (~2-3s vs ~1-2s) due to network round-trip
- **Quality**: Granite 13B often gives more polished, professional responses
- **Consistency**: Cloud models are always the same version; local models can vary
</span>

::: notes
Have students compare their watsonx response to their earlier Ollama response. Discussion points:

**Similarities:**
- Both introduce themselves
- Both offer to help
- Both complete the task successfully

**Differences:**
- Granite may be more formal/professional
- Granite is a larger model (13B vs 0.5B parameters)
- watsonx includes enterprise features (audit logs, governance)

Ask: "Which response do you prefer? Why?" There's no wrong answer—it depends on use case!
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

## 🎉 Congratulations! Lab 1.1 Complete! {data-background-color="#0f172a"}

**You've mastered the fundamentals of LLM interaction!**

<span class="fragment">✅ **Connected successfully** to both Ollama and watsonx.ai environments</span>

<span class="fragment">✅ **Sent programmatic prompts** and parsed responses correctly</span>

<span class="fragment">✅ **Experimented with parameters** (temperature, max_tokens) and observed effects</span>

<span class="fragment">✅ **Compared outputs** between local and cloud platforms systematically</span>

<span class="fragment">✅ **Understood the integration pattern** for building larger applications</span>

::: notes
Congratulations! This foundation is critical for everything that follows. Students now have hands-on experience with:
- Authentication and API patterns
- Prompt engineering basics
- Parameter tuning
- Performance measurement
- Multi-environment development

These skills transfer directly to production AI development!
:::

---

## 📊 What You've Accomplished {data-background-color="#1e293b"}

**Real skills that apply to production AI development:**

<span class="fragment">🎯 **API Integration**: You can now integrate any LLM API into your applications</span>

<span class="fragment">🎯 **Environment Management**: You understand trade-offs between local and cloud deployments</span>

<span class="fragment">🎯 **Parameter Tuning**: You can adjust model behavior for different use cases</span>

<span class="fragment">🎯 **Performance Analysis**: You know how to measure and optimize latency</span>

<span class="fragment">🎯 **Code Patterns**: You've learned reusable patterns for auth → init → configure → generate</span>

::: notes
Emphasize that these aren't just academic exercises—these are the exact patterns used in production AI systems at companies worldwide. Students can add "LLM integration" to their resumes now!
:::

---

## 🔗 Navigation & Next Steps {data-background-color="#0f172a"}

**Where to go from here:**

### 🏠 [Return to Workshop Home](../../README.md)
Access all workshop materials, labs, and resources

### 📚 [Day 1 Overview](./README.md)
Review Day 1 schedule and learning objectives

### ▶️ [Next: Lab 1.2 – Prompt Templates](./lab-2-prompt-templates.md)
Learn to build reusable, production-ready prompt patterns

### 🔄 [Alternative: Day 1 Theory Slides](./llm-concepts.md)
Review theoretical concepts before continuing

::: notes
**Instructor guidance:**
- Take a 5-10 minute break before Lab 1.2
- Check in with students who struggled
- Allow fast finishers to experiment with additional prompts
- Remind everyone to save their notebooks

**If students want to go deeper:**
- Experiment with different models (ollama list shows all available models)
- Try creative writing prompts at different temperatures
- Test more reasoning puzzles
- Explore the watsonx.ai web UI to see available models

**Next lab preview:**
Lab 1.2 will teach you to create reusable prompt templates instead of hardcoded strings. This is essential for production applications!
:::

---

## 📖 Additional Resources

**Want to learn more? Check these out:**

- 📘 **[Ollama Documentation](https://github.com/ollama/ollama/blob/main/docs/api.md)** – Complete Ollama API reference
- 📘 **[watsonx.ai Python SDK Docs](https://ibm.github.io/watsonx-ai-python-sdk/)** – Official watsonx SDK documentation
- 📘 **[Prompt Engineering Guide](https://www.promptingguide.ai/)** – Comprehensive prompt engineering techniques
- 📘 **[LLM Parameters Explained](https://txt.cohere.com/llm-parameters-best-outputs-language-ai/)** – Deep dive into temperature, top-p, and more

**Workshop Materials:**
- 🔧 [Environment Setup Guide](../day0-env/setup-simple-ollama-environment.md) – Review setup steps
- 🔧 [Troubleshooting Guide](../day0-env/verify-environments.md) – Common issues and solutions
- 🔧 [Complete Notebooks](../../labs-src/) – Full working examples with solutions

::: notes
Share these resources in the workshop chat/LMS. Students often want to dive deeper after completing hands-on labs.
:::

---

## 🙏 Thank You!

**Questions? Feedback?**

Feel free to:
- Ask questions in the workshop chat
- Review this presentation anytime at your own pace
- Experiment with the code examples
- Share your findings with fellow learners

**Remember:** The best way to learn is by doing. Keep experimenting! 🚀

<div style="margin-top: 40px; text-align: center;">
<a href="../../README.md" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Back to Workshop Home</a>
<a href="./lab-2-prompt-templates.md" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">▶️ Next Lab: Prompt Templates</a>
</div>

::: notes
End on a positive, encouraging note. Remind students that struggling is part of learning, and they've accomplished something significant today. The fact that they can now call LLMs programmatically is a valuable professional skill.

**For instructors:**
Before dismissing to break, ask:
- "Who successfully got both environments working?"
- "What was the most interesting thing you learned?"
- "Any lingering questions before we break?"

Take notes on common issues for future workshop improvements.
:::