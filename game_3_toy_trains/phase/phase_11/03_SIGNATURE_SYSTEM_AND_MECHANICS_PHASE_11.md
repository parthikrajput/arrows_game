# 03 · Signature System & Base Mechanics Phase 11 — Toy Trains
> હેતુ: Phase 11 ની signature system (Twin Tables / Linked Boards) અને 4 નવા railway base mechanics (M501–M504) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 11 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_11_SCOPE_AND_RULES.md)

---

## 1. Signature System: Twin Tables (`S11`)
- **Core Concept:** બે સ્વતંત્ર પરંતુ જોડાયેલા વુડન પ્લેટેબલ્સ (Table A અને Table B). ખેલાડી બંને ટેબલ્સને એકસાથે સ્ક્રીન પર જોઈ શકે છે (ડ્યુઅલ વ્યુ અથવા સ્પ્લિટ-સ્ક્રીન). બંને ટેબલ્સ વચ્ચે ટ્રેનો પુલ અને સુરંગ દ્વારા આવ-જા કરે છે.
- **Tick Order Integration:**
  - Table Bridge ટ્રાન્સફર Move Step 1 (Player Action / Path Advance) માં પૂર્ણ થાય છે.
  - Cross-board Ticket Triggers Step 2 (Passive Triggers) માં સક્રિય થાય છે અને તરત Table B ના બેરિયરને ખોલે છે.
  - Mirror Train Simultanous Execution: પ્લેયર એક ટ્રેન ટેપ કરે ત્યારે બીજી ટેબલની મિરર ટ્રેન એ જ મૂવમાં એકસાથે ચાલે છે.

---

## 2. New Base Mechanics (M501–M504)

### M501 · Table Bridge (Board Link Edge)
- **Intro Level:** L5011 (Block 2, x1)
- **Category:** E / P (Cross-Table Connector)
- **Exact Rule:** Table A ની નિર્ધારિત લિંક્ડ એજમાંથી નીકળતી ટ્રેન Table B ની સંલગ્ન એજમાં પ્રવેશે છે. જો Table B નો એન્ટ્રી સેલ ખાલી ન હોય (કોઈ ટ્રેન ઉભેલી હોય), તો ટ્રેન બમ્પ થઈ −1 Heart ગુમાવે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M501", "cells": [[7, 4]], "params": {"sourceBoard": "A", "targetBoard": "B", "targetCell": [0, 4]}, "hammerable": false}
  ```

---

### M502 · Inter-table Ticket (Cross-board Key)
- **Intro Level:** L5131 (Block 14, x1)
- **Category:** K / T (Cross-board Trigger Key)
- **Exact Rule:** Table A પર મુકાયેલી સ્પેશિયલ ટિકિટ. જ્યારે Table A ની ટ્રેન આ ટિકિટ સેલ પરથી પસાર થાય છે, ત્યારે Table B પર આવેલો ક્રોસ-ટેબલ બેરિયર કાયમી ધોરણે ખુલી જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M502", "cells": [[3, 3]], "params": {"sourceBoard": "A", "targetBarrierId": "b_gate_1", "targetBoard": "B"}, "hammerable": false}
  ```

---

### M503 · Mirror Table (Mirror Board)
- **Intro Level:** L5251 (Block 26, x1)
- **Category:** P / B (Synchronized Twin Train)
- **Exact Rule:** બે જોડિયા ટ્રેનો — એક Table A પર અને બીજી Table B પર. ખેલાડી Table A પરની ટ્રેન પર ટેપ કરે છે ત્યારે Table B પરની ટ્રેન આપોઆપ મિરર દિશામાં (R <-> L) સાથે ચાલે છે. જો બંનેમાંથી કોઈ પણ ટ્રેનનો પાટો અવરોધાયેલો હોય તો બંને બમ્પ થાય છે.
- **Hammerable:** Yes (Track Crane બંનેમાંથી એકને હટાવી શકે છે, જેનાથી બીજી સામાન્ય ટ્રેન બની જાય છે).
- **JSON Definition:**
  ```json
  {"id": "p_twin_a", "type": "path", "board": "A", "cells": [[2, 2], [2, 3]], "dir": "R", "params": {"partnerId": "p_twin_b", "partnerBoard": "B"}}
  ```

---

### M504 · Relay Tunnel (Relay Portal)
- **Intro Level:** L5371 (Block 38, x1)
- **Category:** P / G (Inter-table Portal)
- **Exact Rule:** ઇન્ટર-ટેબલ સુરંગ. એક સુરંગનું મુખ Table A પર અને બીજું સુરંગનું મુખ Table B પર હોય છે. એક મુખમાં પ્રવેશતી ટ્રેન 1 Move માં સીધી બીજા ટેબલના મુખમાંથી બહાર આવે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M504", "cells": [[5, 2]], "params": {"mouthA": {"board": "A", "cell": [5, 2]}, "mouthB": {"board": "B", "cell": [2, 5]}}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **State Representation:** બોર્ડ સ્ટેટ હવે બે અલગ ગ્રીડ્સ ધરાવે છે (`boards: {"A": Grid, "B": Grid}`).
- **Cross-Board Pathfinding:** સોલ્વર એન્ટ્રી-એક્ઝિટ પોઇન્ટ્સને એડજેસન્સી ગ્રાફમાં જોડે છે જેથી બે અલગ બોર્ડ્સ એક જ વિશાળ ગ્રાફ તરીકે ટ્રેવર્સ થાય.
- **Simultaneous Action Resolution:** Mirror Trains માટે સોલ્વર બંને મુવ્સને એટોમિક ગણે છે — જો એક નિષ્ફળ જાય તો સમગ્ર સ્ટેટ રોલબેક થાય છે.
