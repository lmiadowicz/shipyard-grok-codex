# Chart traits — what the spider / FUT card means

Charts in this repo are **design bars** rendered with Piotr’s [mega-card](https://github.com/piotrkrych2/Random-Skills) (FUT card + 24-spoke spider). They are **not** claimed measured assessment scores.

## How scores work

For each trait T01–T24:

```text
score = (applied + declined) / eligible * 100
```

- **eligible** — episodes where the trait could apply  
- **applied** — trait was practiced  
- **declined** — conscious skip (counts **positive**, same as applied)  
- **missed** — should have applied but did not  

## Overall ORC / card tier

- **ORC** (overall on the FUT card) = mean of the 24 trait scores  
- Card metal tier (mega-card): **75+ gold**, **65–74 silver**, below **bronze**

## Groups (INT / KTX / DIA / DEL / STR / WER)

Mega-card’s own grouping (not a contest taxonomy):

| Code | Group (PL) | Group (EN) | Traits |
| --- | --- | --- | --- |
| **INT** | Intencja | Intent | T01, T02, T05, T06 |
| **KTX** | Kontekst | Context | T03, T04, T09, T10, T11, T12 |
| **DIA** | Diagnoza | Diagnosis | T07, T08, T13 |
| **DEL** | Delegacja | Delegation | T14, T15, T16, T17, T19, T20 |
| **STR** | Sterowanie | Steering | T18, T21, T22 |
| **WER** | Weryfikacja | Verification | T23, T24 |

## T01–T24 (Polish + English)

Names from mega-card `NAMES` / MEGA trait labels:

| ID | Polish (mega-card) | English |
| --- | --- | --- |
| T01 | Jasność intencji | Intent Clarity |
| T02 | Poziom ramowania | Problem Framing |
| T03 | Model stanu agenta | Agent State Modeling |
| T04 | Kotwiczenie kontekstu | Context Anchoring |
| T05 | Precyzja ograniczeń | Constraint Precision |
| T06 | Sprawdzalna akceptacja | Falsifiable Acceptance |
| T07 | Najpierw zrozumienie | Problem Understanding First |
| T08 | Przyczyna źródłowa | Root-Cause Orientation |
| T09 | Dowody w decyzji | Evidence Injection |
| T10 | Stopniowe odsłanianie | Progressive Disclosure |
| T11 | Ekonomia kontekstu | Context Economy |
| T12 | Trwała pamięć | Durable Memory |
| T13 | Czytaj przed edycją | Inspect-Before-Edit |
| T14 | Przygotowanie narzędzi | Capability Provisioning |
| T15 | Ocena delegacji | Delegation Judgment |
| T16 | Dekompozycja | Decomposition Skill |
| T17 | Jakość briefu | Agent Brief Quality |
| T18 | Prawa decyzyjne | Decision Rights |
| T19 | Higiena równoległości | Parallelism Hygiene |
| T20 | Integracja wyników | Result Integration |
| T21 | Precyzja feedbacku | Feedback Specificity |
| T22 | Sterowanie i zaufanie | Steering and Trust |
| T23 | Domknięcie weryfikacji | Verification Closure |
| T24 | Uczenie po błędach | Recovery and Learning |

## TARGET 100% vs ~90% coverage

| Chart | Meaning |
| --- | --- |
| **TARGET 100%** | Aspirational **design bar** — every spoke at full radius. Goal to aim at while building the harness. |
| **~90% coverage** | Harness **coverage design goal** / example render with honest gaps (e.g. Context Anchoring, Evidence, Progressive Disclosure, Parallelism, Verification Closure). |

**Neither chart is a claimed measured score.** Do not treat README embeds as ORC results from a live scan.

## Rebuild

```bash
bash scripts/render-charts.sh
# or: npm run charts
```

Needs Google Chrome / Chromium for headless PNG. Wrapper calls `python3 vendor/mega-card/render.py` only as an implementation detail of Piotr’s tool — harness DX stays shell-first.

Credit: [piotrkrych2/Random-Skills](https://github.com/piotrkrych2/Random-Skills) · `vendor/mega-card/`.
