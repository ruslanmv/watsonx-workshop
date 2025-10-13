# Pre-work

> 15–30 minutes

## Install

- Python 3.10/3.11
- Create a virtual environment
- `pip install -r docs/tracks/rag/downloads/requirements.txt`

## Accounts & Access

- IBM Cloud account with **watsonx.ai** enabled
- Elastic Cloud or self-hosted Elasticsearch (optional; use Chroma for local-only)

## Verify

```bash
python -c "import ibm_watsonx_ai, elasticsearch, chromadb, langchain; print('OK')"
```
