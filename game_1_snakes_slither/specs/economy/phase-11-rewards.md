Source docs: phases/phase_11/05_REWARDS_AND_ECONOMY_PHASE_11.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §8. Depends on: specs/gameplay/phase-11-level-plan-05001-05500.md, specs/economy/phase-10-rewards.md.

# Spec: Economy — Phase 11 Rewards and Progression

## Status
Draft

## Type
New Feature

## Goal
Define the economy, coin payout curves, booster distribution, milestone gift baskets, dual-pond Golden Slither Rush events, and the Level 5500 Grand Finale Chest for Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phases/phase_11/05_REWARDS_AND_ECONOMY_PHASE_11.md`, `phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Payouts conform to standard per-level coin formulas.
- Phase 11 features 49 milestone gift baskets, 20 Golden Slither Rush rounds spanning both ponds, and the "Dual Pond Master" Phase Finale package.

## Proposed Change
Implement Phase 11 economy configurations and rewards handlers in `packages/puzzle_core/lib/src/economy/phase_11/`:

### 1. Per-Level Coin Reward Schedule

| Level Type | Slot / Pattern | Base Coins | First-Time 3-Star Bonus | Total Maximum (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 | +20 | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 | +20 | **40 Coins** |
| **Hard Level** | Slot 9 (every x9 level) | 30 | +20 | **50 Coins** |
| **Milestone Gate** | Slot 10 (every x0 level) | 35 | +20 | **55 Coins** |
| **Phase Finale** | Level 5500 | 50 | +50 | **100 Coins** |

- **Replay Reward:** Fixed at 20% of base coins (4 coins for Normal level); 0 boosters or star bonus re-awarded.

---

### 2. Milestone Gift Baskets (Every x0 Level)
- **Cadence:** Awarded at the end of every block (Levels 5010, 5020, 5030 ... 5490), totaling **49 Gift Baskets**.
- **Fixed Currency:** 300 Coins per basket ($49 \times 300 = 14{,}700\text{ Coins}$).
- **Power-Up Booster Rotation:**
  - Round $3k + 1$ (5010, 5040, 5070...): **Hint Booster**
  - Round $3k + 2$ (5020, 5050, 5080...): **Shield Booster**
  - Round $3k + 0$ (5030, 5060, 5090...): **Hammer Booster**

---

### 3. Golden Slither Rush (Every 25 Levels)
- **Cadence:** Levels 5025, 5050, 5075 ... 5500 (total **20 events**).
- **Format:** 30-second rapid-untangle event featuring 30 golden snakes distributed across both mini-boards.
- **Payout:** 5 coins per freed golden snake (up to 150 coins) + 100 coin Perfect Clear bonus = **250 Coins max per event**.
- **Phase Rush Potential:** $20 \times 250 = \mathbf{5{,}000\text{ Coins}}$.

---

### 4. Grand Finale Chest (Level 5500)
Unlocked upon clearing Level 5500:
- **Currency:** **1,000 Coins**.
- **Booster Bundle:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **Cosmetics & Prestige:**
  - Permanent profile badge: **"Dual Pond Master" (Mirror Marsh Sovereign)**.
  - Animated cosmetic snake skin: **Water Lily Petal Skin / Trail**.
  - Immediate unlock flag for Phase 12 (Monsoon Winds: Gravity).

---

### 5. Aggregate Phase 11 Inflow & Sinks
- **Total Inflow (First Clear ★★★):**
  - Base Levels (5001–5500): ~20,500 Coins
  - 49 Milestone Baskets: 14,700 Coins
  - 20 Slither Rush Events: 5,000 Coins
  - Finale Chest: 1,000 Coins
  - **Phase Total:** **~41,200 Coins**
- **In-Game Sinks:**
  - Extra Moves (+5 moves): 100 Coins
  - Hint Booster: 150 Coins
  - Shield Booster: 200 Coins
  - Hammer Booster: 250 Coins
  - Bridge Swap Token: 120 Coins

## Affected Files
- `packages/puzzle_core/lib/src/economy/phase_11/phase_11_economy_config.dart` (to be created)
- `packages/puzzle_core/lib/src/economy/phase_11/phase_11_milestone_rewards.dart` (to be created)
- `test/economy/phase_11_economy_test.dart` (to be created)

## Risks and Open Questions
- **Economy Stability:** Total inflow of ~41,200 coins aligns with Phase 9 standard levels. Monitoring player booster purchase behavior when navigating cross-board dependencies.
