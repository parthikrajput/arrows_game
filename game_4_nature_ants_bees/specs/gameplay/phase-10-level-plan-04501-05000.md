# Spec: Phase 10 Level Plan — Levels 4501–5000 (Garden Rhythm)

Source docs: phase/phase_10/02_LEVEL_PLAN_4501_5000.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-10-base-mechanics.md, specs/gameplay/phase-10-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 Level Plan — Levels 4501–5000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define the complete 50-block slot map for 500 levels (4501–5000) of Garden Rhythm, detailing tier progressions, difficulty envelopes, milestone rewards, and the Mid-Season Symphony Gala finale at L5000.

---

## Current State

Design documented in `phase/phase_10/02_LEVEL_PLAN_4501_5000.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple 2-step modulo timing) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Complex color sequences & queue chains) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L5000 | Phase Finale — Mid-Season Symphony Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P10-A | 4501–4750 | 12×12 to 13×13 | 28–34 | 60–68 |
| P10-B | 4751–5000 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 4501–4510 | **Signature Intro: Garden Rhythm** | 12×12 | 28 | 60–62 | L4509 (D 74) | 300 coins + Hint |
| **2** | 4511–4520 | **M451 Cricket Gate** | 12×12 | 28–30 | 61–63 | L4519 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 4521–4630 | Variants 1–11 (M451 rhythm modulo cycles) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 4631–4640 | **M452 Bead-String Lock** | 13×13 | 32–34 | 66–68 | L4639 (D 75) | 300 coins + Shield |
| **15–25** | 4641–4750 | Variants 12–22 (M452 color string matching tactics) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 4751–4760 | **M453 Queue Hedge** | 13×13 | 34–36 | 69–71 | L4759 (D 75) | 300 coins + Hint |
| **27–37** | 4761–4870 | Variants 23–33 (M453 ordered perimeter departures) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 4871–4880 | **M454 Echo Bloom** | 14×14 | 36–38 | 72–74 | L4879 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 4881–4990 | Variants 34–44 (M454 pattern replay & memory chains) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 4991–5000 | **L4991 Mastery Mix / L5000 Mid-Season Symphony Gala** | 14×14 | 40 | 76 / 91 | L4999 (D 76) | L5000 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L4510, L4520 … L4990.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L5000 Finale — Mid-Season Symphony Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Rhythm Maestro"** cosmetic badge.
- Major half-way celebration milestone across the 10,000-level journey.

---

## Acceptance Criteria
- [ ] All 500 seeds (L4501–5000) verified solvable by CI solver without booster use.
- [ ] Grid dimensions conform strictly to 12×12–14×14 limits.
- [ ] Line counts remain within 28–40 range across all blocks.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L5000 awards Royal Honey Chest + Rhythm Maestro profile badge.
- [ ] `phase_10_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_10/seeds/phase_10_seeds.json` | To be created |
| `assets/phase_10/phase_10_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/garden_rhythm_generator.dart` | To be created |

---

## Risks and Open Questions

1. **L5000 Mid-Point Milestone celebration:** As L5000 represents the half-way point of the game (50% of 10,000 levels), confirm if additional UI flourish or interstitial celebratory cutscene is triggered beyond standard finale modal.
