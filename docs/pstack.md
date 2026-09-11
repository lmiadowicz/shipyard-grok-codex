# Using pstack (quality bar)

Do **not** vendor the full pstack monorepo into this harness. Clone / install upstream and point agents at it.

## Upstream

- **Cursor plugin:** [cursor/plugins pstack](https://github.com/cursor/plugins/tree/main/pstack) — Lauren Tan ([@poteto](https://x.com/poteto)) style.
- **Claude Code / Codex port:** [ericlitman/open-pstack](https://github.com/ericlitman/open-pstack) (community; keep LICENSE / NOTICE if you package anything).

## Recommended skills

### Daily (quality + reliability)

| Skill | When |
| --- | --- |
| `poteto-mode` | Default high-bar coding mode |
| `setup-pstack` | First-time / refresh install |
| `how` | Orient before large changes |
| `architect` | Sparingly — only when design choice matters |
| `unslop` / `deslop` | Strip AI slop before review |
| `thermo-nuclear-code-quality-review` | Pre-merge quality pass |
| `interrogate` | Contested decisions only — not every ticket |

### UI anti-drift

| Skill | Why |
| --- | --- |
| `visual-parity` playbook | Keep UI matching intent / screenshots |
| `create-verification-skill` | Capture Done-when as a reusable check |
| `maintain-verification-skill` | Keep checks honest as product moves |
| `principle-experience-first` | Ship feel over theory |
| `principle-subtract-before-you-add` | Prefer delete / simplify |

### Token cost

| Skill | Why |
| --- | --- |
| `principle-guard-the-context-window` | Do not dump the world into every prompt |
| `principle-laziness-protocol` | Least work that still closes Done-when |
| `principle-minimize-reader-load` | Short STATUS / act-ons |
| `blast-radius` | Name what can break before edit |
| `babysit` | Watch long jobs without re-briefing from scratch |

**Avoid** arena / multi-model shootouts on every ticket — reserve for contested architecture or taste.

## Typical flow

1. `to-spec` — falsifiable spec.
2. `to-tickets` — In / Out / Forbidden + Done-when (see `TICKET-TEMPLATE.md`).
3. `architect` — only when needed; keep diffs small.
4. Hand tickets to **limen + Codex** (and thin Grok coordinator in the grok-codex variant); Reviewer closes the loop.

## Clone (example)

```bash
git clone https://github.com/ericlitman/open-pstack.git ~/Development/open-pstack
# Follow open-pstack README for Codex / Claude Code / Cursor install.
```

If you already keep `~/Development/open-pstack`, point agents there — this harness only documents the pointer.
