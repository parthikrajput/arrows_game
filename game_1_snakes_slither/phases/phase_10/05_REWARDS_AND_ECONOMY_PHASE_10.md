# Phase 10: Rewards and Economy (લેવલ 4501 થી 5000)

> આ દસ્તાવેજ **Phase 10 (Levels 4501–5000)** ની ઇકોનોમી, કોઈન રિવોર્ડ્સ, બૂસ્ટર ડ્રોપ્સ, મિલસ્ટોન ગિફ્ટ્સ અને 5000-લેવલ હાફવે ગ્રાન્ડ ચેસ્ટનું સંપૂર્ણ માળખું પ્રદાન કરે છે. આ નિયમો [SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) અને [SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md) સાથે સુસંગત છે.

---

## 1. કમાણીનું મૂળભૂત માળખું (Base Coin Rewards)

પ્રત્યેક લેવલ ક્લિયરન્સ પર ખેલાડીને લેવલના પ્રકાર મુજબ નિશ્ચિત સિક્કા મળે છે:

| લેવલ પ્રકાર (Level Type) | સ્લોટ / પેટર્ન | બેઝ કોઈન્સ (Base Coins) | ફર્સ્ટ-ટાઇમ 3-સ્ટાર બોનસ | કુલ મહત્તમ (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slot 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slot 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (દર બ્લોકનું x9 લેવલ) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (દર બ્લોકનું x0 લેવલ) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale & Halfway** | Level 5000 (અંતિમ લેવલ) | 50 Coins | +50 Coins | **100 Coins** |

> [!NOTE]
> રીપ્લે (Replay) કરવા પર બેઝ રિવોર્ડના માત્ર 20% કોઈન્સ મળે છે (દા.ત. Normal લેવલ પર 4 કોઈન્સ), અને કોઈ બૂસ્ટર કે વધારાનું બોનસ ફરીથી મળતું નથી.

---

## 2. 50 બ્લોક્સ લેવલ કમ્પ્લીશન અનુસૂચિ (Phase 10 Progression Schedule)

Phase 10 માં 50 બ્લોક્સ (Block 451 થી 500) આવેલા છે. પ્રત્યેક બ્લોકમાં 10 લેવલ્સનો સમાવેશ થાય છે:

```
Block 451: 4501–4510 (Signature Intro)
Block 452: 4511–4520 (M451 Intro + Gift Basket 1 @ 4510)
Block 453: 4521–4530 (Golden Slither Rush 1 @ 4525 + Gift Basket 2 @ 4520)
...
Block 475: 4741–4750 (Festival Grounds Finale + Rush 10 @ 4750 + Gift Basket 24 @ 4740)
...
Block 500: 4991–5000 (Grand Halfway Finale @ 5000 + Halfway Grand Chest + Halfway Badge)
```

### બ્લોક-વાઇઝ કોઈન કલેક્શન પ્રોજેક્શન (Average per 10 Levels)
- 10 લેવલ દીઠ સરેરાશ કમાણી (Normal First Clear ★★★):
  - 3 Easy ($3 \times 35 = 105$)
  - 5 Normal ($5 \times 40 = 200$)
  - 1 Hard ($1 \times 50 = 50$)
  - 1 Milestone ($1 \times 55 = 55$)
  - **કુલ સરેરાશ પ્રતિ બ્લોક: 410 Coins** (Gift Baskets સિવાય).
- 50 બ્લોક્સના 500 લેવલ્સમાંથી માત્ર લેવલ ક્લિયરન્સ વડે કુલ: **~20,500 Coins**.

---

## 3. મિલસ્ટોન ગિફ્ટ બાસ્કેટ્સ (Milestone Gift Baskets - Every x0 Level)

દરેક બ્લોકના અંતે (લેવલ 4510, 4520, 4530 ... 4990) ખેલાડીને **Gift Basket** એનાયત કરવામાં આવે છે:

### Gift Basket સંરચના:
- **Coins:** 300 Coins ફિક્સ્ડ.
- **Booster:** 1 ફ્રી પાવર-અપ બૂસ્ટર, જે નીચે મુજબના ચક્ર (Cycle) માં ફરે છે:
  1. **Hint Booster** (દા.ત. 4510, 4540, 4570, ...)
  2. **Shield Booster** (દા.ત. 4520, 4550, 4580, ...)
  3. **Hammer Booster** (દા.ત. 4530, 4560, 4590, ...)
- **કુલ ગિફ્ટ બાસ્કેટ્સ:** 49 બાસ્કેટ્સ (લેવલ 4510 થી 4990).
- **કુલ ગિફ્ટ બાસ્કેટ કમાણી:** $49 \times 300 = 14,700 \text{ Coins}$, ઉપરાંત 49 પ્રીમિયમ બૂસ્ટર્સ.

---

## 4. ગોલ્ડન સ્લિધર રશ (Golden Slither Rush - Every 25 Levels)

Phase 10 માં દર 25 લેવલે ગોલ્ડન સ્લિધર રશ બોનસ ઇવેન્ટ ટ્રિગર થાય છે (લેવલ 4525, 4550, 4575 ... 5000):

| પેરામીટર | વિગત |
| :--- | :--- |
| **આવૃત્તિ (Frequency)** | દર 25 લેવલે (કુલ 20 ઇવેન્ટ્સ) |
| **સમય મર્યાદા (Time Limit)** | 30 સેકન્ડ્સ કાઉન્ટડાઉન |
| **ધ્યેય (Objective)** | 30 ગોલ્ડન સાપોને બહાર કાઢવા (Tap & Untangle) |
| **પુરસ્કાર (Reward)** | દરેક સાપ દીઠ 5 કોઈન્સ; તમામ 30 સાપ મુક્ત કરવા પર 150 કોઈન્સ + **100 Coins Perfect Clear Bonus** (કુલ 250 Coins) |
| **મહત્તમ ઉપલબ્ધ ઇકોનોમી** | $20 \times 250 = \mathbf{5,000\text{ Coins}}$ |

---

## 5. ગ્રાન્ડ હાફવે માઇલસ્ટોન ચેસ્ટ (Grand Halfway Milestone Chest - Level 5000)

ગેમના 5,000 લેવલ્સ (50% Milestone) પૂર્ણ કરવા પર ખેલાડીને એક વિશેષ ગ્રાન્ડ ચેસ્ટ પ્રાપ્ત થાય છે:

- **કોઈન્સ:** **2,000 Coins** (વિશેષ હાફવે બોનસ).
- **બૂસ્ટર બંડલ:**
  - 3x Hint Boosters
  - 3x Shield Boosters
  - 3x Hammer Boosters
- **એક્સક્લૂઝિવ અચીવમેન્ટ & બૅજ:**
  - **"Halfway Grandmaster" (5,000 Levels Sovereign)** ગોલ્ડન પ્રોફાઇલ બૅજ.
  - **Tribal Drummer Skin / Trail:** ડ્રમ બીટ્સ અને ગોલ્ડન મ્યુઝિકલ નોટ્સ સાથેની એક્સક્લૂઝિવ સ્કીન.
  - Phase 11 (Two Ponds: Linked Boards) નું તાત્કાલિક અનલૉકિંગ.

---

## 6. ઇકોનોમી સિંક અને સ્ટોર બેલેન્સ (Economy Sinks & Balance)

| આઇટમ / સુવિધા | કોઈન કિંમત | હેતુ |
| :--- | :---: | :--- |
| **Extra Moves (+5 Moves)** | 100 Coins | ડ્રમ ગેટના રિધમ સાઇકલને પોતાની અનુકૂળતા મુજબ એડજસ્ટ કરવા |
| **Hint Booster** | 150 Coins | તોતેમ પેટર્ન માટે કયો સાપ આગામી કલર આપશે તેનું માર્ગદર્શન |
| **Shield Booster** | 200 Coins | પરેડ ગેટ પર ખોટો સાપ ટેપ થવાના અકસ્માત સામે રક્ષણ |
| **Hammer Booster** | 250 Coins | સિક્વન્સમાં અડચણરૂપ પથ્થર કે ખોટા સાપને બોર્ડ પરથી હટાવવા |
| **Rhythm Skip Token** | 120 Coins | ડ્રમ ગેટને તાત્કાલિક આગામી ઓપન સ્ટેટ પર લઈ જવા |

### કુલ ઇકોનોમી સરવૈયું (Total Coin Inflow in Phase 10):
- લેવલ કમ્પ્લીશન (4501–5000): ~20,500 Coins
- 49 Gift Baskets: 14,700 Coins
- 20 Golden Slither Rush: 5,000 Coins
- Halfway Grand Chest: 2,000 Coins
- **સંપૂર્ણ Phase 10 ની સંભવિત ફ્રી કમાણી: ~42,200 Coins**

