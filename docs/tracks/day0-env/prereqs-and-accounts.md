# Day 0 · Prerequisites & Accounts

**watsonx Workshop Series**

Get Ready to Build with LLMs, RAG & Agents


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

## 👋 Welcome to Day 0 {data-background-color="#0f172a"}

::: notes
Welcome everyone! This is our "pre-flight check" session. The goal is to get everyone set up so Day 1 can be 100% hands-on coding instead of debugging environment issues.

Be enthusiastic and reassuring - setup can be intimidating, but we'll walk through everything step by step.
:::

<span class="fragment">This is your **pre-flight check** session</span>

<span class="fragment">**Goal**: By the end of this module, you'll have everything you need</span>

<span class="fragment">✅ Laptop ready</span>

<span class="fragment">✅ Software installed</span>

<span class="fragment">✅ Cloud accounts configured</span>

<span class="fragment">✅ Repos cloned and tested</span>

---

## 🎯 Who Is This Workshop For?

<span class="fragment">**Data Scientists & ML Engineers**</span>
<span class="fragment">Go from "LLM playground" to RAG and agents in production</span>

<span class="fragment">**Developers & Architects**</span>
<span class="fragment">Connect LLMs to real systems (APIs, databases, governance)</span>

<span class="fragment">**Technical Leaders**</span>
<span class="fragment">Evaluate how watsonx.ai, local LLMs, and RAG fit your stack</span>

::: notes
Take a moment to ask the audience: "Which of these categories do you identify with?" This helps people feel seen and helps you gauge the room's experience level.
:::

---

## 📚 What You Should Already Know

Before we dive in, you should be comfortable with:

* <span class="fragment">**Basic Python** (functions, virtualenvs, `pip`, Jupyter)</span>
* <span class="fragment">**Terminal commands** (cd, ls, running scripts)</span>
* <span class="fragment">**Docker basics** (build image, run container)</span>

::: notes
You don't need to be a deep learning researcher or Docker expert.

If someone is completely new to Python or has never touched a terminal, recommend they pair up with someone more experienced during the workshop.
:::

---

## 🗓️ Workshop Structure {data-background-color="#1e293b"}

We'll work across **3 core days** + optional sessions

---

### Day 0 (Monday, 2h)

**Environment Setup**

* <span class="fragment">Install tools, clone repos</span>
* <span class="fragment">Test notebooks</span>
* <span class="fragment">Validate both environments</span>

---

### Day 1 (Tuesday)

**LLMs & Prompting**

* <span class="fragment">Ollama vs watsonx.ai</span>
* <span class="fragment">Prompt engineering patterns</span>
* <span class="fragment">Evaluation & safety</span>

---

### Day 2 (Wednesday)

**RAG (Retrieval-Augmented Generation)**

* <span class="fragment">Build a RAG pipeline</span>
* <span class="fragment">Vector databases & embeddings</span>
* <span class="fragment">Integrate with production code</span>

---

### Day 3 (Thursday)

**Orchestration, Agents & Governance**

* <span class="fragment">Use RAG as a service</span>
* <span class="fragment">Build agentic workflows</span>
* <span class="fragment">Think about governance</span>

---

### Optional Capstone (Friday)

**Team Project & Demos**

* <span class="fragment">Apply everything you've learned</span>
* <span class="fragment">Build a real-world prototype</span>
* <span class="fragment">Present to the group</span>

---

## 🧰 Three Core Codebases {data-background-color="#0f172a" data-transition="zoom"}

We'll spend the entire workshop inside **three** codebases

::: notes
These three repos are the foundation of the entire workshop. Make sure everyone understands we'll be moving between them throughout the week.
:::

---

### 1️⃣ `simple-ollama-environment`

**Local LLM Sandbox**

* <span class="fragment">Built around [Ollama](https://ollama.com/)</span>
* <span class="fragment">Python 3.11 + Jupyter</span>
* <span class="fragment">Run models on your machine or in Docker</span>
* <span class="fragment">Notebook: `notebooks/ollama_quickstart.ipynb`</span>

::: notes
This is your local playground. You can experiment without internet, without cloud costs, and without rate limits.

Ollama makes it trivially easy to download and run LLMs locally.
:::

---

### 2️⃣ `simple-watsonx-enviroment`

**watsonx.ai Sandbox**

* <span class="fragment">Access Granite / Llama models via IBM Cloud</span>
* <span class="fragment">Python 3.11 + Jupyter</span>
* <span class="fragment">IBM watsonx.ai SDK + LangChain integration</span>
* <span class="fragment">Notebook: `notebooks/watsonx_quickstart.ipynb`</span>
* <span class="fragment">Reads credentials from a `.env` file</span>

::: notes
This is your cloud-based sandbox. It gives you access to enterprise-grade models with governance, audit trails, and production-ready infrastructure.
:::

---

### 3️⃣ `accelerator/` (RAG Production Skeleton)

**Inside `watsonx-workshop` repo**

* <span class="fragment">**API**: FastAPI service wrapping RAG pipeline</span>
* <span class="fragment">**RAG core**: retriever, pipeline, prompt templates</span>
* <span class="fragment">**Tools**: ingestion, chunking, embedding, evaluation</span>
* <span class="fragment">**UI**: Streamlit app</span>
* <span class="fragment">**Assets**: notebooks and sample data</span>

::: notes
This is the "real application" - production-ready skeleton code that you can adapt for your own use cases.

We start with the two sandbox environments on Day 0, then wire in the accelerator from Day 2 onwards.
:::

---

## 💻 Technical Prerequisites {data-background-color="#1e293b"}

Let's make sure your machine is ready

---

### Operating System

You can use any of:

* <span class="fragment">**Windows 10+**</span>
* <span class="fragment">**macOS 12+**</span>
* <span class="fragment">**Linux** (Ubuntu 20.04+, Debian, Fedora, etc.)</span>

::: notes
If you're on a locked-down corporate laptop, you may need help from IT to install Docker or run containers. Flag this early!
:::

---

### Minimum Hardware

These are guidelines, not hard limits:

* <span class="fragment">**CPU**: 4+ cores</span>
* <span class="fragment">**RAM**: 16 GB recommended (8 GB possible with smaller models)</span>
* <span class="fragment">**Disk**: 20–30 GB free (Docker images + models + notebooks)</span>

::: notes
For local LLMs via Ollama:
- Tiny models (0.5B–1B params) work fine on 8 GB RAM
- 7B models are happier with ~16 GB RAM
- Bigger models (13B+) are not recommended on small laptops

If you have less than this, you can still do most of the workshop using only watsonx.ai.
:::

---

### Required Software

You **must** have:

* <span class="fragment">**Git**</span>
* <span class="fragment">**Python 3.11**</span>
* <span class="fragment">**Docker** (Desktop on Win/macOS, Engine on Linux)</span>
* <span class="fragment">**Modern web browser** (Chrome, Edge, Firefox, Safari)</span>

::: notes
You *can* survive without Docker, but the experience will be much smoother with it, especially for Ollama.

We'll walk through installation in the next modules.
:::

---

## ☁️ Accounts & Access {data-background-color="#0f172a"}

To use watsonx.ai you need IBM Cloud access

---

### IBM Cloud Account

You need:

1. <span class="fragment">Create or use an existing **IBM Cloud account**</span>
2. <span class="fragment">Ensure you have access to **watsonx.ai**</span>
3. <span class="fragment">(Optional) **watsonx.governance**</span>
4. <span class="fragment">(Optional) **watsonx.orchestrate**</span>

::: notes
Your instructor or organizer should tell you:
- Which region to use (e.g., us-south)
- Whether you'll use a shared project or create your own
- If there's a pre-configured resource group

Make sure everyone has this information before Day 1!
:::

---

### Required Credentials

You will need three key values:

```bash
IBM_CLOUD_API_KEY=your_api_key_here
IBM_CLOUD_URL=https://us-south.ml.cloud.ibm.com
IBM_CLOUD_PROJECT_ID=your_project_id_here
```

::: notes
We'll walk through exactly where to find these values in the next module (Setup watsonx environment).

For now, just be aware you'll need them.
:::

---

### Where to Find These Values

* <span class="fragment">**IBM_CLOUD_API_KEY**: IBM Cloud console → Manage → Access (IAM) → API keys</span>
* <span class="fragment">**IBM_CLOUD_URL**: Typically `https://<region>.ml.cloud.ibm.com`</span>
* <span class="fragment">**IBM_CLOUD_PROJECT_ID**: From your watsonx.ai project details in the UI</span>

::: notes
These values will go into a `.env` file in the `simple-watsonx-enviroment` repo.

Treat this file as a secret - never commit it to git!
:::

---

## 🌐 Network Configuration {: #network-configuration }

**Corporate Network & Firewall Settings**

If you're working from a corporate network, you may need to configure network settings:

**Common Firewall Issues:**

* <span class="fragment">Ollama downloads blocked</span>
* <span class="fragment">Docker registry access restricted</span>
* <span class="fragment">IBM Cloud API connections timeout</span>

**Solutions:**

```bash
# Configure proxy for downloads
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080

# For Docker
# Add proxy settings to ~/.docker/config.json
```

**Whitelist these domains:**
- `ollama.ai`
- `githubusercontent.com`
- `cloud.ibm.com`
- `ml.cloud.ibm.com`
- `docker.io`

::: notes
If students are on corporate networks, have IT whitelist these domains ahead of time. VPN connections can also cause issues with local Ollama servers.
:::

---

## 🐍 Python Setup {: #python-setup }

**Managing Python Environments**

Best practices for Python setup:

**Using Virtual Environments:**

```bash
# Create a virtual environment
python3.11 -m venv .venv

# Activate it
# On macOS/Linux:
source .venv/bin/activate

# On Windows:
.venv\Scripts\activate
```

**Using Conda (Alternative):**

```bash
# Create conda environment
conda create -n watsonx python=3.11

# Activate it
conda activate watsonx
```

**Verify Installation:**

```bash
# Check Python version
python --version

# Check pip
pip --version

# Install workshop dependencies
pip install ollama ibm-watsonx-ai python-dotenv jupyter
```

::: notes
Recommend virtual environments to avoid dependency conflicts. Some students may prefer conda, which is fine. The key is isolation from system Python.
:::

---

## 🛠️ Tools to Install (Optional Pre-Work) {data-background-color="#1e293b"}

If you have time *before* the workshop, install these

This makes Day 0 just validation instead of installation

---

### Installing Git

**Windows:**

```bash
# Download from git-scm.com and run installer
```

**macOS:**

```bash
xcode-select --install
```

**Linux (Ubuntu):**

```bash
sudo apt-get update
sudo apt-get install -y git
```

::: notes
Most developers already have Git installed. This is a quick sanity check.
:::

---

### Installing Python 3.11

**Windows:**

* <span class="fragment">Download from python.org</span>
* <span class="fragment">✅ Check "Add to PATH" during installation</span>

**macOS (Homebrew):**

```bash
brew install python@3.11
```

**Linux (Ubuntu 22.04):**

```bash
sudo apt-get update
sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
```

---

### Verify Python Installation

Run this command to check:

```bash
python3.11 --version
```

<span class="fragment">You should see: `Python 3.11.x`</span>

::: notes
If this doesn't work, Python might not be in your PATH, or you might need to use `python` or `python3` instead of `python3.11`.

Common issue on Windows: forgetting to check "Add to PATH" during installation.
:::

---

### Installing Docker

**Windows / macOS:**

* <span class="fragment">Install **Docker Desktop** from docker.com</span>
* <span class="fragment">Enable WSL2 backend (Windows)</span>

**Linux (Ubuntu):**

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"
# Log out and back in
```

::: notes
On Linux, make sure to add your user to the docker group so you don't need sudo for every docker command.

On Windows/Mac, Docker Desktop handles most of the complexity.
:::

---

## 📦 Reference Repositories {data-background-color="#0f172a"}

During the workshop you'll work with these repos

---

### Repository Overview

* <span class="fragment">**`simple-ollama-environment`** - Local LLM sandbox</span>
* <span class="fragment">**`simple-watsonx-enviroment`** - watsonx.ai sandbox</span>
* <span class="fragment">**`watsonx-workshop`** - Main repo with accelerator & docs</span>

::: notes
You'll clone all three of these during Day 0.

The watsonx-workshop repo is the "home base" - it contains this documentation plus the production RAG accelerator.
:::

---

### Notebook Galleries

We have **excellent reference implementations** you can borrow from:

* <span class="fragment">**`labs-src/`** - RAG & governance examples</span>
* <span class="fragment">**`accelerator/assets/notebook/`** - Production workflow notebooks</span>

::: notes
We won't run all of these line-by-line during the workshop, but they're incredibly valuable reference material.

Encourage students to explore them during breaks or after the workshop.
:::

---

### Key Reference Notebooks

**RAG Examples:**

* <span class="fragment">`use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`</span>
* <span class="fragment">`use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`</span>

**Governance Examples:**

* <span class="fragment">`ibm-watsonx-governance-evaluation-studio-getting-started.ipynb`</span>
* <span class="fragment">`ibm-watsonx-governance-governed-agentic-catalog.ipynb`</span>

::: notes
These show you how to integrate watsonx with popular vector databases and how to use governance features.
:::

---

### Accelerator Production Notebooks

**End-to-end workflow notebooks:**

* <span class="fragment">`Process_and_Ingest_Data_into_Vector_DB.ipynb`</span>
* <span class="fragment">`QnA_with_RAG.ipynb`</span>
* <span class="fragment">`Create_and_Deploy_QnA_AI_Service.ipynb`</span>
* <span class="fragment">`Analyze_Log_and_Feedback.ipynb`</span>

::: notes
These notebooks show the complete journey:
- Raw documents → chunks → embeddings → vector DB
- Implement a Q&A RAG pipeline
- Package and deploy as a service
- Analyze logs and user feedback

This is production-ready code you can adapt.
:::

---

## ✅ What You'll Have After Day 0 {data-background-color="#1e293b" data-transition="fade"}

By the end of today's session

---

### Your Checklist

* <span class="fragment">✅ **Cloned**: All three repos</span>
* <span class="fragment">✅ **Working Jupyter** in both env repos</span>
* <span class="fragment">✅ **Ollama chat** running from `ollama_quickstart.ipynb`</span>
* <span class="fragment">✅ **Granite call** working from `watsonx_quickstart.ipynb`</span>
* <span class="fragment">✅ **Accelerator folder** available locally</span>
* <span class="fragment">✅ **Reference notebooks** opening in Jupyter</span>

::: notes
When all these boxes are ticked, you're ready to hit the ground running on Day 1.

If someone is stuck on any of these, they should raise their hand now or during breaks.
:::

---

## 🚀 Ready to Get Started? {data-background-color="#0f172a"}

Next up: **Setup `simple-ollama-environment`**

We'll get your local LLM sandbox running

::: notes
Take a quick break if needed, then dive into the hands-on setup!

Remind everyone they can ask questions at any time.
:::

---

## 💡 Live Environment Links

Want to explore before installing locally?

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ruslanmv/simple-ollama-environment/main?filepath=notebooks/ollama_quickstart.ipynb)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/ruslanmv/simple-watsonx-enviroment/blob/main/notebooks/watsonx_quickstart.ipynb)

::: notes
These badges link to live, interactive environments where students can try notebooks without any local setup.

MyBinder is great for Ollama (though it won't have GPU access).
Google Colab works well for the watsonx notebooks if students have their credentials ready.

Make sure to update ruslanmv with the actual GitHub usernames once the repos are public.
:::

---

## 🔗 Navigation & Next Steps {data-background-color="#0f172a"}

**Where to go from here:**

### 🏠 [Return to Workshop Home](../../portal.md)
Access all workshop materials and schedule

### ▶️ [Next: Setup Ollama Environment](./setup-simple-ollama-environment.md)
Install and configure your local LLM environment

### ▶️ [Alternative: Setup watsonx Environment](./setup-simple-watsonx-enviroment.md)
Configure your IBM watsonx.ai cloud environment

### ▶️ [Verify Both Environments](./verify-environments.md)
Test that everything is working correctly

### 📚 [Jump to Day 1](../day1-llm/README.md)
Begin the LLM fundamentals workshop (after setup is complete)

::: notes
**Instructor guidance:**
- Ensure everyone has completed prerequisites before moving on
- Take a break if needed before starting environment setup
- Have teaching assistants available to help with installation issues
- Remind students they can work through setup at their own pace

**Setup order recommendation:**
1. Complete this prerequisites check
2. Set up Ollama environment first (simpler, no credentials needed)
3. Set up watsonx environment (requires IBM Cloud account)
4. Verify both environments are working
5. You're ready for Day 1!

**Pro tip:** Students who finish setup early can:
- Explore the sample notebooks
- Try the Binder/Colab links
- Review Day 1 theory slides
- Help classmates who are stuck
:::

---

## 📖 Additional Resources

**Helpful documentation and tutorials:**

- 📘 **[Python Installation Guide](https://realpython.com/installing-python/)** – Comprehensive Python setup for all platforms
- 📘 **[Git Basics Tutorial](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)** – Learn Git fundamentals
- 📘 **[Jupyter Notebook Guide](https://jupyter-notebook.readthedocs.io/en/stable/)** – Master Jupyter notebooks
- 📘 **[IBM Cloud Getting Started](https://cloud.ibm.com/docs/overview)** – Navigate IBM Cloud console
- 📘 **[Ollama Documentation](https://github.com/ollama/ollama/blob/main/README.md)** – Complete Ollama reference

**Troubleshooting Resources:**
- 🔧 [Python PATH Issues](https://realpython.com/add-python-to-path/) – Fix "command not found" errors
- 🔧 [Git Installation Help](https://github.com/git-guides/install-git) – Platform-specific Git setup
- 🔧 [VS Code Setup](https://code.visualstudio.com/docs/setup/setup-overview) – Configure your code editor

::: notes
Share these resources in the workshop chat/LMS. Students often need additional help with environment setup, especially if they're new to Python or Git.
:::

---

## 🙏 Thank You for Preparing!

**Questions about prerequisites or setup?**

Remember:
- Take your time with setup—there's no rush
- Ask questions if you get stuck
- Help your neighbors if you finish early
- We're here to support you!

**Environment setup can be challenging, but you've got this!** 💪

<div style="margin-top: 40px; text-align: center;">
<a href="../../README.md" style="padding: 10px 20px; background: #0066cc; color: white; text-decoration: none; border-radius: 5px;">🏠 Back to Workshop Home</a>
<a href="./setup-simple-ollama-environment.md" style="padding: 10px 20px; background: #00aa00; color: white; text-decoration: none; border-radius: 5px; margin-left: 10px;">▶️ Setup Ollama Environment</a>
</div>

::: notes
End on an encouraging note. Environment setup is often the hardest part of any workshop, so reassure students that:
- It's normal to encounter issues
- We have time allocated for troubleshooting
- There are multiple paths to success (local install, Docker, cloud notebooks)
- The learning starts on Day 1—setup is just preparation

**For instructors:**
Have a backup plan for students who can't get local setup working:
- Google Colab for watsonx notebooks
- MyBinder for Ollama notebooks (limited)
- Shared development environment if available
- Pairing with students who have working setups

Make sure to circulate and check on everyone's progress before dismissing!
:::