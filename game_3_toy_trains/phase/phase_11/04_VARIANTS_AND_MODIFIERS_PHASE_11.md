# 04 · Variants & Modifiers Phase 11 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 11 ના 45 variant slots, Twin Tables આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 11 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_5001_5500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Twin Table Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી ટેબલ બ્રિજ બંધ થાય છે અથવા રિલે ટનલ બ્લોક થાય છે. | M501, M502, M503, M504 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થયા પછી જ પુલ કે ક્રોસ ટિકિટ કાર્યરત બને છે. | M501, M502, M503, M504 |
| `Colored` | ચોક્કસ રંગની ટ્રેન જ બ્રિજ પાર કરી શકે છે અથવા રિલે ટનલ વાપરી શકે છે. | M501, M502, M503, M504 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો બ્રિજ અથવા બીજા ટેબલનું ટનલ મુખ. | All M50x |
| `Chained` | બે ટેબલ બ્રિજ એકસાથે ખુલે છે અથવા બે ટિકિટ્સ સાથે કલેક્ટ કરવી પડે છે. | M501, M502, M503 |
| `Phasing` | માત્ર Even moves પર જ બ્રિજ કે મિરર ટ્રેન હાજર રહે છે. | M501, M502, M503, M504 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી ક્રોસ-બોર્ડ ટિકિટ ગેટને તોડી શકાતો નથી. | M501, M502, M503, M504 |
| `Layered` | ઉપલા ડેક પરથી બીજા ટેબલના ડેક પર સીધો પુલ. | M501, M502, M503, M504 |
| `Mirrored` | મિરર અક્ષ પર ઉલટી દિશામાં પુલ કે ટનલ જોડાણ. | M501, M502, M503, M504 |
| `Growing` | પુલના મુખ આગળ અવરોધક વેલ વિસ્તરે છે. | M501, M502, M503, M504 |

---

## 2. 45 Variant Slots Definition
1. `M501~CNT5`: Last Call Table Bridge (5 moves પછી બંધ થઈ જતો ક્રોસ-ટેબલ પુલ).
2. `M501~FRZ2`: Snowbound Table Bridge (2 ટ્રેન એક્ઝિટ પછી કાર્યરત થતો પુલ).
3. `M501~COL`: Painted Table Bridge (ચોક્કસ રંગની ટ્રેન માટેનો પુલ).
4. `M501~FOG`: Steamy Table Bridge (ધુમ્મસમાં ઢંકાયેલો ક્રોસ બ્રિજ).
5. `M501~CHN`: Linked Table Bridges (બે સમાંતર લિન્ક્ડ પુલો).
6. `M501~PHS`: Phantom Table Bridge (ફેઝિંગ બોર્ડ બ્રિજ).
7. `M501~ARM`: Iron-clad Table Bridge (તોડી ન શકાય તેવો મજબૂત પુલ).
8. `M501~LAY`: Deck Table Bridge (ડેક લેવલ પરનો પુલ).
9. `M501~MIR`: Looking-glass Table Bridge (પ્રતિબિંબિત પુલ એજ).
10. `M501~GRW`: Sprouting Bridge Pier (વેલથી વીંટળાયેલો પુલ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M502~CNT5`: Last Call Cross Ticket (5 moves સુધી જ માન્ય ટિકિટ).
13. `M502~FRZ2`: Snowbound Cross Ticket (થીજેલી ક્રોસ ટિકિટ).
14. `M502~COL`: Painted Cross Ticket (ચોક્કસ રંગની ટ્રેન માટેની ટિકિટ).
15. `M502~FOG`: Steamy Cross Ticket (ધુમ્મસમાં છુપાયેલી ટિકિટ).
16. `M502~CHN`: Linked Cross Tickets (જોડાયેલી બેવડી ટિકિટ્સ).
17. `M502~PHS`: Phantom Cross Ticket (ફેઝિંગ ટિકિટ).
18. `M502~ARM`: Iron-clad Ticket Barrier (આર્મ્ડ ટિકિટ ગેટ).
19. `M502~LAY`: Deck Cross Ticket (ડેક લેયર પરની ટિકિટ).
20. `M502~MIR`: Looking-glass Cross Ticket (મિરર પોઝિશન ટિકિટ).
21. `M502~GRW`: Sprouting Ticket Gate (વેલવાળો ટિકિટ ગેટ).
22. `M013~FRZ2`: Snowbound Rotary Junction (થીજેલું ટર્નટેબલ).
23. `M503~CNT5`: Last Call Mirror Table (5 moves પછી મિરર કનેક્શન તૂટે છે).
24. `M503~FRZ2`: Snowbound Mirror Train (બરફ મુક્ત મિરર ટ્રેન).
25. `M503~COL`: Painted Mirror Train (ચોક્કસ રંગની જોડિયા ટ્રેન).
26. `M503~FOG`: Steamy Mirror Train (ધુમ્મસમાં જોડિયા ટ્રેન).
27. `M503~CHN`: Linked Mirror Trains (બે જોડી મિરર ટ્રેનો).
28. `M503~PHS`: Phantom Mirror Train (ફેઝિંગ મિરર ટ્રેન).
29. `M503~ARM`: Iron-clad Mirror Train (આર્મ્ડ જોડિયા એન્જિન).
30. `M503~LAY`: Deck Mirror Table (ડેક પર મિરર થતી ટ્રેન).
31. `M503~MIR`: Looking-glass Inversion (ડબલ મિરર ટ્રેન).
32. `M503~GRW`: Sprouting Mirror Track (વેલ વચ્ચે દોડતી મિરર ટ્રેન).
33. `M018~FOG`: Steamy Branch Switch (ધુમ્મસિયું સ્વિચ).
34. `M504~CNT5`: Last Call Relay Tunnel (5 moves પછી બંધ થતી ટનલ).
35. `M504~FRZ2`: Snowbound Relay Tunnel (થીજેલું ટનલ મુખ).
36. `M504~COL`: Painted Relay Tunnel (ચોક્કસ રંગની ટનલ).
37. `M504~FOG`: Steamy Relay Tunnel (ધુમ્મસમાં ટનલ).
38. `M504~CHN`: Linked Relay Tunnels (બે જોડાયેલી રિલે ટનલ્સ).
39. `M504~PHS`: Phantom Relay Tunnel (ફેઝિંગ રિલે પોર્ટલ).
40. `M504~ARM`: Iron-clad Relay Mouth (આર્મ્ડ ટનલ મુખ).
41. `M504~MIR`: Looking-glass Relay Tunnel (મિરર રિલે ટનલ).
42. `M504~LAY`: Deck Relay Tunnel (ડેક પરથી ગ્રાઉન્ડ રિલે ટનલ).
43. `M504~GRW`: Sprouting Relay Mouth (વેલથી ઢંકાયેલું ટનલ મુખ).
44. `M045~CHN`: Linked Master Gear Bridge (લિંક્ડ ગિયર બ્રિજ સિસ્ટમ).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
