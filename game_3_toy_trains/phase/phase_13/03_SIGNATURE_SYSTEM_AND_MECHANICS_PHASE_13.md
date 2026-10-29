# 03 · Signature System & Base Mechanics Phase 13 — Toy Trains
> હેતુ: Phase 13 ની signature system (Weather Station / Fog on the Line / Hidden Info) અને 4 નવા railway base mechanics (M601–M604) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_13_SCOPE_AND_RULES.md)

---

## 1. Signature System: Weather Station (`S13`)
- **Core Concept:** ધુમ્મસિયા પર્વતીય સ્ટેશન પર સ્ટીમ ફોગ. ખેલાડીને શરૂઆતમાં અમુક ટ્રેક સેલ્સ અને ટ્રેનો અસ્પષ્ટ દેખાય છે. સ્કાઉટ હેન્ડકાર્ટ્સ અને લેન્ટર્ન પ્લેટ્સ દ્વારા ધુમ્મસ હટાવીને સચોટ માર્ગ નક્કી કરવાનો રહે છે.
- **Tick Order Integration:**
  - Route Peek: ટેપ હોલ્ડ પર તાત્કાલિક સાચો પાથ અને મિરાજ/ફોલ્સ વોલનું રહસ્ય પ્રગટ કરે છે.
  - Lantern Plate Tick: Step 2 (Passive Triggers) માં ટ્રેન પ્લેટ પર આવતાં જ રેડિયસ 2 નું ધુમ્મસ ક્લિયર થાય છે.
  - Scout Draisine Reveal: Step 1 (Player Exit) પૂર્ણ થતાં જ લેનના સંલગ્ન સેલ્સનું ધુમ્મસ કાયમી દૂર થાય છે.

---

## 2. New Base Mechanics (M601–M604)

### M601 · Scout Draisine (Scout Path)
- **Intro Level:** L6011 (Block 2, x1)
- **Category:** P (Reconnaissance Handcart)
- **Exact Rule:** નાની સ્કાઉટ ટ્રેન. જ્યારે આ ટ્રેન બોર્ડ છોડીને સ્ટેશનમાં સફળતાપૂર્વક પ્રવેશે છે, ત્યારે તે પોતાના સમગ્ર એક્ઝિટ પાથના 1-સેલ રેડિયસમાં રહેલા તમામ ધુમ્મસિયા સેલ્સને કાયમી ધોરણે પ્રગટ કરે છે.
- **Hammerable:** Yes (Track Crane ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p_scout", "type": "path", "cells": [[4, 2], [4, 3]], "dir": "U", "params": {"revealRadius": 1}}
  ```

---

### M602 · Mirage Steam (Mimic Fog)
- **Intro Level:** L6131 (Block 14, x1)
- **Category:** B / C (Illusion Cloud)
- **Exact Rule:** સ્ટીમ ક્લાઉડ જે અંદર એક નકલી (Decoy) ટ્રેન હોવાનો આભાસ કરાવે છે. દૃષ્ટિએ તે અવરોધ જેવો લાગે છે, પરંતુ વાસ્તવિક ટ્રેન તેની આરપાર નીકળી શકે છે. Route Peek વાપરતાં તે ખાલી સેલ દર્શાવે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M602", "cells": [[6, 7]], "params": {"decoyDir": "R"}, "hammerable": false}
  ```

---

### M603 · Painted Backdrop (False Wall)
- **Intro Level:** L6251 (Block 26, x1)
- **Category:** B (Illusory Wooden Wall)
- **Exact Rule:** દેખાવમાં સામાન્ય લાકડાની વાડ (Wooden Fence Blocker) જેવો અવરોધ. પરંતુ તે માત્ર સ્ટેજ બેકડ્રોપ છે — ટ્રેન તેના પરથી અસ્ખલિત પસાર થઈ શકે છે. Route Peek માં તે લાલ બ્લોકરને બદલે લીલો માન્ય પાથ દર્શાવે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M603", "cells": [[3, 5]], "params": {}, "hammerable": false}
  ```

---

### M604 · Lantern Plate (Reveal Plate)
- **Intro Level:** L6371 (Block 38, x1)
- **Category:** T (Pressure Lantern Switch)
- **Exact Rule:** ફાનસ ધરાવતી રેલ્વે સ્વીચ પ્લેટ. જ્યાં સુધી કોઈ પણ ટ્રેન આ પ્લેટ ઉપર સ્થિર ઉભી રહે છે, ત્યાં સુધી તેના કેન્દ્રથી રેડિયસ 2 ના તમામ સેલ્સનું ધુમ્મસ સંપૂર્ણ હટેલું રહે છે અને સાચી સ્થિતિ દૃશ્યમાન બને છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M604", "cells": [[8, 8]], "params": {"radius": 2}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **Deterministic Information:** ક્લાયન્ટ અને સોલ્વર બંને સંપૂર્ણ સાચું બોર્ડ સ્ટેટ ધરાવે છે; ધુમ્મસ માત્ર પ્રેઝન્ટેશન/રેન્ડરિંગ લેયર પર લાગુ થાય છે.
- **Solver Knowledge:** સોલ્વર જાણે છે કે M602 અને M603 અવરોધક નથી, તેથી તે કોઈ પણ એડિશનલ પેનલ્ટી વગર સીધા પાથ સોલ્યુશન્સ ગણે છે.
- **Hints Integrity:** ગ્રીન સિગ્નલ હિન્ટ (Green Signal Booster) ક્યારેય ધુમ્મસમાં ગૂંચવાતી નથી; તે હંમેશાં સાચી સ્કાઉટ અથવા લીડ ટ્રેન તરફ દોરે છે.
