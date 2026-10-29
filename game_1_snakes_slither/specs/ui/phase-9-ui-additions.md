Source docs: phases/phase_9/06_UI_AND_QA_PHASE_9.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §17.28. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-9-base-mechanics.md, specs/ui/phase-8-ui-additions.md.

# Spec: UI — Phase 9 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Implement UI additions, HUD widgets, tutorial dialogs, touch previews, and accessibility patterns for Phase 9 (Levels 4001–4500) supporting the Twin Rivers split and merge mechanics.

## Current State
Design documented in `phases/phase_9/06_UI_AND_QA_PHASE_9.md` and `SHARED_CORE_STANDARD.md` §12, not yet implemented.
- HUD previously displayed move counters, booster buttons, and vine pruning status.
- Phase 9 requires real-time segment counting indicators, twin entity status trackers, and bifurcation path preview ghosting.

## Proposed Change
Implement the Phase 9 UI components within `packages/puzzle_ui/lib/src/phase_9/`:

### 1. HUD Additions
- **Bead Lock Progress Bar:**
  - Located in the sub-header bar.
  - Displays sapphire bead tokens representing exited segments against the target: `[BEAD LOCK: 9/12 SEGMENTS]`.
  - Animates a glowing bead absorption pulse each time an exiting snake segment leaves the board perimeter.
- **Reunion Gate Status Indicator:**
  - Displayed alongside active gate puzzles: `[REUNION: HALF 1 OK 🟢, HALF 2 PENDING 🟡]`.
  - Icon turns bright green and plays an unlock badge animation when the second child exits.
- **Merger Pad Readiness Glow:**
  - When two qualifying snakes have heads rested on the dual Hug Pad cells, an interactive golden outline pulsates on the pad.
  - An optional tap prompt ("Tap Pad to Merge") appears for the first 3 appearances.

---

### 2. Path Previews and Ghost Trajectories
- **Twin Splitter Ghost Dots:**
  - Long-pressing or tapping a snake pointing toward an M402 Twin Splitter projects dual trajectory guide dots along both the $90^\circ$ Left and $90^\circ$ Right branches.
  - If either branch is obstructed, that branch renders with translucent red crosses (`X`) to warn the player of the impassable fork.

---

### 3. Tutorial Cards & Interactive Onboarding
- **Card P9-01 (L4001 / L4011):** "Twin Rivers: Merger Pad" — Illustrates two snakes entering adjacent pads to fuse into a single long snake.
- **Card P9-02 (L4131):** "Twin Splitter: Diverging Waters" — Illustrates a snake splitting into two halves; highlights that both exit branches must be clear simultaneously.
- **Card P9-03 (L4251):** "Bead Lock: Segment Count" — Explains that the gate counts every exited snake segment, not just full snakes.
- **Card P9-04 (L4371):** "Reunion Gate: Synchronized Exit" — Explains that both split twin children must leave the board to unlock the portal.

---

### 4. Accessibility & Color-Blindness Support
- **Dual Pattern Coding for Split Children:**
  - In addition to color differences, child snakes inherit distinct geometric textures (e.g., Left child features chevron stripes, Right child features polka dots) to guarantee pair distinction for all visual faculties.
- **Numeric Counter Overlays:**
  - M403 Bead Locks feature high-contrast numeric digits (`9/12`) centered on the stone arch, ensuring progression is legible without relying on bead color perception.
- **High Contrast Borders:**
  - Snakes and interactive river tiles include 2px dark outer strokes against water backgrounds.
- **Reduce Motion Support:**
  - Replaces morphing extrusion transitions with instant cut-in splits and static directional arrows.

## Affected Files
- `packages/puzzle_ui/lib/src/phase_9/bead_lock_hud_counter.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_9/reunion_gate_hud_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_9/twin_fork_ghost_preview.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_9/phase_9_tutorial_dialogs.dart` (to be created)
- `test/ui/phase_9_ui_test.dart` (to be created)

## Risks and Open Questions
- **HUD Clutter on Narrow Displays:** On screens with aspect ratios narrower than 9:18, displaying both the Bead Lock meter and Reunion Gate status simultaneously can crowd the top bar. A compact icon-only mode must be implemented for viewport widths $< 360\text{ dp}$.
