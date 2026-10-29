# 03 — Signature System & Base Mechanics (Phase 5)
> Phase 5 (Coconut Grove Physics) ની signature system અને 4 નવા base mechanics (M201–M204) ના નિયમો, parameters, edge cases, tick order (§16.17), solver impact અને solvability guarantees.

**Related docs:** [Phase 5 index](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Phase 5 Rules](./01_PHASE_5_SCOPE_AND_RULES.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md)

---

## 1. Signature System: Coconut Grove Physics (Push Physics+)
- **Concept:** જંગલમાં નારિયેળ અને મોટા ફળોને ધકેલવાના નિયમો. સાપનું માથું બ્લોકને આગળ ધકેલે છે, જેનાથી બોર્ડની રચના (Terrain) બદલાય છે.
- **Rules:**
  - નારિયેળની પાછળનો સેલ ખાલી હોય તો જ તે ધકેલાય છે; અન્યથા સાપ બોંક થાય છે (−1 Heart).
  - Open Edge પર ધકેલાતાં બ્લોક બોર્ડ બહાર પડીને દૂર થાય છે (standard §17.29).
  - નારિયેળ પર હેમર વાપરી શકાય છે (M053/M054 defaults, standard §16.18); પરંતુ Jackfruit Boulder (M204) hammerable નથી.

---

## 2. Mechanic M201: Coconut Pit (Crate Holes)
- **Intro Level:** L2011 (Block 2 x1)
- **Category:** Terrain Hole / Push Target (B / D)
- **Visual:** જમીનમાં પડેલો ઊંડો ગોળ ખાડો (Pit).
- **Rule:**
  - **ખાલી અવસ્થા:** ખાડો સોલિડ લેન બ્લોકર તરીકે વર્તે છે (સાપ તેના પર જઈ શકતો નથી; જતાં માથું ભટકાય છે).
  - **ભરાયેલી અવસ્થા:** જ્યારે કોઈપણ નારિયેળ (M053, M202) ને ધકેલીને આ ખાડામાં નાખવામાં આવે, ત્યારે નારિયેળ ખાડામાં બેસી જાય છે.
  - ખાડો ભરાતાં જ તે **સામાન્ય ફ્લોર (Plain Floor)** બની જાય છે! હવે કોઈપણ સાપ તેના પરથી મુક્તપણે પસાર થઈ શકે છે.
  - એક વાર ભરાયેલો ખાડો કાયમ માટે ફ્લોર રહે છે.
- **JSON Format:**
  ```json
  {"id": "o201_1", "type": "M201", "cells": [[5, 5]], "params": {"filled": false}, "hammerable": false}
  ```
- **Hammerable:** `false` (ખાડો હેમરથી તૂટી શકતો નથી).

---

## 3. Mechanic M202: Dew-Slick Coconut (Sliding Ice Crates)
- **Intro Level:** L2131 (Block 14 x1)
- **Category:** Pushable Block / Momentum (D)
- **Visual:** ઝાકળથી લપસણું બનેલું લીલું નારિયેળ.
- **Rule:**
  - સામાન્ય નારિયેળ માત્ર 1 સેલ ખસે છે; જ્યારે **Dew-Slick Coconut** ને ધક્કો મારતાં તે દિશામાં **જ્યાં સુધી આગળનો સેલ ખાલી હોય ત્યાં સુધી લપસતું રહે છે (Continuous Slide)**.
  - તે દિવાલ, અન્ય સાપ, બ્લોકર કે ખાડા (M201) પાસે પહોંચીને જ અટકે છે.
  - જો તે ખાડા (M201) માં પ્રવેશે, તો તરત જ ખાડામાં પડીને અટકી જાય છે અને ખાડો ફ્લોર બની જાય છે.
  - જો તે ખુલ્લી કિનારી (Open Edge) તરફ સરકે, તો સીધું બોર્ડ બહાર પડી જાય છે.
- **JSON Format:**
  ```json
  {"id": "o202_1", "type": "M202", "cells": [[4, 8]], "params": {}, "hammerable": true}
  ```
- **Hammerable:** `true`.

---

## 4. Mechanic M203: Key Coconut (Crate Keys)
- **Intro Level:** L2251 (Block 26 x1)
- **Category:** Pushable Key Token (D / K)
- **Visual:** સોનેરી ચાવી જડેલું નારિયેળ.
- **Rule:**
  - આ નારિયેળ પોતાના પર એક ચાવી ધરાવે છે.
  - તેને ધકેલીને બોર્ડ પર આવેલા મેચિંગ લોક સેલ (Lock Cell) પર બેસાડવું પડે છે.
  - જ્યારે Key Coconut લોક સેલ પર પહોંચે છે, ત્યારે લોક કાયમ માટે ખુલી જાય છે (અને કી નારિયેળ સામાન્ય નારિયેળ બની જાય છે).
  - સાપ સીધો આ કી ઉપાડી શકતો નથી; તેને ધકેલીને જ લોક સુધી પહોંચાડવો પડે છે.
- **JSON Format:**
  ```json
  {"id": "o203_1", "type": "M203", "cells": [[8, 3]], "params": {"targetLockId": "lock_1"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 5. Mechanic M204: Jackfruit Boulder (Heavy Crate)
- **Intro Level:** L2371 (Block 38 x1)
- **Category:** Heavy Pushable Blocker (B / D)
- **Visual:** કાંટાળું અને ખૂબ ભારે મોટું ફણસ (Jackfruit Boulder).
- **Rule:**
  - આ બ્લોક અત્યંત ભારે છે. સામાન્ય એક સાપ તેને ધક્કો મારી શકતો નથી (સામાન્ય સાપ અથડાતાં બોંક થાય છે અને −1 Heart થાય છે).
  - તેને ધકેલવા માટે નીચેનામાંથી કોઈ એક શરત જરૂરી છે:
    1. **Giant Anaconda (M049):** જાયન્ટ સાપનું માથું તેને ધક્કો મારીને 1 સેલ ખસેડી શકે છે.
    2. **Chained Group Push:** જો બે સાપ એકસાથે જોડાયેલા હોય (`Chained` modifier).
- **JSON Format:**
  ```json
  {"id": "o204_1", "type": "M204", "cells": [[7, 7]], "params": {"requiredPower": "heavy"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 6. Tick Order Integration (§16.17)
1. Player action resolve:
   - સાપ આગળ વધે છે → નારિયેળ સાથે ટક્કર.
   - જો માન્ય ધક્કો હોય: નારિયેળ સ્લાઇડ/મૂવ થાય છે.
   - જો ખાડા (M201) માં પડે: ખાડો સેલ સ્ટેટ ફ્લોરમાં બદલાય છે.
   - જો લોક (M203) પર બેસે: ગેટ સ્ટેટ ઓપન થાય છે.
2. `moveCount += 1`.
3. Derived states & checks.
4. Win check.

