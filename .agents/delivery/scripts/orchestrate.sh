#!/usr/bin/env bash
# Zero-chat orchestration tick — status dump, review queue, optional auto-merge on PASS label.
# Genericized delivery harness. Point PRODUCT_ROOT at your product repo.
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/bin:/bin:$PATH"
ROOT="${PRODUCT_ROOT:-${AIFFER_ROOT:-$PWD}}"
cd "$ROOT"
mkdir -p .agents/delivery .verification/evidence/reviews
STAMP="$(TZ=Europe/Warsaw date '+%Y-%m-%d %H:%M %Z')"
LOG=".agents/delivery/orchestrate.log"
LABEL="${REVIEWER_PASS_LABEL:-delivery:reviewer-pass}"
{
  echo "=== $STAMP ==="
  bash .agents/delivery/scripts/status-dump.sh || true
} >>"$LOG" 2>&1
TMP=$(mktemp)
gh pr list --state open --limit 40 --json number,title,isDraft,headRefName,url,labels,statusCheckRollup,mergeable >"$TMP"
python3 - "$TMP" "$STAMP" "$LABEL" <<'PY'
import json, subprocess, sys
from pathlib import Path
prs=json.loads(Path(sys.argv[1]).read_text())
stamp=sys.argv[2]
pass_label=sys.argv[3]
merged, needs_review, blocked = [], [], []

def authoritative_ok(checks):
    auth=None
    hard_fail=False
    for c in checks or []:
        name=c.get("name") or c.get("context") or ""
        conc=(c.get("conclusion") or c.get("state") or "").upper()
        url=(c.get("targetUrl") or c.get("detailsUrl") or "")
        if name=="Authoritative repository gate":
            auth=conc
        if name.startswith("Vercel") and ("upgradeToPro" in url or "rate-limit" in url.lower()):
            continue
        if name in ("Secret scan","Project SAST","Dependency audit") and conc in ("FAILURE","ERROR","CANCELLED"):
            hard_fail=True
        if name.startswith("Vercel") and conc in ("FAILURE","ERROR") and "upgradeToPro" not in url:
            hard_fail=True
    if auth is None:
        return not hard_fail
    return (auth == "SUCCESS") and not hard_fail

for pr in prs:
    n=pr["number"]
    labels={x.get("name") for x in (pr.get("labels") or [])}
    ok=authoritative_ok(pr.get("statusCheckRollup"))
    title=pr.get("title") or ""
    branch=pr.get("headRefName") or ""
    if ok and pass_label in labels:
        if pr.get("isDraft"):
            subprocess.run(["gh","pr","ready",str(n)], check=False)
        r=subprocess.run(["gh","pr","merge",str(n),"--merge","--delete-branch=false"], capture_output=True, text=True)
        if r.returncode==0:
            merged.append({"number":n,"title":title,"branch":branch})
        else:
            blocked.append({"number":n,"reason":"merge-failed","detail":(r.stderr or r.stdout)[:200]})
    elif ok:
        needs_review.append({"number":n,"title":title,"branch":branch,"url":pr.get("url"),"draft":bool(pr.get("isDraft"))})
    else:
        blocked.append({"number":n,"reason":"ci-not-green","title":title})

out={"generated":stamp,"merged":merged,"needs_review":needs_review,"blocked":blocked,
     "policy":f"Auto-merge iff label {pass_label} + authoritative CI green (optional; customize)"}
Path(".agents/delivery/ACTIONS.json").write_text(json.dumps(out, indent=2)+"\n")
print(json.dumps(out, indent=2))
PY
rm -f "$TMP"
echo "$STAMP orchestrate OK" >>"$LOG"
