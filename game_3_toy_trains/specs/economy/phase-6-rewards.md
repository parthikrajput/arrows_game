Source docs: phase/phase_6/05_REWARDS_AND_ECONOMY_PHASE_6.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-5-rewards.md, specs/gameplay/phase-6-level-plan-02501-03000.md.

# Spec: Economy — Phase 6 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 6 (Levels 2501–3000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_6/05_REWARDS_AND_ECONOMY_PHASE_6.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with the canonical shared standard.

## Proposed Change
Implement the reward distribution logic for Phase 6 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L2510–2990):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 6.
- **Phase 6 Grand Central Chest (Level 3000 Finale):**
  - Awarded upon clearing the L3000 Finale board.
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Optical Signals"** Avatar Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L3000): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L2525, L2550, L2575, L2600, L2625, L2650, L2675, L2700, L2725, L2750, L2775, L2800, L2825, L2850, L2875, L2900, L2925, L2950, L2975, L3000.
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 6 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L3000 Phase Chest modal)

## Risks
- None. Reward values strictly match earlier phase models.

## Open Questions
- None. All numbers match `phase/phase_6/05_REWARDS_AND_ECONOMY_PHASE_6.md` and `SHARED_CORE_STANDARD.md` §6.
