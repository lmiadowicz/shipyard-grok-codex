# Ticket board (sample) — NOW / NEXT / PARK

Keep **max 1–2** in NOW. Prefer finishing + Reviewer PASS over opening the next ticket.

## NOW
| Ticket | Outcome | Limen | Collision |
| --- | --- | --- | --- |
| F012-slug | Preview shows X after Y click | `--tab` · gpt-6-astra · thinking high | — |
| F018-slug | API returns Z with evidence | `--tab` | no overlap with F012 |

## NEXT
| Ticket | Why next | Depends on |
| --- | --- | --- |
| F020-slug | Unlocks Preview path | F012 Reviewer PASS |
| F021-slug | Owner taste surface | F020 |

## PARK
| Ticket | Why parked | Unpark when |
| --- | --- | --- |
| F050-slug | Nice-to-have polish | NOW empty + quota healthy |
