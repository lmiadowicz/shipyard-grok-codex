# Ticket template (quality lock)

Status: **PLANNED | NOW | DONE**  
Owner outcome: <one sentence observable result>

## In
- <what must exist when done>

## Out
- <explicit non-goals>

## Forbidden
- <files/areas/behaviours the coding agent must not touch>

## Done-when (falsifiable)
1. Preview: <click path> → <visible result>
2. <test or command> passes
3. <UI/state check>

## Blast-radius
- Likely files: `...`
- Collides with running jobs? **yes/no** — if yes, wait/serialize

## Taste fails if
- <flat wash / wrong flow / …>

## Stop conditions
- Stop and write `.agents/delivery/STATUS.md` when: blocked on owner, CI red after N tries, or scope creep.
