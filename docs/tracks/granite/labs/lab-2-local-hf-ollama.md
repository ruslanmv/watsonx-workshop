# Lab 2 — Granite via Hugging Face & Ollama (Local)

**Goal:** Run a local model to prototype flows offline.

> Use a small CPU-friendly model locally for the mechanics. Swap to Granite on watsonx.ai for higher quality.

## Transformers (CPU-friendly skeleton)
```python
# pip install transformers accelerate torch --extra-index-url https://download.pytorch.org/whl/cpu
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

model_id = "meta-llama/Llama-3.2-1B"  # placeholder; pick a small CPU model
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, torch_dtype=torch.float32)

prompt = "List three design principles of scalable APIs."
inputs = tokenizer(prompt, return_tensors="pt")
outputs = model.generate(**inputs, max_new_tokens=128)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
```

## Ollama (simple streaming chat)
```bash
# Install Ollama, then pull a local model:
ollama pull llama3.2
```

```python
# pip install requests
import requests, json
resp = requests.post("http://localhost:11434/api/generate",
    json={"model":"llama3.2","prompt":"Explain idempotency in REST APIs."},
    stream=True)
for chunk in resp.iter_lines():
    if chunk:
        print(json.loads(chunk.decode())["response"], end="")
```
