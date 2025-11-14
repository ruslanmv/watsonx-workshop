# Day 0 · Verify Both Environments

**Final Sanity Check**

Make Sure Everything Works Together

---

## 🎯 Where We Are {data-background-color="#0f172a"}

At this point you've set up:

* <span class="fragment">✅ **`simple-ollama-environment`** – local LLM sandbox</span>
* <span class="fragment">✅ **`simple-watsonx-enviroment`** – watsonx.ai sandbox</span>

<span class="fragment">**This module:** A sanity check to make sure everything works *together*</span>

::: notes
This is the final step of Day 0.

We're going to verify that both environments are working and you're ready for Day 1.

Think of this as your "pre-flight checklist" before takeoff.
:::

---

## 🎯 Goal {data-background-color="#1e293b"}

Confirm you can:

* <span class="fragment">Run a local model via **Ollama** inside a notebook</span>
* <span class="fragment">Run a **Granite** model via watsonx.ai inside a notebook</span>
* <span class="fragment">Access the **`accelerator/`** folder and open notebooks</span>
* <span class="fragment">Access the **`labs-src/`** reference notebooks</span>
* <span class="fragment">End with a clear **ready / not ready** checklist</span>

::: notes
By the end of this verification, you should have high confidence that:
1. Your local setup works
2. Your cloud credentials work
3. You have access to all the code you'll need for Days 1-3
:::

---

## 🧪 Quick Verification Notebook {data-background-color="#0f172a"}

You can create a combined test notebook

---

### Create `verify_envs.ipynb`

In your main folder, create a notebook with:

```python
# verify_envs.ipynb

import os
from dotenv import load_dotenv

print("🔎 Verifying environments...")
```

::: notes
You don't HAVE to create this combined notebook, but it's a nice, quick sanity check.

Alternatively, you can just run the quickstart notebooks from each environment separately.
:::

---

### Test 1: Ollama Client

```python {data-line-numbers="1-3|5-9|10|11-12"}
# Test Ollama
try:
    import ollama
    print("✅ ollama Python package is importable")

    res = ollama.chat(
        model="qwen2.5:0.5b-instruct",
        messages=[{"role": "user", "content": "Say hello from Ollama."}],
    )
    print("Ollama says:", res["message"]["content"][:100], "...")
except Exception as e:
    print("❌ Ollama check failed:", e)
```

::: notes
Lines 1-3: Try importing ollama
Lines 5-9: Make a simple chat request
Line 10: Print the response (first 100 chars)
Lines 11-12: Catch any errors

If this succeeds, your Ollama environment is working!
:::

---

### Test 2: watsonx.ai Client

```python {data-line-numbers="1-2|3-6|8-11|13-25"}
try:
    load_dotenv()  # pick up .env
    from ibm_watsonx_ai import Credentials
    from ibm_watsonx_ai.foundation_models import ModelInference
    from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

    api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
    url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
    project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

    if not api_key or not url or not project_id:
        raise ValueError("Missing credentials")

    creds = Credentials(url=url, api_key=api_key)
    model = ModelInference(
        model_id="ibm/granite-13b-instruct-v2",
        credentials=creds,
        project_id=project_id,
    )
    params = {GenParams.DECODING_METHOD: "greedy", GenParams.MAX_NEW_TOKENS: 50}

    response = model.generate_text(
        prompt="Say hello from watsonx.ai in one sentence.", params=params
    )
    print("✅ watsonx.ai call succeeded:", response)
```

---

### Test 2 Continued

```python
except Exception as e:
    print("❌ watsonx.ai check failed:", e)
```

::: notes
This comprehensive test checks:
1. Credentials are loaded from .env
2. All required values are present
3. Authentication works
4. Model inference succeeds

If both tests pass, you're golden!
:::

---

## 👥 Pair Check Exercise {data-background-color="#1e293b"}

If you're in a classroom setting

---

### How It Works

<span class="fragment">**1. Pair up** with someone next to you</span>

<span class="fragment">**2. Each person shows:**</span>

* <span class="fragment">Jupyter running in **`simple-ollama-environment`**</span>
* <span class="fragment">`ollama_quickstart.ipynb` successfully returns a model response</span>

<span class="fragment">**3. Then each person shows:**</span>

* <span class="fragment">Jupyter running in **`simple-watsonx-enviroment`**</span>
* <span class="fragment">`watsonx_quickstart.ipynb` successfully returns a Granite response</span>

::: notes
This peer verification exercise serves multiple purposes:
1. Surfaces small typos and misconfigurations
2. Gives people practice explaining what they did
3. Creates a supportive learning environment
4. Helps identify common issues quickly

Common things that surface:
- Typos in .env
- Misconfigured paths
- Port conflicts
- Model not pulled

Encourage helping each other!
:::

---

## 📂 Confirm Accelerator & Notebooks {data-background-color="#0f172a"}

Verify your project scaffolding is complete

---

### Check the `accelerator/` Directory

From the `watsonx-workshop` repo root:

```bash
ls accelerator
```

<span class="fragment">You should see:</span>

```text
assets/  assettypes/  config.yaml  rag/
service/  tools/  ui/  ...
```

::: notes
The accelerator is the heart of the production RAG implementation.

We'll dive deep into it on Day 2-3.

For now, just verify it's there.
:::

---

### Open an Accelerator Notebook

Try opening one (read-only is fine for now):

```
accelerator/assets/notebook/
  notebook:Create_and_Deploy_QnA_AI_Service.ipynb
```

<span class="fragment">Make sure:</span>

* <span class="fragment">Jupyter loads the notebook</span>
* <span class="fragment">You can scroll through the cells</span>

::: notes
You don't need to run these notebooks yet.

Just verify they open without errors.

This confirms your Jupyter environment can handle the accelerator code.
:::

---

### Check the `labs-src/` Folder

From the same repo:

```bash
ls labs-src
```

<span class="fragment">You should see:</span>

```text
README.md
use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb
use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb
use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb
ibm-watsonx-governance-evaluation-studio-getting-started.ipynb
ibm-watsonx-governance-governed-agentic-catalog.ipynb
```

::: notes
These are reference implementations we'll use throughout the workshop.

Open one as a preview, for example:
- use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb

Again, just verify it opens. We'll run these later.
:::

---

## ⚠️ Common Failure Modes {data-background-color="#1e293b"}

What to do when things go wrong

---

### Ollama Issues

**"Connection refused" / timeout**

* <span class="fragment">Ensure Ollama server is running</span>
* <span class="fragment">In Docker: container up with port 11434 exposed</span>
* <span class="fragment">Local: Ollama app/service started</span>

**"Model not found"**

* <span class="fragment">Pull the model: `ollama pull qwen2.5:0.5b-instruct`</span>

**Out-of-memory**

* <span class="fragment">Use smaller models (0.5B–1B variants)</span>

::: notes
The most common Ollama issue is the server not running.

Quick check: curl http://localhost:11434/api/tags

If that fails, the server isn't up.
:::

---

### watsonx.ai Issues

**401 / 403 errors**

* <span class="fragment">Check API key, URL, project ID in `.env`</span>
* <span class="fragment">Confirm you have permissions in IBM Cloud</span>

**Project not found / invalid region**

* <span class="fragment">Double-check region and project ID from watsonx UI</span>

::: notes
Authentication errors are usually:
1. Wrong API key
2. Wrong region
3. Wrong project ID
4. Missing IAM permissions

Go back to the setup slides if you need to find these values again.
:::

---

### Docker Issues

**Ports already in use**

* <span class="fragment">Change host port mapping: `-p 8890:8888`</span>

**Cannot connect to Docker Daemon**

* <span class="fragment">Ensure Docker Desktop or Docker Engine is running</span>
* <span class="fragment">Linux: check user is in `docker` group</span>

::: notes
Port conflicts happen when another app (maybe another Jupyter instance) is using 8888 or 11434.

Docker daemon issues on Linux usually mean the user needs to be added to the docker group:

sudo usermod -aG docker $USER

Then log out and back in.
:::

---

## 🆘 What to Do If Something Fails {data-background-color="#0f172a"}

---

### Troubleshooting Steps

1. <span class="fragment">**Capture the error** - copy the message and command</span>
2. <span class="fragment">**Ask for help** - instructor, Slack, Teams channel</span>
3. <span class="fragment">**Check fallback paths** below</span>

::: notes
Don't suffer in silence!

Most errors are quick fixes if you ask for help.

The instructors have seen these issues before.
:::

---

### Fallback Paths

**If local Docker or Ollama is blocked:**

* <span class="fragment">You can still follow many labs in the watsonx environment</span>
* <span class="fragment">Use a pre-provisioned VM / cloud notebook if your team provides one</span>
* <span class="fragment">Pair with someone whose setup is working</span>

**The key:**

<span class="fragment">By the time Day 1 starts, you should have **at least one working LLM path** (preferably both)</span>

::: notes
Corporate laptops sometimes block Docker or local model execution.

If that's your situation, don't worry - the watsonx path still works great.

The concepts are the same whether you're using local or cloud LLMs.
:::

---

## ✅ End-of-Day 0 Checklist {data-background-color="#1e293b" data-transition="fade"}

The moment of truth

---

### ✅ `simple-ollama-environment`

* <span class="fragment">✅ Repo cloned</span>
* <span class="fragment">✅ Jupyter working</span>
* <span class="fragment">✅ `ollama_quickstart.ipynb` returns a model response</span>

---

### ✅ `simple-watsonx-enviroment`

* <span class="fragment">✅ Repo cloned</span>
* <span class="fragment">✅ `.env` configured with valid API key, URL, project ID</span>
* <span class="fragment">✅ Jupyter working</span>
* <span class="fragment">✅ `watsonx_quickstart.ipynb` returns a Granite response</span>

---

### ✅ Project Scaffolding

* <span class="fragment">✅ `accelerator/` folder present</span>
* <span class="fragment">✅ Notebooks under `accelerator/assets/notebook/` open</span>
* <span class="fragment">✅ `labs-src/` notebooks open and are readable</span>

---

### ✅ Conceptual Understanding

You can comfortably:

* <span class="fragment">✅ Switch between repos</span>
* <span class="fragment">✅ Explain (at a high level) the difference between:</span>
  * <span class="fragment">Local LLMs via Ollama</span>
  * <span class="fragment">Hosted LLMs via watsonx.ai</span>

::: notes
The technical setup is important, but understanding the concepts is equally critical.

Make sure you can articulate:
- Why we have two environments
- When you'd use local vs cloud
- How they'll connect to RAG later
:::

---

## 🎉 Congratulations! {data-background-color="#0f172a" data-transition="zoom"}

If the answer is "yes" to all of the above:

<span class="fragment">**You're ready for Day 1 – LLMs & Prompting!**</span>

::: notes
Give everyone a moment to celebrate!

Setting up development environments is genuinely hard work.

If you made it this far, you should feel proud.

Tomorrow we'll start doing the fun stuff - prompt engineering, RAG, and building real applications!
:::

---

## 📊 Quick Poll {data-background-color="#1e293b"}

**Show of hands:**

* <span class="fragment">✅ Both environments working?</span>
* <span class="fragment">⚠️ Only one environment working?</span>
* <span class="fragment">❌ Still troubleshooting?</span>

::: notes
This gives you (the instructor) a quick read on the room.

If most people are green, you can move on.

If many people are yellow or red, take extra time to help them now.

It's worth the investment - Day 1 will be much smoother if everyone starts from the same place.
:::

---

## 🎓 What's Next? {data-background-color="#0f172a"}

**Day 1 Preview (Tomorrow):**

* <span class="fragment">Deep dive into **prompt engineering**</span>
* <span class="fragment">Learn **prompt patterns** (Chain-of-Thought, Few-Shot, etc.)</span>
* <span class="fragment">Compare Ollama vs watsonx.ai performance</span>
* <span class="fragment">Introduction to **evaluation** and **safety**</span>

::: notes
Get people excited about what's coming!

Tomorrow we move from setup to actual AI engineering.

Encourage everyone to review their notes tonight and come with questions.
:::

---

## 📚 Homework (Optional)

**Before Day 1:**

* <span class="fragment">Read the Day 1 overview in the docs</span>
* <span class="fragment">Experiment with different Ollama models</span>
* <span class="fragment">Try modifying prompts in the quickstart notebooks</span>
* <span class="fragment">Skim one of the reference notebooks in `labs-src/`</span>

::: notes
This is all optional, but it will help people get more out of Day 1.

The more familiar they are with the basics, the faster they can move through advanced concepts.
:::

---

## 💬 Questions? {data-background-color="#1e293b"}

Now is a great time to ask!

::: notes
Open the floor for questions.

Common questions at this point:
- "What if I couldn't get Ollama working?"
- "Can I use a different model than Granite?"
- "How do I customize the Docker image?"
- "Where can I find more documentation?"

Be ready to answer or direct them to resources.
:::

---

## 🤝 Office Hours & Support

**Stuck on something?**

* <span class="fragment">Stay after this session for 1-on-1 help</span>
* <span class="fragment">Join the workshop Slack/Teams channel</span>
* <span class="fragment">Check the FAQ in the docs repo</span>
* <span class="fragment">Pair with a buddy who's further along</span>

::: notes
Make it clear that help is available.

Setting up environments is frustrating when it doesn't work.

Reassure people that getting stuck is normal and help is available.
:::

---

## 🌟 You Made It! {data-background-color="#0f172a"}

Day 0 is complete!

<span class="fragment">**Get some rest.**</span>

<span class="fragment">**See you tomorrow for Day 1!**</span>

::: notes
End on a positive, encouraging note.

Remind everyone that the hard part (setup) is done.

Now the fun part begins!

Thank them for their patience and participation.
:::

---

## 🚀 Explore More

**Additional Resources:**

* <span class="fragment">[Ollama Model Library](https://ollama.com/library)</span>
* <span class="fragment">[IBM watsonx.ai Documentation](https://www.ibm.com/docs/en/watsonx-as-a-service)</span>
* <span class="fragment">[LangChain Documentation](https://python.langchain.com/)</span>
* <span class="fragment">[Workshop GitHub Repos](https://github.com/ruslanmv)</span>

::: notes
Share these links in the chat or workshop materials.

Students can bookmark them for later reference.
:::

---

## 💡 Live Environment Links

**Try the environments online:**

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/YOUR_USERNAME/simple-ollama-environment/main?filepath=notebooks/ollama_quickstart.ipynb)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/YOUR_USERNAME/simple-watsonx-enviroment/blob/main/notebooks/watsonx_quickstart.ipynb)

::: notes
These cloud environments are great for:
- Students who couldn't get local setup working
- Quick experimentation without installation
- Sharing examples with others

Update YOUR_USERNAME with actual GitHub usernames when repos are public.
:::