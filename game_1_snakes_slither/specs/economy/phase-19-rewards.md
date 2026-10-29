# Technical Specification: Phase 19 Rewards and Economy (Remix B)

**Status:** Draft  
**Phase:** 19 (Levels 9001–9500)  
**Theme:** Remix B (Phase 7 to Phase 12 Mechanics Synergy)  
**Document Type:** Technical Economy Specification  
**Source Cross-Reference:** [phases/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md](../../phases/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md), [SHARED_CORE_STANDARD.md §12](../../SHARED_CORE_STANDARD.md), [SCALING_TO_10000_LEVELS.md §4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Coin Economy & First-Clear Rewards

Coin economy in Phase 19 matches the canonical late-game payout schedule:

| Level Classification | Slot Position | Base Coin Reward | Perfect 3-Star Bonus | First-Clear Total |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 Coins | +20 Coins | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 Coins | +20 Coins | **40 Coins** |
| **Hard Level** | Slot 9 (x9) | 30 Coins | +20 Coins | **50 Coins** |
| **Milestone Gate** | Slot 10 (x0) | 35 Coins | +20 Coins | **55 Coins** |
| **Phase Finale** | Level 9500 | 50 Coins | +50 Coins | **100 Coins** |

- **Replay Coin Rate:** Repeat completions award 20% base coins (e.g. 4 coins for Normal).
- **10-Level Block Total:** 410 Coins per block.
- **500-Level Total First-Clear Coins:** $\approx 20,500\text{ Coins}$.

---

## 2. Milestone Gift Baskets (Every x0 Level)

Every 10th level (Slots x0, 49 baskets total across Phase 19):
- **Contents per Basket:**
  - 300 Coins
  - 1 Free Booster (Rotating: Undo, Shield, Hammer)
  - 30-minute Infinite Lives voucher every 5th basket (e.g., Level 9050, 9100, 9150)
- **Cumulative Milestone Payout:** $49 \times 300 = 14,700\text{ Coins}$ + 49 Boosters.

---

## 3. Golden Slither Rush Events

20 Slither Rush mini-events occur across Phase 19 (every 25 levels, e.g., 9025, 9050, 9075...):
- **Objective:** Clear 3 consecutive levels on first attempt.
- **Reward:** 250 Coins + 1 Mega Hammer booster.
- **Total Slither Rush Economy:** $20 \times 250 = 5,000\text{ Coins}$.

---

## 4. Grand Finale Level 9500 Reward Bundle
Upon completing Level 9500:
- **Phase 19 Grand Finale Chest:**
  - 1,000 Coins
  - 2 Undo Boosters
  - 2 Shield Boosters
  - 2 Mega Hammer Boosters
  - Exclusive Profile Cosmetic: **Wild Currents Sovereign** Animated Avatar Badge
- **Phase 20 Unlock Key:** Sets client flag `unlockedPhase = 20`.

---

## 5. Economy Totals Across Phase 19
- **Direct Level Clears:** 20,500 Coins
- **Milestone Gift Baskets:** 14,700 Coins
- **Slither Rush Events:** 5,000 Coins
- **Grand Finale Chest:** 1,000 Coins
- **Total Potential Phase 19 Yield:** **41,200 Coins** + 75 Boosters + 9 Infinite Lives Vouchers.

---

## 6. References & Cross-Links
- [Phase 19 Level Plan](../gameplay/phase-19-level-plan-09001-09500.md)
- [Phase 19 QA and Rollout](../tech/phase-19-qa-and-rollout.md)
- [Shared Core Standard §12](../../SHARED_CORE_STANDARD.md)

