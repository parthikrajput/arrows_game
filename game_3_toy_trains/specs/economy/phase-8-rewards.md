Source docs: phase/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-7-rewards.md, specs/gameplay/phase-8-level-plan-03501-04000.md.

# Spec: Economy — Phase 8 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 8 (Levels 3501–4000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with the canonical shared standard.

## Proposed Change
Implement the reward distribution logic for Phase 8 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L3510–3990):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 8.
- **Phase 8 Grand Central Chest (Level 4000 Finale):**
  - Awarded upon clearing the L4000 Finale board.
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Botanical Lines"** Avatar Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L4000): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L3525, L3550, L3575, L3600, L3625, L3650, L3675, L3700, L3725, L3750, L3775, L3800, L3825, L3850, L3875, L3900, L3925, L3950, L3975, L4000.
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 8 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L4000 Phase Chest modal)

## Risks
- None. Reward values strictly match earlier phase models.

## Open Questions
- None. All numbers match `phase/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md` and `SHARED_CORE_STANDARD.md` §6.
