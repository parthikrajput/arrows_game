# 01 — Phase 11 Scope & Rule Changes (ફેઝ 11 નિયમો)
> Levels 5001–5500 માટે Linked Boards (Twin Gardens) ના નિયમો, ક્રોસ-બોર્ડ લિંક્સ, પેન-પાલ કી, મિરર બોર્ડ્સ અને Phase 11 limits.

**Related docs:** [Phase 11 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 11 (નવું શું છે)
1. **Linked Boards (Twin Gardens):**
   - પઝલમાં એકની જગ્યાએ બે જોડાયેલા ગાર્ડન બોર્ડ્સ (Board A અને Board B) હોય છે:
     - **Garden Gate Link (M501):** બોર્ડ A ની લિંક્ડ કિનારીમાંથી બહાર નીકળતી લાઈન સીધી જ બોર્ડ B ના અનુરૂપ એજ સેલ પર તે જ દિશામાં પ્રવેશે છે.
     - **Pen-Pal Key (M502):** બોર્ડ A પર રહેલી કી-લાઈન જ્યારે બોર્ડ A માંથી એક્ઝિટ થાય છે, ત્યારે તે બોર્ડ B પર રહેલા કાંટાળા લૉકને અનલૉક કરે છે.
     - **Reflecting Pond Board (M503):** બોર્ડ A પરની લાઈન ટેપ કરતાં બોર્ડ B પર રહેલી તેની મિરર ટ્વિન લાઈન પણ સમાન રીતે ગતિ કરે છે (કોઈપણ એક અથડાય $\implies -1$ Heart).
     - **Relay Burrow (M504):** બોર્ડ A અને બોર્ડ B વચ્ચે સીધો કીડીઓનો અંડરગ્રાઉન્ડ ટનલ પોર્ટલ.
2. **Dual-Board Viewport Management:**
   - પ્લેયર બંને બોર્ડ વચ્ચે સ્વાઇપ કરીને અથવા ટોચ પર આપેલા "Garden A" / "Garden B" ટેબ્સ દ્વારા કેમેરા સ્વિચ કરી શકે છે, અથવા ઝૂમ-આઉટ કરીને બંને બોર્ડ એકસાથે જોઈ શકે છે.
3. **4 New Base Mechanics (M501–M504):**
   - Garden Gate Link (M501), Pen-Pal Key (M502), Reflecting Pond Board (M503), Relay Burrow (M504).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (2 boards, zoom/pan સપોર્ટ).
- **Line Count:** 28 થી 40 lines across both boards and layers.
- **Obstacle Count:** 8 થી 14 instances across boards.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 11`: Phase 11 content unlock કરવા માટે.
- `p11_board_pan_ms = 250`: Board transition animation duration.

