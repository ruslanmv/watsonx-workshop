# Granite Lab 3B — Prompt Templates & Deployment — Solution

## Runtime templating
```python
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import Model
import os

creds = Credentials(url=os.getenv("WATSONX_URL"), api_key=os.getenv("WATSONX_APIKEY"))
model = Model(
  model_id=os.getenv("LLM_MODEL_ID","ibm/granite-3-3-8b-instruct"),
  credentials=creds,
  project_id=os.getenv("WATSONX_PROJECT_ID"),
  params={"decoding_method":"greedy","max_new_tokens":200,"temperature":0.2}
)
tmpl = "Write a {tone} summary for an {audience} about {topic} (<=120 words)."
print(model.generate_text(prompt=tmpl.format(tone="neutral", audience="CTO", topic="RAG patterns"))
      ["results"][0]["generated_text"].strip())
```
