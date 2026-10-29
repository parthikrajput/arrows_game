Source docs: phase_2/02_LEVEL_PROGRESSION_0501_1000.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Level Progression (Levels 501–1000)

## Status
Draft

## Type
Improvement (extends level progression architecture from `specs/gameplay/level-progression-0001-0500.md` into Phase 2)

## Goal
Implement the 500-level progression architecture for Phase 2 (Levels 501–1000), including P2-A and P2-B tiers, biome theming, the 10-level zoom onboarding sequence (Levels 501–510), the 50-block level progression slot table, and Phase 2 Finale Level 1000.

## Current State
Design documented in `phase_2/02_LEVEL_PROGRESSION_0501_1000.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 covered Levels 1–500 across FTUE and tiers T1–T5 up to D band 38–52.
- Phase 2 expands to Levels 501–1000 divided into P2-A (D 45–60) and P2-B (D 52–70).

## Proposed Change
Extend level loader and map progression logic to handle Phase 2 levels, onboarding steps, and block patterns:

### 1. Phase 2 Tiers & Biomes
| Tier | Levels | Biome | Board Tint | Grid Size | Snakes | Obstacles | D Band |
|---|---|---|---|---|---|---|---|
| **P2-A** | 501–600 | Waterfall Gorge | `#E0F2F1` | 10×10–12×12 | 24–30 | 6–9 | 45–53 |
| **P2-A** | 601–700 | Sunbeam Rainforest | `#F1F8E9` | 11×11–13×13 | 26–32 | 7–11 | 49–57 |
| **P2-A** | 701–750 | Treetop Village | `#EFF5E6` | 12×12–13×13 | 30–34 | 9–12 | 54–60 |
| **P2-B** | 751–850 | Ancient Ruins | `#F3EEE4` | 12×12–13×13 | 28–34 | 8–12 | 54–62 |
| **P2-B** | 851–950 | Crystal Caves | `#E8EAF6` | 13×13–14×14 | 32–38 | 10–14 | 58–67 |
| **P2-B** | 951–1000 | Sun Temple | `#FFF3E0` | 14×14 | 36–40 | 12–14 | 64–70 (L1000 ≈ 84) |

### 2. Levels 501–510 Onboarding Sequence
Dedicated 10-level onboarding to introduce pinch-zoom and pan mechanics without introducing new gameplay obstacles:
- **L501:** 12x12 grid, D 45.4 (`p2_1_pinch`): Grandpa Tortoise card introduces pinch gesture; completes once player pinches board.
- **L502:** 12x12 grid, D 47.4 (`p2_2_pan`): One snake sits off-screen in initial zoom; edge arrow prompts pan gesture.
- **L503:** 12x12 grid, D 49.0 (`p2_3_fit`): Prompts "Fit" 🔍 button to reset camera.
- **L504:** 12x12 grid, D 49.6 (`p2_4_preview_zoomed`): Long-press preview on zoomed-in board.
- **L505:** 11x11 grid, D 42.4 (Breather, easy): Demonstrates that zoom is disabled on smaller boards (`p2_5_no_zoom`).
- **L506:** 12x12 grid, D 50.2: Off-screen obstacle collision indicator demonstration (`p2_6_offscreen_bump`).
- **L507:** 12x12 grid, D 50.7: Glow Firefly Hint camera auto-centering demonstration.
- **L508:** 12x12 grid, D 51.3: Settings tip for "Remember zoom".
- **L509:** 12x12 grid, D 55.8 (Hard level): First Hard level of Phase 2 with red paw badge.
- **L510:** 12x12 grid, D 48.6 (Milestone): Jungle Gift Basket granting 300 coins + 1 Safety Shell Shield + Sticker Album Vol 4 sticker #1.

### 3. 10-Level Block Pattern (Blocks 51–100)
- Continues 10-level block structure from Phase 1:
  - `x1`: New mechanic intro (M051 at L511 ... M099 at L991) + Grandpa Tortoise card.
  - `x2–x4`: Practice levels (Normal, 20 coins).
  - `x5`: Breather level (Easy, 15 coins).
  - `x6–x8`: Ramp levels (Normal, 20 coins).
  - `x9`: Hard level (Hard, 30 coins, red paw badge, D target = block max × 1.1).
  - `x0`: Milestone level (Gift Basket 300 coins + 1 booster + 1 sticker).
- Golden Slither Rush bonus rounds trigger every 25 levels (L525, 550, 575 ... 1000).

### 4. Phase 2 Finale: Level 1000 ("Mongoose Emperor's Sun Temple")
- **Board:** 14x14 grid, 3 layers.
- **Paths:** 40 snakes.
- **Mechanics:** M098 Prowling Mongoose Emperor + 11 mixed mechanics (Push Blocks, Sunbeams, Prisms, Mirrors, Periodic Gates).
- **Difficulty:** D target ≈ 84.
- **Reward Sequence:** Jungle Treasure Chest (1,000 coins + 2 Hint + 2 Shield + 2 Hammer + Phase 2 badge) -> Golden Slither Rush -> Phase 2 Complete celebration.

## Affected Files
- `lib/features/gameplay/domain/models/phase_progression.dart` (changed to include Phase 2 tiers)
- `lib/features/map/presentation/widgets/phase_2_map_section.dart` (to be created)
- `lib/features/gameplay/presentation/dialogs/ftue_zoom_dialog.dart` (to be created)
- `assets/levels/phase_2.json.gz` (to be added)

## Risks
- Players accustomed to auto-fit Phase 1 gameplay may find large 14x14 boards overwhelming. Onboarding sequence in L501–510 mitigates this.
- Performance raster times on 14x14 boards with 40 snakes and 14 obstacle instances on low-tier devices.

## Open Questions
- None. Tiers and block mapping match `SHARED_CORE_STANDARD.md` §9.3 and `phase_2/02_LEVEL_PROGRESSION_0501_1000.md`.
