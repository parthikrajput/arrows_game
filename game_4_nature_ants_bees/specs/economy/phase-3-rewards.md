Source docs: phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/gameplay/phase-3-level-plan-01001-01500.md.

# Spec: Economy — Phase 3 Rewards & Economy

## Status
Draft

## Type
New Feature

## Goal
Specify the economic balance, coin inflows, milestone gift boxes, Level 1500 Royal Honey Chest, and Golden Nectar Rush rounds for Phase 3 (Levels 1001–1500) strictly adhering to Standard §6.

## Current State
Design documented in `phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 1 & 2 established foundational coin inflows, 150–300 coin gift boxes, and the Level 500 / Level 1000 milestone chests.
- Phase 3 scales the milestone economy across Levels 1001–1500 with fixed 300-coin Queen's Gift Boxes.

## Proposed Change
Implement Phase 3 reward distribution rules in `packages/puzzle_core` and `lib/features/economy`:

### 1. Level Clear Inflow (Standard §6)
- **First Clear Rewards:**
  - Easy (Breather `x5`): **15 coins**
  - Normal (`x1–x4`, `x6–x8`, `x0`): **20 coins**
  - Hard (`x9`): **30 coins**
  - Phase Finale (`L1500`): **50 coins**
  - First ★★★ Clear Bonus: **+20 coins**
  - Replays of previously cleared levels: **0 coins**

### 2. Queen's Gift Box (Every x0 Milestone)
- Awarded at Levels 1010, 1020, 1030 ... 1490 (49 Gift Boxes total).
- **Contents:** Exactly **300 coins + 1 rotating booster**:
  - `(L / 10) mod 3 == 1`: Nectar Glow Hint (cap 3).
  - `(L / 10) mod 3 == 2`: Leaf Blower / Hammer (cap 2).
  - `(L / 10) mod 3 == 0`: Queen's Royal Shield (cap 1).

### 3. Royal Honey Chest (Level 1500 Finale)
- Awarded upon clearing the Queen's Solstice Gala Finale (L1500).
- **Contents:**
  - **1,000 coins**
  - **2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers**
  - Exclusive **"Solstice Guardian"** cosmetic profile badge.

### 4. Golden Nectar Rush Rounds
- Unlocks every 25 levels: L1025, L1050, ..., L1500 (20 rounds total).
- 30-second time-attack bonus board:
  - 10 coins per cleared line.
  - +100 coins full board completion bonus.

### 5. Phase 3 Economy Projection
- Total First-Clear Coin Inflow: $\approx 10,250\text{ coins}$.
- Total Star Bonus Inflow: $10,000\text{ coins}$.
- 49 Gift Boxes Inflow: $14,700\text{ coins}$.
- 20 Golden Nectar Rush Rounds: $\approx 8,000\text{ coins}$.
- L1500 Finale Chest: $1,000\text{ coins}$.
- **Net Inflow for Phase 3:** $\approx \mathbf{43,950\text{ coins}}$.
- **Primary Sinks:** Solstice themed garden skins (2,500–4,000 coins), Honey Heart refills (120 coins), booster restocks.

## Affected Files
- `lib/features/economy/rewards_calculator.dart` (changed to include Phase 3 milestone rewards)
- `lib/features/economy/gift_box_service.dart` (changed to handle L1010–L1490 schedule)
- `lib/features/profile/badges_repository.dart` (changed to register "Solstice Guardian" badge)

## Risks
- Coin inflation if Gift Box drops are triggered multiple times due to offline sync race conditions. Mitigated by idempotency keys on milestone level rewards.

## Open Questions
- None. All values are strictly bound to `SHARED_CORE_STANDARD.md` §6.
