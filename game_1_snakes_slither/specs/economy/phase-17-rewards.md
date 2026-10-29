# Technical Specification: Phase 17 Rewards and Economy (Mongoose Clan)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical Economy Specification  
**Source Cross-Reference:** [phases/phase_17/05_REWARDS_AND_ECONOMY_PHASE_17.md](../../phases/phase_17/05_REWARDS_AND_ECONOMY_PHASE_17.md), [SHARED_CORE_STANDARD.md §12](../../SHARED_CORE_STANDARD.md), [SCALING_TO_10000_LEVELS.md §4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Coin Economy & First-Clear Rewards

Coin economy in Phase 17 adheres strictly to the late-game economy model:

| Level Classification | Slot Position | Base Coin Reward | Perfect 3-Star Bonus | First-Clear Total |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (x9) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (x0) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale** | Level 8500 | 50 Coins | +50 Coins | **100 Coins** |

- **Replay Coin Rate:** Flat 20% base reward (e.g. 4 coins for Normal).
- **10-Level Block Total:** 410 Coins per block.
- **500-Level Total First-Clear Coins:** $\approx 20,500\text{ Coins}$.

---

## 2. Milestone Gift Baskets (Every x0 Level)

Every 10th level (Slots x0, 49 baskets total across Phase 17):
- **Contents per Basket:**
  - 300 Coins
  - 1 Free Booster (Rotating: Undo, Shield, Hammer)
  - 30-minute Infinite Lives voucher every 5th basket (e.g., Level 8050, 8100, 8150)
- **Cumulative Milestone Payout:** $49 \times 300 = 14,700\text{ Coins}$ + 49 Boosters.

---

## 3. Golden Slither Rush Events

20 Slither Rush mini-events occur across Phase 17 (every 25 levels, e.g., 8025, 8050, 8075...):
- **Objective:** Clear 3 consecutive levels on first attempt.
- **Reward:** 250 Coins + 1 Mega Hammer booster.
- **Total Slither Rush Economy:** $20 \times 250 = 5,000\text{ Coins}$.

---

## 4. Grand Finale Level 8500 Reward Bundle
Upon completing Level 8500:
- **Phase 17 Grand Finale Chest:**
  - 1,000 Coins
  - 2 Undo Boosters
  - 2 Shield Boosters
  - 2 Mega Hammer Boosters
  - Exclusive Profile Cosmetic: **Mongoose Clan Conqueror** Animated Avatar Badge
- **Phase 18 Unlock Key:** Sets client flag `unlockedPhase = 18`.

---

## 5. Economy Totals Across Phase 17
- **Direct Level Clears:** 20,500 Coins
- **Milestone Gift Baskets:** 14,700 Coins
- **Slither Rush Events:** 5,000 Coins
- **Grand Finale Chest:** 1,000 Coins
- **Total Potential Phase 17 Yield:** **41,200 Coins** + 75 Boosters + 9 Infinite Lives Vouchers.

---

## 6. References & Cross-Links
- [Phase 17 Level Plan](../gameplay/phase-17-level-plan-08001-08500.md)
- [Phase 17 QA and Rollout](../tech/phase-17-qa-and-rollout.md)
- [Shared Core Standard §12](../../SHARED_CORE_STANDARD.md)
