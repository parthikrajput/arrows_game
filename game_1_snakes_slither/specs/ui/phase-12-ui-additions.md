Source docs: phases/phase_12/06_UI_AND_QA_PHASE_12.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §17.28. Depends on: specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-12-base-mechanics.md, specs/ui/phase-11-ui-additions.md.

# Spec: UI — Phase 12 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Implement UI additions, HUD gravity compass widgets, falling trajectory ghost previews, heavy python weight badges, and accessibility enhancements for Phase 12 (Levels 5501–6000), supporting Monsoon Winds rotating gravity physics.

## Current State
Design documented in `phases/phase_12/06_UI_AND_QA_PHASE_12.md` and `SHARED_CORE_STANDARD.md` §12, not yet implemented.
- Previous UI handled dual-grid viewports and suspension bridge transitions.
- Phase 12 introduces dynamic 4-way gravity vector compasses, trajectory drop previews upon long-pressing levers, and weight indicators for autonomous entities.

## Proposed Change
Implement the Phase 12 UI widgets in `packages/puzzle_ui/lib/src/phase_12/`:

### 1. HUD Additions & Environmental Indicators
- **Compass Wind Indicator:**
  - Located in the center-top HUD sub-bar: `[WIND: 🠗 DOWN (GUST IN 2 MOVES)]`.
  - Stylized 2D weather-vane compass with an arrow pointing strictly along the active gravity vector ($\downarrow, \to, \uparrow, \leftarrow$).
  - Smoothly animates a $90^\circ$ clockwise spin transition whenever the M551 Wind Lever is activated.
- **Active Fruit Counter:**
  - Displays remaining obstacles in play: `[FRUITS ON BOARD: 4]`.
- **Heavy Python Weight Badge:**
  - Heavy Pythons (M554) display an obsidian anvil / stone weight glyph overlaid onto their dorsal scales, clearly signaling their autonomous falling behavior.
- **Floaty Lily Glow:**
  - M553 Anti-grav tiles pulse with a soft violet bioluminescent shimmer, highlighting tiles that suspend falling obstacles.

---

### 2. Trajectory Previews & Ghost Drops
- **Falling Trajectory Preview:**
  - Long-pressing an M551 Wind Lever displays ghost projections showing where all active M552 Falling Fruits will land under the rotated gravity vector.
  - Ghost projections render as translucent fruit silhouettes with downward dotted fall vectors, assisting strategic planning.

---

### 3. Tutorial Cards & Interactive Onboarding
- **Card P12-01 (L5501 / L5511):** "Monsoon Winds: Rotating Gravity" — Explains how tapping the Wind Lever rotates gravity $90^\circ$ clockwise and uses 1 move.
- **Card P12-02 (L5631):** "Falling Fruits: Dynamic Obstacles" — Demonstrates fruits falling into vacant spaces, acting as solid barriers without harming snakes.
- **Card P12-03 (L5751):** "Floaty Lily: Anti-Gravity Pad" — Explains that fruits on lily tiles float weightlessly until pushed by a slithering snake.
- **Card P12-04 (L5871):** "Heavy Python: Weighty Slide" — Demonstrates pythons sliding autonomously under gravity when their path is completely vacant.

---

### 4. Accessibility & Multi-Modal Support
- **Directional Arrow Stamps on Obstacles:**
  - All falling fruits and heavy pythons feature small high-contrast directional arrow stamps pointing along the current gravity vector, removing exclusive reliance on the HUD compass.
- **High Contrast Weather Vane:**
  - Wind compass renders in vibrant cyan-yellow with 2px dark outer strokes against all sky backgrounds.
- **Reduce Motion Support:**
  - Camera rumble and wind gust screen streaks are disabled.
  - Falling obstacles teleport instantly to settled coordinates over 50 ms alpha transitions rather than animating falling arcs.

## Affected Files
- `packages/puzzle_ui/lib/src/phase_12/compass_wind_indicator.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_12/falling_trajectory_ghost_preview.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_12/heavy_python_weight_badge.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_12/phase_12_tutorial_dialogs.dart` (to be created)
- `test/ui/phase_12_ui_test.dart` (to be created)

## Risks and Open Questions
- **Preview Clutter on Dense Boards:** When 8 or more fruits are present, long-pressing the lever could render multiple overlapping ghost trails, cluttering the puzzle. Trajectory previews should display only final landing target tiles rather than full transit lines.
