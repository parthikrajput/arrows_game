# 03 · Signature System & Base Mechanics Phase 18 — Toy Trains
> હેતુ: Phase 18 ની signature system (Remix A / Early Era Systems Synergy) અને 4 ડેટા-ડ્રિવન combo mechanics (M851–M854) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §10](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_18_SCOPE_AND_RULES.md)

---

## 1. Signature System: Remix A (`S18`)
- **Core Concept:** પ્રારંભિક તબક્કા (Phases 1–6) ના સૌથી લોકપ્રિય અને રસપ્રદ મિકેનિક્સનું મિશ્રણ. ડે/નાઇટ સમયપત્રક, મલ્ટી-ફ્લોર પ્લેટફોર્મ્સ, પુશ ફિઝિક્સ અને લાઇટ સેન્સર્સ એકસાથે મળીને જટિલ લોજિસ્ટિક્સ પઝલ્સ રચે છે.
- **Tick Order Integration:**
  - Day/Night Flip: Step 3 માં `moveCount % 5 == 0` વખતે બોર્ડ સ્ટેટ A/B બદલાય છે.
  - Lift & Chute Motions: Step 1 માં પ્લેયર ટેપ અને Step 2 માં પેસિવ ડ્રોપ સાથે ફ્લોર બદલાય છે.
  - Light Sensor Checks: Step 2 માં બીમ પાથ રીસોલ્વ થઈને ડ્રોબ્રિજ/ગેટ્સ નિયંત્રિત કરે છે.

---

## 2. New Base Combo Mechanics (M851–M854)

### M851 · Day/Night Ticket Cart (Cycle Key)
- **Intro Level:** L8511 (Block 2, x1)
- **Category:** K / T (Day/Night + Shunting Fusion)
- **Exact Rule:** ટિકિટ વહન કરતી કાર્ટ. જ્યારે તેને પુશ કરીને Day/Night Tunnel (P3) માં ધકેલવામાં આવે છે, ત્યારે તે સાયકલ ફેઝ (Day/Night) અનુસાર પોતાના બેરિયર પ્રતીકને બદલે છે. તે ચોક્કસ ફેઝમાં જ સંબંધિત બેરિયરને ખોલી શકે છે.
- **Hammerable:** Yes (Track Crane કાર્ટ હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "o1_cart", "type": "M851", "cells": [[4, 4]], "params": {"phaseUnlocked": "A", "linkedBarrier": "b_cycle_1"}, "hammerable": true}
  ```

---

### M852 · Station Floor Shunting Lift (Multi-Floor Cart Elevator)
- **Intro Level:** L8631 (Block 14, x1)
- **Category:** T / P (Floors + Shunting Fusion)
- **Exact Rule:** માલવાહક એલિવેટર. જ્યારે કોઈ કાર્ટ (બેલાસ્ટ કે સામાન્ય કાર્ટ) સંપૂર્ણપણે લિફ્ટ પ્લેટફોર્મ પર હોય છે, ત્યારે લીવર ટેપ કરવાથી (1 Move) કાર્ટ સીધી ઉપલા કે નીચલા પ્લેટફોર્મ ફ્લોર પર ટ્રાન્સફર થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2_lift", "type": "M852", "cells": [[6, 6]], "params": {"currentFloor": 0, "targetFloor": 1}, "hammerable": false}
  ```

---

### M853 · Prism Signal Sensor (Color Lens Sensor Gate)
- **Intro Level:** L8751 (Block 26, x1)
- **Category:** G / S (Light & Beams + Drawbridge Fusion)
- **Exact Rule:** પ્રિઝમ સિગ્નલ સેન્સર. સિગ્નલ લેમ્પમાંથી નીકળતો સફેદ બીમ રંગીન લેન્સમાંથી પસાર થઈને સેન્સર ગેટ પર પડે છે. જ્યાં સુધી યોગ્ય રંગનો બીમ સેન્સરને પ્રકાશિત રાખે છે, ત્યાં સુધી પાટા પરનો ડ્રોબ્રિજ નીચો રહે છે અને ટ્રેનો પસાર થઈ શકે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o3_prism", "type": "M853", "cells": [[8, 4]], "params": {"requiredColor": "blue", "controlsBridge": "br_1"}, "hammerable": false}
  ```

---

### M854 · Ice Cart Blackout Chute (Drop Hole Shunting)
- **Intro Level:** L8871 (Block 38, x1)
- **Category:** B / T (Push Physics + Floors + Darkness Fusion)
- **Exact Rule:** આઇસ બ્લોક કાર્ટ જે સ્લાઇડ થઈને ગુડ્સ ચ્યુટમાં પડે છે અને નીચેના ફ્લોરના અંધારા બ્લેકઆઉટ પેચમાં સ્થાપિત કાર્ટ પીટમાં ફિટ થાય છે. કાર્ટ પીટ ભરાતાં જ પાટો પૂર્ણ થાય છે અને ટ્રેન માટે રસ્તો ખુલે છે.
- **Hammerable:** Yes.
- **JSON Definition:**
  ```json
  {"id": "o4_ice_chute", "type": "M854", "cells": [[10, 5]], "params": {"dropTarget": [10, 5, 1]}, "hammerable": true}
  ```

---

## 3. Solver & Engine Impact
- **Layer & Light Resolution:** સોલ્વર સ્ટેટ ગ્રાફમાં મલ્ટી-ફ્લોર કોઓર્ડિનેટ્સ $(x, y, z)$ અને લાઈટ બીમ વેક્ટર્સ બંનેને સાથે રીસોલ્વ કરે છે.
- **Cycle Timing Prediction:** Day/Night ફેઝ બદલાવના આધારે સોલ્વર અગાઉથી ગણતરી કરે છે કે કાર્ટ યોગ્ય સમયે ટનલ સુધી પહોંચશે કે નહીં.
- **Pruning Efficiency:** અંધારા વિસ્તારોમાં ખોટી રીતે ફેંકાયેલી કાર્ટ્સના પાથ્સને સોલ્વર ઝડપથી પ્રૂન કરે છે.

