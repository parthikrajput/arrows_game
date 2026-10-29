# 04 · Variants & Modifiers Phase 6 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 6 ના 45 variant slots, સિગ્નલ ઓપ્ટિક્સ આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Signal Optics Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી લેન્સ/સેન્સર કાયમી રીતે બંધ કે ચાલુ થાય છે. | M251, M252, M253, M254 |
| `Frozen(K)` | બરફ પીગળ્યા પછી જ લેન્સમાંથી પ્રકાશ પસાર થાય છે. | M251, M252, M253, M254 |
| `Colored` | ચોક્કસ રંગની ટ્રેન અથવા બીમ સાથે જ પ્રતિક્રિયા. | M251, M252, M253, M254 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે બીમ વિખેરાઈ જાય છે. | All M25x |
| `Chained` | બે લેન્સ અથવા સેન્સર્સ એકસાથે સ્થિતિ બદલે છે. | M251, M252, M253 |
| `Phasing` | માત્ર Even moves પર જ બીમ ઉત્સર્જિત થાય છે કે સેન્સર સક્રિય રહે છે. | M251, M252, M253, M254 |
| `Armored` | ક્રેનથી તોડી શકાતું નથી. | M251, M252, M253, M254 |
| `Layered` | ડેક અથવા વાયાડક્ટ સ્તર પર બીમ ટ્રાન્સમિશન. | M251, M252, M253, M254 |
| `Mirrored` | બીમનું પ્રતિબિંબ 90 ડિગ્રી અથવા મિરર અક્ષ પર વળે છે. | M251, M252, M253, M254 |
| `Growing` | moves સાથે ઓપ્ટિકલ પોસ્ટ પર વેલ ચડે છે. | M251, M252, M253, M254 |

---

## 2. 45 Variant Slots Definition
1. `M251~CNT5`: Last Call Coloured Lens (5 moves સુધી જ બીમ કલર ફિલ્ટર કરે).
2. `M251~FRZ2`: Snowbound Coloured Lens (2 ટ્રેન પછી બરફ મુક્ત લેન્સ).
3. `M251~COL`: Painted Lens Frame (ખાસ રંગના આધારે ફિલ્ટર).
4. `M251~FOG`: Steamy Coloured Lens (ધુમ્મસમાં ઢંકાયેલો લેન્સ).
5. `M251~CHN`: Linked Coloured Lenses (બે જોડાયેલા કલર લેન્સ).
6. `M251~PHS`: Phantom Coloured Lens (ફેઝિંગ કલર લેન્સ).
7. `M251~ARM`: Iron-clad Lens Holder (મજબૂત લોખંડી લેન્સ).
8. `M251~LAY`: Deck Coloured Lens (ડેક પર સ્થિત કલર લેન્સ).
9. `M251~MIR`: Looking-glass Lens (પ્રતિબિંબિત કલર લેન્સ).
10. `M251~GRW`: Sprouting Lens Post (વેલવાળો લેન્સ).
11. `M001~CNT6`: Last Call Optical Buffer (ટાઈમર બફર સ્ટોપ).
12. `M252~CNT5`: Last Call Twin Sensor (5 moves પછી બંધ થતો સેન્સર).
13. `M252~COL`: Painted Twin Sensor Gate (ચોક્કસ રંગના બીમથી ખુલતો ગેટ).
14. `M252~FOG`: Steamy Twin Sensor Gate (ધુમ્મસમાં સેન્સર).
15. `M252~CHN`: Linked Twin Sensors (બે જોડિયા સેન્સર્સ).
16. `M252~PHS`: Phantom Twin Sensor (ફેઝિંગ ટ્વિન સેન્સર).
17. `M252~LAY`: Deck Twin Sensor Gate (ડેક પર ટ્વિન સેન્સર).
18. `M252~MIR`: Looking-glass Twin Sensor (મિરર થયેલ ટ્વિન સેન્સર).
19. `M252~FRZ1`: Snowbound Twin Sensor (થીજેલું ટ્વિન સેન્સર).
20. `M252~ARM`: Iron-clad Twin Gate (તોડી ન શકાય તેવો ગેટ).
21. `M252~GRW`: Sprouting Twin Sensor Frame (વેલથી ઢંકાયેલો ગેટ).
22. `M013~FRZ2`: Snowbound Turntable Optics (થીજેલું ટર્નટેબલ).
23. `M253~CNT5`: Last Call Lamp Timer (5 moves પછી કાયમી બંધ લેમ્પ).
24. `M253~FRZ2`: Snowbound Lamp Timer (બરફ પીગળ્યા પછી ચાલુ થતો લેમ્પ).
25. `M253~COL`: Painted Lamp Timer (ચોક્કસ રંગનો ટાઈમર લેમ્પ).
26. `M253~FOG`: Steamy Lamp Timer (ધુમ્મસમાં ટાઈમર લેમ્પ).
27. `M253~CHN`: Linked Lamp Timers (બે જોડાયેલા ટાઈમર લેમ્પ્સ).
28. `M253~PHS`: Phantom Lamp Timer (ફેઝિંગ ટાઈમર લેમ્પ).
29. `M253~ARM`: Iron-clad Lamp Timer (તોડી ન શકાય તેવો લેમ્પ).
30. `M253~MIR`: Looking-glass Lamp Timer (પ્રતિબિંબિત લેમ્પ).
31. `M253~LAY`: Deck Lamp Timer (ડેક પર ટાઈમર લેમ્પ).
32. `M253~GRW`: Sprouting Lamp Tower (વેલવાળો લેમ્પ ટાવર).
33. `M018~FOG`: Steamy Track Switch Optics (ધુમ્મસિયું સ્વિચ).
34. `M254~CNT6`: Last Call Blackout Patch (6 moves પછી કાયમી અંધારું).
35. `M254~FRZ2`: Snowbound Blackout Patch (થીજેલો અંધારો સેલ).
36. `M254~COL`: Painted Blackout Patch (ચોક્કસ રંગના બીમથી પ્રકાશિત).
37. `M254~FOG`: Steamy Blackout Patch (ધુમ્મસિયું અંધારું).
38. `M254~CHN`: Linked Blackout Patches (બે અંધારા સેલ્સ જોડાયેલા).
39. `M254~PHS`: Phantom Blackout Patch (ફેઝિંગ ડાર્ક સેલ).
40. `M254~ARM`: Iron-clad Blackout Area (કાયમી અંધારો વિસ્તાર).
41. `M254~MIR`: Looking-glass Blackout Patch (પ્રતિબિંબિત ડાર્ક સેલ).
42. `M254~LAY`: Deck Blackout Patch (ડેક પરનો ડાર્ક સેલ).
43. `M254~GRW`: Sprouting Dark Cells (વધતા જતા અંધારા સેલ્સ).
44. `M045~CHN`: Linked Master Gear Optics (જોડાયેલા ગિયર લીવર્સ).
45. `M251~ARM`: Permanent Coloured Lens (લોખંડી કલર લેન્સ).
