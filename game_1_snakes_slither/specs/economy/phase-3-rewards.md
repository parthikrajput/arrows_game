Source docs: phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/economy/piggy-bank-and-cosmetics.md.

# Spec: Economy — Phase 3 Rewards & Economy

## Status
Draft

## Type
Improvement (extends economy reward schedules and milestone claims into Levels 1001–1500)

## Goal
Specify the economy schedule, milestone reward values, Gift Baskets, Level 1500 Phase Chest, and Golden Slither Rush bonus rounds for Phase 3, preserving the invariant values established in the shared standard.

## Current State
Design documented in `phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 2 established 300 coins per Gift Basket and Level 1000 Phase Chest.
- Phase 3 continues the identical economy balances across Levels 1001 to 1500 without currency inflation.

## Proposed Change
Extend reward distribution tables and grant pipelines for Phase 3:

### 1. Inflow Schedule (standard §6.1)
- **Level First Clear:**
  - Easy (x5 Breathers): **15 coins**
  - Normal (x1, x2–x4, x6–x8, x0): **20 coins**
  - Hard (x9 Hard levels): **30 coins**
  - Phase Finale (L1500): **50 coins**
- **First ★★★ Bonus:** **+20 coins** (credited on first 3-star clear).
- **2X Win (Rewarded Ad):** Base clear coins × 2 (star bonus does not double).
- **Jungle Gift Basket (Milestone Levels):**
  - Triggers at every 10th level: L1010, L1020, L1030 ... L1490 (49 total baskets).
  - Reward per basket: **300 coins + 1 booster** (cycling: Glow Firefly Hint -> Safety Shell Shield -> Magic Stone Hammer).
- **Phase 3 Finale Chest (Level 1500):**
  - **1,000 coins + 2 Hint + 2 Shield + 2 Hammer + Phase 3 Master Badge**.
- **Golden Slither Rush (Bonus Rounds):**
  - Triggers on first clear of every 25th level: L1025, 1050, 1075 ... 1500 (20 total rounds).
  - 30 seconds timer, 30 snakes per round, 10 coins per slithered snake + 100 coins full-clear bonus (up to 400 coins per run).

### 2. Economy Inflow / Outflow Balance
- Average earnings across Phase 3 remain steady at ~60–70 coins per level cleared (accounting for first clear, stars, gift baskets, and bonus rushes).
- Standard booster prices remain locked: Hint (60 / 150 for 3), Shield (80 / 200 for 3), Hammer (100 / 250 for 3).
- Heart Berry Refill remains fixed at 120 coins (max 2 per attempt during Second Chance).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (extended for Phase 3 level tags)
- `lib/features/gameplay/presentation/dialogs/gift_basket_dialog.dart` (Phase 3 gift tier)
- `lib/features/gameplay/presentation/dialogs/phase_chest_dialog.dart` (L1500 chest assets)

## Risks
- Rapid coin accumulation from 20 Golden Slither Rush rounds in Phase 3. Mitigated by one-time first-clear grant rule and cosmetic shop sinks (800–4,000 coins).

## Open Questions
- None. Reward numbers and schedules are strictly bound by `SHARED_CORE_STANDARD.md` §6.
