# 01 — Phase 8 Scope & Rule Additions
> Phase 8 (L3501–4000) માં લાગુ પડતા નિયમો: Growth (Garden Knitting) સિસ્ટમ, આઇવી યાર્ન ગ્રોથ કાઇનેટિક્સ, સ્નિપ પ્રૂનિંગ ટાઇલ્સ, સીડ બીડ ટાઇમર્સ, D band 76–92, ગ્રીડ અને પાથ લિમિટ્સ.

**Related docs:** [Phase 8 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling §6, §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી:
- 3 Hearts, snag bump (-1 Heart, twang), Second Chance (ad revive 1/level, 120 coin refill max 2/attempt), 3 boosters + free Thread Peek.
- Turn-based પઝલ નિયમો; કોઈ સમય મર્યાદા નથી.
- 0-hearts solvable: તમામ levels બૂસ્ટર્સ વગર સોલ્વેબલ હોવા ફરજિયાત છે.
- Pinch-zoom & pan સક્ષમ.

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Growth Signature: Garden Knitting** | ગ્રીન આઇવી યાર્ન જે દર N Moves એ ખાલી સેલ્સમાં 2 નવા સેલ્સ વિસ્તરે છે | L3501 |
| 2 | **Snip Pruner Tiles (M352)** | પુલ લાઇન આ ટાઇલ પરથી પસાર થતાં તેની આસપાસના 8 સેલ્સના ગ્રોથને કાપી નાખે છે | L3631 |
| 3 | **Seed Bead Threads (M353)** | દોરો નીકળતાં પૂંછડીના સેલ પર સીડ બીડ મુકાય છે જે 3 Moves માં વૂડન બટન બને છે | L3751 |
| 4 | **Blossom Gates (M354)** | પડોશના K ગ્રોથ સેલ્સ ક્લિયર થવાથી જ કાયમી ઓપન થાય છે | L3871 |
| 5 | **Fixed Plateau D Band** | D band 76–92 પર સ્થિર રહે છે (SCALING §6) | L3501 |

---

## 2. Growth Mechanics & Pruning Rules
1. **Ivy Yarn Spread Kinetics (M351):**
   - દર N Moves (દા.ત. 3 Moves) પછી, સૌથી જૂના ગ્રોથ સેલમાંથી ઘડિયાળના કાંટા મુજબ (Up -> Right -> Down -> Left) પ્રાધાન્યતા સાથે 2 ખાલી પડોશી સેલ્સમાં નવો આઇવી ગ્રોથ વિસ્તરે છે.
   - ગ્રોથ સેલ સિંગલ બ્લોકર તરીકે વર્તે છે અને પુલ લાઇનને રોકે છે (સ્નેગ, -1 Heart).
   - ગ્રોથ સેલ્સ ગોલ્ડન સિઝર્સ (Hammer) વડે સ્નિપ કરી શકાય છે (1 સેલ પ્રતિ સ્નિપ).
2. **Move Resolution Tick Order (Step 3 Integration):**
   - Step 1 (Action Resolve) માં Snip Tile (M352) ટ્રાવર્સલથી પડોશી ગ્રોથ તરત જ સાફ થાય છે.
   - Step 2 (`moveCount += 1`).
   - Step 3 (Counters Tick) માં:
     - M027 Spreading Tangle અને M351 Ivy Yarn ટિક થાય છે અને જો મૂવ શરત પૂરી થાય તો વિસ્તરે છે.
     - M353 Seed Bead કાઉન્ટર 1 ઘટે છે (0 થતાં જો સેલ પર કોઈ દોરો ન હોય તો Wooden Button M001 બને છે).
   - Step 4 (Derived States) માં M354 Blossom Gate K પડોશી ક્લિયર ગણતરી ચકાસે છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Fit cell ≥ 22 dp |
| Thread Paths ($P$) | 28 – 40 threads | |
| Max Spreader Roots | 1 – 3 roots per board | |
| Total Obstacles ($O$) | 8 – 14 instances | |
| Difficulty ($D$) Band | **76 – 92** | Plateau rule |
| x9 Hard Target | ≈ 101 | High band × 1.1 |
| L4000 Finale Target | ≈ 110 | High band × 1.2 |

