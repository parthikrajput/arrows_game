# Spec: Phase 16 Economy & Rewards — Royal Keyring (Levels 7501–8000)

Source docs: phase/phase_16/05_REWARDS_AND_ECONOMY_PHASE_16.md, phase/phase_16/02_LEVEL_PLAN_7501_8000.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-16-level-plan-07501-08000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 Economy & Rewards — Royal Keyring |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Royal Honey Chest rewards, Golden Nectar Rush rounds, and economic balance projections for Phase 16 (Levels 7501–8000).

---

## Current State

Design documented in `phase/phase_16/05_REWARDS_AND_ECONOMY_PHASE_16.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L8000 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L7510, L7520, L7530 … L7990) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L8000 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Master Keywright"** profile badge
- **Unlocked feature:** Phase 16 completion flag (`maxPhase = 16`).

### Golden Nectar Rush
- **Trigger:** Every 25 levels (L7525, L7550 … L8000) — 20 rounds total.
- **Duration:** 30 seconds timer.
- **Grid:** 30 lines frenzied mini-board.
- **Payout:** 10 coins per cleared line + 100 coins all-clear completion bonus (max 400 coins per rush).

### Projected Inflow for Phase 16

| Source | Count | Rate | Total Coins |
|---|---|---|---|
| Level Clears (Base) | 500 levels | Avg ~21 | ~10,500 |
| First ★★★ Bonuses | 500 levels | 20 | 10,000 |
| Queen's Gift Boxes | 49 boxes | 300 | 14,700 |
| Golden Nectar Rush | 20 rounds | Avg ~387 | ~7,750 |
| L8000 Royal Honey Chest | 1 chest | 1,000 | 1,000 |
| **Total Inflow** | | | **~43,950** |

### Projected Outflow & Sinks
- **Garden Wardrobe Additions:** "Royal Keywright" and "Golden Crest" skins (2,500–4,000 coins).
- **Heart Refills:** 120 coins per refill.
- **Booster Shop Purchases:** Hint 60 coins, Shield 80 coins, Leaf Blower 100 coins.

---

## Verification Plan

### Automated Tests
1. Verify 49 Queen's Gift Boxes award exactly 300 coins and correct booster mod formula.
2. Verify L8000 awards exactly 1,000 coins, 2 of each booster, and "Master Keywright" badge.
3. Verify total coin inflow test across 500 levels yields 43,950 ± 100 coins.

### Manual Verification
1. Reach L7510 and check Gift Box popup contents.
2. Complete L8000, verify badge appears in Player Profile, and verify Royal Honey Chest opening animation.
