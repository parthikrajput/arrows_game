# 03 · Signature System & Base Mechanics Phase 8 — Toy Trains
> હેતુ: Phase 8 ની signature system (Overgrown Branch Line / Growth) અને 4 નવા railway base mechanics (M351–M354) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_8_SCOPE_AND_RULES.md)

---

## 1. Signature System: Overgrown Branch Line (`S08`)
- **Core Concept:** જૂની રેલ્વે લાઇન પર જંગલી વેલનું ઝડપી વિસ્તરણ. સમયસર કાપણી ન થાય તો વેલ પાટા જામ કરી દે છે.
- **Growth Tick Order:** Move resolution order ના **Step 3** માં `moveCount % N == 0` વખતે વેલ ફેલાય છે.

---

## 2. New Base Mechanics (M351–M354)

### M351 · Wild Ivy+ (Vine Spread+)
- **Intro Level:** L3511 (Block 2, x1)
- **Category:** C (Aggressive Spreader Blocker)
- **Exact Rule:** જંગલી વેલ. દર N Moves એ (Step 3 tick) તે પોતાના ખાલી પાડોશી સેલ્સમાંથી મહત્તમ **2 મુક્ત સેલ્સ** માં વિસ્તરે છે (`Up -> Right -> Down -> Left` ના નિશ્ચિત ક્રમમાં). વેલ પર આવતી ટ્રેન બમ્પ થઈ −1 Heart ગુમાવે છે.
- **Hammerable:** Yes (Track Crane 1 વેલ સેલ સાફ કરે છે).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M351", "cells": [[4, 4]], "params": {"period": 2, "maxSpread": 2}, "hammerable": true}
  ```

---

### M352 · Hedge Trimmer Car (Pruner Tile)
- **Intro Level:** L3631 (Block 14, x1)
- **Category:** T (Active Track Cleaner)
- **Exact Rule:** હેજ ટ્રીમર બ્લેડ સેલ. જ્યારે કોઈ ટ્રેનની exit lane આ સેલ પરથી પૂર્ણપણે પસાર થાય છે, ત્યારે તે લેનની બંને બાજુ ઓર્થોગોનલી અડીને રહેલા તમામ વેલ સેલ્સ (Wild Ivy) તરત કપાઈને દૂર થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M352", "cells": [[5, 6]], "params": {}, "hammerable": false}
  ```

---

### M353 · Seed Wagon (Seed Path)
- **Intro Level:** L3751 (Block 26, x1)
- **Category:** P (Spore Drop Locomotive)
- **Exact Rule:** બીજ વહન કરતી સ્પેશિયલ ટ્રેન. આ ટ્રેન જ્યારે બોર્ડ છોડીને Toy Box Station માં જાય છે, ત્યારે તે પોતાના છેલ્લા બોડી સેલ પર 1 બીજ છોડી જાય છે. N Moves પછી તે બીજ ફૂટીને નવી Wild Ivy બની જાય છે.
- **Hammerable:** Yes (Track Crane ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p1", "type": "path", "cells": [[2, 3], [2, 4]], "dir": "U", "params": {"seedDelay": 3}}
  ```

---

### M354 · Flower Arch (Bloom Gate)
- **Intro Level:** L3871 (Block 38, x1)
- **Category:** B (Botanical Condition Gate)
- **Exact Rule:** બ્લૂમ ગેટ. શરૂઆતમાં આ કમાન બંધ હોય છે અને પાટો બ્લોક કરે છે. જ્યારે બોર્ડ પર ફેલાતી વેલના K સેલ્સ (દા.ત. K = 4) આ કમાનની બોર્ડરને સ્પર્શે છે, ત્યારે ફૂલો ખીલી ઊઠે છે અને કમાન કાયમી રીતે ખુલી જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M354", "cells": [[7, 5]], "params": {"requiredIvy": 4}, "hammerable": false}
  ```

---

## 3. Solver & Engine Integration
- Solver વેલના વિસ્તરણને Step 3 માં સિમ્યુલેટ કરે છે.
- Flower Arch ની ખુલવાની શરત Step 4 (Derived states) માં ચેક થાય છે.
