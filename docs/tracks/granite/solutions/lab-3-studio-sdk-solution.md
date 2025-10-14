# Granite Lab 3 — watsonx.ai (Studio + SDK) — Solution

## Studio
- Create/select Project, open Prompt Lab, choose Granite model.
- Save Prompt Template + create Deployment.

## SDK
```python
import os
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import Model

creds = Credentials(url=os.getenv("WATSONX_URL"), api_key=os.getenv("WATSONX_APIKEY"))
gen = Model(
    model_id=os.getenv("LLM_MODEL_ID","ibm/granite-3-3-8b-instruct"),
    credentials=creds,
    project_id=os.getenv("WATSONX_PROJECT_ID"),
    params={"decoding_method":"greedy","max_new_tokens":256,"temperature":0.2}
)
prompt = "Summarize watsonx.ai enterprise benefits in 3 bullets."
print(gen.generate_text(prompt=prompt)["results"][0]["generated_text"].strip())
```
