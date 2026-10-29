# Spec: Phase 13 Economy & Rewards — Mystery Meadow (Levels 6001–6500)

Source docs: phase/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md, phase/phase_13/02_LEVEL_PLAN_6001_6500.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-13-level-plan-06001-06500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 Economy & Rewards — Mystery Meadow |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Royal Honey Chest rewards, Golden Nectar Rush rounds, and economic balance projections for Phase 13 (Levels 6001–6500).

---

## Current State

Design documented in `phase/phase_13/05_REWARDS_AND_ECONOMY_PHASE_13.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L6500 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L6010, L6020, L6030 … L6490) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L6500 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Meadow Clairvoyant"** exclusive cosmetic profile badge

### Golden Nectar Rush
- Unlocks every 25 levels: L6025, L6050, L6075 … L6500 (20 rounds total).
- Format: 30-second frenzy board with 30 lines; 10 coins per line cleared + 100 bonus for full completion.
- Maximum possible Rush inflow per round: 400 coins.

### Economy Projection

| Source | Amount |
|---|---|
| 500 First Clears (mix of 15/20/30/50) | ~10,450 coins |
| First ★★★ Clear Bonuses (est. 60% of 500) | ~6,000 coins |
| 49 Queen's Gift Boxes (300 coins each) | 14,700 coins |
| 20 Golden Nectar Rush rounds (avg ~250 coins each) | ~5,000 coins |
| L6500 Royal Honey Chest | 1,000 coins |
| **Total Phase 13 Inflow** | **≈ 43,950 coins** |

### Economy Sinks

| Sink | Cost |
|---|---|
| Garden Wardrobe Phase 13 additions (Mist & Clairvoyant skins) | 2,500–4,000 coins |
| Honey Heart Refill | 120 coins per refill (max 2/attempt) |
| Booster restocks: Nectar Glow Hint | 60 coins |
| Booster restocks: Queen's Royal Shield | 80 coins |
| Booster restocks: Leaf Blower | 100 coins |

---

## Acceptance Criteria
- [ ] Exactly 49 Queen's Gift Boxes awarded at L6010–L6490 (x0 slots only).
- [ ] Booster rotation formula `(L/10) mod 3` applied correctly at each x0 level.
- [ ] L6500 Royal Honey Chest awards 1,000 coins + 2 each of the 3 boosters + Meadow Clairvoyant badge.
- [ ] 20 Golden Nectar Rush rounds unlock at correct 25-level intervals.
- [ ] "Meadow Clairvoyant" badge is unique to Phase 13 finale.
- [ ] Total inflow for Phase 13 matches ≈ 43,950 coins projection.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/economy/lib/phase_13_rewards.dart` | To be created |
| `packages/economy/lib/gift_box_scheduler.dart` | Changed |
| `packages/economy/lib/golden_nectar_rush.dart` | Changed |
| `assets/badges/meadow_clairvoyant_badge.png` | To be created |

---

## Risks and Open Questions

1. **Rush Rounds with Fog:** Ensure Golden Nectar Rush boards contain minimal or zero fog to preserve the rapid 30-second reflex challenge.
