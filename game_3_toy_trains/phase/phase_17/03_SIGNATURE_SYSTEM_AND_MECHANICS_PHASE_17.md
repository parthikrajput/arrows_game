# 03 · Signature System & Base Mechanics Phase 17 — Toy Trains
> હેતુ: Phase 17 ની signature system (Clock Towers / Guardians / Guardian Boss Puzzles) અને 4 નવા railway base mechanics (M801–M804) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_17_SCOPE_AND_RULES.md)

---

## 1. Signature System: Clock Towers (`S17`)
- **Core Concept:** ગાર્ડિયન બોસ પઝલ. વિશાળ લાકડાના ક્લોક ટાવર્સ જે HP પૂલ ધરાવે છે અને પાટા પર અવરોધો સ્પોન કરે છે. આ ટાવર્સને પરાસ્ત કરવા માટે ખેલાડીએ ચોક્કસ ક્રમમાં ટ્રેનો બહાર કાઢવી, સ્પોન થયેલા બફર સ્ટોપ્સ સાફ કરવા અને છેવટે લાઇટ બીમ વડે કોર સેલને નષ્ટ કરવો પડે છે.
- **Tick Order Integration:**
  - Depot Tower Spawner: Step 3 (Mechanic Ticks) માં દર N Moves એ ખાલી પાડોશી સેલમાં બફર સ્ટોપ ઉમેરે છે.
  - Guardian Damage Check: Step 2 (Passive Triggers) માં ટ્રેન એક્ઝિટ થતાં જ સંલગ્ન શિલ્ડ/ટાવર HP માંથી ૧ પોઇન્ટ ઘટાડે છે.
  - Light Beam Trigger: Step 2 માં સિગ્નલ લેમ્પ બીમ કોર સેલ પર પડતાં જ HP શૂન્ય થયેલ કોર નાશ પામે છે.

---

## 2. New Base Mechanics (M801–M804)

### M801 · Twin Clock Towers (Twin Guardian)
- **Intro Level:** L8011 (Block 2, x1)
- **Category:** B / C (Shared HP Boss Blocker)
- **Exact Rule:** બે જોડિયા ક્લોક ટાવર્સ ($2\times 2$ સેલ્સ દરેક) જે એક જ સંયુક્ત HP પૂલ (દા.ત. 6 HP) શેર કરે છે. કોઈપણ ટાવરની આસપાસથી સંલગ્ન ટ્રેન એક્ઝિટ થાય ત્યારે પૂલમાંથી ૧ HP ઘટે છે. જ્યારે HP 0 થાય ત્યારે બંને ટાવર્સ એકસાથે તૂટીને નાશ પામે છે અને પાટો મુક્ત બને છે.
- **Hammerable:** No (Track Crane થી ટાવર તોડી શકાતો નથી).
- **JSON Definition:**
  ```json
  {"id": "o1_twin", "type": "M801", "cells": [[3, 3], [3, 4], [4, 3], [4, 4], [8, 8], [8, 9], [9, 8], [9, 9]], "params": {"sharedHp": 6}, "hammerable": false}
  ```

---

### M802 · Armoured Clock Tower (Shield Guardian)
- **Intro Level:** L8131 (Block 14, x1)
- **Category:** B / L (Order-Dependent Shield Boss)
- **Exact Rule:** લોખંડી કવચ ધરાવતો ટાવર. ટાવરની આસપાસ દર્શાવેલા રંગ ક્રમ મુજબ (દા.ત. Red -> Blue -> Yellow) ટ્રેનો બહાર નીકળે તો જ કવચ તૂટે છે અને તેનું HP ઘટે છે. જો અન્ય રંગની ટ્રેન નીકળે તો ટાવર કોઈ ડેમેજ લેતો નથી.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M802", "cells": [[5, 5], [5, 6], [6, 5], [6, 6]], "params": {"hp": 4, "damageSequence": ["red", "blue", "yellow"]}, "hammerable": false}
  ```

---

### M803 · Depot Tower (Spawner Guardian)
- **Intro Level:** L8251 (Block 26, x1)
- **Category:** B / S (Blocker Spawner Boss)
- **Exact Rule:** રેલ્વે ડિપો ટાવર. દર N Moves એ (દા.ત. N = 3, Step 3 tick) પોતાના ખાલી ઓર્થોગોનલ પાડોશી સેલમાં નવો બફર સ્ટોપ (M001 Blocker) સ્પોન કરે છે. જ્યારે તેનું HP 0 થાય છે ત્યારે તે સ્પોન કરવાનું બંધ કરે છે અને પાટા પરથી અદૃશ્ય થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M803", "cells": [[6, 8]], "params": {"hp": 3, "spawnPeriod": 3}, "hammerable": false}
  ```

---

### M804 · Clock Core (Guardian Core)
- **Intro Level:** L8371 (Block 38, x1)
- **Category:** B / K (Multi-Condition Core)
- **Exact Rule:** ટાવરનું સંવેદનશીલ હૃદય/કોર સેલ. જ્યારે તેનું HP 0 થાય છે ત્યારે પણ તે તરત નાશ પામતો નથી; જ્યાં સુધી સિગ્નલ લેમ્પનો બીમ (Signal Light Beam M251) સીધો તેના સેલ પર ન પડે ત્યાં સુધી તે પાટા પર અવરોધ તરીકે રહે છે. બીમ પડતાં જ તે કાયમી વિખેરાઈ જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M804", "cells": [[5, 5]], "params": {"hp": 0, "needsBeam": true}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **Boss State Management:** સ્ટેટ વેક્ટરમાં દરેક ટાવરનું `currentHp`, `shieldBroken` અને `nextSpawnMove` ટ્રેક થાય છે.
- **Aggressive Pruning:** સ્પોનર ડિપો ટાવરના બફર સ્ટોપ્સ પાટા સંપૂર્ણ જામ કરી દે તે પહેલાં સોલ્વર ટાવર પર હુમલો કરતી (ડેમેજ આપતી) ટ્રેનોને ઉચ્ચ અગ્રતા (Heuristic Priority) આપે છે.
- **Beam Routing Graph:** M804 માટે સોલ્વર લાઇટ બીમના પાથને ક્લિયર કરવાની સમાંતર યોજના બનાવે છે.
