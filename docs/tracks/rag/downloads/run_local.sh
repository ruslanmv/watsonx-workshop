#!/usr/bin/env bash
set -euo pipefail
export PYTHONUNBUFFERED=1
cd accelerator
python -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -e .
uvicorn service.api:app --reload --port 8001 &
sleep 3
streamlit run ui/app.py
