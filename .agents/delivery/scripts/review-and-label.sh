#!/usr/bin/env bash
# Local review then label for auto-merge if clean PASS.
# Hook: set REVIEW_CMD to your review script, e.g. "bash scripts/product-review.sh"
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/bin:/bin:$PATH"
ROOT="${PRODUCT_ROOT:-${AIFFER_ROOT:-$PWD}}"
cd "$ROOT"
N="${1:?pr number}"
LABEL="${REVIEWER_PASS_LABEL:-delivery:reviewer-pass}"
gh label create "$LABEL" --force -c "0E8A16" -d "Review PASS — orchestrate may auto-merge" 2>/dev/null || true
BRANCH=$(gh pr view "$N" --json headRefName --jq .headRefName)
BASE=$(gh pr view "$N" --json baseRefName --jq .baseRefName)
echo "Reviewing PR #$N ($BRANCH <- $BASE)"
git fetch origin "$BRANCH" "$BASE" -q
REVIEW_CMD="${REVIEW_CMD:-}"
if [[ -n "$REVIEW_CMD" ]]; then
  # shellcheck disable=SC2086
  eval $REVIEW_CMD --base "origin/$BASE" --title "PR #$N $BRANCH"
else
  echo "No REVIEW_CMD set — write a review note under .verification/evidence/reviews/ then re-run,"
  echo "or export REVIEW_CMD='bash scripts/your-review.sh'"
  mkdir -p .verification/evidence/reviews
  NOTE=".verification/evidence/reviews/review-manual-$N.md"
  if [[ ! -f "$NOTE" ]]; then
    cat >"$NOTE" <<NOTEOF
# Manual review PR #$N
Status: PASS | HOLD | FAIL
Act-on: (none)
NOTEOF
    echo "Created stub $NOTE — edit then re-run."
    exit 0
  fi
fi
LATEST=$(ls -t .verification/evidence/reviews/review-*.md 2>/dev/null | head -1 || true)
if [[ -z "$LATEST" ]]; then echo "No review file"; exit 1; fi
if command -v rg >/dev/null 2>&1; then
  if rg -qi 'act-on' "$LATEST" && ! rg -qi 'no act-on|act-on:\s*$|act-on\s*\(none\)|PASS' "$LATEST"; then
    echo "Act-on findings — not labeling. $LATEST"
    exit 0
  fi
  if rg -qi 'PASS|no act-on|clean review|ready to merge' "$LATEST"; then
    gh pr edit "$N" --add-label "$LABEL"
    echo "Labeled #$N $LABEL"
  else
    echo "Review unclear — not labeling. $LATEST"
  fi
else
  echo "Install ripgrep (rg) for auto-label, or: gh pr edit $N --add-label \"$LABEL\""
fi
