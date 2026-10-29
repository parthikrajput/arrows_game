# 04 · Variants & Modifiers Phase 8 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 8 ના 45 variant slots, બોટનિકલ ગ્રોથ આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Growth Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી વેલ સુકાઈ જાય છે અથવા કાયમી પથ્થર બને છે. | M351, M352, M353, M354 |
| `Frozen(K)` | બરફ પીગળ્યા પછી જ વેલ ફેલાય છે કે ટ્રીમર ચાલે છે. | M351, M352, M353, M354 |
| `Colored` | ચોક્કસ રંગની ટ્રેન જ વેલને કાપી શકે છે કે બીજ વાવી શકે છે. | M351, M352, M353, M354 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલી વેલ/બીજ. | All M35x |
| `Chained` | બે વેલ કળીઓ અથવા ટ્રીમર્સ એકસાથે સક્રિય થાય છે. | M351, M352, M353 |
| `Phasing` | માત્ર Even moves પર જ વેલ ભૌતિક અવરોધ બને છે. | M351, M352, M353, M354 |
| `Armored` | ક્રેનથી વેલ કાપી શકાતી નથી. | M351, M352, M353, M354 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર જ વેલનું વિસ્તરણ. | M351, M352, M353, M354 |
| `Mirrored` | મિરર અક્ષ પર વિરુદ્ધ દિશામાં વેલ ફેલાય છે. | M351, M352, M353, M354 |
| `Growing` | વેલનો વિસ્તરણ દર બમણો થાય છે (ડબલ ગ્રોથ). | M351, M353, M354 |

---

## 2. 45 Variant Slots Definition
1. `M351~CNT5`: Last Call Wild Ivy (5 moves પછી આપોઆપ સુકાઈ જતી વેલ).
2. `M351~FRZ2`: Snowbound Wild Ivy (2 ટ્રેન પછી બરફ મુક્ત વેલ).
3. `M351~COL`: Painted Wild Ivy (ચોક્કસ રંગીન ટ્રેન જ સ્પર્શી શકે).
4. `M351~FOG`: Steamy Wild Ivy (ધુમ્મસમાં છુપાયેલી વેલ).
5. `M351~CHN`: Linked Wild Ivies (બે જોડાયેલી વેલ કળીઓ).
6. `M351~PHS`: Phantom Wild Ivy (ફેઝિંગ વેલ).
7. `M351~ARM`: Iron-clad Wild Ivy (તોડી ન શકાય તેવી મજબૂત વેલ).
8. `M351~LAY`: Deck Wild Ivy (ડેક પર ફેલાતી વેલ).
9. `M351~MIR`: Looking-glass Wild Ivy (પ્રતિબિંબિત વેલ).
10. `M351~GRW`: Sprouting Ivy Core (ઝડપી વેલ).
11. `M001~CNT6`: Last Call Foliage Buffer (ટાઈમર બફર સ્ટોપ).
12. `M352~CNT5`: Last Call Hedge Trimmer (5 moves સુધી જ સક્રિય ટ્રીમર).
13. `M352~COL`: Painted Hedge Trimmer (ચોક્કસ રંગની ટ્રેનથી જ ચાલતો ટ્રીમર).
14. `M352~FOG`: Steamy Hedge Trimmer (ધુમ્મસમાં ટ્રીમર).
15. `M352~CHN`: Linked Hedge Trimmers (બે ટ્રીમર્સ એકસાથે ચાલે).
16. `M352~PHS`: Phantom Hedge Trimmer (ફેઝિંગ ટ્રીમર).
17. `M352~LAY`: Deck Hedge Trimmer (ડેક પરનો ટ્રીમર).
18. `M352~MIR`: Looking-glass Trimmer (વિરુદ્ધ દિશામાં કાપતો ટ્રીમર).
19. `M352~FRZ1`: Snowbound Hedge Trimmer (થીજેલો ટ્રીમર).
20. `M352~ARM`: Iron-clad Trimmer Blade (મજબૂત લોખંડી બ્લેડ).
21. `M352~GRW`: Sprouting Trimmer Post (વેલવાળો ટ્રીમર).
22. `M013~FRZ2`: Snowbound Rotary Pruner (થીજેલું ટર્નટેબલ).
23. `M353~CNT5`: Last Call Seed Wagon (5 moves પછી બીજ વાવવાનું બંધ).
24. `M353~FRZ2`: Snowbound Seed Wagon (બરફ મુક્ત થયા પછી બીજ પડે).
25. `M353~COL`: Painted Seed Wagon (ચોક્કસ રંગનું સીડ વેગન).
26. `M353~FOG`: Steamy Seed Wagon (ધુમ્મસિયું સીડ વેગન).
27. `M353~CHN`: Linked Seed Wagons (બે જોડાયેલા સીડ વેગન્સ).
28. `M353~PHS`: Phantom Seed Wagon (ફેઝિંગ સીડ વેગન).
29. `M353~ARM`: Iron-clad Seed Wagon (ક્રેન-અભેદ્ય સીડ વેગન).
30. `M353~MIR`: Looking-glass Seed Wagon (પ્રતિબિંબિત સીડ વેગન).
31. `M353~LAY`: Deck Seed Wagon (ડેક પરનું સીડ વેગન).
32. `M353~GRW`: Sprouting Seed Pod (ઝડપી બીજ).
33. `M018~FOG`: Steamy Branch Switch (ધુમ્મસમાં સ્વિચ).
34. `M354~CNT6`: Last Call Flower Arch (6 moves પછી આપોઆપ ખુલતી કમાન).
35. `M354~FRZ2`: Snowbound Flower Arch (થીજેલી ફૂલ કમાન).
36. `M354~COL`: Painted Flower Arch (ચોક્કસ રંગના ફૂલો).
37. `M354~FOG`: Steamy Flower Arch (ધુમ્મસમાં કમાન).
38. `M354~CHN`: Linked Flower Arches (બે જોડાયેલી કમાનો).
39. `M354~PHS`: Phantom Flower Arch (ફેઝિંગ કમાન).
40. `M354~ARM`: Iron-clad Flower Arch (તોડી ન શકાય તેવી કમાન).
41. `M354~MIR`: Looking-glass Flower Arch (મિરર કમાન).
42. `M354~LAY`: Deck Flower Arch (ડેક પરની કમાન).
43. `M354~GRW`: Sprouting Botanical Arch (વેલવાળી કમાન).
44. `M045~CHN`: Linked Master Gear Foliage (જોડાયેલા ગિયર લીવર્સ).
45. `M351~ARM`: Permanent Wild Ivy (ક્રેન-અભેદ્ય જંગલી વેલ).
