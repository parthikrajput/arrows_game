# Phase 13: Signature System and Mechanics (લેવલ 6001 થી 6500)

> આ દસ્તાવેજ **Phase 13 (Mystery Mists)** ના સિગ્નેચર સિસ્ટમ (Hidden Info & Fog) અને 4 નવા બેઝ મિકેનિક્સ (**M601, M602, M603, M604**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 13 Index](./README.md) · [Scope & Rules](./01_PHASE_13_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: મિસ્ટ્રી મિસ્ટ્સ (Mystery Mists: Fog & Reveal)

Mystery Mists એ બોર્ડ પર છવાયેલું વિઝ્યુઅલ ધુમ્મસ છે જે ચોક્કસ ટાઇલ્સ અને અવરોધોને આંશિક રીતે ઢાંકે છે. આ સિસ્ટમ અનુમાન લગાવવા પર નહીં, પરંતુ સ્કાઉટિંગ અને ફ્રી પાથ પ્રીવ્યૂના બુદ્ધિશાળી ઉપયોગ પર આધારિત છે.

```
       [FOG COVERED REGION] 
       ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
       [M601 SCOUT GECKO] ---> (Slithers out -> Permanently clears 1-cell radius fog)
       ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
       [M603 FALSE WALL]  ---> (Appears as wall, but Tongue-Flick Preview shows path through)
       [M604 GLOW STONE]  ---> (Snake on plate -> Temporarily reveals 3x3 surrounding cells)
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M601: Scout Gecko / Scout Path (સ્કાઉટ ગેકો)
- **પ્રથમ પરિચય:** Level 6011 (Block 602, x1 slot).
- **કાર્યપદ્ધતિ:**
  - માથા પર ગરોળી (Gecko) નું પ્રતીક ધરાવતો ઝડપી સાપ.
  - જ્યારે આ સાપ બોર્ડ પરથી બહાર નીકળે છે:
    1. તેના સમગ્ર પ્રવાસ માર્ગ (Lane) ના 1-સેલ રેડિયસમાં રહેલા તમામ ધુમ્મસવાળા સેલ્સ કાયમી ધોરણે ખુલી જાય છે (`permanentlyRevealed`).
    2. આ વિસ્તારમાં ભવિષ્યમાં M602 Trick Mist ક્યારેય ફરી છવાઈ શકતું નથી.
- **એજ કેસ (Edge Cases):**
  - જો સ્કાઉટ પોતે અન્ય સાપો પાછળ ફસાયેલો હોય, તો અન્ય સાપોને પ્રીવ્યૂ કરીને સાવચેતીથી બહાર કાઢીને સ્કાઉટનો માર્ગ મોકળો કરવાનો રહે છે.

---

### 2.2 M602: Trick Mist / Mimic Fog (છળકપટ ધુમ્મસ)
- **પ્રથમ પરિચય:** Level 6131 (Block 614, x1 slot).
- **કાર્યપદ્ધતિ:**
  - સામાન્ય સાપ બહાર નીકળ્યા પછી, તેના દ્વારા ખાલી થયેલી જગ્યાઓમાંથી 1 પસંદગીના સેલ પર હળવું ધુમ્મસ ફરી વળે છે.
  - આ ધુમ્મસ ટાઇલની સપાટી (બરફ, કીચડ કે સ્વીચ) ને અસ્પષ્ટ બનાવે છે.
  - **નિવારણ:** જો તે સેલ સ્કાઉટ ગેકો (M601) દ્વારા પહેલેથી રીવીલ થયેલો હોય, તો ટ્રીક મિસ્ટ ત્યાં બની શકતું નથી.

---

### 2.3 M603: Painted Wall / False Wall (ભ્રામક દીવાલ)
- **પ્રથમ પરિચય:** Level 6251 (Block 626, x1 slot).
- **કાર્યપદ્ધતિ:**
  - ગ્રાફિક્સમાં આ ટાઇલ અડીખમ પથ્થરની દીવાલ જેવી દેખાય છે.
  - વાસ્તવમાં આ કેનવાસ પર દોરેલી નકલી દીવાલ છે અને સાપ તેની આરપાર સીધો નીકળી શકે છે!
  - **ફેરનેસ ગેરંટી (Fairness Standard):** ખેલાડી જ્યારે સાપ પર $\ge 350\text{ ms}$ લોંગ-પ્રેસ (Tongue-Flick Preview) કરે છે, ત્યારે પ્રીવ્યૂ લાઇન દીવાલમાંથી આરપાર પસાર થઈને સોનેરી ચમક સાથે સત્ય છતું કરે છે.

---

### 2.4 M604: Glow Stone / Reveal Plate (ગ્લો પ્લેટ)
- **પ્રથમ પરિચય:** Level 6371 (Block 638, x1 slot).
- **કાર્યપદ્ધતિ:**
  - જમીનમાં જડેલી લીલા પ્રકાશવાળી પ્રેશર પ્લેટ.
  - જ્યાં સુધી કોઈ સાપનું શરીર આ પ્લેટને ઢાંકીને રાખે છે, ત્યાં સુધી તેના કેન્દ્રની આસપાસના $3\times 3$ વિસ્તારનું તમામ ધુમ્મસ અદૃશ્ય રહે છે.
  - જ્યારે સાપ પ્લેટ છોડીને સંપૂર્ણ બહાર નીકળી જાય છે, ત્યારે તે વિસ્તાર જો સ્કાઉટ થયેલો ન હોય તો ફરી ધુમ્મસથી ઘેરાઈ જાય છે.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Long-Press (Preview) -> Calculate Raycast across Painted Walls (M603)
Step 2: Player Tap Input -> Active Snake Selection
Step 3: Movement Execution:
        - Snake body moves across tiles
        - Update M604 Glow Stones (If covered -> set 3x3 visibility = scouted)
Step 4: Board Exit Detection:
        - If Scout Gecko (M601) exits -> Mark lane + 1-cell radius as permanentlyRevealed
        - If Regular Snake exits -> If vacated cell not permanentlyRevealed, spawn M602 Trick Mist
Step 5: Refresh Fog Render Buffer & Update Canvas Alpha
Step 6: Board Settled -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Zero Guessing Solvability:** સોલ્વર ખાતરી કરે છે કે ફ્રી પ્રીવ્યૂ અને સ્કાઉટિંગ પાથ દ્વારા ખેલાડી કોઈપણ અનુમાન કે જોખમ વગર 100% ખાતરીપૂર્વક નિર્ણય લઈ શકે.
2. **Hidden Blocker Safety:** ધુમ્મસ હેઠળ છુપાયેલા અવરોધ સાથે અથડાતાં કોઈ હાર્ટ નષ્ટ થતું નથી (હેડ-બોંક રીટર્ન).
3. **Scout Priority Path:** જનરેટર ખાતરી કરે છે કે સ્કાઉટ ગેકો બહાર નીકળવાનો હંમેશા એક સુરક્ષિત પ્રાથમિક રસ્તો અસ્તિત્વમાં હોય.
