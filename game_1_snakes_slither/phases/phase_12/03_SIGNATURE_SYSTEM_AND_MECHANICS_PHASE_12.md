# Phase 12: Signature System and Mechanics (લેવલ 5501 થી 6000)

> આ દસ્તાવેજ **Phase 12 (Monsoon Winds)** ના સિગ્નેચર સિસ્ટમ (Gravity Physics) અને 4 નવા બેઝ મિકેનિક્સ (**M551, M552, M553, M554**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 12 Index](./README.md) · [Scope & Rules](./01_PHASE_12_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: મોન્સૂન વિન્ડ્સ (Monsoon Winds: Gravity Physics)

Monsoon Winds એ બોર્ડ પર 4 દિશાઓમાં ફરતી ગુરુત્વાકર્ષણ પ્રણાલી છે. આ સિસ્ટમમાં બ્લોકર્સ અને અમુક વિશેષ સાપો સ્થિર રહેતા નથી, પરંતુ પ્રત્યેક મૂવ પછી પવનની દિશામાં નીચે પડે છે અથવા સરકે છે.

```
       [GRAVITY: DOWN V]
       [M552 FRUIT] 
            | (falls 1 cell if empty)
            V
       [EMPTY CELL] ---> [RESTS ON BOARD BOUNDARY OR SNAKE]

       [M551 WIND LEVER] (Tap -> Gravity Rotates 90° CW to RIGHT >)
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M551: Wind Lever / Gravity Lever (ગુરુત્વાકર્ષણ લિવર)
- **પ્રથમ પરિચય:** Level 5511 (Block 552, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ પર સ્થિત એક યાંત્રિક પવનચક્કી અથવા લિવર ટાઇલ.
  - ખેલાડી લિવર પર ટેપ કરે છે ત્યારે:
    1. ગુરુત્વાકર્ષણની દિશા $90^\circ$ ક્લોકવાઇઝ ફરે છે ($\downarrow \to \to \to \uparrow \to \leftarrow$).
    2. ખેલાડીનો 1 મૂવ વપરાય છે (`Move += 1`).
    3. HUD પરનો પવન એરો તાત્કાલિક નવી દિશા તરફ વળે છે.
    4. તમામ મુક્ત ફળો અને ભારે સાપો નવી દિશામાં સરકવાનો પ્રયત્ન કરે છે.
- **એજ કેસ (Edge Cases):**
  - જો લિવર પોતે અન્ય સાપના શરીર હેઠળ ઢંકાયેલું હોય, તો તે સાપ હટ્યા પછી જ ટેપ થઈ શકે છે.

---

### 2.2 M552: Falling Fruit / Falling Blockers (પડતાં ફળો)
- **પ્રથમ પરિચય:** Level 5631 (Block 564, x1 slot).
- **કાર્યપદ્ધતિ:**
  - ગોળાકાર જંગલી ફળો જે 1 ગ્રીડ સેલ રોકે છે.
  - પ્રત્યેક માન્ય મૂવ (સાપ બહાર નીકળ્યા અથવા લિવર ટેપ કર્યા) પછી:
    - જો ફળની નીચેનો સેલ (ગ્રેવિટી વેક્ટર મુજબ) સંપૂર્ણ ખાલી હોય, તો ફળ 1 સેલ નીચે પડે છે.
    - આ પતન જ્યાં સુધી તે કોઈ દીવાલ, અન્ય ફળ અથવા સાપના શરીર સાથે ન અથડાય ત્યાં સુધી સળંગ ચાલુ રહે છે.
- **ક્રિટિકલ સેફ્ટી નિયમ:**
  - ફળ પડવાને કારણે સાપ ક્યારેય કચડાઈને નષ્ટ થતો નથી કે ખેલાડીનું હાર્ટ કપાતું નથી; સાપનું શરીર ફળને અટકાવવા માટે નક્કર આધાર બને છે.

---

### 2.3 M553: Floaty Lily / Anti-grav Tile (એન્ટી-ગ્રેવિટી લીલી)
- **પ્રથમ પરિચય:** Level 5751 (Block 576, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ પર ચમકતી જાંબલી/ગુલાબી કમળની ટાઇલ.
  - આ ટાઇલ પર રહેલું કોઈપણ ફળ ગુરુત્વાકર્ષણ શક્તિને અવગણે છે અને નીચે પડ્યા વિના હવામાં તરતું રહે છે.
  - જ્યારે કોઈ સાપ આ ટાઇલ પરથી પસાર થઈને ફળને ધક્કો મારે, ત્યારે જ ફળ સામાન્ય ગુરુત્વાકર્ષણ હેઠળ આવે છે.

---

### 2.4 M554: Heavy Python / Weight Path (ભારે અજગર)
- **પ્રથમ પરિચય:** Level 5871 (Block 588, x1 slot).
- **કાર્યપદ્ધતિ:**
  - વિશાળ અને ભારે સાપ જે પોતાની આળસ અને વજનને કારણે પવનની દિશામાં સરકી શકે છે.
  - જો આ સાપના સંપૂર્ણ શરીરની નીચેના તમામ સેલ્સ એકસાથે ખાલી હોય, તો તે ટેપ કર્યા વગર પણ ગુરુત્વાકર્ષણની દિશામાં આપોઆપ 1 સેલ નીચે સરકે છે.
  - ખેલાડી તેને સામાન્ય સાપની જેમ ટેપ કરીને બોર્ડમાંથી બહાર પણ કાઢી શકે છે.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Action Input -> Tap Snake OR Tap M551 Wind Lever
Step 2: If Lever Tapped -> Rotate Gravity Vector 90° CW
Step 3: If Snake Tapped -> Execute standard slither out animation
Step 4: Increment Move Counter (Move += 1)
Step 5: Post-Move Falling Cascade (Loop until stable):
        - For each M552 Fruit not on M553 Lily:
            If cell_in_gravity_direction == Empty -> Move Fruit
        - For each M554 Heavy Python:
            If all_cells_below_body == Empty -> Shift Python
Step 6: Board Settled & Physics Equilibrium Reached
Step 7: Check Exit Lanes & Ready for Next Move.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Finite Physics Settling:** જનરેટર બાંહેધરી આપે છે કે ફળોનું પતન વધુમાં વધુ $\text{GridSize}$ પગલાંમાં સ્થિર થઈ જશે, કોઈ અનંત લૂપ શક્ય નથી.
2. **Permanent Blocker Safeguard:** ફળ પડ્યા પછી ક્યારેય તમામ બાકી રહેલા સાપોના એક્ઝિટ લેન એકસાથે બ્લોક ન થવા જોઈએ.
3. **Deterministic Cascade:** ભૌતિક પતનની ગણતરી ગ્રીડના સ્કેન ઓર્ડર (ગ્રેવિટી વેક્ટરની સૌથી નજીકના સેલથી શરૂ કરીને) મુજબ સખત રીતે નિર્ધારિત રહે છે.
