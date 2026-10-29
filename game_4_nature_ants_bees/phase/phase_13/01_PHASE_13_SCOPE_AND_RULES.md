# 01 — Phase 13 Scope & Rule Changes (ફેઝ 13 નિયમો)
> Levels 6001–6500 માટે Hidden Info (Mystery Meadow) ના નિયમો, ધુમ્મસ ક્લિયરિંગ, સ્કાઉટ કીડીઓ, ભ્રામક કાંકરા અને Phase 13 limits.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 13 (નવું શું છે)
1. **Hidden Info (Mystery Meadow):**
   - પઝલમાં માહિતી છુપાયેલી હોય છે અને પ્લેયરે સ્કાઉટિંગ અને તાર્કિક અનુમાન દ્વારા રસ્તો શોધવાનો હોય છે:
     - **Scout Ant (M601):** બોર્ડમાંથી બહાર નીકળતાં જ પોતાની લેનની આસપાસના 2 સેલ્સ (Chebyshev અંતર) માં રહેલા તમામ ધુમ્મસ (fog) ને કાયમી સાફ કરે છે.
     - **Mirage Mist (M602):** શરૂઆતમાં સામાન્ય લૉન જેવું દેખાય છે, પરંતુ જ્યારે કોઈ લાઈન તેની અડીને પસાર થાય છે ત્યારે તે ધુમ્મસમાં ફેરવાઈને અંદરની લાઈનોને છુપાવી દે છે.
     - **Painted Pebble (M603):** સામાન્ય બ્લોકર જેવો દેખાય છે, પરંતુ તે ભ્રામક દીવાલ (false wall) છે; લાઈનો તેના ઉપરથી કોઈપણ અથડામણ વગર પસાર થઈ જાય છે અને તેને અનાવૃત કરે છે (Preview માં "?" દેખાય છે).
     - **Sunlit Plate (M604):** જ્યારે કોઈ કીડીનું શરીર આ પ્લેટ પર ઊભું હોય છે, ત્યારે તેની આખી હરોળ અને સ્તંભ (row and column) ની તમામ છુપાયેલી લાઈનો પ્રકાશિત થઈને ટેપ કરવા યોગ્ય બને છે.
2. **Chebyshev Fog Radius ($\le 2$):**
   - સ્કાઉટ લેનથી મહત્તમ $(\max(|x_1-x_2|, |y_1-y_2|) \le 2)$ અંતરના તમામ સેલ્સ સ્પષ્ટ દેખાય છે.
3. **4 New Base Mechanics (M601–M604):**
   - Scout Ant (M601), Mirage Mist (M602), Painted Pebble (M603), Sunlit Plate (M604).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 13`: Phase 13 content unlock કરવા માટે.
- `p13_fog_dissolve_ms = 200`: Fog clearing animation speed.

