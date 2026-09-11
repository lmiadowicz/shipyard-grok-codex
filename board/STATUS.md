# Delivery STATUS (sample shape)

Generated: 2026-09-11 23:40 CEST

> Sample only — `status-dump.sh` / `orchestrate.sh` overwrite `.agents/delivery/STATUS.md` in the **product** repo.

## Live (max 1–2 jobs)
- F012-slug — RUNNING — limen `--tab` · `gpt-6-astra` · thinking high
- F018-slug — RUNNING — non-overlapping files with F012

## Blocked / next
- F020-slug — HOLD: waiting on Reviewer PASS of F012
- After Live clear: F021 → F007

## Merged recently
- #42 F009-slug @ abc1234

## Notes
- Codex at **0%** usage → reset in Codex desktop (Settings → Usage), then resume. See `docs/codex-usage-reset.md`.
- Coordinator stays thin: wake only for merge after PASS or owner taste.
