# Delivery PLAYBOOK excerpt (quality bar)

Patterns genericized from a production agentic product harness. Adapt names/labels to your repo.

## Roles (decision rights)

| Role | May decide | Must escalate |
| --- | --- | --- |
| Delivery | spawn/continue limen, open draft PR, STATUS.md | merge; owner taste |
| Reviewer | PASS/HOLD/FAIL + act-ons | merge |
| Taste | HOLD/PASS on UI craft | merge |
| SDLC | playbook/process docs | product scope |
| Owner / coordinator | merge after PASS; queue order | coding implementation |
| Codex / limen | implement within In/Out | expand scope; touch Forbidden |

## Quality bar

1. **pstack** `to-spec` / `to-tickets` / `architect` before limen spawn (Codex-safe tickets: In/Out/Forbidden + Taste fails).
2. **limen + Codex** scales implementation (prefer 1–2 jobs; never five half-PRs).
3. **Taste + Reviewer PASS** before owner merge; Preview not broken.
4. Every ticket has **Done-when** (3–5 falsifiable checks) and **blast-radius**.
5. Draft PR cites Done-when + evidence under `.verification/evidence/` (or honest blocker).

## Parallelism

- Default **1–2** limen jobs when quota uncertain.
- Parallel only non-overlapping files; serialize otherwise.
- Prefer finishing + Reviewer PASS over opening the next ticket.

## Optional auto-merge label pattern

- Label (example): `delivery:reviewer-pass`
- `orchestrate.sh` may auto-merge when that label is present **and** authoritative CI is green.
- Treat auto-merge as **optional** — disable by not installing launchd / not applying the label.

## Mac orchestrate (token-saving)

1. `bash setup.sh /path/to/product` then `bash .agents/delivery/scripts/install-launchd.sh`
2. `orchestrate.sh` writes `STATUS.md` + `ACTIONS.json`
3. Prefer `review-and-label.sh <PR>` over waking a chat coordinator
4. Wake the coordinator only for merge after clean PASS or owner taste — never FYI spam
