#!/usr/bin/env bash
# scripts/bootstrap.sh
# Minimal cross-platform bootstrap:
# - Pandoc
# - Docker (or guidance)
# - Pull DeckTape image
# - Optional: Node.js + npm (for local reveal dev servers)

set -euo pipefail

has_cmd() { command -v "$1" >/dev/null 2>&1; }
log() { printf "\033[1;34m[bootstrap]\033[0m %s\n" "$*"; }
ok()  { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[err]\033[0m %s\n" "$*" >&2; }

OS="$(uname -s)"
IS_WSL=false; grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=true

install_pandoc_linux(){ if has_cmd apt-get; then sudo apt-get update && sudo apt-get install -y pandoc; elif has_cmd dnf; then sudo dnf install -y pandoc; elif has_cmd pacman; then sudo pacman -S --noconfirm pandoc; else err "Install pandoc manually: https://pandoc.org/installing.html"; fi; }
install_pandoc_macos(){ has_cmd brew || err "Install Homebrew first: https://brew.sh"; brew install pandoc; }
install_pandoc_windows(){ if has_cmd winget; then winget install -e --id JohnMacFarlane.Pandoc; elif has_cmd choco; then choco install -y pandoc; else err "Install pandoc manually: https://pandoc.org/installing.html"; fi; }

install_docker_linux(){ has_cmd docker && return; if has_cmd apt-get; then sudo apt-get update && sudo apt-get install -y docker.io && sudo usermod -aG docker "$USER" || true; elif has_cmd dnf; then sudo dnf install -y docker && sudo systemctl enable --now docker || true && sudo usermod -aG docker "$USER" || true; elif has_cmd pacman; then sudo pacman -S --noconfirm docker && sudo systemctl enable --now docker || true && sudo usermod -aG docker "$USER" || true; else err "Install Docker: https://docs.docker.com/engine/install/"; fi; }
install_docker_macos(){ has_cmd docker && return; has_cmd brew || err "Install Homebrew first: https://brew.sh"; brew install --cask docker; warn "Open Docker.app once to finish setup."; }
install_docker_windows(){ has_cmd docker && return; if has_cmd winget; then winget install -e --id Docker.DockerDesktop; elif has_cmd choco; then choco install -y docker-desktop; else err "Install Docker Desktop: https://docs.docker.com/desktop/"; fi; }

# Optional Node (for reveal.js dev server use-cases)
install_node_linux(){ has_cmd node && has_cmd npm && return; if has_cmd apt-get; then curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs; elif has_cmd dnf; then sudo dnf install -y nodejs npm; elif has_cmd pacman; then sudo pacman -S --noconfirm nodejs npm; else warn "Node install skipped; see https://nodejs.org"; fi; }
install_node_macos(){ has_cmd node && has_cmd npm && return; has_cmd brew || { warn "No Homebrew; skipping Node."; return; }; brew install node; }
install_node_windows(){ has_cmd node && has_cmd npm && return; if has_cmd winget; then winget install -e --id OpenJS.NodeJS.LTS; elif has_cmd choco; then choco install -y nodejs-lts; else warn "Install Node manually: https://nodejs.org/"; fi; }

case "$OS" in
  Linux)
    has_cmd pandoc || install_pandoc_linux
    $IS_WSL || has_cmd docker || install_docker_linux
    install_node_linux || true
    ;;
  Darwin)
    has_cmd pandoc || install_pandoc_macos
    has_cmd docker  || install_docker_macos
    install_node_macos || true
    ;;
  MINGW*|MSYS*|CYGWIN*)
    has_cmd pandoc || install_pandoc_windows
    has_cmd docker || install_docker_windows
    install_node_windows || true
    ;;
  *) err "Unsupported OS: $OS";;
esac

ok "Pandoc: $(pandoc -v | head -n1 || echo 'installed')"
if has_cmd docker; then ok "Docker: $(docker --version || echo 'installed')"; log "Pulling DeckTape…"; docker pull astefanutti/decktape:latest; ok "DeckTape image ready."; else warn "Docker missing → PDF export will be unavailable."; fi
if has_cmd node; then ok "Node: $(node -v)"; fi
if has_cmd npm;  then ok "npm:  $(npm -v)";  fi

ok "Bootstrap complete. Next:"
echo "  1) make install        # uv env + deps"
echo "  2) make slides         # vendors Reveal v4 locally and builds HTML"
echo "  3) make pdf            # DeckTape export (needs Docker running)"
echo "  4) make serve          # local preview"
