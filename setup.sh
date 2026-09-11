#!/usr/bin/env bash
# Shipyard harness — install delivery loop into ANY product repo.
# Companion tools: limen (mega.dev), herdr, Pi, Codex, gh.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-}"
INSTALL_HERDR="${INSTALL_HERDR:-0}"

echo "== shipyard harness setup =="
echo

check() {
  local name="$1" hint="$2"
  if command -v "$name" >/dev/null 2>&1; then
    echo "OK  $name → $(command -v "$name")"
  else
    echo "MISS $name — $hint"
  fi
}

check node "Node.js 20+ for TS chart renderer: https://nodejs.org/"
check gh "GitHub CLI: https://cli.github.com/"
check limen "Download: https://mega.dev/autonomous-product-development"
check herdr "curl -fsSL https://herdr.dev/install.sh | bash  · https://github.com/herdrdev/herdr"
check pi "Pi coding agent: https://pi.dev"

if command -v codex >/dev/null 2>&1; then
  echo "OK  codex → $(command -v codex)"
elif [[ -d "$HOME/.codex" ]]; then
  echo "HINT Codex config at ~/.codex (CLI may still need PATH)"
else
  echo "MISS codex — OpenAI Codex CLI / ChatGPT Codex desktop"
fi

echo
echo "Companion links"
echo "  limen : https://mega.dev/autonomous-product-development"
echo "  herdr : https://herdr.dev/install.sh"
echo "  Pi    : https://pi.dev"
echo "  charts: npm run charts  (TypeScript mega-card · Piotr Random-Skills)"
echo "  flow  : open docs/orchestration-animation.html"
echo

if [[ "$INSTALL_HERDR" == "1" ]] && ! command -v herdr >/dev/null 2>&1; then
  echo "INSTALL_HERDR=1 → installing herdr…"
  curl -fsSL https://herdr.dev/install.sh | bash
fi

if [[ -z "$TARGET" ]]; then
  echo "Install into any product repo:"
  echo "  bash setup.sh /path/to/your-product"
  echo "  INSTALL_HERDR=1 bash setup.sh /path/to/your-product"
  echo "Then:"
  echo "  export PRODUCT_ROOT=/path/to/your-product"
  echo "  bash .agents/delivery/scripts/status-dump.sh"
  exit 0
fi

TARGET="$(cd "$TARGET" && pwd)"
DEST="$TARGET/.agents/delivery/scripts"
mkdir -p "$DEST" "$TARGET/.agents/delivery" "$TARGET/.verification/evidence/reviews"
if [[ -d "$HERE/.agents/delivery/scripts" ]]; then
  cp -f "$HERE/.agents/delivery/scripts/"*.sh "$DEST/" 2>/dev/null || true
  chmod +x "$DEST/"*.sh 2>/dev/null || true
fi
cp -f "$HERE/.agents/delivery/TICKET-TEMPLATE.md" "$TARGET/.agents/delivery/" 2>/dev/null || true
cp -f "$HERE/.agents/delivery/PLAYBOOK.md" "$TARGET/.agents/delivery/" 2>/dev/null || true
# seed board/spec if missing
if [[ ! -d "$TARGET/board" ]] && [[ -d "$HERE/board" ]]; then
  cp -R "$HERE/board" "$TARGET/board"
  echo "Seeded board/ → $TARGET/board"
fi
if [[ ! -d "$TARGET/spec" ]] && [[ -d "$HERE/spec" ]]; then
  cp -R "$HERE/spec" "$TARGET/spec"
  echo "Seeded spec/ → $TARGET/spec"
fi
echo "Installed delivery scripts → $DEST"
echo "PRODUCT_ROOT tip: export PRODUCT_ROOT=\"$TARGET\""
echo "Animation: open $HERE/docs/orchestration-animation.html"
