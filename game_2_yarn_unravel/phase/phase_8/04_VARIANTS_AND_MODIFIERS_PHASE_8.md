# 04 — Variants & Modifiers: Phase 8
> Phase 8 ના 45 variant slots, ઓર્ગેનિક ગ્રોથ craft modifiers ના નિયમો અને M351–M354 સાથેના combinations.

**Related docs:** [Phase 8 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Organic Growth Craft Modifiers
Phase 8 ના 10 craft modifiers ગ્રોથ મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | ઓર્ગેનિક ગ્રોથ નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | આઇવી રૂટ લૉક છે; K દોરા બહાર નીકળે પછી જ સ્પ્રેડિંગ શરૂ થાય છે. |
| 2 | `Colored(c)` | **Dyed** | બ્લોસમ ગેટ માત્ર c કલરના દોરાઓ દ્વારા ક્લિયર થયેલા પડોશથી જ ખુલે છે. |
| 3 | `Fluffed` | **Fluffed** | સ્નિપ ટાઇલ કે સીડ બીડ વૂલ ફ્લફ નીચે છુપાયેલું છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે આઇવી રૂટ્સ જોડાયેલા છે; બંને એકસાથે સમાંતર દિશામાં ફેલાય છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી આઇવી આપોઆપ સુકાઈને ખરી પડે છે. |
| 6 | `Phasing` | **Sheer Silk** | આઇવી વેલાઓ ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Thimble-Reinforced** | આઇવી સેલ ક્લિયર કરવા માટે 2 સ્નિપ્સની જરૂર પડે છે. |
| 8 | `Layered` | **Multi-Layer** | આઇવી વેલાઓ કાપડના ચોક્કસ લેયર પર જ ફેલાય છે અને અન્ય લેયરને નડતા નથી. |
| 9 | `Reflected` | **Reflected** | અડધા બોર્ડ પર આઇવી ફેલાતાં મિરર અક્ષ પર જોડિયા વેલાઓ પ્રતિબિંબિત થાય છે. |
| 10 | `Growing` | **Knit-Expanding** | સ્પ્રાઉટ થયેલા નવા સેલ્સ પોતે સેકન્ડરી રૂટ્સ તરીકે ઝડપી શાખાઓ પાડે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L3521–3630):** M351 Ivy Yarn Variants (Knotted Roots, Basting Vines, Ribbon-Tied Double Spreaders, વગેરે).
- **Blocks 15–25 (L3641–3750):** M352 Snip Tile Variants (Fluffed Shears, Multi-Radius Snips, Armored Pruners, વગેરે).
- **Blocks 27–37 (L3761–3870):** M353 Seed Bead Thread Variants (Chained Seeds, Fast Sprouting Beads, Dyed Seeds, વગેરે).
- **Blocks 39–49 (L3881–3990):** M354 Blossom Gate Variants અને Full Blooming Garden Mix (M351 + M352 + M354 સંયોજનો).

---

## 3. Solver Invariants
- ગ્રોથ સ્પ્રાઉટિંગ ક્યારેય એવો ડેડ-એન્ડ ન બનાવી શકે કે જેથી બોર્ડ અનસોલ્વેબલ બને; CI જનરેટર ખાતરી કરે છે કે સ્નિપ ટાઇલ્સ અને પુલ ઓર્ડર યોગ્ય વિન્ડો પૂરી પાડે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે સોલ્વેબલ છે.

