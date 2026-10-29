# 04 — Variants & Modifiers: Phase 6
> Phase 6 ના 45 variant slots, ઓપ્ટિકલ craft modifiers ના નિયમો અને M251–M254 સાથેના combinations.

**Related docs:** [Phase 6 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Optical Craft Modifiers
Phase 6 ના 10 craft modifiers ઓપ્ટિકલ અને બીમ મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | ઓપ્ટિકલ નિયમ અને વર્તણૂક |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | ટિન્ટેડ ગ્લાસ કે પ્રિઝમ દોરાથી લૉક છે; K દોરા નીકળે પછી જ કિરણો પસાર થાય છે. |
| 2 | `Colored(c)` | **Dyed** | પ્રિઝમ ક્લેસ્પ માત્ર c કલરના ફિલ્ટર થયેલા કિરણથી જ અનલૉક થાય છે. |
| 3 | `Fogged` | **Fluffed** | લેમ્પ કે શેડો પોકેટ વૂલ ફ્લફ નીચે છુપાયેલું છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે લેમ્પ્સ જોડાયેલા છે; એક ઑન/ઑફ થતાં બીજો પણ સમાંતર ટૉગલ થાય છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી ટિન્ટેડ ગ્લાસ તૂટીને ઓપ્ટિકલ પાથ સાફ કરે છે. |
| 6 | `Phasing` | **Sheer Silk** | ઓડ/ઇવન મૂવ્સ પર ટિન્ટેડ ગ્લાસ અદૃશ્ય/પ્રગટ થાય છે. |
| 7 | `Armored` | **Thimble-Reinforced** | કાચ તોડવા માટે 2 ગોલ્ડન સિઝર્સ સ્નિપ્સની જરૂર પડે છે. |
| 8 | `Layered` | **Multi-Layer** | કિરણો માત્ર તેમના પોતાના ફેબ્રિક લેયર પરના ઓબ્જેક્ટ્સને જ પ્રકાશિત કરે છે. |
| 9 | `Reflected` | **Reflected** | પ્રિઝમ ક્લેસ્પ મિરર અક્ષ પર વિરુદ્ધ દિશામાં કિરણ રીફ્લેક્ટ કરે છે. |
| 10 | `Growing` | **Knit-Expanding** | વધતો દોરો કિરણના માર્ગને બ્લોક કરીને શેડો પોકેટને ફરી અંધારું બનાવે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L2521–2630):** M251 Tinted Glass Variants (Knotted Filters, Basting Glass, Dyed Prisms, વગેરે).
- **Blocks 15–25 (L2641–2750):** M252 Prism Clasp Variants (Dyed Clasps, Fluffed Prisms, Armored Clasps, વગેરે).
- **Blocks 27–37 (L2761–2870):** M253 Hourglass Lamp Variants (Chained Lamps, Timed Prisms, Phasing Emitters, વગેરે).
- **Blocks 39–49 (L2881–2990):** M254 Shadow Pocket Variants અને Full Atelier Optical Mix (M251 + M252 + M254 સંયોજનો).

---

## 3. Solver Invariants
- કિરણોના અનંત રિફ્લેક્શન લૂપ્સ (M014 Hook Deflectors સાથે) ન સર્જાય તે માટે engine મહત્તમ 16 રે-બાઉન્સ પર કિરણને ટર્મિનેટ કરે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે સોલ્વેબલ છે.

