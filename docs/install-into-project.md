# Install into a project

Works on Mac and VPS (shell-first).

## Steps

```bash
git clone https://github.com/lmiadowicz/startup-harness-grok-codex.git
# sibling Codex-only harness also available
cd startup-harness-grok-codex

bash setup.sh                         # tool checks + Limen URL
bash setup.sh /path/to/your-product   # copy harness into the product repo

export PRODUCT_ROOT=/path/to/your-product
bash "$PRODUCT_ROOT/.agents/delivery/scripts/status-dump.sh"
# macOS optional loop:
bash "$PRODUCT_ROOT/.agents/delivery/scripts/install-launchd.sh"
```

## What lands in the product repo

| Path | Purpose |
| --- | --- |
| `.agents/delivery/scripts/` | `orchestrate.sh`, `review-and-label.sh`, `status-dump.sh`, `happy-path-smoke.sh`, `install-launchd.sh` |
| `.agents/delivery/PLAYBOOK.md` | Quality bar, max 1–2 jobs, evidence |
| `.agents/delivery/TICKET-TEMPLATE.md` | In/Out/Forbidden + Done-when |
| `.agents/delivery/STATUS.md` | Written by status-dump / orchestrate |
| `.agents/delivery/ACTIONS.json` | Written by orchestrate |
| `.verification/evidence/reviews/` | Review notes directory |

Also copy (manually or from this harness) as needed:

- `board/` samples → adapt as your human-readable board
- `spec/vision.md` + `spec/styleguide.md` → product north star + craft rules
- `docs/limen.md` — Herdr `--tab` spawn examples

## Prerequisites

- `gh` (GitHub CLI)
- **Limen** from https://mega.dev/autonomous-product-development
- Herdr (usually near limen)
- Codex desktop / CLI for coding agents
