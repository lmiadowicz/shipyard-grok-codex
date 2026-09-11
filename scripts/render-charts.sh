#!/usr/bin/env bash
# Rebuild TARGET 100% + ~90% coverage mega-card PNGs (FUT + 24-spoke).
# Implementation detail: calls Piotr’s vendored mega-card (Python + Chrome headless).
# Harness DX stays shell-first — do not advertise a Python venv for day-to-day use.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENDOR="$ROOT/vendor/mega-card/render.py"
CHARTS="$ROOT/charts"

if [[ ! -f "$VENDOR" ]]; then
  echo "Missing $VENDOR — vendor mega-card from https://github.com/piotrkrych2/Random-Skills" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 required only to run vendor/mega-card/render.py (Piotr’s tool)" >&2
  exit 1
fi

echo "Rendering TARGET 100% mega-card…"
python3 "$VENDOR" "$CHARTS/mega-assessment-TARGET-100.md" --name TARGET --out-dir "$CHARTS/tmp-target"
echo "Rendering ~90% coverage mega-card…"
python3 "$VENDOR" "$CHARTS/mega-assessment-COVERAGE-90.md" --name HARNESS --out-dir "$CHARTS/tmp-90"

# Prefer the PNG mega-card wrote (FUT + spider); copy to canonical README names
shopt -s nullglob
target_pngs=("$CHARTS"/tmp-target/*.png)
cov_pngs=("$CHARTS"/tmp-90/*.png)
if [[ ${#target_pngs[@]} -lt 1 || ${#cov_pngs[@]} -lt 1 ]]; then
  echo "mega-card did not produce PNGs (is Google Chrome / Chromium installed?)" >&2
  exit 1
fi

cp -f "${target_pngs[0]}" "$CHARTS/target-100.png"
cp -f "${target_pngs[0]}" "$CHARTS/target-100-megacard.png"
cp -f "${cov_pngs[0]}" "$CHARTS/coverage-90.png"
cp -f "${cov_pngs[0]}" "$CHARTS/coverage-90-megacard.png"

# Keep HTML next to assessments for local preview (gitignored via charts/*.html often)
cp -f "$CHARTS"/tmp-target/*.html "$CHARTS/target-100-megacard.html" 2>/dev/null || true
cp -f "$CHARTS"/tmp-90/*.html "$CHARTS/coverage-90-megacard.html" 2>/dev/null || true

rm -rf "$CHARTS/tmp-target" "$CHARTS/tmp-90"
echo "Wrote charts/target-100.png and charts/coverage-90.png (mega-card FUT + 24-spoke)."
echo "Remember: TARGET 100% and ~90% are design bars — not measured scores."
