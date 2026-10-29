# 03 · Signature System & Base Mechanics Phase 15 — Toy Trains
> હેતુ: Phase 15 ની signature system (Moving Platforms / Conveyors & Motorized Tracks) અને 4 નવા railway base mechanics (M701–M704) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 15 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_15_SCOPE_AND_RULES.md)

---

## 1. Signature System: Moving Platforms (`S15`)
- **Core Concept:** મોટરાઇઝ્ડ રેલ્વે યાર્ડ. ટ્રેક પોતે કન્વેયર બેલ્ટ છે જે તેના પર રહેલી ટ્રેનોને આગળ ધકેલે છે. ખેલાડીએ સ્વિચ અને લીવર્સ વડે બેલ્ટનો પ્રવાહ નિયંત્રિત કરીને ટ્રેનોને યોગ્ય સ્ટેશન એક્ઝિટ તરફ વાળવાની રહે છે.
- **Tick Order Integration:**
  - Interactive Lever / Switch: Step 1 (Player Action) માં resolve થાય છે (1 Move).
  - Conveyor Advance: Step 3 (Mechanic Ticks) માં સક્રિય કન્વેયર પર રહેલી તમામ ટ્રેનો પ્રવાહની દિશામાં 1 સેલ આગળ સરકે છે (જો આગળનો સેલ ખાલી હોય).

---

## 2. New Base Mechanics (M701–M704)

### M701 · Belt Switch (Belt Junction)
- **Intro Level:** L7011 (Block 2, x1)
- **Category:** T (Interactive Conveyor Switch)
- **Exact Rule:** કન્વેયર બેલ્ટ જંકશન. જ્યારે ટ્રેક બે દિશાઓમાં વિભાજિત થાય છે (Left / Right), ત્યારે આ સ્વિચ પર ટેપ કરવાથી (1 Move) પ્રવાહનો માર્ગ ડાબેથી જમણે ટોગલ થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M701", "cells": [[5, 6]], "params": {"currentBranch": "L", "branches": ["L", "R"]}, "hammerable": false}
  ```

---

### M702 · Reversing Belt (Reversible Belt)
- **Intro Level:** L7131 (Block 14, x1)
- **Category:** T / B (Direction-Inversion Conveyor)
- **Exact Rule:** રિવર્સિંગ કન્વેયર બેલ્ટ. લિન્ક્ડ લીવર પર ટેપ કરતાં જ સંલગ્ન તમામ બેલ્ટ સેલ્સની ગતિ દિશા $180^\circ$ ઉલટાઈ જાય છે (દા.ત. Up <-> Down).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M702", "cells": [[3, 4], [3, 5], [3, 6]], "params": {"flowDir": "U", "leverId": "lev_1"}, "hammerable": false}
  ```

---

### M703 · Belt Stop Lever (Belt Lever)
- **Intro Level:** L7251 (Block 26, x1)
- **Category:** T (Conveyor Clutch Brake)
- **Exact Rule:** કન્વેયર બ્રેક લીવર. ટેપ કરવાથી (1 Move) લિન્ક્ડ બેલ્ટ્સ અટકી જાય છે (Paused/Stopped). સ્ટોપ થયેલા બેલ્ટ સામાન્ય સ્થિર પાટા જેવું વર્તન કરે છે. ફરી ટેપ કરતાં બેલ્ટ ફરી શરૂ થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M703", "cells": [[8, 4]], "params": {"isRunning": true, "linkedBelts": ["b1", "b2"]}, "hammerable": false}
  ```

---

### M704 · Loop Belt (Track Loop)
- **Intro Level:** L7371 (Block 38, x1)
- **Category:** B / P (Closed Circular Conveyor)
- **Exact Rule:** બંધ કન્વેયર રીંગ. આ લૂપમાં રહેલી ટ્રેનો દર મૂવ વખતે ક્લોકવાઇઝ 1 સેલ પરિભ્રમણ કરે છે. જ્યારે ટ્રેનનું મુખ બહાર નીકળતી શાખા સાથે સંરેખિત થાય ત્યારે પ્લેયર ટેપ કરીને તેને લૂપમાંથી બહાર કાઢી શકે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M704", "cells": [[6, 6], [6, 7], [7, 7], [7, 6]], "params": {"loopDir": "CW"}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **State Representation:** બોર્ડ સ્ટેટમાં દરેક કન્વેયર સેલનો `flowDir` અને `isRunning` સ્ટેટસ સ્ટોર થાય છે.
- **Advance Ordering:** કન્વેયર પરની ટ્રેનો માટે આગળના સેલ્સ પહેલાં ચેક થાય છે (Tail-to-head evaluation) જેથી ક્રાઉડિંગ વખતે અથડામણ ન થાય.
- **Infinite Loop Protection:** Loop Belt માં સતત ફરતી ટ્રેનો માટે સોલ્વર વિઝિટેડ સ્ટેટ્સ હેશિંગ ($H(\text{board}, \text{moveCount} \bmod \text{period})$) વાપરીને અનંત લૂપ્સ અટકાવે છે.
