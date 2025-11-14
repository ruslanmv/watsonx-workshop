#!/usr/bin/env bash
# scripts/generate_slides.sh
# Enhanced version with better visual appearance and features
# - Auto-detects Pandoc version and uses compatible Reveal.js CDN
# - Full HD layout (1920×1080) for crisp PDF exports
# - Enhanced styling with better code highlighting and typography
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd -P)"

# Require SOURCE_MD to be set by caller (no hard-coded default)
SOURCE_MD="${SOURCE_MD:-}"

if [ -z "${SOURCE_MD}" ]; then
  echo "ERROR: SOURCE_MD is not set."
  echo "       This script is generic and needs an explicit source file."
  echo "       Examples:"
  echo "         SOURCE_MD=\"${ROOT}/docs/tracks/day1-llm/llm-concepts.md\" \\"
  echo "           bash scripts/generate_slides.sh"
  exit 1
fi

OUT_DIR="${OUT_DIR:-${ROOT}/docs/slides}"
DECK_NAME="${DECK_NAME:-$(basename "${SOURCE_MD%.*}")}"
HTML_OUT="${OUT_DIR}/${DECK_NAME}.html"

# Optional custom CSS (passed from Makefile / caller)
# Example: CUSTOM_CSS="themes/watsonx.css"
CUSTOM_CSS="${CUSTOM_CSS:-}"

# Check Pandoc installation
command -v pandoc >/dev/null 2>&1 || {
  echo "ERROR: Pandoc not found. Install from: https://pandoc.org/installing.html"
  exit 1
}

PANDOC_VER="$(pandoc -v | head -n1 | awk '{print $2}')"
ver_ge() {
  [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

mkdir -p "${OUT_DIR}"

# Determine embed flag based on Pandoc version
if pandoc --help | grep -q -- "--embed-resources"; then
  EMBED_FLAG="--embed-resources"
else
  EMBED_FLAG="--self-contained"
fi

# ========== CONFIGURATION ==========
# Reveal.js themes: beige, black, blood, league, moon, night, serif, simple, sky, solarized, white
REVEAL_THEME="${REVEAL_THEME:-black}"

# Transitions: none, fade, slide, convex, concave, zoom
REVEAL_TRANSITION="${REVEAL_TRANSITION:-convex}"

# Code highlighting style
# Valid styles: pygments, tango, espresso, zenburn, kate, monochrome, breezedark, haddock
HIGHLIGHT_STYLE="${HIGHLIGHT_STYLE:-zenburn}"

# Math support (uses CDN to avoid local file errors)
ENABLE_MATH="${ENABLE_MATH:-yes}"

# Pick CDN based on Pandoc's template expectations
if ver_ge "${PANDOC_VER}" "2.12"; then
  # Reveal v4 (modern)
  REVEAL_VERSION="${REVEAL_VERSION:-4.6.0}"
  REVEAL_URL="https://cdn.jsdelivr.net/npm/reveal.js@${REVEAL_VERSION}"
  echo "[OK] Using Reveal v4 CDN (${REVEAL_URL}) with Pandoc ${PANDOC_VER}"
else
  # Reveal v3 (legacy)
  REVEAL_URL="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.9.2"
  echo "[OK] Using Reveal v3 CDN (${REVEAL_URL}) with Pandoc ${PANDOC_VER}"
fi

if [ -n "${CUSTOM_CSS}" ]; then
  echo "Theme: ${REVEAL_THEME} | Transition: ${REVEAL_TRANSITION} | Highlight: ${HIGHLIGHT_STYLE}"
  echo "Custom CSS: ${CUSTOM_CSS}"
else
  echo "Theme: ${REVEAL_THEME} | Transition: ${REVEAL_TRANSITION} | Highlight: ${HIGHLIGHT_STYLE}"
  echo "Custom CSS: (none)"
fi

# Show math status
if [ "${ENABLE_MATH}" = "yes" ]; then
  echo "Math: enabled (MathJax CDN)"
else
  echo "Math: disabled"
fi

echo "Generating slides -> ${HTML_OUT}"
echo "  Source: ${SOURCE_MD}"

# Choose the right highlighting option depending on Pandoc version
if ver_ge "${PANDOC_VER}" "3.8"; then
  # New option (no deprecation warning)
  SYNTAX_HIGHLIGHT_OPT=(--syntax-highlighting="${HIGHLIGHT_STYLE}")
else
  # Old option for older pandoc versions
  SYNTAX_HIGHLIGHT_OPT=(--highlight-style="${HIGHLIGHT_STYLE}")
fi

# Build CSS options for Pandoc (-c file.css)
CSS_ARGS=()
if [ -n "${CUSTOM_CSS}" ]; then
  # Support one or more CSS files separated by spaces or commas
  # Example: "themes/watsonx.css themes/extra.css"
  IFS=', ' read -r -a _css_list <<< "${CUSTOM_CSS}"
  for css in "${_css_list[@]}"; do
    [ -z "${css}" ] && continue
    if [ -f "${css}" ]; then
      CSS_ARGS+=(-c "${css}")
    else
      echo "⚠️  CUSTOM_CSS file not found: ${css} (skipping)" >&2
    fi
  done
fi

# ========== BUILD PANDOC OPTIONS ==========
PANDOC_OPTS=(
  --standalone
  --to=revealjs
  --slide-level=2
  ${EMBED_FLAG}
  --variable "revealjs-url=${REVEAL_URL}"
  --variable "theme=${REVEAL_THEME}"
  --variable "transition=${REVEAL_TRANSITION}"
  --variable slideNumber=true
  --variable hash=true
  --variable controls=true
  --variable progress=true
  --variable history=true
  --variable center=true
  --variable mouseWheel=true
  --variable overview=true
  --variable width=1920
  --variable height=1080
  --variable margin=0.08
  --variable maxScale=2.0
  --variable minScale=0.2
  "${SYNTAX_HIGHLIGHT_OPT[@]}"
  "${CSS_ARGS[@]}"
  --metadata=pagetitle:"${DECK_NAME}"
)

# Add MathJax support if enabled (uses CDN to avoid local file errors)
if [ "${ENABLE_MATH}" = "yes" ]; then
  PANDOC_OPTS+=(--mathjax="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js")
fi

# ========== GENERATE SLIDES ==========
pandoc "${PANDOC_OPTS[@]}" -o "${HTML_OUT}" "${SOURCE_MD}"

echo "[OK] Slides generated at ${HTML_OUT}"