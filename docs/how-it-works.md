# How it works (Grok Bot + Codex + Limen)

Flow: **Board (NOW / NEXT / PARK) → Tickets (Done-when) → limen / Pi workers → Codex (+ Grok thin coordinator) → Review → Merge**.

Polished walkthrough: open [orchestration-animation.html](orchestration-animation.html) (also embedded from the README).

## Loop

1. **Board** — keep at most 1–2 jobs in NOW; NEXT is queued; PARK is deferred.
2. **Tickets** — every card has In / Out / Forbidden + falsifiable **Done-when**.
3. **Workers** — `limen` / Pi agents implement.
4. **Codex** — coding agent; **Grok Bot** stays a **thin coordinator** (token budget — see `grok/TOKEN-BUDGET.md`): Delivery owns STATUS; wake Grok only for merge / taste — never FYI spam.
5. **Review** — Reviewer (+ Taste when UI) PASS / HOLD / FAIL.
6. **Merge** — owner / coordinator after clean PASS.

## Install

```bash
bash setup.sh
bash setup.sh /path/to/your-product
```

Read `grok/TOKEN-BUDGET.md` before wiring routines.

## Charts

Primary spider is **MEASURED** Grok+Codex **ORC 69** (Codex-only comparison **65**). See [chart-traits.md](chart-traits.md). TARGET/90 only in `charts/archive/`.

## pstack

Optional quality bar — [pstack.md](pstack.md).
