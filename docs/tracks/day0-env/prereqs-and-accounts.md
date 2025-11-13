# 0.1 Prerequisites & Accounts

Welcome to Day 0 of the **watsonx Workshop Series** 👋  

This is our "pre-flight check" session. The goal is simple: by the end of this module, you'll know exactly what you need (laptop, software, cloud accounts, repos) so that Day 1 can be 100% hands-on instead of 100% debugging.

---

## Audience & Workshop Overview

This workshop is designed for:

- **Data scientists & ML engineers** who want to go from "LLM playground" to RAG and agents in production.
- **Developers & architects** who need to connect LLMs to real systems (APIs, data stores, governance).
- **Technical leaders** evaluating how watsonx.ai, local LLMs (Ollama), and a RAG accelerator fit into their stack.

You don't need to be a deep learning researcher, but you should be comfortable with:

- Basic Python (functions, virtualenvs, `pip`, Jupyter).
- Running commands in a terminal.
- Very basic Docker concepts (build image, run container).

### Workshop structure

We'll work across **3 core days** plus an optional Day 0 and optional Capstone:

- **Day 0 (Monday, 2h)** – Environment setup  
  - Install tools, clone repos, test notebooks.
- **Day 1 (Tuesday)** – LLMs & Prompting (Ollama vs watsonx.ai)
- **Day 2 (Wednesday)** – RAG (Retrieval-Augmented Generation)
- **Day 3 (Thursday)** – Orchestration, Agents & Recap  
  - Use your RAG as a service, think about governance.
- **Optional Capstone (Friday)** – Team project & demos

### Three core codebases we'll use

We will spend the entire workshop inside **three** codebases:

1. **`simple-ollama-environment`**  
   Local **LLM sandbox** built around [Ollama](https://ollama.com/):
   - Python 3.11 + Jupyter.
   - Ollama server, running models on your machine or in Docker.
   - Notebook: `notebooks/ollama_quickstart.ipynb`.

2. **`simple-watsonx-enviroment`**  
   watsonx.ai **sandbox** for Granite / Llama models:
   - Python 3.11 + Jupyter.
   - IBM watsonx.ai SDK + LangChain integration.
   - Notebook: `notebooks/watsonx_quickstart.ipynb`.
   - Reads credentials from a `.env` file.

3. **`accelerator/` (inside `watsonx-workshop`)**  
   A RAG **production skeleton**:
   - API: FastAPI service in `service/` wrapping `rag/pipeline.py`.
   - RAG core: `rag/` (`pipeline.py`, `retriever.py`, `prompt.py`).
   - Tools: ingestion, chunking, embedding, evaluation under `tools/`.
   - UI: Streamlit app in `ui/app.py`.
   - Assets & notebooks under `assets/`.

We start with the two env repos on Day 0 and begin "wiring in" the accelerator from Day 2 onwards.

---

## Technical Prerequisites

Before you can follow the labs, make sure your machine meets these requirements.

### Operating system

You should be able to use any of:

- **Windows 10+**
- **macOS 12+**
- **Linux** (Ubuntu 20.04+, Debian, Fedora, etc.)

If you're on a locked-down corporate laptop, you may need help from IT to install Docker or run containers.

### Minimum hardware

These are not hard limits, but they're good guidelines:

- **CPU**: 4+ cores  
- **RAM**: 16 GB recommended (8 GB possible with smaller models)  
- **Disk**: 20–30 GB free (Docker images + models + notebooks)

For local LLMs via Ollama:

- Tiny models (0.5B–1B parameters) are fine on 8 GB RAM.
- 7B models are happier with ~16 GB RAM.
- Bigger models (13B, 33B) are not recommended on small laptops.

### Software you must have

You will need:

- **Git**
- **Python 3.11**
- **Docker** (Docker Desktop on Win/macOS, Docker Engine on Linux)
- A modern **web browser** (Chrome, Edge, Firefox, Safari)

You *can* survive without Docker, but the experience will be smoother with it, especially for Ollama.

---

## Accounts & Access

To use watsonx.ai you need an **IBM Cloud account** and access to the watsonx services.

### IBM Cloud

1. Create or use an existing IBM Cloud account.
2. Ensure you have access to:
   - **watsonx.ai**
   - (Optional, but recommended) **watsonx.governance**
   - (Optional) **watsonx.orchestrate**

Your instructor / organizer should tell you:

- Which **region** to use (e.g., `us-south`).
- Whether you'll use a shared project or create your own.
- If there is a pre-configured resource group.

### watsonx project information

You will need:

- **IBM Cloud API key**
- **watsonx endpoint URL**  
  e.g. `https://us-south.ml.cloud.ibm.com`
- **Project or space ID**  
  (depending on how your environment is configured)

These values go into `.env` for `simple-watsonx-enviroment`:

```bash
IBM_CLOUD_API_KEY=...
IBM_CLOUD_URL=https://us-south.ml.cloud.ibm.com
IBM_CLOUD_PROJECT_ID=...
```

or, using the compatibility names:

```bash
WATSONX_APIKEY=...
WATSONX_URL=https://us-south.ml.cloud.ibm.com
PROJECT_ID=...
```

We'll walk through this again in **0.3 Setup `simple-watsonx-enviroment`**.

---

## Tools to Install Before Day 0 (Optional but strongly recommended)

If you have time *before* the workshop, install these locally so Day 0 is just validation.

### Git

* **Windows**:
  Download Git for Windows from the official site and follow the installer.
* **macOS**:
  Git usually comes via Xcode Command Line Tools:

  ```bash
  xcode-select --install
  ```
* **Linux** (Ubuntu example):

  ```bash
  sudo apt-get update
  sudo apt-get install -y git
  ```

### Python 3.11

* **Windows**:
  Install from python.org and check "Add to PATH".
* **macOS (Homebrew)**:

  ```bash
  brew install python@3.11
  ```
* **Linux (Ubuntu 22.04 example)**:

  ```bash
  sudo apt-get update
  sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
  ```

Verify:

```bash
python3.11 --version
```

### Docker

* **Windows / macOS**:
  Install **Docker Desktop** from docker.com and enable WSL2/backing engine as needed.
* **Linux (Ubuntu)**:
  Follow the official Docker Engine docs, or something like:

  ```bash
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
  ```

  Then log out & back in so your user is in the `docker` group.

### Jupyter (optional)

We install Jupyter via the project `Makefile`, but if you want a global install:

```bash
pip install jupyter
```

---

## Reference Repositories & Assets

During the workshop you will clone and/or have access to:

### Repositories

* **`simple-ollama-environment`**
  Minimal Python 3.11 + Jupyter + Ollama setup, with:

  * Docker support.
  * `notebooks/ollama_quickstart.ipynb`.

* **`simple-watsonx-enviroment`**
  Minimal Python 3.11 + Jupyter + watsonx.ai integration:

  * `.env.sample` for credentials.
  * `notebooks/watsonx_quickstart.ipynb`.
  * Dockerfile + Makefile for easy setup.

* **`watsonx-workshop`**
  The repository that hosts:

  * This documentation.
  * The **`accelerator/`** folder:

    * `rag/` – retrieval + pipeline code.
    * `service/` – FastAPI API.
    * `tools/` – ingestion & evaluation scripts.
    * `ui/` – Streamlit UI.
  * `labs-src/` – reference notebooks for RAG & governance.

### Notebook galleries

We won't run all of these line-by-line, but they are **excellent reference implementations** you can borrow from.

#### `labs-src/` – RAG & governance examples

* `use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`
* `use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb`
* `use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`
* `ibm-watsonx-governance-evaluation-studio-getting-started.ipynb`
* `ibm-watsonx-governance-governed-agentic-catalog.ipynb`

#### `accelerator/assets/notebook/` – RAG production workflow

* `notebook:Process_and_Ingest_Data_into_Vector_DB.ipynb`
* `notebook:Process_and_Ingest_Data_from_COS_into_vector_DB.ipynb`
* `notebook:Ingestion_of_Expert_Profile_data_to_Vector_DB.ipynb`
* `notebook:QnA_with_RAG.ipynb`
* `notebook:Create_and_Deploy_QnA_AI_Service.ipynb`
* `notebook:Test_Queries_for_Vector_DB.ipynb`
* `notebook:Analyze_Log_and_Feedback.ipynb`

These will show you:

* How to go from raw documents → chunks → embeddings → vector DB.
* How to implement a Q&A RAG pipeline.
* How to package and deploy a Q&A service.
* How to analyze logs and feedback.

---

## What You Will Have After Day 0

By the end of Day 0, you should have:

* ✅ **Cloned**:

  * `simple-ollama-environment`
  * `simple-watsonx-enviroment`
  * `watsonx-workshop` (with `accelerator/` and `labs-src/`)
* ✅ **Working Jupyter** in both env repos.
* ✅ A basic **Ollama chat** running from `ollama_quickstart.ipynb`.
* ✅ A basic **Granite / watsonx.ai call** running from `watsonx_quickstart.ipynb`.
* ✅ The `accelerator/` folder available locally.
* ✅ All reference notebooks (`labs-src/` and accelerator notebooks) opening in Jupyter.

When those boxes are ticked, you're ready to hit the ground running on **Day 1**.
