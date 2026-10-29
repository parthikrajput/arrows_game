# Phase 14: Signature System and Mechanics (લેવલ 6501 થી 7000)

> આ દસ્તાવેજ **Phase 14 (Pond Reflections)** ના સિગ્નેચર સિસ્ટમ (Mirror Worlds) અને 4 નવા બેઝ મિકેનિક્સ (**M651, M652, M653, M654**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 14 Index](./README.md) · [Scope & Rules](./01_PHASE_14_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: પોન્ડ રિફ્લેક્શન્સ (Pond Reflections: Mirror Worlds)

Pond Reflections એ બોર્ડના કેન્દ્રમાંથી પસાર થતી જળ-અક્ષ (Water Axis) પર આધારિત પ્રતિબિંબિત પઝલ સિસ્ટમ છે. આ સિસ્ટમમાં સાપો સિંગલ એન્ટિટી તરીકે નહીં, પરંતુ સપ્રમાણ જોડીઓ તરીકે સંચાલિત થાય છે.

```
       [SIDE A: UPPER]       [Snake A] ------> (Tap: moves right)
       ====================  [M651 POND AXIS: REFLECTIVE WATER DIVIDER]
       [SIDE B: LOWER]       [Snake B] ------> (Auto-mirrors: moves right)
       
       [M654 INVERSE SNAKE]  <------ (Moves in exact OPPOSITE direction of partner)
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M651: Pond Axis / Mirror Axis (પ્રતિબિંબિત જળ-અક્ષ)
- **પ્રથમ પરિચય:** Level 6511 (Block 652, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડના કેન્દ્રમાં ચમકતી પાણીની રેખા જે બોર્ડને બે સમાન ભાગોમાં વહેંચે છે.
  - અક્ષની બંને બાજુના સાપો પરસ્પર "મિરર પાર્ટનર્સ" તરીકે લિંક થયેલા હોય છે.
  - ખેલાડી જ્યારે સાપ A પર ટેપ કરે છે, ત્યારે સાપ B પણ આપોઆપ પોતાની પ્રતિબિંબિત દિશામાં આગળ વધે છે.
- **સિંક્રનાઇઝ્ડ સેફ્ટી રુલ:**
  - બંને સાપોનો માર્ગ સંપૂર્ણ ખુલ્લો હોવો અનિવાર્ય છે. જો બેમાંથી કોઈપણ એક સાપનો રસ્તો બ્લોક હોય, તો બંનેમાંથી કોઈ સાપ આગળ વધતો નથી; બંને માથું બોંક કરીને મૂળ સ્થાને રહે છે (0 Hearts Lost).

---

### 2.2 M652: Reflection Lock / Reflect Lock (વિરુદ્ધ કિનારાનું લૉક)
- **પ્રથમ પરિચય:** Level 6631 (Block 664, x1 slot).
- **કાર્યપદ્ધતિ:**
  - એક દરવાજો જે અક્ષની એક બાજુ (દા.ત. Side A) પર આવેલો હોય છે.
  - તેને ખોલવા માટે જરૂરી કી-સાપ અક્ષની વિરુદ્ધ બાજુ (Side B) પર હોય છે.
  - જ્યારે Side B નો કી-સાપ સંપૂર્ણપણે બોર્ડમાંથી બહાર નીકળી જાય છે, ત્યારે એક જળ-તરંગ અક્ષ ઓળંગીને Side A ના દરવાજાને કાયમી ધોરણે અનલૉક કરે છે.

---

### 2.3 M653: Twin Pond / Twin Board (જોડિયાં બોર્ડ્સ)
- **પ્રથમ પરિચય:** Level 6751 (Block 676, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બે સંપૂર્ણપણે એકસમાન પ્રતિબિંબિત ગ્રીડ્સ.
  - બંને બોર્ડ પર સાપોની ગોઠવણી આબેહૂબ સમાન હોય છે.
  - ખેલાડીએ એવી વ્યૂહરચના બનાવવાની રહે છે કે એક બાજુ સાપો ક્લિયર થતાં બીજી બાજુ પણ સમાંતર રીતે તમામ સાપો કોઈપણ અડચણ વગર મુક્ત થાય.

---

### 2.4 M654: Upside-down Snake / Inverse Path (ઊંધો સાપ)
- **પ્રથમ પરિચય:** Level 6871 (Block 688, x1 slot).
- **કાર્યપદ્ધતિ:**
  - વિશિષ્ટ સાપ જેની પીઠ પર ઊંધા તીરનું ચિહ્ન હોય છે.
  - તે પોતાના મિરર જોડીદારની સમાંતર ચાલવાને બદલે **તદ્દન વિરુદ્ધ દિશા (Opposite Vector)** માં સરકે છે!
  - દા.ત. જો સાપ A ઉત્તર તરફ સરકે છે, તો સાપ B દક્ષિણ તરફ સરકે છે; જો સાપ A પૂર્વ તરફ જાય, તો સાપ B પશ્ચિમ તરફ જાય છે.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Tap Input -> Active Snake Selection (Snake A)
Step 2: Look up Mirrored Partner (Snake B) in MirrorPairRegistry
Step 3: Vector Calculation:
        - If Normal Mirror (M651) -> Vector B = Reflect(Vector A)
        - If Inverse Snake (M654) -> Vector B = -Reflect(Vector A)
Step 4: Dual Path Clearance Check (Simultaneous check for Snake A & Snake B)
Step 5: If BOTH clear:
        - Execute parallel slither animations for Snake A & Snake B
        - Move Counter += 1
        - If Side B key snake exits -> Trigger M652 unlock on Side A
Step 6: If EITHER blocked -> Execute dual bonk ripple (0 Hearts Lost)
Step 7: Board Settled -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Simultaneous Reachability:** સોલ્વર ખાતરી કરે છે કે બંને બાજુના સાપો એકબીજાના એક્ઝિટ પાથને સમાંતર કે વિરુદ્ધ ગતિમાં ક્યારેય અવરોધતા નથી.
2. **Key Independence:** M652 લોક ખોલવા માટે જરૂરી કી-સાપ ક્યારેય તે જ દરવાજા પાછળ બંધાયેલો હોતો નથી (કોઈ સર્ક્યુલર ડિપેન્ડન્સી નહીં).
3. **Deterministic Physics:** મિરરિંગ અને ઇન્વર્સ વેક્ટર્સ ફ્લોટિંગ પોઇન્ટ એરર વગર પ્યોર ઇન્ટિજર ગ્રીડ કોઓર્ડિનેટ્સ પર ગણાય છે.
