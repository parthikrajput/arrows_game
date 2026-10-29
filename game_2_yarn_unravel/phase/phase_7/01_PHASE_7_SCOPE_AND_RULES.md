# 01 — Phase 7 Scope & Rule Additions
> Phase 7 (L3001–3500) માં લાગુ પડતા નિયમો: Rotation (Turning Table) સિસ્ટમ, હૂપ રોટર્સ, ટર્નિંગ હેમ્સ, ટ્વિર્લ દોરાઓ, ટેન્ગલ્ડ સ્ટેટ્સ, D band 73–89, ગ્રીડ અને પાથ લિમિટ્સ.

**Related docs:** [Phase 7 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling §6, §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

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
| 1 | **Rotation Signature: Turning Table** | બોર્ડ પર 90° ક્લોકવાઇઝ રોટેશનલ એલિમેન્ટ્સ | L3001 |
| 2 | **Hoop Rotors (M301)** | 4×4 સબ-ગ્રીડ રોટેશન (ઇન્ટરેક્ટિવ ટેપ, ખર્ચ 1 Move) | L3011 |
| 3 | **Turning Hems (M302)** | બોર્ડની ઓપન એક્ઝિટ ગેપ્સ દર મૂવે 1 સેગમેન્ટ CW ફરે છે | L3131 |
| 4 | **Twirl Threads (M303)** | દરેક Move પછી સોયની દિશા 90° CW બદલાય છે | L3251 |
| 5 | **Ratchet Pins (M304)** | રોટેશન-લૉક જે કી-દોરો ન નીકળે ત્યાં સુધી રોટેશન રોકે છે | L3371 |
| 6 | **Fixed Plateau D Band** | D band 73–89 પર સ્થિર રહે છે (SCALING §6) | L3001 |

---

## 2. Rotation Mechanics & Tangled Rules
1. **Sub-Board Rotor (M301):**
   - 4×4 રોટર સેન્ટર પર ટેપ કરવાથી માત્ર તે 4×4 ગ્રીડના તમામ કોઓર્ડિનેટ્સ 90° CW ફરે છે.
   - **Boundary Invariant:** જે દોરાઓ સંપૂર્ણપણે 4×4 રોટરની અંદર આવેલા હોય તે જ તેની સાથે ફરે છે. જે દોરો અર્ધ અંદર અને અર્ધ બહાર હોય તે રોટરના રોટેશનને **લૉક** કરે છે (ટેપ પર સોફ્ટ વૉબલ, 0 Move).
2. **Tangled Thread State:**
   - જો રોટેશનના પરિણામે કોઈ દોરાની સોય (`body[0]`) પોતાના જ શરીરના સેગમેન્ટ તરફ પોઇન્ટ કરે, તો તે દોરો "Tangled" સ્ટેટમાં મુકાય છે.
   - Tangled દોરા પર ટેપ કરવાથી લૉક વૉબલ થાય છે (0 Heart lost, 0 Move). તે snag bump કરતો નથી. જ્યારે આગામી રોટેશન તેની દિશા ફરી મુક્ત કરે ત્યારે જ તે અનરૅવલ થઈ શકે છે.
3. **Move Resolution Tick Order (Step 3 Integration):**
   - Step 1 (Action Resolve) બાદ `moveCount += 1`.
   - Step 3 (Counters Tick) માં M302 Turning Hems 1 સેલ CW આગળ વધે છે અને M303 Twirl Threads ની સોય 90° CW ફરે છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Fit cell ≥ 22 dp |
| Thread Paths ($P$) | 28 – 40 threads | |
| Max Rotors | 1 – 3 rotors per board | |
| Total Obstacles ($O$) | 8 – 14 instances | |
| Difficulty ($D$) Band | **73 – 89** | Plateau rule |
| x9 Hard Target | ≈ 98 | High band × 1.1 |
| L3500 Finale Target | ≈ 107 | High band × 1.2 |

