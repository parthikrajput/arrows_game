# 03 · Signature System & Base Mechanics Phase 9 — Toy Trains
> હેતુ: Phase 9 ની signature system (Couple & Uncouple / Split & Merge) અને 4 નવા railway base mechanics (M401–M404) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_9_SCOPE_AND_RULES.md)

---

## 1. Signature System: Couple & Uncouple (`S09`)
- **Core Concept:** રેલ્વે યાર્ડમાં શન્ટિંગ કામગીરી. ટૂંકી ટ્રેનોને જોડીને લાંબી ટ્રેન બનાવવી અથવા વિશાળ ટ્વિન ટ્રેનને અલગ ટ્રેનોમાં વિભાજિત કરવી જેથી સાંકડા પાટાઓમાંથી પસાર થઈ શકાય.
- **Tick Order Integration:**
  - Coupling Merger / Splitting: ખેલાડીના ટેપ ઇનપુટ પર તરત Move Step 1 (Player Action) માં resolve થાય છે.
  - સેગમેન્ટ લોક સ્ટેટસ Step 2 (Passive Triggers) માં કી-ટ્રેન એક્ઝિટ પછી અપડેટ થાય છે.

---

## 2. New Base Mechanics (M401–M404)

### M401 · Coupling Pad (Merger Pad)
- **Intro Level:** L4011 (Block 2, x1)
- **Category:** T (Interactive Track Tile)
- **Exact Rule:** જ્યારે બે સંકળાયેલી ટ્રેનોના હેડ (Locomotive Heads) બંને Coupling Pads પર સ્થિર હોય, ત્યારે પેડ પર ટેપ કરવાથી (1 Move) બંને ટ્રેનો એકબીજા સાથે જોડાઈને સિંગલ સંયુક્ત ટ્રેન (Front + Rear) બને છે.
- **Hammerable:** No.
- **Edge Cases:** જો બંને ટ્રેનોના હેડ બંને પેડ્સ પર ન હોય તો ટેપ અમાન્ય રહે છે (Locked feedback).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M401", "cells": [[4, 5], [4, 6]], "params": {"targetTrains": ["p1", "p2"]}, "hammerable": false}
  ```

---

### M402 · Twin Split Train (Twin Splitter)
- **Intro Level:** L4131 (Block 14, x1)
- **Category:** P (Locomotive Splitting Path)
- **Exact Rule:** ડબલ-વિડ્થ સંયુક્ત ટ્રેન. ટેપ કરવાથી (1 Move) તે પોતાની લંબાઈ જાળવી રાખીને 2 સમાંતર ટ્રેનોમાં વિભાજિત થઈ જાય છે (બંને મૂળ મુખની દિશામાં ફેસ કરે છે).
- **Hammerable:** Yes (Track Crane સંપૂર્ણ ટ્રેનને હટાવી શકે છે).
- **Edge Cases:** જો સમાંતર વિભાજન માટે પૂરતો ખાલી પાટો ન હોય તો વિભાજન બ્લોક થાય છે અને બમ્પ એનિમેશન દેખાય છે.
- **JSON Definition:**
  ```json
  {"id": "p1", "type": "path", "cells": [[2, 2], [2, 3], [3, 2], [3, 3]], "dir": "R", "params": {"splitAxis": "parallel"}, "mods": {}}
  ```

---

### M403 · Coupling Lock (Segment Lock)
- **Intro Level:** L4251 (Block 26, x1)
- **Category:** K / L (Train Segment Barrier)
- **Exact Rule:** રેલ્વે સેગમેન્ટ લોક. જ્યાં સુધી નિર્ધારિત કી-ટ્રેન બોર્ડમાંથી એક્ઝિટ ન થાય, ત્યાં સુધી આ સેગમેન્ટ અનકપલ થઈ શકતું નથી કે આગળ વધી શકતું નથી.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M403", "cells": [[7, 8]], "params": {"keyTrain": "p3"}, "hammerable": false}
  ```

---

### M404 · Rejoin Arch (Rejoin Gate)
- **Intro Level:** L4371 (Block 38, x1)
- **Category:** G (Conditional Gate)
- **Exact Rule:** રીજોઇન આર્ચ. માત્ર વિભાજિત થયેલી ટ્વિન ટ્રેન (M402) ના બંને ભાગો જ આ આર્ચમાંથી પસાર થઈ શકે છે. જ્યારે બંને અર્ધ-ભાગો આ કમાન પાર કરી લે છે, ત્યારે કમાન કાયમી ધોરણે સંપૂર્ણ ખુલી જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M404", "cells": [[10, 5]], "params": {"requiredPassCount": 2, "sourceTrain": "p1"}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **State Representation:** ટ્રેન આઈડી સ્ટેટમાં મર્જ/સ્પ્લિટ ફ્લેગ્સ ઉમેરાય છે (`isMerged`, `splitParentId`).
- **Graph Expansion:** મર્જ થયા પછી ટ્રેનની લંબાઈ વધતી હોવાથી કોલિઝન ચેક્સ લાંબી ટ્રેન તરીકે થાય છે.
- **BFS Depth:** સોલ્વર પહેલાં મર્જ/સ્પ્લિટ નોડ્સને પ્રાયોરિટી આપે છે જેથી મુવ્સની શાખાઓ ઝડપથી સંકોચાય.
