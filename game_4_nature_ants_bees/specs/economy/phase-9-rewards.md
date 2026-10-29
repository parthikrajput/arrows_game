# Spec: Phase 9 Economy & Rewards — Swarm Splits (Levels 4001–4500)

Source docs: phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md, phase/phase_9/02_LEVEL_PLAN_4001_4500.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-9-level-plan-04001-04500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 Economy & Rewards — Swarm Splits |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Define coin inflows, Queen's Gift Box milestones, Royal Honey Chest finale rewards, Golden Nectar Rush rounds, and economy balance projections for Phase 9 (Levels 4001–4500).

---

## Current State

Design documented in `phase/phase_9/05_REWARDS_AND_ECONOMY_PHASE_9.md`, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L4500 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L4010, L4020, L4030 … L4490) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L4500 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Swarm Conductor"** exclusive cosmetic profile badge

### Golden Nectar Rush
- Unlocks every 25 levels: L4025, L4050, L4075 … L4500 (20 rounds total).
- Format: 30-second frenzy board with 30 lines; 10 coins per line cleared + 100 bonus for full completion.
- Maximum possible Rush inflow per round: 400 coins.

### Economy Projection

| Source | Amount |
|---|---|
| 500 First Clears (mix of 15/20/30/50) | ~10,450 coins |
| First ★★★ Clear Bonuses (est. 60% of 500) | ~6,000 coins |
| 49 Queen's Gift Boxes (300 coins each) | 14,700 coins |
| 20 Golden Nectar Rush rounds (avg ~250 coins each) | ~5,000 coins |
| L4500 Royal Honey Chest | 1,000 coins |
| **Total Phase 9 Inflow** | **≈ 43,950 coins** |

### Economy Sinks

| Sink | Cost |
|---|---|
| Garden Wardrobe Phase 9 additions (Swarm & Caravan skins) | 2,500–4,000 coins |
| Honey Heart Refill | 120 coins per refill (max 2/attempt) |
| Booster restocks: Nectar Glow Hint | 60 coins |
| Booster restocks: Queen's Royal Shield | 80 coins |
| Booster restocks: Leaf Blower | 100 coins |

---

## Acceptance Criteria
- [ ] Exactly 49 Queen's Gift Boxes awarded at L4010–L4490 (x0 slots only).
- [ ] Booster rotation formula `(L/10) mod 3` applied correctly at each x0 level.
- [ ] L4500 Royal Honey Chest awards exactly: 1,000 coins + 2 of each booster + Swarm Conductor badge.
- [ ] 20 Golden Nectar Rush rounds unlock at correct level intervals (every 25 levels).
- [ ] "Swarm Conductor" badge is unique to Phase 9 finale.
- [ ] Total inflow for Phase 9 matches ≈ 43,950 coins projection.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/economy/lib/phase_9_rewards.dart` | To be created |
| `packages/economy/lib/gift_box_scheduler.dart` | Changed |
| `packages/economy/lib/golden_nectar_rush.dart` | Changed |
| `assets/badges/swarm_conductor_badge.png` | To be created |

---

## Risks and Open Questions

1. **Rush completion variance:** Player clear rates on 14x14 frenzy boards with split paths may lower average rush yield below 250 coins.
2. **Caravan wardrobe asset scope:** Exact skin variations for coupled caravans need final verification.
