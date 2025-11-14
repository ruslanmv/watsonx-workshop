# Day 0 · Setup watsonx Environment

**watsonx.ai Sandbox**

Connect to IBM's Enterprise AI Platform

---

## 🎯 Goal of This Module {data-background-color="#0f172a"}

By the end of this lab you will:

* <span class="fragment">Have **`simple-watsonx-enviroment`** repo cloned</span>
* <span class="fragment">Provide **IBM Cloud credentials** via a `.env` file</span>
* <span class="fragment">Run `watsonx_quickstart.ipynb` and generate text with **Granite**</span>
* <span class="fragment">Understand how this relates to the **RAG accelerator**</span>

::: notes
This module is all about connecting to IBM's cloud-based AI platform.

Unlike Ollama (which runs locally), this environment calls APIs hosted by IBM.

You'll need valid credentials to proceed.
:::

---

## ☁️ What Is watsonx.ai?

<span class="fragment">IBM's **enterprise-grade AI platform**</span>

* <span class="fragment">Access to **Granite**, **Llama**, and other foundation models</span>
* <span class="fragment">Built-in **governance** and **audit trails**</span>
* <span class="fragment">**Production-ready** infrastructure with SLAs</span>
* <span class="fragment">Integrates with **watsonx.governance** and **watsonx.orchestrate**</span>

::: notes
Think of watsonx.ai as the enterprise alternative to running models locally.

You get:
- Professional-grade models
- Security and compliance features
- Team collaboration
- Scalability

This is what you'd use in a real business setting.
:::

---

## 📁 Repository Overview {data-background-color="#1e293b"}

Let's explore the repo structure

---

### Folder Structure

```text
simple-watsonx-enviroment/
├── Dockerfile
├── Makefile
├── pyproject.toml
├── .env.sample
├── notebooks/
│   └── watsonx_quickstart.ipynb
└── scripts/
    ├── mac/
    ├── ubuntu/
    └── windows/
```

::: notes
Similar structure to the Ollama repo, but with one critical addition: .env.sample

This is where your credentials will live.
:::

---

### Key Files Explained

**`Dockerfile`**

* <span class="fragment">Python 3.11 + Jupyter</span>
* <span class="fragment">`ibm-watsonx-ai` SDK</span>
* <span class="fragment">`langchain-ibm` for LLM integration</span>

**`Makefile`**

* <span class="fragment">`make install` – local venv + Jupyter kernel</span>
* <span class="fragment">`make build-container` – build Docker image</span>
* <span class="fragment">`make run-container` – run with `.env` loaded</span>

**`.env.sample`**

* <span class="fragment">Template for IBM Cloud credentials (you'll copy this to `.env`)</span>

::: notes
The .env.sample file is version-controlled and safe to share.

The actual .env file (which you'll create) contains secrets and should NEVER be committed to git.
:::

---

## 📥 Step 1: Clone the Repository {data-background-color="#0f172a"}

---

### Clone from GitHub

From your main workshop folder:

```bash
cd ~/projects/watsonx-workshop   # or your path
git clone https://github.com/ruslanmv/simple-watsonx-enviroment.git
cd simple-watsonx-enviroment
```

<span class="fragment">You now have both env repos side by side</span>

::: notes
This should be in the same parent folder as simple-ollama-environment.

Keeping them organized makes it easier to switch between environments.
:::

---

## 🔐 Step 2: Configure `.env` {data-background-color="#1e293b"}

**Most important step!**

This is how the environment authenticates to watsonx.ai

---

### Copy the Sample File

```bash
cp .env.sample .env
```

<span class="fragment">Now you have a `.env` file ready to be customized</span>

::: notes
The .env file is listed in .gitignore, so it won't be committed accidentally.

Treat this file as a secret - it contains your API key!
:::

---

### Edit `.env` with Your Credentials

Open `.env` in your editor and fill in:

```bash
# Preferred variables
IBM_CLOUD_API_KEY=your_api_key_here
IBM_CLOUD_URL=https://us-south.ml.cloud.ibm.com
IBM_CLOUD_PROJECT_ID=your_project_id_here

# Compatibility aliases (optional)
WATSONX_APIKEY=${IBM_CLOUD_API_KEY}
WATSONX_URL=${IBM_CLOUD_URL}
PROJECT_ID=${IBM_CLOUD_PROJECT_ID}
```

::: notes
The "compatibility aliases" are there for legacy code that uses different variable names.

They just reference the main variables, so you only need to fill in the top three.
:::

---

### Where to Find: API Key

**IBM Cloud Console → Manage → Access (IAM) → API keys**

* <span class="fragment">Click **"Create"** to generate a new API key</span>
* <span class="fragment">Give it a descriptive name (e.g., "watsonx-workshop")</span>
* <span class="fragment">Copy the key immediately (you can't retrieve it later!)</span>
* <span class="fragment">Paste into `.env` as `IBM_CLOUD_API_KEY`</span>

::: notes
IBM Cloud API keys are like passwords - they grant full access to your account.

Store it safely and never share it publicly.

If you lose it, you'll need to create a new one.
:::

---

### Where to Find: URL

**Typically:** `https://<region>.ml.cloud.ibm.com`

Common regions:

* <span class="fragment">`https://us-south.ml.cloud.ibm.com`</span>
* <span class="fragment">`https://eu-de.ml.cloud.ibm.com`</span>
* <span class="fragment">`https://jp-tok.ml.cloud.ibm.com`</span>

<span class="fragment">Use the region where your watsonx.ai instance is deployed</span>

::: notes
Your instructor should tell you which region to use.

If you're working on your own, check the watsonx.ai service instance details in IBM Cloud.
:::

---

### Where to Find: Project ID

**watsonx.ai UI → Your Project → Settings**

* <span class="fragment">Open your watsonx.ai project</span>
* <span class="fragment">Navigate to **Settings** or **Manage** tab</span>
* <span class="fragment">Look for **"Project ID"** (a long alphanumeric string)</span>
* <span class="fragment">Copy and paste into `.env`</span>

::: notes
The Project ID is unique to your watsonx.ai project.

It's how the SDK knows which project to use for billing and resource management.

Some environments use "space ID" instead - the concept is the same.
:::

---

### 🔒 Security Reminder

**Your `.env` file is secret!**

* <span class="fragment">✅ Listed in `.gitignore` (won't be committed)</span>
* <span class="fragment">✅ Only on your local machine</span>
* <span class="fragment">❌ NEVER commit to git</span>
* <span class="fragment">❌ NEVER share in screenshots</span>
* <span class="fragment">❌ NEVER paste in chat/email</span>

::: notes
This is a good time to remind everyone about credential hygiene.

If you accidentally commit credentials to GitHub:
1. Revoke the API key immediately
2. Generate a new one
3. Use git-filter-branch or BFG Repo-Cleaner to remove it from history

Prevention is much easier than cleanup!
:::

---

## 🛤️ Step 3: Choose Your Setup Path {data-background-color="#0f172a"}

Just like with Ollama, you have **two options**

---

### Option A: Local (virtualenv)

**Best if:**

* <span class="fragment">You prefer running Python directly on your machine</span>
* <span class="fragment">You don't want to deal with Docker</span>
* <span class="fragment">You're comfortable managing virtual environments</span>

---

### Option B: Docker (Recommended)

**Best if:**

* <span class="fragment">You want team consistency</span>
* <span class="fragment">You like reproducible environments</span>
* <span class="fragment">You're already using Docker for Ollama</span>

::: notes
Since most students already have Docker running for Ollama, using it here keeps things consistent.

But local virtualenv is perfectly fine too!
:::

---

## 🐍 Option A: Local Setup {data-background-color="#1e293b"}

---

### Install Dependencies

From the repo root:

```bash
make install
```

<span class="fragment">This will:</span>

* <span class="fragment">Create a Python 3.11 virtual environment</span>
* <span class="fragment">Install dependencies from `pyproject.toml`</span>
* <span class="fragment">Register Jupyter kernel: **"Python 3.11 (watsonx-env)"**</span>

::: notes
The Makefile handles all the heavy lifting.

If you want to see what it's doing, you can look inside the Makefile.
:::

---

### Start Jupyter

```bash
jupyter notebook
```

<span class="fragment">Choose the **"Python 3.11 (watsonx-env)"** kernel when opening notebooks</span>

::: notes
Make sure to select the correct kernel!

Otherwise, the ibm-watsonx-ai package won't be available.
:::

---

## 🐳 Option B: Docker Setup {data-background-color="#0f172a"}

---

### Build the Image

From the repo root:

```bash
make build-container
```

<span class="fragment">Creates an image (e.g., `simple-watsonx-env:latest`)</span>

::: notes
This takes a few minutes on first build.

It downloads the base Python image and installs all the IBM watsonx SDK dependencies.
:::

---

### Run the Container

```bash
make run-container
```

<span class="fragment">This will:</span>

* <span class="fragment">Mount your `.env` file (so credentials are available)</span>
* <span class="fragment">Mount current directory to `/workspace`</span>
* <span class="fragment">Expose Jupyter on `http://localhost:8888`</span>

::: notes
The --env-file flag is crucial - it loads your credentials into the container environment.

Without it, authentication will fail.
:::

---

### Manual Docker Run (Alternative)

If you prefer manual control:

```bash {data-line-numbers="1-5"}
docker run -d --name watsonx-env \
  --env-file .env \
  -p 8888:8888 \
  -v "$(pwd)":/workspace \
  simple-watsonx-env:latest
```

::: notes
Line 1: Run in detached mode with name "watsonx-env"
Line 2: Load environment variables from .env
Line 3: Map Jupyter port
Line 4: Mount current directory for persistence
Line 5: Use the image we just built
:::

---

### Access Jupyter

Open browser to:

```
http://localhost:8888
```

<span class="fragment">Your notebooks and code edits stay on the host (via volume mount)</span>

::: notes
If it asks for a token, check the container logs:

docker logs watsonx-env

Copy the URL with the token.
:::

---

## 🧪 Step 4: Run the Quickstart Notebook {data-background-color="#1e293b"}

Time to confirm that credentials + environment are correct

---

### Open the Notebook

1. <span class="fragment">Open **Jupyter** (local or container)</span>
2. <span class="fragment">Navigate to `notebooks/`</span>
3. <span class="fragment">Open `watsonx_quickstart.ipynb`</span>
4. <span class="fragment">Run the cells in order</span>

::: notes
This is the moment of truth!

If credentials are set up correctly, you'll successfully call the watsonx.ai API.
:::

---

### What's Inside: Imports & Setup

```python {data-line-numbers="1-5|7|9-11"}
import os
from dotenv import load_dotenv
from ibm_watsonx_ai import APIClient, Credentials
from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

load_dotenv()

api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")
```

::: notes
Lines 1-5: Import necessary libraries
Line 7: Load .env file into environment
Lines 9-11: Read credentials from environment variables

The "or" pattern handles both naming conventions.
:::

---

### What's Inside: Create Client

```python {data-line-numbers="1-2|4-8"}
credentials = Credentials(url=url, api_key=api_key)
client = APIClient(credentials=credentials, project_id=project_id)

model = ModelInference(
    model_id="ibm/granite-13b-instruct-v2",
    credentials=credentials,
    project_id=project_id,
)
```

::: notes
Lines 1-2: Initialize credentials and API client
Lines 4-8: Create a model inference object

This is the pattern you'll use throughout the workshop.

Granite is IBM's family of open-source foundation models.
:::

---

### What's Inside: Generate Text

```python {data-line-numbers="1-4|6-9|11"}
params = {
    GenParams.DECODING_METHOD: "greedy",
    GenParams.MAX_NEW_TOKENS: 200,
}

prompt = "Write a short story about a robot who wants to be a painter."

response = model.generate_text(
    prompt=prompt,
    params=params,
)
print(response)
```

::: notes
Lines 1-4: Set generation parameters (greedy decoding, max 200 tokens)
Lines 6-9: Define prompt and call the model
Line 11: Print the response

Greedy decoding means always picking the most likely next token (deterministic).
:::

---

### Expected Output

If everything is configured correctly:

<span class="fragment">You'll see **model output** printed in the notebook</span>

<span class="fragment">Something like:</span>

```
"In a world of circuits and code, there lived a robot named Artie.
Artie had always dreamed of becoming a painter, but robots weren't
supposed to create art—they were supposed to follow instructions..."
```

<span class="fragment">🎉 Success! You're now using enterprise AI!</span>

::: notes
The actual story will vary based on the model and any randomness in the parameters.

If you get an error, we'll troubleshoot in the next slides.
:::

---

## 🎨 Optional: LangChain Integration {data-background-color="#0f172a"}

Prefer the LangChain API style?

---

### LangChain-Style Code

```python {data-line-numbers="1-4|6-12|14"}
from langchain_ibm import WatsonxLLM
from dotenv import load_dotenv
import os

load_dotenv()
llm = WatsonxLLM(
    model_id="ibm/granite-13b-instruct-v2",
    url=os.getenv("IBM_CLOUD_URL"),
    apikey=os.getenv("IBM_CLOUD_API_KEY"),
    project_id=os.getenv("IBM_CLOUD_PROJECT_ID"),
    params={"decoding_method": "greedy", "max_new_tokens": 128},
)

print(llm.invoke("Give me 3 study tips for Python."))
```

::: notes
Lines 1-4: Import LangChain watsonx integration
Lines 6-12: Create LangChain LLM wrapper
Line 14: Use the simple .invoke() method

LangChain provides a unified interface across different LLM providers.

We'll build on this pattern in later labs, especially for RAG.
:::

---

## 🔗 Connection to the Accelerator {data-background-color="#1e293b"}

How does this relate to the production RAG code?

---

### The `accelerator/` Project

Located in `watsonx-workshop/accelerator/`:

**Core RAG Logic:**

* <span class="fragment">`rag/retriever.py` - Fetch relevant documents from vector DB</span>
* <span class="fragment">`rag/pipeline.py` - Combine retrieval + generation</span>
* <span class="fragment">`rag/prompt.py` - Template management</span>

**API:**

* <span class="fragment">`service/api.py` - FastAPI app exposing `POST /ask`</span>
* <span class="fragment">`service/deps.py` - Configuration (URL, API key, project, etc.)</span>

::: notes
The accelerator is where you'll build a production-like RAG service.

Everything you're learning in these sandbox environments will be applied there.
:::

---

### The Pattern You Just Learned

In `watsonx_quickstart.ipynb` you learned:

* <span class="fragment">Loading credentials from `.env`</span>
* <span class="fragment">Creating a watsonx.ai client</span>
* <span class="fragment">Calling Granite with structured params</span>

**This will be refactored into:**

* <span class="fragment">Setup code in `service/deps.py`</span>
* <span class="fragment">Model invocation in `rag/pipeline.py`</span>

::: notes
Think of `simple-watsonx-enviroment` as your **playground**.

Think of `accelerator/` as your **real application**.

The patterns are the same, just organized differently for production use.
:::

---

## 📚 Reference Notebooks {data-background-color="#0f172a"}

Once your environment is stable, explore these examples

---

### RAG & Vector DB Examples (`labs-src/`)

* <span class="fragment">**Elasticsearch + LangChain**</span>
  <span class="fragment">`use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb`</span>

* <span class="fragment">**Elasticsearch Python SDK**</span>
  <span class="fragment">`use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb`</span>

* <span class="fragment">**Chroma + LangChain**</span>
  <span class="fragment">`use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`</span>

::: notes
These notebooks show different vector database integrations.

They'll inspire your RAG implementation on Day 2.

Elasticsearch and Chroma are popular production vector stores.
:::

---

### Accelerator Notebooks (`accelerator/assets/notebook/`)

**Ingestion & Indexing:**

* <span class="fragment">`Process_and_Ingest_Data_into_Vector_DB.ipynb`</span>
* <span class="fragment">`Process_and_Ingest_Data_from_COS_into_vector_DB.ipynb`</span>

**RAG Q&A:**

* <span class="fragment">`QnA_with_RAG.ipynb`</span>
* <span class="fragment">`Create_and_Deploy_QnA_AI_Service.ipynb`</span>

**Evaluation:**

* <span class="fragment">`Analyze_Log_and_Feedback.ipynb`</span>

::: notes
These show the complete end-to-end workflow:

Raw documents → chunks → embeddings → vector DB → Q&A → deployment → analysis

This is production-ready code you can adapt.
:::

---

## 🔧 Troubleshooting {data-background-color="#1e293b"}

Common issues and how to fix them

---

### Issue: 401 / 403 Authentication Errors

**Symptoms:**

* <span class="fragment">"Unauthorized" or "Forbidden" when calling API</span>

**Check:**

* <span class="fragment">`IBM_CLOUD_API_KEY` is correct (no trailing spaces)</span>
* <span class="fragment">You pasted the whole key</span>
* <span class="fragment">Correct `IBM_CLOUD_URL` for your region</span>
* <span class="fragment">Project ID is valid and you have access</span>

::: notes
Copy-paste errors are common - extra spaces or missing characters.

Also verify you have the right permissions in IBM Cloud IAM.
:::

---

### Issue: Project Not Found / 404

**Symptoms:**

* <span class="fragment">"Project not found" error</span>

**Check:**

* <span class="fragment">Double-check the **Project ID** in watsonx.ai UI</span>
* <span class="fragment">Ensure you're using the right region</span>
* <span class="fragment">Verify it's a project (not a space), or vice versa</span>

::: notes
Sometimes people mix up project ID and space ID.

Both exist, but you need to use the correct type for your setup.
:::

---

### Issue: `.env` Not Loading

**Symptoms:**

* <span class="fragment">Credentials are `None` even though `.env` exists</span>

**Check:**

* <span class="fragment">`.env` is in the repo root (same folder as Makefile)</span>
* <span class="fragment">Notebook calls `load_dotenv()` at the top</span>
* <span class="fragment">If Docker: confirm `--env-file .env` is passed</span>

::: notes
The load_dotenv() call is crucial - without it, the .env file won't be read.

Also check for typos in variable names.
:::

---

### Issue: Jupyter Kernel Missing

**Symptoms:**

* <span class="fragment">Can't find the "watsonx-env" kernel</span>

**Solution:**

```bash
make install
```

<span class="fragment">Restart Jupyter and select the new kernel</span>

::: notes
Sometimes the kernel registration fails silently.

Re-running make install usually fixes it.
:::

---

### Issue: Corporate Proxies

**Symptoms:**

* <span class="fragment">Timeouts when building Docker or accessing IBM Cloud</span>

**Solution:**

* <span class="fragment">Configure `HTTP_PROXY` / `HTTPS_PROXY` environment variables</span>
* <span class="fragment">Add proxy settings to Docker build and run commands</span>

::: notes
Corporate networks often require proxy configuration.

Talk to your IT department for the correct proxy URLs.
:::

---

## ✅ Checklist Before Moving On {data-background-color="#0f172a"}

Make sure you have all of these:

* <span class="fragment">✅ `simple-watsonx-enviroment` cloned</span>
* <span class="fragment">✅ `.env` configured with API key, URL, Project ID</span>
* <span class="fragment">✅ Dependencies installed (venv or Docker)</span>
* <span class="fragment">✅ `watsonx_quickstart.ipynb` runs and returns a Granite response</span>
* <span class="fragment">✅ You know where the `accelerator/` project is</span>

::: notes
Next up: we'll do a combined verification of both environments (Ollama + watsonx).

If everything is green here, you're in great shape!
:::

---

## 🎉 Congratulations! {data-background-color="#1e293b" data-transition="zoom"}

You now have access to **enterprise-grade AI models**

**Next:** Combined verification of both environments

---

## 💡 Live Demo Link

Try watsonx.ai in Google Colab (bring your credentials):

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/YOUR_USERNAME/simple-watsonx-enviroment/blob/main/notebooks/watsonx_quickstart.ipynb)

::: notes
This Colab link lets students run the notebook in the cloud.

They'll still need to provide their own IBM Cloud credentials.

Update YOUR_USERNAME with the actual GitHub username.
:::