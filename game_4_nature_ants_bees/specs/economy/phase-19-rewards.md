# Spec: Phase 19 Economy & Rewards — Garden Festival II (Levels 9001–9500)

Source docs: phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md, phase/phase_19/02_LEVEL_PLAN_9001_9500.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-19-level-plan-09001-09500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 Economy & Rewards — Garden Festival II |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Royal Honey Chest rewards, Golden Nectar Rush rounds, and economic balance projections for Phase 19 (Levels 9001–9500).

---

## Current State

Design documented in `phase/phase_19/05_REWARDS_AND_ECONOMY_PHASE_19.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L9500 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L9010, L9020, L9030 … L9490) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L9500 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Master Composer"** profile badge
- **Unlocked feature:** Phase 19 completion flag (`maxPhase = 19`).

### Golden Nectar Rush
- **Trigger:** Every 25 levels (L9025, L9050 … L9500) — 20 rounds total.
- **Duration:** 30 seconds timer.
- **Grid:** 30 lines frenzied mini-board.
- **Payout:** 10 coins per cleared line + 100 coins all-clear completion bonus (max 400 coins per rush).

### Projected Inflow for Phase 19

| Source | Count | Rate | Total Coins |
|---|---|---|---|
| Level Clears (Base) | 500 levels | Avg ~21 | ~10,500 |
| First ★★★ Bonuses | 500 levels | 20 | 10,000 |
| Queen's Gift Boxes | 49 boxes | 300 | 14,700 |
| Golden Nectar Rush | 20 rounds | Avg ~387 | ~7,750 |
| L9500 Royal Honey Chest | 1 chest | 1,000 | 1,000 |
| **Total Inflow** | | | **~43,950** |

### Projected Outflow & Sinks
- **Garden Wardrobe Additions:** "Master Composer" and "Wind-dancer" skins (2,500–4,000 coins).
- **Heart Refills:** 120 coins per refill.
- **Booster Shop Purchases:** Hint 60 coins, Shield 80 coins, Leaf Blower 100 coins.

---

## Verification Plan

### Automated Tests
1. Verify 49 Queen's Gift Boxes award exactly 300 coins and correct rotating booster.
2. Verify L9500 awards exactly 1,000 coins, 2 of each booster, and "Master Composer" badge.
3. Verify total coin inflow test across 500 levels yields 43,950 ± 100 coins.

### Manual Verification
1. Reach L9010 and check Gift Box popup contents.
2. Complete L9500, verify badge appears in Player Profile, and verify Royal Honey Chest opening animation.
