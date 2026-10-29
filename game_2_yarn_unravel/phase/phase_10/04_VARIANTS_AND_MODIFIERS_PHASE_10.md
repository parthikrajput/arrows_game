# 04 — Variants & Modifiers: Phase 10
> Phase 10 ના 45 variant slots, Sequencing craft modifiers ના નિયમો અને M451–M454 સાથેના combinations.

**Related docs:** [Phase 10 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_4501_5000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Sequencing Craft Modifiers
Phase 10 ના 10 craft modifiers સિક્વન્સિંગ મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | Sequencing નિયમ |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | મેટ્રોનોમ ગેટ લૉક છે; K દોરા બહાર નીકળે પછી જ રિધમિક ટિક શરૂ થાય છે. |
| 2 | `Colored(c)` | **Dyed** | ઓર્ડર્ડ હેમ માત્ર c કલરના દોરાઓ માટે જ સિક્વન્સ ચેક કરે છે. |
| 3 | `Fluffed` | **Fluffed** | પેટર્ન ક્લેસ્પની આગામી કલર રિક્વાયરમેન્ટ વૂલ ફ્લફ નીચે છુપાયેલી છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે મેટ્રોનોમ ગેટ્સ જોડાયેલા છે; બંને એકસાથે વિરુદ્ધ ફેઝમાં ઓપન/ક્લોઝ થાય છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી ઓર્ડર્ડ હેમની શરત હળવી થઈને સામાન્ય ઓપન એજ બને છે. |
| 6 | `Phasing` | **Sheer Silk** | પેટર્ન ક્લેસ્પ ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ફેન્ટમ બને છે. |
| 7 | `Armored` | **Brass-Plated** | ક્લેસ્પ વધુ મજબૂત છે અને કોઈ બૂસ્ટર તેની સિક્વન્સ બાયપાસ કરી શકતું નથી. |
| 8 | `Layered` | **Tulle** | રિધમ ગેટ્સ માત્ર કાપડના ચોક્કસ લેયરના દોરાઓ માટે જ અવરોધ બને છે. |
| 9 | `Mirrored` | **Mirror-Stitched** | ડાબી બાજુની કલર સિક્વન્સ જમણી બાજુ ઊંધી (reverse) ક્રમમાં રિપીટ થાય છે. |
| 10 | `Growing` | **Step-Expanding** | એકો કાર્ડની વિન્ડો સાઈઝ દર 10 મૂવ્સ પછી 1 સ્ટેપ વધે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L4521–4630):** M451 Metronome Gate Variants (Knotted Metronome, Phasing Beats, Ribbon-Tied Inverted Gates, વગેરે).
- **Blocks 15–25 (L4641–4750):** M452 Pattern Clasp Variants (Fluffed Sequence, Mirrored Pattern Locks, Dyed Clasps, વગેરે).
- **Blocks 27–37 (L4761–4870):** M453 Ordered Hem Variants (Basting Hems, Armored Boundaries, Multi-Tier Hems, વગેરે).
- **Blocks 39–49 (L4881–4990):** M454 Echo Card Variants અને Complex Orchestrated Sequences (M451 + M452 + M454 સંયોજનો).

---

## 3. Solver Invariants
- તમામ સિક્વન્સિંગ પઝલ્સમાં પ્લેયર માટે હંમેશાં ઓછામાં ઓછો એક કાયદેસર અને બ્લોક વગરનો ક્રમ ઉપલબ્ધ હોય છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે 100% સોલ્વેબલ છે.

