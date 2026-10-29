Source docs: phases/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md, phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §6, ../../SCALING_TO_10000_LEVELS.md §8. Depends on: specs/gameplay/phase-10-level-plan-04501-05000.md, specs/economy/phase-9-rewards.md.

# Spec: Economy — Phase 10 Rewards and Progression

## Status
Draft

## Type
New Feature

## Goal
Specify the economy, coin rewards, booster payouts, milestone gift baskets, Golden Slither Rush events, and the historic Level 5,000 Grand Halfway Milestone Chest for Phase 10 (Levels 4501–5000).

## Current State
Design documented in `phases/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md`, `phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §6, not yet implemented.
- Standard payouts follow the base economy schedule.
- Phase 10 marks the 50% project halfway point, featuring 49 milestone gift baskets, 20 Slither Rush events, and a premium 2,000-coin Grand Halfway Milestone Chest at Level 5000.

## Proposed Change
Implement Phase 10 economy tables and payout handlers in `packages/puzzle_core/lib/src/economy/phase_10/`:

### 1. Per-Level Coin Reward Schedule

| Level Type | Slot / Pattern | Base Coins | First-Time 3-Star Bonus | Total Maximum (1st Clear ★★★) |
| :--- | :--- | :---: | :---: | :---: |
| **Easy Level** | Slots 1, 2, 4 | 15 | +20 | **35 Coins** |
| **Normal Level** | Slots 3, 5, 6, 7, 8 | 20 | +20 | **40 Coins** |
| **Hard Level** | Slot 9 (every x9 level) | 30 | +20 | **50 Coins** |
| **Milestone Gate** | Slot 10 (every x0 level) | 35 | +20 | **55 Coins** |
| **Phase Finale & Halfway** | Level 5000 | 50 | +50 | **100 Coins** |

- **Replay Reward:** Fixed at 20% of base coins (4 coins for Normal level); 0 boosters or star bonus re-awarded.

---

### 2. Milestone Gift Baskets (Every x0 Level)
- **Cadence:** Awarded at the end of every 10-level block (Levels 4510, 4520, 4530 ... 4990), totaling **49 Gift Baskets**.
- **Fixed Coins:** 300 Coins per basket ($49 \times 300 = 14{,}700\text{ Coins}$).
- **Cycling Power-Up Booster:**
  - Round $3k + 1$ (4510, 4540, 4570...): **Hint Booster**
  - Round $3k + 2$ (4520, 4550, 4580...): **Shield Booster**
  - Round $3k + 0$ (4530, 4560, 4590...): **Hammer Booster**

---

### 3. Golden Slither Rush (Every 25 Levels)
- **Cadence:** Levels 4525, 4550, 4575 ... 5000 (total **20 events**).
- **Format:** 30-second rapid-untangle event featuring 30 golden snakes.
- **Payout:** 5 coins per freed golden snake (up to 150 coins) + 100 coin Perfect Clear bonus = **250 Coins max per event**.
- **Phase Rush Potential:** $20 \times 250 = \mathbf{5{,}000\text{ Coins}}$.

---

### 4. Grand Halfway Milestone Chest (Level 5000)
Unlocked upon clearing Level 5000 (celebrating completion of 5,000 levels):
- **Currency:** **2,000 Coins** (premium halfway milestone payout).
- **Booster Bundle:**
  - 3x Hint Boosters
  - 3x Shield Boosters
  - 3x Hammer Boosters
- **Cosmetics & Prestige:**
  - Golden profile badge: **"Halfway Grandmaster" (5,000 Levels Sovereign)**.
  - Animated cosmetic snake skin: **Tribal Drummer Skin / Trail** (drum beat ripples and golden musical notes).
  - Immediate unlock flag for Phase 11 (Two Ponds: Linked Boards).

---

### 5. Aggregate Phase 10 Inflow & Sinks
- **Total Inflow (First Clear ★★★):**
  - Base Levels (4501–5000): ~20,500 Coins
  - 49 Milestone Baskets: 14,700 Coins
  - 20 Slither Rush Events: 5,000 Coins
  - Halfway Grand Chest: 2,000 Coins
  - **Phase Total:** **~42,200 Coins**
- **In-Game Sinks:**
  - Extra Moves (+5 moves): 100 Coins
  - Hint Booster: 150 Coins
  - Shield Booster: 200 Coins
  - Hammer Booster: 250 Coins
  - Rhythm Skip Token: 120 Coins

## Affected Files
- `packages/puzzle_core/lib/src/economy/phase_10/phase_10_economy_config.dart` (to be created)
- `packages/puzzle_core/lib/src/economy/phase_10/phase_10_milestone_rewards.dart` (to be created)
- `test/economy/phase_10_economy_test.dart` (to be created)

## Risks and Open Questions
- **Halfway Milestone Coin Surge:** Awarding 2,000 coins at Level 5000 represents the largest single chest in the game so far. Standard §6 confirms special milestone chests can scale up to 2,000 coins at major 5,000 intervals without breaking long-term monetization.
