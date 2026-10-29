# 03 · Signature System & Base Mechanics Phase 6 — Toy Trains
> હેતુ: Phase 6 ની signature system (Signal Lights+ / Light & Beams+) અને 4 નવા railway base mechanics (M251–M254) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_6_SCOPE_AND_RULES.md)

---

## 1. Signature System: Signal Lights+ (`S06`)
- **Core Concept:** રેલ્વે ઓપ્ટિક્સ જેમાં સિગ્નલ લેમ્પ્સ, ઓપ્ટિકલ સેન્સર્સ અને બીમ્સ દ્વારા રેલ્વે દરવાજા આપોઆપ સંચાલિત થાય છે.
- **Beam Propagation:**
  - પ્રકાશનો કિરણ પારદર્શક પાટા અને ખુલ્લા સેલ્સમાંથી સીધો અનંત રેન્જ સુધી મુસાફરી કરે છે.
  - ટ્રેન અથવા ઘન અવરોધ માર્ગમાં આવતાં બીમ તરત અટકી જાય છે.

---

## 2. New Base Mechanics (M251–M254)

### M251 · Coloured Lens (Color Filter)
- **Intro Level:** L2511 (Block 2, x1)
- **Category:** D (Directional / Optical Filter)
- **Exact Rule:** રંગીન કાચનો લેન્સ. તેમાંથી પસાર થતાં બીમ લેન્સનો રંગ ધારણ કરે છે. રંગીન સેન્સર્સ (Red, Green, Blue) માત્ર પોતાના રંગના બીમથી જ પ્રતિક્રિયા આપી જોડાયેલા દરવાજા ખોલે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M251", "cells": [[4, 5]], "params": {"filterColor": "green"}, "hammerable": false}
  ```

---

### M252 · Twin Sensor Gate (Beam Splitter Lock)
- **Intro Level:** L2631 (Block 14, x1)
- **Category:** K (Multi-Sensor Lock)
- **Exact Rule:** જોડિયા સેન્સર્સ ધરાવતો સિગ્નલ ગેટ. આ ગેટ ત્યારે જ ખુલે છે જ્યારે બંને સેન્સર્સ પર એક જ સમયે બીમ આપાત થતો હોય. એક પણ સેન્સર બીમ વગર હોય તો ગેટ બંધ રહે છે (બમ્પ ⇒ −1 Heart).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M252", "cells": [[6, 8]], "params": {"sensors": [[5, 2], [7, 2]]}, "hammerable": false}
  ```

---

### M253 · Lamp Timer (Beam Timer)
- **Intro Level:** L2751 (Block 26, x1)
- **Category:** C (Move Countdown Emitter)
- **Exact Rule:** ટાઈમર સિગ્નલ લેમ્પ. દર N Moves એ લેમ્પ ચાલુ (beam on) અને બંધ (beam off) સ્થિતિ વચ્ચે સ્વિચ થાય છે (Move resolution ના Step 3 માં tick).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M253", "cells": [[3, 3]], "params": {"period": 3, "initialState": true}, "hammerable": false}
  ```

---

### M254 · Blackout Patch (Dark Cells)
- **Intro Level:** L2871 (Block 38, x1)
- **Category:** C (Illumination Cell / Hidden)
- **Exact Rule:** અંધારા ટ્રેક સેલ્સ. આ સેલ્સમાં રહેલી ટ્રેનો લૉક રહે છે (tap = locked tap) અને અદૃશ્ય હોય છે જ્યાં સુધી કોઈ સિગ્નલ બીમ આ સેલને પ્રકાશિત ન કરે. બીમ પડતાં જ સેલ અજવાળું થાય છે અને ટ્રેન મુક્તપણે સક્રિય બને છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M254", "cells": [[8, 4], [8, 5]], "params": {}, "hammerable": false}
  ```

---

## 3. Solver & Engine Integration
- બીમ રે-ટ્રેસિંગ દરેક મૂવ પછી તાત્કાલિક રી-કમ્પ્યુટ થાય છે.
- Dark Cells ની વિઝિબિલિટી અને સેન્સર ગેટ્સની સ્થિતિ Step 4 (Derived states recompute) માં અપડેટ થાય છે.
