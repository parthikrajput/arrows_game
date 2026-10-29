# 01 · Phase 3 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 3 (Levels 1001–1500) ના નિયમો, Cycles (Day & Night Timetable) signature system નો state machine, Phase 2 vs Phase 3 નું તુલનાત્મક વિશ્લેષણ, grid/path limits અને Remote Config keys.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md)

---

## 1. Scope (પ્રમાણ)
Phase 3 એ Toy Trains નું ત્રીજું મોટું content update છે જે Levels 1001 થી 1500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 2 (501–1000) | Phase 3 (1001–1500) |
|---|---|---|
| Levels | 501–1000 (Bundled `.json.gz`) | **1001–1500 (On-device generated via seed)** |
| Signature System | Zoom/Pan, 8 Directions, 3 Layers | **Day & Night Timetable (Cycles A/B)** |
| New Content | 49 standalone mechanics (M051–M099) | **4 Base (M101–M104) + 45 Variants (Base × Mod)** |
| Difficulty Range | D 38–70 (Challenging slope) | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 11×11 થી 14×14 | **12×12 થી 14×14** (Pinch-zoom + Pan standard) |
| Train Count | 18–32 trains | **28–40 trains** |
| Delivery Pipeline | `assets/levels/phase_2.json.gz` | `xoshiro128ss` seed generator + `phase_3_meta.bin` |

---

## 2. Signature System: Day & Night Timetable (Cycles)
- **Cycle Period:** દર **5 Moves** એ બોર્ડ નું state **State A (Day)** અને **State B (Night)** વચ્ચે ફ્લિપ થાય છે.
- **Tick Order:** Move resolution order ના **Step 3** માં tick થાય છે (Move count increment થયા પછી).
- **Parity / Timing:**
  - Moves 1–5: State A (Day Service)
  - Moves 6–10: State B (Night Service)
  - Moves 11–15: State A (Day Service), વગેરે.
- **HUD Representation:** સ્ક્રીન પર Sun/Moon dial બતાવે છે કે વર્તમાન state કયું છે અને આગલા switch સુધી કેટલા moves બાકી છે.
- **Interactive Taps:** Lever, Switch કે Turntable પર કરવામાં આવેલો tap પણ Move ગણાય છે અને cycle counter ને tick કરે છે.
- **Locked Taps:** Locked tap થી cycle counter આગળ વધતો નથી.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `3` | Player માટે ઉપલબ્ધ મહત્તમ phase. `3` હોય ત્યારે જ L1001 unlock થાય. |
| `phase_3_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_3_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `cycle_period_phase_3` | int | `5` | Cycles system માટેનો Move period. |
| `seed_overrides_p3` | string | `"{}"` | Emergency overrides for failed seeds. |

---

## 4. On-Device Generation Limits
- `seed = hash64("toy_trains", level, GENERATOR_VERSION)`
- Device પર seed attempt `k` (0..63) નો ઉપયોગ કરીને level generate થાય છે.
- Device પર કોઈ retry loop ચાલતી નથી; CI દ્વારા validate થયેલ ચોક્કસ `k` મૂલ્ય `phase_3_meta.bin` માંથી સીધું વાંચવામાં આવે છે.
