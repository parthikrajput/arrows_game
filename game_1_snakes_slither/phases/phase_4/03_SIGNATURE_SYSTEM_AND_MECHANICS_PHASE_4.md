# 03 — Signature System & Base Mechanics (Phase 4)
> Phase 4 (Great Tree Floors) ની signature system અને 4 નવા base mechanics (M151–M154) ના નિયમો, parameters, edge cases, tick order (§16.17), solver impact અને solvability guarantees.

**Related docs:** [Phase 4 index](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Phase 4 Rules](./01_PHASE_4_SCOPE_AND_RULES.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md)

---

## 1. Signature System: Great Tree Floors (Multi-Floor)
- **Concept:** વિશાળ મહાવૃક્ષના વિવિધ માળ (F1 Roots/Cavern, F2 Trunk, F3 Canopy) પર પઝલ બોર્ડ ગોઠવાયેલા છે.
- **Rules:**
  - એક લેવલમાં 2 થી 3 માળ (stacked grids) હોઈ શકે છે.
  - HUD પર Floor Tabs (`[F1]`, `[F2]`, `[F3]`) ઉપલબ્ધ હોય છે.
  - Floor બદલીને જોવું એ ગેમપ્લે Move નથી.
  - સાપ વર્ટિકલ મિકેનિક્સ (M151, M153, M154) દ્વારા એક માળેથી બીજા માળે પ્રવાસ કરી શકે છે.

---

## 2. Mechanic M151: Root Stairs (Stairs)
- **Intro Level:** L1511 (Block 2 x1)
- **Category:** Inter-Floor Connector (D)
- **Visual:** ઝાડની વિશાળ મૂળિયાંથી બનેલી સીડી જે બે માળને જોડે છે.
- **Rule:**
  - Root Stairs બે અલગ માળના બે ચોક્કસ સેલ્સને લિંક કરે છે (દા.ત. F1 સેલ `[4, 5]` થી F2 સેલ `[4, 5]`).
  - જ્યારે કોઈ સાપ સીડીના સેલમાં પ્રવેશે છે, ત્યારે તેની લેન અટકી જતી નથી પણ આપોઆપ બીજા માળના લિંક થયેલ સેલમાંથી સમાન દિશામાં આગળ વધે છે.
  - જો બીજા માળ પર રસ્તો સાફ હોય, તો સાપ સરળતાથી સીડી ચડીને બીજા માળે સરકી જાય છે.
  - જો બીજા માળ પર અવરોધ હોય, તો સાપ મૂળ માળ પર જ બોંક થઈને પાછો ફરે છે (−1 Heart).
- **JSON Format:**
  ```json
  {"id": "o151_1", "type": "M151", "cells": [[4, 5]], "params": {"floorFrom": 1, "floorTo": 2, "linkedCell": [4, 5]}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 3. Mechanic M152: Dewglass Floor (Glass Floor)
- **Intro Level:** L1631 (Block 14 x1)
- **Category:** Occlusion / Vision Tile (D)
- **Visual:** પારદર્શક ઝાકળવાળું સ્ફટિક ફ્લોર.
- **Rule:**
  - Dewglass Floor એક પારદર્શક ટાઈલ છે.
  - ઉપલા માળ પર Dewglass સેલ પર રહેલો સાપ નીચલા માળના તે જ સેલના સાપને લોક કે બ્લોક કરતો નથી.
  - બંને માળના સાપ સ્વતંત્ર રીતે પસાર થઈ શકે છે.
  - ઉપરથી નીચેનો માળ સ્પષ્ટ દેખાય છે.
- **JSON Format:**
  ```json
  {"id": "o152_1", "type": "M152", "cells": [[7, 7]], "params": {"floor": 2}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 4. Mechanic M153: Knot Hole (Drop Hole)
- **Intro Level:** L1751 (Block 26 x1)
- **Category:** Gravity Drop / One-Way Descent (D)
- **Visual:** ઝાડના થડમાં પડેલું કુદરતી છિદ્ર/બખોલ (Knot Hole).
- **Rule:**
  - One-way ડાઉનવર્ડ પાથ છે: ઉપલા માળ (F2 અથવા F3) પરથી લેન આ હોલમાં પહોંચતાં સાપ સીધો નીચલા માળ (F1 અથવા F2) ના તે જ સેલ પર ડ્રોપ થાય છે.
  - ડ્રોપ થયા પછી સાપ પોતાની મૂળ દિશામાં આગળ વધવાનું ચાલુ રાખે છે.
  - Knot Hole માંથી ઉપર જઈ શકાતું નથી (માત્ર ઉપરથી નીચે ડ્રોપ).
  - જો નીચેનો સેલ બ્લોક હોય, તો સાપ હોલમાં પડતાં પહેલાં જ બોંક થઈ જાય છે.
- **JSON Format:**
  ```json
  {"id": "o153_1", "type": "M153", "cells": [[5, 8]], "params": {"fromFloor": 2, "toFloor": 1}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 5. Mechanic M154: Vine Lift (Elevator)
- **Intro Level:** L1871 (Block 38 x1)
- **Category:** Interactive Platform (T / D)
- **Visual:** વેલોથી બંધાયેલું લાકડાનું પાલખું/પ્લેટફોર્મ (Elevator).
- **Rule:**
  - Interactive Mechanic: પ્લેટફોર્મ પર ટેપ કરવાથી તે 1 Move લે છે.
  - જ્યારે કોઈ સાપ **સંપૂર્ણપણે પ્લેટફોર્મ પર ઊભો હોય**, ત્યારે પ્લેટફોર્મ ટેપ કરવાથી પ્લેટફોર્મ અને સાપ બંને 1 માળ ઉપર અથવા નીચે ખસે છે (દિશા એક પછી એક વારાફરતી alternates).
  - જો સાપ આંશિક રીતે પ્લેટફોર્મ પર હોય, તો ટેપ Locked Tap ગણાય છે (સાપ કપાતો નથી; standard §16.19).
- **JSON Format:**
  ```json
  {"id": "o154_1", "type": "M154", "cells": [[6, 6], [6, 7]], "params": {"currentFloor": 1, "targetFloor": 2}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 6. Tick Order Integration (§16.17)
1. Player action resolve:
   - જો Snake exit હોય: વર્ટિકલ સ્ટેપ્સ સાથે લેન આગળ વધે છે.
   - જો Vine Lift ટેપ હોય: પ્લેટફોર્મ અને સાપનો માળ અપડેટ થાય છે.
2. `moveCount += 1`.
3. Counters tick: Periodic gates, lifts, timers.
4. Floor Transition checks: જો સાપનો માળ બદલાયો હોય તો કેમેરા ટાર્ગેટ ફ્લોર પર સ્મૂધલી ખસે છે.
5. Win check: બધા માળના તમામ સાપ ક્લિયર થયા છે કે નહીં.

