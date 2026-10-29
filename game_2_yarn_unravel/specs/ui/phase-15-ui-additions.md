Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-15-base-mechanics.md.

# Spec: UI — Phase 15 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, tutorial overlays, conveyor tread animations, and accessibility adaptations for Phase 15 (Levels 7001–7500).

## Current State
Documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Conveyor & Track Visual Design
- **Feed Dog Tread Texture:**
  - Steel-toothed conveyor belts embedded on linen canvas displaying active chevron direction markers ($\gg$).
  - When reversing, belts display a 150 ms red/green directional flip flash.
- **Track Loop Circuit:**
  - Distinct rounded-rectangle stitched track with a pulsating golden needle exit marker.
- **Clutch Lever Visuals:**
  - Wooden mechanical lever widget showing an illuminated green LED when active and a red wooden brake stopper when halted.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 7001:** "Feed Dog Conveyors — Factory gears turn! Belts glide your threads forward after every move."
- **Level 7011:** "Belt Switch — Choose your track! Tap the junction switch to redirect conveyor lines."
- **Level 7131:** "Reversing Belt — Shifting currents! This belt reverses direction every few moves."
- **Level 7251:** "Belt Lever — Master the clutch! Tap the lever to stop or restart conveyor lines."
- **Level 7371:** "Track Loop — Endless loop! Ride the circuit until your needle aligns with the golden exit."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Conveyor chevrons rendered in high-contrast monochrome with double-weight arrows.
  - Direction badges on Reversing Belts display numerical move counts and cardinal arrow indicators ($N \uparrow, S \downarrow, W \leftarrow, E \rightarrow$).
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/conveyor_belt_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/belt_switch_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/track_loop_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_15_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.
