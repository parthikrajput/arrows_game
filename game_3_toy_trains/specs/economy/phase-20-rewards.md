Source docs: phase/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-19-rewards.md, specs/gameplay/phase-20-level-plan-09501-10000.md.

# Spec: Economy — Phase 20 Rewards & Lifetime 10,000 Level Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the reward disbursements, milestone loot crates, Coin Rush schedule, Level 10,000 Grand Sovereign Central Chest, and aggregate lifetime economy totals across all 10,000 levels of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md` and `../../SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Economy maintains exact structural and numeric parity with canonical shared standards.

## Proposed Change
Implement the reward distribution logic for Phase 20 and lifetime tracking in `lib/features/economy/`:

### 1. Milestone Rewards Schedule
- **Conductor's Gift Crates (Every x0 Level: L9510–9990):**
  - Awarded on first clear of each 10th level across all 49 non-finale milestone blocks.
  - Contents: Exactly **300 coins** + **1 booster** based on `(L/10) mod 3`:
    - 1 -> Green Signal Hint
    - 2 -> Track Crane (Hammer)
    - 0 -> Cowcatcher Shield
  - Cumulative: 14,700 coins + 49 boosters across Phase 20.
- **Grand Sovereign Central Chest (Level 10000 Climax):**
  - Awarded upon clearing the historic Level 10,000 board ("The Grand Sovereign Terminus").
  - Contents:
    - **5,000 coins** (Special Grand Finale grant)
    - **5x Green Signal Hint**
    - **5x Cowcatcher Shield**
    - **5x Track Crane**
    - Exclusive Legendary Profile Trophy: **"Grand Master of 10,000 Tracks"** (Solid Gold Crown Emblem).
    - Permanent unlock of the exclusive **Grand Sovereign Golden Locomotive & Carriages Livery**.

### 2. Level Clear Coins
Adheres to canonical standard values:
- Easy (x5 Breather): **15 coins**.
- Normal (x1–x4, x6–x8, x0): **20 coins**.
- Hard (x9 Red Badge): **30 coins**.
- Level 10000 Climax: **100 coins**.
- First ★★★ Clear Bonus: **+20 coins** (one-time grant per level).

### 3. Golden Express Coin Rush Schedule
Triggered immediately following the first clear of every 25th level:
- Levels: L9525, L9550, L9575, L9600, L9625, L9650, L9675, L9700, L9725, L9750, L9775, L9800, L9825, L9850, L9875, L9900, L9925, L9950, L9975, L10000 (20 rounds).
- Duration: 30 seconds.
- Target: 30 wooden express trains.
- Reward: 10 coins per train cleared + 100 coin full-board clear bonus (Max 400 coins per round; total up to 8,000 coins).

### 4. Lifetime 10,000 Levels Cumulative Economy Summary
| Content Stream | Total Coins Granted | Boosters Granted |
|---|---|---|
| **First Clears (L1–L10000)** | ~210,000 coins | — |
| **First ★★★ Clear Bonus** | 200,000 coins | — |
| **980 Conductor Gift Crates** | 294,000 coins | 980 rotating boosters |
| **400 Coin Rush Rounds** | ~140,000 coins | — |
| **20 Phase Finale Chests** | 24,000 coins | 120 total boosters |
| **Lifetime Aggregate Inflow** | **~868,000 coins** | **1,100 total boosters** |

## Affected Files
- `lib/features/economy/domain/reward_calculator.dart` (changed: integrate Phase 20 level rewards and L10000 chest)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: handle L10000 Grand Sovereign modal)

## Risks
- Overflow of coin counters on 32-bit integer representations. Mitigation: Coins tracked via 64-bit integers (`int` in Dart/Flutter).

## Open Questions
- None. All numbers match `phase/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md` and `SHARED_CORE_STANDARD.md` §6.
