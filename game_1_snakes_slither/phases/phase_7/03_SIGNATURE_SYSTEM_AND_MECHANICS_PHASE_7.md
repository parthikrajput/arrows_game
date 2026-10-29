# 03 — Signature System & Base Mechanics (Phase 7)
> Phase 7 (Whirlwind Valley) ની signature system અને 4 નવા base mechanics (M301–M304) ના નિયમો, parameters, edge cases, tick order (§16.17), solver impact અને solvability guarantees.

**Related docs:** [Phase 7 index](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Phase 7 Rules](./01_PHASE_7_SCOPE_AND_RULES.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md)

---

## 1. Signature System: Whirlwind Valley (Rotation)
- **Concept:** વાવાઝોડાની ખીણમાં ફરતા પ્લેટફોર્મ્સ અને દિવાલો. 4×4 રોટેશન, સરકતી કિનારીઓ અને વળાંક લેતા સાપ.
- **Rules:**
  - રોટેશન 90° Clockwise થાય છે.
  - રોટર ટેપ 1 Move ખર્ચે છે.
  - Partial snakes ધરાવતા રોટર્સ લૉક રહે છે (સાપ કપાતો નથી).

---

## 2. Mechanic M301: Island Spinner (Sub-board Rotor)
- **Intro Level:** L3011 (Block 2 x1)
- **Category:** Interactive Sub-grid Rotation (T / D)
- **Visual:** 4×4 ક્ષેત્રમાં પથ્થરનું ગોળાકાર ચક્ર જેના કેન્દ્રમાં લાકડાનું હેન્ડલ છે.
- **Rule:**
  - કેન્દ્ર હેન્ડલ ટેપ કરવાથી 4×4 ક્ષેત્ર 90° CW ફરે છે (1 Move).
  - **Invariants:**
    1. સંપૂર્ણપણે અંદર રહેલા સાપનું આખું શરીર અને `dir` 90° CW ફરે છે.
    2. જો કોઈ સાપ ક્ષેત્રની બોર્ડર પર લંબાયેલો હોય (અડધો અંદર, અડધો બહાર), તો ટેપ **Locked Tap** બને છે (વૉબલ સાઉન્ડ, હાર્ટ જતું નથી).
    3. રોટેશન પછી જો કોઈ સાપની દિશા પોતાના શરીર તરફ થાય, તો તે Tangled (Locked) બને છે (standard §17.39).
- **JSON Format:**
  ```json
  {"id": "o301_1", "type": "M301", "cells": [[4, 4], [7, 7]], "params": {"currentAngle": 0}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 3. Mechanic M302: Turning Hedges (Rotating Edges)
- **Intro Level:** L3131 (Block 14 x1)
- **Category:** Dynamic Border Blocker (B)
- **Visual:** બોર્ડની કિનારી પર આવેલી ઘટાદાર ઝાડીઓ (Hedges) જે સતત સરકે છે.
- **Rule:**
  - દરેક Move પછી (Step 3: Counters tick), બોર્ડર પર આવેલી દિવાલના સેગમેન્ટ્સ બોર્ડની પરિમિતિ પર **1 સેલ Clockwise** આગળ ખસે છે.
  - સાપનો બહાર નીકળવાનો રસ્તો (Exit lane) જો દિવાલ સામે આવી જાય તો બ્લોક થાય છે; દિવાલ સરકી જતાં રસ્તો ખુલી જાય છે.
  - ખેલાડીએ બહાર નીકળવાનો દરવાજો ખુલ્લો થાય ત્યાં સુધી મૂવ્સનું ટાઈમિંગ સાચવવું પડે છે.
- **JSON Format:**
  ```json
  {"id": "o302_1", "type": "M302", "cells": [[0, 2], [0, 3], [0, 4]], "params": {"shiftInterval": 1}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 4. Mechanic M303: Spinning Snake (Spin Path)
- **Intro Level:** L3251 (Block 26 x1)
- **Category:** Dynamic Path Behavior (D)
- **Visual:** માથા પર વમળનું ચિહ્ન (Swirl crest) ધરાવતો ખાસ ચપળ સાપ.
- **Rule:**
  - આ સાપ સ્થિર રહેતો નથી: બોર્ડ પર કોઈપણ અન્ય માન્ય Move થાય તે પછી આ સાપની દિશા આપોઆપ **90° CW** ફરી જાય છે!
  - દિશા બદલાતાં જો તેનો એક્ઝિટ લેન ખુલ્લો હોય તો ખેલાડી તેને તરત ટેપ કરીને બહાર કાઢી શકે છે.
  - જો આગામી Move માં ટેપ ન કરાય, તો તે ફરી 90° ફરી જશે અને રસ્તો બંધ થઈ શકે છે.
  - જો નવી દિશા પોતાના શરીર પર આવે, તો તે Move માટે Tangled Lock રહે છે.
- **JSON Format:**
  ```json
  {"id": "p_spin_1", "color": "amber", "dir": "R", "body": [[5, 5], [5, 6], [5, 7]], "mods": {"spin": true}}
  ```
- **Hammerable:** Normal snake rules.

---

## 5. Mechanic M304: Gear Lock (Rotation Lock)
- **Intro Level:** L3371 (Block 38 x1)
- **Category:** Orientation-Coupled Lock (G)
- **Visual:** દાંતાવાળા ગિયર્સ સાથે જોડાયેલો મોટો દરવાજો.
- **Rule:**
  - Gear Lock લિંક થયેલા Island Spinner (M301) સાથે જોડાયેલું હોય છે.
  - દરવાજો માત્ર ત્યારે જ ખુલ્લો રહે છે જ્યારે રોટર તેના નિર્ધારિત માર્ક કરેલા એંગલ (દા.ત. 180°) પર સ્થિર હોય.
  - રોટર અન્ય કોઈ ખૂણે હોય ત્યારે ગેટ બંધ રહે છે અને બ્લોકર બને છે.
- **JSON Format:**
  ```json
  {"id": "o304_1", "type": "M304", "cells": [[10, 6]], "params": {"linkedRotorId": "o301_1", "unlockAngle": 180}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 6. Tick Order Integration (§16.17)
1. Player action resolve (સાપ એક્ઝિટ અથવા રોટર ટેપ).
2. `moveCount += 1`.
3. Rotation Step:
   - M302 Turning Hedges 1 સેલ CW આગળ સરકે છે.
   - M303 Spinning Snakes 90° CW દિશા બદલે છે.
4. Derived states & Gear Locks (M304) અપડેટ થાય છે.
5. Win check.
