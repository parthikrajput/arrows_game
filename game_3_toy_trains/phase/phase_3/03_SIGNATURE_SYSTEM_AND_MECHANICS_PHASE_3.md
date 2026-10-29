# 03 · Signature System & Base Mechanics Phase 3 — Toy Trains
> હેતુ: Phase 3 ની signature system (Day & Night Timetable / Cycles) અને 4 નવા railway base mechanics (M101–M104) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_3_SCOPE_AND_RULES.md)

---

## 1. Signature System: Day & Night Timetable (`S03`)
- **Core Concept:** ટ્રેન સર્વિસ દિવસ અને રાત્રિના ટાઇમટેબલ વચ્ચે બદલાય છે.
- **State Transition:**
  - દર 5 Moves એ બોર્ડ State A (Day Service) અને State B (Night Service) વચ્ચે ફ્લિપ થાય છે.
  - Tick Order ના **Step 3** માં `moveCount % 5 == 0` વખતે state toggle થાય છે.
- **Visuals:** બોર્ડના honey-oak રંગ પર soft daylight થી warm evening amber લેમ્પલાઇટનું ટ્રાન્ઝિશન.
- **HUD Indicator:** ઉપરના બારમાં Sun/Moon dial જે ચાલુ મોડ અને આગામી સ્વિચ સુધીના બાકી રહેલા Moves બતાવે છે.

---

## 2. New Base Mechanics (M101–M104)

### M101 · Day/Night Gate (Cycle Gate)
- **Intro Level:** L1011 (Block 2, x1)
- **Category:** B (Blocker / Gate)
- **Exact Rule:** Gate cell જે State A માં ખુલ્લું રહે છે અને State B માં બંધ થઈ જાય છે (અથવા `params.openIn: "B"` મુજબ ઊલટું). બંધ સ્થિતિમાં ટ્રેન બમ્પ થઈને −1 heart ગુમાવે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M101", "cells": [[6, 4]], "params": {"openIn": "A"}, "hammerable": false}
  ```

---

### M102 · Day/Night Overpass (Cycle Bridge)
- **Intro Level:** L1131 (Block 14, x1)
- **Category:** L (Layer / Bridge)
- **Exact Rule:** State A માં આ cell Wooden Overpass (M015) તરીકે વર્તે છે (નીચેથી અને ઉપરથી ટ્રેનો એકબીજાને બ્લોક કર્યા વિના પસાર થઈ શકે છે). State B માં ઓવરપાસ નીચે બેસી જાય છે અને Single Blocker તરીકે બંને ટ્રેક્સને બ્લોક કરે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M102", "cells": [[7, 5]], "params": {"openIn": "A"}, "hammerable": false}
  ```

---

### M103 · Day/Night Tunnel (Cycle Portal)
- **Intro Level:** L1251 (Block 26, x1)
- **Category:** D (Directional / Portal)
- **Exact Rule:** Tunnel pair પોર્ટલ્સ. State A માં સુરંગ ખુલ્લી રહે છે અને ટ્રેન એક છેડેથી પ્રવેશી બીજા છેડેથી તે જ દિશામાં નીકળે છે. State B માં સુરંગના દરવાજા બંધ થઈ જાય છે અને સુરંગના બંને મુખ blockers બની જાય છે (બમ્પ ⇒ −1 heart).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M103", "cells": [[2, 8], [9, 8]], "params": {"openIn": "A"}, "hammerable": false}
  ```

---

### M104 · Day/Night Livery (Cycle Color)
- **Intro Level:** L1371 (Block 38, x1)
- **Category:** P (Train Variant)
- **Exact Rule:** સ્પેશિયલ ટ્રેન જેની પાસે બે વૈકલ્પિક રંગો (દા.ત. Red Day / Blue Night) હોય છે. દરેક A/B ફ્લિપ વખતે ટ્રેનનો રંગ આપોઆપ સ્વેપ થાય છે. રંગ આધારિત દરવાજા (M005 Platform Gate, M030 Station Exit, M033 Locked Siding) સાથે ક્રિયાપ્રતિક્રિયા કરે છે.
- **Hammerable:** Yes (Track Crane ટ્રેનને લિફ્ટ કરી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p1", "type": "path", "cells": [[3, 2], [3, 3], [3, 4]], "dir": "U", "color": "red", "params": {"nightColor": "blue"}}
  ```

---

## 3. Solver & Engine Integration
- Solver ના state representation માં cycle counter `(moveCount % 5)` અને current cycle state (`A` or `B`) નો સમાવેશ થાય છે.
- State toggle વખતે M101, M102, M103 ના collision hitboxes અને M104 ના color attributes ડિટર્મિનિસ્ટિક રીતે અપડેટ થાય છે.
