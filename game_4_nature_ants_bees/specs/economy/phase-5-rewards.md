Source docs: phase/phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/gameplay/phase-5-level-plan-02001-02500.md.

# Spec: Economy — Phase 5 Rewards & Economy

## Status
Draft

## Type
New Feature

## Goal
Specify the economic balance, coin inflows, milestone gift boxes, Level 2500 Royal Honey Chest, and Golden Nectar Rush rounds for Phase 5 (Levels 2001–2500) strictly adhering to Standard §6.

## Current State
Design documented in `phase/phase_5/05_REWARDS_AND_ECONOMY_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 4 maintained standard economic inflow rhythm.
- Phase 5 establishes the 500-level reward cadence for Levels 2001–2500 culminating in the Level 2500 Harvest Master milestone.

## Proposed Change
Implement Phase 5 reward distribution rules in `packages/puzzle_core` and `lib/features/economy`:

### 1. Level Clear Inflow (Standard §6)
- **First Clear Rewards:**
  - Easy (Breather `x5`): **15 coins**
  - Normal (`x1–x4`, `x6–x8`, `x0`): **20 coins**
  - Hard (`x9`): **30 coins**
  - Phase Finale (`L2500`): **50 coins**
  - First ★★★ Clear Bonus: **+20 coins**
  - Replays of previously cleared levels: **0 coins**

### 2. Queen's Gift Box (Every x0 Milestone)
- Awarded at Levels 2010, 2020, 2030 ... 2490 (49 Gift Boxes total).
- **Contents:** Exactly **300 coins + 1 rotating booster**:
  - `(L / 10) mod 3 == 1`: Nectar Glow Hint (cap 3).
  - `(L / 10) mod 3 == 2`: Leaf Blower / Hammer (cap 2).
  - `(L / 10) mod 3 == 0`: Queen's Royal Shield (cap 1).

### 3. Royal Honey Chest (Level 2500 Finale)
- Awarded upon clearing the Autumn Harvest Festival Finale (L2500).
- **Contents:**
  - **1,000 coins**
  - **2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers**
  - Exclusive **"Harvest Master"** cosmetic profile badge.

### 4. Golden Nectar Rush Rounds
- Unlocks every 25 levels: L2025, L2050, ..., L2500 (20 rounds total).
- 30-second time-attack bonus board:
  - 10 coins per cleared line.
  - +100 coins full board completion bonus.

### 5. Phase 5 Economy Projection
- Total First-Clear Coin Inflow: $\approx 10,250\text{ coins}$.
- Total Star Bonus Inflow: $10,000\text{ coins}$.
- 49 Gift Boxes Inflow: $14,700\text{ coins}$.
- 20 Golden Nectar Rush Rounds: $\approx 8,000\text{ coins}$.
- L2500 Finale Chest: $1,000\text{ coins}$.
- **Net Inflow for Phase 5:** $\approx \mathbf{43,950\text{ coins}}$.
- **Primary Sinks:** Autumn Harvest cosmetics (2,500–4,000 coins), Honey Heart refills (120 coins), booster restocks.

## Affected Files
- `lib/features/economy/rewards_calculator.dart` (changed to include Phase 5 milestone rewards)
- `lib/features/profile/badges_repository.dart` (changed to register "Harvest Master" badge)

## Risks
- Double grant of milestone rewards under high latency cloud-sync retries. Mitigated by checking transaction ledger before applying coin credits.

## Open Questions
- None. All values strictly adhere to `SHARED_CORE_STANDARD.md` §6.

