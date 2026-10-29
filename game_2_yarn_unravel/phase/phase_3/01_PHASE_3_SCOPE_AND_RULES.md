# 01 — Phase 3 Scope & Rule Additions
> Phase 3 (L1001–1500) માં લાગુ પડતા નિયમો: Day & Night Loom (Cycles signature system), 5-move period state machine, On-device generation architecture, fixed plateau D band 60–76, grid & path limits અને Remote Config keys.

**Related docs:** [Phase 3 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_3.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી (standard §2–§10):
- Tap → thread unravels, blocked → needle snags (−1 Heart, damped twang spring-back), 3 Hearts, Second Chance (ad revive level દીઠ 1, Heart Refill 120 coins × max 2/attempt), 3 boosters + free Thread Peek.
- Turn-based (કોઈ wall-clock timer નહીં; Cycle state માત્ર player moves થી આગળ વધે છે).
- 0-hearts solvable: દરેક generated level 0 hearts lost અને 0 boosters થી solvable હોવું ફરજિયાત છે.
- Pinch-zoom & pan (boards ≥ 12×12, `fitCell ≥ 22 dp`, max zoom 48 dp cell).
- 8 directions (diagonal threads M051) અને 3 layers (M015 / M032 / M055).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Signature System: Cycles** | Day & Night Loom: દર 5 Moves એ A (Day) અને B (Night) વચ્ચે alternate થાય છે | L1001 |
| 2 | **On-Device Level Generation** | Levels bundle માંથી લોડ થવાને બદલે device પર PRNG seed થી build થાય છે (SCALING §2–§4) | L1001 |
| 3 | **Fixed Difficulty Plateau** | D band 60–76 પર સ્થિર રહે છે; non-decrease rule ની જગ્યાએ plateau rule | L1001 |
| 4 | **Base Mechanics M101–M104** | Loom Latch (Cycle Gate), Day Bridge (Cycle Bridge), Night Pompom (Cycle Portal), Twilight Eyelet (Cycle Color) | L1011, L1131, L1251, L1371 |
| 5 | **Variant System (45 slots)** | 10 craft modifiers સાથે Base Mechanics નું combination | L1021 … L1481 |
| 6 | **Shipped Pre-computed Metadata** | `phase_3_meta.bin` (attempt k, par, D, CRC, solution) | L1001–1500 |

---

## 2. Day & Night Loom Cycle System Rules
### 2.1 State Definition & Timing
- Cycle ની બે મૂળભૂત states છે:
  - **State A (Day Loom / દિવસ):** Moves 1–5, 11–15, 21–25, ...
  - **State B (Night Loom / રાત):** Moves 6–10, 16–20, 26–30, ...
- **Cycle Period = 5 Moves** (standard §11). એક પૂર્ણ Cycle = 10 Moves (5 Day + 5 Night).
- Level Start વખતે `moveCount = 0` હોય ત્યારે State **Day Loom (State A)** થી શરૂ થાય છે (જ્યાં સુધી level JSON માં `"initialCycle": "B"` override ન હોય).
- Player એ કરેલ **માન્ય Move** (valid thread unravel અથવા interactive tap) પછી `moveCount` વધે છે અને Cycle counter આગળ વધે છે. Snag bump કે locked tap વખતે Move ગણાતો નથી, તેથી Cycle ફેરવાતો નથી.

### 2.2 Tick Order Integration (standard §16.17)
Cycle નું update standard ના tick order માં નીચે મુજબ થાય છે:
1. Player action resolve થાય છે (thread unravel exit અથવા interactive tile tap).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M025, M027, M047, M041.
4. **Cycle State Transition:** જો `(moveCount % 5) == 0` હોય, તો Cycle state `A ↔ B` toggle થાય છે.
5. Derived states update: Loom Latches (M101) open/close, Day Bridges (M102) switch bridge/blocker, Night Pompoms (M103) activate/deactivate, Twilight Eyelets (M104) shift color.
6. Heart loss & Shields resolution.
7. Win check.

---

## 3. On-Device Generation Limits & Parameters
Phase 3 ના તમામ levels `tools/levelgen` દ્વારા નિર્ધારિત નીચેના કડક parameters માં generate થાય છે (SCALING §3.5):

| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ; `fitCell ≥ 22 dp` |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction થી place થાય છે |
| Max Obstacles ($O$) | 8 – 14 instances | Marker entries બાદ કરતાં |
| Difficulty ($D$) Band | **60 – 76** | Target formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ≈ 84 | High band × 1.1 (§16.13) |
| L1500 Finale Target | ≈ 91 | High band × 1.2 (§16.13) |

- **On-Device Generator Isolation:** Generator isolate માં રન થાય છે (બજેટ: <= 100 ms). CI માં તમામ 500 levels pre-validated હોવાથી device માત્ર `phase_3_meta.bin` માંથી valid `k` મેળવીને level reconstitute કરે છે.
- **Rollout Guard:** Remote Config key `maxPhase` જો `< 3` હોય, તો Phase 3 Map માં locked રહે છે.

