#!/usr/bin/env bash
# Writes a product-agnostic smoke checklist you can edit per product.
set -euo pipefail
ROOT="${PRODUCT_ROOT:-${AIFFER_ROOT:-$PWD}}"
cd "$ROOT"
mkdir -p .agents/delivery
OUT=".agents/delivery/SMOKE-$(TZ=Europe/Warsaw date +%Y-%m-%d).md"
cat >"$OUT" <<'SMOKEOF'
# Happy-path smoke (edit for your product)
1. [ ] Sign-in / auth
2. [ ] Empty state / onboarding visible
3. [ ] Core create flow → durable artifact
4. [ ] Edit / update artifact
5. [ ] Share / publish / export
6. [ ] Error path shows recoverable UI (no blank crash)
7. [ ] CI green on draft PR + Done-when evidence linked
SMOKEOF
echo "Wrote $OUT"
