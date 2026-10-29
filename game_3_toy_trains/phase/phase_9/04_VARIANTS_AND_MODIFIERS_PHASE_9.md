# 04 · Variants & Modifiers Phase 9 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 9 ના 45 variant slots, Couple & Uncouple આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_4001_4500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Coupling Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી કપલિંગ પેડ કે રીજોઇન આર્ચ ખુલે છે અથવા બ્લોક થાય છે. | M401, M402, M403, M404 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થયા પછી જ પેડ એક્ટિવ થાય છે કે સ્પ્લિટ શક્ય બને છે. | M401, M402, M403, M404 |
| `Colored` | માત્ર સમાન રંગની ટ્રેન જ પેડ પર જોડાઈ શકે છે કે આર્ચમાંથી નીકળી શકે છે. | M401, M402, M403, M404 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલું કપલિંગ પેડ કે સેગમેન્ટ લોક. | All M40x |
| `Chained` | એક પેડ પર જોડાણ થતાં બીજા પેડ પર પણ સાથી ટ્રેનો જોડાય છે. | M401, M402, M403 |
| `Phasing` | માત્ર Even moves પર જ સ્પ્લિટ અથવા રીજોઇન શક્ય બને છે. | M401, M402, M403, M404 |
| `Armored` | ક્રેનથી ટ્વિન ટ્રેન કે કપલિંગ આર્ચ હટાવી શકાતી નથી. | M401, M402, M403, M404 |
| `Layered` | ઉપલા ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ જોડાણ/વિભાજન. | M401, M402, M403, M404 |
| `Mirrored` | વિભાજિત ટ્રેન અરીસાની જેમ વિરુદ્ધ દિશામાં અલગ પડે છે. | M401, M402, M403, M404 |
| `Growing` | કપલિંગ પેડની આસપાસ સમય જતાં અવરોધક માળખું વિસ્તરે છે. | M401, M403, M404 |

---

## 2. 45 Variant Slots Definition
1. `M401~CNT5`: Last Call Coupling Pad (5 moves સુધી જ સક્રિય રહેતું મેગ્નેટિક પેડ).
2. `M401~FRZ2`: Snowbound Coupling Pad (2 ટ્રેન એક્ઝિટ પછી અનફ્રીઝ થતું પેડ).
3. `M401~COL`: Painted Coupling Pad (ચોક્કસ રંગની જોડી જ જોડી શકે).
4. `M401~FOG`: Steamy Coupling Pad (ધુમ્મસમાં છુપાયેલું કપલિંગ પેડ).
5. `M401~CHN`: Linked Coupling Pads (એકસાથે મર્જ થતાં બે જોડી પેડ્સ).
6. `M401~PHS`: Phantom Coupling Pad (ફેઝિંગ કપલિંગ પેડ).
7. `M401~ARM`: Iron-clad Coupling Pad (તોડી ન શકાય તેવું પેડ).
8. `M401~LAY`: Deck Coupling Pad (ડેક પર આવેલું કપલિંગ પેડ).
9. `M401~MIR`: Looking-glass Coupling Pad (પ્રતિબિંબિત દિશામાં જોડાણ).
10. `M401~GRW`: Sprouting Magnetic Pad (આસપાસ અવરોધક વેલવાળું પેડ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M402~CNT5`: Last Call Splitter (5 moves સુધી જ સ્પ્લિટ થતી ટ્રેન).
13. `M402~COL`: Painted Twin Splitter (ચોક્કસ રંગીન ડ્યુઅલ ટ્રેન).
14. `M402~FOG`: Steamy Twin Splitter (ધુમ્મસમાં સ્પ્લિટ થતી ટ્રેન).
15. `M402~CHN`: Linked Twin Splitters (જોડાયેલી બે સ્પ્લિટ ટ્રેનો).
16. `M402~PHS`: Phantom Twin Splitter (ફેઝિંગ સ્પ્લિટ એન્જિન).
17. `M402~LAY`: Deck Twin Splitter (ડેક લેયર પર સ્પ્લિટ થતી ટ્રેન).
18. `M402~MIR`: Looking-glass Splitter (વિરુદ્ધ દિશામાં સ્પ્લિટ થતી ટ્રેન).
19. `M402~FRZ2`: Snowbound Twin Splitter (થીજેલી સ્પ્લિટ ટ્રેન).
20. `M402~ARM`: Iron-clad Split Engine (આર્મ્ડ ટ્વિન ટ્રેન).
21. `M402~GRW`: Sprouting Tender Split (સ્પ્રાઉટિંગ સ્પ્લિટ ટ્રેન).
22. `M018~FRZ2`: Snowbound Shunting Switch (થીજેલું ટ્રેક સ્વિચ).
23. `M403~CNT6`: Last Call Coupling Lock (6 moves પછી આપોઆપ અનલોક).
24. `M403~FRZ2`: Snowbound Coupling Lock (બરફ મુક્ત સેગમેન્ટ લોક).
25. `M403~COL`: Painted Coupling Lock (ચોક્કસ રંગની કી-ટ્રેન વાળો લોક).
26. `M403~FOG`: Steamy Coupling Lock (ધુમ્મસમાં સેગમેન્ટ લોક).
27. `M403~CHN`: Linked Segment Locks (એકસાથે ખુલતા બે સેગમેન્ટ લોક્સ).
28. `M403~PHS`: Phantom Coupling Lock (ફેઝિંગ સેગમેન્ટ લોક).
29. `M403~ARM`: Iron-clad Segment Lock (ક્રેન-ઇમ્યુન લોક).
30. `M403~MIR`: Looking-glass Segment Lock (મિરર પોઝિશન લોક).
31. `M403~LAY`: Deck Segment Lock (ડેક પરનો સેગમેન્ટ લોક).
32. `M403~GRW`: Sprouting Coupling Lock (ગ્રોથ મિકેનિઝમ ધરાવતો લોક).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M404~CNT5`: Last Call Rejoin Arch (5 moves પછી બંધ થતી કમાન).
35. `M404~FRZ2`: Snowbound Rejoin Arch (થીજેલી રીજોઇન આર્ચ).
36. `M404~COL`: Painted Rejoin Arch (ચોક્કસ રંગની સ્પ્લિટ ટ્રેન માટેની આર્ચ).
37. `M404~FOG`: Steamy Rejoin Arch (ધુમ્મસમાં રીજોઇન આર્ચ).
38. `M404~CHN`: Linked Rejoin Arches (બે સમાંતર રીજોઇન આર્ચ).
39. `M404~PHS`: Phantom Rejoin Arch (ફેઝિંગ રીજોઇન આર્ચ).
40. `M404~ARM`: Iron-clad Rejoin Arch (આર્મ્ડ રીજોઇન આર્ચ).
41. `M404~MIR`: Looking-glass Rejoin Arch (મિરર રીજોઇન આર્ચ).
42. `M404~LAY`: Deck Rejoin Arch (ડેક લેયર પરની કમાન).
43. `M404~GRW`: Sprouting Rejoin Arch (વેલથી વીંટળાયેલી કમાન).
44. `M045~CHN`: Linked Master Gear Splitter (લિંક્ડ ગિયર સ્પ્લિટ કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
