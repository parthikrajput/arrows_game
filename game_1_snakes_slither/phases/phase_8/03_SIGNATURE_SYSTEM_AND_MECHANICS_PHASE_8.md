# 03 — Signature System & Base Mechanics (Phase 8)
> Phase 8 (Overgrown Garden) ની signature system અને 4 નવા base mechanics (M351–M354) ના નિયમો, parameters, edge cases, tick order (§16.17), solver impact અને solvability guarantees.

**Related docs:** [Phase 8 index](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Phase 8 Rules](./01_PHASE_8_SCOPE_AND_RULES.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md)

---

## 1. Signature System: Overgrown Garden (Growth)
- **Concept:** અવિરત વધતી જંગલી વેલો અને વનસ્પતિ. ખેલાડીએ કાપણી ટાઇલ્સ દ્વારા વેલો કાપવી પડે છે, અન્યથા વેલો બોર્ડના એક્ઝિટ લેનને અવરોધે છે.
- **Rules:**
  - દર $N$ Moves એ વેલો અંકુરિત થઈને ફેલાય છે.
  - કાપણી ટાઈલ પરથી લેન પસાર થતાં આસપાસની વેલો સાફ થાય છે.
  - તમામ વેલો દૂર થતાં જ બ્લૂમ ગેટ ખુલે છે.

---

## 2. Mechanic M351: Wild Vine (Vine Spread+)
- **Intro Level:** L3511 (Block 2 x1)
- **Category:** Dynamic Organic Spreader (B / D)
- **Visual:** કાંટાળી જાંબલી-લીલી વેલો જેના પર જીવંત અંકુર ફૂટે છે.
- **Rule:**
  - દર $N$ Moves એ (Default: $N=3$) Wild Vine પોતાના ખાલી ઓર્થોગોનલ પાડોશી સેલ્સ તપાસે છે.
  - ફેલાવવાનો ક્રમ: **Up -> Right -> Down -> Left** (`U, R, D, L`).
  - પ્રથમ 2 ખાલી સેલ્સ પર નવી વેલો અંકુરિત થાય છે (તે સેલ સોલિડ બ્લોકર બની જાય છે).
  - જો પાડોશી સેલમાં સાપ કે અન્ય બ્લોકર હોય, તો તે દિશા છોડીને આગળની દિશામાં ફેલાય છે.
  - એક લેવલમાં વેલોની મહત્તમ સંખ્યા કેપ (Cap = 8 cells) હોય છે.
- **JSON Format:**
  ```json
  {"id": "o351_1", "type": "M351", "cells": [[6, 6]], "params": {"spreadInterval": 3, "maxCells": 8}, "hammerable": true}
  ```
- **Hammerable:** `true` (સિંગલ સેલ હેમરથી કાપી શકાય છે, standard §16.18).

---

## 3. Mechanic M352: Pruning Shears Tile (Pruner Tile)
- **Intro Level:** L3631 (Block 14 x1)
- **Category:** Terrain Clearing Tile (D)
- **Visual:** સોનેરી કાતર અને માળીના ઓજારોની કોતરણીવાળી ટાઈલ.
- **Rule:**
  - જ્યારે કોઈપણ સાપની એક્ઝિટ લેન આ ટાઈલ પરથી પસાર થાય છે:
    - Pruning Tile સક્રિય થાય છે.
    - તે ટાઈલના 4 ઓર્થોગોનલ પાડોશી સેલ્સ (`U, D, L, R`) માં આવેલી તમામ Wild Vine (M351) સેલ્સ તરત જ કપાઈને નાશ પામે છે!
  - આ રીતે ખેલાડી સાપને કાતર ટાઈલ પરથી દોડાવીને બંધ રસ્તાઓ ખોલી શકે છે.
- **JSON Format:**
  ```json
  {"id": "o352_1", "type": "M352", "cells": [[5, 5]], "params": {}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 4. Mechanic M353: Seed-Carrier Snake (Seed Path)
- **Intro Level:** L3751 (Block 26 x1)
- **Category:** Path Exit Side-Effect (D)
- **Visual:** પીઠ પર ચમકતું બીજ (Jungle Seed pod) વહન કરતો સાપ.
- **Rule:**
  - જ્યારે આ સાપ બોર્ડમાંથી સફળતાપૂર્વક બહાર નીકળે છે, ત્યારે તે પોતાના નિર્ધારિત સેલ પર એક **Seed Pod** છોડી જાય છે.
  - બીજ પર $N$ મૂવ્સનું કાઉન્ટડાઉન શરૂ થાય છે ($N=4$).
  - જો $N$ મૂવ્સ પૂરા થતાં પહેલાં અન્ય કોઈ સાપ તેના પરથી નીકળે: બીજ કચડાઈને નાશ પામે છે.
  - જો $N$ મૂવ્સમાં કોઈ સાપ ન નીકળે: બીજ ફૂટીને Wild Vine બ્લોકર બની જાય છે!
- **JSON Format:**
  ```json
  {"id": "p_seed_1", "color": "green", "dir": "U", "body": [[7, 4], [7, 5], [7, 6]], "mods": {"seedCell": [7, 5], "sproutMoves": 4}}
  ```
- **Hammerable:** Normal snake rules.

---

## 5. Mechanic M354: Bloom Gate (Bloom Gate)
- **Intro Level:** L3871 (Block 38 x1)
- **Category:** Conditional Weed-Clear Lock (G)
- **Visual:** વિશાળ કમળનું ફૂલ ગેટ જે વેલોથી વીંટળાયેલું છે.
- **Rule:**
  - બોર્ડ પર જ્યાં સુધી લિંક થયેલી Wild Vines અસ્તિત્વમાં હોય ત્યાં સુધી આ ગેટ બંધ રહે છે.
  - જ્યારે બોર્ડ પરની તમામ લિંક થયેલી વેલો Pruner Tile (M352) કે હેમર દ્વારા કાપી નાખવામાં આવે (0 vines remaining):
    - Bloom Gate ના ફૂલો ખીલી ઊઠે છે અને ગેટ કાયમ માટે ખુલી જાય છે.
- **JSON Format:**
  ```json
  {"id": "o354_1", "type": "M354", "cells": [[11, 8]], "params": {"linkedVineGroupId": "vg_1"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 6. Tick Order Integration (§16.17)
1. Player action resolve:
   - જો સાપ Pruning Shears Tile (M352) પરથી નીકળે: પાડોશી વેલો તરત પ્રૂન થાય છે.
   - જો Seed-Carrier Snake (M353) નીકળે: સીડ પોડ ડ્રોપ થાય છે.
2. `moveCount += 1`.
3. Growth Step:
   - Wild Vines (M351) કાઉન્ટર ટિક થાય છે; $N$ મૂવ્સે 2 સેલમાં ફેલાય છે.
   - Seed Pods કાઉન્ટર 1 ઘટે છે; 0 થતાં અંકુરિત થાય છે.
4. Derived states & Bloom Gate (M354) ચેક (જો vines == 0 તો ઓપન).
5. Win check.
