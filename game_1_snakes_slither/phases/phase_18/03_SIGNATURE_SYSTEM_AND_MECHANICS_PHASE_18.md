# Phase 18: Signature System and Mechanics (લેવલ 8501 થી 9000)

> આ દસ્તાવેજ **Phase 18 (Remix A: P1–P6 Systems)** ના સિગ્નેચર સિસ્ટમ (Data-Driven Synergy) અને 4 એનાલિટિક્સ કોમ્બો મિકેનિક્સ (**M851, M852, M853, M854**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 18 Index](./README.md) · [Scope & Rules](./01_PHASE_18_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6, §9](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: રિમિક્સ A (Remix A: Early Eras Synergy)

Remix A એ સમગ્ર પઝલ ગેમના પ્રથમ તબક્કાઓ (Phase 1 થી Phase 6) ના શ્રેષ્ઠ સાબિત થયેલા મિકેનિક્સનું સિનર્જિસ્ટિક જોડાણ છે. સ્વતંત્ર મિકેનિક્સના બદલે, આ ફેઝમાં બે કે ત્રણ સિસ્ટમ્સ એકબીજા પર આધારિત થઈને કામ કરે છે.

```
       [PHASE 3: DAY/NIGHT DIAL] ===> CONTROLS ===> [PHASE 4: ELEVATOR FLOOR] (M851)
       [PHASE 6: LIGHT BEAM]    ===> MELTS    ===> [PHASE 5: COCONUT OBSTACLE] (M852)
       [PHASE 6: SOLAR SWITCH]  ===> ENERGIZES ===> [PHASE 1: BURROW PORTAL]   (M853)
```

---

## 2. 4 ડેટા-ડ્રિવન કોમ્બો મિકેનિક્સ (The 4 Combo Mechanics)

### 2.1 M851: Cycle Floor Elevator (દિવસ-રાત એલિવેટર: P3×P4)
- **પ્રથમ પરિચય:** Level 8511 (Block 852, x1 slot).
- **કાર્યપદ્ધતિ:**
  - દર 5 મૂવ્સે દિવસ (Day) અને રાત્રિ (Night) વચ્ચે ડાયલ ફરે છે.
  - બોર્ડ પર આવેલું એલિવેટર આપમેળે દિવસ દરમિયાન ફ્લોર 1 (નીચે) અને રાત્રિ દરમિયાન ફ્લોર 2 (ઉપર) પર શિફ્ટ થાય છે.
  - સાપ માત્ર તે સમયે સક્રિય ફ્લોર પરથી જ પસાર થઈ શકે છે.

---

### 2.2 M852: Prism Coconut Roll (પ્રિઝમ નાળિયેર ભૌતિકી: P5×P6)
- **પ્રથમ પરિચય:** Level 8631 (Block 864, x1 slot).
- **કાર્યપદ્ધતિ:**
  - એક ભારે નાળિયેર બ્લોકર જેને સામાન્ય રીતે ધક્કો મારીને ખસેડવો પડે છે.
  - જ્યારે સૂર્યમંદિરના અરીસામાંથી આવતું પ્રકાશનું કિરણ આ નાળિયેર પર કેન્દ્રિત થાય છે, ત્યારે તે નરમ બનીને આપોઆપ ઓગળી જાય છે અને સાપને શારીરિક શ્રમ વગર સીધો રસ્તો આપે છે.

---

### 2.3 M853: Solar Burrow Portal (સોલાર પોર્ટલ: P1×P6)
- **પ્રથમ પરિચય:** Level 8751 (Block 876, x1 slot).
- **કાર્યપદ્ધતિ:**
  - જમીનદોઝ પોર્ટલની જોડી જે સામાન્ય સ્થિતિમાં નિષ્ક્રિય (બંધ બ્લોકર) હોય છે.
  - જ્યારે પ્રકાશનું કિરણ સોલાર સ્વીચ પર અથડાય છે, ત્યારે બંને પોર્ટલ્સ ઊર્જાવાન થઈને ખુલે છે અને સાપને એક છેડેથી બીજા છેડે ટેલિપોર્ટ કરે છે.

---

### 2.4 M854: Shadow Weight Drop (શેડો વેઇટ ડ્રોપ: P5×P6)
- **પ્રથમ પરિચય:** Level 8871 (Block 888, x1 slot).
- **કાર્યપદ્ધતિ:**
  - પડછાયાના દરવાજા દ્વારા હવામાં પકડી રાખવામાં આવેલો ભારે પથ્થર.
  - જ્યારે પ્રકાશનું કિરણ અવરોધાઈને પડછાયો પડે છે, ત્યારે દરવાજો ખુલે છે અને પથ્થર નીચે ખાડામાં પડીને રસ્તો સમતલ કરી આપે છે.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Input -> Active Snake Selection
Step 2: Move Counter Increments (Move += 1)
Step 3: Update Day/Night Dial (Shift state every 5 moves)
Step 4: Raycast Sun Temple Beams -> Identify illuminated mirrors, prisms, switches
Step 5: State Synchronizations:
        - Update M851 Elevator floor based on Day/Night state
        - Check M852 Coconuts in light beams -> Soften / Dissolve
        - Update M853 Solar Burrows (Open if Solar Switch active)
        - Check M854 Shadow Gates -> Drop suspended stones if shaded
Step 6: Snake Movement Execution -> Slither along cleared paths
Step 7: Check Exits & Board Settled -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Multi-System Determinism:** તમામ 4 સિસ્ટમ્સનો પરસ્પર સંબંધ ચોક્કસ ગણતરી આધારિત છે; કોઈ રેન્ડમ અસ્થિરતા નથી.
2. **Day/Night Cycle Solvability:** સોલ્વર ખાતરી કરે છે કે દિવસ કે રાત્રિ બંને તબક્કામાં હંમેશા ઓછામાં ઓછો એક સુરક્ષિત મૂવ ઉપલબ્ધ હોય.
3. **Zero Damage Collision:** પ્રકાશ કે પડછાયામાં ફેરફાર થતાં સાપ ક્યારેય કચડાઈને હાર્ટ ગુમાવતો નથી (0 Hearts Lost).
