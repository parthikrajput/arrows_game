# 04 · Variants & Modifiers Phase 16 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 16 ના 45 variant slots, Ticket Office Keys Deluxe આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 16 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_7501_8000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Ticket Office Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી ટિકિટ એક્સપાયર થાય છે અથવા બેરિયર આપોઆપ ખુલે છે. | M751, M752, M753, M754 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ પંચ સ્ટેશન કે સ્વેપ પેડ કાર્યરત થાય છે. | M751, M752, M753, M754 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ ટિકિટ પંચ કરી શકે છે કે માસ્ટર પાસ વાપરી શકે છે. | M751, M752, M753, M754 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલી ટિકિટ કાર કે પંચ બૂથ. | All M75x |
| `Chained` | બે ટિકિટ સ્વેપ પેડ્સ અથવા બે પંચ બૂથ એકબીજા સાથે લિન્ક રહે છે. | M751, M752, M754 |
| `Phasing` | માત્ર Even moves પર જ માસ્ટર પાસ કે ટિકિટ બેરિયર હાજર રહે છે. | M751, M752, M753, M754 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી ટિકિટ બેરિયરને તોડી શકાતો નથી. | M751, M752, M753, M754 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ ટિકિટ નેટવર્ક્સ. | M751, M752, M753, M754 |
| `Mirrored` | પ્રતિબિંબિત અક્ષ પર ટિકિટ સ્ટબ્સ વિરુદ્ધ સ્થાનો ધરાવે છે. | M751, M752, M753, M754 |
| `Growing` | ટિકિટ બૂથની આસપાસ અવરોધક વેલ વિસ્તરે છે. | M751, M752, M753, M754 |

---

## 2. 45 Variant Slots Definition
1. `M751~CNT5`: Last Call Ticket Chain (5 moves પછી ચેઇન તૂટી જાય છે).
2. `M751~FRZ2`: Snowbound Ticket Chain (થીજેલો ચેઇન બેરિયર).
3. `M751~COL`: Painted Ticket Chain (ચોક્કસ રંગની ટ્રેન માટેનો ચેઇન બેરિયર).
4. `M751~FOG`: Steamy Ticket Chain (ધુમ્મસમાં ટિકિટ ચેઇન).
5. `M751~CHN`: Linked Ticket Chains (બે જોડાયેલી ટિકિટ ચેઇન્સ).
6. `M751~PHS`: Phantom Ticket Chain (ફેઝિંગ ટિકિટ બેરિયર).
7. `M751~ARM`: Iron-clad Ticket Chain (આર્મ્ડ ચેઇન બેરિયર).
8. `M751~LAY`: Deck Ticket Chain (ડેક લેવલ પરનો ચેઇન બેરિયર).
9. `M751~MIR`: Looking-glass Ticket Chain (પ્રતિબિંબિત ટિકિટ ચેઇન).
10. `M751~GRW`: Sprouting Ticket Chain (વેલવાળો ચેઇન બેરિયર).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M752~CNT5`: Last Call Ticket Punch (5 moves સુધી જ માન્ય પંચિંગ બૂથ).
13. `M752~FRZ2`: Snowbound Ticket Punch (થીજેલું પંચિંગ સ્ટેશન).
14. `M752~COL`: Painted Ticket Punch (ચોક્કસ રંગની ટિકિટ માટેનું પંચ સ્ટેશન).
15. `M752~FOG`: Steamy Ticket Punch (ધુમ્મસમાં પંચ સ્ટેશન).
16. `M752~CHN`: Linked Ticket Punches (બે જોડાયેલા પંચ બૂથ).
17. `M752~PHS`: Phantom Ticket Punch (ફેઝિંગ પંચ બૂથ).
18. `M752~ARM`: Iron-clad Ticket Punch (આર્મ્ડ પંચ સ્ટેશન).
19. `M752~LAY`: Deck Ticket Punch (ડેક લેયર પરનું પંચ સ્ટેશન).
20. `M752~MIR`: Looking-glass Punch (મિરર પંચ સ્ટેશન).
21. `M752~GRW`: Sprouting Punch Booth (વેલવાળો પંચ બૂથ).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M753~CNT5`: Last Call Master Pass (5 moves પછી સામાન્ય ટ્રેન બનતો માસ્ટર પાસ).
24. `M753~FRZ2`: Snowbound Master Pass (થીજેલો ગોલ્ડન માસ્ટર પાસ).
25. `M753~COL`: Painted Master Pass (ચોક્કસ રંગ ફિલ્ટર સાથેનો માસ્ટર પાસ).
26. `M753~FOG`: Steamy Master Pass (ધુમ્મસમાં માસ્ટર પાસ).
27. `M753~CHN`: Linked Master Passes (બે લિન્ક્ડ માસ્ટર પાસ ટ્રેનો).
28. `M753~PHS`: Phantom Master Pass (ફેઝિંગ માસ્ટર પાસ).
29. `M753~ARM`: Iron-clad Master Pass (આર્મ્ડ માસ્ટર પાસ).
30. `M753~LAY`: Deck Master Pass (ડેક પર દોડતો માસ્ટર પાસ).
31. `M753~MIR`: Looking-glass Master Pass (મિરર માસ્ટર પાસ).
32. `M753~GRW`: Sprouting Master Pass (વેલ વચ્ચે દોડતો માસ્ટર પાસ).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M754~CNT5`: Last Call Swap Pad (5 moves સુધી જ એક્સચેન્જ શક્ય).
35. `M754~FRZ2`: Snowbound Swap Pad (થીજેલા સ્વેપ પેડ્સ).
36. `M754~COL`: Painted Swap Pad (ચોક્કસ રંગના સ્લોટ્સવાળા પેડ્સ).
37. `M754~FOG`: Steamy Swap Pad (ધુમ્મસમાં સ્વેપ પેડ્સ).
38. `M754~CHN`: Linked Swap Pads (બે જોડી સ્વેપ પેડ્સ).
39. `M754~PHS`: Phantom Swap Pad (ફેઝિંગ સ્વેપ પેડ્સ).
40. `M754~ARM`: Iron-clad Swap Pad (આર્મ્ડ સ્વેપ પેડ્સ).
41. `M754~MIR`: Looking-glass Swap Pad (મિરર સ્વેપ પેડ્સ).
42. `M754~LAY`: Deck Swap Pad (ડેક લેવલ પરના સ્વેપ પેડ્સ).
43. `M754~GRW`: Sprouting Swap Pad (વેલવાળા સ્વેપ પેડ્સ).
44. `M045~CHN`: Linked Master Gear Office (લિંક્ડ ગિયર ઓફિસ કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
