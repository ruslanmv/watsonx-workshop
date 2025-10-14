# Granite Lab 0 — Pre-work — Solution

## Goal
Set up your tools and verify access to IBM Cloud and watsonx.ai.

## Checklist
- Python 3.11+, pip, git are installed.
- Optional: IBM Cloud CLI + `machine-learning` plugin installed.
- `.env` contains WATSONX_URL, WATSONX_APIKEY, WATSONX_PROJECT_ID.

## Commands
```bash
python3 --version
pip --version
git --version
python -m venv .venv && source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt
ibmcloud login --sso  # optional
```
