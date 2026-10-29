Source docs: phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md, ../../SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-19-level-plan-09001-09500.md.

# Spec: Economy — Phase 19 Rewards & Economy

## Status
Draft

## Type
New Feature

## Goal
Specify the coin flow, Craft Basket milestone rewards, Grand Sewing Chest payouts, and Golden Bobbin Rush bonus rules for Phase 19 (Levels 9001–9500).

## Current State
Documented in `phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md`, adhering to `SHARED_CORE_STANDARD.md` §6.

## Proposed Change
Implement Phase 19 reward structures in `packages/puzzle_core` and `packages/economy`:

### 1. Economy Numbers Summary
All values are strictly aligned with `SHARED_CORE_STANDARD.md` §6:

| Source | Reward Value | Conditions / Trigger Frequency |
|---|---|---|
| **First Clear Coins** | Easy **15**, Normal **20**, Hard **30**, Finale **50** | Per level `tag`; replay awards 0 |
| **First ★★★ Bonus** | **+20 coins** | One-time bonus per level |
| **Craft Basket (Gift Box)** | **300 coins** + 1 rotating booster | Every x0 milestone (L9010, 9020 … 9490; 49 times total) |
| **Rotating Booster Rule** | `(Level / 10) mod 3`: 1 = Hint, 2 = Hammer, 0 = Shield | Awarded inside Craft Basket |
| **Grand Sewing Chest** | **1,000 coins** + 2 Hints + 2 Shields + 2 Hammers + Phase 19 Badge | Level 9500 Phase Finale clear |
| **Golden Bobbin Rush** | **10 coins/thread** (30 threads) + **100 full clear** ⇒ Max 400 coins | Every 25 levels (L9025, 9050 … 9500; 20 times total) |
| **2X Win (Rewarded Ad)** | Base clear coins × 2 | Available exclusively on first clear |

### 2. Phase 19 Coin Inflow Potential
- Base clears (500 levels): $\approx 11,000$ coins.
- First ★★★ bonus (500 levels): 10,000 coins.
- 49 Craft Baskets: 14,700 coins + 49 boosters (17 Hints, 16 Hammers, 16 Shields).
- 20 Golden Bobbin Rush rounds: $\approx 7,000$ coins.
- Grand Sewing Chest (L9500): 1,000 coins + 6 boosters.
- Total Phase 19 coin potential: $\approx 43,700$ coins + 55 boosters.

### 3. Sinks and Invariants
- Booster purchase pricing: Hint (60 / 150), Shield (80 / 200), Scissors/Hammer (100 / 250).
- Heart refill: 120 coins (Second Chance only; max 2 per attempt).
- Darning patch: 200 coins or 1 rewarded ad.
- Ad Deferral Rule: Interstitial ads are never shown immediately following a Craft Basket, Coin Rush, or Daily Stitch milestone win.

## Affected Files
- `packages/economy/lib/src/reward_calculator.dart` (changed: Phase 19 milestone payouts)
- `packages/economy/lib/src/models/chest_rewards.dart` (changed: Level 9500 Grand Sewing Chest data)

## Risks and Open Questions
- None. All numbers match `SHARED_CORE_STANDARD.md` §6.

