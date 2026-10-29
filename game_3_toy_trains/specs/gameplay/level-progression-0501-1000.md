Source docs: phase/phase_2/02_LEVEL_PROGRESSION_0501_1000.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/obstacle-catalog-phase-1.md.

# Spec: Level Progression 0501–1000 (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Define the 500-level progression architecture for Phase 2 (Levels 501–1000) of Toy Trains: Wooden Railway Puzzle, establishing tiers P2-A and P2-B, difficulty parameter scaling, the 10-level block rhythm, onboarding sequence L501–510, Depot Sticker Album milestones, and L1000 Grand Terminus Finale.

## Current State
Design documented in `phase/phase_2/02_LEVEL_PROGRESSION_0501_1000.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 progression (`specs/gameplay/level-progression-0001-0500.md`) covered Levels 1–500 across FTUE and Tiers T1–T5 up to 11x11 boards and D = 55.
- Phase 2 expands the content with 500 pre-generated and CI-validated levels (Levels 501–1000) bundled in `assets/levels/phase_2.json.gz` (JSON schema v3).
- 49 new railway mechanics (M051–M099) introduced at each block's x1 level from L511 to L991.

## Proposed Change

### 1. Progression Structure & Tiers

| Tier | Levels | Grid Dimensions | Train Count | Max Obstacle Instances | D Band | D Sub-Bands (Low / Mid / High) | x9 Hard Target D |
|---|---|---|---|---|---|---|---|
| **P2-A** | 501–750 | 10x10 to 13x13 | 24–34 | 6–12 | 44–60 | 44–49.3 / 49.3–54.7 / 54.7–60 | 66 ±3 |
| **P2-B** | 751–1000 | 12x12 to 14x14 | 28–40 | 8–14 | 52–70 | 52–58 / 58–64 / 64–70 | 77 ±3 |

- **L1000 Finale Target:** Target D = 70 × 1.2 = **84 ±3**.
- **Solvability Guarantee:** Every level must be provably solvable with 0 hearts lost and 0 boosters used, validated via CI automated solver.
- Hand-tuned levels: L501–510 (onboarding), all x1 intros, all x9 hards, and L1000 Finale. Remaining levels generated via `tools/levelgen` and audited by level designers.

### 2. Ten-Level Block Rhythm & Rewards
Every 10-level block follows a standardized cadence:

| Slot | `slot` ID | `tag` ID | First Clear Coins | Difficulty Level | Mechanics Composition |
|---|---|---|---|---|---|
| x1 | `intro` | `normal` | 20 coins | Low | Intro mechanic + <= 1 earlier mechanic |
| x2–x4 | `practice` | `normal` | 20 coins | Low -> Mid | Intro mechanic paired with familiar mechanics |
| x5 | `breather` | `easy` | 15 coins | Low | Lower train density, relaxed spatial layout |
| x6–x8 | `ramp` | `normal` | 20 coins | Mid -> High | Increased train density and multi-obstacle interactions |
| x9 | `hard` | `hard` | 30 coins | High × 1.1 | Red "Hard" badge, tight tolerances, complex routing |
| x0 | `milestone` | `normal` | 20 coins + Gift Crate | Mid | Conductor's Gift Crate 300 coins + 1 booster + 1 sticker |
| L1000 | `finale` | `finale` | 50 coins + Chest | High × 1.2 | Grand Central Chest (1,000 coins + 2 each booster + badge) |

- **Conductor's Gift Crate (every x0):** 300 coins + 1 booster based on `(L/10) mod 3`:
  - 1 -> Green Signal Hint
  - 2 -> Track Crane (Hammer)
  - 0 -> Cowcatcher Shield
- **Golden Express Coin Rush:** Triggered immediately after first clear of every 25th level (L525, L550, L575 ... L1000). 30 seconds, 30 trains, 10 coins/train + 100 clear bonus.

### 3. Onboarding Sequence L501–510 (Level-by-Level)
All levels in this block use 12x12 boards with **no new mechanics** (using familiar Phase 1 mechanics) to teach zoom/pan navigation:

- **L501 (`intro` / `normal`, D = 42.9):** 24 trains, M001 Buffer Stop x6. `ftue_step = p2_zoom_pinch`. Displays welcome card: "Bigger railway yards ahead!" Animated hand demonstrates pinch-to-zoom.
- **L502 (`practice` / `normal`, D = 45.5):** 25 trains, M002, M004, M008. `ftue_step = p2_pan_drag`. Starts at 1.5x zoom: "Drag with one finger to look around."
- **L503 (`practice` / `normal`, D = 48.6):** 26 trains, M002, M005, M009. `ftue_step = p2_peek_zoom`. Long-press Route Peek shows `"Track continues →"` screen edge indicator.
- **L504 (`practice` / `normal`, D = 54.6):** 26 trains, M001, M006, M013, M018. `ftue_step = p2_hint_autopan`. Demonstrates Green Signal Hint automatically centering an off-screen train.
- **L505 (`breather` / `easy`, D = 41.4):** 24 trains, M001, M002. `ftue_step = p2_fit_button`. Prompts user to tap the "⤢ Fit" button to return to whole-table view.
- **L506–508 (`ramp` / `normal`, D = 52.3–60.5):** Escalating puzzle complexity without tutorial interruptions.
- **L509 (`hard` / `hard`, D = 67.7):** 32 trains, multi-mechanic puzzle, red Hard badge.
- **L510 (`milestone` / `normal`, D = 51.2):** 27 trains. Awards first Phase 2 Gift Crate (300 coins + 1 Cowcatcher Shield) and Vol 4 Sticker #1.

### 4. Milestone Timeline (Phase 2 Highlights)
- L511: M051 Diagonal Express (first diagonal trains).
- L525: First Phase 2 Coin Rush.
- L531 / L541 / L551: Push Cart -> Frosty Rails -> Cart Weighbridge progression.
- L691: M069 Triple-Deck Viaduct (3-layer tracks).
- L750: Volume 4 Album completion milestone.
- L751: Tier P2-B begins (12x12–14x14 boards).
- L841 / L851 / L861 / L891: Signal Lamp, Sensor, Mirror, and Prism optics sequence.
- L1000: Grand Terminus Finale (M098 Marching Clock Tower + 10 mixed mechanics).

## Affected Files
- `assets/levels/phase_2.json.gz` (to be created: bundled level pack, schema v3)
- `packages/puzzle_core/lib/src/generator/level_validator.dart` (changed: validate P2-A/P2-B constraints)
- `lib/features/level_map/presentation/bloc/level_map_bloc.dart` (changed: Phase 2 map nodes L501–1000)

## Design
- Level map: Phase 2 visual theme "Grand Terminus & Alpine Mountain Rail" spanning nodes 501–1000.
- Level Complete Dialog: Phase 2 Gift Crate card with 300 coins badge and animated Vol 4/5 sticker slot stamp.

## Risks
- Level loading latency from `phase_2.json.gz`. Mitigation: Gzip stream decompress and parse only metadata on launch; load individual level payload on demand or pre-buffer 5 levels.

## Open Questions
- None. All parameters match `phase/phase_2/02_LEVEL_PROGRESSION_0501_1000.md` and `SHARED_CORE_STANDARD.md`.
