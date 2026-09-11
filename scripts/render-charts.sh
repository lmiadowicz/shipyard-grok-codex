#!/usr/bin/env bash
# Render MEASURED MEGA assessments → charts/measured-*.png via TypeScript mega-card (English UI).
# Design bars (TARGET/90) only via --archive → charts/archive/
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
CHARTS="$ROOT/charts"
VENDOR_TS="$ROOT/vendor/mega-card/render.ts"
ARCHIVE="$CHARTS/archive"
OUT_TMP="$CHARTS/.render-tmp"
MODE="${1:-measured}"

die() { echo "$*" >&2; exit 1; }
[[ -f "$VENDOR_TS" ]] || die "Missing $VENDOR_TS"
command -v node >/dev/null 2>&1 || die "Node.js required (https://nodejs.org/)"

cd "$ROOT"
if [[ ! -d node_modules/tsx ]]; then
  echo "Installing chart deps (tsx)…"
  npm install --no-fund --no-audit
fi

chrome_shot() {
  local html="$1" png="$2"
  if ! command -v google-chrome >/dev/null 2>&1 && ! command -v chromium >/dev/null 2>&1 \
     && [[ ! -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]]; then
    echo "WARN: no Chrome/Chromium — keeping existing $png" >&2
    return 0
  fi
  local chrome
  if [[ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]]; then
    chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  else
    chrome="$(command -v google-chrome || command -v chromium)"
  fi
  "$chrome" --headless=new --no-sandbox --disable-dev-shm-usage --disable-gpu \
    --hide-scrollbars --force-device-scale-factor=2 --window-size=1600,1240 \
    --screenshot="$png" "file://$html" >/dev/null 2>&1 || {
      echo "WARN: Chrome screenshot failed for $png" >&2
      return 0
    }
  sleep 1
  [[ -s "$png" ]] && echo "Wrote $png"
}

render_one() {
  local report="$1" name="$2" dest_png="$3" dest_html="$4"
  [[ -f "$report" ]] || { echo "skip missing $report"; return 0; }
  rm -rf "$OUT_TMP"
  mkdir -p "$OUT_TMP"
  echo "mega-card (tsx): $report"
  npx --yes tsx "$VENDOR_TS" "$report" --name "$name" --out-dir "$OUT_TMP" --no-png
  local html
  html="$(ls -1 "$OUT_TMP"/*.html | head -1)"
  [[ -n "$html" ]] || die "no HTML from mega-card"
  cp -f "$html" "$dest_html"
  chrome_shot "$dest_html" "$dest_png"
}

mkdir -p "$CHARTS" "$ARCHIVE"

if [[ "$MODE" == "--archive" ]]; then
  echo "Archive mode: TARGET/design bars only (not primary README charts)"
  # leave archive as-is; do not promote to charts/
  exit 0
fi

# Detect which measured reports exist
if [[ -f "$CHARTS/mega-assessment-MEASURED-grok-codex.md" ]]; then
  render_one "$CHARTS/mega-assessment-MEASURED-grok-codex.md" "SHIPYARD GROK+CODEX" \
    "$CHARTS/measured-grok-codex.png" "$CHARTS/measured-grok-codex-megacard.html"
fi
if [[ -f "$CHARTS/mega-assessment-MEASURED-codex-only.md" ]]; then
  render_one "$CHARTS/mega-assessment-MEASURED-codex-only.md" "SHIPYARD CODEX" \
    "$CHARTS/measured-codex-only.png" "$CHARTS/measured-codex-only-megacard.html"
fi

echo "Done. Primary charts are MEASURED only (English mega-card)."
