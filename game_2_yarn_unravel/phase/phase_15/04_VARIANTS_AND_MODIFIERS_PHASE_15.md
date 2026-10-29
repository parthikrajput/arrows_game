# 04 — Variants & Modifiers: Phase 15
> Phase 15 ના 45 variant slots, Conveyors & Tracks craft modifiers ના નિયમો અને M701–M704 સાથેના combinations.

**Related docs:** [Phase 15 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_7001_7500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Conveyor Craft Modifiers
Phase 15 ના 10 craft modifiers કન્વેયર મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Conveyor નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | બેલ્ટ સ્વિચ લૉક છે; K દોરા બહાર નીકળે પછી જ શાખા બદલી શકાય છે. |
| 2 | `Colored(c)` | **Dyed** | કન્વેયર બેલ્ટ માત્ર c કલરના દોરાઓને જ આગળ ધકેલે છે. |
| 3 | `Fluffed` | **Fluffed** | ટ્રેક લૂપનો એક્ઝિટ પોઇન્ટ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે અલગ અલગ બેલ્ટ્સ એકસાથે જોડાયેલા છે અને સમાન ગતિ કરે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી કન્વેયર બેલ્ટ સામાન્ય સ્થિર લિનન બની જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | બેલ્ટ ઓડ મૂવ્સ પર સોલિડ સ્પીડમાં ચાલે છે અને ઇવન મૂવ્સ પર અટકી જાય છે. |
| 7 | `Armored` | **Brass-Plated** | બેલ્ટ લીવર વધુ મજબૂત છે અને કોઈ બૂસ્ટર વડે બાયપાસ થતું નથી. |
| 8 | `Layered` | **Tulle** | કન્વેયર મોશન માત્ર કાપડના ચોક્કસ લેયરના દોરાઓને જ લાગુ પડે છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુનો બેલ્ટ ક્લોકવાઇઝ ફરે ત્યારે જમણી બાજુનો બેલ્ટ કાઉન્ટર-ક્લોકવાઇઝ ફરે છે. |
| 10 | `Growing` | **Belt-Expanding** | દર 10 મૂવ્સ પછી કન્વેયર બેલ્ટ પોતાની લંબાઈમાં 1 સેલનો ઉમેરો કરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L7021–7130):** M701 Belt Switch Variants (Knotted Switches, Dyed Conveyors, Phasing Junctions, વગેરે).
- **Blocks 15–25 (L7141–7250):** M702 Reversing Belt Variants (Fluffed Reversers, Chained Belts, Basting Reversers, વગેરે).
- **Blocks 27–37 (L7261–7370):** M703 Belt Lever Variants (Brass-Plated Levers, Mirrored Clutches, વગેરે).
- **Blocks 39–49 (L7381–7490):** M704 Track Loop Variants અને High-Speed Mechanized Conveyors (M701 + M702 + M704 સંયોજનો).

---

## 3. Solver Invariants
- કન્વેયર બેલ્ટ અને ટ્રેક લૂપના સતત પરિભ્રમણથી કોઈ દોરો કાયમી અપ્રાપ્ય (unreachable) અવસ્થામાં ફસાઈ ન જાય તેની ખાતરી CI સોલ્વર કરે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

