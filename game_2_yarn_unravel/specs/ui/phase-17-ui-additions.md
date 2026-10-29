Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-17-base-mechanics.md.

# Spec: UI — Phase 17 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, tutorial overlays, velvet pincushion rendering, pin extraction dynamics, and accessibility adaptations for Phase 17 (Levels 8001–8500).

## Current State
Documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Royal Velvet Pincushions & HP UI Design
- **Velvet Guardian Aesthetics:**
  - Rich crimson/purple velvet fabric pillows adorned with golden fringe and pearl-headed pins.
  - Floating HP badge mounted on top displaying current/max health with a mini segmented heart bar.
- **Pin Extraction Animations:**
  - As a thread passes adjacent to a pincushion, a pin smoothly lifts from the cushion and dissolves into golden sparks (200 ms).
- **Armoured Force-Field:**
  - Active brass shields display an iridescent perimeter shield bubble that deflects incoming pulls with a ring ripple.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 8001:** "Pincushion Court — Regal guardians block the way! Unravel threads alongside them to pluck their pins and clear the board."
- **Level 8011:** "Twin Pincushions — Bound in thread! Twin guardians share one heart; damaging either weakens both."
- **Level 8131:** "Armoured Pincushion — Brass-plated shield! Flip the lever to lower the barrier before extracting pins."
- **Level 8251:** "Seeding Pincushion — Sprouting obstacles! Stop the seeder before it scatters buttons across the canvas."
- **Level 8371:** "Heart Pincushion — Focused radiance! Direct a light beam onto the heart core to render it vulnerable."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Pincushion HP badges display bold numerical text (e.g. `HP: 4/6`) alongside the graphical health bar.
  - Shield force-fields use high-contrast diagonal stripe overlays when active.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/pincushion_guardian_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/pincushion_hp_badge.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/shield_bubble_overlay.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_17_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.
