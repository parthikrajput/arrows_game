# Phase 8: Rewards and Economy (લેવલ 3501 થી 4000)

આ દસ્તાવેજ **Phase 8 (Levels 3501–4000)** ની સંપૂર્ણ ઇકોનોમી ડિઝાઇન, કોઈન રિવોર્ડ્સ, બૂસ્ટર ડ્રોપ્સ, મિલસ્ટોન ગિફ્ટ્સ અને ગોલ્ડન સ્લિધર રશ ઇવેન્ટ્સનું વિસ્તૃત માળખું પ્રદાન કરે છે. આ નિયમો [SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) અને [SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md) ના સ્ટાન્ડર્ડ સાથે સુસંગત છે.

---

## 1. કમાણીનું મૂળભૂત માળખું (Base Coin Rewards)

પ્રત્યેક લેવલ ક્લિયરન્સ પર ખેલાડીને લેવલના પ્રકાર (Difficulty Tier) મુજબ નિશ્ચિત સિક્કા પ્રાપ્ત થાય છે:

| લેવલ પ્રકાર (Level Type) | પેટર્ન / સ્લોટ | બેઝ કોઈન્સ (Base Coins) | ફર્સ્ટ-ટાઇમ 3-સ્ટાર બોનસ | કુલ મહત્તમ (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slot 1, 2, 4 (સામાન્ય રીતે) | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slot 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (દર બ્લોકનું x9 લેવલ) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (દર બ્લોકનું x0 લેવલ) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale** | Level 4000 (અંતિમ લેવલ) | 50 Coins | +50 Coins | **100 Coins** |

> [!NOTE]
> રીપ્લે (Replay) કરવા પર ખેલાડીને માત્ર બેઝ રિવોર્ડના 20% કોઈન્સ મળે છે (દા.ત. Normal લેવલ પર 4 કોઈન્સ) અને કોઈ બૂસ્ટર કે ફર્સ્ટ-ટાઇમ સ્ટાર બોનસ ફરીથી મળતું નથી.

---

## 2. 50 બ્લોક્સ લેવલ કમ્પ્લીશન અનુસૂચિ (Phase 8 Progression Schedule)

Phase 8 માં 50 બ્લોક્સ (Block 351 થી 400) આવેલા છે. પ્રત્યેક બ્લોકમાં 10 લેવલ્સનો સમાવેશ થાય છે:

```
Block 351: 3501–3510 (Gift Basket 1 @ 3510)
Block 352: 3511–3520 (Gift Basket 2 @ 3520)
Block 353: 3521–3530 (Golden Slither Rush 1 @ 3525 + Gift Basket 3 @ 3530)
...
Block 375: 3741–3750 (Briar Thicket Finale + Golden Slither Rush 10 @ 3750 + Gift Basket 25 @ 3750)
...
Block 400: 3991–4000 (Grand Finale @ 4000 + Finale Chest + Phase 8 Badge)
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

દરેક બ્લોકના અંતે (લેવલ 3510, 3520, 3530 ... 3990) ખેલાડીને **Gift Basket** એનાયત કરવામાં આવે છે.

### Gift Basket સંરચના:
- **Coins:** 300 Coins ફિક્સ્ડ.
- **Booster:** 1 ફ્રી પાવર-અપ બૂસ્ટર, જે નીચે મુજબના ચક્ર (Cycle) માં ફરે છે:
  1. **Hint Booster** (દા.ત. 3510, 3540, 3570, ...)
  2. **Shield Booster** (દા.ત. 3520, 3550, 3580, ...)
  3. **Hammer Booster** (દા.ત. 3530, 3560, 3590, ...)
- **કુલ ગિફ્ટ બાસ્કેટ્સ:** 49 બાસ્કેટ્સ (લેવલ 3510 થી 3990).
- **કુલ ગિફ્ટ બાસ્કેટ કમાણી:** $49 \times 300 = 14,700 \text{ Coins}$, ઉપરાંત 49 પ્રીમિયમ બૂસ્ટર્સ.

---

## 4. ગોલ્ડન સ્લિધર રશ (Golden Slither Rush - Every 25 Levels)

Phase 8 માં પ્રત્યેક 25 લેવલ પર એક સ્પેશિયલ બોનસ ઇવેન્ટ ટ્રિગર થાય છે (લેવલ 3525, 3550, 3575 ... 4000):

| પેરામીટર | વિગત |
| :--- | :--- |
| **આવૃત્તિ (Frequency)** | દર 25 લેવલે (કુલ 20 ઇવેન્ટ્સ) |
| **સમય મર્યાદા (Time Limit)** | 30 સેકન્ડ્સ કાઉન્ટડાઉન |
| **ધ્યેય (Objective)** | 30 ગોલ્ડન સાપોને બહાર કાઢવા (Tap & Untangle) |
| **પુરસ્કાર (Reward)** | દરેક સફળ સાપ દીઠ 5 કોઈન્સ; તમામ 30 સાપ મુક્ત કરવા પર 150 કોઈન્સ + **100 Coins Perfect Clear Bonus** (કુલ 250 Coins) |
| **મહત્તમ ઉપલબ્ધ ઇકોનોમી** | $20 \times 250 = \mathbf{5,000\text{ Coins}}$ |

---

## 5. ગ્રાન્ડ ફિનાલે ચેસ્ટ (Grand Finale Chest - Level 4000)

લેવલ 4000 સફળતાપૂર્વક પૂર્ણ કરવા પર અનલૉક થતી સ્પેશિયલ ચેસ્ટ:

- **કોઈન્સ:** **1,000 Coins**
- **બૂસ્ટર બંડલ:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **એક્સક્લૂઝિવ અચીવમેન્ટ & બૅજ:**
  - **"Overgrown Master" (Garden Sovereign)** કાયમી પ્રોફાઇલ બૅજ.
  - **Flora King Skin / Trail:** સાપ માટે વિશિષ્ટ બ્લોસમ પેટલ ટ્રેઇલ (Cosmetic).
  - Phase 9 (Crystal Caverns) નું તાત્કાલિક અનલૉકિંગ.

---

## 6. ઇકોનોમી સિંક અને સ્ટોર બેલેન્સ (Economy Sinks & Balance)

Phase 8 ના ઉચ્ચ મુશ્કેલી સ્તર (Plateau D: Difficulty 60–76) ને કારણે ખેલાડીઓ માટે ઇન-ગેમ કોઈન્સ વાપરવા માટેના નિયુક્ત ખર્ચ (Sinks):

| આઇટમ / સુવિધા | કોઈન કિંમત | હેતુ |
| :--- | :---: | :--- |
| **Extra Moves (+5 Moves)** | 100 Coins | જ્યારે વેલાઓ ફેલાઈને બોર્ડ જામ કરી દે ત્યારે ત્વરિત સહાય |
| **Hint Booster** | 150 Coins | M354 Bloom Gate ખોલવા માટેના યોગ્ય પાથનું માર્ગદર્શન |
| **Shield Booster** | 200 Coins | એક અથડામણ (Collision) અથવા કાંટાળા વેલાના ડંખ સામે રક્ષણ |
| **Hammer Booster** | 250 Coins | ગમે તે એક અવરોધક વેલો (Wild Vine) અથવા બ્લોકિંગ સાપને સીધો બોર્ડ પરથી હટાવવા |
| **Shears Refresh Tile** | 120 Coins | વપરાયેલી કાતર ટાઇલને ફરીથી સક્રિય (Recharge) કરવા |

### કુલ ઇકોનોમી સરવૈયું (Total Coin Inflow in Phase 8):
- લેવલ કમ્પ્લીશન (3501–4000): ~20,500 Coins
- 49 Gift Baskets: 14,700 Coins
- 20 Golden Slither Rush: 5,000 Coins
- Finale Chest: 1,000 Coins
- **સંપૂર્ણ Phase 8 ની સંભવિત ફ્રી કમાણી: ~41,200 Coins**
- આ ઇકોનોમી ખેલાડીને મુશ્કેલ સ્તરો પર બૂસ્ટર્સ ખરીદવા અને નવી કોસ્મેટિક સ્કિન્સ અનલૉક કરવા માટે સંપૂર્ણ સંતુલન પૂરું પાડે છે.
