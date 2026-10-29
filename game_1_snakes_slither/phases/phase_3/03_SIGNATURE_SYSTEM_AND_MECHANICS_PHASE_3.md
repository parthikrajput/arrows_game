# 03 — Signature System & Base Mechanics (Phase 3)
> Phase 3 (Day & Night Garden) ની signature system અને 4 નવા base mechanics (M101–M104) ના નિયમો, parameters, edge cases, tick order (§16.17), solver impact અને solvability guarantees.

**Related docs:** [Phase 3 index](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Phase 3 Rules](./01_PHASE_3_SCOPE_AND_RULES.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md)

---

## 1. Signature System: Day & Night Garden (Cycles)
- **Concept:** બગીચામાં દર 5 Moves એ દિવસ અને રાત બદલાય છે.
- **Rules:**
  - Cycle Period = **5 Moves** (standard §11).
  - State A = **Day (સૂર્ય)**: Moves 1–5, 11–15, 21–25...
  - State B = **Night (ચંદ્ર)**: Moves 6–10, 16–20, 26–30...
  - Player Move increment થાય તે પછી જો `moveCount % 5 == 0` થાય તો State toggle થાય છે.
  - HUD પર Sun/Moon dial દર્શાવાય છે જે આગામી Cycle બદલાવા માટે કેટલા Moves બાકી છે તે બતાવે છે (દા.ત. "3 moves to Night").
- **Solver Impact:** Solver state key માં `(moveCount % 10)` સમાવાય છે (Period 10, BFS/IDA*).

---

## 2. Mechanic M101: Sun-Moon Gate (Cycle Gate)
- **Intro Level:** L1011 (Block 2 x1)
- **Category:** Gate / Path-Blocker (D / G)
- **Visual:** પ્રાચીન પથ્થરનું ગેટ જેના પર સૂર્ય અને ચંદ્રની કોતરણી છે.
- **Rule:**
  - Default: **Day (State A) માં OPEN**, **Night (State B) માં CLOSED**.
  - Inverted (`params.inverted: true`): Day માં CLOSED, Night માં OPEN.
  - જ્યારે CLOSED હોય, ત્યારે તે Single Blocker જેવું વર્તે છે (તેના પરથી snake પસાર થઈ શકતો નથી; માથું ભટકાય તો −1 Heart).
  - જ્યારે OPEN હોય, ત્યારે lane તેના પરથી મુક્તપણે પસાર થઈ શકે છે.
  - જો કોઈ snake નો body segment ગેટ ખુલ્લો હતો ત્યારે તેના પર રહી ગયો હોય અને ગેટ બંધ થાય: ગેટ બંધ થવાનું એનિમેશન અટકી જાય છે જ્યાં સુધી snake બહાર ન નીકળી જાય (snake કપાતો નથી; standard §2 safe exit guarantee).
- **JSON Format:**
  ```json
  {"id": "o101_1", "type": "M101", "cells": [[5, 6]], "params": {"inverted": false}, "hammerable": false}
  ```
- **Hammerable:** `false` (Gate base mechanic hammerable નથી; standard §16.18).
- **Solver Guarantee:** Reverse construction માં ગેટ ના ખુલ્લા હોવાના સમયગાળા (Move window) સાથે snake ના exit નું synchronization ચકાસાય છે.

---

## 3. Mechanic M102: Moonlight Root Bridge (Cycle Bridge)
- **Intro Level:** L1131 (Block 14 x1)
- **Category:** Terrain / Layer Crossing (D)
- **Visual:** રાત્રે ચમકતી મોહક મૂળિયાંની પુલ જે ચંદ્રપ્રકાશમાં જ દેખાય છે.
- **Rule:**
  - Bridge ફક્ત તેની સક્રિય state (Default: **Night / State B**) માં જ અસ્તિત્વ ધરાવે છે.
  - સક્રિય અવસ્થામાં: બે ડિસ્કનેક્ટેડ બોર્ડ સેલ્સ વચ્ચે lane crossing પૂરું પાડે છે (અથવા વોઇડ/ખાડા પરથી રસ્તો બનાવે છે).
  - નિષ્ક્રિય અવસ્થા (Day / State A) માં: ત્યાં ખાલી જગ્યા / ખાડો (Void) રહે છે, જેથી તે સેલ પર જવાનો પ્રયત્ન કરનાર snake blocked થાય છે (−1 Heart).
  - જો Bridge પર પહેલેથી snake નું શરીર પડેલું હોય અને Cycle Day માં ફરે: Bridge અદૃશ્ય થતો નથી જ્યાં સુધી snake ખાલી ન થાય (no clipping rule).
- **JSON Format:**
  ```json
  {"id": "o102_1", "type": "M102", "cells": [[8, 4]], "params": {"activeState": "B"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 4. Mechanic M103: Day-Night Burrows (Cycle Portal)
- **Intro Level:** L1251 (Block 26 x1)
- **Category:** Portal / Warp (D)
- **Visual:** જાદુઈ રાફડા (Burrows) જે દિવસ દરમિયાન સોનેરી અને રાત્રે રૂપેરી પ્રકાશ ફેંકે છે.
- **Rule:**
  - પોર્ટલ જોડી (Entry Burrow & Exit Burrow) માત્ર તેની સક્રિય state (Default: **Day / State A**) માં ખુલ્લી રહે છે.
  - સક્રિય અવસ્થા: Entry Burrow માં પ્રવેશતો snake Exit Burrow માંથી તે જ દિશામાં બહાર નીકળે છે (M020 Burrow rules).
  - નિષ્ક્રિય અવસ્થા (Night): Burrow બંધ થઈ જાય છે અને સોલિડ બ્લોકર બની જાય છે. તેના પર જતાં snake નું માથું ભટકાય છે.
- **JSON Format:**
  ```json
  {"id": "o103_1", "type": "M103", "cells": [[3, 3], [10, 10]], "params": {"activeState": "A"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 5. Mechanic M104: Twilight Flower Gate (Cycle Color)
- **Intro Level:** L1371 (Block 38 x1)
- **Category:** Color Filter / Gate (G)
- **Visual:** મોટો જંગલી ફૂલ દર 5 Moves એ પાંખડીઓનો રંગ બદલે છે (દા.ત. Teal ↔ Amber).
- **Rule:**
  - Flower Gate Cycle અનુસાર બે ચોક્કસ રંગો વચ્ચે ફરે છે: Day માં `colorA` અને Night માં `colorB`.
  - Snake નો રંગ જો Flower Gate ના હાલના સક્રિય રંગ સાથે મેળ ખાતો હોય તો જ તે ગેટમાંથી પસાર થઈ શકે છે.
  - જો રંગ અલગ હોય, તો ગેટ બંધ રહે છે અને ભટકાતાં −1 Heart થાય છે.
  - Player એ Cycle ના સમય મુજબ યોગ્ય રંગના snake ને વારો આપવો પડે છે.
- **JSON Format:**
  ```json
  {"id": "o104_1", "type": "M104", "cells": [[6, 8]], "params": {"colorDay": "teal", "colorNight": "amber"}, "hammerable": false}
  ```
- **Hammerable:** `false`.

---

## 6. Tick Order Integration (§16.17)
દરેક Move પછી Phase 3 નું resolution નીચે મુજબ થાય છે:
```
1. Action resolve (Snake exits or interactive tap)
2. moveCount += 1
3. Counters tick (M007... M096)
4. Cycle Step:
   - if (moveCount % 5 == 0):
       currentCycle = (currentCycle == State.DAY) ? State.NIGHT : State.DAY
       update M101 Gates (open/close)
       update M102 Bridges (solid/void)
       update M103 Burrows (active/blocked)
       update M104 Flower Gates (colorDay/colorNight)
5. Derived states & beams check
6. Heart loss & Shields
7. Win condition check
```

## 7. Solvability & Fair Play
- **0 Hearts, 0 Boosters Guarantee:** રિવર્સ કન્સ્ટ્રક્શન અને IDA* સોલ્વર ખાતરી કરે છે કે દરેક લેવલમાં એવો ચોક્કસ ક્રમ મોજૂદ હોય જેમાં સાપ સાચા Cycle Window દરમિયાન જ નીકળે, કોઈ અનિવાર્ય નુકસાન ન થાય.

