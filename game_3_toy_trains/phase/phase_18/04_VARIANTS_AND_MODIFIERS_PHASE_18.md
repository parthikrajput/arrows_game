# 04 · Variants & Modifiers Phase 18 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 18 ના 45 variant slots, Remix A આધારિત Combo Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_8501_9000.md)

---

## 1. 10 Standard Modifiers Compatibility & Remix Stacking
> [!NOTE]
> SCALING §8.2 મુજબ, Remix Phases (18–20) માં જરૂર પડ્યે **મહત્તમ 2 મોડિફાયર્સ (Stacking)** એક સાથે એક જ ઇન્સ્ટન્સ પર લાગુ થઈ શકે છે (દા.ત. `Frozen + Colored` અથવા `Countdown + Armored`).

| Modifier | Remix A Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી લિફ્ટ લોક થાય છે અથવા કાર્ટ કાયમી પથ્થર બને છે. | M851, M852, M853, M854 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ પ્રિઝમ સેન્સર કે ચ્યુટ કાર્યરત બને છે. | M851, M852, M853, M854 |
| `Colored` | ચોક્કસ રંગની ટ્રેન જ કાર્ટ પુશ કરી શકે છે કે લિફ્ટ ઓપરેટ કરી શકે છે. | M851, M852, M853, M854 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલી ટિકિટ કાર્ટ કે પ્રિઝમ સેન્સર. | All M85x |
| `Chained` | બે લિફ્ટ્સ અથવા બે પ્રિઝમ સેન્સર્સ એકબીજા સાથે લિન્ક રહે છે. | M851, M852, M853 |
| `Phasing` | માત્ર Even moves પર જ ચ્યુટ કે કાર્ટ પાટા પર ભૌતિક રૂપે હાજર રહે છે. | M851, M852, M853, M854 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી લિફ્ટ મિકેનિઝમ કે સેન્સરને નુકસાન કરી શકાતું નથી. | M851, M852, M853, M854 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ ફ્યુઝન મિકેનિક્સ. | M851, M852, M853, M854 |
| `Mirrored` | પ્રતિબિંબિત અક્ષ પર ઉલટા સ્થાનો ધરાવતા સેન્સર્સ અને કાર્ટ્સ. | M851, M852, M853, M854 |
| `Growing` | મિકેનિઝમની આસપાસ સમય જતાં વેલ અને પથ્થરો વિસ્તરે છે. | M851, M852, M853, M854 |

---

## 2. 45 Variant Slots Definition
1. `M851~CNT5`: Last Call Ticket Cart (5 moves સુધી જ ચાલતી ટિકિટ કાર્ટ).
2. `M851~FRZ2`: Snowbound Ticket Cart (થીજેલી ટિકિટ કાર્ટ).
3. `M851~COL`: Painted Ticket Cart (ચોક્કસ રંગની કાર્ટ).
4. `M851~FOG`: Steamy Ticket Cart (ધુમ્મસમાં ટિકિટ કાર્ટ).
5. `M851~CHN`: Linked Ticket Carts (જોડાયેલી જોડિયા કાર્ટ્સ).
6. `M851~PHS`: Phantom Ticket Cart (ફેઝિંગ ટિકિટ કાર્ટ).
7. `M851~ARM`: Iron-clad Ticket Cart (આર્મ્ડ ટિકિટ કાર્ટ).
8. `M851~LAY`: Deck Ticket Cart (ડેક લેવલ પરની ટિકિટ કાર્ટ).
9. `M851~MIR`: Looking-glass Ticket Cart (પ્રતિબિંબિત ટિકિટ કાર્ટ).
10. `M851~GRW`: Sprouting Ticket Cart (વેલવાળી ટિકિટ કાર્ટ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M852~CNT5`: Last Call Shunting Lift (5 moves પછી બંધ થતી લિફ્ટ).
13. `M852~FRZ2`: Snowbound Shunting Lift (થીજેલી માલવાહક લિફ્ટ).
14. `M852~COL`: Painted Shunting Lift (ચોક્કસ રંગીન લિફ્ટ).
15. `M852~FOG`: Steamy Shunting Lift (ધુમ્મસમાં લિફ્ટ).
16. `M852~CHN`: Linked Shunting Lifts (બે સંયુક્ત લિફ્ટ્સ).
17. `M852~PHS`: Phantom Shunting Lift (ફેઝિંગ લિફ્ટ).
18. `M852~ARM`: Iron-clad Shunting Lift (આર્મ્ડ લિફ્ટ).
19. `M852~LAY`: Deck Floor Lift (ડેક લેયર પરની લિફ્ટ).
20. `M852~MIR`: Looking-glass Shunting Lift (મિરર લિફ્ટ).
21. `M852~GRW`: Sprouting Floor Lift (વેલવાળી લિફ્ટ).
22. `M013~FRZ2`: Snowbound Rotary Junction (થીજેલું ટર્નટેબલ).
23. `M853~CNT5`: Last Call Prism Sensor (5 moves સુધી જ ચાલતો સેન્સર).
24. `M853~FRZ2`: Snowbound Prism Sensor (થીજેલો પ્રિઝમ સેન્સર).
25. `M853~COL`: Painted Prism Sensor (ચોક્કસ રંગીન સેન્સર).
26. `M853~FOG`: Steamy Prism Sensor (ધુમ્મસમાં પ્રિઝમ સેન્સર).
27. `M853~CHN`: Linked Prism Sensors (બે લિન્ક્ડ પ્રિઝમ સેન્સર્સ).
28. `M853~PHS`: Phantom Prism Sensor (ફેઝિંગ પ્રિઝમ સેન્સર).
29. `M853~ARM`: Iron-clad Prism Sensor (આર્મ્ડ પ્રિઝમ સેન્સર).
30. `M853~LAY`: Deck Prism Sensor (ડેક લેવલ પરનો પ્રિઝમ સેન્સર).
31. `M853~MIR`: Looking-glass Prism Sensor (મિરર પ્રિઝમ સેન્સર).
32. `M853~GRW`: Sprouting Prism Sensor (વેલવાળો પ્રિઝમ સેન્સર).
33. `M018~FOG`: Steamy Branch Switch (ધુમ્મસિયું સ્વિચ).
34. `M854~CNT5`: Last Call Ice Chute (5 moves પછી બ્લોક થતી ચ્યુટ).
35. `M854~FRZ2`: Snowbound Ice Chute (થીજેલી આઇસ ચ્યુટ).
36. `M854~COL`: Painted Ice Chute (ચોક્કસ રંગની ચ્યુટ).
37. `M854~FOG`: Steamy Ice Chute (ધુમ્મસમાં આઇસ ચ્યુટ).
38. `M854~CHN`: Linked Ice Chutes (જોડાયેલી જોડિયા ચ્યુટ્સ).
39. `M854~PHS`: Phantom Ice Chute (ફેઝિંગ આઇસ ચ્યુટ).
40. `M854~ARM`: Iron-clad Ice Chute (આર્મ્ડ આઇસ ચ્યુટ).
41. `M854~MIR`: Looking-glass Ice Chute (મિરર આઇસ ચ્યુટ).
42. `M854~LAY`: Deck Ice Chute (ડેક લેયર પરની ચ્યુટ).
43. `M854~GRW`: Sprouting Ice Chute (વેલવાળી ચ્યુટ).
44. `M045~CHN`: Linked Master Gear Chute (લિંક્ડ ગિયર ચ્યુટ કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).

