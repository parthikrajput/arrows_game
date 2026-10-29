# Technical Specification: Phase 15 Rewards and Economy (River Delta)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical Economy Specification  
**Source Cross-Reference:** [phases/phase_15/05_REWARDS_AND_ECONOMY_PHASE_15.md](../../phases/phase_15/05_REWARDS_AND_ECONOMY_PHASE_15.md), [SHARED_CORE_STANDARD.md §12](../../SHARED_CORE_STANDARD.md), [SCALING_TO_10000_LEVELS.md §4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Coin Economy & First-Clear Rewards

Coin economy in Phase 15 scales linearly to support late-game booster costs and progression sinks:

| Level Classification | Slot Position | Base Coin Reward | Perfect 3-Star Bonus | First-Clear Total |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (x9) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (x0) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale** | Level 7500 | 50 Coins | +50 Coins | **100 Coins** |

- **Replay Coin Rate:** Repeat completions grant flat 20% of base reward (rounded down; e.g. 4 coins for Normal).
- **10-Level Block Total:** First-clear 3-star yields 410 Coins per block.
- **500-Level Total First-Clear Coins:** $\approx 20,500\text{ Coins}$.

---

## 2. Milestone Gift Baskets (Every x0 Level)

Every 10th level (Slots x0, 49 baskets total across Phase 15):
- **Contents per Basket:**
  - 300 Coins
  - 1 Free Booster (Rotating: Undo, Shield, Hammer)
  - 30-minute Infinite Lives voucher every 5th basket (e.g., Level 7050, 7100, 7150)
- **Cumulative Milestone Payout:** $49 \times 300 = 14,700\text{ Coins}$ + 49 Boosters.

---

## 3. Golden Slither Rush Events

20 Slither Rush mini-events occur across Phase 15 (every 25 levels, e.g., 7025, 7050, 7075...):
- **Objective:** Clear 3 consecutive levels on first attempt.
- **Reward:** 250 Coins + 1 Mega Hammer booster.
- **Total Slither Rush Economy:** $20 \times 250 = 5,000\text{ Coins}$.

---

## 4. Grand Finale Level 7500 Reward Bundle
Upon completing Level 7500:
- **Phase 15 Grand Finale Chest:**
  - 1,000 Coins
  - 2 Undo Boosters
  - 2 Shield Boosters
  - 2 Mega Hammer Boosters
  - Exclusive Profile Cosmetic: **Delta Tide Sovereign** Animated Avatar Badge
- **Phase 16 Unlock Key:** Sets persistent client flag `unlockedPhase = 16`.

---

## 5. Economy Totals Across Phase 15
- **Direct Level Clears:** 20,500 Coins
- **Milestone Gift Baskets:** 14,700 Coins
- **Slither Rush Events:** 5,000 Coins
- **Grand Finale Chest:** 1,000 Coins
- **Total Potential Phase 15 Yield:** **41,200 Coins** + 75 Boosters + 9 Infinite Lives Vouchers.

---

## 6. References & Cross-Links
- [Phase 15 Level Plan](../gameplay/phase-15-level-plan-07001-07500.md)
- [Phase 15 QA and Rollout](../tech/phase-15-qa-and-rollout.md)
- [Shared Core Standard §12](../../SHARED_CORE_STANDARD.md)

