# 01 — Phase 8 Scope & Rule Changes (ફેઝ 8 નિયમો)
> Levels 3501–4000 માટે Growth (Bloom Season) ના નિયમો, ફેલાતી વેલો, ગાર્ડન કાતર, બીજ-છોડતી લાઈનો, પરાગરજ ગેટ્સ અને Phase 8 limits.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 8 (નવું શું છે)
1. **Growth (Bloom Season):**
   - બોર્ડ પર સતત વધતી કુદરતી વનસ્પતિ અને ગતિશીલ અવરોધો ઉમેરાય છે:
     - **Morning Glory Vine (M351):** દર $N$ Moves એ આ વેલ તેની આસપાસના તમામ ખાલી ઓર્થોગોનલ સેલ્સમાં (Up, Right, Down, Left) $1$ સેલ વિસ્તરે છે.
     - **Garden Shears (M352):** પ્રૂનર ટાઇલ; કોઈપણ લાઈન તેના ઉપરથી પસાર થાય ત્યારે આ કાતર તેની આસપાસના ઓર્થોગોનલ વેલ સેલ્સને કાપી નાખે છે.
     - **Seed-Dropping Line (M353):** બહાર નીકળતી વખતે તેના પ્રારંભિક હેડ સેલ પર એક બીજ (seed) મૂકે છે. $N$ Moves પછી આ બીજ બ્લોકર બની જાય છે જો કોઈ લાઈન તે પહેલા તેના પરથી ન પસાર થાય.
     - **Pollination Gate (M354):** ફૂલોનો ગેટ; તેની નજીકથી $K$ લાઈનો સફળતાપૂર્વક બહાર નીકળે ત્યારે તેના પર પરાગરજ બેસે છે અને તે કાયમી ખુલી જાય છે.
2. **Move-Based Expansion Order:**
   - વેલનો ફેલાવો શુદ્ધ ટર્ન-આધારિત છે; પ્લેયરનો Move પૂર્ણ થયા પછી જ ટિક ઓર્ડર (Standard §16.17) મુજબ થાય છે.
3. **4 New Base Mechanics (M351–M354):**
   - Morning Glory Vine (M351), Garden Shears (M352), Seed-Dropping Line (M353), Pollination Gate (M354).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 8`: Phase 8 content unlock કરવા માટે.
- `p8_vine_max_spread_cells = 48`: Single level max vine cap.
