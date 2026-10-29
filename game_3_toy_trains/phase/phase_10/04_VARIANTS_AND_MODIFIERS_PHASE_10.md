# 04 · Variants & Modifiers Phase 10 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 10 ના 45 variant slots, Timetable Sequencing આધારિત Base × Modifier સંયોજનો અને સુસંગતતા નિયમો.

**Related docs:** [Phase 10 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_4501_5000.md)

---

## 1. 10 Standard Modifiers Compatibility
| Modifier | Sequencing Application | Valid Target Bases |
|---|---|---|
| `Countdown(N)` | N Moves પછી મેટ્રોનોમ ગેટ કાયમી ખુલે છે અથવા સિગ્નલ લોક થાય છે. | M451, M452, M453, M454 |
| `Frozen(K)` | K ટ્રેન એક્ઝિટ પછી જ રિધમ શરૂ થાય છે કે કોડ લોક સક્રિય બને છે. | M451, M452, M453, M454 |
| `Colored` | માત્ર ચોક્કસ રંગની ટ્રેન જ મેટ્રોનોમ કે ઓર્ડર એજમાંથી નીકળી શકે. | M451, M452, M453, M454 |
| `Fogged` | સ્ટીમ ક્લાઉડ નીચે છુપાયેલું મેટ્રોનોમ કે એક્ઝિટ કોડ બોર્ડ. | All M45x |
| `Chained` | બે મેટ્રોનોમ ગેટ્સ એકસાથે સમાન રિધમમાં ધબકે છે. | M451, M452, M453 |
| `Phasing` | માત્ર Even moves પર જ ઓર્ડર એજ કે કોડ લોક હાજર રહે છે. | M451, M452, M453, M454 |
| `Armored` | ક્રેન કે બોમ્બથી સિગ્નલ કે ગેટને નુકસાન પહોંચાડી શકાતું નથી. | M451, M452, M453, M454 |
| `Layered` | ડેક અથવા ગ્રાઉન્ડ લેયર પર વિશિષ્ટ સિક્વન્સિંગ નિયમો. | M451, M452, M453, M454 |
| `Mirrored` | મેટ્રોનોમ અથવા કોડ સિક્વન્સ ઉલટા ક્રમમાં ચાલે છે. | M451, M452, M453, M454 |
| `Growing` | સિક્વન્સ પૂર્ણ ન થાય ત્યાં સુધી આસપાસ ગ્રોથ અવરોધ વિસ્તરે છે. | M451, M452, M453, M454 |

---

## 2. 45 Variant Slots Definition
1. `M451~CNT5`: Last Call Metronome (5 moves પછી કાયમી ખુલ્લો રહેતો ગેટ).
2. `M451~FRZ2`: Snowbound Metronome (2 ટ્રેન એક્ઝિટ પછી શરૂ થતો રિધમ ગેટ).
3. `M451~COL`: Painted Metronome Gate (ચોક્કસ રંગની ટ્રેન માટેનો રિધમ ગેટ).
4. `M451~FOG`: Steamy Metronome (ધુમ્મસમાં ધબકતો ગેટ).
5. `M451~CHN`: Linked Metronome Gates (સાથે ખુલતા-બંધ થતા જોડી ગેટ્સ).
6. `M451~PHS`: Phantom Metronome (ફેઝિંગ રિધમ ગેટ).
7. `M451~ARM`: Iron-clad Metronome Gate (તોડી ન શકાય તેવો ગેટ).
8. `M451~LAY`: Deck Metronome Gate (ડેક લેયર પરનો રિધમ ગેટ).
9. `M451~MIR`: Looking-glass Metronome (ઉલટી રિધમ સાયકલવાળો ગેટ).
10. `M451~GRW`: Sprouting Rhythm Gate (વેલથી ઘેરાયેલો રિધમ ગેટ).
11. `M001~CNT6`: Last Call Shunting Bumper (ટાઈમર બફર સ્ટોપ).
12. `M452~CNT6`: Last Call Code Lock (6 moves પછી આપોઆપ અનલોક).
13. `M452~FRZ2`: Snowbound Departure Lock (થીજેલું કોડ બોર્ડ).
14. `M452~COL`: Painted Code Barrier (ચોક્કસ રંગના મિશ્રણવાળો બેરિયર).
15. `M452~FOG`: Steamy Code Lock (ધુમ્મસિયું કોડ બેરિયર).
16. `M452~CHN`: Linked Departure Codes (બે સંયુક્ત કોડ લોક્સ).
17. `M452~PHS`: Phantom Code Lock (ફેઝિંગ કોડ લોક).
18. `M452~ARM`: Iron-clad Code Barrier (આર્મ્ડ કોડ બેરિયર).
19. `M452~LAY`: Deck Code Lock (ડેક પર આવેલું કોડ બોર્ડ).
20. `M452~MIR`: Looking-glass Code Lock (ઉલટા રંગ ક્રમવાળો લોક).
21. `M452~GRW`: Sprouting Code Lock (ગ્રોથ મિકેનિઝમ ધરાવતો કોડ લોક).
22. `M013~FRZ2`: Snowbound Rotary Junction (થીજેલું ટર્નટેબલ).
23. `M453~CNT5`: Last Call Platform Exit (5 moves પછી સામાન્ય એજ બનતો ઓર્ડર એજ).
24. `M453~FRZ2`: Snowbound Platform Edge (બરફ મુક્ત પ્લેટફોર્મ એજ).
25. `M453~COL`: Painted Platform Edge (રંગીન ક્રમાંકિત એજ).
26. `M453~FOG`: Steamy Platform Edge (ધુમ્મસમાં પ્લેટફોર્મ એજ).
27. `M453~CHN`: Linked Platform Edges (બે લિન્ક્ડ પ્લેટફોર્મ એક્ઝિટ્સ).
28. `M453~PHS`: Phantom Platform Exit (ફેઝિંગ પ્લેટફોર્મ એજ).
29. `M453~ARM`: Iron-clad Platform Edge (ક્રેન-ઇમ્યુન પ્લેટફોર્મ એજ).
30. `M453~LAY`: Deck Platform Edge (ડેક લેયર પરની પ્લેટફોર્મ એજ).
31. `M453~MIR`: Looking-glass Order Exit (ઉલટા ક્રમવાળી એજ).
32. `M453~GRW`: Sprouting Platform Edge (વેલવાળી પ્લેટફોર્મ એજ).
33. `M018~FOG`: Steamy Branch Switch (ધુમ્મસિયું સ્વિચ).
34. `M454~CNT5`: Last Call Echo Signal (5 moves પછી ઇકો મુક્ત સિગ્નલ).
35. `M454~FRZ2`: Snowbound Echo Signal (થીજેલું ઇકો સિગ્નલ).
36. `M454~COL`: Painted Echo Signal (ચોક્કસ રંગ ફિલ્ટર સાથે ઇકો સિગ્નલ).
37. `M454~FOG`: Steamy Echo Signal (ધુમ્મસમાં ઇકો સિગ્નલ).
38. `M454~CHN`: Linked Echo Signals (બે સમાંતર ઇકો સિગ્નલ્સ).
39. `M454~PHS`: Phantom Echo Signal (ફેઝિંગ ઇકો સિગ્નલ).
40. `M454~ARM`: Iron-clad Echo Signal (આર્મ્ડ ઇકો સિગ્નલ).
41. `M454~MIR`: Looking-glass Echo Signal (મિરર ઇકો સિગ્નલ).
42. `M454~LAY`: Deck Echo Signal (ડેક લેયર પરનું ઇકો સિગ્નલ).
43. `M454~GRW`: Sprouting Echo Signal (વેલથી ઢંકાયેલું સિગ્નલ).
44. `M045~CHN`: Linked Master Gear Rhythm (લિંક્ડ ગિયર રિધમ કંટ્રોલર).
45. `M021~CNT5`: Last Call Crossing Signal (ટાઈમર ક્રોસિંગ સિગ્નલ).
