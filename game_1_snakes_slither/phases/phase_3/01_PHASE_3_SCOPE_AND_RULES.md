# 01 — Phase 3 Scope & Rule Additions
> Phase 3 (L1001–1500) માં લાગુ પડતા નિયમો: Day & Night Garden (Cycles signature system), 5-move period state machine, On-device generation architecture, fixed plateau D band 60–76, grid & path limits અને Remote Config keys.

**Related docs:** [Phase 3 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_3.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી (standard §2–§10):
- Tap → slither out, blocked → head bonk (−1 Heart Berry), 3 Hearts, Second Chance (ad revive level દીઠ 1, Heart Berry Refill 120 coins × max 2/attempt), 4 boosters + free Tongue-Flick Preview.
- Turn-based (કોઈ wall-clock timer નહીં; Cycle state માત્ર player moves થી આગળ વધે છે).
- 0-hearts solvable: દરેક generated level 0 hearts lost અને 0 boosters થી solvable હોવું ફરજિયાત છે.
- Pinch-zoom & pan (boards ≥ 12×12, `fitCell ≥ 22 dp`, max zoom 48 dp cell).
- 8 directions (diagonal snakes M051) અને 3 layers (Ground / Canopy / Treetop).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Signature System: Cycles** | Day & Night Garden: દર 5 Moves એ A (Day) અને B (Night) વચ્ચે alternate થાય છે | L1001 |
| 2 | **On-Device Level Generation** | Levels bundle માંથી લોડ થવાને બદલે device પર PRNG seed થી build થાય છે | L1001 |
| 3 | **Fixed Difficulty Plateau** | D band 60–76 પર સ્થિર રહે છે; non-decrease rule ની જગ્યાએ plateau rule | L1001 |
| 4 | **Base Mechanics M101–M104** | Cycle Gate, Cycle Bridge, Cycle Portal, Cycle Color | L1011, L1131, L1251, L1371 |
| 5 | **Variant System (45 slots)** | 10 generic modifiers સાથે Base Mechanics નું combination | L1021 … L1481 |
| 6 | **Shipped Pre-computed Metadata** | `phase_3_meta.bin` (attempt k, par, D, CRC, solution) | L1001–1500 |

---

## 2. Day & Night Cycle System Rules
### 2.1 State Definition & Timing
- Cycle ની બે મૂળભૂત states છે:
  - **State A (Day / સૂર્ય):** Moves 1–5, 11–15, 21–25, ...
  - **State B (Night / ચંદ્ર):** Moves 6–10, 16–20, 26–30, ...
- **Cycle Period = 5 Moves** (standard §11). એક પૂર્ણ Cycle = 10 Moves (5 Day + 5 Night).
- Level Start વખતે `moveCount = 0` હોય ત્યારે State **Day (State A)** થી શરૂ થાય છે (જ્યાં સુધી level JSON માં `"initialCycle": "B"` override ન હોય).
- Player એ કરેલ **માન્ય Move** (valid slither exit અથવા interactive tap) પછી `moveCount` વધે છે અને Cycle counter આગળ વધે છે. Bump કે locked tap વખતે Move ગણાતો નથી, તેથી Cycle ફેરવાતો નથી.

### 2.2 Tick Order Integration (standard §16.17)
Cycle નું update standard ના tick order માં નીચે મુજબ થાય છે:
1. Player action resolve થાય છે (snake exit અથવા interactive tile tap).
2. `moveCount += 1`.
3. Counters tick: M007, M017 ... Phase 2 mechanics ...
4. **Cycle State Transition:** જો `(moveCount % 5) == 0` હોય, તો Cycle state `A ↔ B` toggle થાય છે.
5. Derived states update: Cycle Gates (M101) open/close, Bridges (M102) appear/disappear, Burrows (M103) switch, Flower Gates (M104) shift colour.
6. Heart loss & Shields resolution.
7. Win check.

---

## 3. On-Device Generation Limits & Parameters
Phase 3 ના તમામ levels `tools/levelgen` દ્વારા નિર્ધારિત નીચેના કડક parameters માં generate થાય છે (SCALING §3.5):

| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ; `fitCell ≥ 22 dp` |
| Snake Paths ($P$) | 28 – 40 snakes | Reverse construction થી place થાય છે |
| Max Obstacles ($O$) | 8 – 14 instances | Marker entries બાદ કરતાં |
| Difficulty ($D$) Band | **60 – 76** | Target formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ≈ 84 | High band × 1.1 (§16.13) |
| L1500 Finale Target | ≈ 91 | High band × 1.2 (§16.13) |
| Par Moves ($S$) | 25 – 55 Moves | Solver દ્વારા ગણાય છે |
| Generation Timeout | ≤ 300 ms (mid-tier) | Isolate thread પર રન થાય છે; cache key `gen/{level}.json.gz` |

---

## 4. Remote Config Keys
Phase 3 માટે નીચેની Remote Config keys ઉપયોગમાં લેવાય છે:

```json
{
  "maxPhase": 3,
  "levelOverrides_p3": {},
  "cycle_vfx_intensity": 1.0,
  "p3_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  }
}
```
- `maxPhase`: જો `maxPhase < 3` હોય તો Phase 3 ના levels UI માં locked રહે છે અને "Coming Soon" card દેખાય છે.
- `levelOverrides_p3`: જો કોઈ ચોક્કસ seed માં ખામી જણાય, તો CI-validated alternate `k` (જે `validated_k.json` માં હોય) અહીથી સેટ કરી શકાય છે.

---

## 5. Open Decisions
- **OD-P3-02:** શું Cycle swap વખતે બોર્ડ background tint માં હળવો Day/Night shader transition રાખવો કે માત્ર ambient overlay? (હાલ 300 ms ambient color tween નક્કી કરેલ છે).

