# 04 — Variants & Modifiers: Phase 14
> Phase 14 ના 45 variant slots, Mirror Worlds craft modifiers ના નિયમો અને M651–M654 સાથેના combinations.

**Related docs:** [Phase 14 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_6501_7000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Mirror Worlds Craft Modifiers
Phase 14 ના 10 craft modifiers મિરર મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Mirror Worlds નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | મિરર સીમ લૉક છે; K દોરા બહાર નીકળે પછી જ ટ્વીન સિંક્રનાઇઝેશન સક્ષમ થાય છે. |
| 2 | `Colored(c)` | **Dyed** | રિફ્લેક્ટ ક્લેસ્પ માત્ર c કલરની કી વડે જ જોડીમાં ખુલે છે. |
| 3 | `Fluffed` | **Fluffed** | ઇન્વર્સ દોરો કે રિફ્લેક્ટ ક્લેસ્પ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે જોડી ટ્વીન દોરાઓ જોડાયેલા છે; 4 દોરાઓ એકસાથે સમાંતર બહાર નીકળે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી મિરર સીમ વિસર્જિત થાય છે અને દોરાઓ સ્વતંત્ર બની જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | ઇન્વર્સ દોરો ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | રિફ્લેક્ટ ક્લેસ્પ વધુ સુરક્ષિત છે અને હેમર પ્રૂફ છે. |
| 8 | `Layered` | **Tulle** | મિરર રિફ્લેક્શન માત્ર ફેબ્રિકના ચોક્કસ લેયર પૂરતું જ મર્યાદિત રહે છે. |
| 9 | `Mirrored` | **Double-Reflected** | અક્ષના બંને છેડે ડબલ મિરરિંગ (4-વે ક્વાડ્રન્ટ સિમેટ્રી) સર્જાય છે. |
| 10 | `Growing` | **Echo-Expanding** | ઇન્વર્સ દોરો દરેક મૂવ પછી પોતાની લંબાઈમાં 1 ગાંઠ ઉમેરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L6521–6630):** M651 Mirror Seam Variants (Knotted Twins, Basting Seams, Tulle Mirrors, વગેરે).
- **Blocks 15–25 (L6641–6750):** M652 Reflect Clasp Variants (Dyed Reflectors, Brass-Plated Clasps, Fluffed Reflectors, વગેરે).
- **Blocks 27–37 (L6761–6870):** M653 Twin Quilt Variants (Chained Toggles, Phasing Quilts, Double-Reflected Boards, વગેરે).
- **Blocks 39–49 (L6881–6990):** M654 Inverse Thread Variants અને Full Looking-Glass Symmetry Mix (M651 + M652 + M654 સંયોજનો).

---

## 3. Solver Invariants
- ટ્વીન દોરાઓ અને ઇન્વર્સ પાથ્સ વચ્ચે ક્યારેય અનિવાર્ય મ્યુચ્યુઅલ હેડલોક ન સર્જાય તેની ખાતરી CI સોલ્વર દ્વારા થાય છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

