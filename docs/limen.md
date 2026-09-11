# Limen + Herdr

**Download Limen from:** https://mega.dev/autonomous-product-development  

You can download Limen there (and related Herdr tooling). This harness assumes `limen` / `herdr` are on your Mac or VPS PATH after install.

## Why `--tab`

Prefer **hosted** jobs in Herdr:

```bash
limen spawn … --tab
```

- Interactive agent inside the job’s Herdr tab.
- Default overnight / delivery path when Herdr is available.
- Use `--detached` only for explicit background workers (or `--review`).

## Model for UI / product tickets

Prefer Codex **`gpt-6-astra`** with **thinking high**:

```bash
limen spawn --tab \
  --label F0XX-slug \
  --model gpt-6-astra \
  --thinking high \
  --branch codex/f0xx-slug \
  "Implement F0XX: <observable outcome>. Ticket: path/to/ticket.md. Preview proof. No merge."
```

## Herdr attach + spawn

```bash
export PATH="$HOME/Development/limen/bin:$HOME/.local/bin:$PATH"
herdr   # attach LIVE dashboard
cd /path/to/your-product
herdr workspace focus <your-workspace-id> 2>/dev/null || true

limen jobs --all | head -40
limen jobs --running

limen spawn --tab \
  --label F0XX-slug \
  --model gpt-6-astra \
  --thinking high \
  --branch codex/f0xx-slug \
  "Implement F0XX: <outcome>. Ticket: …/ticket.md. Preview proof. No merge."

limen continue <id-or-label> --tab "<follow-up>"
limen watch --running
limen open <label>
```

## Parallelism

- Default **1–2** live jobs.
- Parallel only when file blast-radius does not overlap.
