Source docs: phases/phase_14/05_REWARDS_AND_ECONOMY_PHASE_14.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §8. Depends on: specs/gameplay/phase-14-level-plan-06501-07000.md, specs/economy/phase-13-rewards.md.

# Spec: Economy — Phase 14 Rewards and Progression

## Status
Draft

## Type
New Feature

## Goal
Specify the economy, coin rewards, booster distribution, milestone gift baskets, Golden Slither Rush events, and the Level 7,000 Grand Finale Chest for Phase 14 (Levels 6501–7000).

## Current State
Design documented in `phases/phase_14/05_REWARDS_AND_ECONOMY_PHASE_14.md`, `phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Payouts conform to standard per-level coin formulas.
- Phase 14 features 49 milestone gift baskets, 20 Golden Slither Rush events across bilateral reflection boards, and the "Obsidian Mirror Sovereign" Phase Finale package.

## Proposed Change
Implement Phase 14 economy tables and payout handlers in `packages/puzzle_core/lib/src/economy/phase_14/`:

### 1. Per-Level Coin Reward Schedule

| Level Type | Slot / Pattern | Base Coins | First-Time 3-Star Bonus | Total Maximum (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 | +20 | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 | +20 | **40 Coins** |
| **Hard Level** | Slot 9 (every x9 level) | 30 | +20 | **50 Coins** |
| **Milestone Gate** | Slot 10 (every x0 level) | 35 | +20 | **55 Coins** |
| **Phase Finale** | Level 7000 | 50 | +50 | **100 Coins** |

- **Replay Reward:** Fixed at 20% of base coins (4 coins for Normal level); 0 boosters or star bonus re-awarded.

---

### 2. Milestone Gift Baskets (Every x0 Level)
- **Cadence:** Awarded at the end of every block (Levels 6510, 6520, 6530 ... 6990), totaling **49 Gift Baskets**.
- **Fixed Currency:** 300 Coins per basket ($49 \times 300 = 14{,}700\text{ Coins}$).
- **Power-Up Booster Rotation:**
  - Round $3k + 1$ (6510, 6540, 6570...): **Hint Booster**
  - Round $3k + 2$ (6520, 6550, 6580...): **Shield Booster**
  - Round $3k + 0$ (6530, 6560, 6590...): **Hammer Booster**

---

### 3. Golden Slither Rush (Every 25 Levels)
- **Cadence:** Levels 6525, 6550, 6575 ... 7000 (total **20 events**).
- **Format:** 30-second rapid-untangle event featuring 30 golden snakes distributed symmetrically across the reflection axis.
- **Payout:** 5 coins per freed golden snake (up to 150 coins) + 100 coin Perfect Clear bonus = **250 Coins max per event**.
- **Phase Rush Potential:** $20 \times 250 = \mathbf{5{,}000\text{ Coins}}$.

---

### 4. Grand Finale Chest (Level 7000)
Unlocked upon clearing Level 7000:
- **Currency:** **1,000 Coins**.
- **Booster Bundle:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **Cosmetics & Prestige:**
  - Permanent profile badge: **"Obsidian Mirror Sovereign"**.
  - Animated cosmetic snake skin: **Prism Mirror Skin / Trail** (crystal refraction glints and mirror glimmers).
  - Immediate unlock flag for Phase 15 (River Delta: Conveyors & Tracks).

---

### 5. Aggregate Phase 14 Inflow & Sinks
- **Total Inflow (First Clear ★★★):**
  - Base Levels (6501–7000): ~20,500 Coins
  - 49 Milestone Baskets: 14,700 Coins
  - 20 Slither Rush Events: 5,000 Coins
  - Finale Chest: 1,000 Coins
  - **Phase Total:** **~41,200 Coins**
- **In-Game Sinks:**
  - Extra Moves (+5 moves): 100 Coins
  - Hint Booster: 150 Coins
  - Shield Booster: 200 Coins
  - Hammer Booster: 250 Coins
  - Mirror Decouple Token: 120 Coins (decouples pair for 1 independent move)

## Affected Files
- `packages/puzzle_core/lib/src/economy/phase_14/phase_14_economy_config.dart` (to be created)
- `packages/puzzle_core/lib/src/economy/phase_14/phase_14_milestone_rewards.dart` (to be created)
- `test/economy/phase_14_economy_test.dart` (to be created)

## Risks and Open Questions
- **Mirror Decouple Token Balancing:** Allowing players to decouple mirror pairs for 120 coins could bypass critical puzzle mechanics if overused. The token must be restricted to non-milestone levels (disallowed on x9 Hard and Finale levels).
