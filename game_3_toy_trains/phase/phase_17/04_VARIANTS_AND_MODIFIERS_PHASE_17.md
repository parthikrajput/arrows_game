# 04 · Variants & Modifiers Phase 17 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 17 ના 45 variant slots, Clock Towers Guardians આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_8001_8500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Clock Towers Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી ટાવરનું HP આપોઆપ 0 થાય છે અથવા સુપર-સ્પોનર બને છે. | M801, M802, M803, M804 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ ટાવર સ્પોન કરવાનું શરૂ કરે છે. | M801, M802, M803, M804 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ ટાવરને ડેમેજ આપી શકે છે. | M801, M802, M803, M804 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો ટાવર કે ક્લોક કોર. | All M80x |
| `Chained` | બે ટાવર્સ શિલ્ડ શેર કરે છે (એકને નુકસાન થતાં બીજાને પણ થાય). | M801, M802, M803 |
| `Phasing` | માત્ર Even moves પર જ ટાવર પાટા પર ભૌતિક અવરોધ બને છે. | M801, M802, M803, M804 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી ટાવરને તોડી શકાતો નથી (ફક્ત પઝલ સોલ્વિંગથી ડેમેજ). | M801, M802, M803, M804 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ ગાર્ડિયન ટાવર્સ. | M801, M802, M803, M804 |
| `Mirrored` | પ્રતિબિંબિત સ્થાનો પર જોડિયા ટાવર્સ સમપ્રમાણ સ્પોન કરે છે. | M801, M802, M803, M804 |
| `Growing` | ટાવરની આસપાસ સમય જતાં વેલ અને પથ્થરો વિસ્તરે છે. | M801, M802, M803, M804 |

---

## 2. 45 Variant Slots Definition
1. `M801~CNT5`: Last Call Twin Towers (5 moves પછી આપોઆપ નાશ પામતા જોડિયા ટાવર્સ).
2. `M801~FRZ2`: Snowbound Twin Towers (થીજેલા જોડિયા ટાવર્સ).
3. `M801~COL`: Painted Twin Towers (ચોક્કસ રંગની ટ્રેનથી ડેમેજ લેતા ટાવર્સ).
4. `M801~FOG`: Steamy Twin Towers (ધુમ્મસમાં ઢંકાયેલા જોડિયા ટાવર્સ).
5. `M801~CHN`: Linked Guardian Towers (બે જોડાયેલા ગાર્ડિયન ટાવર્સ).
6. `M801~PHS`: Phantom Twin Towers (ફેઝિંગ જોડિયા ટાવર્સ).
7. `M801~ARM`: Iron-clad Twin Towers (તોડી ન શકાય તેવા આર્મ્ડ ટાવર્સ).
8. `M801~LAY`: Deck Twin Towers (ડેક લેવલ પરના જોડિયા ટાવર્સ).
9. `M801~MIR`: Looking-glass Twin Towers (પ્રતિબિંબિત જોડિયા ટાવર્સ).
10. `M801~GRW`: Sprouting Clock Towers (વેલવાળા જોડિયા ટાવર્સ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M802~CNT5`: Last Call Armoured Tower (5 moves પછી કવચ આપોઆપ તૂટે છે).
13. `M802~FRZ2`: Snowbound Armoured Tower (થીજેલો આર્મ્ડ ટાવર).
14. `M802~COL`: Painted Shield Tower (ચોક્કસ રંગીન કવચવાળો ટાવર).
15. `M802~FOG`: Steamy Armoured Tower (ધુમ્મસમાં આર્મ્ડ ટાવર).
16. `M802~CHN`: Linked Shield Towers (જોડાયેલા બે કવચ ટાવર્સ).
17. `M802~PHS`: Phantom Armoured Tower (ફેઝિંગ આર્મ્ડ ટાવર).
18. `M802~ARM`: Iron-clad Shield Tower (અત્યંત મજબૂત કવચ ટાવર).
19. `M802~LAY`: Deck Armoured Tower (ડેક લેયર પરનો આર્મ્ડ ટાવર).
20. `M802~MIR`: Looking-glass Shield Tower (મિરર શિલ્ડ ટાવર).
21. `M802~GRW`: Sprouting Armoured Tower (વેલથી ઢંકાયેલો આર્મ્ડ ટાવર).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M803~CNT5`: Last Call Depot Tower (5 moves પછી સ્પોન કરવાનું બંધ કરતો ટાવર).
24. `M803~FRZ2`: Snowbound Depot Tower (થીજેલો ડિપો ટાવર).
25. `M803~COL`: Painted Depot Spawner (ચોક્કસ રંગના બ્લોકર્સ સ્પોન કરતો ટાવર).
26. `M803~FOG`: Steamy Depot Tower (ધુમ્મસમાં ડિપો ટાવર).
27. `M803~CHN`: Linked Depot Spawners (સાથે સ્પોન કરતા જોડિયા ટાવર્સ).
28. `M803~PHS`: Phantom Depot Tower (ફેઝિંગ ડિપો ટાવર).
29. `M803~ARM`: Iron-clad Depot Tower (આર્મ્ડ ડિપો ટાવર).
30. `M803~LAY`: Deck Depot Tower (ડેક લેવલ પરનો ડિપો ટાવર).
31. `M803~MIR`: Looking-glass Depot Tower (મિરર સ્પોનર ટાવર).
32. `M803~GRW`: Sprouting Depot Spawner (વેલવાળો ડિપો ટાવર).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M804~CNT5`: Last Call Clock Core (5 moves પછી બીમ વિના પણ નાશ પામતો કોર).
35. `M804~FRZ2`: Snowbound Clock Core (થીજેલો ક્લોક કોર).
36. `M804~COL`: Painted Clock Core (ચોક્કસ રંગના બીમની જરૂરિયાતવાળો કોર).
37. `M804~FOG`: Steamy Clock Core (ધુમ્મસમાં ક્લોક કોર).
38. `M804~CHN`: Linked Clock Cores (જોડાયેલા બેવડા ક્લોક કોર્સ).
39. `M804~PHS`: Phantom Clock Core (ફેઝિંગ ક્લોક કોર).
40. `M804~ARM`: Iron-clad Clock Core (આર્મ્ડ ક્લોક કોર).
41. `M804~MIR`: Looking-glass Clock Core (મિરર ક્લોક કોર).
42. `M804~LAY`: Deck Clock Core (ડેક લેયર પરનો ક્લોક કોર).
43. `M804~GRW`: Sprouting Clock Core (વેલથી વીંટળાયેલો કોર).
44. `M045~CHN`: Linked Master Gear Guardian (લિંક્ડ ગિયર ગાર્ડિયન કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
