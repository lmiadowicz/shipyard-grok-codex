# Sample routine: evening ready (markdown only — no secrets)

1. Run `bash .agents/delivery/scripts/status-dump.sh`.
2. List open draft PRs with green CI.
3. If Reviewer PASS label present → wake coordinator **only** with merge request + Preview URL.
4. Else write blockers into STATUS.md — **do not** FYI the coordinator.
