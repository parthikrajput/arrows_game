# Spec: Phase 11 Level Plan — Levels 5001–5500 (Twin Gardens)

Source docs: phase/phase_11/02_LEVEL_PLAN_5001_5500.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-11-base-mechanics.md, specs/gameplay/phase-11-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 Level Plan — Levels 5001–5500 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define the complete 50-block slot map for 500 levels (5001–5500) of Twin Gardens, specifying dual-board grid sizes, difficulty bands, tiers, milestone rewards, and the Twin Garden Jubilee finale at L5500.

---

## Current State

Design documented in `phase/phase_11/02_LEVEL_PLAN_5001_5500.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple cross-board transfer) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Interlocking cross-board keys & twins) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L5500 | Phase Finale — Twin Garden Jubilee | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size (per board) | Lines | D Band |
|---|---|---|---|---|
| P11-A | 5001–5250 | 12×12 | 28–34 | 60–68 |
| P11-B | 5251–5500 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid (per board) | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 5001–5010 | **Signature Intro: Twin Gardens** | 12×12 | 28 | 60–62 | L5009 (D 74) | 300 coins + Hint |
| **2** | 5011–5020 | **M501 Garden Gate Link** | 12×12 | 28–30 | 61–63 | L5019 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 5021–5130 | Variants 1–11 (M501 cross-border line transfers) | 12×12 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 5131–5140 | **M502 Pen-Pal Key** | 12×12–13×13 | 32–34 | 66–68 | L5139 (D 75) | 300 coins + Shield |
| **15–25** | 5141–5250 | Variants 12–22 (M502 cross-board lock dependencies) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 5251–5260 | **M503 Reflecting Pond Board** | 13×13 | 34–36 | 69–71 | L5259 (D 75) | 300 coins + Hint |
| **27–37** | 5261–5370 | Variants 23–33 (M503 twin-board synchronous taps) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 5371–5380 | **M504 Relay Burrow** | 14×14 | 36–38 | 72–74 | L5379 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 5381–5490 | Variants 34–44 (M504 dual-realm subterranean routes) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 5491–5500 | **L5491 Mastery Mix / L5500 Twin Garden Jubilee** | 14×14 | 40 | 76 / 91 | L5499 (D 76) | L5500 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L5010, L5020 … L5490.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L5500 Finale — Twin Garden Jubilee
- Grid: 14×14 (dual boards), 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Twin Realm Navigator"** cosmetic badge.
- Finale tag: `finale`.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L5001–5500) pass CI solver without booster use.
- [ ] Dual boards adhere to 12×12 to 14×14 per-board dimension limits.
- [ ] Line counts remain within 28–40 across both boards combined.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L5500 awards Royal Honey Chest + Twin Realm Navigator badge.
- [ ] `phase_11_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_11/seeds/phase_11_seeds.json` | To be created |
| `assets/phase_11/phase_11_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/twin_gardens_generator.dart` | To be created |

---

## Risks and Open Questions

1. **Dual-Board UI Layout in Landscape vs Portrait:** In portrait mode, showing two 14×14 boards side by side requires either vertical stacking or tabbed viewport paging. Ensure default zoom-to-fit respects screen aspect ratios.
