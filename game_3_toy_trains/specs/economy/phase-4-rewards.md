Source docs: phase/phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-3-rewards.md, specs/gameplay/phase-4-level-plan-01501-02000.md.

# Spec: Economy — Phase 4 Rewards & Economy Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, and overall coin economy balance for Phase 4 (Levels 1501–2000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Rewards schedule follows the exact canonical economy standard established in Phases 1–3 without deviation.

## Proposed Change
Implement the reward distribution logic for Phase 4 in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L1510–1990):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 4.
- **Phase 4 Grand Central Chest (Level 2000 Finale):**
  - Awarded upon clearing the L2000 Finale board.
  - Contents: **1,000 coins** + **2x Green Signal Hint** + **2x Cowcatcher Shield** + **2x Track Crane** + exclusive **"Master of Station Floors"** Avatar Badge.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Finale (L2000): **50 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L1525, L1550, L1575, L1600, L1625, L1650, L1675, L1700, L1725, L1750, L1775, L1800, L1825, L1850, L1875, L1900, L1925, L1950, L1975, L2000.
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins).

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 4 level rewards)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L2000 Phase Chest modal)

## Risks
- None. Reward values maintain exact parity with earlier phase economy models.

## Open Questions
- None. All numbers match `phase/phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §6.

