# 04 — Variants & Modifiers: Phase 4
> Phase 4 ના 45 variant slots, મલ્ટી-ફ્લોર craft modifiers ના નિયમો અને M151–M154 સાથેના combinations.

**Related docs:** [Phase 4 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Multi-Floor Modifiers
Phase 4 ના 10 craft modifiers મલ્ટી-ફ્લોર પરિમાણમાં વિસ્તરે છે:

| # | Modifier | Yarn Flavour Name | વર્ટિકલ નિયમ અને વર્તણૂક |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | સીડી અથવા લિફ્ટ જ્યાં સુધી લક્ષ્ય ફ્લોરના K દોરા બહાર ન નીકળે ત્યાં સુધી અનલૉક થતી નથી. |
| 2 | `Colored(c)` | **Dyed** | સીડી કે ડ્રોપ હોલ માત્ર c કલરના દોરાને જ વર્ટિકલ ટ્રાન્સફર કરે છે; અન્ય કલર સ્નેગ થાય છે. |
| 3 | `Fogged` | **Fluffed** | અન્ય ફ્લોર પરનું એક્ઝિટ સેલ વૂલ ફ્લફ નીચે ઢંકાયેલું રહે છે. |
| 4 | `Chained` | **Ribbon-Tied** | Floor 1 નો દોરો અને Floor 2 નો દોરો રિબનથી જોડાયેલા; બંને એકસાથે ક્લિયર થવા જોઈએ. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી સીડી તૂટી જાય છે અથવા ડ્રોપ હોલ સીવાઈને બંધ થાય છે. |
| 6 | `Phasing` | **Sheer Silk** | ઓર્ગેન્ઝા ગ્લાસ સેલ ઓડ/ઇવન મૂવ્સ પર પારદર્શક/અપારદર્શક બને છે. |
| 7 | `Armored` | **Thimble-Reinforced** | બોબિન લિફ્ટ 2 વાર વાપરવા માટે 2 થિમ્બલ ચાર્જ લે છે. |
| 8 | `Layered` | **Multi-Layer** | દરેક ફ્લોર પર પણ 3 સબ-લેયર્સ (Ground/Canopy/Treetop) નું અસ્તિત્વ. |
| 9 | `Reflected` | **Reflected** | Floor 1 પરનો દોરો Floor 2 ના જોડિયા દોરા સાથે મિરર ગતિ કરે છે. |
| 10 | `Growing` | **Knit-Expanding** | વધતો દોરો ડ્રોપ હોલમાંથી નીચેના ફ્લોર પર વિસ્તરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L1521–1630):** M151 Spiral Spool Stair Variants (Knotted Stairs, Dyed Stairs, Ribbon-Tied Cross-Floor Stairs, Basting Stairs, વગેરે).
- **Blocks 15–25 (L1641–1750):** M152 Organza Floor Variants (Dyed Organza, Fluffed Under-Layer, Armored Organza, Phasing Silk Floor, વગેરે).
- **Blocks 27–37 (L1761–1870):** M153 Drop Hole Variants (Knotted Drop Holes, Dyed Funnel Holes, Cross-Floor Ribbon Pairs, વગેરે).
- **Blocks 39–49 (L1881–1990):** M154 Bobbin Lift Variants અને Multi-Floor કૉમ્બો સ્લોટ્સ (M151 + M153 + M154 નું મિશ્રણ).

---

## 3. Solver Invariants
- વર્ટિકલ લૂપ્સ (Stairs થી F2 અને Drop Hole થી ફરી F1) સોલ્વરમાં ઇન્ફિનિટ લૂપ ન બનાવે તે માટે `tools/levelgen` સાયકલ ડિટેક્શન અલ્ગોરિધમ લાગુ કરે છે.
- દરેક લેવલ 0 hearts lost અને 0 boosters સાથે પૂર્ણ સોલ્વેબલ હોવું ફરજિયાત છે.

