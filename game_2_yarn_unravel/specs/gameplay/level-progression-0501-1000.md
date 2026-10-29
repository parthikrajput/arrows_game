Source docs: phase/phase_2/02_LEVEL_PROGRESSION_0501_1000.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Phase 2 Level Progression (Levels 0501–1000)

## Status
Draft

## Type
New Feature

## Goal
Specify the level progression architecture for Yarn Unravel Phase 2 (Levels 501–1000), including tiers P2-A and P2-B, the 10-level onboarding sequence (501–510) introducing large board zoom and pan, the 50-block cadence, economy milestone integrations, and Level 1000 Grand Finale design.

## Current State
Design documented in `phase/phase_2/02_LEVEL_PROGRESSION_0501_1000.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 progression in `specs/gameplay/level-progression-0001-0500.md` concluded with Level 500 "Cozy Blanket Finish".
- Phase 2 delivers 500 bundled levels packaged into `assets/levels/phase_2.json.gz` (schema v3).
- Levels 501–510 provide dedicated zoom/pan onboarding using Phase 1 mechanics without introducing new obstacles.
- 49 new craft mechanics (M051–M099) unlock at level slots ending in 1 (511, 521, … 991).

## Proposed Change
Implement the Phase 2 progression pipeline and level pack loader:

### 1. Phase 2 Tiers & Parameters
Adheres strictly to `SHARED_CORE_STANDARD.md` §9.3:

| Tier | Levels | Grid Dimensions | Thread Count | Max Obstacle Instances | Difficulty (D) Band |
|---|---|---|---|---|---|
| **P2-A** | 501–750 | 10×10 to 13×13 | 24–34 | 6–12 | 45–60 |
| **P2-B** | 751–1000 | 12×12 to 14×14 | 28–40 | 8–14 | 52–70 |

- **Difficulty Plateau Transition:** T5 mid-point from Phase 1 was 45. Difficulty never decreases; P2-A begins at D = 45 and ramps to 60. P2-B scales from 52 to 70.
- **Difficulty Metric:** Computed via standard formula: `D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S`.
- **Level Completion Coins:** Easy 15, Normal 20, Hard 30, Finale 50; first ★★★ clear awards +20 bonus Coins.

### 2. Onboarding: Levels 501–510 (Level-by-Level)
No new mechanics are introduced during onboarding; all boards are 12×12 to train zoom and pan gestures:

| Level | Grid | Threads | D Target | Phase 1 Mechanics | Tutorial Step & Analytics (`ftue_step`) |
|---|---|---|---|---|---|
| **501** | 12×12 | 24 | 45 | M001 Wooden Button, M014 Hook Deflector | `p2_pinch`: Purl the kitten demonstrates 2-paw pinch gesture to zoom in. Board starts auto-fit. |
| **502** | 12×12 | 24 | 46 | M002 Ruler Strip, M008 Pompom Tunnel | `p2_pan`: In zoomed state, player drags to pan. Tunnel pair located at opposite board corners. |
| **503** | 12×12 | 25 | 46 | M020 Yarn Basket, M029 Hem Wall | `p2_fit`: Prompts tapping the "Fit" HUD button to return view to scale 1.0. |
| **504** | 12×12 | 25 | 47 | M004 Charm & Clasp, M010 Wool Fluff | `p2_peek_zoom`: Teaches Thread Peek (long-press >= 350 ms) while zoomed in. |
| **505** | 12×12 | 24 | 45 | M001 Wooden Button | Breather (tag `easy`): open lanes for relaxing clears. |
| **506** | 12×12 | 26 | 49 | M032 Double Fabric Layers, M015 Stitch Bridge | Refresher on layered thread depth and bridge crossings. |
| **507** | 12×12 | 27 | 50 | M013 Spool Spinner, M028 Tagged Threads | `p2_hint_pan`: Demonstrates Needle Glow Hint auto-panning camera to off-screen targets. |
| **508** | 12×12 | 28 | 52 | M009 Presser Lever, M019 Foot Pedal Plate | Ramp level combining levers and pressure plates. |
| **509** | 12×12 | 29 | 58 | M043 Multi-Clasp, M025 Rolling Yarn Ball, M041 Ombre Thread | Hard level (tag `hard`, red badge): test of multi-clasp unlocking and rolling yarn. |
| **510** | 12×12 | 26 | 49 | M022 Backstitch Thread, M038 Elastic Hop Pad | Milestone (tag `normal`): Craft Basket awards 300 Coins + 1 Thimble Shield; awards Scrapbook Vol 4 first sticker. |

### 3. 50-Block Level Cadence
Each 10-level block from 511 to 1000 follows the standardized repeating structure:
- **x1 (Intro):** Introduces one new mechanic (M051–M099) alongside <= 1 earlier mechanic. Tutorial card shown; tag `normal`.
- **x2–x4 (Practice):** Familiarization with the new mechanic across varied board layouts; tag `normal`.
- **x5 (Breather):** Lower difficulty, open layout; tag `easy` (15 Coins).
- **x6–x8 (Ramp):** Increasing thread density, layer depth, and obstacle integration; tag `normal`.
- **x9 (Hard):** Peak challenge of the block (target D = block high × 1.1); tag `hard` (30 Coins).
- **x0 (Milestone):** Craft Basket containing 300 Coins + 1 rotating booster (`(L/10) mod 3`: 1 Needle Glow Hint, 2 Golden Scissors, 0 Thimble Shield) + Scrapbook sticker; tag `normal`.

### 4. Golden Bobbin Rush (Coin Rush Bonus Rounds)
- Triggers after first clear of milestone levels every 25 levels: L525, 550, 575, … 1000 (20 bonus rounds total in Phase 2).
- **Format:** 30-second timer, 30 single-segment threads on an 8×8 to 10×10 board.
- **Rewards:** 10 Coins per thread unravelled + 100 Coins bonus for clearing all 30 threads (maximum 400 Coins).

### 5. Level 1000 Phase 2 Grand Finale: "The Heirloom Tapestry"
- **Grid:** 14×14 craft board, 40 threads, 3 layers (Lining, Fabric, Tulle).
- **Signature Mechanic:** Wandering Pincushion Guardian (M098) patrol path + >= 10 mixed mechanics (Bobbin Crates M053, Dye Pots M059, Sewing Lamps M084, Sun-Catchers M085, Vanity Mirrors M086, Master Jewel Clasp M099).
- **Difficulty Target:** D = 84 (band high 70 × 1.2).
- **Reward:** Grand Sewing Chest awarding 1,000 Coins + 2 Needle Glow Hints + 2 Thimble Shields + 2 Golden Scissors + "Heirloom Weaver" profile badge.

## Affected Files
- `packages/puzzle_core/lib/src/models/level_data.dart` (changed: schema v3 fields, slot and tag metadata)
- `packages/puzzle_core/lib/src/generator/level_validator.dart` (changed: Phase 2 validation checks)
- `assets/levels/phase_2.json.gz` (to be created: 500 pre-generated levels)
- `lib/features/gameplay/bloc/level_loader_cubit.dart` (changed: load Phase 2 level pack)

## Risks
- Board size increase to 14x14 may cause difficulty spikes if density exceeds 40 threads. Mitigated by CI difficulty calculator enforcing P2-B band cap (D <= 70, Finale <= 84).

## Open Questions
None. Cadence and parameters match `SHARED_CORE_STANDARD.md`.
