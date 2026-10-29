Source docs: phases/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md, ../../SHARED_CORE_STANDARD.md §5, §6, §7, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/economy/phase-7-rewards.md.

# Spec: Economy — Phase 8 Rewards, Currencies and Economy

## Status
Draft

## Type
New Feature

## Goal
Implement the currency inflow and outflow balances, milestone Gift Baskets, Golden Slither Rush bonus events, and the Level 4000 Phase Finale Chest for Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phases/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Base booster prices, coin values, and gift basket mechanics are governed strictly by the cross-game standard.
- Phase 8 requires scheduling the 49 milestone gift baskets, 20 rush events, and the L4000 Finale Chest unboxing.

## Proposed Change
Extend `lib/features/economy/` with Phase 8 reward tables and milestone reward unlocks:

### 1. Level Clear Inflow Rates (Standard §6.1)

| Level Classification | Base Clear Coins | First-Clear ★★★ Bonus | Total First-Clear Yield |
|---|---|---|---|
| **Easy Levels (x5)** | 15 coins | +20 coins | 35 coins |
| **Normal Levels** | 20 coins | +20 coins | 40 coins |
| **Hard Levels (x9)** | 30 coins | +20 coins | 50 coins |
| **Milestone Levels (x0)** | 35 coins | +20 coins | 55 coins |
| **Phase Finale (L4000)** | 50 coins | +20 coins | 70 coins |

- **Repeat Clears:** 20% of base clear coins (rounded down), 0 stars awarded.
- **Rewarded Ad Double (2X Win):** Doubles base clear coins.

---

### 2. Milestone Gift Baskets (49 Baskets at x0 Levels)
- Triggered immediately upon clearing levels 3510, 3520, 3530 ... 3990 (49 total baskets).
- **Coin Grant:** 300 Gold Coins per basket ($49 \times 300 = 14,700\text{ coins}$).
- **Booster Grant:** 1 Free Booster per basket cycling:
  $$(\text{Level} / 10) \pmod 3 \implies 1: \text{Hint}, 2: \text{Shield}, 0: \text{Hammer}$$
- Total boosters awarded: 17 Glow Firefly Hints, 16 Safety Shell Shields, 16 Magic Stone Hammers.

---

### 3. Golden Slither Rush Events (20 Bonus Rounds)
- Triggered after levels 3525, 3550, 3575 ... 4000.
- **Round Setup:** 30 seconds timer, 30 bonus snakes, zero hearts lost on bonks.
- **Payout:** 10 coins per exited snake + 100 coins full-board clear bonus (Max 400 coins per run).

---

### 4. Phase 8 Finale Treasure Chest (Level 4000)
- Unlocked upon completing Level 4000 "Heart of the Overgrowth":
  - **1,000 Gold Coins**
  - **2 Glow Firefly Hint Boosters**
  - **2 Safety Shell Shield Boosters**
  - **2 Magic Stone Hammer Boosters**
  - **Exclusive Cosmetic Profile Badge:** *"Phase 8 Master — Overgrowth Sovereign"*
  - Unlocks Phase 9 progression (Levels 4001–4500).

---

### 5. Economy Outflow & Sinks (Standard §5.2)
- **Booster Shop:** Hint (60 / 150), Shield (80 / 200), Hammer (100 / 250).
- **Second Chance Heart Berry:** 120 coins (+1 Heart, max 2 per attempt).
- **Streak Saver Leaf:** 200 coins.
- **Cosmetics Shop Additions:** Overgrown Garden Board Theme (2,500 coins) and Sprout Serpent Skin (3,000 coins).

## Affected Files
- `lib/features/economy/data/phase_8_rewards_table.dart` — to be created
- `lib/features/economy/bloc/rewards_bloc.dart` — changed

## Risks and Open Questions
- None. Formula and numbers strictly match `SHARED_CORE_STANDARD.md` §6.

