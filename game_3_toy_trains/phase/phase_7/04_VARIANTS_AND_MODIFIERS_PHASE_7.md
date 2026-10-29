# 04 · Variants & Modifiers Phase 7 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 7 ના 45 variant slots, રોટેશનલ ફિઝિક્સ આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Rotation Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી યાર્ડ રોટેશન કાયમી લોક કે અનલૉક થાય છે. | M301, M302, M303, M304 |
| `Frozen(K)` | બરફ પીગળ્યા પછી જ 4×4 રોટર ફરી શકે છે. | M301, M302, M303, M304 |
| `Colored` | ચોક્કસ રંગની ટ્રેન યાર્ડમાં હોય ત્યારે જ રોટેશન સંભવ બને છે. | M301, M302, M303, M304 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો રોટેટિંગ યાર્ડ. | All M30x |
| `Chained` | બે રોટેટિંગ યાર્ડ્સ એકસાથે 90° CW ફરે છે. | M301, M302, M303 |
| `Phasing` | માત્ર Even moves પર જ રોટેશન શક્ય બને છે. | M301, M302, M303, M304 |
| `Armored` | ક્રેનથી અપ્રભાવિત રહે છે. | M301, M302, M303, M304 |
| `Layered` | ડેક અથવા વાયાડક્ટ સ્તર પર રોટેશન મર્યાદિત રહે છે. | M301, M302, M303, M304 |
| `Mirrored` | રોટેશન ક્લોકવાઇઝના બદલે કાઉન્ટર-ક્લોકવાઇઝ (CCW) થાય છે. | M301, M302, M303, M304 |
| `Growing` | moves સાથે રોટરની કિનારી પર વેલ ચડે છે. | M301, M302, M303, M304 |

---

## 2. 45 Variant Slots Definition
1. `M301~CNT5`: Last Call Yard Block (5 moves પછી કાયમી લોક થતો યાર્ડ).
2. `M301~FRZ2`: Snowbound Yard Block (2 ટ્રેન નીકળ્યા પછી બરફ મુક્ત).
3. `M301~COL`: Painted Yard Block (ચોક્કસ રંગીન ટ્રેન સાથે જ ફરે).
4. `M301~FOG`: Steamy Yard Block (ધુમ્મસમાં ઢંકાયેલો યાર્ડ).
5. `M301~CHN`: Linked Rotating Yards (બે જોડાયેલા 4×4 યાર્ડ્સ).
6. `M301~PHS`: Phantom Yard Block (ફેઝિંગ યાર્ડ).
7. `M301~ARM`: Iron-clad Yard Rotor (તોડી ન શકાય તેવો રોટર).
8. `M301~LAY`: Deck Yard Block (ડેક પરનો યાર્ડ).
9. `M301~MIR`: Looking-glass Yard Block (CCW ઉલટું ફરતું યાર્ડ).
10. `M301~GRW`: Sprouting Yard Edge (વેલવાળો યાર્ડ).
11. `M001~CNT6`: Last Call Rotating Buffer (ટાઈમર બફર સ્ટોપ).
12. `M302~CNT5`: Last Call Spinning Exit (5 moves પછી સ્થિર થતી એક્ઝિટ).
13. `M302~COL`: Painted Spinning Exit (ચોક્કસ રંગીન ટ્રેન જ બહાર જઈ શકે).
14. `M302~FOG`: Steamy Spinning Exit (ધુમ્મસમાં ફરતી એક્ઝિટ).
15. `M302~CHN`: Linked Spinning Exits (બે એક્ઝિટ્સ એકસાથે ફરે).
16. `M302~PHS`: Phantom Spinning Exit (ફેઝિંગ એક્ઝિટ ગેપ).
17. `M302~LAY`: Deck Spinning Exit (ડેક લેવલ પર ફરતી એક્ઝિટ).
18. `M302~MIR`: Looking-glass Spinning Exit (CCW ફરતી એક્ઝિટ).
19. `M302~FRZ1`: Snowbound Spinning Exit (થીજેલી એક્ઝિટ).
20. `M302~ARM`: Iron-clad Station Border (મજબૂત લોખંડી બોર્ડર).
21. `M302~GRW`: Sprouting Border Track (વેલવાળી કિનારી).
22. `M013~FRZ2`: Snowbound Turntable Shunt (થીજેલું ટર્નટેબલ).
23. `M303~CNT5`: Last Call Spinner Engine (5 moves પછી સ્પિનિંગ બંધ).
24. `M303~FRZ2`: Snowbound Spinner Engine (બરફ મુક્ત થયા પછી જ ફરે).
25. `M303~COL`: Painted Spinner Engine (ચોક્કસ રંગનું સ્પિનર એન્જિન).
26. `M303~FOG`: Steamy Spinner Engine (ધુમ્મસિયું સ્પિનર એન્જિન).
27. `M303~CHN`: Linked Spinner Engines (બે એન્જિન્સ એકસાથે 90° ફરે).
28. `M303~PHS`: Phantom Spinner Engine (ફેઝિંગ સ્પિનર).
29. `M303~ARM`: Iron-clad Spinner Engine (ક્રેન-અભેદ્ય સ્પિનર એન્જિન).
30. `M303~MIR`: Looking-glass Spinner (CCW ઉલટી દિશામાં ફરતું એન્જિન).
31. `M303~LAY`: Deck Spinner Engine (ડેક પરનું સ્પિનર એન્જિન).
32. `M303~GRW`: Sprouting Spinner Trail (વેલ છોડતું એન્જિન).
33. `M018~FOG`: Steamy Yard Switch (ધુમ્મસમાં સ્વિચ).
34. `M304~CNT6`: Last Call Turntable Lock (6 moves પછી આપોઆપ અનલૉક).
35. `M304~FRZ2`: Snowbound Turntable Lock (થીજેલું રોટેશન લોક).
36. `M304~COL`: Painted Turntable Lock (ચોક્કસ કલર કી ટ્રેનથી અનલૉક).
37. `M304~FOG`: Steamy Turntable Lock (ધુમ્મસમાં લૉક).
38. `M304~CHN`: Linked Turntable Locks (બે જોડાયેલા લૉક્સ).
39. `M304~PHS`: Phantom Turntable Lock (ફેઝિંગ લૉક).
40. `M304~ARM`: Iron-clad Turntable Lock (તોડી ન શકાય તેવું લૉક).
41. `M304~MIR`: Looking-glass Turntable Lock (મિરર લૉક).
42. `M304~LAY`: Deck Turntable Lock (ડેક પરનું લૉક).
43. `M304~GRW`: Sprouting Lock Post (વેલવાળો લૉક પોસ્ટ).
44. `M045~CHN`: Linked Master Gear Rotor (જોડાયેલા ગિયર રોટર્સ).
45. `M301~ARM`: Permanent Heavy Yard Rotor (કાયમી લોખંડી યાર્ડ રોટર).
