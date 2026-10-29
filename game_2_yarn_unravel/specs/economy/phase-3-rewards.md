Source docs: phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/piggy-bank-and-cosmetics.md.

# Spec: Economy — Phase 3 Rewards & Economy Invariants

## Status
Draft

## Type
New Feature

## Goal
Specify the economic rewards, coin inflows, Craft Baskets, Level 1500 Grand Sewing Chest, Golden Bobbin Rush bonus rounds, and monetization invariants for Yarn Unravel Phase 3 (Levels 1001–1500).

## Current State
Design documented in `phase/phase_3/05_REWARDS_AND_ECONOMY_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Phase 2 established the 300-coin Craft Basket schedule and ₹49 Knitted Piggy Bank in `specs/economy/piggy-bank-and-cosmetics.md`.
- Phase 3 extends this economic framework into Levels 1001–1500 with strict mathematical budget adherence.

## Proposed Change
Implement Phase 3 reward mappings in `lib/features/economy/`:

### 1. Level Completion Coins & First Win Bonuses
Rewards awarded strictly upon first clear (replays award 0 coins):
- **Easy Levels (x5 breather):** 15 Coins.
- **Normal Levels (x1 intro, x2–x4 practice, x6–x8 ramp, x0 milestone):** 20 Coins.
- **Hard Levels (x9):** 30 Coins.
- **Phase Finale (L1500):** 50 Coins.
- **First ★★★ Clear Bonus:** +20 Coins across all levels.
- **2X Win (Rewarded Ad):** Doubles the base clear coins on first win (e.g. Hard level 30 Coins -> 60 Coins).

### 2. Craft Basket (Gift Box) Schedule
- **Trigger:** Awarded on first clear of every milestone level ending in 0 (L1010, 1020 … 1490, total 49 times).
- **Contents:** **300 Coins** + 1 free booster.
- **Rotating Booster Formula:** `(Level / 10) mod 3`:
  - Result `1`: **1 Needle Glow Hint** (e.g. L1010, 1040, 1070 …)
  - Result `2`: **1 Golden Scissors** (e.g. L1020, 1050, 1080 …)
  - Result `0`: **1 Thimble Shield** (e.g. L1030, 1060, 1090 …)

### 3. Level 1500 Grand Sewing Chest (Phase Chest)
Awarded upon clearing Level 1500 "Day & Night Tapestry" (replaces standard Craft Basket):
- **1,000 Coins**
- **2 Needle Glow Hints**
- **2 Thimble Shields**
- **2 Golden Scissors**
- **Phase 3 Profile Badge:** "Master of the Loom"

### 4. Golden Bobbin Rush (Coin Rush Bonus Rounds)
- **Schedule:** Triggers upon first clear every 25 levels (L1025, 1050, 1075 … 1500, total 20 bonus rounds).
- **Rules:** 30-second timer, 30 isolated threads on 10×10 board.
- **Payout:** 10 Coins per thread unpicked + 100 Coins full clear bonus = maximum **400 Coins**.

### 5. Economy Invariants & Sinks
- **Booster Shop Prices (unchanged):**
  - Needle Glow Hint: 60 Coins (3-pack: 150)
  - Thimble Shield: 80 Coins (3-pack: 200)
  - Golden Scissors: 100 Coins (3-pack: 250)
- **Heart Refill:** 120 Coins (only inside "Tangled Up!" Second Chance modal; maximum 2 refills per attempt).
- **Darning Patch (Streak Saver):** 200 Coins or 1 rewarded ad.
- **Ad Deferral:** Interstitial ads are never shown immediately following Craft Baskets, Phase Chests, or Golden Bobbin Rush wins; deferred to subsequent standard wins.

## Affected Files
- `lib/features/economy/data/reward_service.dart` (changed: configure Phase 3 chest and level tags)
- `lib/features/economy/models/reward_bundle.dart` (changed: Phase 3 milestone grants)

## Risks
- Rapid coin accumulation devaluing booster purchases. Mitigated by Wardrobe cosmetic sinks (800–4,000 Coins) absorbing surplus coin inflow.

## Open Questions
None. All reward quantities and booster schedules match `SHARED_CORE_STANDARD.md` §6.
