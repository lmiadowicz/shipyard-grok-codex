# Install into a project

Works on **MacBook (Darwin)** and **VPS / Linux**. Primary installer is `setup.sh` (detects OS). Shell-first — no Python venv required for day-to-day harness use.

## Steps (both platforms)

```bash
git clone https://github.com/lmiadowicz/startup-harness-codex.git
# or: startup-harness-grok-codex
cd startup-harness-codex

bash setup.sh                         # tool checks + Limen URL (prints Mac or VPS hints)
bash setup.sh /path/to/your-product   # copy harness into the product repo

export PRODUCT_ROOT=/path/to/your-product
bash "$PRODUCT_ROOT/.agents/delivery/scripts/status-dump.sh"
```

## macOS (optional) — launchd

```bash
bash "$PRODUCT_ROOT/.agents/delivery/scripts/install-launchd.sh"
```

launchd is **Mac-only** and optional. Core delivery works without it.

## Linux / VPS — cron or systemd

Do **not** use launchd on a VPS. Schedule the same scripts with cron or systemd.

**cron example** (every 15 minutes):

```cron
*/15 * * * * PRODUCT_ROOT=/path/to/product bash /path/to/product/.agents/delivery/scripts/status-dump.sh >>/var/log/harness-status.log 2>&1
```

**systemd timer sketch:**

```ini
# /etc/systemd/system/harness-status.service
[Unit]
Description=Startup harness status-dump

[Service]
Type=oneshot
Environment=PRODUCT_ROOT=/path/to/product
ExecStart=/bin/bash /path/to/product/.agents/delivery/scripts/status-dump.sh
```

```ini
# /etc/systemd/system/harness-status.timer
[Unit]
Description=Run harness status-dump every 15m

[Timer]
OnBootSec=2m
OnUnitActiveSec=15m
Unit=harness-status.service

[Install]
WantedBy=timers.target
```

```bash
sudo systemctl enable --now harness-status.timer
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

Optional (charts rebuild only): Google Chrome / Chromium + `python3` to run vendored `vendor/mega-card/render.py` via `bash scripts/render-charts.sh`.
