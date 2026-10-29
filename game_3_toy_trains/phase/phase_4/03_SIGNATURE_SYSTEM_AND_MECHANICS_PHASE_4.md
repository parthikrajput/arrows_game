# 03 · Signature System & Base Mechanics Phase 4 — Toy Trains
> હેતુ: Phase 4 ની signature system (Station Floors / Multi-Floor) અને 4 નવા railway base mechanics (M151–M154) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_4_SCOPE_AND_RULES.md)

---

## 1. Signature System: Station Floors (`S04`)
- **Core Concept:** ભવ્ય મલ્ટી-લેવલ રેલ્વે સ્ટેશન જેમાં F1 (ગ્રાઉન્ડ યાર્ડ), F2 (મેઝેનાઇન પ્લેટફોર્મ), અને F3 (હાઇ લાઇન વાયાડક્ટ) ત્રિપરિમાણીય રીતે ગોઠવાયેલા છે.
- **Floor Navigation:**
  - UI પર `F1`, `F2`, `F3` ટેબ્સ દ્વારા કેમેરા સ્વિચ થાય છે (0 Moves).
  - એક ફ્લોર પરની ટ્રેન બીજા ફ્લોર પર સ્થાનાંતરિત થવા માટે વિશિષ્ટ ઊર્ધ્વગામી સાધનો (Stairs, Chutes, Lifts) વાપરે છે.

---

## 2. New Base Mechanics (M151–M154)

### M151 · Station Stairs (Stairs)
- **Intro Level:** L1511 (Block 2, x1)
- **Category:** D (Directional / Vertical Portal)
- **Exact Rule:** રેલ્વે સીડીનો સેલ. ટ્રેનની exit lane આ સેલ પર પહોંચતાં ટ્રેન લિંક કરેલા ફ્લોર પર સમાન `(x, y)` કોઓર્ડિનેટથી તે જ દિશામાં પોતાની યાત્રા ચાલુ રાખે છે. જો લક્ષ્ય ફ્લોર પર સેલ ઓક્યુપાઇડ હોય તો બમ્પ (−1 heart).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M151", "cells": [[4, 6]], "params": {"targetFloor": 2}, "hammerable": false}
  ```

---

### M152 · Glass Platform (Glass Floor)
- **Intro Level:** L1631 (Block 14, x1)
- **Category:** L (Layer / Platform)
- **Exact Rule:** કાચનું પારદર્શક પ્લેટફોર્મ. ઉપલા ફ્લોર પર આ સેલ ટ્રેન માટે સામાન્ય ટ્રેક તરીકે વર્તે છે, પરંતુ તેના દ્વારા નીચેના ફ્લોરની ટ્રેનો સ્પષ્ટ દેખાય છે અને નીચેની ટ્રેનને સીધી tap કરી શકાય છે (કોઈ લોક નથી, ઉપલી ટ્રેન નીચેની ટ્રેનને ઢાંકતી નથી).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M152", "cells": [[6, 6], [6, 7]], "params": {}, "hammerable": false}
  ```

---

### M153 · Goods Chute (Drop Hole)
- **Intro Level:** L1751 (Block 26, x1)
- **Category:** D (Directional / Relocation)
- **Exact Rule:** માલસામાન નીચે નાખવાનો ડ્રોપ હોલ. Exit lane આ ખાડા સુધી પહોંચતાં ટ્રેન નીચેના ફ્લોર પર સમાન `(x, y)` સેલ પર પડે છે (relocate, 1 Move). તે પછીના tap પર ટ્રેન નીચેના ફ્લોરથી પોતાની મૂળ દિશામાં આગળ વધે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M153", "cells": [[8, 3]], "params": {"targetFloor": 1}, "hammerable": false}
  ```

---

### M154 · Goods Lift (Elevator)
- **Intro Level:** L1871 (Block 38, x1)
- **Category:** T (Interactive / Transport)
- **Exact Rule:** રેલ્વે ગુડ્સ લિફ્ટ પ્લેટફોર્મ. જ્યારે કોઈ ટ્રેન સંપૂર્ણપણે લિફ્ટના પાટા પર ઊભી હોય, ત્યારે લિફ્ટ બટન પર tap કરવાથી (1 Move) લિફ્ટ ટ્રેન સહિત ઉપરના/નીચેના ફ્લોર પર પહોંચી જાય છે. આંશિક રીતે ઊભેલી ટ્રેન વખતે tap = locked tap.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M154", "cells": [[5, 5], [5, 6]], "params": {"connectedFloor": 2}, "hammerable": false}
  ```

---

## 3. Solver & Engine Integration
- Solver state માં દરેક ટ્રેનનું `floorIndex` ટ્રેક થાય છે.
- સ્ટેજ ટ્રાન્ઝિશન વખતે વર્ટિકલ અથડામણ (vertical collision checks) સોલ્વરના સર્ચ ગ્રાફમાં એકીકૃત છે.

