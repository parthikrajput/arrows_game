Source docs: phase/phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/phase-3-rewards.md.

# Spec: Economy — Phase 4 Rewards & Economy Invariants

## Status
Draft

## Type
New Feature

## Goal
Specify the coin rewards, Craft Baskets, Level 2000 Grand Sewing Chest, Golden Bobbin Rush bonus rounds, and monetization invariants for Yarn Unravel Phase 4 (Levels 1501–2000).

## Current State
Design documented in `phase/phase_4/05_REWARDS_AND_ECONOMY_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 3 established economic flows across Levels 1001–1500 in `specs/economy/phase-3-rewards.md`.
- Phase 4 continues identical economic invariants for Levels 1501–2000.

## Proposed Change
Extend reward mappings for Phase 4:

### 1. Level Clear Coins
Awarded upon first clear only:
- **Easy Levels (x5 breather):** 15 Coins.
- **Normal Levels (x1, x2–x4, x6–x8, x0):** 20 Coins.
- **Hard Levels (x9):** 30 Coins.
- **Phase Finale (L2000):** 50 Coins.
- **First ★★★ Clear Bonus:** +20 Coins across all levels.
- **2X Win (Rewarded Ad):** Doubles base clear coins upon player opt-in.

### 2. Craft Basket (Gift Box) Schedule
- **Milestone Trigger:** First clear of every level ending in 0 (L1510, 1520 … 1990, total 49 milestones).
- **Contents:** **300 Coins** + 1 free booster.
- **Booster Formula:** `(Level / 10) mod 3`:
  - `1`: 1 Needle Glow Hint
  - `2`: 1 Golden Scissors
  - `0`: 1 Thimble Shield

### 3. Level 2000 Grand Sewing Chest (Phase Chest)
Awarded upon first clear of Level 2000 "The Three-Tier Quilt":
- **1,000 Coins**
- **2 Needle Glow Hints**
- **2 Thimble Shields**
- **2 Golden Scissors**
- **Phase 4 Profile Badge:** "Master of the Multi-Floor"

### 4. Golden Bobbin Rush (Bonus Rounds)
- **Schedule:** Triggers upon first clear every 25 levels (L1525, 1550, 1575 … 2000, total 20 bonus rounds).
- **Format:** 30 seconds, 30 single-segment threads on single-floor bonus board.
- **Rewards:** 10 Coins per thread + 100 Coins full clear bonus = maximum **400 Coins**.

### 5. Economy Invariants
- **Booster Prices (fixed):** Hint (60 / 150), Shield (80 / 200), Scissors (100 / 250).
- **Heart Refill:** 120 Coins (only inside Second Chance modal; maximum 2 refills per attempt).
- **Darning Patch:** 200 Coins or 1 rewarded ad.
- **Ad Deferral:** Interstitial ads strictly deferred after milestone rewards or bonus rounds.

## Affected Files
- `lib/features/economy/data/reward_service.dart` (changed: add Phase 4 chest and level tags)

## Risks
None. Economy parameters conform to `SHARED_CORE_STANDARD.md` §6.

## Open Questions
None.
