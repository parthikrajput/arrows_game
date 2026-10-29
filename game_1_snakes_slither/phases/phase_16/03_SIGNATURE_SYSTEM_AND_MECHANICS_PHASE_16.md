# Phase 16: Signature System and Mechanics (લેવલ 7501 થી 8000)

> આ દસ્તાવેજ **Phase 16 (Treasure Keys)** ના સિગ્નેચર સિસ્ટમ (Keys Deluxe) અને 4 નવા બેઝ મિકેનિક્સ (**M751, M752, M753, M754**) ના વિગતવાર ગણિત, નિયમો, ટિક ઓર્ડર અને એજ કેસ નિર્ધારિત કરે છે.

**Related docs:** [Phase 16 Index](./README.md) · [Scope & Rules](./01_PHASE_16_SCOPE_AND_RULES.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. સિગ્નેચર સિસ્ટમ: ટ્રેઝર કીઝ (Treasure Keys: Keys Deluxe)

Treasure Keys એ પઝલ રમતમાં ચાવી અને તાળાના પરંપરાગત સંબંધને અત્યંત રસપ્રદ બનાવતી મેટાગેમ સિસ્ટમ છે. સાપો માત્ર તાળા ખોલતા નથી, પરંતુ અધૂરી ચાવીઓ ભેગી કરીને ક્રાફ્ટ કરે છે, શૃંખલાબદ્ધ તાળાઓ ખોલે છે અને ચાવીઓની આપ-લે કરે છે.

```
       [SNAKE WITH HALF-KEY A] ---> \
                                     [KEY CRAFTING] ===> [COMPLETED MASTER KEY]
       [SNAKE WITH HALF-KEY B] ---> /                          |
                                                               V
       [LOCK 1 OPENS] ===(M751 Golden Vine)===> [RELEASES KEY 2 ON BOARD]
```

---

## 2. 4 નવા બેઝ મિકેનિક્સ (The 4 Base Mechanics)

### 2.1 M751: Key Vine / Key Chain (શૃંખલાબદ્ધ ચાવી વેલ)
- **પ્રથમ પરિચય:** Level 7511 (Block 752, x1 slot).
- **કાર્યપદ્ધતિ:**
  - એક સોનેરી વેલા દ્વારા જોડાયેલી તાળા-ચાવીની જોડી.
  - જ્યારે તાળું 1 સફળતાપૂર્વક ખુલે છે:
    1. સોનેરી વેલો ઓગળી જાય છે.
    2. વેલાના બીજા છેડે બંધાયેલી નવી ચાવી (Key 2) મુક્ત થઈને તેના નિયુક્ત સાપ અથવા ટાઇલ પર સક્રિય બને છે.
  - આ મિકેનિક પઝલમાં કડક ક્રમિક પ્રગતિ (Sequence Order: Lock 1 $\to$ Key 2 $\to$ Lock 2) લાગુ કરે છે.

---

### 2.2 M752: Key Bundle / Key Crafting (અર્ધ-ચાવી ક્રાફ્ટિંગ)
- **પ્રથમ પરિચય:** Level 7631 (Block 764, x1 slot).
- **કાર્યપદ્ધતિ:**
  - બોર્ડ પર બે અલગ સાપો અધૂરી ચાવીઓ વહન કરે છે: સાપ A પાસે ડાબો ભાગ (Half-Key A) અને સાપ B પાસે જમણો ભાગ (Half-Key B).
  - જ્યાં સુધી બંને સાપ બોર્ડમાંથી સંપૂર્ણ બહાર ન નીકળે ત્યાં સુધી ચાવી અધૂરી રહે છે.
  - બંને ભાગ બહાર આવતાં જ UI માં ક્રાફ્ટિંગ એનિમેશન દ્વારા સંપૂર્ણ ગોલ્ડન કી તૈયાર થાય છે અને તે લક્ષિત દરવાજાને અનલૉક કરે છે.

---

### 2.3 M753: Golden Master Leaf / Skeleton Key (સ્કેલેટન કી)
- **પ્રથમ પરિચય:** Level 7751 (Block 776, x1 slot).
- **કાર્યપદ્ધતિ:**
  - ચમકતી સોનેરી પાંદડીનું પ્રતીક ધરાવતી સાર્વત્રિક ચાવી (Universal Key).
  - જે સાપ પાસે આ સ્કેલેટન કી હોય છે, તે કોઈપણ રંગ કે પ્રકારના તાળાની ચિંતા કર્યા વિના રસ્તામાં આવતા **સૌપ્રથમ બંધ તાળાને તાત્કાલિક ખોલી નાખે છે**.
  - એક સ્કેલેટન કી માત્ર એક જ તાળું ખોલી શકે છે (Single Use).

---

### 2.4 M754: Key Swap Stone / Key Swap (ચાવી સ્વેપ પેડેસ્ટલ)
- **પ્રથમ પરિચય:** Level 7871 (Block 788, x1 slot).
- **કાર્યપદ્ધતિ:**
  - જમીન પર આવેલું પ્રાચીન સ્વેપ પેડેસ્ટલ.
  - જ્યારે બે સાપ આ સ્ટોનની અડીને આવેલા સેલ પર આવીને ઊભા રહે છે, ત્યારે ખેલાડી સ્ટોન પર ટેપ કરી શકે છે:
    1. બંને સાપો પોતાની પીઠ પરની ચાવીઓ અથવા અર્ધ-ચાવીઓની પરસ્પર અદલાબદલી કરે છે.
    2. ખેલાડીનો 1 મૂવ વપરાય છે (`Move += 1`).
  - આ મિકેનિક ખોટી લેનમાં ફસાયેલી ચાવીને સાચી લેનવાળા સાપને સોંપવા માટે અત્યંત ઉપયોગી છે.

---

## 3. એન્જિન ટિક ઓર્ડર (Engine Tick Sequence §16.17)

પ્રત્યેક મૂવ દરમિયાન નીચે મુજબના ક્રમમાં સ્ટેટ્સ અપડેટ થાય છે:

```
Step 1: Player Action Input -> Tap Snake OR Tap M754 Swap Stone
Step 2: If M754 Tapped -> Swap key tokens between adjacent snakes (Move += 1)
Step 3: If Snake Tapped -> Execute standard slither out animation (Move += 1)
Step 4: Board Exit Detection:
        - If Snake carries Half-Key A -> Update KeyCraftingManager.hasHalfKeyA = true
        - If Snake carries Half-Key B -> Update KeyCraftingManager.hasHalfKeyB = true
        - If Snake carries Skeleton Key -> Add to availableSkeletonKeys
Step 5: Crafting & Chain Evaluation:
        - If HalfKeyA && HalfKeyB -> Trigger Key Crafting -> Unlock linked gate
        - If M751 Lock opened -> Release linked Key 2 on board
Step 6: Gate State Propagation & Settle -> Next Turn Ready.
```

---

## 4. એલ્ગોરિધમિક સોલ્વેબિલિટી ગેરંટી (Solver Rules)

1. **Acyclic Key Graph:** જનરેટર ખાતરી કરે છે કે ચાવીઓની ડિપેન્ડન્સી હંમેશા DAG (Directed Acyclic Graph) હોય, જેથી કોઈ સર્ક્યુલર લોક-ઇન ન બને.
2. **Half-Key Availability:** ક્રાફ્ટિંગ માટે જરૂરી બંને અર્ધ-ચાવી સાપો બોર્ડ પર સમાન સમયે સોલ્વેબલ પાથ ધરાવતા હોય.
3. **Skeleton Key Fairness:** સ્કેલેટન કી ક્યારેય એવા તાળાને ન તોડે જેનાથી પાછળનું લેવલ અનસોલ્વેબલ થઈ જાય.

