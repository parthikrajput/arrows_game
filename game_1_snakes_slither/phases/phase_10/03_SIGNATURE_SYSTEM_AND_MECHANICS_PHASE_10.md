# Phase 10: Signature System and Mechanics (લેવલ 4501 થી 5000)

> આ દસ્તાવેજ **Phase 10 (Jungle Drum Festival)** ના સિગ્નેચર સિસ્ટમ (Sequencing) અને 4 નવા બેઝ મિકેનિક્સ (**M451, M452, M453, M454**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 10 Index](./README.md) · [Scope & Rules](./01_PHASE_10_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: જંગલ ડ્રમ ફેસ્ટિવલ (Jungle Drum Festival: Sequencing)

જંગલ ડ્રમ ફેસ્ટિવલ એ તાલબદ્ધ રિધમ અને રંગોના ક્રમબદ્ધ સંયોજન પર આધારિત પઝલ સિસ્ટમ છે. ખેલાડીઓએ સાપોને માત્ર મુક્ત જ નથી કરવાના, પરંતુ યોગ્ય સમયે (તબલાના તાલ મુજબ) અને યોગ્ય રંગ-ક્રમમાં બહાર કાઢવાના રહે છે.

```
       [MOVE N] ---> DRUM BEAT 1 (OPEN)   ---> Snake 1 Passes
       [MOVE N+1] -> DRUM BEAT 2 (OPEN)   ---> Snake 2 Passes
       [MOVE N+2] -> DRUM BEAT 3 (CLOSED) ---> Snake Blocked (Wait for next beat)

       [TOTEM LOCK] <--- [RED] -> [BLUE] -> [GREEN] (Last 3 exits must match)
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M451: Drum Gate / Rhythm Gate (તાલબદ્ધ ડ્રમ દરવાજો)
- **પ્રથમ પરિચય:** Level 4511 (Block 452, x1 slot).
- **કાર્યપદ્ધતિ:**
  - દરવાજો કોઈ ઘડિયાળના સેકન્ડ્સ પર નહીં, પરંતુ ખેલાડી દ્વારા લેવાતા પ્રત્યેક **મૂવ (Move)** ના આધારે ખુલે છે અને બંધ થાય છે.
  - પ્રત્યેક ગેટ એક પેટર્ન સાઇકલ ધરાવે છે, દા.ત. `[OPEN, OPEN, CLOSED]`.
  - ગણતરી સૂત્ર:
    $$\text{Index} = \text{TotalMovesTaken} \pmod {\text{PatternLength}}$$
  - જો Index પરનું સ્ટેટ OPEN હોય, તો રસ્તો ખુલ્લો છે. CLOSED હોય, તો ગેટ પથ્થરની જેમ બંધ રહે છે.
- **એજ કેસ (Edge Cases):**
  - જો કોઈ સાપ CLOSED ગેટ તરફ સરકે, તો તે માથું બોંક કરીને પાછો વળે છે; કોઈ હાર્ટ કપાતું નથી. ખેલાડી અન્ય કોઈ મુક્ત સાપને ટેપ કરીને મૂવ કાઉન્ટર આગળ વધારી શકે છે જેથી ગેટ ખુલી જાય.

---

### 2.2 M452: Totem Pattern Lock (તોતેમ પેટર્ન લોક)
- **પ્રથમ પરિચય:** Level 4631 (Block 464, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ પર એક વિશાળ લાકડાનો તોતેમ સ્તંભ હોય છે, જેના પર રંગબેરંગી કડાઓ (દા.ત. લાલ $\to$ પીળો $\to$ લીલો) કોતરેલા હોય છે.
  - બોર્ડમાંથી બહાર નીકળેલા **છેલ્લા $k$ સાપોના રંગો** આ પેટર્ન સાથે અક્ષરશઃ મેળ ખાવા જોઈએ.
  - દા.ત. પેટર્ન [લાલ, વાદળી] હોય, અને ખેલાડી પહેલા લાલ સાપ અને પછી વાદળી સાપ બહાર કાઢે, તો તોતેમ સ્તંભ ખુશ થઈને તેનો દરવાજો અનલૉક કરે છે.
  - જો વચ્ચે કોઈ અન્ય રંગનો સાપ નીકળી જાય, તો પેટર્ન રીસેટ થઈ જાય છે.

---

### 2.3 M453: Parade Exit / Order Edge (પરેડ ઓર્ડર એક્ઝિટ)
- **પ્રથમ પરિચય:** Level 4751 (Block 476, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડની ચોક્કસ કિનારી પર "Parade Gate" આવેલું હોય છે.
  - આ ગેટ માત્ર તેના નિયુક્ત ક્રમાંક (Ordinal Numbers: 1, 2, 3...) મુજબ જ સાપોને બહાર જવા દે છે.
  - સાપોની પીઠ પર સ્પષ્ટ નંબર બેજ ચમકે છે.
  - જ્યાં સુધી નંબર 1 બહાર ન નીકળે ત્યાં સુધી નંબર 2 નીકળી શકતો નથી. ખોટા નંબરનો સાપ ત્યાં જતાં બોંક થઈને અટકે છે.

---

### 2.4 M454: Echo Frogs / Echo Sequence (ઇકો સિક્વન્સ)
- **પ્રથમ પરિચય:** Level 4871 (Block 488, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ પર બે જૂથ હોય છે: **Group A (Master)** અને **Group B (Echo)**.
  - ખેલાડી Group A ના સાપોને પોતાની પસંદગીના કોઈપણ ક્રમમાં બહાર કાઢી શકે છે (દા.ત. ગુલાબી $\to$ નારંગી $\to$ વાદળી).
  - સિસ્ટમ આ ક્રમને મેમરીમાં સ્ટોર કરે છે.
  - Group B ના દરવાજા ત્યારે જ ખુલે છે જ્યારે Group A સંપૂર્ણ સાફ થાય.
  - Group B એ Group A ના રંગ-ક્રમનું **અક્ષરશઃ પુનરાવર્તન (Echo)** કરવું અનિવાર્ય છે. ખોટો રંગ ટેપ થતાં સાપ આગળ વધતો નથી.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Tap Input -> Active Snake Selection
Step 2: Move Counter Increments (Move += 1)
Step 3: Update M451 Rhythm Gates: GateState = Pattern[Move % Length]
Step 4: Path Clearance Evaluation (Check M451 state, M453 order badge)
Step 5: Movement Execution -> Snake exits board:
        - Push Snake Color to ExitHistoryBuffer
        - Check M452 Totem Match (last k exits == target pattern)
        - If Group A member -> Append to GroupA_ExitOrder
        - If Group B member -> Verify against GroupA_ExitOrder[B_index]
Step 6: Unlock evaluation (M452 opens, M453 advances next expected badge, M454 gate updates)
Step 7: Board Settled -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Parade Solvability:** સોલ્વર ખાતરી કરે છે કે Parade Exit ધરાવતા લેવલમાં નંબર 1 સાપ ક્યારેય અન્ય ઉચ્ચ નંબરના સાપ દ્વારા પાથ-બ્લોક ન થયેલો હોય.
2. **Color Palette Matching:** M452 અને M454 માં જરૂરી પેટર્નના તમામ રંગો બોર્ડ પર પૂરતી સંખ્યામાં હાજર હોય.
3. **No Soft-Locks:** ખોટા ક્રમે ટેપ થતાં સાપ ડેડલોક થતો નથી; તે માત્ર માથું બોંક કરીને પાછો આવે છે જેથી ખેલાડી સાચો ક્રમ શોધી શકે.

