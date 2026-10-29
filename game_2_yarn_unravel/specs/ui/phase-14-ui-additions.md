Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-14-base-mechanics.md.

# Spec: UI — Phase 14 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, tutorial overlays, mirror symmetry indicators, and accessibility adaptations for Phase 14 (Levels 6501–7000).

## Current State
Documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Mirror Symmetry Visual Indicators
- **Mirror Seam Axis Rendering:**
  - Silver zig-zag cross-stitch seam rendered along the board center axis with a continuous subtle silver shimmer.
  - Hover / Touch Highlight: Touching or hovering over any twin thread causes its symmetrical counterpart across the seam to glow with a synchronized cyan pulse.
- **Reflect Clasp Pairing:**
  - Mirrored clasp widgets with matching filigree engravings.
  - When one clasp is unlocked, a luminous silver resonant beam travels across the seam to unlock its counterpart.
- **Inverse Thread Cues:**
  - Needle heads of Inverse Threads feature an embossed triangular glass arrow indicating 180° contra-directional motion.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 6501:** "Looking-Glass Quilt — Symmetry stitches the world! Threads mirrored across the seam unravel in harmony."
- **Level 6511:** "Mirror Seam — Two threads, one heartbeat! Both twin paths must be clear, or both will snag."
- **Level 6631:** "Reflect Clasp — Twin locks bound by silver thread! Unlock one clasp, and its mirror twin unlocks with it."
- **Level 6751:** "Twin Quilt — A toggle touched on one side flips its reflection on the other."
- **Level 6871:** "Inverse Thread — Contra-motion! When your primary thread advances, the inverse glides in reverse."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Mirror Seam features high-contrast dashed line rendering with distinct cross-hash markers.
  - Twin thread pairs share a small matching geometric tag (e.g. dual diamond $\diamond \diamond$, dual circle $\circ \circ$) in high-contrast mode for instant association.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/mirror_seam_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/reflect_clasp_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/inverse_thread_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_14_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.

