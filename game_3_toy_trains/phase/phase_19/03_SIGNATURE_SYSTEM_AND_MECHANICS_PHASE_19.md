# 03 · Signature System & Base Mechanics Phase 19 — Toy Trains
> હેતુ: Phase 19 ની signature system (Remix B / Mid-Era Systems Synergy) અને 4 ડેટા-ડ્રિવન combo mechanics (M901–M904) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §10](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_19_SCOPE_AND_RULES.md)

---

## 1. Signature System: Remix B (`S19`)
- **Core Concept:** મધ્ય તબક્કા (Phases 7–12) ના સૌથી પડકારજનક અને રસપ્રદ મિકેનિક્સનું સિનર્જિસ્ટિક સંયોજન. રોટેશન, વેલ ગ્રોથ, ટ્રેન સ્પ્લિટિંગ, સિક્વન્સિંગ રિધમ, ડ્યુઅલ ટેબલ્સ અને ગ્રેવિટી ફિઝિક્સનું એકીકરણ.
- **Tick Order Integration:**
  - Turntable Rotor / Split Taps: Step 1 (Player Action) માં resolve થાય છે.
  - Incline Slide & Ivy Growth: Step 3 (Mechanic Ticks) માં ગ્રેવિટી સ્લાઇડ અને સીડ સ્પ્રાઉટિંગ થાય છે.
  - Cross-Table Metronome Check: Step 1 (Exit Validation) માં બંને ટેબલ્સના એક્ઝિટ્સ સિંક્રનાઇઝ થાય છે.

---

## 2. New Base Combo Mechanics (M901–M904)

### M901 · Turntable Coupling Pad (Rotating Coupler)
- **Intro Level:** L9011 (Block 2, x1)
- **Category:** T / P (Rotation + Coupling Fusion)
- **Exact Rule:** રોટેટિંગ કપલિંગ યાર્ડ. 4×4 સબ-બોર્ડ રોટર પર મેગ્નેટિક કપલિંગ પેડ્સ સ્થાપિત છે. જ્યાં સુધી ખેલાડી લીવર વડે યાર્ડને 90° CW ફેરવીને મુખ્ય રેલવે પાટા સાથે સંરેખિત ન કરે, ત્યાં સુધી બંને ટ્રેનો પેડ્સ પર આવીને મર્જ થઈ શકતી નથી.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1_rotor_coupler", "type": "M901", "cells": [[4, 4], [4, 5], [5, 4], [5, 5]], "params": {"currentAngle": 0, "targetAngle": 90}, "hammerable": false}
  ```

---

### M902 · Incline Seed Wagon (Gravity Spore Train)
- **Intro Level:** L9131 (Block 14, x1)
- **Category:** P / B (Gravity + Botanical Growth Fusion)
- **Exact Rule:** ગ્રેવિટી સીડ વેગન. હિલ લાઇનના ઢાળ પર સ્થિત આ ટ્રેન દર મૂવ વખતે ગ્રેવિટીની દિશામાં 1 સેલ આપોઆપ નીચે સરકે છે. સરકતી વખતે તે પોતાના મુસાફરી માર્ગમાં પાછળ વેલના બીજ છોડતી જાય છે જે N Moves પછી અંકુરિત થઈ ટ્રેક બ્લોક કરે છે.
- **Hammerable:** Yes (Track Crane ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p_incline_seed", "type": "path", "cells": [[8, 2], [8, 3]], "dir": "D", "params": {"sproutDelay": 3, "autoRoll": true}}
  ```

---

### M903 · Cross-Table Metronome Gate (Twin Table Rhythm)
- **Intro Level:** L9251 (Block 26, x1)
- **Category:** G / E (Linked Boards + Sequencing Fusion)
- **Exact Rule:** ક્રોસ-ટેબલ રિધમ ગેટ. Table A અને Table B વચ્ચેનો Table Bridge આ ગેટથી નિયંત્રિત થાય છે. ગેટ મેટ્રોનોમ પેટર્ન (દા.ત. `["open", "closed", "open"]`) અનુસરે છે; ટ્રેન Table A થી B માં ત્યારે જ પ્રવેશી શકે જ્યારે મેટ્રોનોમ "open" સ્ટેટમાં હોય.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3_bridge_metro", "type": "M903", "cells": [[7, 4]], "params": {"bridgeBoard": "A", "targetBoard": "B", "pattern": ["open", "closed", "open"]}, "hammerable": false}
  ```

---

### M904 · Hedge-Trimming Split Train (Twin Split Pruner)
- **Intro Level:** L9371 (Block 38, x1)
- **Category:** P / T (Split & Merge + Ivy Pruning Fusion)
- **Exact Rule:** પ્રૂનર સ્પ્લિટ ટ્રેન. ટેપ કરવાથી તે બે સમાંતર ટ્રેનોમાં વિભાજિત થાય છે. બંને ટ્રેનો આગળ વધતાં પોતાની બંને બાજુ અડીને રહેલી તમામ વાઇલ્ડ આઇવી (Wild Ivy) ને કાપીને પાટો સાફ કરતી જાય છે.
- **Hammerable:** Yes.
- **JSON Definition:**
  ```json
  {"id": "p_split_prune", "type": "path", "cells": [[3, 5], [3, 6], [4, 5], [4, 6]], "dir": "R", "params": {"pruneRadius": 1}}
  ```

---

## 3. Solver & Engine Impact
- **Cross-Table Kinetic Resolution:** સોલ્વર બંને ટેબલ્સના સ્ટેટ્સ અને સ્લાઇડિંગ ગ્રેવિટી એન્ટિટીઝનું એક સાથે મૂલ્યાંકન કરે છે.
- **Pruning Heuristics:** સ્પ્લિટ પ્રૂનર ટ્રેન દ્વારા વેલ સાફ કરવાની ક્ષમતા સોલ્વરને ઝડપી એક્ઝિટ પાથ્સ શોધવામાં મદદ કરે છે.
- **Rotation Alignment Branching:** રોટેટિંગ કપલિંગ યાર્ડ માટે સોલ્વર $0^\circ, 90^\circ, 180^\circ, 270^\circ$ ના સ્ટેટ્સનું ચોક્કસ મોડેલિંગ કરે છે.

