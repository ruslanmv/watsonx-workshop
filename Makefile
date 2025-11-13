# Makefile for watsonx Workshop Series (ruslanmv)
# Enhanced with Professional Slide Generation (Reveal.js + PDF)

SHELL := /usr/bin/env bash

# =============== Original MkDocs Config ===============
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

# =============== Slide Generation Config ===============
# Use multi-arch DeckTape image so it works on amd64 *and* arm64 (e.g. Apple Silicon)
DECKTAPE_IMAGE ?= ghcr.io/astefanutti/decktape:3.15.0
SLIDE_SIZE     ?= 1920x1080

# PDF Export (explicit range + extended timing for all slides)
PDF_SLIDES     ?= 1-100
LOAD_PAUSE     ?= 8000
PAUSE          ?= 2000

# Slide Theming
REVEAL_THEME      ?= black
REVEAL_TRANSITION ?= convex
HIGHLIGHT_STYLE   ?= zenburn

# MathJax Support (set to "yes" to enable LaTeX math, "no" to disable)
ENABLE_MATH       ?= yes

# Source file for single-file generation (can be overridden)
SOURCE_MD ?=

# PDF merge tool (for day-level combined PDFs)
PDF_MERGE ?= pdfunite

# =============== Phony Targets ===============
.PHONY: help install check-py311 install-tools bootstrap \
        serve serve-noslides serve-with-slides \
        build build-complete build-quick \
        check check-tools \
        clean clean-venv clean-slides clean-all \
        gh-deploy \
        slides slides-one slides-dark slides-light slides-tech slides-creative slides-all \
        pdf pdf-one pdf-debug pdf-all pdf-days \
        info

# =============== Help ===============
help:
	@echo ""
	@echo "================================================================"
	@echo "  IBM watsonx Workshop - MkDocs + Reveal.js Slides"
	@echo "================================================================"
	@echo ""
	@echo "QUICK START:"
	@echo "  make install         - Install Python deps + external tools"
	@echo "  make slides          - Generate ALL HTML slides (black theme)"
	@echo "  make pdf             - Export PDFs for ALL slide decks"
	@echo "  make pdf-days        - Merge per-deck PDFs into one PDF per day"
	@echo "  make serve-with-slides - Rebuild slides then preview site"
	@echo ""
	@echo "ORIGINAL MKDOCS COMMANDS:"
	@echo "  make check           - Validate mkdocs.yml"
	@echo "  make build           - Build the static site ($(SITE_DIR))"
	@echo "  make clean           - Remove build artifacts"
	@echo "  make clean-venv      - Remove Python virtual environment"
	@echo "  make gh-deploy       - Deploy to GitHub Pages"
	@echo ""
	@echo "SLIDE GENERATION:"
	@echo "  make slides          - Generate slides for ALL workshop content"
	@echo "  make slides-all      - Same as 'make slides'"
	@echo "  make slides-one SOURCE_MD=path/to/file.md"
	@echo "                       - Generate slides from a single Markdown file"
	@echo "  make slides-dark     - All slides in dark theme"
	@echo "  make slides-light    - All slides in light theme"
	@echo "  make slides-tech     - All slides in technical dark theme"
	@echo "  make slides-creative - All slides in vibrant sky theme"
	@echo ""
	@echo "SINGLE FILE GENERATION:"
	@echo "  make slides-one SOURCE_MD=docs/tracks/day1-llm/llm-concepts.md"
	@echo ""
	@echo "PDF EXPORT:"
	@echo "  make pdf             - Export ALL generated HTML slides to PDFs (per deck)"
	@echo "  make pdf-all         - Same as 'make pdf'"
	@echo "  make pdf-days        - Merge per-deck PDFs into one PDF per day (day0.pdf, day1.pdf, ...)"
	@echo "  make pdf-one HTML_REL=... PDF_REL=..."
	@echo "                       - Export a single deck to PDF"
	@echo "  make pdf-debug       - Export debug PDF + screenshots"
	@echo ""
	@echo "COMBINED BUILDS:"
	@echo "  make build-complete  - Build everything (docs + slides + PDF)"
	@echo "  make build-quick     - Build docs + slides (skip PDF)"
	@echo ""
	@echo "DEVELOPMENT:"
	@echo "  make serve-with-slides - Rebuild slides then serve"
	@echo "  make serve-noslides    - Serve without rebuilding slides"
	@echo ""
	@echo "CLEANUP:"
	@echo "  make clean-slides    - Remove only generated slides"
	@echo "  make clean-all       - Remove everything (site + slides + venv)"
	@echo ""
	@echo "DIAGNOSTICS:"
	@echo "  make check-tools     - Verify external tools (Pandoc, Docker)"
	@echo "  make info            - Show current configuration"
	@echo ""
	@echo "CONFIGURATION:"
	@echo "  REVEAL_THEME=$(REVEAL_THEME) REVEAL_TRANSITION=$(REVEAL_TRANSITION)"
	@echo "  PDF_SLIDES=$(PDF_SLIDES) LOAD_PAUSE=$(LOAD_PAUSE)ms PAUSE=$(PAUSE)ms"
	@echo "  ENABLE_MATH=$(ENABLE_MATH)"
	@echo "  DECKTAPE_IMAGE=$(DECKTAPE_IMAGE)"
	@echo "  PDF_MERGE=$(PDF_MERGE)"
	@echo "================================================================"
	@echo ""

# =============== Installation ===============
check-py311:
	@echo "→ Ensuring a Python 3.11 interpreter is available ..."
	@$(PY311) -c 'import sys; exit(0) if sys.version_info[:2]==(3,11) else exit(1)' >/dev/null 2>&1 || \
	( echo "❌ Python 3.11 not found. Install it or override PY311=<path> (e.g., PY311=python3)." && exit 1 )

install-tools: bootstrap
	@echo "✅ External tools check complete"

bootstrap:
	@if [ -f scripts/bootstrap.sh ]; then \
		bash scripts/bootstrap.sh; \
	else \
		echo "⚠️  scripts/bootstrap.sh not found - skipping tool installation"; \
		echo "   Manually ensure: Pandoc, Docker are installed"; \
	fi

install: check-py311 install-tools
	@echo "→ Creating virtualenv in '$(VENV)' using: $(PY311)"
	@$(PY311) -m venv $(VENV)
	@echo "→ Upgrading pip & build tooling ..."
	@$(PIP) install --upgrade pip setuptools wheel
	@echo "→ Installing project dependencies from pyproject.toml ..."
	@$(PIP) install -e .
	@echo "→ Verifying mkdocs from venv ..."
	@$(MKDOCS) --version
	@echo "✅ Installation complete!"

# =============== Validation ===============
check:
	@echo "→ Validating mkdocs.yml..."
	@rm -rf $(CHECK_DIR) 2>/dev/null || rmdir /s /q $(CHECK_DIR) 2>nul || true
	@$(MKDOCS) build --strict --site-dir $(CHECK_DIR) >/dev/null
	@rm -rf $(CHECK_DIR) 2>/dev/null || rmdir /s /q $(CHECK_DIR) 2>nul || true
	@echo "✅ mkdocs.yml syntax and navigation OK"

check-tools:
	@echo "================================================================"
	@echo "Checking external dependencies..."
	@echo "================================================================"
	@command -v pandoc >/dev/null 2>&1 && echo "✅ Pandoc: $$(pandoc --version | head -n1)" || echo "❌ Pandoc: NOT FOUND"
	@command -v docker >/dev/null 2>&1 && echo "✅ Docker: $$(docker --version)" || echo "❌ Docker: NOT FOUND"
	@command -v python3 >/dev/null 2>&1 && echo "✅ Python: $$(python3 --version)" || echo "❌ Python: NOT FOUND"
	@echo "================================================================"

# =============== Slide Generation ===============
# 'slides' ≡ 'slides-all'
slides:
	@$(MAKE) slides-all

# Single-file slide generation (optional helper)
slides-one:
	@if [ -z "$(SOURCE_MD)" ]; then \
		echo "❌ SOURCE_MD is required for slides-one."; \
		echo "   Example:"; \
		echo "     make slides-one SOURCE_MD=docs/tracks/day1-llm/llm-concepts.md"; \
		exit 1; \
	fi; \
	echo "→ Generating slides for: $(SOURCE_MD)"; \
	SOURCE_MD="$(SOURCE_MD)" \
	REVEAL_THEME="$(REVEAL_THEME)" \
	REVEAL_TRANSITION="$(REVEAL_TRANSITION)" \
	HIGHLIGHT_STYLE="$(HIGHLIGHT_STYLE)" \
	ENABLE_MATH="$(ENABLE_MATH)" \
	bash scripts/generate_slides.sh

slides-all:
	@echo "→ Generating all workshop slides..."
	@if [ -f scripts/generate_all_slides.sh ]; then \
		REVEAL_THEME="$(REVEAL_THEME)" \
		REVEAL_TRANSITION="$(REVEAL_TRANSITION)" \
		HIGHLIGHT_STYLE="$(HIGHLIGHT_STYLE)" \
		ENABLE_MATH="$(ENABLE_MATH)" \
		bash scripts/generate_all_slides.sh; \
	else \
		echo "❌ scripts/generate_all_slides.sh not found"; \
		echo "   Create it to batch-generate slides for all content"; \
		exit 1; \
	fi

slides-dark:
	@echo "→ Generating DARK theme slides for ALL decks..."
	@REVEAL_THEME=black \
	 REVEAL_TRANSITION=convex \
	 HIGHLIGHT_STYLE=zenburn \
	 ENABLE_MATH="$(ENABLE_MATH)" \
	 $(MAKE) slides-all

slides-light:
	@echo "→ Generating LIGHT theme slides for ALL decks..."
	@REVEAL_THEME=white \
	 REVEAL_TRANSITION=fade \
	 HIGHLIGHT_STYLE=pygments \
	 ENABLE_MATH="$(ENABLE_MATH)" \
	 $(MAKE) slides-all

slides-tech:
	@echo "→ Generating TECHNICAL theme slides for ALL decks..."
	@REVEAL_THEME=night \
	 REVEAL_TRANSITION=slide \
	 HIGHLIGHT_STYLE=zenburn \
	 ENABLE_MATH="$(ENABLE_MATH)" \
	 $(MAKE) slides-all

slides-creative:
	@echo "→ Generating CREATIVE theme slides for ALL decks..."
	@REVEAL_THEME=sky \
	 REVEAL_TRANSITION=zoom \
	 HIGHLIGHT_STYLE=tango \
	 ENABLE_MATH="$(ENABLE_MATH)" \
	 $(MAKE) slides-all

# =============== PDF Export ===============
# pdf = "export all decks" (pdf-all)
pdf: pdf-all

# Single-deck export (internal helper)
pdf-one:
	@echo "================================================================"
	@echo "Exporting to PDF with fixed timing"
	@echo "================================================================"
	@echo "Configuration:"
	@echo "  Slides range:  $(PDF_SLIDES)"
	@echo "  Size:          $(SLIDE_SIZE)"
	@echo "  Load pause:    $(LOAD_PAUSE)ms"
	@echo "  Slide pause:   $(PAUSE)ms"
	@echo "  HTML_REL:      $${HTML_REL:-docs/slides/watsonx-agentic-ai.html}"
	@echo "  PDF_REL:       $${PDF_REL:-docs/slides/watsonx-agentic-ai.pdf}"
	@echo "================================================================"
	@if [ -f scripts/export_pdf.sh ]; then \
		DECKTAPE_IMAGE="$(DECKTAPE_IMAGE)" \
		SLIDE_SIZE="$(SLIDE_SIZE)" \
		SLIDES_RANGE="$(PDF_SLIDES)" \
		LOAD_PAUSE="$(LOAD_PAUSE)" \
		PAUSE="$(PAUSE)" \
		HTML_REL="$${HTML_REL:-docs/slides/watsonx-agentic-ai.html}" \
		PDF_REL="$${PDF_REL:-docs/slides/watsonx-agentic-ai.pdf}" \
		bash scripts/export_pdf.sh; \
	else \
		echo "❌ scripts/export_pdf.sh not found"; \
		exit 1; \
	fi

# Export ALL generated HTML slide decks to PDFs
pdf-all:
	@echo "→ Exporting ALL HTML slides to PDF using DeckTape ($(DECKTAPE_IMAGE))..."
	@set -e; \
	find docs -name "*.html" -path "*/slides/*" | while read html; do \
		pdf="$${html%.html}.pdf"; \
		echo "→ Exporting: $$html → $$pdf"; \
		HTML_REL="$$html" PDF_REL="$$pdf" $(MAKE) pdf-one; \
	done
	@echo "✅ All slide decks exported to PDF"

# Merge per-deck PDFs into one PDF per "day" prefix (day0, day1, day2, day3, capstone)
pdf-days: pdf
	@echo "→ Building day-level merged PDFs in docs/slides/..."
	@set -e; \
	cd docs/slides; \
	all_pdfs=$$(ls *.pdf 2>/dev/null | grep -E '^(day[0-9]+|capstone)-' || true); \
	if [ -z "$$all_pdfs" ]; then \
		echo "⚠️  No per-deck PDFs found. Run 'make pdf' first."; \
		exit 0; \
	fi; \
	days=$$(printf '%s\n' $$all_pdfs | sed 's/-.*//' | sort -u); \
	for d in $$days; do \
		files=$$(ls "$${d}-"*.pdf | sort); \
		out="$${d}.pdf"; \
		echo "→ Merging $$files -> $$out"; \
		$(PDF_MERGE) $$files "$$out"; \
	done; \
	echo "✅ All day-level PDFs generated in docs/slides/"

pdf-debug:
	@echo "→ Generating PDF with debug screenshots..."
	@mkdir -p debug-slides
	@docker run --rm -t \
	  --shm-size=2g \
	  -e HOME=/tmp \
	  -v "$$PWD":/work \
	  $(DECKTAPE_IMAGE) \
	  reveal \
	  --screenshots \
	  --screenshots-directory /work/debug-slides \
	  --size $(SLIDE_SIZE) \
	  --slides $(PDF_SLIDES) \
	  --load-pause $(LOAD_PAUSE) \
	  --pause $(PAUSE) \
	  "file:///work/docs/slides/watsonx-agentic-ai.html" \
	  "/work/docs/slides/watsonx-agentic-ai-debug.pdf"
	@echo "✅ Debug PDF + screenshots in debug-slides/"

# =============== Development Server ===============
serve:
	@echo "→ Starting dev server (Ctrl+C to stop) ..."
	@$(MKDOCS) serve --strict

serve-with-slides: slides-all
	@echo "→ Rebuilt slides, starting dev server..."
	@$(MKDOCS) serve --strict

serve-noslides:
	@echo "→ Starting dev server (without rebuilding slides)..."
	@$(MKDOCS) serve --strict

# =============== Build ===============
build:
	@echo "→ Building static site to $(SITE_DIR)..."
	@$(MKDOCS) build --strict --verbose

build-complete: slides-all pdf
	@echo "================================================================"
	@echo "Building complete site (docs + slides + PDF)..."
	@echo "================================================================"
	@$(MKDOCS) build --strict --verbose
	@echo "✅ Complete build finished!"

build-quick: slides-all
	@echo "→ Quick build (docs + slides, skip PDF)..."
	@$(MKDOCS) build --strict --verbose
	@echo "✅ Quick build finished!"

# =============== Cleanup ===============
clean:
	@echo "→ Cleaning build artifacts..."
	@rm -rf $(SITE_DIR) 2>/dev/null || rmdir /s /q $(SITE_DIR) 2>nul || true
	@echo "✅ Cleaned $(SITE_DIR)"

clean-slides:
	@echo "→ Cleaning generated slides..."
	@find docs -type f \( -name "*.html" -o -name "*.pdf" \) -path "*/slides/*" -delete 2>/dev/null || true
	@rm -rf debug-slides 2>/dev/null || true
	@echo "✅ Cleaned slides"

clean-venv:
	@echo "→ Removing virtualenv $(VENV) ..."
	@rm -rf $(VENV) 2>/dev/null || rmdir /s /q $(VENV) 2>nul || true
	@echo "✅ Removed virtualenv"

clean-all: clean clean-slides clean-venv
	@echo "→ Deep clean (site + slides + venv)..."
	@rm -rf .cache 2>/dev/null || true
	@echo "✅ Deep clean complete"

# =============== Deployment ===============
gh-deploy:
	@echo "→ Deploying to GitHub Pages..."
	@$(MKDOCS) gh-deploy --clean --force

# =============== Diagnostics ===============
info:
	@echo "================================================================"
	@echo "Current Configuration"
	@echo "================================================================"
	@echo ""
	@echo "Python Environment:"
	@echo "  Target:        $(PY311)"
	@if [ -d $(VENV) ]; then \
		echo "  Virtual Env:   ✅ Present ($(VENV))"; \
	else \
		echo "  Virtual Env:   ⚠️  Not created (run 'make install')"; \
	fi
	@echo ""
	@echo "Slide Generation:"
	@echo "  Theme:         $(REVEAL_THEME)"
	@echo "  Transition:    $(REVEAL_TRANSITION)"
	@echo "  Code Style:    $(HIGHLIGHT_STYLE)"
	@echo "  Math Support:  $(ENABLE_MATH)"
	@echo ""
	@echo "PDF Export:"
	@echo "  Size:          $(SLIDE_SIZE)"
	@echo "  Slide Range:   $(PDF_SLIDES)"
	@echo "  Load Pause:    $(LOAD_PAUSE)ms"
	@echo "  Slide Pause:   $(PAUSE)ms"
	@echo "  DeckTape Img:  $(DECKTAPE_IMAGE)"
	@echo "  PDF Merge:     $(PDF_MERGE)"
	@echo ""
	@echo "Paths:"
	@echo "  Site Dir:      $(SITE_DIR)"
	@echo "  Config:        $(CONFIG)"
	@echo ""
	@echo "Generated Files:"
	@if ls docs/slides/*.html >/dev/null 2>&1; then \
		echo "  HTML Slides:   ✅ Present in docs/slides/"; \
	else \
		echo "  HTML Slides:   ⚠️  Not generated (run 'make slides')"; \
	fi
	@if ls docs/slides/*.pdf >/dev/null 2>&1; then \
		echo "  PDF Slides:    ✅ Present in docs/slides/"; \
	else \
		echo "  PDF Slides:    ⚠️  Not generated (run 'make pdf')"; \
	fi
	@echo "================================================================"

.DEFAULT_GOAL := help
