# 04 · Variants & Modifiers Phase 19 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 19 ના 45 variant slots, Remix B આધારિત Combo Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_9001_9500.md)

---

## 1. 10 Standard Modifiers Compatibility & Remix Stacking
> [!NOTE]
> SCALING §8.2 મુજબ, Remix Phases (18–20) માં જરૂર પડ્યે **મહત્તમ 2 મોડિફાયર્સ (Stacking)** એક સાથે એક જ ઇન્સ્ટન્સ પર લાગુ થઈ શકે છે (દા.ત. `Frozen + Colored` અથવા `Countdown + Armored`).

| Modifier | Remix B Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી રોટર લોક થાય છે અથવા બ્રિજ ગેટ આપોઆપ ખુલે છે. | M901, M902, M903, M904 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ સીડ વેગન કે સ્પ્લિટ પ્રૂનર કાર્યરત બને છે. | M901, M902, M903, M904 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ રોટેટિંગ કપલિંગ પેડ પર જોડાઈ શકે છે. | M901, M902, M903, M904 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો ટર્નટેબલ કે ક્રોસ-ટેબલ ગેટ. | All M90x |
| `Chained` | બે રોટેટિંગ પેડ્સ અથવા બે સ્પ્લિટ પ્રૂનર્સ એકસાથે લિન્ક રહે છે. | M901, M902, M904 |
| `Phasing` | માત્ર Even moves પર જ બ્રિજ ગેટ કે સીડ વેગન પાટા પર ભૌતિક રૂપે હાજર રહે છે. | M901, M902, M903, M904 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી રોટેટિંગ યાર્ડ કે પ્રૂનરને હટાવી શકાતા નથી. | M901, M902, M903, M904 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ મિડ-એરા ફ્યુઝન મિકેનિક્સ. | M901, M902, M903, M904 |
| `Mirrored` | પ્રતિબિંબિત અક્ષ પર વિરુદ્ધ દિશામાં રોટેટ થતા યાર્ડ્સ. | M901, M902, M903, M904 |
| `Growing` | મિકેનિઝમની આસપાસ સમય જતાં વેલ અને પથ્થરો વિસ્તરે છે. | M901, M902, M903, M904 |

---

## 2. 45 Variant Slots Definition
1. `M901~CNT5`: Last Call Rotating Coupler (5 moves સુધી જ રોટેટ થતો યાર્ડ).
2. `M901~FRZ2`: Snowbound Rotating Coupler (થીજેલો રોટેટિંગ યાર્ડ).
3. `M901~COL`: Painted Turntable Coupler (ચોક્કસ રંગની ટ્રેન માટેનો યાર્ડ).
4. `M901~FOG`: Steamy Rotating Coupler (ધુમ્મસમાં રોટેટિંગ યાર્ડ).
5. `M901~CHN`: Linked Turntable Couplers (બે જોડાયેલા રોટેટિંગ યાર્ડ્સ).
6. `M901~PHS`: Phantom Rotating Coupler (ફેઝિંગ રોટેટિંગ યાર્ડ).
7. `M901~ARM`: Iron-clad Rotating Coupler (આર્મ્ડ રોટેટિંગ યાર્ડ).
8. `M901~LAY`: Deck Turntable Coupler (ડેક લેવલ પરનો રોટેટિંગ યાર્ડ).
9. `M901~MIR`: Looking-glass Coupler (પ્રતિબિંબિત રોટેટિંગ યાર્ડ).
10. `M901~GRW`: Sprouting Rotating Coupler (વેલવાળો રોટેટિંગ યાર્ડ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M902~CNT5`: Last Call Incline Seed (5 moves પછી બીજ વાવવાનું બંધ કરતી ટ્રેન).
13. `M902~FRZ2`: Snowbound Incline Seed (થીજેલી સીડ વેગન).
14. `M902~COL`: Painted Incline Seed (ચોક્કસ રંગની સીડ વેગન).
15. `M902~FOG`: Steamy Incline Seed (ધુમ્મસમાં સરકતી સીડ વેગન).
16. `M902~CHN`: Linked Incline Seeders (જોડાયેલી જોડિયા સીડ વેગન્સ).
17. `M902~PHS`: Phantom Incline Seed (ફેઝિંગ સીડ વેગન).
18. `M902~ARM`: Iron-clad Incline Seeder (આર્મ્ડ સીડ વેગન).
19. `M902~LAY`: Deck Incline Seed Wagon (ડેક લેયર પરની સીડ વેગન).
20. `M902~MIR`: Looking-glass Seed Wagon (મિરર સીડ વેગન).
21. `M902~GRW`: Sprouting Incline Seeder (વેલવાળી સીડ વેગન).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M903~CNT5`: Last Call Table Metronome (5 moves પછી કાયમી ખુલ્લો રહેતો ગેટ).
24. `M903~FRZ2`: Snowbound Table Metronome (થીજેલો ટેબલ મેટ્રોનોમ).
25. `M903~COL`: Painted Table Metronome (ચોક્કસ રંગની ટ્રેન માટેનો ગેટ).
26. `M903~FOG`: Steamy Table Metronome (ધુમ્મસમાં ટેબલ મેટ્રોનોમ).
27. `M903~CHN`: Linked Table Metronomes (બે લિન્ક્ડ ટેબલ મેટ્રોનોમ્સ).
28. `M903~PHS`: Phantom Table Metronome (ફેઝિંગ ટેબલ મેટ્રોનોમ).
29. `M903~ARM`: Iron-clad Table Metronome (આર્મ્ડ ટેબલ મેટ્રોનોમ).
30. `M903~LAY`: Deck Table Metronome (ડેક પર આવેલો ટેબલ મેટ્રોનોમ).
31. `M903~MIR`: Looking-glass Metronome (મિરર ટેબલ મેટ્રોનોમ).
32. `M903~GRW`: Sprouting Table Metronome (વેલવાળો ટેબલ મેટ્રોનોમ).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M904~CNT5`: Last Call Trimming Split (5 moves સુધી જ પ્રૂન કરતી ટ્રેન).
35. `M904~FRZ2`: Snowbound Trimming Split (થીજેલી સ્પ્લિટ પ્રૂનર ટ્રેન).
36. `M904~COL`: Painted Trimming Split (ચોક્કસ રંગની પ્રૂનર ટ્રેન).
37. `M904~FOG`: Steamy Trimming Split (ધુમ્મસમાં પ્રૂનર ટ્રેન).
38. `M904~CHN`: Linked Trimming Splits (જોડાયેલા બે પ્રૂનર્સ).
39. `M904~PHS`: Phantom Trimming Split (ફેઝિંગ પ્રૂનર ટ્રેન).
40. `M904~ARM`: Iron-clad Trimming Split (આર્મ્ડ પ્રૂનર ટ્રેન).
41. `M904~MIR`: Looking-glass Trimming Split (મિરર પ્રૂનર ટ્રેન).
42. `M904~LAY`: Deck Trimming Split (ડેક લેયર પરની પ્રૂનર ટ્રેન).
43. `M904~GRW`: Sprouting Trimming Split (વેલવાળી પ્રૂનર ટ્રેન).
44. `M045~CHN`: Linked Master Gear Pruner (લિંક્ડ ગિયર પ્રૂનર કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).

