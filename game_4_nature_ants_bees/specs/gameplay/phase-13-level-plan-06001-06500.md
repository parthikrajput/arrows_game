# Spec: Phase 13 Level Plan — Levels 6001–6500 (Mystery Meadow)

Source docs: phase/phase_13/02_LEVEL_PLAN_6001_6500.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-13-base-mechanics.md, specs/gameplay/phase-13-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 Level Plan — Levels 6001–6500 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define the complete 50-block slot map for 500 levels (6001–6500) of Mystery Meadow, outlining tier bands, fog complexity scaling, milestone rewards, and the Solstice Dawn Gala finale at L6500.

---

## Current State

Design documented in `phase/phase_13/02_LEVEL_PLAN_6001_6500.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple scout path uncover) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Dense mist mazes & false wall routing) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L6500 | Phase Finale — Solstice Dawn Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P13-A | 6001–6250 | 12×12 to 13×13 | 28–34 | 60–68 |
| P13-B | 6251–6500 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 6001–6010 | **Signature Intro: Mystery Meadow** | 12×12 | 28 | 60–62 | L6009 (D 74) | 300 coins + Hint |
| **2** | 6011–6020 | **M601 Scout Ant** | 12×12 | 28–30 | 61–63 | L6019 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 6021–6130 | Variants 1–11 (M601 fog uncovering pathways) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 6131–6140 | **M602 Mirage Mist** | 13×13 | 32–34 | 66–68 | L6139 (D 75) | 300 coins + Shield |
| **15–25** | 6141–6250 | Variants 12–22 (M602 reactive dynamic fog puzzles) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 6251–6260 | **M603 Painted Pebble** | 13×13 | 34–36 | 69–71 | L6259 (D 75) | 300 coins + Hint |
| **27–37** | 6261–6370 | Variants 23–33 (M603 illusionary wall bypass tactics) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 6371–6380 | **M604 Sunlit Plate** | 14×14 | 36–38 | 72–74 | L6379 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 6381–6490 | Variants 34–44 (M604 cross-axis reveal coordination) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 6491–6500 | **L6491 Mastery Mix / L6500 Solstice Dawn Gala** | 14×14 | 40 | 76 / 91 | L6499 (D 76) | L6500 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L6010, L6020 … L6490.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L6500 Finale — Solstice Dawn Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Meadow Clairvoyant"** cosmetic badge.
- Finale tag: `finale`.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L6001–6500) pass CI solver without boosters or heart loss.
- [ ] Grid dimensions strictly conform to 12×12–14×14 boundaries.
- [ ] Line counts remain within 28–40 across all blocks.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L6500 awards Royal Honey Chest + Meadow Clairvoyant badge.
- [ ] `phase_13_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_13/seeds/phase_13_seeds.json` | To be created |
| `assets/phase_13/phase_13_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/mystery_meadow_generator.dart` | To be created |

---

## Risks and Open Questions

1. **Fog Coverage Ratio Limits:** Levels must not shroud more than 70% of the initial board grid to avoid early-stage player confusion. Max fog cap should be enforced in procedural generator.
