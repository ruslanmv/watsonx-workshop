# Lab 3 — Granite on watsonx.ai (Studio + SDK)

**Goal:** Call Granite models on watsonx.ai programmatically.

> Replace placeholders with your credentials/project info.

```python
# pip install ibm-watsonx-ai
from ibm_watsonx_ai import APIClient
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

creds = {
    "url": "https://us-south.ml.cloud.ibm.com",
    "apikey": "<YOUR_API_KEY>"
}
client = APIClient(creds)
client.set.default_project("<YOUR_PROJECT_ID>")

model_id = "ibm/granite-13b-instruct"  # example; pick a model available in your region
params = {
    GenParams.MAX_NEW_TOKENS: 256,
    GenParams.TEMPERATURE: 0.2
}

prompt = "Generate a concise product description for a smart thermostat."
result = client.genai.generate_text(model_id=model_id, inputs=prompt, parameters=params)
print(result)
```

## Few-shot pattern
```python
prompt = """You are a helpful assistant.
Task: Extract key facts as bullet points.

Example:
Input: "IBM was founded in 1911 and is headquartered in Armonk."
Output:
- Founded: 1911
- HQ: Armonk

Input: "Granite models power enterprise use-cases on watsonx.ai including code, chat, and task automation."
Output:
- Platform: watsonx.ai
- Capabilities: code, chat, task automation
"""
result = client.genai.generate_text(model_id=model_id, inputs=prompt, parameters=params)
print(result)
```
