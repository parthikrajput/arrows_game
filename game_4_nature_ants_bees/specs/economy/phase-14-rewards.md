# Spec: Phase 14 Economy & Rewards — Reflecting Pond (Levels 6501–7000)

Source docs: phase/phase_14/05_REWARDS_AND_ECONOMY_PHASE_14.md, phase/phase_14/02_LEVEL_PLAN_6501_7000.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-14-level-plan-06501-07000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 Economy & Rewards — Reflecting Pond |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Royal Honey Chest rewards, Golden Nectar Rush rounds, and economic balance projections for Phase 14 (Levels 6501–7000).

---

## Current State

Design documented in `phase/phase_14/05_REWARDS_AND_ECONOMY_PHASE_14.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L7000 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L6510, L6520, L6530 … L6990) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L7000 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Mirror Mirage Master"** exclusive cosmetic profile badge

### Golden Nectar Rush
- Unlocks every 25 levels: L6525, L6550, L6575 … L7000 (20 rounds total).
- Format: 30-second frenzy board with 30 lines; 10 coins per line cleared + 100 bonus for full completion.
- Maximum possible Rush inflow per round: 400 coins.

### Economy Projection

| Source | Amount |
|---|---|
| 500 First Clears (mix of 15/20/30/50) | ~10,450 coins |
| First ★★★ Clear Bonuses (est. 60% of 500) | ~6,000 coins |
| 49 Queen's Gift Boxes (300 coins each) | 14,700 coins |
| 20 Golden Nectar Rush rounds (avg ~250 coins each) | ~5,000 coins |
| L7000 Royal Honey Chest | 1,000 coins |
| **Total Phase 14 Inflow** | **≈ 43,950 coins** |

### Economy Sinks

| Sink | Cost |
|---|---|
| Garden Wardrobe Phase 14 additions (Mirrored & Water Lily skins) | 2,500–4,000 coins |
| Honey Heart Refill | 120 coins per refill (max 2/attempt) |
| Booster restocks: Nectar Glow Hint | 60 coins |
| Booster restocks: Queen's Royal Shield | 80 coins |
| Booster restocks: Leaf Blower | 100 coins |

---

## Acceptance Criteria
- [ ] Exactly 49 Queen's Gift Boxes awarded at L6510–L6990 (x0 slots only).
- [ ] Booster rotation formula `(L/10) mod 3` applied correctly at each x0 level.
- [ ] L7000 Royal Honey Chest awards 1,000 coins + 2 each of the 3 boosters + Mirror Mirage Master badge.
- [ ] 20 Golden Nectar Rush rounds unlock at correct 25-level intervals.
- [ ] "Mirror Mirage Master" badge is unique to Phase 14 finale.
- [ ] Total inflow for Phase 14 matches ≈ 43,950 coins projection.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/economy/lib/phase_14_rewards.dart` | To be created |
| `packages/economy/lib/gift_box_scheduler.dart` | Changed |
| `packages/economy/lib/golden_nectar_rush.dart` | Changed |
| `assets/badges/mirror_mirage_master_badge.png` | To be created |

---

## Risks and Open Questions

1. **Badge Icon Visual Distinction:** Ensure Mirror Mirage Master badge uses a clean water-lily reflection emblem distinct from earlier Phase 13 Meadow Clairvoyant iconography.
