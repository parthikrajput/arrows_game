Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-12-signature-system.md.

# Spec: UI — Phase 12 UI Additions & Hanging Loom Art

## Status
Draft

## Type
New Feature

## Goal
Specify the canvas rendering for plumb-bob gravity indicators, sliding button physics, floating silk patches, weighted wire threads, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 12 (Levels 5501–6000).

## Current State
Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md`, not yet implemented.

## Proposed Change
Implement Phase 12 visual styling and UI components in `lib/features/gameplay`:

### 1. Gravity Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Plumb Bob Gravity Indicator Widget:**
  - Heavy antique brass plumb-bob anchored to the top corner of the frame.
  - Swings and tilts dynamically to point along the active gravity vector ($\downarrow, \leftarrow, \uparrow, \rightarrow$).
  - Features an eased 250 ms harmonic pendulum oscillation on gravity direction changes.
- **Dropping Buttons:**
  - Round polished hardwood buttons with central thread stitch holes.
  - As buttons slide, they emit tiny wood-shaving dust particles along their trajectory.
- **Float Patch (Anti-gravity Tile):**
  - Ethereal sky-blue woven silk patch with an iridescent silver-stitched border.
  - Items resting on the patch exhibit a soft subtle hovering levitation shadow (`offset: (0, 3)`, `blurRadius: 4`).
- **Weighted Threads:**
  - Heavy charcoal yarn twisted around a visible braided metallic silver wire core, distinguishing them from standard pure wool threads.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P12-1 (Level 5501):** "Hanging Loom Gravity!" — Introduces gravity fields, showing how loose buttons slide when the frame hangs.
- **Card P12-2 (Level 5511):** "Plumb Levers!" — Explains tapping the plumb bob lever to redirect gravity in 4 cardinal directions.
- **Card P12-3 (Level 5631):** "Dropping Buttons!" — Demonstrates loose buttons sliding along gravity until hitting an obstacle or wall.
- **Card P12-4 (Level 5751):** "Float Patches!" — Shows that anti-gravity silk patches anchor items firmly in place against gravity forces.
- **Card P12-5 (Level 5871):** "Weighted Threads!" — Illustrates heavy metal-core threads translating 1 cell under gravity after every move.

### 3. Accessibility & Responsive Adjustments
- **Directional Compass Overlay:** The Plumb Bob widget includes prominent high-contrast cardinal arrow indicators for clear orientation.
- **Reduced Motion Support:** Gravity shifts, pendulum swings, and button slides snap instantly (0 ms) when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/gravity_painter.dart` (to be created: plumb bob & sliding button renderer)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_12.dart` (to be created: tutorial dialogs)
- `assets/images/gravity/` (to be created: plumb bob textures and float patch SVGs)

## Risks
- Multiple buttons sliding concurrently causing visual confusion. Mitigated by synchronized linear slide durations (200 ms).

## Open Questions
None. UI and tutorial requirements match Phase 12 documentation.
