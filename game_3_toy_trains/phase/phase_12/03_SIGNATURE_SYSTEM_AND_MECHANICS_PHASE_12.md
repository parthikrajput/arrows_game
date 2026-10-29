# 03 · Signature System & Base Mechanics Phase 12 — Toy Trains
> હેતુ: Phase 12 ની signature system (Hill Line / Gravity Physics) અને 4 નવા railway base mechanics (M551–M554) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 12 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_12_SCOPE_AND_RULES.md)

---

## 1. Signature System: Hill Line (`S12`)
- **Core Concept:** પર્વતીય ચઢાણ અને ઢોળાવવાળી રેલ્વે લાઇન. સમગ્ર પ્લેટેબલ એક ચોક્કસ દિશામાં ઢળેલું રહે છે (Gravity Vector: $g \in \{U, R, D, L\}$).
- **Tick Order Integration:**
  - Tilt Lever Tap: Step 1 (Player Action) માં resolve થાય છે અને ગ્રેવિટી વેક્ટર અપડેટ કરે છે (1 Move).
  - Falling / Rolling Step: Step 3 (Mechanic Ticks) માં મુક્ત Loose Crates (M552) અને Ballast Trains (M554) ગ્રેવિટીની દિશામાં 1 સેલ આગળ સરકે છે.

---

## 2. New Base Mechanics (M551–M554)

### M551 · Tilt Lever (Gravity Lever)
- **Intro Level:** L5511 (Block 2, x1)
- **Category:** T (Interactive Track Incline Lever)
- **Exact Rule:** ટિલ્ટ લીવર. ટેપ કરવાથી (1 Move) બોર્ડની ગુરુત્વાકર્ષણની દિશા $90^\circ$ ક્લોકવાઇઝ ફરે છે (`Down -> Left -> Up -> Right`). સ્ક્રીન પર હોકાયંત્રનો એરો બદલાય છે અને તમામ લૂઝ આઇટમ્સ નવી દિશામાં સરકવા લાગે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M551", "cells": [[4, 4]], "params": {"currentDir": "D"}, "hammerable": false}
  ```

---

### M552 · Loose Crates (Falling Blockers)
- **Intro Level:** L5631 (Block 14, x1)
- **Category:** B (Sliding Dynamic Blocker)
- **Exact Rule:** લૂઝ લાકડાના કાર્ગો ક્રેટ્સ. દરેક મૂવ પછી (Step 3 tick), જો તેમની ગ્રેવિટી દિશામાં સામેનો સેલ ખાલી હોય, તો તેઓ 1 સેલ નીચે સરકે છે જ્યાં સુધી રોકાણ ન આવે. ટ્રેન સાથે અથડાતાં ટ્રેન બમ્પ થઈ −1 Heart ગુમાવે છે.
- **Hammerable:** Yes (Track Crane 1 ક્રેટ હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M552", "cells": [[6, 8]], "params": {}, "hammerable": true}
  ```

---

### M553 · Balloon Pad (Anti-grav Tile)
- **Intro Level:** L5751 (Block 26, x1)
- **Category:** T / P (Anti-Gravity Safety Tile)
- **Exact Rule:** ફુગ્ગા આકારનું સ્પેશિયલ પેડ. જ્યારે કોઈ લૂઝ ક્રેટ સરકીને આ પેડ પર આવે છે, ત્યારે તે ગુરુત્વાકર્ષણ પ્રભાવ મુક્ત થઈ સ્થિર બને છે અને નીચે પડતો નથી જ્યાં સુધી કોઈ ટ્રેન તેને પુશ ન કરે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M553", "cells": [[3, 8]], "params": {}, "hammerable": false}
  ```

---

### M554 · Ballast Train (Weight Path)
- **Intro Level:** L5871 (Block 38, x1)
- **Category:** P (Autonomous Rolling Locomotive)
- **Exact Rule:** પથ્થરથી ભરેલી ભારે ટ્રેન. જો તેનો આગળનો પાટો ખાલી હોય અને તેની ફેસિંગ દિશા હાલની ગ્રેવિટી દિશા સાથે સંરેખિત (aligned) હોય, તો તે પ્લેયરના ટેપ વિના પણ દર મૂવ વખતે આપોઆપ 1 સેલ નીચે તરફ સરકે છે.
- **Hammerable:** Yes (Track Crane સંપૂર્ણ ટ્રેનને હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p_ballast", "type": "path", "cells": [[8, 2], [8, 3]], "dir": "D", "params": {"autoRoll": true}}
  ```

---

## 3. Solver & Engine Impact
- **State Representation:** બોર્ડ સ્ટેટમાં `gravityDir` અને તમામ સ્લાઇડિંગ એન્ટિટીઝના કોઓર્ડિનેટ્સ ટ્રેક થાય છે.
- **Physics Tick Ordering:** ક્રેટ્સ સૌથી નીચે રહેલા સેલથી શરૂ કરીને ઉપર તરફ સરકે છે (Bottom-up sliding) જેથી સ્ટેકીંગ લોજિક ચોક્કસ રીતે જળવાય.
- **Deadlock Detection:** જો કોઈ ક્રેટ એક્ઝિટ એજને કાયમી બ્લોક કરી દે અને લીવર ઉપલબ્ધ ન હોય, તો સોલ્વર તે બ્રાન્ચને તરત જ પ્રૂન કરે છે.
