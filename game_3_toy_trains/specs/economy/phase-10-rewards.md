Source docs: phase/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-9-rewards.md, specs/gameplay/phase-10-level-plan-04501-05000.md.

# Spec: Economy — Phase 10 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 10 (Levels 4501–5000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with the canonical shared standard.

## Proposed Change
Implement the reward distribution logic for Phase 10 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L4510–4990):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 10.
- **Phase 10 Grand Central Chest (Level 5000 Finale):**
  - Awarded upon clearing the L5000 Finale board ("Master Timetable Clock Tower").
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master Timetable Conductor"** Avatar Trophy Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L5000): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L4525, L4550, L4575, L4600, L4625, L4650, L4675, L4700, L4725, L4750, L4775, L4800, L4825, L4850, L4875, L4900, L4925, L4950, L4975, L5000 (20 rounds).
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins per round; total up to 8,000 coins).

### 4. Phase 10 Aggregate Inflow
- 500 Levels First Clear: ~10,500 coins.
- First ★★★ Bonus: 10,000 coins.
- 49 Gift Crates: 14,700 coins.
- 20 Coin Rush Rounds: ~7,000 coins.
- Grand Central Chest: 1,000 coins.
- Total Phase 10 Inflow: **~43,200 coins**.

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 10 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L5000 Phase Chest modal)

## Risks
- None. Reward values strictly match earlier phase models.

## Open Questions
- None. All numbers match `phase/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md` and `SHARED_CORE_STANDARD.md` §6.
