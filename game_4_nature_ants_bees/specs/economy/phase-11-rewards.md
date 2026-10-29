# Spec: Phase 11 Economy & Rewards — Twin Gardens (Levels 5001–5500)

Source docs: phase/phase_11/05_REWARDS_AND_ECONOMY_PHASE_11.md, phase/phase_11/02_LEVEL_PLAN_5001_5500.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-11-level-plan-05001-05500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 Economy & Rewards — Twin Gardens |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Royal Honey Chest rewards, Golden Nectar Rush rounds, and economic balance projections for Phase 11 (Levels 5001–5500).

---

## Current State

Design documented in `phase/phase_11/05_REWARDS_AND_ECONOMY_PHASE_11.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L5500 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L5010, L5020, L5030 … L5490) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L5500 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Twin Realm Navigator"** exclusive cosmetic profile badge

### Golden Nectar Rush
- Unlocks every 25 levels: L5025, L5050, L5075 … L5500 (20 rounds total).
- Format: 30-second frenzy board with 30 lines; 10 coins per line cleared + 100 bonus for full completion.
- Maximum possible Rush inflow per round: 400 coins.

### Economy Projection

| Source | Amount |
|---|---|
| 500 First Clears (mix of 15/20/30/50) | ~10,450 coins |
| First ★★★ Clear Bonuses (est. 60% of 500) | ~6,000 coins |
| 49 Queen's Gift Boxes (300 coins each) | 14,700 coins |
| 20 Golden Nectar Rush rounds (avg ~250 coins each) | ~5,000 coins |
| L5500 Royal Honey Chest | 1,000 coins |
| **Total Phase 11 Inflow** | **≈ 43,950 coins** |

### Economy Sinks

| Sink | Cost |
|---|---|
| Garden Wardrobe Phase 11 additions (Twin Realm & Mirror skins) | 2,500–4,000 coins |
| Honey Heart Refill | 120 coins per refill (max 2/attempt) |
| Booster restocks: Nectar Glow Hint | 60 coins |
| Booster restocks: Queen's Royal Shield | 80 coins |
| Booster restocks: Leaf Blower | 100 coins |

---

## Acceptance Criteria
- [ ] Exactly 49 Queen's Gift Boxes awarded at L5010–L5490 (x0 slots only).
- [ ] Booster rotation formula `(L/10) mod 3` applied correctly at each x0 level.
- [ ] L5500 Royal Honey Chest awards 1,000 coins + 2 each of the 3 boosters + Twin Realm Navigator badge.
- [ ] 20 Golden Nectar Rush rounds unlock at correct 25-level intervals.
- [ ] "Twin Realm Navigator" badge is unique to Phase 11 finale.
- [ ] Total inflow for Phase 11 matches ≈ 43,950 coins projection.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/economy/lib/phase_11_rewards.dart` | To be created |
| `packages/economy/lib/gift_box_scheduler.dart` | Changed |
| `packages/economy/lib/golden_nectar_rush.dart` | Changed |
| `assets/badges/twin_realm_navigator_badge.png` | To be created |

---

## Risks and Open Questions

1. **Dual-Board Rush Pacing:** In Golden Nectar Rush rounds spanning two boards, ensuring lines are evenly split between boards to maintain a fast 30-second pacing without excessive camera panning.
