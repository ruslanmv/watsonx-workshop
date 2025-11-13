#!/usr/bin/env bash
# scripts/export_pdf.sh
# Robust DeckTape export for Reveal.js slides — production-ready
set -euo pipefail

# ---- Config (env-overridable) -----------------------------------------------
# Use GHCR multi-arch image by default so Apple Silicon (arm64) works
DECKTAPE_IMAGE="${DECKTAPE_IMAGE:-ghcr.io/astefanutti/decktape:3.15.0}"
SLIDE_SIZE="${SLIDE_SIZE:-1920x1080}"
SLIDES_RANGE="${SLIDES_RANGE:-1-100}"   # Explicit range for better compatibility

# CRITICAL: Timing parameters - INCREASED for full HD slides
LOAD_PAUSE="${LOAD_PAUSE:-8000}"     # Initial load: 8 seconds
PAUSE="${PAUSE:-2000}"               # Between slides: 2 seconds

# Default Docker flags (no user override, keep container defaults for Chrome)
if [ -z "${DOCKER_RUN_EXTRA:-}" ]; then
  DOCKER_RUN_EXTRA="--shm-size=2g -e HOME=/tmp"
fi

# Extra Chrome args to make file:// rendering reliable inside DeckTape/Chromium
CHROME_ARGS=(
  --chrome-arg=--allow-file-access-from-files
  --chrome-arg=--disable-web-security
  --chrome-arg=--autoplay-policy=no-user-gesture-required
  --chrome-arg=--no-sandbox
  --chrome-arg=--disable-setuid-sandbox
  --chrome-arg=--disable-dev-shm-usage
  --chrome-arg=--disable-gpu
  --chrome-arg=--hide-scrollbars
  --chrome-arg=--mute-audio
  --chrome-arg=--disable-background-timer-throttling
  --chrome-arg=--disable-renderer-backgrounding
  --chrome-arg=--disable-backgrounding-occluded-windows
  --chrome-arg=--user-data-dir=/tmp/chrome-user
  --chrome-arg=--crash-dumps-dir=/tmp
)

# ---- Paths -------------------------------------------------------------------
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd -P)"
HTML_REL="${HTML_REL:-docs/slides/watsonx-agentic-ai.html}"
PDF_REL="${PDF_REL:-docs/slides/watsonx-agentic-ai.pdf}"

HTML_HOST="${ROOT}/${HTML_REL}"
PDF_HOST="${ROOT}/${PDF_REL}"

# ---- Pre-checks --------------------------------------------------------------
command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }
[ -f "${HTML_HOST}" ] || { echo "Missing HTML: ${HTML_HOST}. Run scripts/generate_slides.sh first."; exit 1; }

# Ensure the DeckTape image is present
docker image inspect "${DECKTAPE_IMAGE}" >/dev/null 2>&1 || {
  echo "Pulling DeckTape image (${DECKTAPE_IMAGE})..."
  docker pull "${DECKTAPE_IMAGE}"
}

# Ensure output directory exists
mkdir -p "$(dirname "${PDF_HOST}")"

# ---- Container mount & in-container paths ------------------------------------
MOUNT_POINT="/work"
HTML_URL="file://${MOUNT_POINT}/${HTML_REL}"
PDF_PATH="${MOUNT_POINT}/${PDF_REL}"

# ---- Run DeckTape ------------------------------------------------------------
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Exporting Reveal.js slides to PDF"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Image:         ${DECKTAPE_IMAGE}"
echo "  Source:        ${HTML_HOST}"
echo "  Destination:   ${PDF_HOST}"
echo "  Slides range:  ${SLIDES_RANGE}"
echo "  Size:          ${SLIDE_SIZE}"
echo "  Load pause:    ${LOAD_PAUSE}ms"
echo "  Slide pause:   ${PAUSE}ms"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# CRITICAL FIX: 'reveal' must come BEFORE other options
docker run --rm -t \
  ${DOCKER_RUN_EXTRA} \
  -v "${ROOT}:${MOUNT_POINT}" \
  "${DECKTAPE_IMAGE}" \
  reveal \
  --size "${SLIDE_SIZE}" \
  --slides "${SLIDES_RANGE}" \
  --load-pause "${LOAD_PAUSE}" \
  --pause "${PAUSE}" \
  "${CHROME_ARGS[@]}" \
  "${HTML_URL}" \
  "${PDF_PATH}"

# ---- Verification ------------------------------------------------------------
if [ -f "${PDF_HOST}" ]; then
  PDF_SIZE=$(du -h "${PDF_HOST}" | cut -f1)
  
  # Try to count pages (requires pdfinfo/qpdf, optional)
  if command -v pdfinfo >/dev/null 2>&1; then
    PAGE_COUNT=$(pdfinfo "${PDF_HOST}" 2>/dev/null | grep -i "^Pages:" | awk '{print $2}' || echo "unknown")
  else
    PAGE_COUNT="unknown (install poppler-utils for page count)"
  fi
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ PDF generated successfully!"
  echo "   File:  ${PDF_HOST}"
  echo "   Size:  ${PDF_SIZE}"
  echo "   Pages: ${PAGE_COUNT}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Warn if file is suspiciously small
  PDF_BYTES=$(stat -f%z "${PDF_HOST}" 2>/dev/null || stat -c%s "${PDF_HOST}" 2>/dev/null || echo 0)
  if [ "${PDF_BYTES}" -lt 100000 ]; then
    echo "⚠️  WARNING: PDF is small (${PDF_BYTES} bytes) - may only contain 1 page"
    echo "   Try increasing LOAD_PAUSE and PAUSE values"
  fi
else
  echo "❌ ERROR: PDF was not generated at ${PDF_HOST}"
  exit 1
fi
