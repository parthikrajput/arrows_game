# 01 — Phase 14 Scope & Rule Changes (ફેઝ 14 નિયમો)
> Levels 6501–7000 માટે Mirror Worlds (Reflecting Pond) ના નિયમો, તળાવ અક્ષ, રીફ્લેક્શન લૉક્સ, ઉલટી દિશાની લાઈનો અને Phase 14 limits.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 14 (નવું શું છે)
1. **Mirror Worlds (Reflecting Pond):**
   - બોર્ડ પર પાણીની પ્રતિબિંબ અક્ષ (Pond Axis) અને સમપ્રમાણ મિરર ભૌતિકશાસ્ત્ર લાગુ પડે છે:
     - **Pond Axis (M651):** બોર્ડને મધ્યમાંથી વિભાજિત કરતી પાણીની અક્ષ. એક બાજુની લાઈનને ટેપ કરવાથી અક્ષની બીજી બાજુ રહેલી તેની કાઉન્ટરપાર્ટ મિરર લાઈન પણ સમાન રીતે ગતિ કરે છે (જો કોઈપણ એક અથડાય $\implies -1$ Heart).
     - **Reflection Lock (M652):** આ લૉક ત્યારે જ ખુલે છે જ્યારે અક્ષની સામી બાજુ રહેલા તેના મિરર-ઇમેજ લૉકની ચાવી ધરાવતી કીડી બોર્ડમાંથી બહાર નીકળી જાય.
     - **Twin Pond (M653):** બોર્ડ પરનો દરેક ટેપ બે સ્વતંત્ર તળાવ વિસ્તારોમાં એકસાથે લાગુ પડે છે; કોઈપણ એકમાં bonk થાય તો $-1$ Heart થાય છે.
     - **Upside-Down Line (M654):** વિશિષ્ટ લાઈન જેનો પ્રત્યક્ષ દેખાતો ફેસ જે દિશામાં હોય, તેની સાચી ગતિ દિશા અક્ષની સાપેક્ષે મિરર (ઉલટી) હોય છે (દા.ત. Up દેખાય પરંતુ Down તરફ દોડે).
2. **Axis Mirror Matrix Transformation:**
   - વર્ટિકલ અક્ષ $x = x_{\text{axis}}$ માટે: $x' = 2x_{\text{axis}} - x$, દિશા $\text{Left} \leftrightarrow \text{Right}$.
   - હોરિઝોન્ટલ અક્ષ $y = y_{\text{axis}}$ માટે: $y' = 2y_{\text{axis}} - y$, દિશા $\text{Up} \leftrightarrow \text{Down}$.
3. **4 New Base Mechanics (M651–M654):**
   - Pond Axis (M651), Reflection Lock (M652), Twin Pond (M653), Upside-Down Line (M654).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 14`: Phase 14 content unlock કરવા માટે.
- `p14_water_ripple_hz = 1.5`: Water shimmer ripple shader frequency.

