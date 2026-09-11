---
name: mega-card
description: FIFA/FUT-style card plus 24-spoke skill web from a MEGA Assessment report (mega-assessment-*.md). Writes HTML and PNG. Use when the user asks for a player card, skill web/spider, radar, or trait chart from a MEGA assessment.
---

# mega-card

From a MEGA Assessment report, render a bronze/silver/gold FUT card (overall + 6 hex stats) beside a full 24-trait skill web (0–100).

UI strings are **English** (GROUPS / NAMES / GOLD·SILVER·BRONZE). Edit `GROUPS` and `NAMES` in `template.html` to rename groups or traits.

## Groups

| Code | Name | Traits |
| --- | --- | --- |
| INT | Intent | T01, T02, T05, T06 |
| KTX | Context | T03, T04, T09, T10, T11, T12 |
| DIA | Diagnosis | T07, T08, T13 |
| DEL | Delegation | T14, T15, T16, T17, T19, T20 |
| STR | Steering | T18, T21, T22 |
| WER | Verification | T23, T24 |

## Report fields

- Card footer: `**Scan date:**` or `**Data skanu:**`, optional episode/session/day counts.
- Trait table: ID | name | eligible | applied | declined | missed | verified

Credit: piotrkrych2 / Random-Skills mega-card.
