Source docs: phase/phase_15/05_REWARDS_AND_ECONOMY_PHASE_15.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-14-rewards.md, specs/gameplay/phase-15-level-plan-07001-07500.md.

# Spec: Economy — Phase 15 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 15 (Levels 7001–7500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_15/05_REWARDS_AND_ECONOMY_PHASE_15.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with canonical shared standards.

## Proposed Change
Implement the reward distribution logic for Phase 15 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L7010–7490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 15.
- **Phase 15 Grand Central Chest (Level 7500 Finale):**
  - Awarded upon clearing the L7500 Finale board ("Automated Transshipment Yard").
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master Yard Machinist"** Avatar Trophy Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L7500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L7025, L7050, L7075, L7100, L7125, L7150, L7175, L7200, L7225, L7250, L7275, L7300, L7325, L7350, L7375, L7400, L7425, L7450, L7475, L7500 (20 rounds).
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins per round; total up to 8,000 coins).

### 4. Phase 15 Aggregate Inflow
- 500 Levels First Clear: ~10,500 coins.
- First ★★★ Bonus: 10,000 coins.
- 49 Gift Crates: 14,700 coins.
- 20 Coin Rush Rounds: ~7,000 coins.
- Grand Central Chest: 1,000 coins.
- Total Phase 15 Inflow: **~43,200 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 15 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L7500 Phase Chest modal)

## Risks
- None. Values match the established mathematical economy model.

## Open Questions
- None. All numbers match `phase/phase_15/05_REWARDS_AND_ECONOMY_PHASE_15.md` and `SHARED_CORE_STANDARD.md` §6.
