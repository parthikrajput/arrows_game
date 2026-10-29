# 04 — Variants & Modifiers: Phase 11
> Phase 11 ના 45 variant slots, Twin Hoops craft modifiers ના નિયમો અને M501–M504 સાથેના combinations.

**Related docs:** [Phase 11 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_5001_5500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Linked Boards Craft Modifiers
Phase 11 ના 10 craft modifiers ટ્વીન હૂપ મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Twin Hoops નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | સીમ એજ કે પોમપોમ પોર્ટલ લૉક છે; K દોરા બહાર નીકળે પછી જ ક્રોસ-હૂપ પાથ ખુલે છે. |
| 2 | `Colored(c)` | **Dyed** | સીમ એજ માત્ર c કલરના દોરાઓને જ બીજા હૂપમાં પ્રવેશવા દે છે. |
| 3 | `Fluffed` | **Fluffed** | ક્રોસ ચાર્મ કી વૂલ ફ્લફ નીચે છુપાયેલી છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે ક્રોસ ચાર્મ્સ જોડાયેલા છે; બંને ક્લિયર થતાં બંને હૂપ્સના ગેટ્સ એકસાથે ખુલે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી સીમ એજ બંધ થઈ જાય છે અને કાયમી સિંગલ બ્લોકર બને છે. |
| 6 | `Phasing` | **Sheer Silk** | રિલે પોમપોમ ઓડ મૂવ્સ પર સક્રિય અને ઇવન મૂવ્સ પર નિષ્ક્રિય રહે છે. |
| 7 | `Armored` | **Brass-Plated** | ક્રોસ ચાર્મ હેમરેબલ નથી; માત્ર નિર્ધારિત દોરા દ્વારા જ મેળવી શકાય છે. |
| 8 | `Layered` | **Tulle** | ક્રોસ-હૂપ સીમ માત્ર લેયર 1 ના દોરાઓને ટ્રાન્સફર કરે છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | Hoop A અને Hoop B વચ્ચેના અવરોધો સંપૂર્ણ સમપ્રમાણ મિરર પોઝિશન ધરાવે છે. |
| 10 | `Growing` | **Hoop-Spanning** | રિલે પોમપોમ ટનલ દર 10 મૂવ્સ પછી બંને હૂપ્સમાં 1-1 સેલ આગળ વિસ્તરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L5021–5130):** M501 Seam Edge Variants (Knotted Seams, Dyed Seams, Basting Bridges, વગેરે).
- **Blocks 15–25 (L5141–5250):** M502 Cross Charm Variants (Fluffed Charms, Brass-Plated Keys, Ribbon-Tied Charms, વગેરે).
- **Blocks 27–37 (L5261–5370):** M503 Mirror Hoop Variants (Phasing Twins, Tulle Mirrored Threads, વગેરે).
- **Blocks 39–49 (L5381–5490):** M504 Relay Pompom Variants અને Full Twin Hoops Orchestration (M501 + M502 + M504 સંયોજનો).

---

## 3. Solver Invariants
- બે હૂપ્સ વચ્ચે સાયકલ કે અનંત લૂપ ન બને તેની ખાતરી CI સોલ્વર દ્વારા કરવામાં આવે છે (DAG verification across hoops).
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

