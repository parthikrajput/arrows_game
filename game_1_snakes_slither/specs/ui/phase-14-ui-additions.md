Source docs: phases/phase_14/06_UI_AND_QA_PHASE_14.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §16.4, §17.28. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-14-base-mechanics.md, specs/ui/phase-13-ui-additions.md.

# Spec: UI — Phase 14 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Implement UI additions, central caustic water axis shaders, mirror link partner halos, inverse direction dorsal arrows, cross-axis ripple wave indicators, and accessibility patterns for Phase 14 (Levels 6501–7000).

## Current State
Design documented in `phases/phase_14/06_UI_AND_QA_PHASE_14.md` and `SHARED_CORE_STANDARD.md` §12, §16.4, not yet implemented.
- Previous UI handled fog overlays and raycast probes.
- Phase 14 introduces bilateral mirror axes dividing the grid, twin partner highlighting shaders, inverse vector indicators, and cross-axis wave cues.

## Proposed Change
Implement Phase 14 UI widgets in `packages/puzzle_ui/lib/src/phase_14/`:

### 1. HUD Additions & Axis Status
- **Mirror Axis Orientation Indicator:**
  - Located in the sub-header bar: `[MIRROR AXIS: VERTICAL]` (or `HORIZONTAL`).
  - Illustrates the orientation of the reflection divider plane across the playfield.
- **Cross-Shore Lock Indicator:**
  - Displays linked gate status: `[REFLECT LOCK: KEY IN TRANSIT]`.
  - Turns glowing emerald upon the key snake's exit on the opposite shore.

---

### 2. Central Water Axis & Mirror Highlighting
- **Caustic Water Axis Line:**
  - Renders a shimmering 2px cyan-white water divider running through the grid center.
  - Features gentle animated caustic light reflections without causing performance drops.
- **Mirror Link Partner Halo:**
  - Touching, tapping, or hovering over any paired snake instantly renders a synchronized pulsating azure glow around **both** partner snakes simultaneously across the axis.
- **Inverse Direction Glyph (M654):**
  - M654 Upside-down Snakes display an animated red-yellow inverted chevron glyph on their dorsal head scales, explicitly signaling reverse vector movement.
- **Cross-Axis Ripple Wave (M652):**
  - When the key snake exits on Shore B, a circular water ripple shockwave glides across the water axis directly toward the target lock on Shore A.

---

### 3. Tutorial Cards & Interactive Onboarding
- **Card P14-01 (L6501 / L6511):** "Pond Reflections: Mirror Axis" — Explains that snakes on opposing shores move in synchronous reflection and both paths must be clear.
- **Card P14-02 (L6631):** "Reflection Lock: Opposite Shore Key" — Demonstrates that liberating the key snake on Shore B opens the gate on Shore A.
- **Card P14-03 (L6751):** "Twin Boards: Symmetrical Challenge" — Explains identical move input execution across twin mirrored grids.
- **Card P14-04 (L6871):** "Upside-Down Snake: Inverse Motion" — Teaches that inverse snakes slither in the exact opposite direction of their partner.

---

### 4. Accessibility & Multi-Modal Support
- **Pair-Matching Shape Badges:**
  - Paired snakes are stamped with matching geometric glyphs (e.g. Diamond $\diamondsuit$, Hexagon $\hexagon$, Circle $\bigcirc$) on their dorsal scales, ensuring visual link identification independent of color perception.
- **High-Contrast Divider Seam:**
  - Central water axis includes 1px dark drop-shadow outlines to remain distinct across both light crystal and dark obsidian pond backdrops.
- **Reduce Motion Support:**
  - Disables animated caustic water shaders, replacing the axis with a static high-contrast divider line.
  - Suppresses screen ripples, rendering an immediate gate unlock flash instead.

## Affected Files
- `packages/puzzle_ui/lib/src/phase_14/caustic_water_axis_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_14/mirror_link_partner_halo.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_14/inverse_direction_glyph.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_14/phase_14_tutorial_dialogs.dart` (to be created)
- `test/ui/phase_14_ui_test.dart` (to be created)

## Risks and Open Questions
- **Simultaneous Touch Conflicts:** If a player taps both partner snakes at the exact same moment on a multi-touch screen, the input handler must coalesce the touch events into a single synchronized move command without executing double-ticks.
