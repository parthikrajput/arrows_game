Source docs: phase/phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-4-rewards.md, specs/gameplay/phase-5-level-plan-02001-02500.md.

# Spec: Economy — Phase 5 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 5 (Levels 2001–2500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with the canonical shared standard.

## Proposed Change
Implement the reward distribution logic for Phase 5 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L2010–2490):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 5.
- **Phase 5 Grand Central Chest (Level 2500 Finale):**
  - Awarded upon clearing the L2500 Finale board.
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Shunting Yards"** Avatar Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L2500): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L2025, L2050, L2075, L2100, L2125, L2150, L2175, L2200, L2225, L2250, L2275, L2300, L2325, L2350, L2375, L2400, L2425, L2450, L2475, L2500.
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 5 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L2500 Phase Chest modal)

## Risks
- None. Reward values strictly match earlier phase models.

## Open Questions
- None. All numbers match `phase/phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §6.

