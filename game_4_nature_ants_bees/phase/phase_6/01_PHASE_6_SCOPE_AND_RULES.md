# 01 — Phase 6 Scope & Rule Changes (ફેઝ 6 નિયમો)
> Levels 2501–3000 માટે Light & Beams+ (Sunlit Garden) ના નિયમો, કલર ફિલ્ટર્સ, સનડાયલ ટાઇમર્સ, ડાર્ક સેલ અનલૉકિંગ અને Phase 6 limits.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 6 (નવું શું છે)
1. **Light & Beams+ (Sunlit Garden):**
   - સૂર્યપ્રકાશના કિરણો Phase 2 માં સામાન્ય સફેદ કિરણો હતા; Phase 6 માં કલર ફિલ્ટરિંગ અને ટાઈમ્ડ એમિશન ઉમેરાય છે:
     - **Petal Filter (M251):** કિરણ જે રંગના ફિલ્ટરમાંથી પસાર થાય તે રંગ ધારણ કરે છે (Red, Yellow, Blue).
     - **Twin-Sun Lock (M252):** લૉક ત્યારે જ ખુલે છે જ્યારે બંને જોડાયેલા રિસીવર સમાન પગલામાં પ્રકાશિત હોય.
     - **Sundial Lens (M253):** મૂવ-આધારિત પિરિયોડિક એમિટર (દર N moves એ ચાલુ/બંધ થાય; wall-clock timer ક્યાંય નથી).
     - **Shade Patch (M254):** છાયડાવાળા સેલ્સમાં રહેલી લાઈનો locked રહે છે જ્યાં સુધી સંબંધિત લેયરનું સૂર્યકિરણ તેમના શરીર પર ન પડે.
2. **Layer-Bound Beams:**
   - સૂર્યકિરણો જે લેયરના એમિટરમાંથી નીકળે તે જ લેયરની લાઈનો અને મિકેનિક્સ સાથે પ્રતિક્રિયા કરે છે (`params.layer: 0, 1, 2`).
3. **4 New Base Mechanics (M251–M254):**
   - Petal Filter (M251), Twin-Sun Lock (M252), Sundial Lens (M253), Shade Patch (M254).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 6`: Phase 6 content unlock કરવા માટે.
- `p6_beam_max_reflections = 8`: Infinite mirror loop prevention cap.
