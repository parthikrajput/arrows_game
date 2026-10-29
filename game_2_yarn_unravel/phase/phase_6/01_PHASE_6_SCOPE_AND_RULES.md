# 01 — Phase 6 Scope & Rule Additions
> Phase 6 (L2501–3000) માં લાગુ પડતા નિયમો: Light & Beams+ (Lamplight Atelier) સિસ્ટમ, રે ટ્રેસિંગ ઓર્ડર, શેડો પોકેટ્સ, D band 70–86, ગ્રીડ અને પાથ લિમિટ્સ.

**Related docs:** [Phase 6 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling §6, §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

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
| 1 | **Light & Beams+ Signature** | ક્રાફ્ટ બોર્ડ પર દીવાઓમાંથી નીકળતા પ્રકાશ કિરણો જે સીધી રેખામાં પ્રવાસ કરે છે | L2501 |
| 2 | **Chromatic Ray Tracing** | Tinted Glass (M251) દ્વારા કિરણો કલર બદલે છે; સન-કેચર્સ મેચિંગ કલરથી જ સક્રિય થાય છે | L2511 |
| 3 | **Prism Clasp Locks (M252)** | બહુવિધ કિરણો એકસાથે મળવાથી ક્લેસ્પ અનલૉક થાય છે | L2631 |
| 4 | **Move-Based Hourglass Lamps (M253)** | N મૂવ્સ ચાલુ અને N મૂવ્સ બંધ રહેતા ટાઇમ્ડ લેમ્પ્સ | L2751 |
| 5 | **Shadow Pockets (M254)** | અંધારા સેલ્સમાં રહેલા દોરાઓ લૉક રહે છે જ્યાં સુધી પ્રકાશ કિરણ તેના પર ન પડે | L2871 |
| 6 | **Fixed Plateau D Band** | D band 70–86 પર સ્થિર રહે છે (SCALING §6) | L2501 |

---

## 2. Light & Beams Gameplay Rules
1. **Ray Propagation:**
   - પ્રકાશ કિરણો લૅમ્પ એમિટર માંથી નીકળીને જ્યાં સુધી કોઈ નક્કર બ્લોકર (વૂડન બટન, દીવાલ, ક્રેઇટ કે દોરાનું શરીર) ન આવે ત્યાં સુધી સીધા આગળ વધે છે.
   - દોરો અનરૅવલ થઈને બહાર નીકળે ત્યારે ખાલી થયેલા સેલ્સમાંથી કિરણો તરત જ આગળ વિસ્તરે છે.
2. **Move Resolution Tick Order (Step 5 Integration):**
   - Step 1 (Action Resolve) અને Step 2 (`moveCount += 1`) બાદ Step 3 માં કાઉન્ટર્સ ટિક થાય છે.
   - Step 4 (Derived States) માં કિરણોનું પુનઃમૂલ્યાંકન (Ray-cast pass) થાય છે:
     1. તમામ લૅમ્પ એમિટર્સમાંથી કિરણો પ્રોજેક્ટ થાય છે.
     2. કલર ફિલ્ટર્સ (M251) અને મિરર્સ (M014) પર રિફ્લેક્શન/કલરિંગ થાય છે.
     3. Prism Clasps (M252) હિટ ચેક થાય છે (જો $\ge 2$ કિરણો મળે તો ક્લેસ્પ કાયમી ઓપન થાય છે).
     4. Shadow Pockets (M254) પર કિરણ પડતાં તે સેલ્સના દોરાઓ તાત્કાલિક અનલૉક થાય છે.
3. **No Wall-Clock Timers:** Hourglass Lamps (M253) સંપૂર્ણપણે Move કાઉન્ટર પર આધારિત છે (દા.ત. દર 3 મૂવે ઑન/ઑફ).

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Fit cell ≥ 22 dp |
| Thread Paths ($P$) | 28 – 40 threads | |
| Max Beam Emitters | 2 – 5 lamps per board | |
| Total Obstacles ($O$) | 8 – 14 instances | |
| Difficulty ($D$) Band | **70 – 86** | Plateau rule |
| x9 Hard Target | ≈ 95 | High band × 1.1 |
| L3000 Finale Target | ≈ 103 | High band × 1.2 |

