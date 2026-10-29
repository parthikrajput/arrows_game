# 03 · Signature System & Base Mechanics Phase 10 — Toy Trains
> હેતુ: Phase 10 ની signature system (Timetable Master / Sequencing) અને 4 નવા railway base mechanics (M451–M454) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 10 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_10_SCOPE_AND_RULES.md)

---

## 1. Signature System: Timetable Master (`S10`)
- **Core Concept:** ક્લોકવર્ક સ્ટેશન માસ્ટર કંટ્રોલ. ટ્રેનોને ગમે તે ક્રમમાં બહાર કાઢી શકાતી નથી; સ્ટેશનના સમયપત્રક, રિધમ ગેટ્સ અને ચોક્કસ કલર પેટર્ન મુજબ જ એક્ઝિટ મંજૂર થાય છે.
- **Tick Order Integration:**
  - Metronome Gate પોઈન્ટર Step 3 (Mechanic Ticks) માં `moveCount` વધતાં જ એડવાન્સ થાય છે.
  - Departure Code અને Platform Order ચેક્સ Step 1 (Player Action / Path Move) માં એક્ઝિટ સમયે જ ચકાસાય છે.
  - Echo Signal બફર Step 2 (Passive Triggers) માં ટ્રેન એક્ઝિટ થયા પછી પુશ થાય છે.

---

## 2. New Base Mechanics (M451–M454)

### M451 · Metronome Gate (Rhythm Gate)
- **Intro Level:** L4511 (Block 2, x1)
- **Category:** G (Rhythm-based Barrier)
- **Exact Rule:** મેટ્રોનોમ ગેટ જે નિર્ધારિત પેટર્ન (દા.ત. `["open", "open", "closed"]`) પર કામ કરે છે. દર મૂવ પછી સ્ટેટ પેટર્નમાં 1 સ્ટેપ આગળ વધે છે. જ્યારે સ્ટેટ "open" હોય ત્યારે જ ટ્રેન પસાર થઈ શકે છે. "closed" હોય ત્યારે ગેટ બમ્પ કરે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M451", "cells": [[5, 6]], "params": {"pattern": ["open", "open", "closed"], "initialIndex": 0}, "hammerable": false}
  ```

---

### M452 · Departure Code Lock (Pattern Lock)
- **Intro Level:** L4631 (Block 14, x1)
- **Category:** K / L (Exit Pattern Barrier)
- **Exact Rule:** સ્ટેશન એક્ઝિટ પરનો કોડ બેરિયર. તેની ઉપર રંગોનો સિક્વન્સ (દા.ત. `["red", "blue", "green"]`) લખેલો હોય છે. જ્યારે ટ્રેનો આ ચોક્કસ કલર ઓર્ડરમાં બહાર નીકળે છે, ત્યારે જ બેરિયર કાયમી ધોરણે ખુલે છે. જો અન્ય રંગની ટ્રેન નીકળે તો સિક્વન્સ રીસેટ થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M452", "cells": [[8, 4]], "params": {"expectedColors": ["red", "blue", "green"]}, "hammerable": false}
  ```

---

### M453 · Platform Order Exit (Order Edge)
- **Intro Level:** L4751 (Block 26, x1)
- **Category:** E / G (Numbered Edge Exit)
- **Exact Rule:** પ્લેટફોર્મ એજ જે ચોક્કસ ક્રમાંક ધરાવે છે. ટ્રેનો માત્ર તેમના બોડી/સ્ટેશન નંબરના ક્રમમાં જ (1 -> 2 -> 3...) અહીંથી એક્ઝિટ લઈ શકે છે. જો #1 પહેલાં #2 જવાનો પ્રયત્ન કરે તો એજ બ્લોક રહે છે (બમ્પ).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M453", "cells": [[0, 5], [0, 6]], "params": {"currentRequiredOrder": 1, "maxOrder": 3}, "hammerable": false}
  ```

---

### M454 · Echo Signal (Echo Sequence)
- **Intro Level:** L4871 (Block 38, x1)
- **Category:** S / G (Echo Memory Signal)
- **Exact Rule:** ઇકો સિગ્નલ. પાછલી N ટ્રેનો (દા.ત. N = 2) જે કલર ક્રમમાં એક્ઝિટ થઈ હોય, તે પછીની N ટ્રેનો પણ બરાબર એ જ કલર ક્રમમાં એક્ઝિટ થવી જોઈએ. જો ક્રમ જળવાય તો સિગ્નલ ગ્રીન રહે છે, અન્યથા રેડ થઈને પાટો બ્લોક કરે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M454", "cells": [[9, 9]], "params": {"bufferSize": 2}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **State Representation:** સોલ્વર સ્ટેટમાં `rhythmIndex`, `codeProgressIndex`, `nextRequiredOrder` અને `echoHistory` રખાય છે.
- **Constraint Pruning:** સોલ્વર ખોટા ક્રમમાં નીકળતી ટ્રેનોના સર્ચ બ્રાન્ચને તરત જ પ્રૂન કરી દે છે (Backtracking optimization).
- **Depth Guarantees:** 500 સ્તરોમાં દરેક પઝલ માટે ઓછામાં ઓછો 1 વેલિડ ક્રમ અસ્તિત્વમાં છે તેની ખાતરી CI જનરેટર કરે છે.
