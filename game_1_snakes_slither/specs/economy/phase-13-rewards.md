Source docs: phases/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §8. Depends on: specs/gameplay/phase-13-level-plan-06001-06500.md, specs/economy/phase-12-rewards.md.

# Spec: Economy — Phase 13 Rewards and Progression

## Status
Draft

## Type
New Feature

## Goal
Specify the economy, coin reward structures, booster distribution, milestone gift baskets, Golden Slither Rush events, and the Level 6,500 Grand Finale Chest for Phase 13 (Levels 6001–6500).

## Current State
Design documented in `phases/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md`, `phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Payouts conform to standard per-level coin formulas.
- Phase 13 features 49 milestone gift baskets, 20 Golden Slither Rush rounds in misty environments, and the "Phantom Mist Walker" Phase Finale pack.

## Proposed Change
Implement Phase 13 economy configuration and reward tables in `packages/puzzle_core/lib/src/economy/phase_13/`:

### 1. Per-Level Coin Reward Schedule

| Level Type | Slot / Pattern | Base Coins | First-Time 3-Star Bonus | Total Maximum (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 | +20 | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 | +20 | **40 Coins** |
| **Hard Level** | Slot 9 (every x9 level) | 30 | +20 | **50 Coins** |
| **Milestone Gate** | Slot 10 (every x0 level) | 35 | +20 | **55 Coins** |
| **Phase Finale** | Level 6500 | 50 | +50 | **100 Coins** |

- **Replay Reward:** Fixed at 20% of base coins (4 coins for Normal level); 0 boosters or star bonus re-awarded.

---

### 2. Milestone Gift Baskets (Every x0 Level)
- **Cadence:** Awarded at the end of every block (Levels 6010, 6020, 6030 ... 6490), totaling **49 Gift Baskets**.
- **Fixed Coins:** 300 Coins per basket ($49 \times 300 = 14{,}700\text{ Coins}$).
- **Power-Up Booster Rotation:**
  - Round $3k + 1$ (6010, 6040, 6070...): **Hint Booster**
  - Round $3k + 2$ (6020, 6050, 6080...): **Shield Booster**
  - Round $3k + 0$ (6030, 6060, 6090...): **Hammer Booster**

---

### 3. Golden Slither Rush (Every 25 Levels)
- **Cadence:** Levels 6025, 6050, 6075 ... 6500 (total **20 events**).
- **Format:** 30-second rapid-untangle event featuring 30 golden snakes in a misty arena.
- **Payout:** 5 coins per freed golden snake (up to 150 coins) + 100 coin Perfect Clear bonus = **250 Coins max per event**.
- **Phase Rush Potential:** $20 \times 250 = \mathbf{5{,}000\text{ Coins}}$.

---

### 4. Grand Finale Chest (Level 6500)
Unlocked upon clearing Level 6500:
- **Currency:** **1,000 Coins**.
- **Booster Bundle:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **Cosmetics & Prestige:**
  - Permanent profile badge: **"Phantom Mist Walker"**.
  - Animated cosmetic snake skin: **Ghost Fog Skin / Trail** (trailing phantom vapor and misty embers).
  - Immediate unlock flag for Phase 14 (Pond Reflections: Mirror Worlds / Magma Chambers).

---

### 5. Aggregate Phase 13 Inflow & Sinks
- **Total Inflow (First Clear ★★★):**
  - Base Levels (6001–6500): ~20,500 Coins
  - 49 Milestone Baskets: 14,700 Coins
  - 20 Slither Rush Events: 5,000 Coins
  - Finale Chest: 1,000 Coins
  - **Phase Total:** **~41,200 Coins**
- **In-Game Sinks:**
  - Extra Moves (+5 moves): 100 Coins
  - Hint Booster: 150 Coins
  - Shield Booster: 200 Coins
  - Hammer Booster: 250 Coins
  - Lantern of Truth: 120 Coins (reveals all fog for 3 turns)

## Affected Files
- `packages/puzzle_core/lib/src/economy/phase_13/phase_13_economy_config.dart` (to be created)
- `packages/puzzle_core/lib/src/economy/phase_13/phase_13_milestone_rewards.dart` (to be created)
- `test/economy/phase_13_economy_test.dart` (to be created)

## Risks and Open Questions
- **Lantern of Truth Item Integration:** The "Lantern of Truth" serves as a specialized thematic consumable (120 coins). Economy telemetry must verify whether it cannibalizes standard Hint Booster sales.
