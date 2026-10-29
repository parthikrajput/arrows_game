# 04 · Variants & Modifiers Phase 15 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 15 ના 45 variant slots, Moving Platforms Conveyors આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 15 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_7001_7500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Conveyor Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી કન્વેયર બેલ્ટ બંધ થઈ જાય છે અથવા સ્વિચ આપોઆપ ફ્લિપ થાય છે. | M701, M702, M703, M704 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ કન્વેયર મોટર અનફ્રીઝ થાય છે. | M701, M702, M703, M704 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ બેલ્ટ સ્વિચ વાપરી શકે છે. | M701, M702, M703, M704 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો બેલ્ટ જંકશન કે સ્ટોપ લીવર. | All M70x |
| `Chained` | બે બેલ્ટ સ્વિચ અથવા બે રિવર્સિંગ લીવર્સ જોડાયેલા રહે છે. | M701, M702, M703 |
| `Phasing` | માત્ર Even moves પર જ કન્વેયર બેલ્ટ સક્રિય ગતિ ધરાવે છે. | M701, M702, M703, M704 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી બેલ્ટ મિકેનિઝમને નુકસાન કરી શકાતું નથી. | M701, M702, M703, M704 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ મોટરાઇઝ્ડ કન્વેયર્સ. | M701, M702, M703, M704 |
| `Mirrored` | પ્રતિબિંબિત અક્ષ પર કન્વેયરનો પ્રવાહ વિરુદ્ધ દિશામાં વહે છે. | M701, M702, M703, M704 |
| `Growing` | કન્વેયર ટ્રેકની આસપાસ અવરોધક વેલ વિસ્તરે છે. | M701, M702, M703, M704 |

---

## 2. 45 Variant Slots Definition
1. `M701~CNT5`: Last Call Belt Switch (5 moves સુધી જ સ્વિચિંગ શક્ય રહે છે).
2. `M701~FRZ2`: Snowbound Belt Switch (થીજેલો બેલ્ટ જંકશન).
3. `M701~COL`: Painted Belt Switch (ચોક્કસ રંગની ટ્રેન માટેનો સ્વિચ).
4. `M701~FOG`: Steamy Belt Switch (ધુમ્મસમાં બેલ્ટ સ્વિચ).
5. `M701~CHN`: Linked Belt Switches (બે જોડાયેલા બેલ્ટ સ્વિચ).
6. `M701~PHS`: Phantom Belt Switch (ફેઝિંગ બેલ્ટ જંકશન).
7. `M701~ARM`: Iron-clad Belt Switch (આર્મ્ડ બેલ્ટ સ્વિચ).
8. `M701~LAY`: Deck Belt Switch (ડેક લેવલ પરનો બેલ્ટ સ્વિચ).
9. `M701~MIR`: Looking-glass Belt Switch (પ્રતિબિંબિત દિશામાં સ્વિચ થતો બેલ્ટ).
10. `M701~GRW`: Sprouting Belt Junction (વેલથી ઘેરાયેલો સ્વિચ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M702~CNT5`: Last Call Reversing Belt (5 moves પછી રિવર્સલ લોક થાય છે).
13. `M702~FRZ2`: Snowbound Reversing Belt (થીજેલો રિવર્સિંગ બેલ્ટ).
14. `M702~COL`: Painted Reversing Belt (ચોક્કસ રંગીન રિવર્સિંગ બેલ્ટ).
15. `M702~FOG`: Steamy Reversing Belt (ધુમ્મસમાં રિવર્સિંગ ટ્રેક).
16. `M702~CHN`: Linked Reversing Belts (સાથે રિવર્સ થતા બેવડા બેલ્ટ્સ).
17. `M702~PHS`: Phantom Reversing Belt (ફેઝિંગ રિવર્સિંગ બેલ્ટ).
18. `M702~ARM`: Iron-clad Reversing Lever (આર્મ્ડ રિવર્સિંગ લીવર).
19. `M702~LAY`: Deck Reversing Belt (ડેક લેયર પરનો રિવર્સિંગ બેલ્ટ).
20. `M702~MIR`: Looking-glass Reverser (મિરર રિવર્સિંગ બેલ્ટ).
21. `M702~GRW`: Sprouting Reversing Track (વેલવાળો રિવર્સિંગ બેલ્ટ).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M703~CNT5`: Last Call Stop Lever (5 moves સુધી જ બ્રેક લાગુ કરી શકાય છે).
24. `M703~FRZ2`: Snowbound Stop Lever (થીજેલો સ્ટોપ લીવર).
25. `M703~COL`: Painted Stop Lever (ચોક્કસ રંગની ટ્રેન માટેનો લીવર).
26. `M703~FOG`: Steamy Stop Lever (ધુમ્મસમાં સ્ટોપ લીવર).
27. `M703~CHN`: Linked Stop Levers (બે લિન્ક્ડ સ્ટોપ લીવર્સ).
28. `M703~PHS`: Phantom Stop Lever (ફેઝિંગ સ્ટોપ લીવર).
29. `M703~ARM`: Iron-clad Stop Lever (આર્મ્ડ બ્રેક લીવર).
30. `M703~LAY`: Deck Stop Lever (ડેક પર આવેલો સ્ટોપ લીવર).
31. `M703~MIR`: Looking-glass Stop Lever (મિરર સ્ટોપ લીવર).
32. `M703~GRW`: Sprouting Belt Brake (વેલથી ઢંકાયેલો લીવર).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M704~CNT5`: Last Call Loop Belt (5 moves પછી લૂપમાંથી બહાર નીકળવું ફરજિયાત).
35. `M704~FRZ2`: Snowbound Loop Belt (થીજેલો કન્વેયર રીંગ).
36. `M704~COL`: Painted Loop Belt (ચોક્કસ રંગનો લૂપ બેલ્ટ).
37. `M704~FOG`: Steamy Loop Belt (ધુમ્મસમાં લૂપ બેલ્ટ).
38. `M704~CHN`: Linked Loop Belts (જોડાયેલા બે લૂપ રીંગ્સ).
39. `M704~PHS`: Phantom Loop Belt (ફેઝિંગ લૂપ બેલ્ટ).
40. `M704~ARM`: Iron-clad Loop Ring (આર્મ્ડ લૂપ બેલ્ટ).
41. `M704~MIR`: Looking-glass Loop Belt (મિરર લૂપ રીંગ).
42. `M704~LAY`: Deck Loop Belt (ડેક લેવલ પરનો લૂપ બેલ્ટ).
43. `M704~GRW`: Sprouting Loop Belt (વેલવાળો લૂપ બેલ્ટ).
44. `M045~CHN`: Linked Master Gear Motor (લિંક્ડ ગિયર મોટર કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
