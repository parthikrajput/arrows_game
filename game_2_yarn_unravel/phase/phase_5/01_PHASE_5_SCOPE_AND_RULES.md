# 01 — Phase 5 Scope & Rule Additions
> Phase 5 (L2001–2500) માં લાગુ પડતા નિયમો: Push Physics+ (Crate Workshop) સિસ્ટમ, ક્રેઇટ પુશ કાઇનેટિક્સ, પિટ ફિલિંગ, D band 67–83, ગ્રીડ અને પાથ લિમિટ્સ.

**Related docs:** [Phase 5 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling §6, §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

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
| 1 | **Push Physics+ Signature** | ક્રાફ્ટ બોર્ડ પર ફરતી લાકડાની સીવણ સામાનની ક્રેઇટ્સ (Notions Crates) | L2001 |
| 2 | **Crate Push Kinetics** | દોરો અનરૅવલ થતાં સામે આવતી ક્રેઇટને 1 સેલ આગળ ધકેલે છે (જો આગળનો સેલ ખાલી હોય) | L2001 |
| 3 | **Base Mechanics M201–M204** | Crate Pit (M201), Satin Crate (M202), Charm Crate (M203), Iron Crate (M204) | L2011, L2131, L2251, L2371 |
| 4 | **Fixed Plateau D Band** | D band 67–83 પર સ્થિર રહે છે (SCALING §6) | L2001 |

---

## 2. Push Physics Gameplay Rules
1. **Push Interaction:**
   - જ્યારે કોઈ દોરો તેની પુલ લાઇન પર આગળ વધે છે અને તેનો માર્ગ સામાન્ય ક્રેઇટ સાથે અથડાય છે:
     - જો ક્રેઇટ પાછળનો સેલ ખાલી હોય, તો દોરો ક્રેઇટને તે દિશામાં **1 સેલ આગળ ધકેલે છે** અને દોરો પોતાનો માર્ગ આગળ વધારે છે.
     - જો ક્રેઇટ પાછળ બીજો કોઈ બ્લોકર, દીવાલ કે અન્ય દોરો હોય, તો ક્રેઇટ ખસી શકતી નથી ⇒ દોરો ક્રેઇટ સાથે અથડાઈને **snag** થાય છે (-1 Heart).
2. **Move Resolution Tick Order (Push Integration):**
   - Step 1 (Action Resolve) માં પુશ કાઇનેટિક્સ ગણાય છે. ક્રેઇટનું નવું સ્થાન અપડેટ થાય છે અને ત્યારબાદ દોરાનું અનરૅવલિંગ પૂર્ણ થાય છે.
3. **Crate Pits (M201):** ક્રેઇટ ખાડામાં ધકેલાતાં ખાડો ભરાઈ જાય છે અને બંને સામાન્ય સપાટ લિનન ફ્લોર બની જાય છે.
4. **Satin Crates (M202):** સ્લાઇડિંગ ક્રેઇટ્સ જ્યાં સુધી કોઈ અવરોધ ન આવે ત્યાં સુધી લપસીને સતત આગળ વધે છે.
5. **Heavy Iron Crates (M204):** સામાન્ય દોરાથી ધકેલાતી નથી (સ્નેગ થાય છે); માત્ર Chunky Chenille (M024) અથવા Ribbon-Tied Pairs (M011) થી જ ધકેલી શકાય છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Fit cell ≥ 22 dp |
| Thread Paths ($P$) | 28 – 40 threads | |
| Pushable Crates | 2 – 6 crates per board | |
| Total Obstacles ($O$) | 8 – 14 instances | Crates સહિત |
| Difficulty ($D$) Band | **67 – 83** | Plateau rule |
| x9 Hard Target | ≈ 91 | High band × 1.1 |
| L2500 Finale Target | ≈ 100 | High band × 1.2 |

