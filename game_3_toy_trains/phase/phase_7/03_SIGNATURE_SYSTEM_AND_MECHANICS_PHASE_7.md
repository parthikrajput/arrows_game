# 03 · Signature System & Base Mechanics Phase 7 — Toy Trains
> હેતુ: Phase 7 ની signature system (Turntable Yards+ / Rotation) અને 4 નવા railway base mechanics (M301–M304) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_7_SCOPE_AND_RULES.md)

---

## 1. Signature System: Turntable Yards+ (`S07`)
- **Core Concept:** રેલ્વે રાઉન્ડહાઉસ રોટેશન જેમાં વિશાળ સબ-બોર્ડ્સ, પરિભ્રમણ કરતી એક્ઝિટ્સ અને ફરતા એન્જિન્સનો સમાવેશ થાય છે.
- **Rotor Matrix Transformation:**
  - 4×4 રોટર સેલની અંદર રહેલા તમામ `(x, y)` ગ્રીડ કોઓર્ડિનેટ્સ સ્થાનિક 90° CW ટ્રાન્સફોર્મ મેળવે છે: `(x', y') = (y, 3 - x)`.
  - રોટેશન દરમિયાન ટ્રેનની દિશા `dir` 90° CW શિફ્ટ થાય છે (`U -> R -> D -> L -> U`).

---

## 2. New Base Mechanics (M301–M304)

### M301 · Rotating Yard Block (Sub-board Rotor)
- **Intro Level:** L3011 (Block 2, x1)
- **Category:** T (Interactive Sub-Board Rotor)
- **Exact Rule:** 4×4 કદનો મોટો ગોળાકાર ટર્નટેબલ બ્લોક. સેન્ટ્રલ લીવર પર tap કરવાથી (1 Move) અંદર સમાયેલી તમામ ટ્રેનો અને પાટા 90° CW ફરે છે. જો કોઈ ટ્રેન આંશિક રીતે બહાર હોય, તો tap = locked tap.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M301", "origin": [4, 4], "size": [4, 4], "params": {}, "hammerable": false}
  ```

---

### M302 · Spinning Station Exits (Rotating Edges)
- **Intro Level:** L3131 (Block 14, x1)
- **Category:** B (Dynamic Border Exits)
- **Exact Rule:** ટેબલની બહાર જતી ખુલ્લી એક્ઝિટ ગેપ્સ દર N Moves એ બોર્ડરની ફરતે 1 સેગમેન્ટ Clockwise આગળ વધે છે (Step 3 tick). જે ટ્રેન એક્ઝિટ સમયે ગેપની સામે ન હોય તે બફર ક્લેક અથડાય છે (−1 Heart).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M302", "params": {"period": 4, "exitLength": 2}, "hammerable": false}
  ```

---

### M303 · Spinner Engine (Spin Path)
- **Intro Level:** L3251 (Block 26, x1)
- **Category:** P (Auto-Rotating Locomotive)
- **Exact Rule:** વિશેષ ક્લોકવર્ક એન્જિન. દરેક વખતે ખેલાડી કોઈપણ માન્ય Move કરે (કોઈપણ ટ્રેન કે લીવર ટેપ), Spinner Engine નું એન્જિન પોતાના સ્થાને 90° CW દિશા બદલે છે.
- **Hammerable:** Yes (Track Crane ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p1", "type": "path", "cells": [[5, 6], [5, 7]], "dir": "U", "params": {"autoSpin": true}}
  ```

---

### M304 · Turntable Lock (Rotation Lock)
- **Intro Level:** L3371 (Block 38, x1)
- **Category:** K (Mechanical Lock)
- **Exact Rule:** રોકિંગ બાર લોક. જોડાયેલ કી ટ્રેન જ્યાં સુધી બોર્ડ પરથી બહાર ન નીકળે ત્યાં સુધી ટર્નટેબલ કે 4×4 યાર્ડનું પરિભ્રમણ અટકેલું રહે છે (લીવર tap = locked tap).
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M304", "params": {"targetRotorId": "o1", "keyPathId": "p_key"}, "hammerable": false}
  ```

---

## 3. Solver & Engine Integration
- Solver સબ-બોર્ડ રોટેશનને એક જ મુવમાં આખા 4×4 ગ્રીડના સ્ટેટ ટ્રાન્સફોર્મેશન તરીકે રજૂ કરે છે.
- Tangled status માટે તાત્કાલિક સેગમેન્ટ ચેક ચાલે છે (head pointing directly into immediate wagon segment).
