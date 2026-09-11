# startup-harness-grok-codex

**For orchestrating my startup projects — I build microsaas, tools, mobile apps, etc. Optimized for highest quality, reliability, and token efficiency.**

Do orkiestracji projektów startupowych (mikrosaasy, narzędzia, apki mobilne itd.) — jakość, niezawodność i oszczędność tokenów.

**Grok Bot + Codex + Limen** delivery harness: same base as the Codex-only harness, **plus** Grok token-budget rules (thin coordinator, Delivery owns the loop, no FYI spam). Independent git history from [`startup-harness-codex`](https://github.com/lmiadowicz/startup-harness-codex).

## Get Limen

**Download Limen from:** https://mega.dev/autonomous-product-development  

You can download Limen there (and related Herdr tooling). Assumes `limen` / `herdr` / `gh` / Codex on PATH (**Mac or VPS**).

## How it works

```mermaid
flowchart LR
  Vision[Vision] --> Tickets[Tickets Done-when]
  Style[Styleguide] --> Tickets
  Board[Board NOW/NEXT/PARK] --> Tickets
  Tickets --> Limen[limen --tab + Codex]
  Limen --> Review[Reviewer / Taste]
  Review --> Merge[Thin coordinator merge]
  Merge --> Board
```

| Piece | Role |
| --- | --- |
| **Board** | STATUS / ACTIONS + NOW / NEXT / PARK |
| **Vision** | `spec/vision.md` — product north star |
| **Styleguides** | `spec/styleguide.md` — UI/craft rules |
| **Tickets** | Done-when → limen/Codex → review → merge |
| **Coordinator** | Stays **thin** — merge after PASS / owner taste only (see `grok/TOKEN-BUDGET.md`) |

Details: [`docs/how-it-works.md`](docs/how-it-works.md).

## Install into a project

Works on **MacBook** and **Linux VPS** (`setup.sh` detects Darwin vs Linux).

```bash
git clone https://github.com/lmiadowicz/startup-harness-grok-codex.git
cd startup-harness-grok-codex
bash setup.sh
bash setup.sh /path/to/your-product
export PRODUCT_ROOT=/path/to/your-product
bash "$PRODUCT_ROOT/.agents/delivery/scripts/status-dump.sh"
# macOS optional: install-launchd.sh
# Linux/VPS: cron or systemd — see docs/install-into-project.md
```

Read `grok/TOKEN-BUDGET.md` before wiring Grok Bot routines.

Full guide: [`docs/install-into-project.md`](docs/install-into-project.md).

## Grok extras (this repo only)

| Path | Purpose |
| --- | --- |
| `grok/TOKEN-BUDGET.md` | Thin coordinator; pause poll crons; Delivery owns STATUS |
| `grok/bot-roles.md` | Delivery / Reviewer / Taste / SDLC / Architect |
| `grok/routines/*.md` | Sample routine prompts (no secrets) |

## Charts (design bars — not measured)

> **CRITICAL:** **TARGET 100%** = design bar, **NOT** measured.  
> **~90%** = harness coverage design goal / example render, **NOT** a claimed measured score.

What traits / ORC / groups mean: [`docs/chart-traits.md`](docs/chart-traits.md).

Rendered with **Piotr’s mega-card** ([piotrkrych2/Random-Skills](https://github.com/piotrkrych2/Random-Skills)) — FUT card + 24-spoke.

### TARGET 100%

![TARGET 100% design bar — mega-card](charts/target-100.png)

### ~90% harness coverage (honest gaps)

![~90% coverage design goal — mega-card](charts/coverage-90.png)

```bash
npm run charts
# or: bash scripts/render-charts.sh
```

Needs Google Chrome / Chromium. Shell wrapper calls vendored mega-card; no matplotlib / Python venv for harness DX.

## Credits

- **Limen:** https://mega.dev/autonomous-product-development
- **Charts / mega-card:** https://github.com/piotrkrych2/Random-Skills — **piotrkrych2 / mega-card**
- **pstack (optional):** [open-pstack](https://github.com/ericlitman/open-pstack) — see `docs/pstack.md`

See `ATTRIBUTION.md`.

## Related

- Codex-only sibling: [`startup-harness-codex`](https://github.com/lmiadowicz/startup-harness-codex)

## License

Scripts and docs: use freely. Vendored `vendor/mega-card/` retains upstream attribution.
