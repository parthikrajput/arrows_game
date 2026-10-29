# 04 · Variants & Modifiers Phase 14 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 14 ના 45 variant slots, Alpine Pass Mirror Worlds આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_6501_7000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Alpine Mirror Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી મિરર અક્ષ તૂટે છે અથવા ગ્લેશિયર લોક કાયમી ખુલે છે. | M651, M652, M653, M654 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ મિરર ટ્વિન અનફ્રીઝ થાય છે. | M651, M652, M653, M654 |
| `Colored` | માત્ર ચોક્કસ રંગની જોડિયા ટ્રેન જ મિરર અક્ષ સાથે જોડાઈ શકે છે. | M651, M652, M653, M654 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલી મિરર ટ્રેન કે ગ્લેશિયર લોક. | All M65x |
| `Chained` | બે અલગ મિરર જોડીઓ એકબીજા સાથે સાંકળથી જોડાયેલી છે. | M651, M652, M653 |
| `Phasing` | માત્ર Even moves પર જ મિરર રિફ્લેક્શન સક્રિય બને છે. | M651, M652, M653, M654 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી ગ્લેશિયર લોક કે રિવર્સ એન્જિન હટાવી શકાતા નથી. | M651, M652, M653, M654 |
| `Layered` | ઉપલા ડેક અથવા ગ્રાઉન્ડ લેયર પર અલગ મિરરિંગ અક્ષ. | M651, M652, M653, M654 |
| `Mirrored` | ડબલ મિરરિંગ (અરીસાની અંદર અરીસો — ફરીથી મૂળ દિશા ધારણ કરે). | M651, M652, M653, M654 |
| `Growing` | ગ્લેશિયર અક્ષની બંને બાજુએ સપ્રમાણ વેલનું વિસ્તરણ. | M651, M652, M653, M654 |

---

## 2. 45 Variant Slots Definition
1. `M651~CNT5`: Last Call Mirror Axis (5 moves સુધી જ મિરર સિન્ક જાળવતી ટ્રેન).
2. `M651~FRZ2`: Snowbound Mirror Axis (થીજેલી મિરર જોડી ટ્રેન).
3. `M651~COL`: Painted Mirror Axis (ચોક્કસ રંગની મિરર ટ્રેન).
4. `M651~FOG`: Steamy Mirror Axis (ધુમ્મસમાં ઢંકાયેલી મિરર ટ્રેન).
5. `M651~CHN`: Linked Mirror Axes (જોડાયેલી બેવડી મિરર જોડીઓ).
6. `M651~PHS`: Phantom Mirror Axis (ફેઝિંગ મિરર અક્ષ).
7. `M651~ARM`: Iron-clad Mirror Axis (આર્મ્ડ મિરર ટ્રેન).
8. `M651~LAY`: Deck Mirror Axis (ડેક લેવલ પરની મિરર જોડી).
9. `M651~MIR`: Looking-glass Double Mirror (ડબલ મિરર ટ્રેક).
10. `M651~GRW`: Sprouting Mirror Ridge (વેલવાળી મિરર અક્ષ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M652~CNT5`: Last Call Reflection Lock (5 moves પછી આપોઆપ ખુલતો લોક).
13. `M652~FRZ2`: Snowbound Reflection Lock (થીજેલો ગ્લેશિયર લોક).
14. `M652~COL`: Painted Reflection Barrier (ચોક્કસ રંગીન બેરિયર).
15. `M652~FOG`: Steamy Reflection Lock (ધુમ્મસમાં ગ્લેશિયર લોક).
16. `M652~CHN`: Linked Reflection Locks (સાથે ખુલતા-બંધ થતા જોડી લોક્સ).
17. `M652~PHS`: Phantom Reflection Lock (ફેઝિંગ ગ્લેશિયર લોક).
18. `M652~ARM`: Iron-clad Reflection Lock (આર્મ્ડ ગ્લેશિયર બેરિયર).
19. `M652~LAY`: Deck Reflection Lock (ડેક લેયર પરનો લોક).
20. `M652~MIR`: Looking-glass Lock (મિરર લોક).
21. `M652~GRW`: Sprouting Glacier Lock (વેલથી ઢંકાયેલો લોક).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M653~CNT5`: Last Call Twin Yard (5 moves પછી સામાન્ય યાર્ડ બનતો ઝોન).
24. `M653~FRZ2`: Snowbound Alpine Yard (થીજેલો મિરર યાર્ડ).
25. `M653~COL`: Painted Twin Yard (ચોક્કસ રંગનો મિરર યાર્ડ).
26. `M653~FOG`: Steamy Twin Yard (ધુમ્મસમાં મિરર યાર્ડ).
27. `M653~CHN`: Linked Alpine Yards (બે લિન્ક્ડ યાર્ડ્સ).
28. `M653~PHS`: Phantom Twin Yard (ફેઝિંગ યાર્ડ).
29. `M653~ARM`: Iron-clad Twin Yard (આર્મ્ડ યાર્ડ પ્લેટ).
30. `M653~LAY`: Deck Alpine Yard (ડેક પરનો યાર્ડ).
31. `M653~MIR`: Looking-glass Yard Splay (મિરર સ્પ્લે યાર્ડ).
32. `M653~GRW`: Sprouting Twin Yard (વેલવાળો યાર્ડ).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M654~CNT5`: Last Call Reverse Engine (5 moves સુધી જ રિવર્સ ચાલતી ટ્રેન).
35. `M654~FRZ2`: Snowbound Reverse Engine (થીજેલું રિવર્સ એન્જિન).
36. `M654~COL`: Painted Reverse Engine (ચોક્કસ રંગનું રિવર્સ એન્જિન).
37. `M654~FOG`: Steamy Reverse Engine (ધુમ્મસમાં રિવર્સ એન્જિન).
38. `M654~CHN`: Linked Reverse Engines (જોડાયેલા બે રિવર્સ એન્જિન્સ).
39. `M654~PHS`: Phantom Reverse Engine (ફેઝિંગ રિવર્સ એન્જિન).
40. `M654~ARM`: Iron-clad Reverse Engine (આર્મ્ડ રિવર્સ એન્જિન).
41. `M654~MIR`: Looking-glass Inversion Path (ડબલ ઇન્વર્ઝન પાથ).
42. `M654~LAY`: Deck Reverse Engine (ડેક લેયર પરનું રિવર્સ એન્જિન).
43. `M654~GRW`: Sprouting Reverse Engine (વેલથી વીંટળાયેલું એન્જિન).
44. `M045~CHN`: Linked Master Gear Reflection (લિંક્ડ ગિયર મિરર કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
