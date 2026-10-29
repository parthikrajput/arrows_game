# 03 · Signature System & Base Mechanics Phase 5 — Toy Trains
> હેતુ: Phase 5 ની signature system (Yard Shunting+ / Push Physics+) અને 4 નવા railway base mechanics (M201–M204) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_5_SCOPE_AND_RULES.md)

---

## 1. Signature System: Yard Shunting+ (`S05`)
- **Core Concept:** રેલ્વે યાર્ડમાં શન્ટિંગ એન્જિન દ્વારા કાર્ટ્સ અને વેગનને ધકેલવું (Push Physics).
- **Collision & Shunting Resolution:**
  - ટ્રેન પોતાની exit lane માં રહેલા શન્ટિંગ કાર્ટને સ્પર્શે ત્યારે કાર્ટ 1 સેલ આગળ ખસે છે (જો આગળનો સેલ ખાલી હોય).
  - જો પાછળનો સેલ ખાલી ન હોય તો ટ્રેન બમ્પ થઈ મૂળ સ્થાને પરત ફરે છે (−1 Heart).

---

## 2. New Base Mechanics (M201–M204)

### M201 · Cart Pit (Crate Holes)
- **Intro Level:** L2011 (Block 2, x1)
- **Category:** B (Blocker / Terrain Mod)
- **Exact Rule:** રેલ્વે ટ્રેક પરનો ઊંડો ખાડો જે લેન બ્લોક કરે છે. જ્યારે કોઈ કાર્ટને ધકેલીને આ ખાડામાં નાખવામાં આવે છે, ત્યારે ખાડો કાયમી રીતે પૂરાઈ જાય છે અને બંને સામાન્ય ટ્રેક (floor) બની જાય છે, જેના પરથી ટ્રેનો મુક્તપણે પસાર થઈ શકે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M201", "cells": [[5, 4]], "params": {}, "hammerable": false}
  ```

---

### M202 · Ice Block Cart (Sliding Ice Crates)
- **Intro Level:** L2131 (Block 14, x1)
- **Category:** C (Continuous Inertia Blocker)
- **Exact Rule:** બરફથી ઢંકાયેલું કાર્ટ જે પાટા પર ઘર્ષણ વિના લપસે છે. ટ્રેન દ્વારા ધકેલાતાં તે માત્ર 1 સેલ નહીં, પરંતુ જ્યાં સુધી આગળ કોઈ અવરોધ, ખાડો કે પાટાનો અંત ન આવે ત્યાં સુધી સતત લપસતું રહે છે (continuous slide). ખાડામાં પડતાં ખાડો પૂરે છે.
- **Hammerable:** Yes (Track Crane કાર્ટને હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M202", "cells": [[4, 7]], "params": {}, "hammerable": true}
  ```

---

### M203 · Ticket Cart (Crate Keys)
- **Intro Level:** L2251 (Block 26, x1)
- **Category:** K (Object-Carried Key)
- **Exact Rule:** ટિકિટ પ્રતીક ધરાવતું સ્પેશિયલ કાર્ટ. આ કાર્ટને ટ્રેન દ્વારા ધકેલીને મેળ ખાતા રંગના રેલ્વે બેરિયર પેડ પર સ્થિર કરવાથી બંધ બેરિયર ગેટ કાયમી રીતે ખુલી જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M203", "cells": [[6, 3]], "params": {"targetPad": [6, 8], "color": "red"}, "hammerable": false}
  ```

---

### M204 · Ballast Cart (Heavy Crate)
- **Intro Level:** L2371 (Block 38, x1)
- **Category:** B (Heavy Resistance Blocker)
- **Exact Rule:** વજનદાર પથ્થરો (બેલાસ્ટ) ભરેલું ભારે કાર્ટ. સામાન્ય એકલી ટ્રેન તેને ધકેલી શકતી નથી (અથડાતાં બમ્પ થાય છે, −1 Heart). તેને માત્ર **Wide Load Freight (M024)** અથવા **Coupled Engines (M011)** દ્વારા જ ધકેલી શકાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M204", "cells": [[7, 7]], "params": {"requiredStrength": 2}, "hammerable": false}
  ```

---

## 3. Solver & Engine Integration
- Solver push simulation ચલાવે છે જેમાં કાર્ટની સ્થિતિ અને ખાડાનું ભરાવું dynamic state graph તરીકે સંગ્રહિત થાય છે.
- Continuous slide (M202) એક જ મૂવના રિઝોલ્યુશન સ્ટેપમાં ગણતરી પામે છે.

