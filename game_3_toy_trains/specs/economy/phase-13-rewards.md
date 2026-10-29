Source docs: phase/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-12-rewards.md, specs/gameplay/phase-13-level-plan-06001-06500.md.

# Spec: Economy — Phase 13 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 13 (Levels 6001–6500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with canonical shared standards.

## Proposed Change
Implement the reward distribution logic for Phase 13 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L6010–6490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 13.
- **Phase 13 Grand Central Chest (Level 6500 Finale):**
  - Awarded upon clearing the L6500 Finale board ("Weather Station Observatory Terminal").
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master Meteorologist Conductor"** Avatar Trophy Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L6500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L6025, L6050, L6075, L6100, L6125, L6150, L6175, L6200, L6225, L6250, L6275, L6300, L6325, L6350, L6375, L6400, L6425, L6450, L6475, L6500 (20 rounds).
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins per round; total up to 8,000 coins).

### 4. Phase 13 Aggregate Inflow
- 500 Levels First Clear: ~10,500 coins.
- First ★★★ Bonus: 10,000 coins.
- 49 Gift Crates: 14,700 coins.
- 20 Coin Rush Rounds: ~7,000 coins.
- Grand Central Chest: 1,000 coins.
- Total Phase 13 Inflow: **~43,200 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 13 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L6500 Phase Chest modal)

## Risks
- None. Values match the established mathematical economy model.

## Open Questions
- None. All numbers match `phase/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md` and `SHARED_CORE_STANDARD.md` §6.
