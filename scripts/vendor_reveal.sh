#!/usr/bin/env bash
# scripts/vendor_reveal.sh
# Vendor Reveal.js locally under docs/vendor/reveal and create a v3-compat
# layout (css/, js/, lib/css/) that many older pandoc versions expect.
# Works on Linux/macOS/Windows (Git Bash). Uses unzip/bsdtar/7z/PowerShell if available.

set -euo pipefail

REVEAL_VERSION="${REVEAL_VERSION:-4.6.0}"  # 4.6.0 exists on npm & GitHub
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd -P)"
VENDOR_DIR="${ROOT}/docs/vendor"
TARGET_DIR="${VENDOR_DIR}/reveal"
CACHE_DIR="${ROOT}/.cache"

mkdir -p "${VENDOR_DIR}" "${CACHE_DIR}"

# If already vendored (and looks complete), bail early
if [ -f "${TARGET_DIR}/dist/reveal.js" ] && [ -d "${TARGET_DIR}/plugin" ]; then
  echo "Reveal.js already vendored at ${TARGET_DIR}"
else
  echo "Fetching reveal.js@${REVEAL_VERSION} via npm..."
  # Use npm to fetch the exact published package (portable and reliable)
  # This writes into node_modules; we then copy the package to our vendor dir.
  npm --loglevel=error view "reveal.js@${REVEAL_VERSION}" version >/dev/null 2>&1 || {
    echo "Error: No matching version found for reveal.js@${REVEAL_VERSION}. Try a published tag (e.g. 4.6.0, 4.5.0, 4.4.0)." >&2
    exit 1
  }
  TMP_NPM="${CACHE_DIR}/npm-reveal-${REVEAL_VERSION}"
  rm -rf "${TMP_NPM}"
  mkdir -p "${TMP_NPM}"
  pushd "${TMP_NPM}" >/dev/null
    npm init -y >/dev/null 2>&1
    npm install --silent "reveal.js@${REVEAL_VERSION}" >/dev/null
    PKG_DIR="node_modules/reveal.js"
    test -f "${PKG_DIR}/dist/reveal.js" || { echo "npm fetch failed." >&2; exit 1; }
    rm -rf "${TARGET_DIR}"
    mkdir -p "${TARGET_DIR}"
    cp -R "${PKG_DIR}/." "${TARGET_DIR}/"
  popd >/dev/null
  echo "✅ Vendored Reveal.js ${REVEAL_VERSION} from npm at ${TARGET_DIR}"
fi

# ---------- Build a v3-compat layout alongside v4 dist ----------
# Many older Pandoc templates reference:
#   css/reset.css, css/reveal.css, css/theme/*.css, css/print/*.css, js/reveal.js,
#   lib/css/monokai.css
# Reveal v4 moved these under dist/ and plugin/highlight; we mirror them.

DIST_DIR="${TARGET_DIR}/dist"
PLUG_DIR="${TARGET_DIR}/plugin"
[ -d "${DIST_DIR}" ] || { echo "dist/ not found in ${TARGET_DIR}" >&2; exit 1; }

# helper: copy if source exists
cp_if() {
  local src="$1" dst="$2"
  if [ -d "$src" ]; then
    mkdir -p "$dst"
    cp -R "$src/." "$dst/"
  elif [ -f "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  fi
}

# css/
cp_if "${DIST_DIR}/reset.css"          "${TARGET_DIR}/css/reset.css"
cp_if "${DIST_DIR}/reveal.css"         "${TARGET_DIR}/css/reveal.css"
cp_if "${DIST_DIR}/theme"              "${TARGET_DIR}/css/theme"
cp_if "${DIST_DIR}/print"              "${TARGET_DIR}/css/print"

# js/
cp_if "${DIST_DIR}/reveal.js"          "${TARGET_DIR}/js/reveal.js"

# lib/css/monokai.css (v3 path) -> plugin/highlight/monokai.css (v4 path)
cp_if "${PLUG_DIR}/highlight/monokai.css" "${TARGET_DIR}/lib/css/monokai.css"

echo "✅ Created v3-compatible layout under ${TARGET_DIR} (css/, js/, lib/css/)"

# Done
