# Phase 11: Signature System and Mechanics (લેવલ 5001 થી 5500)

> આ દસ્તાવેજ **Phase 11 (Two Ponds)** ના સિગ્નેચર સિસ્ટમ (Linked Boards) અને 4 નવા બેઝ મિકેનિક્સ (**M501, M502, M503, M504**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 11 Index](./README.md) · [Scope & Rules](./01_PHASE_11_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: ટૂ પોન્ડ્સ (Two Ponds: Linked Boards)

Two Ponds એ રમતનું મેદાન બે લિંક્ડ તળાવો (Board 1 અને Board 2) માં વિભાજીત કરતી સિગ્નેચર સિસ્ટમ છે. સાપો માત્ર પોતાના તળાવમાં સીમિત નથી રહેતા, પરંતુ પુલ, ચાવીઓ અને પોર્ટલ દ્વારા બંને તળાવો વચ્ચે આદાનપ્રદાન કરે છે.

```
       +--------------------+
       |      BOARD 1       |
       |  [Snake A] ------> | ---> [M501 VINE BRIDGE]
       +--------------------+             |
                                          V
       +--------------------+ <-----------+
       |      BOARD 2       | (Snake A enters and continues lane)
       |                    |
       +--------------------+
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M501: Vine Bridge Edge / Board Link Edge (વાઇન બ્રિજ લિંક)
- **પ્રથમ પરિચય:** Level 5011 (Block 502, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ 1 ની નિયુક્ત કિનારી પર લીલા વેલાઓનો બ્રિજ બોર્ડ 2 સાથે જોડાયેલો હોય છે.
  - જ્યારે કોઈ સાપ આ કિનારી તરફથી બહાર નીકળે છે, ત્યારે તે ગેમમાંથી બહાર નથી જતો; તેનું માથું સીધું જ બોર્ડ 2 ની વિરુદ્ધ કિનારી પર પ્રવેશ કરે છે.
  - સાપનું શરીર બંને બોર્ડ પર સળંગ પ્રવાહી રીતે વહે છે જ્યાં સુધી તેની પૂંછડી બોર્ડ 1 છોડી ન દે.
- **એજ કેસ (Edge Cases):**
  - જો બોર્ડ 2 પર પ્રવેશવાના ટાઇલ પર અન્ય કોઈ સાપ ઊભો હોય અથવા રસ્તો બ્લોક હોય, તો સાપ બોર્ડ 1 પર જ અટકી જાય છે; કોઈ નુકસાન થતું નથી.

---

### 2.2 M502: Messenger Key / Cross-Board Key (ક્રોસ-બોર્ડ કી)
- **પ્રથમ પરિચય:** Level 5131 (Block 514, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ 1 પર એક વિશિષ્ટ "Messenger Snake" હોય છે જેના માથા પર સોનેરી કમળ-ચાવીનું પ્રતીક હોય છે.
  - જ્યારે આ સાપ બોર્ડ 1 માંથી સફળતાપૂર્વક બહાર નીકળે છે, ત્યારે એક સોનેરી કણ ઊડીને બોર્ડ 2 પર જાય છે અને ત્યાં આવેલા દરવાજાને અનલૉક કરે છે.
  - આ મિકેનિક બોર્ડ 1 અને બોર્ડ 2 વચ્ચે એક ચોક્કસ આંતર-નિર્ભરતા (Cross-Board Dependency) ઊભી કરે છે.

---

### 2.3 M503: Pond Reflection / Mirror Board (મિરર ટ્વિન્સ)
- **પ્રથમ પરિચય:** Level 5251 (Block 526, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ 1 પર સાપ A અને બોર્ડ 2 પર સાપ B એકબીજાના "પ્રતિબિંબ" (Mirrors) તરીકે જોડાયેલા હોય છે.
  - ખેલાડી બેમાંથી કોઈપણ એક સાપ પર ટેપ કરે છે, ત્યારે **બંને સાપ એકસાથે સમાંતર દિશામાં સરકવાનો પ્રયત્ન કરે છે**.
  - **સિંક્રનાઇઝ્ડ સેફ્ટી રુલ:** જો બેમાંથી કોઈપણ એક સાપનો પાથ બંધ હોય, તો બીજો સાપ પણ આગળ વધશે નહીં; બંને એકસાથે માથું બોંક કરીને મૂળ સ્થાને સ્થિર રહેશે (0 Hearts Lost).

---

### 2.4 M504: Relay Burrow / Relay Portal (ક્રોસ-બોર્ડ પોર્ટલ)
- **પ્રથમ પરિચય:** Level 5371 (Block 538, x1 slot).
- **કાર્યપદ્ધતિ:**
  - જમીનદોઝ પોર્ટલની જોડી જેમાં પ્રવેશદ્વાર બોર્ડ 1 પર અને નિકાસદ્વાર બોર્ડ 2 પર હોય છે.
  - સાપ બોર્ડ 1 ના પોર્ટલમાં પ્રવેશે છે અને તરત જ બોર્ડ 2 ના પોર્ટલમાંથી પોતાની મૂળ ગતિ અને દિશા સાથે બહાર આવે છે.
  - પોર્ટલ પાથ પર કોઈ સમય વિલંબ થતો નથી (Zero Wall-Clock Lag).

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Tap Input -> Active Snake Selection (Board 1 or Board 2)
Step 2: If Mirror Snake (M503) -> Identify Linked Partner on other board
Step 3: Dual Clearance Check (Verify paths on BOTH Board 1 and Board 2)
Step 4: Movement Execution:
        - If crossing M501 Bridge -> Initiate cross-grid continuous segment transfer
        - If entering M504 Portal -> Shift coordinates from Board 1 to Board 2
Step 5: Board Exit Detection:
        - If Messenger Snake (M502) exits -> Dispatch unlock signal to target lock on opposite board
Step 6: Board Settled on both grids -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Independent Grid Solvability:** સોલ્વર બંને બોર્ડને સમાંતર સ્ટેટ મશીન તરીકે ટ્રેક કરે છે.
2. **Buffer Space Guarantee:** જ્યારે સાપ બોર્ડ 1 થી બોર્ડ 2 માં પ્રવેશે, ત્યારે બોર્ડ 2 પર હંમેશા ઓછામાં ઓછી સાપની લંબાઈ જેટલી ખાલી જગ્યા ઉપલબ્ધ હોવાની બાંહેધરી રહે છે.
3. **Circular Bridge Deadlock Prevention:** બ્રિજ ક્યારેય અનંત લૂપ (Board 1 $\to$ Board 2 $\to$ Board 1) ન બનાવે તે માટે દિશાઓ એકમાર્ગી (Directed Acyclic Graph) રાખવામાં આવે છે.

