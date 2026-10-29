# Phase 16: Rewards and Economy (લેવલ 7501 થી 8000)

> આ દસ્તાવેજ **Phase 16 (Levels 7501–8000)** ની ઇકોનોમી, કોઈન રિવોર્ડ્સ, બૂસ્ટર ડ્રોપ્સ, મિલસ્ટોન ગિફ્ટ્સ અને ગોલ્ડન સ્લિધર રશ ઇવેન્ટ્સનું સંપૂર્ણ માળખું પ્રદાન કરે છે. આ નિયમો [SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) અને [SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md) સાથે સુસંગત છે.

---

## 1. કમાણીનું મૂળભૂત માળખું (Base Coin Rewards)

પ્રત્યેક લેવલ ક્લિયરન્સ પર ખેલાડીને લેવલના પ્રકાર મુજબ નિશ્ચિત સિક્કા મળે છે:

| લેવલ પ્રકાર (Level Type) | સ્લોટ / પેટર્ન | બેઝ કોઈન્સ (Base Coins) | ફર્સ્ટ-ટાઇમ 3-સ્ટાર બોનસ | કુલ મહત્તમ (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slot 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slot 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (દર બ્લોકનું x9 લેવલ) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (દર બ્લોકનું x0 લેવલ) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale** | Level 8000 (અંતિમ લેવલ) | 50 Coins | +50 Coins | **100 Coins** |

> [!NOTE]
> રીપ્લે (Replay) કરવા પર બેઝ રિવોર્ડના માત્ર 20% કોઈન્સ મળે છે (દા.ત. Normal લેવલ પર 4 કોઈન્સ), અને કોઈ બૂસ્ટર કે વધારાનું બોનસ ફરીથી મળતું નથી.

---

## 2. 50 બ્લોક્સ લેવલ કમ્પ્લીશન અનુસૂચિ (Phase 16 Progression Schedule)

Phase 16 માં 50 બ્લોક્સ (Block 751 થી 800) આવેલા છે. પ્રત્યેક બ્લોકમાં 10 લેવલ્સનો સમાવેશ થાય છે:

```
Block 751: 7501–7510 (Signature Intro)
Block 752: 7511–7520 (M751 Intro + Gift Basket 1 @ 7510)
Block 753: 7521–7530 (Golden Slither Rush 1 @ 7525 + Gift Basket 2 @ 7520)
...
Block 775: 7741–7750 (Gilded Grove Finale + Rush 10 @ 7750 + Gift Basket 24 @ 7740)
...
Block 800: 7991–8000 (Grand Finale @ 8000 + Finale Chest + Phase 16 Badge)
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

દરેક બ્લોકના અંતે (લેવલ 7510, 7520, 7530 ... 7990) ખેલાડીને **Gift Basket** એનાયત કરવામાં આવે છે:

### Gift Basket સંરચના:
- **Coins:** 300 Coins ફિક્સ્ડ.
- **Booster:** 1 ફ્રી પાવર-અપ બૂસ્ટર, જે નીચે મુજબના ચક્ર (Cycle) માં ફરે છે:
  1. **Hint Booster** (દા.ત. 7510, 7540, 7570, ...)
  2. **Shield Booster** (દા.ત. 7520, 7550, 7580, ...)
  3. **Hammer Booster** (દા.ત. 7530, 7560, 7590, ...)
- **કુલ ગિફ્ટ બાસ્કેટ્સ:** 49 બાસ્કેટ્સ (લેવલ 7510 થી 7990).
- **કુલ ગિફ્ટ બાસ્કેટ કમાણી:** $49 \times 300 = 14,700 \text{ Coins}$, ઉપરાંત 49 પ્રીમિયમ બૂસ્ટર્સ.

---

## 4. ગોલ્ડન સ્લિધર રશ (Golden Slither Rush - Every 25 Levels)

Phase 16 માં દર 25 લેવલે ગોલ્ડન સ્લિધર રશ બોનસ ઇવેન્ટ ટ્રિગર થાય છે (લેવલ 7525, 7550, 7575 ... 8000):

| પેરામીટર | વિગત |
| :--- | :--- |
| **આવૃત્તિ (Frequency)** | દર 25 લેવલે (કુલ 20 ઇવેન્ટ્સ) |
| **સમય મર્યાદા (Time Limit)** | 30 સેકન્ડ્સ કાઉન્ટડાઉન |
| **ધ્યેય (Objective)** | 30 ગોલ્ડન સાપોને મુક્ત કરવા (Tap & Untangle) |
| **પુરસ્કાર (Reward)** | દરેક સાપ દીઠ 5 કોઈન્સ; તમામ 30 સાપ મુક્ત કરવા પર 150 કોઈન્સ + **100 Coins Perfect Clear Bonus** (કુલ 250 Coins) |
| **મહત્તમ ઉપલબ્ધ ઇકોનોમી** | $20 \times 250 = \mathbf{5,000\text{ Coins}}$ |

---

## 5. ગ્રાન્ડ ફિનાલે ચેસ્ટ (Grand Finale Chest - Level 8000)

લેવલ 8000 પૂર્ણ કરવા પર અનલૉક થતી ગ્રાન્ડ ચેસ્ટ:

- **કોઈન્સ:** **1,000 Coins**
- **બૂસ્ટર બંડલ:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **એક્સક્લૂઝિવ અચીવમેન્ટ & બૅજ:**
  - **"Master of Keys" (Vault Sovereign)** કાયમી પ્રોફાઇલ બૅજ.
  - **Golden Key Crest Skin / Trail:** સાપ સરકતાં પાછળ સુવર્ણ ચાવીઓ છોડતી લક્ઝરી સ્કીન.
  - Phase 17 (Mongoose Clan: Guardians) નું તાત્કાલિક અનલૉકિંગ.

---

## 6. ઇકોનોમી સિંક અને સ્ટોર બેલેન્સ (Economy Sinks & Balance)

| આઇટમ / સુવિધા | કોઈન કિંમત | હેતુ |
| :--- | :---: | :--- |
| **Extra Moves (+5 Moves)** | 100 Coins | ચાવી સ્વેપ કરવામાં મૂવ્સ વપરાઈ ગયા હોય ત્યારે વધારાના મૂવ્સ |
| **Hint Booster** | 150 Coins | કઈ અર્ધ-ચાવી પ્રથમ બહાર કાઢવી તેનું સચોટ માર્ગદર્શન |
| **Shield Booster** | 200 Coins | ચાવી વગર તાળા સાથે અથડાવાના અકસ્માત સામે રક્ષણ |
| **Hammer Booster** | 250 Coins | કોઈપણ જટિલ તાળાને ચાવી વગર સીધું તોડી નાખવા |
| **Master Lockpick** | 120 Coins | કોઈપણ 1 સામાન્ય તાળાને તાત્કાલિક બાયપાસ કરવા |

### કુલ ઇકોનોમી સરવૈયું (Total Coin Inflow in Phase 16):
- લેવલ કમ્પ્લીશન (7501–8000): ~20,500 Coins
- 49 Gift Baskets: 14,700 Coins
- 20 Golden Slither Rush: 5,000 Coins
- Finale Chest: 1,000 Coins
- **સંપૂર્ણ Phase 16 ની સંભવિત ફ્રી કમાણી: ~41,200 Coins**

