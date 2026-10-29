Source docs: phase/phase_17/05_REWARDS_AND_ECONOMY_PHASE_17.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-16-rewards.md, specs/gameplay/phase-17-level-plan-08001-08500.md.

# Spec: Economy — Phase 17 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 17 (Levels 8001–8500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_17/05_REWARDS_AND_ECONOMY_PHASE_17.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with canonical shared standards.

## Proposed Change
Implement the reward distribution logic for Phase 17 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L8010–8490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 17.
- **Phase 17 Grand Central Chest (Level 8500 Finale):**
  - Awarded upon clearing the L8500 Finale board ("Citadel of the Grand Clock Tower").
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Guardian Clock Master"** Avatar Trophy Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L8500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L8025, L8050, L8075, L8100, L8125, L8150, L8175, L8200, L8225, L8250, L8275, L8300, L8325, L8350, L8375, L8400, L8425, L8450, L8475, L8500 (20 rounds).
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins per round; total up to 8,000 coins).

### 4. Phase 17 Aggregate Inflow
- 500 Levels First Clear: ~10,500 coins.
- First ★★★ Bonus: 10,000 coins.
- 49 Gift Crates: 14,700 coins.
- 20 Coin Rush Rounds: ~7,000 coins.
- Grand Central Chest: 1,000 coins.
- Total Phase 17 Inflow: **~43,200 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 17 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L8500 Phase Chest modal)

## Risks
- None. Values match the established mathematical economy model.

## Open Questions
- None. All numbers match `phase/phase_17/05_REWARDS_AND_ECONOMY_PHASE_17.md` and `SHARED_CORE_STANDARD.md` §6.
