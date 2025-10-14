# Granite Lab 1 — Overview & Playground — Solution

## Studio steps
1. Open watsonx.ai, select your Project.
2. Open Prompt Lab → choose a Granite Instruct model.
3. Test 2–3 prompts, save one as a Prompt Template.

## SDK verification
```python
from ibm_watsonx_ai import Credentials
from ibm_watsonx_ai.foundation_models import Model
import os

creds = Credentials(url=os.getenv("WATSONX_URL"), api_key=os.getenv("WATSONX_APIKEY"))
model = Model(
    model_id=os.getenv("LLM_MODEL_ID","ibm/granite-3-3-8b-instruct"),
    credentials=creds,
    project_id=os.getenv("WATSONX_PROJECT_ID"),
    params={"decoding_method":"greedy","max_new_tokens":128,"temperature":0.2}
)
print(model.generate_text(prompt="Give me two bullets on responsible AI.")[
    "results"][0]["generated_text"].strip())
```
