# Using pstack (quality bar)

Do **not** vendor the full pstack monorepo into this harness. Clone and install upstream.

## Recommended

- **Original (Cursor):** [cursor/plugins pstack](https://github.com/cursor/plugins/tree/main/pstack) — Lauren Tan ([@poteto](https://x.com/poteto)) style workflows.
- **Claude Code / Codex port:** [ericlitman/open-pstack](https://github.com/ericlitman/open-pstack) (unofficial community; keep its LICENSE / NOTICE if you vendor scripts).

## Typical flow

1. `to-spec` — turn a vague goal into a falsifiable spec.
2. `to-tickets` — split into In/Out/Forbidden + Done-when tickets (see `TICKET-TEMPLATE.md`).
3. `architect` — only when design choice matters; keep diffs small.
4. Hand tickets to **limen + Codex** for implementation; Reviewer closes the loop.

## Clone (example)

```bash
git clone https://github.com/ericlitman/open-pstack.git ~/Development/open-pstack
# Follow open-pstack README for Codex / Claude Code plugin install.
```

If you already keep `~/Development/open-pstack`, point agents there — this harness only documents the pointer.
