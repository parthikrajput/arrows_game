Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-18-base-mechanics.md.

# Spec: UI — Phase 18 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, composite HUD layouts, multi-floor parallax depth rendering, and accessibility adaptations for Phase 18 (Levels 8501–9000).

## Current State
Documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Multi-System Composite UI & Depth Design
- **Composite HUD:**
  - Integrates the Day/Night cycle dial and the multi-floor layer switcher into a single harmonized top navigation ribbon.
- **Layer & Optical Depth:**
  - Multi-floor light beams projecting downward through sheer organza fabric render with dynamic 3D parallax depth, casting soft golden ambient highlights on the floor below.
- **Satin Charm Crate Aesthetics:**
  - Sliding crates encased in shimmering satin fabric with a glowing golden key emblem along the rim.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 8501:** "Remix Atelier — Craft disciplines unite! Prepare for combined challenges of cycles, light, layers, and push kinetics."
- **Level 8511:** "Cycle Crate — Shifting mobility! Slide this crate during Day; at Night it locks fast into the loom."
- **Level 8631:** "Floor Beam — Piercing light! Rays shine downward through organza to illuminate lower floors."
- **Level 8751:** "Fogged Stair — Concealed ascent! Unravel a thread through the wool fluff to reveal the hidden staircase."
- **Level 8871:** "Satin Charm Crate — Key delivery! Push this satin crate into the matching clasp to open the way."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Cycle state badges clearly show bold Sun ($\odot$) and Moon ($\leftmoon$) symbols alongside color shifts.
  - Floor beam light projections feature directional chevron streams to clarify vertical projection trajectories.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/composite_hud_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/floor_beam_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/satin_charm_crate_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_18_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.
