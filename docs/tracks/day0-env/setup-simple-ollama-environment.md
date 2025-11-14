# Day 0 · Setup Ollama Environment

**Local LLM Sandbox**

Run AI Models on Your Machine

---

## 🎯 Goal of This Module {data-background-color="#0f172a"}

By the end of this lab you will:

* <span class="fragment">Have **`simple-ollama-environment`** repo cloned</span>
* <span class="fragment">Be able to **launch Jupyter Notebook**</span>
* <span class="fragment">**Run `ollama_quickstart.ipynb`** and chat with a local LLM</span>
* <span class="fragment">Understand the basics of **Ollama**</span>

::: notes
This is hands-on! Everyone should be following along on their own machine.

The goal is to get a working local LLM environment - no cloud dependencies, no API keys (yet).
:::

---

## 🤔 What Is Ollama?

<span class="fragment">[Ollama](https://ollama.com/) is the easiest way to run LLMs locally</span>

<span class="fragment">Think of it as **"Docker for AI models"**</span>

* <span class="fragment">Download models with one command</span>
* <span class="fragment">Run them via CLI or API</span>
* <span class="fragment">Works on Mac, Windows, and Linux</span>

::: notes
Ollama abstracts away all the complexity of model quantization, CUDA drivers, memory management, etc.

You just say "ollama pull llama3.2:1b" and it works.

It's become the de facto standard for running local LLMs.
:::

---

## 📁 Repository Overview {data-background-color="#1e293b"}

Let's look at what's inside

---

### Folder Structure

```text
simple-ollama-environment/
├── Dockerfile
├── Makefile
├── pyproject.toml
├── README.md
├── assets/
│   └── screenshot.png
└── notebooks/
    └── ollama_quickstart.ipynb
```

::: notes
This is a minimal, focused repo. Everything you need, nothing you don't.
:::

---

### Key Files Explained

**`Dockerfile`**

* <span class="fragment">Bundles Python 3.11 + Jupyter + Ollama</span>
* <span class="fragment">Optionally pre-pulls a small model</span>

**`Makefile`**

* <span class="fragment">Cross-platform shortcuts: `make install`, `make build-container`</span>

**`pyproject.toml`**

* <span class="fragment">Python dependencies and metadata</span>

**`notebooks/ollama_quickstart.ipynb`**

* <span class="fragment">Your first local LLM chat!</span>

::: notes
The Makefile is your friend - it handles all the repetitive commands so you don't have to remember them.
:::

---

## 📥 Step 1: Clone the Repository {data-background-color="#0f172a"}

Let's get the code

---

### Create a Workshop Folder

First, organize your workspace:

```bash
mkdir -p ~/projects/watsonx-workshop
cd ~/projects/watsonx-workshop
```

::: notes
Keeping all workshop repos in one parent folder makes it easier to navigate.

You can use a different path if you prefer, just be consistent.
:::

---

### Clone the Repo

```bash
git clone https://github.com/ruslanmv/simple-ollama-environment.git
cd simple-ollama-environment
```

<span class="fragment">You should now be inside the repo root.</span>

::: notes
If git is not installed, refer back to the prerequisites module for installation instructions.

Make sure the clone succeeds before moving on.
:::

---

## 🛤️ Step 2: Choose Your Setup Path {data-background-color="#1e293b" data-transition="zoom"}

You have **two options**

---

### Option A: Docker (Recommended)

**Best if:**

* <span class="fragment">You want minimal local setup</span>
* <span class="fragment">You're happy to let Docker handle Python + Ollama</span>
* <span class="fragment">You want consistent environment across machines</span>

::: notes
Docker is the recommended path because it eliminates "works on my machine" issues.

Everything is containerized and reproducible.
:::

---

### Option B: Local Python Environment

**Best if:**

* <span class="fragment">You already have Ollama installed on your host</span>
* <span class="fragment">You prefer running Jupyter directly on your machine</span>
* <span class="fragment">You don't want to deal with Docker</span>

::: notes
This is a valid choice, especially if you're already comfortable managing Python environments.

The trade-off is you need to install Ollama separately.
:::

---

## 🐳 Option A: Docker Setup {data-background-color="#0f172a"}

Let's build and run the container

---

### A.1: Build the Container Image

From the repo root:

```bash
make build-container
```

<span class="fragment">This runs `docker build` and creates an image that includes:</span>

* <span class="fragment">Python 3.11 + dependencies</span>
* <span class="fragment">Jupyter</span>
* <span class="fragment">Ollama server + client</span>
* <span class="fragment">A tiny pre-pulled model (configurable)</span>

::: notes
The first build takes a few minutes because it downloads base images and installs packages.

Subsequent builds are much faster thanks to Docker's layer caching.

You can customize which model gets pre-pulled by setting the PREPULL build arg.
:::

---

### A.2: Run the Container

Launch the environment:

```bash
make run-container
```

<span class="fragment">This will:</span>

* <span class="fragment">Start a container named `simple-ollama-env`</span>
* <span class="fragment">Expose **Jupyter** on `http://localhost:8888`</span>
* <span class="fragment">Expose **Ollama API** on `http://localhost:11434`</span>
* <span class="fragment">Mount your current folder into `/workspace`</span>

::: notes
The volume mount is important - it means your notebook changes persist even if you stop the container.

The named volume `ollama_models` keeps your downloaded models cached.
:::

---

### Manual Docker Run (Alternative)

If you prefer to run manually:

```bash {data-line-numbers="1-5"}
docker run -d --name simple-ollama-env \
  -p 8888:8888 -p 11434:11434 \
  -v "$PWD":/workspace \
  -v ollama_models:/root/.ollama \
  docker.io/ruslanmv/simple-ollama-environment:latest
```

::: notes
Line 1: Run in detached mode with a friendly name
Line 2: Map both Jupyter and Ollama ports
Line 3: Mount current directory for notebook persistence
Line 4: Use named volume for model cache
Line 5: Pull from Docker Hub (or use your local build)
:::

---

### Access Jupyter

Open your browser to:

```
http://localhost:8888
```

<span class="fragment">If it asks for a token, check the container logs:</span>

```bash
docker logs simple-ollama-env | grep "http://127.0.0.1"
```

<span class="fragment">Copy the URL with the token and paste it in your browser</span>

::: notes
The token is generated automatically for security.

Once you've logged in once, your browser should remember it.
:::

---

## 🐍 Option B: Local Python Setup {data-background-color="#1e293b"}

For those who prefer local environments

---

### B.1: Install Ollama on Your Machine

Follow [ollama.com/download](https://ollama.com/download)

**macOS:**

```bash
brew install --cask ollama
```

**Windows:**

```bash
# Use GUI installer or:
winget install Ollama.Ollama
```

**Linux:**

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

::: notes
Ollama usually starts automatically as a background service.

On macOS, you'll see it in your menu bar.

On Windows, it runs as a system tray app.

On Linux, it runs as a systemd service.
:::

---

### B.2: Create Virtual Environment

From the repo root:

```bash
make install
```

<span class="fragment">This will:</span>

* <span class="fragment">Create a Python 3.11 virtualenv</span>
* <span class="fragment">Install dependencies from `pyproject.toml`</span>
* <span class="fragment">Register a Jupyter kernel: **"Python 3.11 (simple-env)"**</span>

::: notes
The Makefile handles all the virtualenv creation and pip installs for you.

If you want to do it manually, you can look inside the Makefile to see the exact commands.
:::

---

### B.3: Start Jupyter

```bash
jupyter notebook
```

<span class="fragment">Then choose the **"Python 3.11 (simple-env)"** kernel when opening notebooks</span>

::: notes
Make sure you select the correct kernel - otherwise the imports won't work.

The kernel name should match what the Makefile registered.
:::

---

## 🤖 Step 3: Pull Ollama Models {data-background-color="#0f172a"}

Let's download some AI models

---

### Understanding Model Sizes

LLMs come in different sizes (parameter counts):

* <span class="fragment">**0.5B–1B**: Tiny, fast, work on any laptop (perfect for learning)</span>
* <span class="fragment">**7B**: Medium quality, need ~8–16GB RAM</span>
* <span class="fragment">**13B–33B**: High quality, need 16GB+ RAM (not recommended for laptops)</span>

::: notes
Parameter count (B = billion) roughly correlates with model capability and resource requirements.

For this workshop, we'll stick with smaller models to ensure everyone can run them.
:::

---

### Pull a Small Model

Examples:

```bash
ollama pull qwen2.5:0.5b-instruct
```

or

```bash
ollama pull llama3.2:1b
```

<span class="fragment">These are small enough to work well on most laptops</span>

::: notes
If you're running Docker, you can exec into the container:

docker exec -it simple-ollama-env ollama pull qwen2.5:0.5b-instruct

Or, if you exposed the Ollama API port, you can run this from your host machine.

The download takes a minute or two depending on your internet speed.
:::

---

### Quick Health Check

Test that Ollama is running:

```bash
curl http://localhost:11434/api/tags
```

<span class="fragment">You should see JSON listing available models</span>

::: notes
This is a simple sanity check that the Ollama server is reachable.

The response shows all the models you've pulled.

If you get "connection refused," the Ollama service isn't running.
:::

---

## 🧪 Step 4: Run the Quickstart Notebook {data-background-color="#1e293b" data-transition="fade"}

Time to chat with your first local LLM!

---

### Open the Notebook

1. <span class="fragment">Open **Jupyter** (container or local)</span>
2. <span class="fragment">Navigate to `notebooks/`</span>
3. <span class="fragment">Open `ollama_quickstart.ipynb`</span>
4. <span class="fragment">Run the cells top to bottom</span>

::: notes
Make sure you're in the notebooks/ folder in the Jupyter file browser.

If you don't see the notebook, you might be in the wrong directory.
:::

---

### What's Inside the Notebook

A simple Python example:

```python {data-line-numbers="1|3-6|7"}
import ollama

response = ollama.chat(
    model="qwen2.5:0.5b-instruct",
    messages=[{"role": "user", "content": "Tell me a joke about AI and coffee."}],
)
print(response["message"]["content"])
```

::: notes
Line 1: Import the Ollama Python client
Lines 3-6: Make a chat request with a model and a message
Line 7: Print the model's response

This is the simplest possible interaction with an LLM.
:::

---

### Expected Output

If everything is wired correctly:

<span class="fragment">You'll get a **text response** from the model</span>

<span class="fragment">Something like:</span>

```
"Why did the AI go to the coffee shop?
Because it wanted to espresso its neural networks!"
```

<span class="fragment">🎉 Congratulations! You just ran your first local LLM!</span>

::: notes
The actual joke will vary each time because of sampling/randomness in the model.

If you get an error instead, we'll troubleshoot in the next slides.
:::

---

## 🔗 How This Relates to RAG {data-background-color="#0f172a"}

Right now: plain prompts to a local model

**Later in the workshop:**

* <span class="fragment">Implement a **local RAG notebook** with Ollama</span>
* <span class="fragment">Compare local RAG vs watsonx.ai RAG</span>
* <span class="fragment">Treat local LLMs and watsonx.ai as **interchangeable backends**</span>

::: notes
What you're learning here:
- How to talk to Ollama's HTTP API / Python client
- How to run notebooks in a controlled environment

This will directly transfer to:
- Calling watsonx.ai in the other repo
- Plugging different LLMs into the accelerator/rag/pipeline.py

The beauty of this architecture is flexibility - you can swap the LLM without changing your RAG pipeline.
:::

---

## 🔧 Troubleshooting {data-background-color="#1e293b"}

Common issues and solutions

---

### Issue: Ollama Not Reachable

**Symptoms:**

* <span class="fragment">"Connection refused" when calling Ollama API</span>

**Solutions:**

* <span class="fragment">Make sure container is running: `docker ps`</span>
* <span class="fragment">Or ensure desktop app/service is started (local)</span>
* <span class="fragment">Test with: `curl http://localhost:11434/api/tags`</span>
* <span class="fragment">In Docker: ensure you mapped `-p 11434:11434`</span>

::: notes
This is the most common issue.

Usually it means the Ollama server isn't running or the port isn't exposed.
:::

---

### Issue: Jupyter Token Problems

**Symptoms:**

* <span class="fragment">Browser asks for a token but you don't have it</span>

**Solution:**

```bash
docker logs simple-ollama-env | grep "http://127.0.0.1"
```

<span class="fragment">Copy the full URL with the token</span>

::: notes
The token is printed to stdout when Jupyter starts.

It's in the container logs, so you can always retrieve it.
:::

---

### Issue: Model Too Big / Out of Memory

**Symptoms:**

* <span class="fragment">Model loading fails or system freezes</span>

**Solutions:**

* <span class="fragment">Use smaller models (0.5B–1B)</span>
* <span class="fragment">Close other applications to free RAM</span>
* <span class="fragment">Reduce concurrency (don't run multiple models at once)</span>

::: notes
If 7B or 13B models crash, it's usually a RAM issue.

Stick to the tiny models for the workshop - they're surprisingly capable for learning purposes.
:::

---

### Issue: Ports Already in Use

**Symptoms:**

* <span class="fragment">Docker error: "port 8888 is already allocated"</span>

**Solution:**

```bash
docker run -d --name simple-ollama-env \
  -p 8890:8888 -p 11435:11434 \
  ...
```

<span class="fragment">Then Jupyter is on `http://localhost:8890`</span>
<span class="fragment">Ollama API on `http://localhost:11435`</span>

::: notes
Another app (maybe another Jupyter instance) might be using those ports.

You can adjust the host port (left side of the colon) to any available port.
:::

---

## ✅ Checklist Before Moving On {data-background-color="#0f172a"}

Make sure you have all of these:

* <span class="fragment">✅ Repo cloned (`simple-ollama-environment`)</span>
* <span class="fragment">✅ Dependencies installed (Docker image or venv)</span>
* <span class="fragment">✅ Jupyter starts successfully</span>
* <span class="fragment">✅ `ollama_quickstart.ipynb` runs and prints a response</span>

::: notes
If all green: you're ready to set up the watsonx environment next.

If anyone is stuck, this is a good time to raise your hand and get help.
:::

---

## 🎉 You Did It! {data-background-color="#1e293b" data-transition="zoom"}

You now have a working **local LLM sandbox**

**Next up:** Setup `simple-watsonx-enviroment`

We'll connect to IBM's enterprise AI platform

::: notes
Great job everyone!

Take a quick break if needed, then we'll move on to the cloud-based environment.
:::

---

## 🚀 Explore More (Optional)

Want to try different models?

**Browse available models:**

```bash
# List what's available on Ollama
curl https://ollama.com/library
```

**Pull other models:**

```bash
ollama pull llama3.2:3b
ollama pull phi3:mini
ollama pull mistral:7b
```

::: notes
Ollama has a huge library of open-source models.

Students can experiment with different models during breaks or after the workshop.

Just remember the RAM requirements!
:::

---

## 💡 Live Demo Link

Try Ollama in your browser (no installation):

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/YOUR_USERNAME/simple-ollama-environment/main?filepath=notebooks/ollama_quickstart.ipynb)

::: notes
This MyBinder link launches a temporary cloud instance with Ollama pre-installed.

Perfect for students who couldn't get Docker working locally.

Note: MyBinder instances are ephemeral and have limited resources.

Update YOUR_USERNAME with the actual GitHub username.
:::