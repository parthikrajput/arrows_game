Source docs: phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-8-rewards.md, specs/gameplay/phase-9-level-plan-04001-04500.md.

# Spec: Economy — Phase 9 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 9 (Levels 4001–4500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with the canonical shared standard.

## Proposed Change
Implement the reward distribution logic for Phase 9 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L4010–4490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 9.
- **Phase 9 Grand Central Chest (Level 4500 Finale):**
  - Awarded upon clearing the L4500 Finale board.
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Train Couplings"** Avatar Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L4500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L4025, L4050, L4075, L4100, L4125, L4150, L4175, L4200, L4225, L4250, L4275, L4300, L4325, L4350, L4375, L4400, L4425, L4450, L4475, L4500.
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 9 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L4500 Phase Chest modal)

## Risks
- None. Reward values strictly match earlier phase models.

## Open Questions
- None. All numbers match `phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md` and `SHARED_CORE_STANDARD.md` §6.
