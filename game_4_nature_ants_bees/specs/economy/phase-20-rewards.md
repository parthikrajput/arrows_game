# Spec: Phase 20 Economy & Rewards — Grand Master Garden (Levels 9501–10,000)

Source docs: phase/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md, phase/phase_20/02_LEVEL_PLAN_9501_10000.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-20-level-plan-09501-10000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 Economy & Rewards — Grand Master Garden |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Grand Royal Honey Chest rewards, Golden Nectar Rush rounds, post-10K economy loops, and economic balance projections for Phase 20 (Levels 9501–10,000).

---

## Current State

Design documented in `phase/phase_20/05_REWARDS_AND_ECONOMY_PHASE_20.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Grand Finale L10,000 | 100 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L9510, L9520, L9530 … L9990) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Grand Royal Honey Chest — L10,000 Grand Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Eternal Hive Champion"** Exclusive Golden Profile Badge & Crown Flower Frame
- **Unlocked feature:** Permanent activation of **Endless Grand Mastery Mode** (`maxPhase = 20`, `p20_grand_mastery_active = true`).

### Golden Nectar Rush
- **Trigger:** Every 25 levels (L9525, L9550 … L10000) — 20 rounds total.
- **Duration:** 30 seconds timer.
- **Grid:** 30 lines frenzied mini-board.
- **Payout:** 10 coins per cleared line + 100 coins all-clear completion bonus (max 400 coins per rush).

### Projected Inflow for Phase 20

| Source | Count | Rate | Total Coins |
|---|---|---|---|
| Level Clears (Base) | 500 levels | Avg ~21 | ~10,550 |
| First ★★★ Bonuses | 500 levels | 20 | 10,000 |
| Queen's Gift Boxes | 49 boxes | 300 | 14,700 |
| Golden Nectar Rush | 20 rounds | Avg ~387 | ~7,750 |
| L10,000 Grand Royal Honey Chest | 1 chest | 1,000 | 1,000 |
| **Total Inflow** | | | **~44,000** |

### Projected Outflow & Sinks
- **Garden Wardrobe Ultimate Additions:**
  - *Queen's Eternal Regalia* skin (5,000 coins).
  - *Celestial Scout Bee Wings* cosmetic (4,500 coins).
  - *Golden Royal Ant Chariot* cosmetic (6,000 coins).
- **Heart Refills:** 120 coins per refill.
- **Booster Shop Purchases:** Hint 60 coins, Shield 80 coins, Leaf Blower 100 coins.
- **Post-10K Endless Prestige Garden:** Ongoing cosmetic prestige tiers and daily challenge entries.

---

## Verification Plan

### Automated Tests
1. Verify 49 Queen's Gift Boxes award exactly 300 coins and correct rotating booster.
2. Verify L10,000 awards exactly 100 clear coins, 1,000 chest coins, 2 of each booster, and "Eternal Hive Champion" badge.
3. Verify total coin inflow test across 500 levels yields 44,000 ± 100 coins.

### Manual Verification
1. Reach L9510 and check Gift Box popup contents.
2. Complete L10,000, verify Grand Finale chest opening sequence, and confirm badge and endless mode unlock.
