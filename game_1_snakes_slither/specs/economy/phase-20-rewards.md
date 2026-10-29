# Technical Specification: Phase 20 Rewards and Economy (Grand Jungle Master)

**Status:** Draft  
**Phase:** 20 (Levels 9501–10,000)  
**Theme:** Grand Jungle Master (All Systems Culmination & Level 10,000 Grand Finale)  
**Document Type:** Technical Economy Specification  
**Source Cross-Reference:** [phases/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md](../../phases/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md), [SHARED_CORE_STANDARD.md §12](../../SHARED_CORE_STANDARD.md), [SCALING_TO_10000_LEVELS.md §4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Coin Economy & First-Clear Rewards

Coin economy in Phase 20 provides the grandest progression rewards in the game:

| Level Classification | Slot Position | Base Coin Reward | Perfect 3-Star Bonus | First-Clear Total |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (x9) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (x0) | 35 Coins | +20 Coins | **55 Coins** |
| **Grand Finale** | Level 10,000 | 100 Coins | +20 Coins | **120 Coins** |

- **Replay Coin Rate:** Repeat completions grant flat 20% base coins (e.g. 4 coins for Normal).
- **10-Level Block Total:** 410 Coins per standard block.
- **500-Level Total First-Clear Coins:** $\approx 22,000\text{ Coins}$.

---

## 2. Milestone Gift Baskets (Every x0 Level)

Every 10th level (Slots x0, 49 baskets total across Phase 20: Levels 9510, 9520... 9990):
- **Contents per Basket:**
  - 300 Coins
  - 1 Free Booster (Strictly cycling: $(\text{Level} / 10) \pmod 3 \implies \text{Hint}, \text{Shield}, \text{Hammer}$)
- **Cumulative Milestone Payout:** $49 \times 300 = 14,700\text{ Coins}$ + 49 Boosters (17 Hints, 16 Shields, 16 Hammers).

---

## 3. Golden Slither Rush Events

20 Slither Rush mini-events occur across Phase 20 (every 25 levels, e.g., 9525, 9550, 9575... 10000):
- **Objective:** Clear 3 consecutive levels on first attempt.
- **Reward:** 250 Coins + 1 Mega Hammer booster.
- **Total Slither Rush Economy:** $20 \times 250 = 5,000\text{ Coins}$.

---

## 4. Level 10,000 Grand Finale Chest (The Sovereign Summit)
Upon completing Level 10,000 ("Jungle Kingdom Crown"):
- **Phase 20 Grand Climax Chest:**
  - **5,000 Gold Coins** (Instant lump sum)
  - **5 Free Hint Boosters**
  - **5 Free Shield Boosters**
  - **5 Free Hammer Boosters** (Total 15 high-tier boosters)
  - **Exclusive Sovereign Cosmetic Skin:** *"Mythic Sovereign Golden Serpent"* (Glowing gold scales with radiant crown particle trail)
  - **Profile Title & Badge:** *"Grand Jungle Sovereign"* (Diamond-embossed Crown Crest)
  - **Master Hall Access:** Permanent unlock of **Endless Mastery Mode** and **Global Crown Leaderboard**

---

## 5. Phase 20 Gross Financial Ledger
- **Direct Level Clears:** ~22,000 Coins
- **Milestone Gift Baskets:** 14,700 Coins
- **Slither Rush Events:** ~4,500 Coins
- **Level 10,000 Grand Climax Chest:** 5,000 Coins
- **Total Phase 20 Gross Yield:** **~46,200 Coins** + 64 Boosters + Mythic Crown Skin.

---

## 6. References & Cross-Links
- [Phase 20 Level Plan](../gameplay/phase-20-level-plan-09501-10000.md)
- [Phase 20 QA and Rollout](../tech/phase-20-qa-and-rollout.md)
- [Shared Core Standard §12](../../SHARED_CORE_STANDARD.md)

