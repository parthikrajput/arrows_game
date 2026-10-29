# 04 · Variants & Modifiers Phase 3 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 3 ના 45 variant slots, 10 standardized modifiers ના railway નિયમો, Base × Modifier ની રચના અને compatibility validation.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md)

---

## 1. 10 Standard Modifiers (Railway Themed)
| Modifier | Themed Name | Exact Gameplay Rule | Valid Categories |
|---|---|---|---|
| `Frozen(K)` | Snowbound | ટ્રેન કે મિકેનિક જ્યાં સુધી તેની આસપાસની K ટ્રેનો ન નીકળે ત્યાં સુધી થીજેલું રહે છે. | T, C, D, G, P |
| `Colored` | Painted | ચોક્કસ રંગની ટ્રેન સાથે જ ક્રિયાપ્રતિક્રિયા કરે છે; અન્ય રંગો માટે બ્લોકર બને છે. | D, G, L, T |
| `Fogged` | Steamy | સ્ટીમ ક્લાઉડ (M010) નીચે શરૂ થાય છે; સ્પર્શતી ટ્રેન નીકળે ત્યારે જ દૃશ્યમાન થાય છે. | All non-X |
| `Chained` | Linked | જોડીદાર મિકેનિક સાથે જોડાયેલું; એકનું એક્શન બીજા પર તે જ સમયે લાગુ થાય છે. | T, P, D |
| `Countdown(N)` | Last Call | N Moves પછી કાયમી રીતે સ્થિતિ બદલે છે (દરવાજા ખુલે છે, સહાયક સાધનો બ્લોકર બને છે). | B, K, D, G, L |
| `Phasing` | Phantom | માત્ર Even Move Count પર જ અસ્તિત્વ ધરાવે છે; Odd પર અદૃશ્ય/અસ્પૃશ્ય રહે છે. | B, D, T, G |
| `Armored` | Iron-clad | Track Crane (Hammer) થી તોડી શકાતું નથી. | B, X, P |
| `Layered` | Deck | Layer 1 અથવા Layer 2 પર મૂકાય છે; માત્ર તે જ layer ની ટ્રેનોને અસર કરે છે. | B, D, T, G, K |
| `Mirrored` | Looking-glass | વર્ટિકલ અક્ષ પર દિશાઓ અને રોટેશન્સ પ્રતિબિંબિત થાય છે. | D, T, P |
| `Growing` | Sprouting | દર N Moves એ નજીકના ખાલી ખાનામાં એક વધારાનો બ્લોકર/કેરેજ ઉમેરે છે. | B, C |

---

## 2. 45 Variant Slots Definition
Phase 3 ના 45 variant slots ની વિગતો:
1. `M001~CNT5`: Last Call Buffer Stop (5 moves પછી અદૃશ્ય થાય છે).
2. `M002~FRZ2`: Snowbound Cargo Crates (2 ટ્રેન નીકળ્યા પછી બરફ પીગળે છે).
3. `M005~COL`: Painted Platform Gate (ફક્ત ચોક્કસ લીવરી માટે જ રસ્તો આપે છે).
4. `M007~FOG`: Steamy Level Crossing (ધુમ્મસ સાફ થયા પછી જ કાઉન્ટડાઉન દેખાય છે).
5. `M009~CHN`: Linked Signal Levers (એક લીવર ફ્લિપ કરતાં બે સિગ્નલ એકસાથે બદલાય છે).
6. `M013~PHS`: Phantom Turntable (માત્ર even moves પર જ ટ્રેનને ફેરવી શકે છે).
7. `M016~ARM`: Iron-clad Rock Pile (ક્રેનથી તોડી શકાતું નથી; માત્ર ટ્રેન ઘસાઈને તૂટે છે).
8. `M018~LAY`: Deck Track Switch (ઉપલા વાયાડક્ટ ડેક પર લાગેલો સ્વિચ પોઇન્ટ).
9. `M015~MIR`: Looking-glass Overpass (ડાબે-જમણે ઊંધી દિશામાં પસાર થતો પુલ).
10. `M027~GRW`: Sprouting Ivy Yard (ઝડપથી ફેલાતી જંગલી વેલ).
11. `M038~CNT6`: Last Call Signal Gate (6 moves સુધી જ ચાલુ રહે છે).
12. `M013~FRZ1`: Snowbound Turntable (બરફ હટ્યા પછી જ ફરે છે).
13. `M019~FOG`: Steamy Weighbridge Plate (ધુમ્મસમાં છુપાયેલી વજન તુલા).
14. `M018~CHN`: Linked Track Switches (બે જંક્શન સ્વિચ એકસાથે દિશા બદલે છે).
15. `M020~PHS`: Phantom Engine Shed (માત્ર ચોક્કસ move પર જ ટ્રેન સ્વીકારે છે).
16. `M030~COL`: Painted Station Exit (ખાસ રંગ માટેનું એક્ઝિટ સ્ટેશન).
17. `M032~LAY`: Deck Viaduct Crossing (બેવડા સ્તરનો વાયાડક્ટ પુલ).
18. `M008~MIR`: Looking-glass Tunnel (પ્રતિબિંબિત દિશામાં ટ્રેન બહાર ફેંકે છે).
19. `M025~ARM`: Iron-clad Handcar Patrol (તોડી ન શકાય તેવી પેટ્રોલિંગ ટ્રોલી).
20. `M002~GRW`: Sprouting Cargo Depot (વધતા જતા લાકડાના બોક્સ).
21. `M102~CNT5`: Last Call Overpass (5 moves પછી તૂટીને બ્લોકર બની જાય છે).
22. `M101~FRZ2`: Snowbound Day/Night Gate (બરફથી જકડાયેલો ડે/નાઇટ દરવાજો).
23. `M102~FOG`: Steamy Day/Night Overpass (ધુમ્મસથી ઢંકાયેલો ડે/નાઇટ પુલ).
24. `M101~CHN`: Linked Day/Night Gates (બે ડે/નાઇટ ગેટ એકસાથે ફ્લિપ થાય છે).
25. `M101~PHS`: Phantom Day/Night Gate (ફેઝિંગ ડે/નાઇટ ગેટ).
26. `M103~COL`: Painted Tunnel Portal (ચોક્કસ રંગની ટ્રેન જ પ્રવેશી શકે).
27. `M103~LAY`: Deck Day/Night Tunnel (ઉપલા ડેક પર સ્થિત સુરંગ).
28. `M101~MIR`: Looking-glass Day/Night Gate (પ્રતિબિંબિત ગેટ).
29. `M029~ARM`: Iron-clad Table Fence (તોડી ન શકાય તેવી કિનારીની વાડ).
30. `M047~GRW`: Sprouting Track Section (moves સાથે લંબાતી ટ્રેન).
31. `M103~CNT6`: Last Call Day/Night Tunnel (6 moves પછી બંધ થતી સુરંગ).
32. `M103~FRZ1`: Snowbound Day/Night Tunnel (બરફથી બ્લોક થયેલી સુરંગ).
33. `M034~FOG`: Steamy Rotary Yard (ધુમ્મસમાં ઢંકાયેલો રોટેટિંગ યાર્ડ).
34. `M102~CHN`: Linked Day/Night Overpasses (બે જોડાયેલા ડે/નાઇટ પુલ).
35. `M103~PHS`: Phantom Day/Night Tunnel (અદૃશ્ય થતી સુરંગ).
36. `M104~COL`: Painted Day/Night Livery (ત્રણ રંગો વચ્ચે સાયકલ થતી ટ્રેન).
37. `M102~LAY`: Deck Day/Night Overpass (ડેક પરનો ડે/નાઇટ પુલ).
38. `M104~MIR`: Looking-glass Livery Train (પ્રતિબિંબિત લીવરી ટ્રેન).
39. `M042~ARM`: Iron-clad Repair Siding (ક્રેન-અભેદ્ય રિપેર સાઇડિંગ).
40. `M027~GRW`: Sprouting Signal Post (સિગ્નલ પોસ્ટ પર વેલનું વિસ્તરણ).
41. `M104~CNT5`: Last Call Livery Gate (સમય મર્યાદા વાળો લીવરી ગેટ).
42. `M104~FRZ2`: Snowbound Livery Engine (થીજેલું લીવરી એન્જિન).
43. `M103~FOG`: Steamy Day/Night Tunnel (ધુમ્મસિયું ટનલ પોર્ટલ).
44. `M045~CHN`: Linked Master Gear Levers (બે જોડાયેલા માસ્ટર ગિયર લીવર્સ).
45. `M101~ARM`: Iron-clad Day/Night Gate (તોડી ન શકાય તેવો ડે/નાઇટ ગેટ).

---

## 3. JSON Representation
```json
{
  "id": "v1",
  "type": "M101",
  "cells": [[5, 3]],
  "params": {"openIn": "A"},
  "mods": {
    "chained": "v2",
    "armored": true
  },
  "hammerable": false
}
```
