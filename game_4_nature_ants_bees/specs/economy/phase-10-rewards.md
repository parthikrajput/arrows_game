# Spec: Phase 10 Economy & Rewards — Garden Rhythm (Levels 4501–5000)

Source docs: phase/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md, phase/phase_10/02_LEVEL_PLAN_4501_5000.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-10-level-plan-04501-05000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 Economy & Rewards — Garden Rhythm |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define all coin earnings, Queen's Gift Box milestones, Royal Honey Chest rewards, Golden Nectar Rush pacing, and balance projections for Phase 10 (Levels 4501–5000).

---

## Current State

Design documented in `phase/phase_10/05_REWARDS_AND_ECONOMY_PHASE_10.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L5000 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L4510, L4520, L4530 … L4990) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L5000 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Rhythm Maestro"** exclusive cosmetic profile badge

### Golden Nectar Rush
- Unlocks every 25 levels: L4525, L4550, L4575 … L5000 (20 rounds total).
- Format: 30-second frenzy board with 30 lines; 10 coins per line cleared + 100 bonus for full completion.
- Maximum possible Rush inflow per round: 400 coins.

### Economy Projection

| Source | Amount |
|---|---|
| 500 First Clears (mix of 15/20/30/50) | ~10,450 coins |
| First ★★★ Clear Bonuses (est. 60% of 500) | ~6,000 coins |
| 49 Queen's Gift Boxes (300 coins each) | 14,700 coins |
| 20 Golden Nectar Rush rounds (avg ~250 coins each) | ~5,000 coins |
| L5000 Royal Honey Chest | 1,000 coins |
| **Total Phase 10 Inflow** | **≈ 43,950 coins** |

### Economy Sinks

| Sink | Cost |
|---|---|
| Garden Wardrobe Phase 10 additions (Symphony & Musical skins) | 2,500–4,000 coins |
| Honey Heart Refill | 120 coins per refill (max 2/attempt) |
| Booster restocks: Nectar Glow Hint | 60 coins |
| Booster restocks: Queen's Royal Shield | 80 coins |
| Booster restocks: Leaf Blower | 100 coins |

---

## Acceptance Criteria
- [ ] Exactly 49 Queen's Gift Boxes awarded at L4510–L4990 (x0 slots only).
- [ ] Booster rotation formula `(L/10) mod 3` applied correctly at each x0 level.
- [ ] L5000 Royal Honey Chest awards 1,000 coins + 2 each of the 3 boosters + Rhythm Maestro badge.
- [ ] 20 Golden Nectar Rush rounds unlock at correct 25-level intervals.
- [ ] "Rhythm Maestro" badge is unique to Phase 10 finale.
- [ ] Total inflow for Phase 10 matches ≈ 43,950 coins projection.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/economy/lib/phase_10_rewards.dart` | To be created |
| `packages/economy/lib/gift_box_scheduler.dart` | Changed |
| `packages/economy/lib/golden_nectar_rush.dart` | Changed |
| `assets/badges/rhythm_maestro_badge.png` | To be created |

---

## Risks and Open Questions

1. **Mid-Game Milestone bonus:** Verify whether reaching L5000 triggers any special global achievement coin payout outside the standard 1,000-coin chest.
