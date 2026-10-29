# 03 · Signature System & Base Mechanics Phase 20 — Toy Trains
> હેતુ: Phase 20 ની signature system (Grand Master / Omni-System Convergence), 4 supreme combo mechanics (M951–M954), L10000 Marching Clock Tower Boss અને solver impact.

**Related docs:** [Phase 20 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §10](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_20_SCOPE_AND_RULES.md)

---

## 1. Signature System: Grand Master (`S20`)
- **Core Concept:** 10,000 લેવલ્સની સફરનું પરમોચ્ચ શિખર. આ ફેઝમાં તમામ 19 પૂર્વ-સિસ્ટમ્સનું એકીકરણ થાય છે. એક જ બોર્ડ પર ડે/નાઇટ સાયકલ સાથે કન્વેયર્સ, ગ્લેશિયર મિરર્સ, ટ્વિન ટેબલ બ્રિજ, ગ્રેવિટી સ્લોપ્સ અને ગાર્ડિયન બોસ ટાવર્સ સંયુક્ત રીતે કાર્ય કરે છે.
- **Tick Order Integration:**
  - તમામ સિસ્ટમ્સ Step 1 (Player Input), Step 2 (Passive Triggers / Beams / Keys), Step 3 (Mechanic Ticks: Clocks, Conveyors, Growth, Gravity, Spawners) ના કઠોર ક્રમમાં એક્ઝિક્યુટ થાય છે.

---

## 2. Supreme Combo Base Mechanics (M951–M954)

### M951 · Clockwork Conveyor Guardian
- **Intro Level:** L9511 (Block 2, x1)
- **Category:** B / T (Conveyor + Clock Tower Fusion)
- **Exact Rule:** કન્વેયર રીંગની મધ્યમાં સ્થાપિત ક્લોક ટાવર ગાર્ડિયન (6 HP). ટાવરની ફરતે આવેલો કન્વેયર બેલ્ટ ટ્રેનોને સતત પરિભ્રમણ કરાવે છે. જ્યારે કોઈ ટ્રેન સમયસર કન્વેયરમાંથી એક્ઝિટ લે છે, ત્યારે ટાવરને ૧ HP નો ડેમેજ થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1_conveyor_boss", "type": "M951", "cells": [[5, 5], [5, 6], [6, 5], [6, 6]], "params": {"hp": 6, "ringCells": [[4, 4], [4, 5], [4, 6], [4, 7], [7, 4], [7, 5], [7, 6], [7, 7]]}, "hammerable": false}
  ```

---

### M952 · Gravity Mirror Relay
- **Intro Level:** L9631 (Block 14, x1)
- **Category:** T / E (Hill Line + Mirror Rails + Twin Tables Fusion)
- **Exact Rule:** ગ્રેવિટી મિરર રીલે. ટિલ્ટ લીવર ટેપ કરવાથી Table A પર ગ્રેવિટી નીચે તરફ ($D$) જાય છે જ્યારે Table B પર કેન્દ્રીય અક્ષની સાપેક્ષે ગ્રેવિટી આપોઆપ ઉપર તરફ ($U$) બદલાય છે. બંને ટેબલ્સ પર રહેલા લૂઝ ક્રેટ્સ વિરુદ્ધ દિશાઓમાં સરકે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2_grav_mirror", "type": "M952", "cells": [[7, 7]], "params": {"tableADir": "D", "tableBDir": "U"}, "hammerable": false}
  ```

---

### M953 · Day/Night Ticket Master Pass
- **Intro Level:** L9751 (Block 26, x1)
- **Category:** P / K (Day/Night + Ticket Office Fusion)
- **Exact Rule:** સાયકલ આધારિત ગોલ્ડન માસ્ટર પાસ લોકોમોટિવ. Day Phase A માં તે સામાન્ય ગેટ્સ ખોલે છે, પરંતુ જ્યારે બોર્ડ Night Phase B માં પ્રવેશે છે ત્યારે તે અલ્ટીમેટ સ્કેલેટન કી બની જાય છે અને કોઈપણ બેરિયરને એક સાથે અનલોક કરે છે.
- **Hammerable:** Yes (Track Crane ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p_master_cycle", "type": "path", "cells": [[2, 2], [2, 3]], "dir": "R", "params": {"nightSkeleton": true}}
  ```

---

### M954 · Prism Bloom Arch
- **Intro Level:** L9871 (Block 38, x1)
- **Category:** G / S (Ivy Growth + Signal Lights Fusion)
- **Exact Rule:** પ્રિઝમ બ્લૂમ કમાન. આ કમાન ખુલવા માટે બે શરતો એકસાથે પૂર્ણ થવી અનિવાર્ય છે: (૧) બોર્ડ પર ફેલાતી વાઇલ્ડ આઇવીના ઓછામાં ઓછા K = 4 સેલ્સ આ કમાનને સ્પર્શેલા હોવા જોઈએ, અને (૨) કલર્ડ લેન્સમાંથી ફિલ્ટર થયેલો સિગ્નલ લાઇટ બીમ સીધો કમાનના કેન્દ્ર પર પડવો જોઈએ.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4_prism_bloom", "type": "M954", "cells": [[11, 6]], "params": {"requiredIvy": 4, "requiredBeamColor": "cyan"}, "hammerable": false}
  ```

---

## 3. L10000 Ultimate Boss: The Marching Clock Tower
- **Level Index:** Level 10000 ("The Grand Sovereign Terminus")
- **Grid:** $14\times 14$ Ultimate Board, 56 Trains, Target Difficulty $D \approx 91.0$.
- **Boss Entity:** $3\times 3$ Marching Clock Tower (12 HP).
- **Marching Mechanics:**
  - દર 5 મૂવે ટાવર ૧ સેલ ડાઉનવર્ડ માર્ચ કરે છે. જે પાટો તેના પગ નીચે આવે છે તે ક્ષતિગ્રસ્ત (Crushed) થાય છે.
  - ખેલાડીએ ટ્વિન કન્વેયર્સ, પ્રિઝમ બીમ્સ અને ડે/નાઇટ પોર્ટલ્સનો ઉપયોગ કરીને ટાવરના માર્ગમાંથી ટ્રેનો ક્લિયર કરી તેના પર હુમલો કરવો પડે છે.
  - 12 HP શૂન્ય થતાં ટાવર ગ્રાન્ડ કન્ફેટી અને સોનેરી પ્રકાશ સાથે વિખેરાઈ જાય છે.

---

## 4. Solver & Engine Impact
- **State Complexity:** $O(14\times 14)$ ગ્રીડ પર 19 સિસ્ટમ્સના સ્ટેટ્સ એકસાથે મોડેલ થાય છે.
- **A* Multi-Heuristic Search:** સોલ્વર કી ડિપેન્ડન્સી, ગ્રેવિટી ફિઝિક્સ અને બોસ માર્ચિંગ કાઉન્ટડાઉનને ત્રિ-સ્તરીય વજન (Heuristic Weights) આપે છે.
- **Zero-Deadlock Guarantee:** તમામ 500 લેવલ્સ CI માં 0 hearts / 0 boosters સાથે વેલિડેટ થયેલા છે.

