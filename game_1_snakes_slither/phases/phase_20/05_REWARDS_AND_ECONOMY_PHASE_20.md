# Phase 20 — Rewards, Currencies and Phase Economy Specification
**Phase:** 20 (Levels 9501–10,000)  
**System:** Grand Jungle Master & Level 10,000 Grand Finale  
**Related Documents:** [02_LEVEL_PLAN_9501_10000.md](02_LEVEL_PLAN_9501_10000.md), [../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md), [../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Economy Architecture & Philosophy

Phase 20 એ *Snakes Slither* ના 10,000 લેવલ્સના લાંબા પ્રવાસનો આર્થિક અને સિદ્ધિપૂર્ણ મુકામ છે. અહીં ખેલાડી માટે અગાઉના તમામ પ્રયત્નોનો સૌથી ભવ્ય બદલો (grandest payout) આપવામાં આવે છે, જે post-10,000 Endless Mastery Mode માટે ખેલાડીને સંપૂર્ણ સક્ષમ બનાવે છે.

---

## 2. Base Level Clear Rewards

Standard economy rules per `SHARED_CORE_STANDARD.md`:

| Level Classification | Base Coins Earned | First-Clear ★★★ Bonus | Total Possible First-Clear |
| :--- | :--- | :--- | :--- |
| **Easy Levels** | 15 coins | +20 coins | 35 coins |
| **Normal Levels** | 20 coins | +20 coins | 40 coins |
| **Hard Levels** | 30 coins | +20 coins | 50 coins |
| **Milestone Levels (x0)** | 35 coins | +20 coins | 55 coins |
| **Grand Finale (L10000)** | 100 coins | +20 coins | 120 coins |

*Repeat Level Clears:* Base coins નો 20% (rounded down); no star bonus.

---

## 3. Milestone Gift Baskets (49 Baskets at x0 Levels)

Levels 9510, 9520, 9530 ... 9990 (કુલ 49 milestone levels) પર player ને instant Gift Basket reward આપવામાં આવે છે:

- **Coin Grant:** 300 Coins per basket.
- **Booster Grant:** 1 Free Booster per basket, strictly cycling:
  $$\text{Basket Reward} = (\text{Level} / 10) \pmod 3 \implies \begin{cases} 1 \implies \text{Hint Booster} \\ 2 \implies \text{Shield Booster} \\ 0 \implies \text{Hammer Booster} \end{cases}$$
- **Total Milestone Basket Yields:**
  - Total Coins: $49 \times 300 = 14,700\text{ Coins}$.
  - Total Boosters: 17 Hints, 16 Shields, 16 Hammers.

---

## 4. Golden Slither Rush Events (20 Events)

દર 25 levels એ Golden Slither Rush trigger થાય છે (L9525, L9550, L9575 ... L10000):

- **Event Mechanics:** 25-turn high-speed coin collecting run.
- **Earning Potential:** Up to 250 bonus coins per event.
- **Total Potential Event Earnings:** $20 \times 250 = 5,000\text{ Coins}$.

---

## 5. Level 10,000 Grand Finale Chest (The Sovereign Summit)

Level 10,000 ("Jungle Kingdom Crown") સફળતાપૂર્વક પૂર્ણ થતાં રમતના ઇતિહાસનો સૌથી મોટો પુરસ્કાર ખુલે છે:

- **5,000 Gold Coins** (Instant lump sum)
- **5 Free Hint Boosters**
- **5 Free Shield Boosters**
- **5 Free Hammer Boosters** (Total 15 high-tier boosters)
- **Exclusive Sovereign Cosmetic Skin:** *"Mythic Sovereign Golden Serpent"* (Glowing gold scales with radiant crown particle trail).
- **Profile Title & Badge:** *"Grand Jungle Sovereign"* (Diamond-embossed Crown Crest).
- **Master Hall Access:** Permanent unlock of **Endless Mastery Mode** અને **Global Crown Leaderboard**.

---

## 6. Phase 20 Financial Ledger

| Income Category | Quantity | Coins Value | Boosters Awarded |
| :--- | :--- | :--- | :--- |
| **Level Base Rewards (Average 24 coins)** | 500 levels | ~12,000 coins | - |
| **First-Clear ★★★ Bonuses (20 coins)** | 500 levels | 10,000 coins | - |
| **Milestone Gift Baskets (49 baskets)** | 49 baskets | 14,700 coins | 49 Boosters |
| **Golden Slither Rush (20 events)** | 20 events | ~4,500 coins | - |
| **Level 10,000 Grand Climax Chest** | 1 chest | 5,000 coins | 15 Boosters |
| **Total Phase 20 Gross Yield** | — | **~46,200 Coins** | **64 Boosters** |

---

## 7. Lifetime 10,000-Level Grand Game Economic Retrospective

*Snakes Slither* ના સંપૂર્ણ 10,000 લેવલ્સ (Phases 1 થી 20) દરમિયાન ખેલાડી દ્વારા પ્રાપ્ત થયેલી કુલ સંપત્તિનો સંગ્રહ:

- **Total First-Clear Coins Earned:** ~360,000 Gold Coins.
- **Total Milestone Gift Baskets Opened:** $20 \times 49 = 980\text{ Gift Baskets}$ (~294,000 bonus coins + 980 free boosters).
- **Total Golden Slither Rush Events:** $20 \times 20 = 400\text{ Live Events}$ (~85,000 bonus coins).
- **Total Phase Finale Chests:** 20 Major Phase Chests (including L10000 Grand Chest).
- **Post-10,000 Endless Economy:** Daily Crown Gauntlet દરરોજ 150 coins + 1 booster grant કરે છે જેથી active engagement અનંતકાળ સુધી જળવાઈ રહે.
