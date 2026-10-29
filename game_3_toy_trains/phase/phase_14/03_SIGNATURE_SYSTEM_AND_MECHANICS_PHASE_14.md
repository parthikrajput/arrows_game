# 03 · Signature System & Base Mechanics Phase 14 — Toy Trains
> હેતુ: Phase 14 ની signature system (Alpine Pass / Looking-Glass Line / Mirror Worlds) અને 4 નવા railway base mechanics (M651–M654) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_14_SCOPE_AND_RULES.md)

---

## 1. Signature System: Alpine Pass (`S14`)
- **Core Concept:** બરફથી છવાયેલ આલ્પાઇન પાસ. બોર્ડની બરાબર મધ્યમાં આલ્પાઇન ગ્લેશિયર મિરર અક્ષ આવેલી છે. ડાબી બાજુનું બોર્ડ જમણી બાજુના બોર્ડનું આબેહૂબ અરીસા જેવું પ્રતિબિંબ છે.
- **Tick Order Integration:**
  - Mirror Train Move: Step 1 (Player Action) માં પ્રાથમિક ટ્રેન અને તેની પ્રતિબિંબિત જોડિયા ટ્રેન બંને એકસાથે એટોમિક રીતે મુવ થાય છે. જો બંનેમાંથી કોઈનો પાથ બ્લોક હોય તો મુવ કેન્સલ થાય છે અને બમ્પ એનિમેશન દેખાય છે.
  - Reflection Lock Check: Step 2 (Passive Triggers) માં બંને સાઈડના સ્વિચ ચેક થાય છે અને જો બંને મુક્ત હોય તો જ ગ્લેશિયર બેરિયર્સ ડાઉન થાય છે.

---

## 2. New Base Mechanics (M651–M654)

### M651 · Mirror Rail Axis (Alpine Mirror Track)
- **Intro Level:** L6511 (Block 2, x1)
- **Category:** P / B (Symmetrical Mirror Pair)
- **Exact Rule:** કેન્દ્રીય અક્ષ પર આધારિત સપ્રમાણ ટ્રેનો. ખેલાડી અક્ષની ડાબી બાજુની ટ્રેન પર ટેપ કરે છે, ત્યારે જમણી બાજુ રહેલી તેની પ્રતિબિંબિત જોડિયા ટ્રેન (Mirrored Twin) પણ એ જ ક્ષણે વિરુદ્ધ આડી દિશામાં (Horizontal Reflection: Left <-> Right) આગળ વધે છે. બંનેના પાટા ખાલી હોવા જરૂરી છે.
- **Hammerable:** Yes (Track Crane વાપરવાથી બંનેમાંથી એક ટ્રેન હટે છે અને બીજી સિંગલ સામાન્ય ટ્રેન બની જાય છે).
- **JSON Definition:**
  ```json
  {"id": "p_mirror_left", "type": "path", "cells": [[3, 3], [3, 4]], "dir": "L", "params": {"mirrorPartner": "p_mirror_right", "axisX": 6.5}}
  ```

---

### M652 · Reflection Lock (Glacier Lock)
- **Intro Level:** L6631 (Block 14, x1)
- **Category:** K / L (Paired Symmetry Barrier)
- **Exact Rule:** આલ્પાઇન ગ્લેશિયર બેરિયર. મિરર અક્ષની બંને બાજુ સમાન અંતરે બે ગેટ્સ આવેલા હોય છે. જ્યાં સુધી બંને બાજુની સંલગ્ન સ્વિચ દબાવવામાં ન આવે અથવા બંને બાજુથી ટ્રેનો એકસાથે પહોંચતી ન હોય, ત્યાં સુધી બંને બેરિયર્સ બંધ રહે છે (બમ્પ).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M652", "cells": [[5, 2], [5, 11]], "params": {"axisX": 6.5, "paired": true}, "hammerable": false}
  ```

---

### M653 · Alpine Twin Yard (Mirror Board)
- **Intro Level:** L6751 (Block 26, x1)
- **Category:** B / T (Synchronized Yard Grid)
- **Exact Rule:** ડુપ્લિકેટ પ્રતિબિંબિત યાર્ડ ઝોન. આ ઝોનમાં કોઈપણ ટર્નટેબલ કે સ્વિચ ફેરવવાથી અક્ષની સામેની બાજુ આવેલું પ્રતિબિંબિત સ્વિચ પણ તે જ સમયે ઉલટી દિશામાં ફરી જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M653", "cells": [[8, 2], [8, 11]], "params": {"syncRotation": true}, "hammerable": false}
  ```

---

### M654 · Reverse Engine (Inverse Path)
- **Intro Level:** L6871 (Block 38, x1)
- **Category:** P (Direction Inversion Locomotive)
- **Exact Rule:** આલ્પાઇન રિવર્સ લોકોમોટિવ. મિરર ક્ષેત્રમાં રહેલી આ ટ્રેન પર સામાન્ય રીતે એરો છાપેલો હોય છે, પરંતુ ટેપ કરવાથી તે પોતાના એરોની બરાબર વિરુદ્ધ દિશામાં પાછળ તરફ રવાના થાય છે.
- **Hammerable:** Yes (Track Crane ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p_reverse", "type": "path", "cells": [[10, 8], [10, 9]], "dir": "R", "params": {"invertedDir": true}}
  ```

---

## 3. Solver & Engine Impact
- **Symmetry Exploitation:** સોલ્વર સપ્રમાણ સ્ટેટ્સ ઓળખીને સર્ચ સ્પેસને અડધો કરી શકે છે ($O(N/2)$ symmetry reduction).
- **Simultaneous Collision Checks:** મિરર ટ્રેનો માટે સોલ્વર બંને પાથ્સનું એકીસાથે વેલિડેશન કરે છે. જો એક પણ પાથમાં ટકરાવ હોય તો મૂવ અમાન્ય ઠરે છે.
- **Reversal Mechanics:** `M654` માટે સોલ્વર મુવમેન્ટ વેક્ટરને $-1$ વડે ગુણીને દિશા ગણે છે.
