# Makefile for watsonx Workshop Series (ruslanmv)

# --------------- Config ---------------
VENV      ?= .venv
CONFIG    ?= mkdocs.yml
SITE_DIR  ?= site
CHECK_DIR ?= .site_check

PY311     ?= python3.11

PY        := $(VENV)/bin/python
PIP       := $(VENV)/bin/pip
MKDOCS    := $(VENV)/bin/mkdocs

ifeq ($(OS),Windows_NT)
  PY311   ?= py -3.11
  PY      := $(VENV)/Scripts/python.exe
  PIP     := $(VENV)/Scripts/pip.exe
  MKDOCS  := $(VENV)/Scripts/mkdocs.exe
endif

# --------------- Targets ---------------
.PHONY: help install serve build clean clean-venv check gh-deploy check-py311

help:
	@echo ""
	@echo "IBM watsonx Workshop (MkDocs) Commands"
	@echo "--------------------------------------"
	@echo "make install     - Create a Python 3.11 venv and install all dependencies"
	@echo "make check       - Validate mkdocs.yml (strict build into temp dir)"
	@echo "make serve       - Run local MkDocs development server"
	@echo "make build       - Build the static site ($(SITE_DIR))"
	@echo "make clean       - Remove build artifacts ($(SITE_DIR))"
	@echo "make clean-venv  - Remove the Python virtual environment ($(VENV))"
	@echo "make gh-deploy   - Deploy to GitHub Pages (direct)"
	@echo ""

check-py311:
	@echo "→ Ensuring a Python 3.11 interpreter is available ..."
	@$(PY311) -c 'import sys; exit(0) if sys.version_info[:2]==(3,11) else exit(1)' >/dev/null 2>&1 || \
	( echo "❌ Python 3.11 not found. Install it or override PY311=<path> (e.g., PY311=python3)." && exit 1 )

install: check-py311
	@echo "→ Creating virtualenv in '$(VENV)' using: $(PY311)"
	@$(PY311) -m venv $(VENV)
	@echo "→ Upgrading pip & build tooling ..."
	@$(PIP) install --upgrade pip setuptools wheel
	@echo "→ Installing project dependencies from pyproject.toml ..."
	@$(PIP) install -e .
	@echo "→ Verifying mkdocs from venv ..."
	@$(MKDOCS) --version

check:
	@echo "→ Validating mkdocs.yml..."
	@rm -rf $(CHECK_DIR) 2>/dev/null || rmdir /s /q $(CHECK_DIR) 2>nul || true
	@$(MKDOCS) build --strict --site-dir $(CHECK_DIR) >/dev/null
	@rm -rf $(CHECK_DIR) 2>/dev/null || rmdir /s /q $(CHECK_DIR) 2>nul || true
	@echo "✅ mkdocs.yml syntax and navigation OK"

serve:
	@echo "→ Starting dev server (Ctrl+C to stop) ..."
	@$(MKDOCS) serve --strict

build:
	@echo "→ Building static site to $(SITE_DIR)..."
	@$(MKDOCS) build --strict --verbose

clean:
	@echo "→ Cleaning build artifacts..."
	@rm -rf $(SITE_DIR) 2>/dev/null || rmdir /s /q $(SITE_DIR) 2>nul || true

clean-venv:
	@echo "→ Removing virtualenv $(VENV) ..."
	@rm -rf $(VENV) 2>/dev/null || rmdir /s /q $(VENV) 2>nul || true

gh-deploy:
	@echo "→ Deploying to GitHub Pages..."
	@$(MKDOCS) gh-deploy --clean --force
