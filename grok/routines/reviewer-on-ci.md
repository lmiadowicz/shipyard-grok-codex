# Sample routine: reviewer on CI green (markdown only — no secrets)

Trigger preference: GitHub `check_suite` / PR event — not a dense cron.

1. Fetch PR diff + Done-when evidence under `.verification/evidence/`.
2. FAIL if no evidence / Done-when unmet / CI red.
3. On clean PASS: apply `delivery:reviewer-pass` (or run `review-and-label.sh`).
4. Wake coordinator **only** for merge — never “FYI: still looking”.
