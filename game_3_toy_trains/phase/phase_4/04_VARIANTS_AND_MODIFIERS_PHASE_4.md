# 04 · Variants & Modifiers Phase 4 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 4 ના 45 variant slots, મલ્ટી-ફ્લોર આધારિત Base × Modifier સંયોજનો અને નિયમો.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Multi-Floor Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી સીડી/લિફ્ટ બ્લોક થાય છે અથવા અનલૉક થાય છે. | M151, M153, M154 |
| `Frozen(K)` | બરફ પીગળ્યા પછી જ વર્ટિકલ ટ્રાન્ઝિટ સક્રિય થાય છે. | M151, M152, M153, M154 |
| `Colored` | ચોક્કસ રંગની ટ્રેન જ ફ્લોર બદલી શકે છે. | M151, M152, M153, M154 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલી સીડી/લિફ્ટ. | All M15x |
| `Chained` | બે ફ્લોરની સીડી/લિફ્ટ એકસાથે ઓપરેટ થાય છે. | M151, M154 |
| `Phasing` | માત્ર Even moves પર જ વર્ટિકલ ટ્રાન્ઝિટ શક્ય બને છે. | M151, M152, M153, M154 |
| `Armored` | ક્રેનથી અપ્રભાવિત રહે છે. | M151, M152, M153, M154 |
| `Layered` | ચોક્કસ ડેક પરથી જ સીડી શરૂ થાય છે. | M151, M152, M153, M154 |
| `Mirrored` | ફ્લોર બદલતાં જ ટ્રેનની દિશા ડાબે-જમણે પ્રતિબિંબિત થાય છે. | M151, M153, M154 |
| `Growing` | moves સાથે સીડીના પાયા પર વેલ ફેલાય છે. | M151, M152, M153, M154 |

---

## 2. 45 Variant Slots Definition
1. `M151~CNT5`: Last Call Stairs (5 moves સુધી જ ઉપલબ્ધ સીડી).
2. `M151~FRZ2`: Snowbound Stairs (2 ટ્રેન નીકળ્યા પછી બરફ મુક્ત).
3. `M151~COL`: Painted Station Stairs (ફક્ત સમાન રંગીન ટ્રેન જ ચડી શકે).
4. `M151~FOG`: Steamy Station Stairs (ધુમ્મસમાં છુપાયેલી સીડી).
5. `M151~CHN`: Linked Station Stairs (બે સીડીઓ એકસાથે સક્રિય).
6. `M151~PHS`: Phantom Stairs (માત્ર even moves પર સક્રિય).
7. `M151~ARM`: Iron-clad Stairs (તોડી ન શકાય તેવી સીડી).
8. `M151~LAY`: Deck Stairs Crossing (ડેક પરથી પસાર થતી સીડી).
9. `M151~MIR`: Looking-glass Stairs (ઉલટી દિશામાં ઉતરતી સીડી).
10. `M151~GRW`: Sprouting Stair Base (વેલથી ઘેરાયેલી સીડી).
11. `M001~CNT6`: Last Call Buffer Stop F2 (ઉપલા ફ્લોર પરનો ટાઈમર બફર).
12. `M152~COL`: Painted Glass Platform (ચોક્કસ રંગ માટે જ પારદર્શક).
13. `M152~FOG`: Steamy Glass Platform (ધુમ્મસિયું કાચનું પ્લેટફોર્મ).
14. `M152~CHN`: Linked Glass Platforms (જોડાયેલા કાચના પ્લેટફોર્મ્સ).
15. `M152~PHS`: Phantom Glass Platform (અદૃશ્ય થતું કાચ પ્લેટફોર્મ).
16. `M152~LAY`: Deck Glass Viaduct (ડેક પરનું કાચનું પ્લેટફોર્મ).
17. `M152~MIR`: Looking-glass Glass Platform (પ્રતિબિંબિત કાચ).
18. `M152~FRZ1`: Snowbound Glass Platform (થીજેલું કાચ પ્લેટફોર્મ).
19. `M152~ARM`: Iron-clad Platform Support (મજબૂત લોખંડી સપોર્ટ).
20. `M152~GRW`: Sprouting Glass Frame (વેલથી ઢંકાયેલું પ્લેટફોર્મ).
21. `M152~CNT5`: Last Call Glass Barrier (5 moves પછી બંધ થતું કાચ).
22. `M007~FRZ2`: Snowbound Level Crossing F2 (F2 પરનું લેવલ ક્રોસિંગ).
23. `M153~CNT5`: Last Call Goods Chute (5 moves પછી બંધ થતો હોલ).
24. `M153~FRZ2`: Snowbound Goods Chute (બરફથી પુરાયેલો હોલ).
25. `M153~COL`: Painted Goods Chute (ચોક્કસ રંગની ટ્રેન જ નીચે પડે).
26. `M153~FOG`: Steamy Goods Chute (ધુમ્મસમાં ઢંકાયેલો હોલ).
27. `M153~CHN`: Linked Goods Chutes (બે જોડાયેલા ડ્રોપ હોલ્સ).
28. `M153~PHS`: Phantom Goods Chute (ફેઝિંગ ડ્રોપ હોલ).
29. `M153~ARM`: Iron-clad Goods Chute (તોડી ન શકાય તેવી ચ્યુટ).
30. `M153~MIR`: Looking-glass Chute (નીચે પડતાં દિશા ઊંધી થતી ચ્યુટ).
31. `M153~LAY`: Deck Goods Chute (ઉપલા ડેક પરથી નીચે પડતી ચ્યુટ).
32. `M153~GRW`: Sprouting Chute Edge (વેલથી ઘેરાયેલી ચ્યુટ).
33. `M013~FOG`: Steamy Turntable F2 (F2 પર ટર્નટેબલ).
34. `M154~CNT6`: Last Call Goods Lift (6 moves સુધી ચાલતી લિફ્ટ).
35. `M154~FRZ2`: Snowbound Goods Lift (થીજેલી ગુડ્સ લિફ્ટ).
36. `M154~COL`: Painted Goods Lift (ચોક્કસ રંગ માટેની લિફ્ટ).
37. `M154~FOG`: Steamy Goods Lift (ધુમ્મસમાં છુપાયેલી લિફ્ટ).
38. `M154~CHN`: Linked Goods Lifts (બે લિફ્ટ એકસાથે ચાલે).
39. `M154~PHS`: Phantom Goods Lift (અદૃશ્ય થતી લિફ્ટ).
40. `M154~ARM`: Iron-clad Goods Lift (ક્રેન-અભેદ્ય લિફ્ટ).
41. `M154~MIR`: Looking-glass Goods Lift (ઉલટી દિશાવાળી લિફ્ટ).
42. `M154~LAY`: Deck Goods Lift (ડેક પર જતી લિફ્ટ).
43. `M154~GRW`: Sprouting Lift Shaft (વેલવાળો લિફ્ટ શાફ્ટ).
44. `M018~CHN`: Linked Track Switches F2 (F2 પર જોડાયેલા સ્વિચ).
45. `M151~CNT6`: Last Call Long Stairs (6 moves વાળી સીડી).

