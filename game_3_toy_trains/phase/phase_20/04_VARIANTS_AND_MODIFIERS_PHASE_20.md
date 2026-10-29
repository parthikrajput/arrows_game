# 04 · Variants & Modifiers Phase 20 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 20 ના 45 variant slots, Grand Master Supreme Combos આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 20 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_9501_10000.md)

---

## 1. 10 Standard Modifiers Compatibility & Supreme Stacking
> [!NOTE]
> SCALING §8.2 મુજબ, Phase 20 માં **મહત્તમ 2 મોડિફાયર્સ (Stacking)** એક સાથે એક જ ઇન્સ્ટન્સ પર લાગુ થઈ શકે છે (દા.ત. `Frozen + Colored` અથવા `Countdown + Armored`).

| Modifier | Grand Master Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી કન્વેયર રીંગ ફ્લિપ થાય છે અથવા બ્લૂમ આર્ચ કાયમી લોક થાય છે. | M951, M952, M953, M954 |
| `Frozen(K)` | K ટ્રેનો એક્ઝિટ થાય પછી જ ગાર્ડિયન કે ગ્રેવિટી રીલે અનફ્રીઝ થાય છે. | M951, M952, M953, M954 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ માસ્ટર પાસ કે પ્રિઝમ આર્ચ સાથે જોડાઈ શકે છે. | M951, M952, M953, M954 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલો કન્વેયર ગાર્ડિયન કે ગ્રેવિટી રીલે. | All M95x |
| `Chained` | બે કન્વેયર ગાર્ડિયન્સ અથવા બે પ્રિઝમ બ્લૂમ્સ એકસાથે લિન્ક રહે છે. | M951, M952, M954 |
| `Phasing` | માત્ર Even moves પર જ ગાર્ડિયન રીંગ કે ગ્રેવિટી લીવર સક્રિય રહે છે. | M951, M952, M953, M954 |
| `Armored` | ક્રેન કે વિસ્ફોટકથી સુપ્રીમ મિકેનિઝમને નુકસાન કરી શકાતું નથી. | M951, M952, M953, M954 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ ગ્રાન્ડ માસ્ટર મિકેનિક્સ. | M951, M952, M953, M954 |
| `Mirrored` | પ્રતિબિંબિત અક્ષ પર વિરુદ્ધ દિશાઓમાં ગતિશીલ ગ્રેવિટી અને કન્વેયર્સ. | M951, M952, M953, M954 |
| `Growing` | મિકેનિઝમની આસપાસ સમય જતાં વેલ અને પથ્થરો વિસ્તરે છે. | M951, M952, M953, M954 |

---

## 2. 45 Variant Slots Definition
1. `M951~CNT5`: Last Call Conveyor Guardian (5 moves પછી સ્લિપ થતો ગાર્ડિયન).
2. `M951~FRZ2`: Snowbound Conveyor Guardian (થીજેલો કન્વેયર ગાર્ડિયન).
3. `M951~COL`: Painted Conveyor Guardian (ચોક્કસ રંગની ટ્રેનથી ડેમેજ લેતો ગાર્ડિયન).
4. `M951~FOG`: Steamy Conveyor Guardian (ધુમ્મસમાં કન્વેયર ગાર્ડિયન).
5. `M951~CHN`: Linked Conveyor Guardians (બે જોડાયેલા કન્વેયર ગાર્ડિયન્સ).
6. `M951~PHS`: Phantom Conveyor Guardian (ફેઝિંગ કન્વેયર ગાર્ડિયન).
7. `M951~ARM`: Iron-clad Conveyor Guardian (આર્મ્ડ કન્વેયર ગાર્ડિયન).
8. `M951~LAY`: Deck Conveyor Guardian (ડેક લેવલ પરનો ગાર્ડિયન).
9. `M951~MIR`: Looking-glass Guardian Belt (પ્રતિબિંબિત કન્વેયર રીંગ).
10. `M951~GRW`: Sprouting Conveyor Guardian (વેલવાળો કન્વેયર ગાર્ડિયન).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M952~CNT5`: Last Call Gravity Relay (5 moves પછી ટિલ્ટ બંધ થતો રીલે).
13. `M952~FRZ2`: Snowbound Gravity Relay (થીજેલો ગ્રેવિટી રીલે).
14. `M952~COL`: Painted Gravity Relay (ચોક્કસ રંગીન ગ્રેવિટી રીલે).
15. `M952~FOG`: Steamy Gravity Relay (ધુમ્મસમાં ગ્રેવિટી રીલે).
16. `M952~CHN`: Linked Gravity Relays (બે જોડાયેલા ગ્રેવિટી રીલેઝ).
17. `M952~PHS`: Phantom Gravity Relay (ફેઝિંગ ગ્રેવિટી રીલે).
18. `M952~ARM`: Iron-clad Gravity Relay (આર્મ્ડ ગ્રેવિટી રીલે).
19. `M952~LAY`: Deck Gravity Relay (ડેક લેવલ પરનો ગ્રેવિટી રીલે).
20. `M952~MIR`: Looking-glass Gravity Relay (મિરર ગ્રેવિટી રીલે).
21. `M952~GRW`: Sprouting Gravity Relay (વેલવાળો ગ્રેવિટી રીલે).
22. `M018~FRZ2`: Snowbound Mountain Switch (થીજેલું સ્વિચ).
23. `M953~CNT5`: Last Call Cycle Master Pass (5 moves સુધી જ માન્ય માસ્ટર પાસ).
24. `M953~FRZ2`: Snowbound Cycle Master Pass (થીજેલો માસ્ટર પાસ).
25. `M953~COL`: Painted Cycle Master Pass (ચોક્કસ રંગ ફિલ્ટર સાથેનો પાસ).
26. `M953~FOG`: Steamy Cycle Master Pass (ધુમ્મસમાં માસ્ટર પાસ).
27. `M953~CHN`: Linked Cycle Master Passes (બે લિન્ક્ડ માસ્ટર પાસ ટ્રેનો).
28. `M953~PHS`: Phantom Cycle Master Pass (ફેઝિંગ માસ્ટર પાસ).
29. `M953~ARM`: Iron-clad Cycle Master Pass (આર્મ્ડ માસ્ટર પાસ).
30. `M953~LAY`: Deck Cycle Master Pass (ડેક પર દોડતો માસ્ટર પાસ).
31. `M953~MIR`: Looking-glass Master Pass (મિરર માસ્ટર પાસ).
32. `M953~GRW`: Sprouting Cycle Master Pass (વેલવાળો માસ્ટર પાસ).
33. `M013~FOG`: Steamy Rotary Yard (ધુમ્મસિયું ટર્નટેબલ).
34. `M954~CNT5`: Last Call Prism Bloom (5 moves પછી બંધ થતી બ્લૂમ કમાન).
35. `M954~FRZ2`: Snowbound Prism Bloom (થીજેલી પ્રિઝમ કમાન).
36. `M954~COL`: Painted Prism Bloom (ચોક્કસ રંગની પ્રિઝમ કમાન).
37. `M954~FOG`: Steamy Prism Bloom (ધુમ્મસમાં પ્રિઝમ બ્લૂમ).
38. `M954~CHN`: Linked Prism Blooms (જોડાયેલી જોડિયા બ્લૂમ કમાનો).
39. `M954~PHS`: Phantom Prism Bloom (ફેઝિંગ બ્લૂમ કમાન).
40. `M954~ARM`: Iron-clad Prism Bloom (આર્મ્ડ બ્લૂમ કમાન).
41. `M954~MIR`: Looking-glass Prism Bloom (મિરર બ્લૂમ કમાન).
42. `M954~LAY`: Deck Prism Bloom (ડેક લેવલ પરની કમાન).
43. `M954~GRW`: Sprouting Prism Bloom (વેલવાળી બ્લૂમ કમાન).
44. `M045~CHN`: Linked Master Gear Terminus (લિંક્ડ ગિયર ટર્મિનસ કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).

