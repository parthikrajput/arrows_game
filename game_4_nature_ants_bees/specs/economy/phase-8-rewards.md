# Spec: Phase 8 Economy & Rewards — Bloom Season (Levels 3501–4000)

Source docs: phase/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md, phase/phase_8/02_LEVEL_PLAN_3501_4000.md, SHARED_CORE_STANDARD.md §6. Depends on: specs/gameplay/phase-8-level-plan-03501-04000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 Economy & Rewards — Bloom Season |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | economy |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define all coin inflows, Queen's Gift Box milestones, Royal Honey Chest finale reward, Golden Nectar Rush rounds, and economy balance projections for Phase 8 (Levels 3501–4000).

---

## Current State

Design documented in phase/phase_8/05_REWARDS_AND_ECONOMY_PHASE_8.md, not yet implemented.

---

## Proposed Change

### Level Clear Coins

| Level Type | Coins |
|---|---|
| Easy / Breather (x5) | 15 |
| Normal (x1–x4, x6–x8, x0) | 20 |
| Hard (x9) | 30 |
| Phase Finale L4000 | 50 |
| First ★★★ Clear Bonus | +20 |
| Replay | 0 |

### Queen's Gift Box (x0 Milestones)
- **Trigger:** Every x0 slot level (L3510, L3520, L3530 … L3990) — 49 boxes total.
- **Reward per box:** 300 coins + 1 rotating booster.
- **Booster rotation:** `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### Royal Honey Chest — L4000 Finale
- **1,000 coins**
- **2 Nectar Glow Hints**
- **2 Queen's Royal Shields**
- **2 Leaf Blowers**
- **"Master Florist"** exclusive cosmetic profile badge

### Golden Nectar Rush
- Unlocks every 25 levels: L3525, L3550, L3575 … L4000 (20 rounds total).
- Format: 30-second frenzy board with 30 lines; 10 coins per line cleared + 100 bonus for full completion.
- Maximum possible Rush inflow per round: 400 coins (30 × 10 + 100).

### Economy Projection

| Source | Amount |
|---|---|
| 500 First Clears (mix of 15/20/30/50) | ~10,450 coins |
| First ★★★ Clear Bonuses (est. 60% of 500) | ~6,000 coins |
| 49 Queen's Gift Boxes (300 coins each) | 14,700 coins |
| 20 Golden Nectar Rush rounds (avg ~250 coins each) | ~5,000 coins |
| L4000 Royal Honey Chest | 1,000 coins |
| **Total Phase 8 Inflow** | **≈ 43,950 coins** |

### Economy Sinks

| Sink | Cost |
|---|---|
| Garden Wardrobe Phase 8 additions (Bloom & Morning Glory skins) | 2,500–4,000 coins |
| Honey Heart Refill | 120 coins per refill (max 2/attempt) |
| Booster restocks: Nectar Glow Hint | 60 coins |
| Booster restocks: Queen's Royal Shield | 80 coins |
| Booster restocks: Leaf Blower | 100 coins |

---

## Acceptance Criteria
- [ ] Exactly 49 Queen's Gift Boxes awarded at L3510–L3990 (x0 slots only).
- [ ] Booster rotation formula `(L/10) mod 3` applied correctly at each x0 level.
- [ ] L4000 Royal Honey Chest awards exactly: 1,000 coins + 2 of each booster + Master Florist badge.
- [ ] 20 Golden Nectar Rush rounds unlock at correct level intervals (every 25 levels).
- [ ] Rush board format: 30 lines, 30-second timer, 10 coins/line + 100 completion bonus.
- [ ] "Master Florist" badge is unique to Phase 8 finale (not awarded in any other phase).
- [ ] Total inflow for Phase 8 matches ≈ 43,950 coins projection in economy balance model.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/economy/lib/phase_8_rewards.dart` | To be created |
| `packages/economy/lib/gift_box_scheduler.dart` | Changed |
| `packages/economy/lib/golden_nectar_rush.dart` | Changed |
| `assets/badges/master_florist_badge.png` | To be created |

---

## Risks and Open Questions

1. **Rush average coins:** The ≈ 250 coins per Rush round is an estimate. Actual average depends on player skill; economy model should be re-validated after soft launch data.
2. **Master Florist badge uniqueness:** Confirm the badge asset name does not conflict with any prior phase badge names.
3. **Sinks calibration:** Garden Wardrobe cost range (2,500–4,000 coins) is approximate; final pricing must be set before Phase 8 release.
