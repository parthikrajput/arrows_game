Source docs: phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/gameplay/phase-3-level-plan-01001-01500.md.

# Spec: Economy — Phase 3 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 3 (Levels 1001–1500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 1 and 2 established core coin payouts, Gift Crates (300 coins), and Phase Chests.
- Phase 3 maintains identical canonical values, ensuring zero inflation across on-device generated levels.

## Proposed Change
Implement the reward distribution logic for Phase 3 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L1010–1490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters over Phase 3.
- **Phase 3 Grand Central Chest (Level 1500 Finale):**
  - Awarded upon clearing the L1500 Finale board.
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Day & Night"** Avatar Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L1500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L1025, L1050, L1075, L1100, L1125, L1150, L1175, L1200, L1225, L1250, L1275, L1300, L1325, L1350, L1375, L1400, L1425, L1450, L1475, L1500.
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 3 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L1500 Phase Chest modal)

## Risks
- Economy inflation if players farm Coin Rush on replays. Mitigation: Coin Rush triggers strictly on **first clear**; replays award 0 coins.

## Open Questions
- None. All numbers match `phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §6.

