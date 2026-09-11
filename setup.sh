#!/usr/bin/env bash
# Startup harness setup — check tools, print limen URL, optionally install scripts into a product repo.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-}"

echo "== startup-harness setup =="
echo

check() {
  local name="$1" hint="$2"
  if command -v "$name" >/dev/null 2>&1; then
    echo "OK  $name → $(command -v "$name")"
  else
    echo "MISS $name — $hint"
  fi
}

check gh "Install GitHub CLI: https://cli.github.com/"
check limen "Download Limen from https://mega.dev/autonomous-product-development"
check herdr "Herdr often ships with / near limen — see mega.dev autonomous product development"
if command -v codex >/dev/null 2>&1; then
  echo "OK  codex → $(command -v codex)"
elif [[ -d "$HOME/.codex" ]]; then
  echo "HINT Codex config present at ~/.codex (CLI may still need PATH)"
else
  echo "MISS codex — install OpenAI Codex CLI / ChatGPT Codex desktop for coding agents"
fi

echo
echo "Limen download: https://mega.dev/autonomous-product-development"
echo "Charts skill (mega-card): https://github.com/piotrkrych2/Random-Skills"
echo "pstack quality bar: see docs/pstack.md"
echo

if [[ -z "$TARGET" ]]; then
  echo "Usage (optional install into a product repo):"
  echo "  bash setup.sh /path/to/your-product-repo"
  echo "Then from that repo:"
  echo "  export PRODUCT_ROOT=/path/to/your-product-repo"
  echo "  bash .agents/delivery/scripts/status-dump.sh"
  echo "  bash .agents/delivery/scripts/install-launchd.sh   # macOS launchd example"
  exit 0
fi

TARGET="$(cd "$TARGET" && pwd)"
DEST="$TARGET/.agents/delivery/scripts"
mkdir -p "$DEST" "$TARGET/.agents/delivery" "$TARGET/.verification/evidence/reviews"
cp -f "$HERE/.agents/delivery/scripts/"*.sh "$DEST/"
chmod +x "$DEST/"*.sh
cp -f "$HERE/.agents/delivery/TICKET-TEMPLATE.md" "$TARGET/.agents/delivery/" 2>/dev/null || true
cp -f "$HERE/.agents/delivery/PLAYBOOK.md" "$TARGET/.agents/delivery/" 2>/dev/null || true
echo "Installed scripts → $DEST"
echo "PRODUCT_ROOT tip: export PRODUCT_ROOT=\"$TARGET\""
