Source docs: phases/phase_12/05_REWARDS_AND_ECONOMY_PHASE_12.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §8. Depends on: specs/gameplay/phase-12-level-plan-05501-06000.md, specs/economy/phase-11-rewards.md.

# Spec: Economy — Phase 12 Rewards and Progression

## Status
Draft

## Type
New Feature

## Goal
Specify the economy, coin rewards, booster payouts, milestone gift baskets, Golden Slither Rush events, and the Level 6,000 Grand Finale Chest for Phase 12 (Levels 5501–6000).

## Current State
Design documented in `phases/phase_12/05_REWARDS_AND_ECONOMY_PHASE_12.md`, `phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Payouts conform to standard per-level coin formulas.
- Phase 12 introduces 49 milestone gift baskets, 20 Golden Slither Rush events, and the "Monsoon Tempest Sovereign" Phase Finale reward pack.

## Proposed Change
Implement Phase 12 economy configuration and payout tables in `packages/puzzle_core/lib/src/economy/phase_12/`:

### 1. Per-Level Coin Reward Schedule

| Level Type | Slot / Pattern | Base Coins | First-Time 3-Star Bonus | Total Maximum (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 | +20 | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 | +20 | **40 Coins** |
| **Hard Level** | Slot 9 (every x9 level) | 30 | +20 | **50 Coins** |
| **Milestone Gate** | Slot 10 (every x0 level) | 35 | +20 | **55 Coins** |
| **Phase Finale** | Level 6000 | 50 | +50 | **100 Coins** |

- **Replay Reward:** Fixed at 20% of base coins (4 coins for Normal level); 0 boosters or star bonus re-awarded.

---

### 2. Milestone Gift Baskets (Every x0 Level)
- **Cadence:** Awarded at the end of every block (Levels 5510, 5520, 5530 ... 5990), totaling **49 Gift Baskets**.
- **Fixed Coins:** 300 Coins per basket ($49 \times 300 = 14{,}700\text{ Coins}$).
- **Power-Up Booster Rotation:**
  - Round $3k + 1$ (5510, 5540, 5570...): **Hint Booster**
  - Round $3k + 2$ (5520, 5550, 5580...): **Shield Booster**
  - Round $3k + 0$ (5530, 5560, 5590...): **Hammer Booster**

---

### 3. Golden Slither Rush (Every 25 Levels)
- **Cadence:** Levels 5525, 5550, 5575 ... 6000 (total **20 events**).
- **Format:** 30-second rapid-untangle event featuring 30 golden snakes.
- **Payout:** 5 coins per freed golden snake (up to 150 coins) + 100 coin Perfect Clear bonus = **250 Coins max per event**.
- **Phase Rush Potential:** $20 \times 250 = \mathbf{5{,}000\text{ Coins}}$.

---

### 4. Grand Finale Chest (Level 6000)
Unlocked upon clearing Level 6000:
- **Currency:** **1,000 Coins**.
- **Booster Bundle:**
  - 2x Hint Boosters
  - 2x Shield Boosters
  - 2x Hammer Boosters
- **Cosmetics & Prestige:**
  - Permanent profile badge: **"Monsoon Tempest Sovereign"**.
  - Animated cosmetic snake skin: **Storm Lightning Skin / Trail** (crackling electrical aura and storm mist).
  - Immediate unlock flag for Phase 13 (Mystery Mists: Hidden Info).

---

### 5. Aggregate Phase 12 Inflow & Sinks
- **Total Inflow (First Clear ★★★):**
  - Base Levels (5501–6000): ~20,500 Coins
  - 49 Milestone Baskets: 14,700 Coins
  - 20 Slither Rush Events: 5,000 Coins
  - Finale Chest: 1,000 Coins
  - **Phase Total:** **~41,200 Coins**
- **In-Game Sinks:**
  - Extra Moves (+5 moves): 100 Coins
  - Hint Booster: 150 Coins
  - Shield Booster: 200 Coins
  - Hammer Booster: 250 Coins
  - Anti-Grav Feather: 120 Coins

## Affected Files
- `packages/puzzle_core/lib/src/economy/phase_12/phase_12_economy_config.dart` (to be created)
- `packages/puzzle_core/lib/src/economy/phase_12/phase_12_milestone_rewards.dart` (to be created)
- `test/economy/phase_12_economy_test.dart` (to be created)

## Risks and Open Questions
- **Move Sink Consumption:** Because M551 Wind Lever activations consume a move, players may encounter tighter turn budgets, increasing the demand for Extra Moves (100 coins). The level generator must award $+3\text{--}6$ buffer moves on high-lever puzzles to keep gameplay fair and skill-based.
