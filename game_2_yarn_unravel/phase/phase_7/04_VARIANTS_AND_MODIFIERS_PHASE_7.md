# 04 — Variants & Modifiers: Phase 7
> Phase 7 ના 45 variant slots, રોટેશનલ craft modifiers ના નિયમો અને M301–M304 સાથેના combinations.

**Related docs:** [Phase 7 index](./README.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md) · [Scaling §8](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Rotational Craft Modifiers
Phase 7 ના 10 craft modifiers રોટેશનલ મિકેનિક્સ પર નીચે મુજબ લાગુ પડે છે:

| # | Modifier | Yarn Flavour Name | રોટેશનલ નિયમ અને વર્તણૂક |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | હૂપ રોટર લૉક છે; K પડોશી દોરા નીકળે પછી જ રોટેશન શરૂ થાય છે. |
| 2 | `Colored(c)` | **Dyed** | ટર્નિંગ હેમ ગેપ માત્ર c કલરના દોરાને જ પસાર થવા દે છે. |
| 3 | `Fluffed` | **Fluffed** | રોટરનો અડધો ભાગ વૂલ ફ્લફ નીચે છુપાયેલો છે. |
| 4 | `Chained` | **Ribbon-Tied** | બે રોટર્સ જોડાયેલા છે; એક ટેપ કરતાં બંને સમાંતર 90° CW ફરે છે. |
| 5 | `Countdown(N)` | **Basting** | N મૂવ્સ પછી રોટર કાયમી જામ થઈ જાય છે અથવા ટ્વિર્લ દોરો સ્થિર થાય છે. |
| 6 | `Phasing` | **Sheer Silk** | ટ્વિર્લ દોરો ઓડ મૂવ્સ પર સોલિડ અને ઇવન મૂવ્સ પર ઘોસ્ટ રહે છે. |
| 7 | `Armored` | **Thimble-Reinforced** | રૅચેટ પિન ખોલવા માટે 2 કી-દોરાઓ ક્લિયર થવા જરૂરી છે. |
| 8 | `Layered` | **Multi-Layer** | રોટેશન માત્ર ઉપલા કાપડના લેયરને જ ફેરવે છે; નીચેનો લેયર સ્થિર રહે છે. |
| 9 | `Reflected` | **Reflected** | એક રોટર CW ફરે ત્યારે તેનો મિરર રોટર CCW (વિરુદ્ધ) ફરે છે. |
| 10 | `Growing` | **Knit-Expanding** | રોટરની અંદર રહેલો ગ્રોઇંગ દોરો રોટેશન સાથે વળાંક લઈને વિસ્તરે છે. |

---

## 2. 45 Variant Slots Overview
- **Blocks 3–13 (L3021–3130):** M301 Hoop Rotor Variants (Knotted Rotors, Fluffed Rotors, Ribbon-Tied Twin Rotors, Basting Rotors, વગેરે).
- **Blocks 15–25 (L3141–3250):** M302 Turning Hem Variants (Dyed Turning Hems, Multi-Gap Hems, Armored Border Hems, વગેરે).
- **Blocks 27–37 (L3261–3370):** M303 Twirl Thread Variants (Chained Twirlers, Phasing Twirl Threads, Knotted Spinners, વગેરે).
- **Blocks 39–49 (L3381–3490):** M304 Ratchet Pin Variants અને Full Turning Table Mix (M301 + M302 + M303 + M304 સંયોજનો).

---

## 3. Solver Invariants
- રોટેશન બાદ કોઈ દોરો પોતાના શરીર સાથે ટેન્ગલ્ડ થઈને અનસોલ્વેબલ સ્થિતિ ન સર્જે તે માટે `tools/levelgen` રોટેશનલ ગ્રાફ સાયકલિંગ વેરિફાય કરે છે.
- તમામ 45 variants 0 hearts lost અને 0 boosters સાથે સોલ્વેબલ છે.

