Source docs: phases/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §8. Depends on: specs/gameplay/phase-9-level-plan-04001-04500.md, specs/economy/phase-8-rewards.md.

# Spec: Economy — Phase 9 Rewards and Progression

## Status
Draft

## Type
New Feature

## Goal
Define the complete economy, coin reward structures, booster distribution, milestone gift baskets, Golden Slither Rush events, and Level 4500 Grand Finale Chest rewards for Phase 9 (Levels 4001–4500).

## Current State
Design documented in `phases/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md`, `phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Base economy conforms to standard per-level payout curves.
- Phase 9 introduces 49 milestone baskets, 20 Golden Slither Rush bonus events, and the "Twin Rivers Sovereign" Phase Finale reward pack.

## Proposed Change
Implement Phase 9 economy tables and payout triggers in `packages/puzzle_core/lib/src/economy/phase_9/`:

### 1. Per-Level Coin Reward Schedule

| Level Type | Slot / Pattern | Base Coins | First-Time 3-Star Bonus | Total Maximum (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 | +20 | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 | +20 | **40 Coins** |
| **Hard Level** | Slot 9 (every x9 level) | 30 | +20 | **50 Coins** |
| **Milestone Gate** | Slot 10 (every x0 level) | 35 | +20 | **55 Coins** |
| **Phase Finale** | Level 4500 | 50 | +50 | **100 Coins** |

- **Replay Reward:** Fixed at 20% of base coins (e.g., 4 coins for Normal level), with 0 boosters or star bonus re-awarded.

---

### 2. Milestone Gift Baskets (Every x0 Level)
- **Cadence:** Awarded at the conclusion of every block (Levels 4010, 4020, 4030 ... 4490), totaling **49 Gift Baskets**.
- **Fixed Coins:** 300 Coins per basket ($49 \times 300 = 14{,}700\text{ Coins}$).
- **Cycling Power-Up Booster:**
  - Round $3k + 1$ (4010, 4040, 4070...): **Hint Booster**
  - Round $3k + 2$ (4020, 4050, 4080...): **Shield Booster**
  - Round $3k + 0$ (4030, 4060, 4090...): **Hammer Booster**

---

### 3. Golden Slither Rush (Every 25 Levels)
- **Cadence:** Levels 4025, 4050, 4075 ... 4500 (total **20 events**).
- **Format:** 30-second rapid-untangle challenge featuring 30 golden snakes.
- **Payout:** 5 coins per freed golden snake (up to 150 coins) + 100 coin Perfect Clear bonus = **250 Coins max per event**.
- **Phase Rush Potential:** $20 \times 250 = \mathbf{5{,}000\text{ Coins}}$.

---

### 4. Grand Finale Chest (Level 4500)
Unlocked immediately upon clearing Level 4500:
- **Currency:** **1,000 Coins**.
- **Booster Bundle:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **Cosmetics & Prestige:**
  - Permanent profile badge: **"Twin Rivers Sovereign"**.
  - Animated cosmetic snake skin: **River Ripple Skin / Trail**.
  - Immediate unlock flag for Phase 10 (Jungle Drum Festival).

---

### 5. Aggregate Phase 9 Inflow & Sinks
- **Total Inflow (First Clear ★★★):**
  - Base Levels (4001–4500): ~20,500 Coins
  - 49 Milestone Baskets: 14,700 Coins
  - 20 Slither Rush Events: 5,000 Coins
  - Finale Chest: 1,000 Coins
  - **Phase Total:** **~41,200 Coins**
- **In-Game Sinks:**
  - Extra Moves (+5 moves): 100 Coins
  - Hint Booster: 150 Coins
  - Shield Booster: 200 Coins
  - Hammer Booster: 250 Coins
  - Splitter Bypass Key: 120 Coins

## Affected Files
- `packages/puzzle_core/lib/src/economy/phase_9/phase_9_economy_config.dart` (to be created)
- `packages/puzzle_core/lib/src/economy/phase_9/phase_9_milestone_rewards.dart` (to be created)
- `test/economy/phase_9_economy_test.dart` (to be created)

## Risks and Open Questions
- **Coin Accumulation Rate:** ~41,200 coins across 500 levels yields ~82 coins/level net. Economy sink calibration must monitor whether late-game booster stockpiling diminishes puzzle challenge.
