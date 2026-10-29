Source docs: phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/economy/phase-4-rewards.md, specs/economy/boosters-coins-shop.md.

# Spec: Economy — Phase 5 Rewards & Economy

## Status
Draft

## Type
Improvement (extends reward schedules and milestone claims into Levels 2001–2500)

## Goal
Specify the economy schedule, milestone reward values, Gift Baskets, Level 2500 Phase Finale Chest, and Golden Slither Rush bonus rounds for Phase 5, preserving strictly the invariant values established in the shared standard.

## Current State
Design documented in `phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 4 maintained balanced coin inflows/outflows through Level 2000.
- Phase 5 extends this identical economic structure through Level 2500 without price drift or coin inflation.

## Proposed Change
Extend reward calculation tables and grant pipelines for Levels 2001 to 2500:

### 1. Inflow Schedule (Standard §6.1)
- **Level First Clear:**
  - Easy (x5 Breathers): **15 coins**
  - Normal (x1, x2–x4, x6–x8, x0): **20 coins**
  - Hard (x9 Hard levels): **30 coins**
  - Phase Finale (L2500): **50 coins**
- **First ★★★ Bonus:** **+20 coins** (granted on first 3-star clear of any level).
- **2X Win (Rewarded Ad):** Base clear coins × 2 (bonus star coins do not double).
- **Jungle Gift Basket (Milestone Levels):**
  - Triggers at every 10th level: L2010, L2020, L2030 ... L2490 (49 total baskets in Phase 5).
  - Reward per basket: **300 coins + 1 booster** (strict round-robin cycle: Glow Firefly Hint → Safety Shell Shield → Magic Stone Hammer).
- **Phase 5 Finale Chest (Level 2500):**
  - **1,000 coins + 2 Glow Firefly Hint + 2 Safety Shell Shield + 2 Magic Stone Hammer + Phase 5 Master Badge**.
- **Golden Slither Rush (Bonus Rounds):**
  - Unlocks on first clear of every 25th level: L2025, 2050, 2075 ... L2500 (20 total rounds in Phase 5).
  - Round parameters: 30 seconds timer, 30 snakes per round, 10 coins per slithered snake + 100 coins full-clear bonus (up to 400 coins per run).

### 2. Outflow Schedule (Standard §6.2)
- **Booster Purchases (Coins):**
  - Glow Firefly Hint: 60 coins (single) / 150 coins (3-pack)
  - Safety Shell Shield: 80 coins (single) / 200 coins (3-pack)
  - Magic Stone Hammer: 100 coins (single) / 250 coins (3-pack)
- **Heart Berry Refill:** Fixed at **120 coins** (+1 Heart, max 2 refills per attempt).
- **Streak Saver Leaf:** Fixed at **200 coins**.
- **Cosmetics Shop Sinks:** Ancient Coconut Shrine Board Theme & Coconut Shell Snake Skin priced between **800 and 4,000 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (extended for Phase 5 level tags)
- `lib/features/gameplay/presentation/dialogs/gift_basket_dialog.dart` (Phase 5 gift tier handling)
- `lib/features/gameplay/presentation/dialogs/phase_chest_dialog.dart` (L2500 chest visual assets and badge grant)

## Risks
- Rapid coin accumulation from 20 bonus rounds. Handled by cosmetic item sinks and standard booster prices.

## Open Questions
- None. Reward numbers and schedules are strictly bound by `SHARED_CORE_STANDARD.md` §6.
