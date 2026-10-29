# 04 — Variants & Modifiers: Phase 19
> Phase 19 ના 45 variant slots, Remix B craft modifiers ના નિયમો અને M901–M904 સાથેના combinations.

**Related docs:** [Phase 19 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_9001_9500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Remix B Craft Modifiers
Phase 19 ના 10 craft modifiers કોમ્બો મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Remix B નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | ટ્વિર્લ વેઇટેડ દોરો લૉક છે; K અન્ય દોરાઓ નીકળે પછી જ રોટેશન/ફોલ શરૂ થાય છે. |
| 2 | `Colored(c)` | **Dyed** | રિધમ બેલ્ટ માત્ર c કલરના દોરાઓને જ બીટ પર આગળ ધકેલે છે. |
| 3 | `Fluffed` | **Fluffed** | સીમ એજ સ્પ્લિટ પોઇન્ટ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે હૂપ રોટર્સ જોડાયેલા છે; એક ફરતાં બીજો પણ સમાંતર 90° ફરે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી આઇવી રૂટ સુકાઈ જાય છે અને રોટર સામાન્ય બને છે. |
| 6 | `Phasing` | **Sheer Silk** | રિધમ બેલ્ટ ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | ટ્વિર્લ દોરો હેમર પ્રૂફ છે અને માત્ર સામાન્ય અનરૅવલથી જ બહાર કાઢી શકાય છે. |
| 8 | `Layered` | **Tulle** | ક્રોસ-બોર્ડ સ્પ્લિટ માત્ર ચોક્કસ ફેબ્રિક લેયર પર જ સક્રિય રહે છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુ રોટર CW ફરે ત્યારે જમણી બાજુ મિરર રોટર CCW ફરે છે. |
| 10 | `Growing` | **Ivy-Expanding** | રોટેટ થયેલા રૂટ્સ દર 4 મૂવ્સે વધુ ઝડપી સ્પ્રાઉટ કરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L9021–9130):** M901 Twirl Weighted Variants (Knotted Twirls, Phasing Spools, Mirrored Falls, વગેરે).
- **Blocks 15–25 (L9141–9250):** M902 Ivy Hoop Rotor Variants (Fluffed Rotors, Basting Vines, Chained Rotors, વગેરે).
- **Blocks 27–37 (L9261–9370):** M903 Rhythm Belt Variants (Dyed Rhythm Belts, Brass-Plated Tracks, Sheer Beats, વગેરે).
- **Blocks 39–49 (L9371–9490):** M904 Seam Edge Split Variants અને Full Kinematic Tapestry Orchestrations (M901 + M902 + M904 સંયોજનો).

---

## 3. Solver Invariants
- રોટેશન, ગ્રોથ અને સ્પ્લિટિંગના મિશ્રણથી સાયકલ લૂપ્સ ન બને તેની ચકાસણી CI ડેડલોક વેરિફાયર કરે છે; સોલ્વર નોડ્સ $\le 1.5\text{M}$.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.
