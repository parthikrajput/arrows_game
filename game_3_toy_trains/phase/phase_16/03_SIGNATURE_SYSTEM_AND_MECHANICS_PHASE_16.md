# 03 · Signature System & Base Mechanics Phase 16 — Toy Trains
> હેતુ: Phase 16 ની signature system (Ticket Office / Keys Deluxe / Multi-Key Networks) અને 4 નવા railway base mechanics (M751–M754) ના સંપૂર્ણ નિયમો, parameters, edge cases, tick order એકીકરણ અને solver impact.

**Related docs:** [Phase 16 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Scope & Rules](./01_PHASE_16_SCOPE_AND_RULES.md)

---

## 1. Signature System: Ticket Office (`S16`)
- **Core Concept:** એડવાન્સ્ડ રેલ્વે ટિકિટિંગ નેટવર્ક. પઝલ માત્ર ટ્રેનો દોડાવવાની નથી પરંતુ યોગ્ય ક્રમમાં ચાવીઓ મેળવવાની (Key Ordering), અડધી ટિકિટો ક્રાફ્ટ કરવાની અને માસ્ટર પાસનો વ્યૂહાત્મક ઉપયોગ કરવાની છે.
- **Tick Order Integration:**
  - Ticket Punch / Key Crafting: Step 2 (Passive Triggers) માં બંને ટિકિટ સ્ટબ્સ ભેગા થતાં જ ઇન્વેન્ટરીમાં પૂર્ણ ગોલ્ડન ટિકિટ ઉમેરાય છે.
  - Ticket Swap Pad: Step 1 (Player Action) માં પેડ પર ટેપ કરવાથી તરત કી એક્સચેન્જ થાય છે (1 Move).
  - Ticket Chain Release: Step 2 માં બેરિયર ખુલતાં પાછળની નવી ટિકિટ આપોઆપ અનલોક થાય છે.

---

## 2. New Base Mechanics (M751–M754)

### M751 · Ticket Chain (Key Chain)
- **Intro Level:** L7511 (Block 2, x1)
- **Category:** K / L (Chained Sequential Barrier)
- **Exact Rule:** સાંકળિત રેલ્વે બેરિયર્સ. બેરિયર A ટિકિટ A થી ખુલે છે. જેવો બેરિયર A ખુલે છે, તેની પાછળ છુપાયેલી ટિકિટ કાર B પાટા પર સક્રિય બને છે. તે જ રીતે ટિકિટ B વડે બેરિયર B ખુલે છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M751", "cells": [[4, 4]], "params": {"keyId": "ticket_a", "releasesKey": "ticket_b"}, "hammerable": false}
  ```

---

### M752 · Ticket Punch (Key Crafting)
- **Intro Level:** L7631 (Block 14, x1)
- **Category:** T / K (Half-Ticket Assembler)
- **Exact Rule:** ટિકિટ પંચિંગ બૂથ. બોર્ડ પર 2 અલગ અર્ધ-ટિકિટો (Left Stub 🎟️L અને Right Stub 🎟️R) હોય છે. જ્યારે બંને હાફ-ટિકિટો પંચ સ્ટેશન પર પહોંચે છે, ત્યારે તેઓ મર્જ થઈને ૧ પૂર્ણ ગોલ્ડન ટિકિટ બની જાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M752", "cells": [[7, 8]], "params": {"requiredStubs": ["stub_left", "stub_right"], "craftedKey": "golden_ticket"}, "hammerable": false}
  ```

---

### M753 · Master Pass (Skeleton Key)
- **Intro Level:** L7751 (Block 26, x1)
- **Category:** P / K (Universal Skeleton Locomotive)
- **Exact Rule:** માસ્ટર પાસ વહન કરતી ગોલ્ડન ટ્રેન. આ ટ્રેન પોતાના મુસાફરી માર્ગમાં આવતા કોઈપણ પ્રથમ રેલ્વે બેરિયર (લાલ, વાદળી કે લીલો) પર પહોંચતાં જ તેને તુરંત અનલોક કરી દે છે. અનલોક કર્યા પછી માસ્ટર પાસ વપરાઈ જાય છે (Single Use).
- **Hammerable:** Yes (Track Crane સંપૂર્ણ ટ્રેન હટાવી શકે છે).
- **JSON Definition:**
  ```json
  {"id": "p_master", "type": "path", "cells": [[2, 2], [2, 3]], "dir": "R", "params": {"isMasterPass": true}}
  ```

---

### M754 · Ticket Swap Pad (Key Swap)
- **Intro Level:** L7871 (Block 38, x1)
- **Category:** T (Key Reallocation Pad)
- **Exact Rule:** ટિકિટ અદલાબદલી પેડ્સ. જ્યારે બે ટિકિટ ધારક ટ્રેનો બંને પેડ્સ પર આવીને ઊભી રહે છે, ત્યારે પેડ પર ટેપ કરવાથી (1 Move) બંને ટ્રેનો વચ્ચે ટિકિટ પ્રતીકો (ચાવીઓ) અદલાબદલી (swap) થાય છે.
- **Hammerable:** No.
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M754", "cells": [[9, 3], [9, 5]], "params": {"swapSlots": ["p1", "p2"]}, "hammerable": false}
  ```

---

## 3. Solver & Engine Impact
- **Dependency Graph:** સોલ્વર કી-ડિપેન્ડન્સી ડાયરેક્ટેડ એસાયક્લિક ગ્રાફ (DAG) બનાવે છે. ચાવીઓના ખોટા વપરાશથી ડેડલોક ન થાય તે સુનિશ્ચિત કરવા Topological Sort તપાસ થાય છે.
- **Master Pass Branching:** માસ્ટર પાસ વડે કયો દરવાજો ખોલવો તે પઝલની ક્રિટિકલ ચોઇસ છે; સોલ્વર તમામ દરવાજાઓ માટે બ્રાન્ચિંગ કરી ન્યૂનતમ મૂવ્સ શોધે છે.
- **Crafting Invariant:** પંચિંગ સ્ટેશન પર બંને સ્ટબ્સ પહોંચે તે પહેલાં ગોલ્ડન બેરિયર અનસોલ્વેબલ ગણાય છે.
