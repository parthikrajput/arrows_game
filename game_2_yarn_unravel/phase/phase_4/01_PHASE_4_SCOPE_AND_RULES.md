# 01 — Phase 4 Scope & Rule Additions
> Phase 4 (L1501–2000) માં લાગુ પડતા નિયમો: Multi-Floor (Sewing Room Floors) સિસ્ટમ, વર્ટિકલ ટ્રાવર્સલ, ફ્લોર કેમેરા સ્વિચિંગ, D band 64–80, ગ્રીડ અને પાથ લિમિટ્સ.

**Related docs:** [Phase 4 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling §6, §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

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
| 1 | **Multi-Floor Architecture** | મહત્તમ 3 વર્ટિકલ ફ્લોર્સ (Floor 1, 2, 3) | L1501 |
| 2 | **Vertical Traversal** | Stairs (M151), Drop Holes (M153), Elevators (M154) દ્વારા ફ્લોર્સ વચ્ચે દોરાઓનું વહન | L1511, L1751, L1871 |
| 3 | **Organza Glass Floor** | ઉપરના ફ્લોર પરથી નીચેના ફ્લોરના દોરાઓ જોઈ અને ટેપ કરી શકાય | L1631 |
| 4 | **Fixed Plateau D Band** | D band 64–80 પર સ્થિર રહે છે (SCALING §6) | L1501 |
| 5 | **Floor Switcher HUD** | F1 / F2 / F3 ટેબ્સ સાથે કેમેરા સ્મૂધ વર્ટિકલ ગ્લાઇડ | L1501 |

---

## 2. Multi-Floor Gameplay Rules
1. **Floor Independence:** દરેક ફ્લોર પોતાનું 2D ગ્રીડ (12×12 થી 14×14) ધરાવે છે. દોરાઓ અને અવરોધો ચોક્કસ ફ્લોર પર સ્થિત હોય છે.
2. **Active Floor & Input:** ખેલાડી જે ફ્લોર જોઈ રહ્યો હોય તે સક્રિય ફ્લોર ગણાય છે. Organza Floor (M152) સિવાય સામાન્ય રીતે અન્ય ફ્લોરના દોરાઓ સીધા ટેપ કરી શકાતા નથી.
3. **Floor Switching (Move નથી):** HUD પર F1/F2/F3 બટન દબાવવાથી કેમેરા બીજા ફ્લોર પર જાય છે. આ ક્રિયાથી Move કાઉન્ટર વધતું નથી (0 Moves cost).
4. **Vertical Move Resolution:**
   - જો કોઈ દોરો Spiral Spool Stair (M151) માં પ્રવેશે, તો તે અવિરત ગતિમાં લક્ષ્ય ફ્લોર પર સમાન `(x, y)` સેલ અને સમાન દિશામાં પોતાની લાઇન ચાલુ રાખે છે.
   - જો દોરો Drop Hole (M153) પર પહોંચે, તો તે નીચેના ફ્લોર પર તે સેલમાં ડ્રોપ થાય છે (Relocate, 1 Move). હવે તે તે સેલમાંથી નવો ટેપ સ્વીકારે છે.
   - Bobbin Lift (M154) પર ટેપ કરવાથી તે સેલ પર રહેલો દોરો ઊર્ધ્વગમન/અધોગમન કરે છે (1 Move).
5. **Win Condition:** ત્રણેય ફ્લોર્સ પરના તમામ દોરાઓ અનરૅવલ થઈને બોર્ડ બહાર નીકળે ત્યારે જ વિજય ઘોષિત થાય છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Floors Count | 2 – 3 Floors | L1501–1650: 2 Floors; L1651+: 3 Floors |
| Grid Size per Floor | 12×12 – 14×14 | Fit cell ≥ 22 dp |
| Total Threads ($P$) | 28 – 40 threads | તમામ ફ્લોર્સ વચ્ચે વહેંચાયેલા |
| Total Obstacles ($O$) | 8 – 14 instances | |
| Difficulty ($D$) Band | **64 – 80** | Plateau rule |
| x9 Hard Target | ≈ 88 | High band × 1.1 |
| L2000 Finale Target | ≈ 96 | High band × 1.2 |

