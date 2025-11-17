#!/usr/bin/env bash
# scripts/generate_all_slides.sh
# Batch-generate Reveal.js decks for key workshop modules
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd -P)"
OUT_BASE="${OUT_BASE:-${ROOT}/docs/slides}"

mkdir -p "${OUT_BASE}"

# Each entry is "relative_md_path|deck_name"
DECKS=(
  # Day 0 – Environment setup
  "docs/tracks/day0-env/prereqs-and-accounts.md|day0-prereqs-and-accounts"
  "docs/tracks/day0-env/setup-simple-ollama-environment.md|day0-setup-simple-ollama-environment"
  "docs/tracks/day0-env/setup-simple-watsonx-enviroment.md|day0-setup-simple-watsonx-environment"
  "docs/tracks/day0-env/verify-environments.md|day0-verify-environments"

  # Day 1 – LLMs & prompting (theory)
  "docs/tracks/day1-llm/llm-concepts.md|day1-llm-concepts"
  "docs/tracks/day1-llm/prompt-patterns-theory.md|day1-prompt-patterns-theory"
  "docs/tracks/day1-llm/eval-safety-theory.md|day1-eval-safety-theory"
  "docs/tracks/day1-llm/day1-summary-and-schedule.md|day1-summary-and-schedule"

  # Day 1 – Labs (new)
  "docs/tracks/day1-llm/lab-1-quickstart-two-envs.md|day1-lab-1-quickstart-two-envs"
  "docs/tracks/day1-llm/lab-2-prompt-templates.md|day1-lab-2-prompt-templates"
  "docs/tracks/day1-llm/lab-3-micro-eval.md|day1-lab-3-micro-eval"

  # Day 2 – RAG theory
  "docs/tracks/day2-rag/Theory_01_RAG_Architecture_Overview.md|day2-rag-architecture-overview"

  # Day 3 – Orchestration & recap
  "docs/tracks/day3-orchestrate/agentic-ai-overview.md|day3-agentic-ai-overview"
  "docs/tracks/day3-orchestrate/bridge-orchestrate-governance.md|day3-bridge-orchestrate-governance"
  "docs/tracks/day3-orchestrate/recap-and-next-steps.md|day3-recap-and-next-steps"

  # Capstone overview
  "docs/tracks/capstone/capstone-overview.md|capstone-overview"
  "docs/tracks/capstone/capstone-project-ideas.md|capstone-project-ideas"
)

for entry in "${DECKS[@]}"; do
  IFS="|" read -r rel_src deck_name <<<"${entry}"

  SRC_PATH="${ROOT}/${rel_src}"

  if [ ! -f "${SRC_PATH}" ]; then
    echo "⚠️  Skipping missing source: ${rel_src}"
    continue
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "→ Building deck: ${deck_name}"
  echo "  Source: ${rel_src}"
  echo "  Output: docs/slides/${deck_name}.html"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  SOURCE_MD="${SRC_PATH}" \
  OUT_DIR="${OUT_BASE}" \
  DECK_NAME="${deck_name}" \
  REVEAL_THEME="${REVEAL_THEME}" \
  REVEAL_TRANSITION="${REVEAL_TRANSITION}" \
  HIGHLIGHT_STYLE="${HIGHLIGHT_STYLE}" \
  ENABLE_MATH="${ENABLE_MATH}" \
  CUSTOM_CSS="${CUSTOM_CSS:-}" \
    bash "${ROOT}/scripts/generate_slides.sh"
done

echo "✅ All decks built into docs/slides/"
