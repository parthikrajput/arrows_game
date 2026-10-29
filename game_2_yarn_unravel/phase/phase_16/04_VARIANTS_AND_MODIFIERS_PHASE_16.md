# 04 — Variants & Modifiers: Phase 16
> Phase 16 ના 45 variant slots, Keys Deluxe craft modifiers ના નિયમો અને M751–M754 સાથેના combinations.

**Related docs:** [Phase 16 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_7501_8000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Keys Deluxe Craft Modifiers
Phase 16 ના 10 craft modifiers કી મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Keys Deluxe નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | સ્કેલેટન ચાર્મ લૉક છે; K દોરા બહાર નીકળે પછી જ સોય મુક્ત થાય છે. |
| 2 | `Colored(c)` | **Dyed** | ચાર્મ ક્રાફ્ટિંગ માત્ર c રંગના ચોક્કસ તંતુઓ જોડાઈને જ કી બનાવે છે. |
| 3 | `Fluffed` | **Fluffed** | હાફ-ચાર્મ કે સ્વેપ હૂપ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે અલગ ચાર્મ ચેઇન્સ એકસાથે જોડાયેલી છે અને સમાંતર આગળ વધે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી સ્કેલેટન ચાર્મ ઓગળીને સામાન્ય દોરો બની જાય છે. |
| 6 | `Phasing` | **Sheer Silk** | સ્વેપ હૂપ ઓડ મૂવ્સ પર સક્રિય અને ઇવન મૂવ્સ પર નિષ્ક્રિય રહે છે. |
| 7 | `Armored` | **Brass-Plated** | સ્કેલેટન ચાર્મ હેમરેબલ નથી; માત્ર નિર્ધારિત એક્ઝિટથી જ વપરાય છે. |
| 8 | `Layered` | **Tulle** | ચાર્મ સ્વેપિંગ માત્ર કાપડના ચોક્કસ લેયરના દોરાઓ વચ્ચે જ થાય છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુ ચાર્મ કલેક્ટ થતાં જમણી બાજુનો સમપ્રમાણ ક્લેસ્પ પણ પ્રભાવિત થાય છે. |
| 10 | `Growing` | **Chain-Expanding** | જો લાંબા સમય સુધી ચાર્મ ન લેવાય, તો ચેઇનની લંબાઈમાં 1 વધારાની લિંક ઉમેરાય છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L7521–7630):** M751 Charm Chain Variants (Knotted Chains, Phasing Chains, Chained Multi-Links, વગેરે).
- **Blocks 15–25 (L7641–7750):** M752 Charm Crafting Variants (Fluffed Halves, Dyed Synthesis, Basting Halves, વગેરે).
- **Blocks 27–37 (L7761–7870):** M753 Skeleton Charm Variants (Brass-Plated Skeletons, Tulle Master Keys, વગેરે).
- **Blocks 39–49 (L7871–7990):** M754 Charm Swap Hoop Variants અને Master Locksmith Networks (M751 + M752 + M754 સંયોજનો).

---

## 3. Solver Invariants
- તમામ કી ચેઇન્સ અને ક્રાફ્ટિંગ પેર માટે હંમેશાં ઓછામાં ઓછો એક એવો ક્રમ હોય છે કે જ્યાં કોઈ દોરો બીજા અનરિલીઝ્ડ દોરા પાછળ બ્લોક ન થાય.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

