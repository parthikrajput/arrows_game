Source docs: phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/economy/boosters-coins-shop.md, specs/economy/phase-3-rewards.md.

# Spec: Economy — Phase 9 Rewards & Inflow/Outflow Balance

## Status
Draft

## Type
New Feature

## Goal
Specify the Phase 9 economy parameters, milestone rewards, Craft Baskets, Level 4500 Grand Sewing Chest, Golden Bobbin Rush bonus rounds, and coin sinks for Yarn Unravel Levels 4001–4500 adhering strictly to SHARED_CORE_STANDARD §6.

## Current State
Design documented in `phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md`, not yet implemented.

## Proposed Change
Implement Phase 9 reward rules in `packages/puzzle_core` and `lib/features/economy`:

### 1. Inflow Rewards Structure
All monetary numbers conform exactly to SHARED_CORE_STANDARD §6:

| Inflow Source | Quantity / Rule | Frequency / Condition |
|---|---|---|
| **First Clear Coins** | Easy **15**, Normal **20**, Hard **30**, Finale **50** | Based on level tag; 0 on replay |
| **First ★★★ Bonus** | **+20 coins** | Granted once per level upon 3-star clear |
| **Craft Basket (Gift Box)** | **300 coins** + 1 rotating booster | Every x0 milestone (L4010, 4020 ... 4490, 49 total) |
| **Rotating Booster Formula** | `(Level / 10) mod 3`: 1 = Hint, 2 = Hammer, 0 = Shield | Dispatched inside Craft Basket |
| **Grand Sewing Chest** | **1,000 coins** + 2 Hints + 2 Shields + 2 Hammers + Phase 9 Master Badge | Granted upon clearing L4500 Finale |
| **Golden Bobbin Rush** | **10 coins / thread** (30 threads) + **100 coin full clear bonus** (Max 400 coins) | Every 25 levels (L4025, 4050 ... 4500, 20 rounds) |
| **2X Win (Rewarded Ad)** | Base clear coins $\times 2$ | Optional double on first clear screen |

### 2. Cumulative Phase 9 Currency Flow
- **Base Level Clears (500 levels):** $\approx 11,000$ Coins.
- **First ★★★ Completion (500 levels):** $10,000$ Coins.
- **49 Craft Baskets:** $14,700$ Coins + 49 Boosters (17 Needle Glow Hints, 16 Golden Scissors Hammers, 16 Thimble Shields).
- **20 Golden Bobbin Rush Events:** $\approx 7,000$ Coins.
- **Grand Sewing Chest (L4500):** $1,000$ Coins + 6 Boosters (2 of each type).
- **Total Phase Inflow Potential:** $\approx 43,700$ Coins + 55 Boosters.

### 3. Economy Sinks & Invariants
- **Booster Shop Pricing (Unchanged):**
  - Needle Glow Hint: 1-pack = 60 Coins, 3-pack = 150 Coins.
  - Thimble Shield: 1-pack = 80 Coins, 3-pack = 200 Coins.
  - Golden Scissors: 1-pack = 100 Coins, 3-pack = 250 Coins.
- **Second Chance Refill:** 120 Coins (max 2 refills per level attempt).
- **Darning Patch (Streak Save):** 200 Coins or 1 rewarded ad.
- **Interstitial Ad Deferral Rule:** Completing a Craft Basket milestone (x0), a Golden Bobbin Rush bonus round, or Daily Stitch suppresses the standard interstitial ad; ad eligibility is deferred to the subsequent standard level victory.

## Affected Files
- `lib/features/economy/data/phase_9_rewards.dart` (to be created: milestone grant table)
- `lib/features/gameplay/bloc/gameplay_cubit.dart` (changed: reward trigger for L4500 Finale chest)

## Risks
- None. Fully adheres to core economy invariants.

## Open Questions
None. All currency and booster values match SHARED_CORE_STANDARD §6.
