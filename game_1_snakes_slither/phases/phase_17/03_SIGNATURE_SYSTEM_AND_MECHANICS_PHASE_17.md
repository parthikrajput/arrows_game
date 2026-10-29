# Phase 17: Signature System and Mechanics (લેવલ 8001 થી 8500)

> આ દસ્તાવેજ **Phase 17 (Mongoose Clan)** ના સિગ્નેચર સિસ્ટમ (Guardians) અને 4 નવા બેઝ મિકેનિક્સ (**M801, M802, M803, M804**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 17 Index](./README.md) · [Scope & Rules](./01_PHASE_17_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: મોંગુઝ ક્લેન (Mongoose Clan: Guardians)

Mongoose Clan એ સામાન્ય તાળા-ચાવીથી આગળ વધીને સાપો અને નોળિયાઓ વચ્ચેના સંઘર્ષની બોસ-પઝલ સિસ્ટમ છે. નોળિયાઓ બોર્ડના મહત્વપૂર્ણ ચોક પર ઊભા રહીને રસ્તો રોકે છે અને સાપો બહાર નીકળતાં તેમની લાઈફ (HP) ઘટે છે.

```
       [SNAKE EXITS BOARD] ===> DEALS 1 DAMAGE TO LINKED GUARDIAN
                                              |
       +--------------------------------------+--------------------------------------+
       |                                      |                                      |
       V                                      V                                      V
[M801 TWIN MONGOOSE]                  [M802 SHIELD GUARDIAN]                [M803 MAMA MONGOOSE]
(Share 1 combined HP pool)            (Invulnerable if Lever ON)            (Spawns rock every N moves, cap 3)
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M801: Mongoose Twins / Twin Guardian (જોડિયા નોળિયા)
- **પ્રથમ પરિચય:** Level 8011 (Block 802, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ પર બે અલગ ટાઇલ્સ પર બે જોડિયા નોળિયાઓ રક્ષણ આપે છે.
  - બંને એક જ સંયુક્ત આયુષ્ય (દા.ત. કુલ 6 HP) ધરાવે છે.
  - કોઈપણ લિંક્ડ સાપ બોર્ડમાંથી બહાર નીકળે ત્યારે સંયુક્ત પૂલમાંથી 1 HP ઘટે છે.
  - જ્યારે HP ઘટીને 0 થાય છે, ત્યારે **બંને નોળિયાઓ એકસાથે બોર્ડ પરથી ભાગી જાય છે** અને બંને ટાઇલ્સ એકસાથે ખુલ્લા રસ્તા બની જાય છે.

---

### 2.2 M802: Armadillo Guardian / Shield Guardian (શીલ્ડ ગાર્ડિયન)
- **પ્રથમ પરિચય:** Level 8131 (Block 814, x1 slot).
- **કાર્યપદ્ધતિ:**
  - ભારે ઢાલ ધરાવતો મજબૂત નોળિયો.
  - જ્યાં સુધી તેની સાથે જોડાયેલું "Shield Lever" ચાલુ (ON) હોય, ત્યાં સુધી તેના પર કોઈ હુમલો કે ડેમેજ કામ કરતું નથી.
  - ખેલાડીએ લિવર પર ટેપ કરીને ઢાલ બંધ કરવી પડે છે (`Move += 1`).
  - ઢાલ બંધ થયા પછી જ બહાર નીકળતા સાપો તેને ડેમેજ આપી શકે છે.

---

### 2.3 M803: Mama Mongoose / Spawner Guardian (મામા મોંગુઝ)
- **પ્રથમ પરિચય:** Level 8251 (Block 826, x1 slot).
- **કાર્યપદ્ધતિ:**
  - એક માતૃ નોળિયો જે પોતાના બચ્ચાઓના રક્ષણ માટે દર $N$ મૂવ્સે (દા.ત. દર 4 મૂવ્સે) પોતાની નજીકના ખાલી સેલ પર એક પથ્થર (Garden Rock) પેદા કરે છે.
  - **કડક લિમિટ (Spawn Cap):** બોર્ડ પર એકસાથે વધુમાં વધુ **3 પથ્થરો** જ પેદા થઈ શકે છે. જો 3 પથ્થરો પહેલેથી હાજર હોય, તો જ્યાં સુધી કોઈ પથ્થર હટાવવામાં ન આવે ત્યાં સુધી નવો પથ્થર બનતો નથી.
  - આ નિયમ ડેડલોક થતાં અટકાવે છે.

---

### 2.4 M804: Mongoose Den Core / Guardian Core (ડેન કોર)
- **પ્રથમ પરિચય:** Level 8371 (Block 838, x1 slot).
- **કાર્યપદ્ધતિ:**
  - નોળિયાઓના ગુપ્ત અડ્ડાનું મુખ્ય કેન્દ્ર.
  - તેના પર ચોક્કસ દિશા (દા.ત. માત્ર ઉત્તરીય અથવા માત્ર પૂર્વીય એક્ઝિટ) અંકિત હોય છે.
  - માત્ર તે નિયુક્ત દિશાની કિનારી પરથી બહાર નીકળતા સાપો જ આ કોરનું HP ઘટાડી શકે છે; અન્ય દિશામાંથી નીકળતા સાપો કોઈ નુકસાન પહોંચાડી શકતા નથી.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Action Input -> Tap Snake OR Tap M802 Shield Lever
Step 2: Move Counter Increments (Move += 1)
Step 3: If Shield Lever Tapped -> Toggle isShielded state
Step 4: If Snake Tapped -> Move snake off board:
        - If target Guardian is unshielded:
            - If M804 Core -> Verify exit side matches required lane
            - Deduct 1 HP from target guardian (or M801 shared pool)
Step 5: Check Defeat State:
        - If Guardian HP <= 0 -> Trigger retreat animation & clear cell
Step 6: Spawner Guardian Step:
        - If Move % SpawnInterval == 0 && activeSpawnCount < 3:
            Spawn Garden Rock in adjacent free cell -> activeSpawnCount += 1
Step 7: Board Settled -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Strict Rock Spawning Cap:** મહત્તમ 3 પથ્થરોની કડક મર્યાદા સુનિશ્ચિત કરે છે કે બોર્ડ ક્યારેય ગૂંગળાઈને અનસોલ્વેબલ ન બને.
2. **Deterministic Guardian Defeat:** સાપોની કુલ સંખ્યા હંમેશા ગાર્ડિયન્સના કુલ HP કરતાં વધુ અથવા સમાન રાખવામાં આવે છે.
3. **Zero Damage Collision:** ગાર્ડિયન સાથે અથડાતાં સાપ માત્ર માથું બોંક કરીને પાછો આવે છે; 0 હાર્ટ લોસ.

