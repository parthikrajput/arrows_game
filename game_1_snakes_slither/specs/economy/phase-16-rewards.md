# Technical Specification: Phase 16 Rewards and Economy (Treasure Keys)

**Status:** Draft  
**Phase:** 16 (Levels 7501–8000)  
**Theme:** Treasure Keys (Keys Deluxe)  
**Document Type:** Technical Economy Specification  
**Source Cross-Reference:** [phases/phase_16/05_REWARDS_AND_ECONOMY_PHASE_16.md](../../phases/phase_16/05_REWARDS_AND_ECONOMY_PHASE_16.md), [SHARED_CORE_STANDARD.md §12](../../SHARED_CORE_STANDARD.md), [SCALING_TO_10000_LEVELS.md §4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Coin Economy & First-Clear Rewards

Coin economy in Phase 16 matches canonical late-game scaling:

| Level Classification | Slot Position | Base Coin Reward | Perfect 3-Star Bonus | First-Clear Total |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (x9) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (x0) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale** | Level 8000 | 50 Coins | +50 Coins | **100 Coins** |

- **Replay Coin Rate:** Repeat completions award 20% base coins (e.g. 4 coins for Normal).
- **10-Level Block Total:** 410 Coins per block.
- **500-Level Total First-Clear Coins:** $\approx 20,500\text{ Coins}$.

---

## 2. Milestone Gift Baskets (Every x0 Level)

Every 10th level (Slots x0, 49 baskets total across Phase 16):
- **Contents per Basket:**
  - 300 Coins
  - 1 Free Booster (Rotating: Undo, Shield, Hammer)
  - 30-minute Infinite Lives voucher every 5th basket (e.g., Level 7550, 7600, 7650)
- **Cumulative Milestone Payout:** $49 \times 300 = 14,700\text{ Coins}$ + 49 Boosters.

---

## 3. Golden Slither Rush Events

20 Slither Rush mini-events occur across Phase 16 (every 25 levels, e.g., 7525, 7550, 7575...):
- **Objective:** Clear 3 consecutive levels on first attempt.
- **Reward:** 250 Coins + 1 Mega Hammer booster.
- **Total Slither Rush Economy:** $20 \times 250 = 5,000\text{ Coins}$.

---

## 4. Grand Finale Level 8000 Reward Bundle
Upon completing Level 8000:
- **Phase 16 Grand Finale Chest:**
  - 1,000 Coins
  - 2 Undo Boosters
  - 2 Shield Boosters
  - 2 Mega Hammer Boosters
  - Exclusive Profile Cosmetic: **Treasure Vault Sovereign** Animated Avatar Badge
- **Phase 17 Unlock Key:** Sets client flag `unlockedPhase = 17`.

---

## 5. Economy Totals Across Phase 16
- **Direct Level Clears:** 20,500 Coins
- **Milestone Gift Baskets:** 14,700 Coins
- **Slither Rush Events:** 5,000 Coins
- **Grand Finale Chest:** 1,000 Coins
- **Total Potential Phase 16 Yield:** **41,200 Coins** + 75 Boosters + 9 Infinite Lives Vouchers.

---

## 6. References & Cross-Links
- [Phase 16 Level Plan](../gameplay/phase-16-level-plan-07501-08000.md)
- [Phase 16 QA and Rollout](../tech/phase-16-qa-and-rollout.md)
- [Shared Core Standard §12](../../SHARED_CORE_STANDARD.md)

