# 0.4 Verify Both Environments

At this point you've set up:

- `simple-ollama-environment` – local LLM sandbox.
- `simple-watsonx-enviroment` – watsonx.ai sandbox.

This final Day 0 module is a **sanity check** to make sure everything works *together*, and that you're ready for Day 1.

---

## Goal

- Confirm you can:
  - Run a local model via Ollama **inside a notebook**.
  - Run a Granite model via watsonx.ai **inside a notebook**.
- Confirm that:
  - The `accelerator/` folder is present and notebooks open.
  - The `labs-src/` reference notebooks open.
- End with a clear **ready / not ready** checklist.

---

## Quick Verification Script / Notebook

You can create a tiny notebook (e.g. `verify_envs.ipynb`) in your main folder that does:

```python
# verify_envs.ipynb

import os
from dotenv import load_dotenv

print("🔎 Verifying environments...")

# 1) Test Ollama client
try:
    import ollama
    print("✅ ollama Python package is importable")

    res = ollama.chat(
        model="qwen2.5:0.5b-instruct",  # or any model you've pulled
        messages=[{"role": "user", "content": "Say hello from Ollama."}],
    )
    print("Ollama says:", res["message"]["content"][:100], "...")
except Exception as e:
    print("❌ Ollama check failed:", e)

# 2) Test watsonx.ai client
try:
    load_dotenv()  # pick up .env from simple-watsonx-enviroment if you run this there
    from ibm_watsonx_ai import Credentials
    from ibm_watsonx_ai.foundation_models import ModelInference
    from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

    api_key = os.getenv("IBM_CLOUD_API_KEY") or os.getenv("WATSONX_APIKEY")
    url = os.getenv("IBM_CLOUD_URL") or os.getenv("WATSONX_URL")
    project_id = os.getenv("IBM_CLOUD_PROJECT_ID") or os.getenv("PROJECT_ID")

    if not api_key or not url or not project_id:
        raise ValueError("Missing one of IBM_CLOUD_API_KEY / IBM_CLOUD_URL / IBM_CLOUD_PROJECT_ID")

    creds = Credentials(url=url, api_key=api_key)
    model = ModelInference(
        model_id="ibm/granite-13b-instruct-v2",  # or another allowed Granite model
        credentials=creds,
        project_id=project_id,
    )

    params = {
        GenParams.DECODING_METHOD: "greedy",
        GenParams.MAX_NEW_TOKENS: 50,
    }

    response = model.generate_text(
        prompt="Say hello from watsonx.ai in one sentence.",
        params=params,
    )
    print("✅ watsonx.ai call succeeded:")
    print(response)
except Exception as e:
    print("❌ watsonx.ai check failed:", e)
```

You don't **have** to create this combined notebook, but it's a nice, quick sanity check.

Alternatively, you can simply:

* Run `ollama_quickstart.ipynb` in `simple-ollama-environment`.
* Run `watsonx_quickstart.ipynb` in `simple-watsonx-enviroment`.

---

## Pair Check Exercise

If you're in a classroom setting, do a quick **pair verification**:

1. Pair up with someone next to you.
2. Each person shows:

   * Jupyter running in **`simple-ollama-environment`**.
   * `ollama_quickstart.ipynb` successfully returns a model response.
3. Then each person shows:

   * Jupyter running in **`simple-watsonx-enviroment`**.
   * `watsonx_quickstart.ipynb` successfully returns a Granite response.

This often surfaces:

* Small typos in `.env`.
* Misconfigured paths.
* Port conflicts.

And you get to practice explaining what you did – which already reinforces Day 1 concepts.

---

## Confirm Accelerator & Notebook Packs

Next, verify your **project scaffolding** is complete.

### Check the `accelerator/` directory

From the `watsonx-workshop` repo root:

```bash
ls accelerator
```

You should see something like:

```text
assets/  assettypes/  config.yaml  rag/  service/  tools/  ui/  ...
```

Try opening one of the accelerator notebooks (read-only is fine for now):

* `accelerator/assets/notebook/notebook:Create_and_Deploy_QnA_AI_Service.ipynb`

Make sure:

* Jupyter loads the notebook.
* You can scroll through the cells.

### Check the `labs-src/` folder

From the same repo:

```bash
ls labs-src
```

You should see:

```text
README.md
use-watsonx-elasticsearch-and-langchain-to-answer-questions-rag.ipynb
use-watsonx-and-elasticsearch-python-sdk-to-answer-questions-rag.ipynb
use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb
ibm-watsonx-governance-evaluation-studio-getting-started.ipynb
ibm-watsonx-governance-governed-agentic-catalog.ipynb
```

Open one as a **preview**, for example:

* `use-watsonx-chroma-and-langchain-to-answer-questions-rag.ipynb`

We'll use these as reference implementations during Day 2–3.

---

## Common Failure Modes

Here are some frequent issues and what to do about them.

### Ollama issues

* **"Connection refused" / timeout**

  * Ensure Ollama server is running:

    * In Docker: container up with port `11434` exposed.
    * Local: Ollama app/service started.
* **"Model not found"**

  * Pull the model:

    ```bash
    ollama pull qwen2.5:0.5b-instruct
    ```
* **Out-of-memory**

  * Use smaller models (e.g., 0.5B–1B variants).

### watsonx.ai issues

* **401 / 403**

  * Check API key, URL, project ID in `.env`.
  * Confirm you have permissions to use watsonx.ai in that project.

* **Project not found / invalid region**

  * Double-check region and project ID from the watsonx UI.

### Docker issues

* **Ports already in use**

  * Change host port mapping (`-p 8890:8888`, etc.).
* **Cannot connect to Docker Daemon**

  * Ensure Docker Desktop or Docker Engine is running.
  * On Linux, check your user is in the `docker` group.

---

## What to Do If Something Fails

If you hit issues:

1. **Capture the error**

   * Copy the error message and the command you ran.
2. **Ask for help**

   * Instructor / Slack / Teams channel.
3. **Fallback paths**

   * If local Docker or Ollama is blocked:

     * You can still follow many labs in the watsonx environment.
     * Or use a pre-provisioned VM / cloud notebook if your team provides one.

The key is: by the time Day 1 starts, you should at least have **one working LLM path** (preferably both).

---

## End-of-Day 0 Checklist

Tick off each of these:

* ✅ `simple-ollama-environment`:

  * Repo cloned.
  * Jupyter working.
  * `ollama_quickstart.ipynb` returns a model response.
* ✅ `simple-watsonx-enviroment`:

  * Repo cloned.
  * `.env` configured with valid IBM Cloud API key, URL, project ID.
  * Jupyter working.
  * `watsonx_quickstart.ipynb` returns a Granite response.
* ✅ `accelerator/`:

  * Folder present.
  * Notebooks under `accelerator/assets/notebook/` open.
* ✅ `labs-src/`:

  * Notebooks open and are readable.
* ✅ You can comfortably:

  * Switch between repos.
  * Explain (at a high level) the difference between:

    * Local LLMs via Ollama.
    * Hosted LLMs via watsonx.ai.

If the answer is "yes" to all of the above:
🎉 Congratulations! You're ready for **Day 1 – LLMs & Prompting**.
