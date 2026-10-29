# 01 — Phase 17 Scope & Rule Changes (ફેઝ 17 નિયમો)
> Levels 8001–8500 માટે Guardians (Garden Guardians) ના નિયમો, શેર કરેલ HP, આર્મર શિલ્ડ્સ, સ્પોનર્સ અને Phase 17 limits.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 17 (નવું શું છે)
1. **Guardians (Garden Guardians):**
   - સામાન્ય બ્લોકર્સની જગ્યાએ બોર્ડ પર વિશાળ બોસ ગાર્ડિયન્સ આવે છે જેમને હરાવવા માટે ખાસ વ્યૂહરચના જરૂરી છે:
     - **Twin Hornets (M801):** બે સ્વતંત્ર $2\times 2$ કદના હોર્નેટ્સ જે સમાન HP પૂલ શેર કરે છે. નિર્ધારિત લાઈનો બહાર નીકળતાં HP ઘટે છે અને 0 થતાં બંને એકસાથે ગાયબ થાય છે.
     - **Armored Rhino Beetle (M802):** અભેદ્ય કવચ ધરાવતો વિશાળ બીટલ. જ્યાં સુધી જોડાયેલું આઈવી લીવર ખેંચીને તેનું શિલ્ડ હટાવવામાં ન આવે ત્યાં સુધી તેના પર કોઈ નુકસાન થતું નથી.
     - **Wasp Nest Guardian (M803):** ભમરીનો માળો; દર $N$ Moves એ પોતાની આસપાસના પ્રથમ મુક્ત સેલ પર નવો $1$-સેલ બ્લોકર સ્પોન કરે છે જ્યાં સુધી તેનો HP 0 ન થાય.
     - **Heart-Seed Guardian (M804):** કેન્દ્રીય હાર્ટ-સીડ; તેનો HP માત્ર એવી લિંક્ડ લાઈનોથી જ ઘટે છે જેનો એક્ઝિટ પાથ બરાબર તેના કેન્દ્રીય સેલમાંથી પસાર થાય.
2. **Tall Blocker Presence:**
   - તમામ ગાર્ડિયન્સ `tall: true` ધરાવે છે એટલે કે તેઓ ગ્રાઉન્ડ કીડીઓ અને આકાશમાં ઉડતી મધમાખીઓ બંનેને બ્લોક કરે છે.
3. **4 New Base Mechanics (M801–M804):**
   - Twin Hornets (M801), Armored Rhino Beetle (M802), Wasp Nest Guardian (M803), Heart-Seed Guardian (M804).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 17`: Phase 17 content unlock કરવા માટે.
- `p17_guardian_defeat_ms = 300`: Boss death animation duration.

