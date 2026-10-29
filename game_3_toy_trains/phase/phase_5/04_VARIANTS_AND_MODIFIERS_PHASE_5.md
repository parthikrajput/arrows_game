# 04 · Variants & Modifiers Phase 5 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 5 ના 45 variant slots, શન્ટિંગ પુશ ફિઝિક્સ આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Shunting Physics Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી કાર્ટ બ્લોક થાય છે અથવા ખાડો આપોઆપ પૂરાય છે. | M201, M202, M203, M204 |
| `Frozen(K)` | બરફ પીગળ્યા પછી જ કાર્ટને ધકેલી શકાય છે. | M201, M202, M203, M204 |
| `Colored` | ચોક્કસ રંગની ટ્રેન જ કાર્ટને શન્ટ કરી શકે છે. | M201, M202, M203, M204 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલું કાર્ટ/ખાડો. | All M20x |
| `Chained` | બે કાર્ટ્સ કપલિંગ રોડથી જોડાયેલા હોય છે અને એકસાથે ખસે છે. | M202, M203, M204 |
| `Phasing` | માત્ર Even moves પર જ કાર્ટ ભૌતિક રીતે ઉપસ્થિત રહે છે. | M201, M202, M203, M204 |
| `Armored` | ટ્રેક ક્રેન (Hammer) થી કાર્ટ હટાવી શકાતું નથી. | M202, M203, M204 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર જ શન્ટિંગ મર્યાદિત રહે છે. | M201, M202, M203, M204 |
| `Mirrored` | કાર્ટ ધકેલતાં મિરર અક્ષ પરનું જોડીદાર કાર્ટ વિરુદ્ધ દિશામાં ખસે છે. | M202, M203, M204 |
| `Growing` | moves સાથે કાર્ટ પર વજન/વેલ વધે છે. | M201, M202, M204 |

---

## 2. 45 Variant Slots Definition
1. `M201~CNT5`: Last Call Cart Pit (5 moves પછી આપોઆપ પૂરાતો ખાડો).
2. `M201~FRZ2`: Snowbound Cart Pit (બરફ પીગળ્યા પછી જ ભરી શકાય).
3. `M201~COL`: Painted Cart Pit (ચોક્કસ રંગના કાર્ટથી જ પૂરાય).
4. `M201~FOG`: Steamy Cart Pit (ધુમ્મસમાં છુપાયેલો ખાડો).
5. `M201~CHN`: Linked Cart Pits (એક ખાડો ભરાતાં બીજો પણ પૂરાય).
6. `M201~PHS`: Phantom Cart Pit (ફેઝિંગ ખાડો).
7. `M201~ARM`: Iron-clad Pit Edge (મજબૂત લોખંડી ખાડો).
8. `M201~LAY`: Deck Cart Pit (ઉપલા ડેક પરનો ખાડો).
9. `M201~MIR`: Looking-glass Cart Pit (પ્રતિબિંબિત ખાડો).
10. `M201~GRW`: Sprouting Pit Vegetation (વેલવાળો ખાડો).
11. `M001~CNT6`: Last Call Shunting Buffer (ટાઈમર બફર સ્ટોપ).
12. `M202~CNT5`: Last Call Ice Cart (5 moves સુધી જ લપસતું કાર્ટ).
13. `M202~COL`: Painted Ice Block Cart (ચોક્કસ રંગવાળું આઈસ કાર્ટ).
14. `M202~FOG`: Steamy Ice Block Cart (ધુમ્મસિયું આઈસ કાર્ટ).
15. `M202~CHN`: Linked Ice Block Carts (બે આઈસ કાર્ટ એકસાથે સ્લાઈડ થાય).
16. `M202~PHS`: Phantom Ice Block Cart (અદૃશ્ય થતું આઈસ કાર્ટ).
17. `M202~LAY`: Deck Ice Shunting Track (ડેક પરનું આઈસ કાર્ટ).
18. `M202~MIR`: Looking-glass Ice Cart (વિરુદ્ધ સ્લાઈડ થતું કાર્ટ).
19. `M202~FRZ1`: Snowbound Ice Cart (થીજેલું આઈસ કાર્ટ).
20. `M202~ARM`: Iron-clad Ice Cart (ક્રેન-અભેદ્ય આઈસ કાર્ટ).
21. `M202~GRW`: Sprouting Ice Track (વેલ વચ્ચે લપસતું કાર્ટ).
22. `M013~FRZ2`: Snowbound Turntable Shunt (શન્ટિંગ ટર્નટેબલ).
23. `M203~CNT5`: Last Call Ticket Cart (5 moves પછી ટિકિટ નિષ્ક્રિય).
24. `M203~FRZ2`: Snowbound Ticket Cart (બરફ મુક્ત થયા પછી ખસે).
25. `M203~COL`: Painted Ticket Cart (ચોક્કસ કલર બેરિયર માટેનું કાર્ટ).
26. `M203~FOG`: Steamy Ticket Cart (ધુમ્મસમાં ઢંકાયેલું ટિકિટ કાર્ટ).
27. `M203~CHN`: Linked Ticket Carts (બે ટિકિટ કાર્ટ્સ).
28. `M203~PHS`: Phantom Ticket Cart (ફેઝિંગ ટિકિટ કાર્ટ).
29. `M203~ARM`: Iron-clad Ticket Cart (તોડી ન શકાય તેવું ટિકિટ કાર્ટ).
30. `M203~MIR`: Looking-glass Ticket Cart (પ્રતિબિંબિત ટિકિટ કાર્ટ).
31. `M203~LAY`: Deck Ticket Shunting (ડેક પરનું ટિકિટ કાર્ટ).
32. `M203~GRW`: Sprouting Ticket Track (વેલવાળો ટ્રેક).
33. `M018~FOG`: Steamy Track Switch Shunt (ધુમ્મસમાં સ્વિચ).
34. `M204~CNT6`: Last Call Ballast Cart (6 moves વાળું બેલાસ્ટ કાર્ટ).
35. `M204~FRZ2`: Snowbound Ballast Cart (થીજેલું બેલાસ્ટ કાર્ટ).
36. `M204~COL`: Painted Ballast Cart (ચોક્કસ રંગનું ભારે કાર્ટ).
37. `M204~FOG`: Steamy Ballast Cart (ધુમ્મસિયું બેલાસ્ટ કાર્ટ).
38. `M204~CHN`: Linked Ballast Carts (બે ભારે કાર્ટ્સ જોડાયેલા).
39. `M204~PHS`: Phantom Ballast Cart (ફેઝિંગ ભારે કાર્ટ).
40. `M204~ARM`: Iron-clad Ballast Cart (ક્રેન-અભેદ્ય ભારે કાર્ટ).
41. `M204~MIR`: Looking-glass Ballast Cart (પ્રતિબિંબિત ભારે કાર્ટ).
42. `M204~LAY`: Deck Ballast Shunt (ડેક પરનું ભારે કાર્ટ).
43. `M204~GRW`: Sprouting Ballast Pit (વેલથી ઢંકાયેલું બેલાસ્ટ).
44. `M045~CHN`: Linked Master Levers Shunt (જોડાયેલા ગિયર લીવર્સ).
45. `M201~ARM`: Iron-clad Permanent Pit (લોખંડી કાયમી ખાડો).

