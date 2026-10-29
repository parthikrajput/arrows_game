Source docs: phase/phase_7/05_REWARDS_AND_ECONOMY_PHASE_7.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/gameplay/phase-7-level-plan-03001-03500.md.

# Spec: Economy — Phase 7 Rewards & Economy

## Status
Draft

## Type
New Feature

## Goal
Specify the economic balance, coin inflows, milestone gift boxes, Level 3500 Royal Honey Chest, and Golden Nectar Rush rounds for Phase 7 (Levels 3001–3500) strictly adhering to Standard §6.

## Current State
Design documented in `phase/phase_7/05_REWARDS_AND_ECONOMY_PHASE_7.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 6 maintained standard economic inflow rhythm.
- Phase 7 establishes the 500-level reward cadence for Levels 3001–3500 culminating in the Level 3500 Whirlwind Virtuoso milestone.

## Proposed Change
Implement Phase 7 reward distribution rules in `packages/puzzle_core` and `lib/features/economy`:

### 1. Level Clear Inflow (Standard §6)
- **First Clear Rewards:**
  - Easy (Breather `x5`): **15 coins**
  - Normal (`x1–x4`, `x6–x8`, `x0`): **20 coins**
  - Hard (`x9`): **30 coins**
  - Phase Finale (`L3500`): **50 coins**
  - First ★★★ Clear Bonus: **+20 coins**
  - Replays of previously cleared levels: **0 coins**

### 2. Queen's Gift Box (Every x0 Milestone)
- Awarded at Levels 3010, 3020, 3030 ... 3490 (49 Gift Boxes total).
- **Contents:** Exactly **300 coins + 1 rotating booster**:
  - `(L / 10) mod 3 == 1`: Nectar Glow Hint (cap 3).
  - `(L / 10) mod 3 == 2`: Leaf Blower / Hammer (cap 2).
  - `(L / 10) mod 3 == 0`: Queen's Royal Shield (cap 1).

### 3. Royal Honey Chest (Level 3500 Finale)
- Awarded upon clearing the Whirling Blossom Gala Finale (L3500).
- **Contents:**
  - **1,000 coins**
  - **2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers**
  - Exclusive **"Whirlwind Virtuoso"** cosmetic profile badge.

### 4. Golden Nectar Rush Rounds
- Unlocks every 25 levels: L3025, L3050, ..., L3500 (20 rounds total).
- 30-second time-attack bonus board:
  - 10 coins per cleared line.
  - +100 coins full board completion bonus.

### 5. Phase 7 Economy Projection
- Total First-Clear Coin Inflow: $\approx 10,250\text{ coins}$.
- Total Star Bonus Inflow: $10,000\text{ coins}$.
- 49 Gift Boxes Inflow: $14,700\text{ coins}$.
- 20 Golden Nectar Rush Rounds: $\approx 8,000\text{ coins}$.
- L3500 Finale Chest: $1,000\text{ coins}$.
- **Net Inflow for Phase 7:** $\approx \mathbf{43,950\text{ coins}}$.
- **Primary Sinks:** Whirlwind Virtuoso skins (2,500–4,000 coins), Honey Heart refills (120 coins), booster restocks.

## Affected Files
- `lib/features/economy/rewards_calculator.dart` (changed to include Phase 7 milestone rewards)
- `lib/features/profile/badges_repository.dart` (changed to register "Whirlwind Virtuoso" badge)

## Risks
- Transaction desync during rapid network dropout when claiming milestone gift boxes. Mitigated by idempotent local journal entries.

## Open Questions
- None. All values strictly adhere to `SHARED_CORE_STANDARD.md` §6.
