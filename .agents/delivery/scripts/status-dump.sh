#!/usr/bin/env bash
# Cheap status dump for delivery — run from Mac/CI host, no chat-agent wake.
set -euo pipefail
ROOT="${PRODUCT_ROOT:-${AIFFER_ROOT:-$PWD}}"
OUT="$ROOT/.agents/delivery/STATUS.md"
cd "$ROOT"
{
  echo "# Delivery STATUS"
  echo
  echo "Generated: $(TZ=Europe/Warsaw date '+%Y-%m-%d %H:%M %Z')"
  echo
  echo "## git"
  echo '```'
  git fetch origin main -q 2>/dev/null || git fetch origin master -q 2>/dev/null || true
  echo "HEAD: $(git rev-parse --short HEAD 2>/dev/null || echo ?)"
  echo "main: $(git rev-parse --short origin/main 2>/dev/null || git rev-parse --short origin/master 2>/dev/null || echo ?)"
  echo '```'
  echo
  echo "## open PRs (draft+ready)"
  echo '```'
  gh pr list --state open --limit 20 --json number,title,isDraft,url,headRefName \
    --jq '.[] | "#\(.number) draft=\(.isDraft) \(.headRefName) — \(.title)\n  \(.url)"' 2>/dev/null || echo "(gh failed)"
  echo '```'
  echo
  echo "## limen (if available)"
  echo '```'
  if command -v limen >/dev/null 2>&1; then
    limen jobs --all 2>/dev/null | head -40 || true
  else
    echo "(limen not on PATH — get it from https://mega.dev/autonomous-product-development )"
  fi
  echo '```'
} > "$OUT"
echo "Wrote $OUT"
