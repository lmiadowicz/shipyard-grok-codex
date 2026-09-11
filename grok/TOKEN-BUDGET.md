# Grok Bot token budget

Goal: burn almost no SuperGrok on standing wakes. Prefer shell / limen / `gh` + files over Grok Bot turns.

## Ownership

- **Thin coordinator (e.g. Stark):** decide, merge after Reviewer PASS, owner taste URLs only. Standing delivery/morning/evening **poll crons paused**.
- **Delivery:** owns limen `--tab` spawns, draft PRs, evening ready ping, writes `.agents/delivery/STATUS.md`. **Delivery owns the loop.**
- **Reviewer:** prefer GitHub event listeners over dense cron polls.
- **Taste / SDLC / Architect:** on-demand, not heartbeat.

## Hard rules

1. **No FYI / ack spam** to the coordinator. Wake only for: (a) merge after clean Reviewer PASS, or (b) owner taste that needs a human.
2. Prefer writing `.agents/delivery/STATUS.md` (and limen board) over chatting agents.
3. Prefer scripts under `.agents/delivery/scripts/` for rebase / open-PR / CI wait / status dump.
4. Stay quiet on no-op routine runs — never send filler.
5. Codex at **0% usage → stop new spawns** (fail-closed); ping owner; reset in Codex app — not by wiping `~/.codex`.

## Default wake policy

| Event | Wake coordinator? |
| --- | --- |
| STATUS.md updated, nothing to merge | No |
| limen job still running | No |
| Reviewer PASS + CI green | Yes — merge decision |
| Taste URL ready | Yes — taste only |
| FYI / “still working” | **Never** |
