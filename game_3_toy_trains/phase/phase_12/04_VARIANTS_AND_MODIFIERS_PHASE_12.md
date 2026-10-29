# 04 · Variants & Modifiers Phase 12 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 12 ના 45 variant slots, Hill Line Gravity આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 12 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_5501_6000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Hill Gravity Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી લીવર આપોઆપ ફરે છે અથવા ક્રેટ કાયમી પથ્થર બને છે. | M551, M552, M553, M554 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ લીવર ટેપ કરી શકાય છે કે ક્રેટ સરકે છે. | M551, M552, M553, M554 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ ક્રેટને પુશ કરી શકે છે કે બેલાસ્ટ આગળ વધે છે. | M551, M552, M553, M554 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો ટિલ્ટ લીવર કે બેલાસ્ટ કાર. | All M55x |
| `Chained` | બે ટિલ્ટ લીવર્સ જોડાયેલા છે (એક ફરતાં બીજું વિરુદ્ધ ફરે છે). | M551, M552, M553 |
| `Phasing` | માત્ર Even moves પર જ ક્રેટ ભૌતિક અવરોધ બને છે. | M551, M552, M553, M554 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી ભારે ક્રેટને તોડી શકાતો નથી. | M551, M552, M553, M554 |
| `Layered` | ઉપલા ડેક અથવા ગ્રાઉન્ડ લેયર પર અલગ ગ્રેવિટી વર્તણૂક. | M551, M552, M553, M554 |
| `Mirrored` | પ્રતિબિંબિત અક્ષ પર ક્રેટ ઉલટી દિશામાં સરકે છે. | M551, M552, M553, M554 |
| `Growing` | ક્રેટની સપાટી પર વેલ ઉગે છે જેથી તે સરકી શકતો નથી. | M551, M552, M553, M554 |

---

## 2. 45 Variant Slots Definition
1. `M551~CNT5`: Last Call Tilt Lever (5 moves સુધી જ સક્રિય રહેતો ટિલ્ટ લીવર).
2. `M551~FRZ2`: Snowbound Tilt Lever (2 ટ્રેન એક્ઝિટ પછી કાર્યરત થતો લીવર).
3. `M551~COL`: Painted Tilt Lever (ચોક્કસ રંગની ટ્રેનથી જ ફરતો લીવર).
4. `M551~FOG`: Steamy Tilt Lever (ધુમ્મસમાં ઢંકાયેલો લીવર).
5. `M551~CHN`: Linked Tilt Levers (જોડાયેલા બેવડા ટિલ્ટ લીવર્સ).
6. `M551~PHS`: Phantom Tilt Lever (ફેઝિંગ ટિલ્ટ લીવર).
7. `M551~ARM`: Iron-clad Tilt Lever (તોડી ન શકાય તેવો મજબૂત લીવર).
8. `M551~LAY`: Deck Tilt Lever (ડેક લેવલ પરનો લીવર).
9. `M551~MIR`: Looking-glass Tilt Lever (પ્રતિબિંબિત દિશામાં ટિલ્ટ કરતો લીવર).
10. `M551~GRW`: Sprouting Incline Lever (વેલથી વીંટળાયેલો લીવર).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M552~CNT5`: Last Call Falling Crate (5 moves સુધી જ સરકતો ક્રેટ).
13. `M552~FRZ2`: Snowbound Loose Crate (થીજેલો લાકડાનો ક્રેટ).
14. `M552~COL`: Painted Loose Crate (ચોક્કસ રંગની ટ્રેન દ્વારા જ પુશ થતો ક્રેટ).
15. `M552~FOG`: Steamy Loose Crate (ધુમ્મસમાં છુપાયેલો ક્રેટ).
16. `M552~CHN`: Linked Loose Crates (એકસાથે સરકતા જોડિયા ક્રેટ્સ).
17. `M552~PHS`: Phantom Loose Crate (ફેઝિંગ ક્રેટ).
18. `M552~ARM`: Iron-clad Heavy Crate (આર્મ્ડ હેવી ક્રેટ).
19. `M552~LAY`: Deck Loose Crate (ડેક લેયર પર સરકતો ક્રેટ).
20. `M552~MIR`: Looking-glass Rolling Crate (મિરર દિશામાં સરકતો ક્રેટ).
21. `M552~GRW`: Sprouting Wooden Crate (વેલવાળો ક્રેટ).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M553~CNT5`: Last Call Balloon Pad (5 moves પછી ફુગ્ગો ફૂટી જતો પેડ).
24. `M553~FRZ2`: Snowbound Balloon Pad (થીજેલો એન્ટિ-ગ્રેવ પેડ).
25. `M553~COL`: Painted Balloon Pad (ચોક્કસ રંગના ક્રેટ માટેનો પેડ).
26. `M553~FOG`: Steamy Balloon Pad (ધુમ્મસમાં એન્ટિ-ગ્રેવ પેડ).
27. `M553~CHN`: Linked Balloon Pads (બે જોડાયેલા એન્ટિ-ગ્રેવ પેડ્સ).
28. `M553~PHS`: Phantom Balloon Pad (ફેઝિંગ પેડ).
29. `M553~ARM`: Iron-clad Balloon Pad (આર્મ્ડ પેડ).
30. `M553~LAY`: Deck Balloon Pad (ડેક લેયર પરનો પેડ).
31. `M553~MIR`: Looking-glass Balloon Pad (મિરર પેડ).
32. `M553~GRW`: Sprouting Balloon Tile (વેલવાળો પેડ).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M554~CNT5`: Last Call Ballast Train (5 moves પછી રોલ થવાનું બંધ કરતી ટ્રેન).
35. `M554~FRZ2`: Snowbound Ballast Train (થીજેલી બેલાસ્ટ ટ્રેન).
36. `M554~COL`: Painted Ballast Train (ચોક્કસ રંગની બેલાસ્ટ ટ્રેન).
37. `M554~FOG`: Steamy Ballast Train (ધુમ્મસમાં સરકતી બેલાસ્ટ ટ્રેન).
38. `M554~CHN`: Linked Ballast Trains (સાથે સરકતી બે બેલાસ્ટ ટ્રેનો).
39. `M554~PHS`: Phantom Ballast Train (ફેઝિંગ બેલાસ્ટ ટ્રેન).
40. `M554~ARM`: Iron-clad Ballast Engine (આર્મ્ડ બેલાસ્ટ ટ્રેન).
41. `M554~MIR`: Looking-glass Ballast Train (મિરર બેલાસ્ટ ટ્રેન).
42. `M554~LAY`: Deck Ballast Train (ડેક પર સરકતી બેલાસ્ટ ટ્રેન).
43. `M554~GRW`: Sprouting Ballast Car (વેલથી વીંટળાયેલી બેલાસ્ટ ટ્રેન).
44. `M045~CHN`: Linked Master Gear Incline (લિંક્ડ ગિયર ઇન્કલાઈન કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
