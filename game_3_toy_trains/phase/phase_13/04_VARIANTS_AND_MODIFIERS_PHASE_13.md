# 04 · Variants & Modifiers Phase 13 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 13 ના 45 variant slots, Weather Station Hidden Info આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_6001_6500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Weather Fog Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી ધુમ્મસ કાયમી છવાઈ જાય છે અથવા લેન્ટર્ન બુઝાઈ જાય છે. | M601, M602, M603, M604 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ સ્કાઉટ ટ્રેન ચાલી શકે છે કે લેન્ટર્ન પ્રગટે છે. | M601, M602, M603, M604 |
| `Colored` | ચોક્કસ રંગની ટ્રેન જ લેન્ટર્ન પ્લેટને સક્રિય કરી શકે છે. | M601, M602, M603, M604 |
| `Fogged` | પહેલેથી જ ધુમ્મસિયા સેલ પર વધારાનું ડબલ-ડેન્સિટી સ્ટીમ ક્લાઉડ. | All M60x |
| `Chained` | બે સ્કાઉટ ટ્રેનો અથવા બે લેન્ટર્ન પ્લેટ્સ એકસાથે લિન્ક રહે છે. | M601, M602, M604 |
| `Phasing` | માત્ર Even moves પર જ મિરાજ ટ્રેન કે ફોલ્સ વોલ દેખાય છે. | M601, M602, M603, M604 |
| `Armored` | ક્રેનથી સ્કાઉટ હેન્ડકાર્ટ કે લેન્ટર્નને હટાવી શકાતા નથી. | M601, M602, M603, M604 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ ધુમ્મસ કવરેજ. | M601, M602, M603, M604 |
| `Mirrored` | મિરર અક્ષ પર ઉલટા પ્રતિબિંબિત સ્થાને ધુમ્મસ સાફ થાય છે. | M601, M602, M603, M604 |
| `Growing` | સમય જતાં ધુમ્મસ ખાલી પાડોશી સેલ્સમાં વિસ્તરે છે. | M601, M602, M603, M604 |

---

## 2. 45 Variant Slots Definition
1. `M601~CNT5`: Last Call Scout (5 moves સુધી જ સ્કાઉટિંગ પાવર ધરાવતી ટ્રેન).
2. `M601~FRZ2`: Snowbound Scout Draisine (થીજેલી સ્કાઉટ હેન્ડકાર્ટ).
3. `M601~COL`: Painted Scout Draisine (ચોક્કસ રંગની સ્કાઉટ ટ્રેન).
4. `M601~FOG`: Steamy Scout Draisine (ધુમ્મસમાં ઢંકાયેલી સ્કાઉટ કાર).
5. `M601~CHN`: Linked Scout Draisines (જોડાયેલી જોડિયા સ્કાઉટ ટ્રેનો).
6. `M601~PHS`: Phantom Scout Draisine (ફેઝિંગ સ્કાઉટ કાર).
7. `M601~ARM`: Iron-clad Scout Draisine (આર્મ્ડ સ્કાઉટ ટ્રેન).
8. `M601~LAY`: Deck Scout Draisine (ડેક લેવલ પર દોડતી સ્કાઉટ).
9. `M601~MIR`: Looking-glass Scout Draisine (પ્રતિબિંબિત સ્કાઉટ પાથ).
10. `M601~GRW`: Sprouting Scout Path (વેલ વચ્ચે દોડતી સ્કાઉટ કાર).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M602~CNT5`: Last Call Mirage (5 moves પછી અદૃશ્ય થતી મિરાજ ટ્રેન).
13. `M602~FRZ2`: Snowbound Mirage Steam (થીજેલું મિરાજ ક્લાઉડ).
14. `M602~COL`: Painted Mirage Steam (ચોક્કસ રંગનો આભાસ કરાવતો ક્લાઉડ).
15. `M602~FOG`: Steamy Mirage Cloud (ગાઢ સ્ટીમ ક્લાઉડ).
16. `M602~CHN`: Linked Mirage Steams (બે જોડિયા મિરાજ વાદળો).
17. `M602~PHS`: Phantom Mirage Steam (ફેઝિંગ મિરાજ ક્લાઉડ).
18. `M602~ARM`: Iron-clad Mirage Steam (આર્મ્ડ મિરાજ ક્લાઉડ).
19. `M602~LAY`: Deck Mirage Steam (ડેક લેયર પરનું મિરાજ).
20. `M602~MIR`: Looking-glass Mirage (મિરર મિરાજ ક્લાઉડ).
21. `M602~GRW`: Sprouting Mirage Cloud (વેલ ફેલાવતું મિરાજ ક્લાઉડ).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M603~CNT5`: Last Call Painted Backdrop (5 moves પછી વાસ્તવિક દીવાલ બનતી વાડ).
24. `M603~FRZ2`: Snowbound Painted Backdrop (થીજેલી ફોલ્સ વાડ).
25. `M603~COL`: Painted False Wall (ચોક્કસ રંગની ટ્રેન માટે જ આરપાર નીકળતી વાડ).
26. `M603~FOG`: Steamy Painted Backdrop (ધુમ્મસમાં છુપાયેલી વાડ).
27. `M603~CHN`: Linked False Walls (બે જોડાયેલી ફોલ્સ વાડ).
28. `M603~PHS`: Phantom False Wall (ફેઝિંગ ફોલ્સ વાડ).
29. `M603~ARM`: Iron-clad False Wall (આર્મ્ડ ફોલ્સ દીવાલ).
30. `M603~LAY`: Deck False Wall (ડેક લેયર પરની વાડ).
31. `M603~MIR`: Looking-glass False Wall (મિરર ફોલ્સ વાડ).
32. `M603~GRW`: Sprouting False Wall (વેલથી ઢંકાયેલી ફોલ્સ વાડ).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M604~CNT5`: Last Call Lantern Plate (5 moves પછી બુઝાઈ જતી લેન્ટર્ન પ્લેટ).
35. `M604~FRZ2`: Snowbound Lantern Plate (થીજેલી લેન્ટર્ન પ્લેટ).
36. `M604~COL`: Painted Lantern Plate (ચોક્કસ રંગની ટ્રેનથી જ પ્રકાશતી પ્લેટ).
37. `M604~FOG`: Steamy Lantern Plate (ધુમ્મસમાં ઢંકાયેલી લેન્ટર્ન પ્લેટ).
38. `M604~CHN`: Linked Lantern Plates (સાથે પ્રકાશતી જોડિયા પ્લેટ્સ).
39. `M604~PHS`: Phantom Lantern Plate (ફેઝિંગ લેન્ટર્ન પ્લેટ).
40. `M604~ARM`: Iron-clad Lantern Plate (આર્મ્ડ લેન્ટર્ન પ્લેટ).
41. `M604~MIR`: Looking-glass Lantern Plate (મિરર લેન્ટર્ન પ્લેટ).
42. `M604~LAY`: Deck Lantern Plate (ડેક પર આવેલી લેન્ટર્ન પ્લેટ).
43. `M604~GRW`: Sprouting Lantern Plate (વેલવાળી લેન્ટર્ન પ્લેટ).
44. `M045~CHN`: Linked Master Gear Light (લિંક્ડ ગિયર લાઇટ કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
