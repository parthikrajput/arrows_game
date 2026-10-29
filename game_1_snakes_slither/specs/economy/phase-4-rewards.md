Source docs: phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/economy/phase-3-rewards.md, specs/economy/boosters-coins-shop.md.

# Spec: Economy — Phase 4 Rewards & Economy

## Status
Draft

## Type
Improvement (extends reward schedules and milestone claims into Levels 1501–2000)

## Goal
Specify the economy schedule, milestone reward values, Gift Baskets, Level 2000 Phase Finale Chest, and Golden Slither Rush bonus rounds for Phase 4, keeping strictly to the invariant values established in the shared standard.

## Current State
Design documented in `phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 3 maintained balanced coin inflows/outflows across Levels 1001–1500.
- Phase 4 extends this exact economic framework through Level 2000 without price changes or currency inflation.

## Proposed Change
Extend reward calculation tables and grant pipelines for Levels 1501 to 2000:

### 1. Inflow Schedule (Standard §6.1)
- **Level First Clear:**
  - Easy (x5 Breathers): **15 coins**
  - Normal (x1, x2–x4, x6–x8, x0): **20 coins**
  - Hard (x9 Hard levels): **30 coins**
  - Phase Finale (L2000): **50 coins**
- **First ★★★ Bonus:** **+20 coins** (granted on first 3-star clear of any level).
- **2X Win (Rewarded Ad):** Base clear coins × 2 (bonus star coins do not double).
- **Jungle Gift Basket (Milestone Levels):**
  - Triggers at every 10th level: L1510, L1520, L1530 ... L1990 (49 total baskets in Phase 4).
  - Reward per basket: **300 coins + 1 booster** (strict round-robin cycle: Glow Firefly Hint → Safety Shell Shield → Magic Stone Hammer).
- **Phase 4 Finale Chest (Level 2000):**
  - **1,000 coins + 2 Glow Firefly Hint + 2 Safety Shell Shield + 2 Magic Stone Hammer + Phase 4 Master Badge**.
- **Golden Slither Rush (Bonus Rounds):**
  - Unlocks on first clear of every 25th level: L1525, 1550, 1575 ... L2000 (20 total rounds in Phase 4).
  - Round parameters: 30 seconds timer, 30 snakes per round, 10 coins per slithered snake + 100 coins full-clear bonus (up to 400 coins per run).

### 2. Outflow Schedule (Standard §6.2)
- **Booster Purchases (Coins):**
  - Glow Firefly Hint: 60 coins (single) / 150 coins (3-pack)
  - Safety Shell Shield: 80 coins (single) / 200 coins (3-pack)
  - Magic Stone Hammer: 100 coins (single) / 250 coins (3-pack)
- **Heart Berry Refill:** Fixed at **120 coins** (+1 Heart, max 2 refills per attempt).
- **Streak Saver Leaf:** Fixed at **200 coins**.
- **Cosmetics Shop Sinks:** Great Tree & Canopy themed snake skins and board tiles priced between **800 and 4,000 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (extended for Phase 4 level tags)
- `lib/features/gameplay/presentation/dialogs/gift_basket_dialog.dart` (Phase 4 gift tier handling)
- `lib/features/gameplay/presentation/dialogs/phase_chest_dialog.dart` (L2000 chest visual assets and badge grant)

## Risks
- Excessive coin accumulation if players clear multiple Golden Slither Rush rounds in a single session. Mitigated by one-time clear restriction and high-value cosmetic shop sinks.

## Open Questions
- None. Reward numbers and schedules are strictly bound by `SHARED_CORE_STANDARD.md` §6.
