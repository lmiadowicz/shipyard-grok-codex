# How mega-card scores are generated

Charts use the vendored [Piotr Random-Skills mega-card](https://github.com/piotrkrych2/Random-Skills) skill (English UI). Renderer: **TypeScript** (`vendor/mega-card/render.ts`) — no Python.

## Inputs

A MEGA assessment markdown file with a trait table:

```
| ID | Trait | eligible | applied | declined | missed | verified |
| T01 | … | 10 | 8 | 1 | 1 | 0 |
```

`render.ts` parses eligible / applied / declined for T01–T24, injects them into `template.html`, and Chrome headless screenshots the card + 24-spoke skill web.

## Formulas

| Symbol | Meaning |
| --- | --- |
| **eligible** | Episodes where the trait could apply |
| **applied** | Episodes where it showed up |
| **declined** | Conscious skip — counts **positive** |
| **Trait score** | `(applied + declined) / eligible × 100` (0 if eligible=0) |
| **ORC** | Mean of all 24 trait scores (agent orchestrator rating) |
| **Group (INT…WER)** | Mean of that group's traits |
| **Metal** | ORC ≥75 GOLD · ≥65 SILVER · else BRONZE |

## Groups

| Code | Name | Traits |
| --- | --- | --- |
| INT | Intent | T01 T02 T05 T06 |
| KTX | Context | T03 T04 T09 T10 T11 T12 |
| DIA | Diagnosis | T07 T08 T13 |
| DEL | Delegation | T14 T15 T16 T17 T19 T20 |
| STR | Steering | T18 T21 T22 |
| WER | Verification | T23 T24 |

## Rebuild

```bash
npm install
npm run charts
```

Primary README embeds are **measured** only. TARGET/90 design bars live under `charts/archive/` and must not be presented as coverage.
