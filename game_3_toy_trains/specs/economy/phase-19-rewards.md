Source docs: phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-18-rewards.md, specs/gameplay/phase-19-level-plan-09001-09500.md.

# Spec: Economy — Phase 19 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 19 (Levels 9001–9500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with canonical shared standards.

## Proposed Change
Implement the reward distribution logic for Phase 19 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L9010–9490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 19.
- **Phase 19 Grand Central Chest (Level 9500 Finale):**
  - Awarded upon clearing the L9500 Finale board ("Mid-Era Alpine Concourse").
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Mid-Era Remix"** Avatar Trophy Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L9500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L9025, L9050, L9075, L9100, L9125, L9150, L9175, L9200, L9225, L9250, L9275, L9300, L9325, L9350, L9375, L9400, L9425, L9450, L9475, L9500 (20 rounds).
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins per round; total up to 8,000 coins).

### 4. Phase 19 Aggregate Inflow
- 500 Levels First Clear: ~10,500 coins.
- First ★★★ Bonus: 10,000 coins.
- 49 Gift Crates: 14,700 coins.
- 20 Coin Rush Rounds: ~7,000 coins.
- Grand Central Chest: 1,000 coins.
- Total Phase 19 Inflow: **~43,200 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 19 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L9500 Phase Chest modal)

## Risks
- None. Values match the established mathematical economy model.

## Open Questions
- None. All numbers match `phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md` and `SHARED_CORE_STANDARD.md` §6.
