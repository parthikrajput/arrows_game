# Spec: Phase 12 Level Plan — Levels 5501–6000 (Falling Leaves)

Source docs: phase/phase_12/02_LEVEL_PLAN_5501_6000.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-12-base-mechanics.md, specs/gameplay/phase-12-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 Level Plan — Levels 5501–6000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Define the complete 50-block slot map for 500 levels (5501–6000) of Falling Leaves, establishing grid boundaries, difficulty curves, tier distributions, milestone rewards, and the Autumn Gale Gala finale at L6000.

---

## Current State

Design documented in `phase/phase_12/02_LEVEL_PLAN_5501_6000.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple downward gravity slide) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Multi-vector gravity shifts & falling traps) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L6000 | Phase Finale — Autumn Gale Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P12-A | 5501–5750 | 12×12 to 13×13 | 28–34 | 60–68 |
| P12-B | 5751–6000 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 5501–5510 | **Signature Intro: Falling Leaves** | 12×12 | 28 | 60–62 | L5509 (D 74) | 300 coins + Hint |
| **2** | 5511–5520 | **M551 Wind-Vane Lever** | 12×12 | 28–30 | 61–63 | L5519 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 5521–5630 | Variants 1–11 (M551 gravity shift vector puzzles) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 5631–5640 | **M552 Falling Acorns** | 13×13 | 32–34 | 66–68 | L5639 (D 75) | 300 coins + Shield |
| **15–25** | 5641–5750 | Variants 12–22 (M552 dynamic falling blocker obstacles) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 5751–5760 | **M553 Dandelion Puff Tile** | 13×13 | 34–36 | 69–71 | L5759 (D 75) | 300 coins + Hint |
| **27–37** | 5761–5870 | Variants 23–33 (M553 anti-gravity floating sanctuaries) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 5871–5880 | **M554 Heavy Beetle Line** | 14×14 | 36–38 | 72–74 | L5879 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 5881–5990 | Variants 34–44 (M554 sliding heavy line choreography) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 5991–6000 | **L5991 Mastery Mix / L6000 Autumn Gale Gala** | 14×14 | 40 | 76 / 91 | L5999 (D 76) | L6000 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L5510, L5520 … L5990.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L6000 Finale — Autumn Gale Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Wind Whisperer"** cosmetic badge.
- Finale tag: `finale`.

---

## Acceptance Criteria
- [ ] All 500 seeds (L5501–6000) verified solvable by CI solver without boosters or heart loss.
- [ ] Grid dimensions conform strictly to 12×12–14×14 limits.
- [ ] Line counts remain within 28–40 across all blocks.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L6000 awards Royal Honey Chest + Wind Whisperer profile badge.
- [ ] `phase_12_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_12/seeds/phase_12_seeds.json` | To be created |
| `assets/phase_12/phase_12_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/falling_leaves_generator.dart` | To be created |

---

## Risks and Open Questions

1. **Solver branch factor under gravity:** Each valid move initiates item settlement that changes the state space. BFS depth limits must prune cycles efficiently.
