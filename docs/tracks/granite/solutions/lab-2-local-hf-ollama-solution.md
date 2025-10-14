# Granite Lab 2 — Hugging Face & Ollama — Solution

## A) Local transformers
```bash
pip install transformers accelerate torch --upgrade
python - <<'PY'
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
m = "mistralai/Mistral-7B-Instruct-v0.2"
tok = AutoTokenizer.from_pretrained(m)
model = AutoModelForCausalLM.from_pretrained(m, torch_dtype=torch.float16, device_map="auto")
x = tok("Name three good evaluation metrics for RAG.", return_tensors="pt").to(model.device)
y = model.generate(**x, max_new_tokens=120)
print(tok.decode(y[0], skip_special_tokens=True))
PY
```

## B) Ollama
```bash
ollama pull llama3
ollama run llama3 "Three tips for safe prompting?"
```
