# Spec: Phase 15 Level Plan — Levels 7001–7500 (Brook & Rails)

Source docs: phase/phase_15/02_LEVEL_PLAN_7001_7500.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-15-signature-system.md, specs/gameplay/phase-15-base-mechanics.md, specs/gameplay/phase-15-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 Level Plan — Levels 7001–7500 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Define the complete 50-block slot map for 500 levels (7001–7500) of Brook & Rails, detailing stream complexity progressions, tier distributions, milestone rewards, and the Rushing Waters Gala finale at L7500.

---

## Current State

Design documented in `phase/phase_15/02_LEVEL_PLAN_7001_7500.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple straight conveyor glide) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Tidal reversals & multi-junction networks) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L7500 | Phase Finale — Rushing Waters Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P15-A | 7001–7250 | 12×12 to 13×13 | 28–34 | 60–68 |
| P15-B | 7251–7500 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 7001–7010 | **Signature Intro: Brook & Rails** | 12×12 | 28 | 60–62 | L7009 (D 74) | 300 coins + Hint |
| **2** | 7011–7020 | **M701 Brook Fork** | 12×12 | 28–30 | 61–63 | L7019 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 7021–7130 | Variants 1–11 (M701 brook branching puzzles) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 7131–7140 | **M702 Tide Brook** | 13×13 | 32–34 | 66–68 | L7139 (D 75) | 300 coins + Shield |
| **15–25** | 7141–7250 | Variants 12–22 (M702 tidal flow reversal tactics) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 7251–7260 | **M703 Sluice Lever** | 13×13 | 34–36 | 69–71 | L7259 (D 75) | 300 coins + Hint |
| **27–37** | 7261–7370 | Variants 23–33 (M703 gated canal flow controls) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 7371–7380 | **M704 Lazy River** | 14×14 | 36–38 | 72–74 | L7379 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 7381–7490 | Variants 34–44 (M704 closed-loop circulation escapes) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 7491–7500 | **L7491 Mastery Mix / L7500 Rushing Waters Gala** | 14×14 | 40 | 76 / 91 | L7499 (D 76) | L7500 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L7010, L7020 … L7490.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L7500 Finale — Rushing Waters Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"River Master"** cosmetic badge.
- Finale tag: `finale`.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L7001–7500) pass CI solver without boosters or heart loss.
- [ ] Grid dimensions conform strictly to 12×12–14×14 boundaries.
- [ ] Line counts remain within 28–40 across all blocks.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L7500 awards Royal Honey Chest + River Master badge.
- [ ] `phase_15_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_15/seeds/phase_15_seeds.json` | To be created |
| `assets/phase_15/phase_15_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/brook_and_rails_generator.dart` | To be created |

---

## Risks and Open Questions

1. **Conveyor Grid Coverage Limits:** Brook tiles must not exceed 40% of walkable ground tiles to ensure ant lines retain sufficient standard ground for maneuvering.
