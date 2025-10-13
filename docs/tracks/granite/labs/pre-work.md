# Lab 0 — Pre-work

**Goal:** Ensure your environment is ready for the Granite labs.

## Steps
1. Create or select a **watsonx.ai Project** in IBM Cloud (optional but recommended).
2. Install Python 3.10+ and create a virtual environment:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # on Windows: .venv\Scriptsctivate
   pip install -U pip
   ```
3. Install developer tooling:
   ```bash
   pip install -U ipykernel jupyter nbformat
   ```
4. (Optional) Install **Ollama** and pull a small local model to test your GPU/CPU:
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ollama pull llama3.2
   ```

## Validation
- You can run `python -V` and `pip list` with no errors.
- (Optional) `ollama run llama3.2` returns a response.
