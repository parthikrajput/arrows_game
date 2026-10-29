Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-7-signature-system.md.

# Spec: UI — Phase 7 UI Additions & Turning Table Art

## Status
Draft

## Type
New Feature

## Goal
Specify the canvas matrix transform rendering, embroidery hoop styling, turning hem borders, tangled thread indicators, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md`, not yet implemented.

## Proposed Change
Implement Phase 7 visual styling and UI components in `lib/features/gameplay`:

### 1. Rotational Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Sub-Board Rotor Transform (`canvas.rotate`):**
  - Rather than re-rasterizing individual cells, the $4 \times 4$ sub-grid utilizes direct 2D canvas matrix transformations:
    ```dart
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(currentAngleRadians);
    canvas.translate(-centerX, -centerY);
    _drawRotorContents(canvas);
    canvas.restore();
    ```
  - Eased 250 ms animation curve (`Curves.easeInOutCubic`).
- **Embroidery Hoop Border:**
  - Double circular polished beechwood hoop frame surrounding the $4 \times 4$ sub-board with brass tightening thumbscrew at the top edge.
- **Turning Hem Border:**
  - Folded stitched calico hem framing the board edges.
  - Open gaps render with a softly illuminated embroidered exit notch; slides along perimeter in 200 ms linear stitch steps.
- **Tangled Thread Visual State:**
  - Threads flagged in the Tangled state render with dimmed opacity (`alpha = 0.75`) and display a tiny crimson padlock badge over the needle eye.
- **Ratchet Pin:**
  - Heavy brass safety pin fastening the hoop rim to the outer board; pops open with a spring recoil when unlocked.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P7-1 (Level 3001):** "Turning Table!" — Shows how rotating a sub-grid repositions blocked thread heads to face open board edges.
- **Card P7-2 (Level 3011):** "Embroidery Hoop Rotors!" — Explains tapping the rotor center to spin the $4 \times 4$ section, cautioning that threads straddling the hoop boundary prevent rotation.
- **Card P7-3 (Level 3131):** "Turning Hems!" — Shows perimeter exit gaps advancing clockwise with every move, requiring timed unravels.
- **Card P7-4 (Level 3251):** "Twirl Threads!" — Demonstrates threads whose needles spin 90° clockwise after each move.
- **Card P7-5 (Level 3371):** "Ratchet Pins!" — Explains that clearing designated key-threads pops the safety pin, freeing locked rotors.

### 3. Accessibility & Responsive Adjustments
- **Directional Needle Indicators:** High-contrast arrow glyphs on needle heads clearly signal current heading even on small phone viewports.
- **Reduced Motion Support:** Sub-grid rotations snap instantly (0 ms) to 90° increments when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/rotor_painter.dart` (to be created: hoop & matrix rotation)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_7.dart` (to be created: tutorial dialogs)
- `assets/images/rotors/` (to be created: hoop textures and pin SVGs)

## Risks
- Canvas clipping artifacts during matrix rotation of rectangular cells. Mitigated by circular clip paths (`Path()..addOval()`) applied to the sub-board canvas layer.

## Open Questions
None. UI and tutorial requirements match Phase 7 documentation.
