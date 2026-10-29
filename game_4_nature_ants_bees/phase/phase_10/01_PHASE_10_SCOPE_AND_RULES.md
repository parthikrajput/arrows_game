# 01 — Phase 10 Scope & Rule Changes (ફેઝ 10 નિયમો)
> Levels 4501–5000 માટે Sequencing (Garden Rhythm) ના નિયમો, મોડ્યુલો ગેટ્સ, કલર પેટર્ન લૉક્સ, કતારબદ્ધ એક્ઝિટ અને Phase 10 limits.

**Related docs:** [Phase 10 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 10 (નવું શું છે)
1. **Sequencing (Garden Rhythm):**
   - પઝલમાં માત્ર કઈ લાઈન બહાર નીકળે છે તે જ નહીં, પરંતુ **કયા ક્રમમાં અને કયા તાલબદ્ધ મૂવ પર** નીકળે છે તે મહત્વનું બને છે:
     - **Cricket Gate (M451):** મૂવ-કાઉન્ટર પર આધારિત રિધમ ગેટ. `moveCount mod P ∈ S` હોય ત્યારે જ ખુલે છે (ઉદા. $P = 3, S = \{0\}$ એટલે કે 0, 3, 6, 9... મો Moves પર ખુલ્લો).
     - **Bead-String Lock (M452):** ચોક્કસ કલર સીક્વન્સ લૉક. બોર્ડ પર દર્શાવેલ રંગીન મોતીઓની માળા મુજબ સતત $k$ લાઈનો સમાન રંગ ક્રમમાં બહાર નીકળે ત્યારે જ લૉક ખુલે છે.
     - **Queue Hedge (M453):** ક્રમાંકિત સરહદ. તે માત્ર તેના પર લખેલા નંબર ક્રમ (1, 2, 3...) અનુસાર જ લાઈનોને બહાર જવા દે છે; ખોટા ક્રમમાં આવતી લાઈન bonk થાય છે.
     - **Echo Bloom (M454):** પ્રથમ $k$ લાઈનોના રંગોનું રેકોર્ડિંગ કરે છે; ત્યાર પછીની $k$ લાઈનોએ તે જ રંગ ક્રમનું પુનરાવર્તન કરવું પડે છે (ખોટો રંગ ટેપ થતાં અટકે છે).
2. **Turn-Based Rhythm State:**
   - કોઈપણ wall-clock timer નથી; તમામ રિધમ સાયકલ્સ માત્ર પ્લેયરના લીગલ Moves થી જ આગળ વધે છે.
3. **4 New Base Mechanics (M451–M454):**
   - Cricket Gate (M451), Bead-String Lock (M452), Queue Hedge (M453), Echo Bloom (M454).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 10`: Phase 10 content unlock કરવા માટે.
- `p10_rhythm_pulse_intensity = 1.0`: UI rhythm glow pulse scale.

