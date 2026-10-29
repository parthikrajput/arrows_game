# Phase 15: Signature System and Mechanics (લેવલ 7001 થી 7500)

> આ દસ્તાવેજ **Phase 15 (River Delta)** ના સિગ્નેચર સિસ્ટમ (Conveyors & Tracks) અને 4 નવા બેઝ મિકેનિક્સ (**M701, M702, M703, M704**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 15 Index](./README.md) · [Scope & Rules](./01_PHASE_15_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: રિવર ડેલ્ટા (River Delta: Conveyors & Tracks)

River Delta એ પાણીના વહેણ જેવી કન્વેયર ટ્રેક પ્રણાલી છે. આ સિસ્ટમમાં સાપો માત્ર ખેલાડીના ટેપથી જ આગળ નથી વધતા, પરંતુ કન્વેયર ટાઇલ્સ પર ઊભા રહેતાં પ્રત્યેક મૂવ પછી પાણીના પ્રવાહ સાથે આપમેળે 1 સેલ આગળ સરકે છે.

```
       [CONVEYOR TILE] ===> [CONVEYOR TILE] ===> [M701 RIVER FORK]
                                                      |
                                                      +---> [BRANCH A: LEFT]
                                                      +---> [BRANCH B: RIGHT] (Tap to toggle)

       [M704 WHIRLPOOL LOOP] (Closed 4-cell loop -> snake circulates 1 cell/move)
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M701: River Fork / Belt Junction (કન્વેયર જંક્શન)
- **પ્રથમ પરિચય:** Level 7011 (Block 702, x1 slot).
- **કાર્યપદ્ધતિ:**
  - 1 ઇનપુટ અને 2 આઉટપુટ (ડાબે અને જમણે) ધરાવતી વિભાજક ટાઇલ.
  - ખેલાડી જંક્શન પર ટેપ કરે છે ત્યારે:
    1. સ્વિચનું મુખ ડાબેથી જમણે (અથવા જમણેથી ડાબે) બદલાય છે.
    2. ખેલાડીનો 1 મૂવ વપરાય છે (`Move += 1`).
    3. સક્રિય દિશાના એરો ગોલ્ડન લાઈટ સાથે પ્રકાશિત થાય છે.
  - જંક્શન પરથી પસાર થતો સાપ સ્વિચની સક્રિય દિશા મુજબ વળી જાય છે.

---

### 2.2 M702: Tide River / Reversible Belt (ભરતી-ઓટ રિવર્સિબલ ટ્રેક)
- **પ્રથમ પરિચય:** Level 7131 (Block 714, x1 slot).
- **કાર્યપદ્ધતિ:**
  - સમુદ્રી ભરતીની લહેરો અંકિત થયેલી કન્વેયર ટાઇલ્સ.
  - આ ટ્રેક્સ દર $N$ મૂવ્સે (દા.ત. દર 3 કે 4 મૂવ્સે) આપોઆપ પોતાની દિશા $180^\circ$ ઉલટાવે છે:
    $$\text{IsReversed} = \left(\lfloor \text{CurrentMove} / N \rfloor \pmod 2\right) == 1$$
  - ખેલાડીએ આગળનું પ્લાનિંગ કરવું પડે છે કે સાપ ક્યારે આગળ ધકેલાશે અને ક્યારે પાછો ખેંચાશે.

---

### 2.3 M703: Sluice Lever / Belt Lever (સ્લૂઇસ કંટ્રોલ લિવર)
- **પ્રથમ પરિચય:** Level 7251 (Block 726, x1 slot).
- **કાર્યપદ્ધતિ:**
  - નદીના કિનારે આવેલું લાકડાનું ગેટ લિવર.
  - ખેલાડી લિવર પર ટેપ કરે છે ત્યારે તે ચોક્કસ કન્વેયર ટ્રેકને "ON" (પ્રવાહી વહેણ) અથવા "OFF" (સ્થિર પાણી) કરે છે.
  - ટેપ કરવાથી 1 મૂવ વપરાય છે.
  - જ્યારે ટ્રેક OFF હોય, ત્યારે સાપ સામાન્ય સ્થિર ગ્રીડ સેલની જેમ તેના પર ઊભો રહી શકે છે.

---

### 2.4 M704: Whirlpool / Track Loop (વમળ લૂપ)
- **પ્રથમ પરિચય:** Level 7371 (Block 738, x1 slot).
- **કાર્યપદ્ધતિ:**
  - 4 અથવા 8 કન્વેયર ટાઇલ્સનો બનેલો બંધ ચક્રીય ટ્રેક (Closed Loop).
  - જ્યારે કોઈ સાપ સંપૂર્ણપણે આ વમળમાં પ્રવેશે છે, ત્યારે તે દર મૂવ પર ચક્રાકારે ગોળ ફરે છે.
  - જ્યારે સાપનું મોં લૂપના બહાર નીકળવાના માર્ગ (Exit Tangent) સાથે લાઇનઅપ થાય છે, ત્યારે ખેલાડી સાપ પર ટેપ કરીને તેને લૂપમાંથી મુક્ત કરી શકે છે.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Action Input -> Tap Snake OR Tap M701 Junction OR Tap M703 Lever
Step 2: Move Counter Increments (Move += 1)
Step 3: If Switch/Lever tapped -> Toggle Track routing state
Step 4: Check M702 Tide Reversal:
        - If Move % TideInterval == 0 -> Flip flow direction
Step 5: If Snake Tapped -> Execute active slither movement
Step 6: Post-Move Conveyor Step (Passive Movement):
        - For each snake residing on active Conveyor Tiles:
            If cell_in_conveyor_direction is clear -> Push snake 1 cell forward
        - Advance snakes inside M704 Whirlpools by 1 loop node
Step 7: Check Board Exits & Settle -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Non-Blocking Flow:** કન્વેયર પર આગળનો સેલ બ્લોક હોય તો સાપ અટકી જાય છે; કોઈ ક્રેશ કે હાર્ટ લોસ થતો નથી.
2. **Whirlpool Exit Guarantee:** વમળ લૂપમાંથી બહાર નીકળવાનો સ્પર્શક માર્ગ (Exit Tangent) ક્યારેય કાયમી બ્લોક હોતો નથી.
3. **Finite State Traversal:** સોલ્વર કન્વેયર ગતિશીલતાને મોડ્યુલો-સ્ટેટ તરીકે ટ્રેક કરીને લૂપિંગ સોલ્યુશન્સને સરળતાથી શોધી કાઢે છે.

