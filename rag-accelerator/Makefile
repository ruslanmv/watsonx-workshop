VENV=.venv
PY=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
.PHONY: venv install extract chunk index api ui all clean
venv:
	python -m venv $(VENV)
install: venv
	$(PIP) install -U pip
	$(PIP) install -e .
extract:
	$(PY) tools/extract.py --config config.yaml
chunk:
	$(PY) tools/chunk.py --config config.yaml
index:
	$(PY) tools/embed_index.py
api:
	$(VENV)/bin/uvicorn service.api:app --reload --port 8001
ui:
	$(VENV)/bin/streamlit run ui/app.py
all: extract chunk index
	@echo "✅ Pipeline ready. Now run: make api  (and in another terminal) make ui"
clean:
	rm -rf data/clean data/chunks index/chroma
