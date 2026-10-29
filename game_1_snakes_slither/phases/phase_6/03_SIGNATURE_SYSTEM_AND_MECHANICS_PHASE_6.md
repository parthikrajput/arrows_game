# 03 — Signature System & Base Mechanics (Phase 6)
> Phase 6 (Sun Temple Light) ની signature system અને 4 નવા base mechanics (M251–M254) ના નિયમો, parameters, edge cases, tick order (§16.17), solver impact અને solvability guarantees.

**Related docs:** [Phase 6 index](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Phase 6 Rules](./01_PHASE_6_SCOPE_AND_RULES.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md)

---

## 1. Signature System: Sun Temple Light (Light & Beams+)
- **Concept:** સૂર્ય મંદિરના પ્રાચીન કિરણો અને સ્ફટિકો. કિરણોનું રંગ ફિલ્ટરિંગ, બહુ-કિરણ તાળાઓ, સનડાયલ ટાઈમર્સ અને અંધારા સેલ્સ.
- **Rules:**
  - Sunbeams સીધી રેખામાં પ્રવાસ કરે છે અને અરીસાઓ (M085) દ્વારા 90° એ વળે છે.
  - બીમ સાપના શરીર દ્વારા અવરોધાય છે (ઓપેક બોડી બ્લોકિંગ).
  - Step 4 (Move resolution) માં તમામ કિરણો તરત જ ફરીથી ટ્રેસ થાય છે.

---

## 2. Mechanic M251: Petal Filter (Color Filter)
- **Intro Level:** L2511 (Block 2 x1)
- **Category:** Optical Filter (D)
- **Visual:** પારદર્શક રંગીન પાંખડીઓવાળું મોટું જંગલી ફૂલ (દા.ત. Ruby Petal Filter).
- **Rule:**
  - કોઈપણ બીમ જ્યારે Petal Filter માંથી પસાર થાય છે, ત્યારે તે ફિલ્ટરનો રંગ ધારણ કરે છે (દા.ત. White beam -> Ruby beam).
  - ફિલ્ટર સાપની લેન માટે બ્લોકર નથી (સાપ તેના પરથી મુક્તપણે પસાર થઈ શકે છે).
  - જો સાપ ફિલ્ટરના સેલ પર ઊભો રહે, તો બીમ અટકી જાય છે (ઓપેક સાપ).
  - રંગીન રીસીવર્સ (Colored Receivers) માત્ર પોતાના મેચિંગ રંગના બીમ દ્વારા જ સક્રિય થાય છે.
- **JSON Format:**
  ```json
  {"id": "o251_1", "type": "M251", "cells": [[4, 5]], "params": {"filterColor": "ruby"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 3. Mechanic M252: Prism Lock (Beam Splitter Lock)
- **Intro Level:** L2631 (Block 14 x1)
- **Category:** Optical Lock (G)
- **Visual:** સ્ફટિક પ્રિઝમ જડેલું પથ્થરનું ગેટ.
- **Rule:**
  - Prism Lock માત્ર ત્યારે જ કાયમ માટે ખુલે છે (Permanently Latches Open) જ્યારે **એક જ Move માં $\ge 2$ કિરણો** તેના પર અલગ-અલગ દિશામાંથી એકસાથે પડે.
  - જો માત્ર 1 કિરણ પડે, તો તે આંશિક રીતે ગ્લો થાય છે પણ ગેટ બંધ રહે છે.
  - $\ge 2$ કિરણો પડતાં જ જાદુઈ ચમકારો થાય છે અને ગેટ કાયમ માટે અનલૉક થઈ જાય છે.
- **JSON Format:**
  ```json
  {"id": "o252_1", "type": "M252", "cells": [[8, 8]], "params": {"requiredBeams": 2}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 4. Mechanic M253: Sundial Receiver (Beam Timer)
- **Intro Level:** L2751 (Block 26 x1)
- **Category:** Timed Optical Sensor (D / G)
- **Visual:** પ્રાચીન સૂર્યઘડી સેન્સર જેના પર સમય માપવાના પથ્થર ચિહ્નો છે.
- **Rule:**
  - તેના પર બીમ પડે ત્યારે દરવાજો તરત ખુલતો નથી.
  - દરવાજો ખોલવા માટે તેને **સળંગ $N$ Moves** સુધી પ્રકાશિત રહેવું પડે છે (કાઉન્ટડાઉન બેજ $N$).
  - દરેક Move પછી જો બીમ સતત ચાલુ હોય, તો કાઉન્ટર 1 ઘટે છે ($N \to N-1$).
  - કાઉન્ટર 0 થતાં દરવાજો કાયમ માટે Latch Open થાય છે.
  - જો $N$ પૂરું થતાં પહેલાં 1 પણ Move માટે બીમ કપાઈ જાય, તો કાઉન્ટર તરત રીસેટ થઈને મૂળ $N$ પર પહોંચી જાય છે!
- **JSON Format:**
  ```json
  {"id": "o253_1", "type": "M253", "cells": [[6, 3]], "params": {"requiredConsecutiveMoves": 3}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 5. Mechanic M254: Shade Leaves (Dark Cells)
- **Intro Level:** L2871 (Block 38 x1)
- **Category:** Light-Dependent Cell Lock (B / D)
- **Visual:** ઘટાદાર કાળા પાંદડાંની છાયા જે જમીન પર ગાઢ અંધારું ફેલાવે છે.
- **Rule:**
  - જે સાપનું માથું Shade Leaves વાળા ડાર્ક સેલમાં હોય તે સાપ **સંપૂર્ણ લૉક (Sleeping/Hidden lock)** રહે છે (ટેપ કરતાં Locked Tap મળે છે).
  - જ્યારે કોઈપણ Sunbeam આ ડાર્ક સેલમાંથી પસાર થાય છે: અંધારું દૂર થાય છે અને સાપ જાગૃત થાય છે.
  - જાગૃત થયેલો સાપ હવે મુક્તપણે ટેપ કરી શકાય છે.
- **JSON Format:**
  ```json
  {"id": "o254_1", "type": "M254", "cells": [[9, 4]], "params": {"illuminated": false}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 6. Tick Order Integration (§16.17)
1. Player action resolve (સાપ મૂવ કે અરીસો રોટેટ).
2. `moveCount += 1`.
3. Move counters tick.
4. Ray Casting Step:
   - તમામ Sunbeams રી-ટ્રેસ થાય છે.
   - Petal Filter (M251) બીમના રંગ બદલે છે.
   - Prism Lock (M252) પર કિરણોની સંખ્યા ગણાય છે.
   - Sundial Receiver (M253) માં સળંગ બીમ ચકાસાય છે.
   - Shade Leaves (M254) ની ઇલ્યુમિનેશન સ્ટેટ અપડેટ થાય છે.
5. Derived states & locks update.
6. Win check.
