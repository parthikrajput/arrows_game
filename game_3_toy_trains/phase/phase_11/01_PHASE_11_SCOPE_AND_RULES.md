# 01 · Phase 11 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 11 (Levels 5001–5500) ના નિયમો, Linked Boards (Twin Tables) signature system, ક્રોસ-ટેબલ બ્રિજિંગ, ઇન્ટર-ટેબલ ટિકિટ્સ, મિરર ટ્રેન સિન્ક અને Remote Config keys.

**Related docs:** [Phase 11 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md)

---

## 1. Scope (પ્રમાણ)
Phase 11 એ Toy Trains નું અગિયારમું content update છે જે Levels 5001 થી 5500 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 10 (4501–5000) | Phase 11 (5001–5500) |
|---|---|---|
| Levels | 4501–5000 | **5001–5500 (On-device generated via seed)** |
| Signature System | Timetable Master (Sequencing) | **Twin Tables (Linked Boards)** |
| Board Structure | Single contiguous board | **Two Linked Sub-boards (Table A & Table B)** |
| Board Crossing | Single board edge exit | **Table Bridge (M501) transfers train between boards** |
| Cross Trigger | Local pattern unlock | **Inter-table Ticket (M502) unlocks barrier on other table** |
| Dual Dynamics | Sequential echo exits | **Mirror Table (M503) mirrors move across tables** |
| Tunnels | Local board tunnels | **Relay Tunnel (M504) spans across Table A and B** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | 12×12 થી 14×14 | **Dual 8×8 થી 9×9 Sub-boards (Side-by-side)** |
| Trains Count | 32–44 trains | **34–46 trains** |

---

## 2. Signature System: Twin Tables (`S11` Rules)
1. **Table Bridge (M501 Board Link Edge):**
   - Table A અને Table B વચ્ચેનો લાકડાનો કનેક્ટીંગ પુલ (Bridge Lane).
   - જ્યારે Table A પરથી ટ્રેન લિંક્ડ એજ તરફ મુવ કરે છે, ત્યારે તે બોર્ડ છોડતી નથી, પરંતુ Table B ની સંલગ્ન એજ સેલમાંથી બરાબર તે જ ગતિ અને દિશા સાથે પ્રવેશે છે.
   - જો Table B નો એન્ટ્રી સેલ અવરોધાયેલો (ઓક્યુપાઈડ) હોય, તો ટ્રેન Table A ની એજ પર બમ્પ થઈ −1 Heart ગુમાવે છે.
2. **Inter-table Ticket (M502 Cross-board Key):**
   - Table A પર મૂકેલી ખાસ ટિકિટ કાર અથવા સ્ટેશન આઇટમ.
   - જ્યારે Table A પર ટ્રેન આ ટિકિટ કલેક્ટ કરે છે અથવા તેને સ્ટેશનમાં લઈ જાય છે, ત્યારે Table B પર રહેલો લિન્ક્ડ રેલ્વે બેરિયર કાયમી ધોરણે ખુલી જાય છે.
3. **Mirror Table (M503 Mirror Board):**
   - બંને ટેબલ્સ પર હાજર સમાન જોડિયા ટ્રેનો (Twin Locomotives).
   - જ્યારે પ્લેયર Table A પરની ટ્વિન ટ્રેન પર ટેપ કરે છે, ત્યારે તે ચાલે છે અને તે જ ક્ષણે Table B પરની જોડિયા ટ્રેન પણ મિરર કરેલી દિશામાં સ્વચાલિત રીતે 1 મૂવ આગળ વધે છે. બંનેના ટ્રેક ક્લિયર હોવા આવશ્યક છે.
4. **Relay Tunnel (M504 Relay Portal):**
   - ક્રોસ-ટેબલ પોર્ટલ સુરંગ. એક સુરંગનું મુખ Table A પર અને બીજું Table B પર હોય છે.
   - Table A ના ટનલમાં પ્રવેશતી ટ્રેન 1 Move માં Table B ના ટનલ મુખમાંથી બહાર આવે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `11` | Player માટે ઉપલબ્ધ મહત્તમ phase. `11` હોય ત્યારે જ L5001 unlock થાય. |
| `phase_11_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_11_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p11` | string | `"{}"` | Emergency overrides for failed seeds in Phase 11. |
