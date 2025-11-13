# 0.2 Setup `simple-ollama-environment`

In this section we'll get your **local LLM sandbox** running: Python 3.11, Jupyter, and [Ollama](https://ollama.com) packaged together in a reproducible way.

You can choose either:

- A **Docker-first** setup (recommended for consistency), or
- A **local virtual environment** using your host's Python 3.11 and an existing Ollama install.

---

## Goal

By the end of this lab you will:

- Have the **`simple-ollama-environment`** repo cloned.
- Be able to launch a Jupyter Notebook.
- Run `notebooks/ollama_quickstart.ipynb` and chat with a local LLM (e.g., `qwen2.5:0.5b-instruct` or `llama3.2:1b`).

---

## Repository Overview

Once cloned, you'll see something like:

```text
simple-ollama-environment/
├── Dockerfile
├── Makefile
├── pyproject.toml
├── README.md
├── assets/
│   └── screenshot.png (example)
└── notebooks/
    └── ollama_quickstart.ipynb
```

Key pieces:

* **`Dockerfile`**
  Builds a container image that bundles:

  * Python 3.11
  * Jupyter
  * Ollama (server + CLI)
  * A small pre-pulled model (configurable)

* **`Makefile`**
  Cross-platform shortcuts for:

  * `make install` – local venv + kernel.
  * `make build-container` – Docker image.
  * `make run-container` – run image with ports & volumes.

* **`pyproject.toml`**
  Python dependencies and metadata.

* **`notebooks/ollama_quickstart.ipynb`**
  A notebook that:

  * Ensures the Python Ollama client is installed.
  * Verifies the Ollama API is reachable.
  * Runs a basic chat call.

---

## Step 1 – Clone the Repository

Pick or create a parent folder for all workshop repos:

```bash
mkdir -p ~/projects/watsonx-workshop
cd ~/projects/watsonx-workshop
```

Clone:

```bash
git clone https://github.com/ruslanmv/simple-ollama-environment.git
cd simple-ollama-environment
```

You should now be inside the repo root.

---

## Step 2 – Choose Setup Path

You have two main options.

### Option A – Docker (recommended)

**Best if**:

* You want minimal local setup.
* You're happy to let Docker handle Python + Ollama.

#### A.1 Build the container image

From the repo root:

```bash
make build-container
```

Under the hood this runs `docker build` and creates an image (for example `simple-ollama-environment:latest`) that includes:

* Python 3.11 + dependencies.
* Jupyter.
* Ollama server + client.
* A tiny pre-pulled model (configurable via `PREPULL` build arg).

#### A.2 Run the container

Launch the environment:

```bash
make run-container
```

This will:

* Start a container named something like `simple-ollama-env`.
* Expose:

  * **Jupyter** on `http://localhost:8888`
  * **Ollama API** on `http://localhost:11434`
* Mount your current folder into `/workspace` so notebooks and changes persist.

If you prefer to run manually:

```bash
docker run -d --name simple-ollama-env \
  -p 8888:8888 -p 11434:11434 \
  -v "$PWD":/workspace \
  -v ollama_models:/root/.ollama \
  docker.io/ruslanmv/simple-ollama-environment:latest
```

> Tip: The `ollama_models` named volume keeps your models cached across container runs.

Open Jupyter:

* Go to `http://localhost:8888` in your browser.
* Copy the token from the container logs if needed (`docker logs simple-ollama-env`).

### Option B – Local Python Environment

**Best if**:

* You already have Ollama installed on your host.
* You prefer to run Jupyter directly on your machine.

#### B.1 Install Ollama on your machine

Follow [https://ollama.com/download](https://ollama.com/download) or:

* **macOS**

  ```bash
  brew install --cask ollama
  ```
* **Windows**
  Use the GUI installer or `winget install Ollama.Ollama`.
* **Linux**

  ```bash
  curl -fsSL https://ollama.com/install.sh | sh
  ```

Make sure the Ollama service is running (it usually starts automatically).

#### B.2 Create a virtual environment & install deps

From the repo root:

```bash
make install
```

This will:

* Create a Python 3.11 virtualenv.
* Install dependencies from `pyproject.toml`.
* Register a Jupyter kernel called something like **"Python 3.11 (simple-env)"**.

To start Jupyter:

```bash
jupyter notebook
```

Then choose the **"Python 3.11 (simple-env)"** kernel.

---

## Step 3 – Install & Configure Ollama Models

If you're using the Docker image with `OLLAMA_PREPULL`, some models may already be present. Otherwise, you can pull them yourself.

### Pull a small model

Examples:

```bash
# From host or inside container:
ollama pull qwen2.5:0.5b-instruct
ollama pull llama3.2:1b
```

These are small enough to work well on most laptops.

### Quick health check

With the container running, you can test:

```bash
curl http://localhost:11434/api/tags
```

You should see JSON listing available models.

---

## Step 4 – Run `ollama_quickstart.ipynb`

Now let's test end-to-end.

1. Open **Jupyter** (either inside the container or local).
2. Navigate to `notebooks/`.
3. Open `ollama_quickstart.ipynb`.
4. Run the cells top to bottom.

You should see something along the lines of:

```python
import ollama

response = ollama.chat(
    model="qwen2.5:0.5b-instruct",
    messages=[{"role": "user", "content": "Tell me a joke about AI and coffee."}],
)
print(response["message"]["content"])
```

If everything is wired correctly, you'll get a text response from the model.

---

## How This Relates to RAG & the Accelerator

Right now, you're just sending plain prompts to a local model, but the same patterns will be used later when you:

* Implement a **local RAG notebook** (`rag_local_ollama.ipynb`).
* Compare local RAG vs watsonx.ai RAG.
* Treat local LLMs and watsonx.ai as interchangeable "generation backends" in the **accelerator**.

What you're learning here:

* How to:

  * Talk to Ollama's HTTP API / Python client.
  * Run notebooks in a controlled environment.
* Will directly transfer to:

  * Calling watsonx.ai in the other repo.
  * Plugging a watsonx.ai LLM into the `accelerator/rag/pipeline.py`.

---

## Troubleshooting

### Ollama not reachable

* Make sure the container is running (`docker ps`) or the desktop app/service is started.
* Check that `curl http://localhost:11434/api/tags` returns JSON.
* In Docker: ensure you mapped `-p 11434:11434`.

### Jupyter token issues

* If the browser asks for a token:

  ```bash
  docker logs simple-ollama-env | grep "http://127.0.0.1"
  ```

  Copy the URL with the token.

### Model too big / out of memory

* If 7B or 13B models crash:

  * Use smaller models (0.5B–1B).
  * Close other applications.
  * Reduce concurrency.

### Ports already in use

* Another app may be using `8888` or `11434`.
* In Docker, you can adjust:

  ```bash
  docker run -d --name simple-ollama-env \
    -p 8890:8888 -p 11435:11434 \
    ...
  ```

  Then Jupyter will be on `http://localhost:8890`, Ollama on `http://localhost:11435`.

---

## Checklist

Before moving on:

* ✅ Repo cloned (`simple-ollama-environment`)
* ✅ Dependencies installed (Docker image or venv)
* ✅ Jupyter starts successfully
* ✅ `ollama_quickstart.ipynb` runs a model and prints a response

If all green: you're ready to set up `simple-watsonx-enviroment` next.
