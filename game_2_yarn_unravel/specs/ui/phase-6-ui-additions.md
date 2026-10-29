Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-6-signature-system.md.

# Spec: UI — Phase 6 UI Additions & Optical Atelier Art

## Status
Draft

## Type
New Feature

## Goal
Specify the visual rendering, chromatic beam shaders, shadow vignette overlays, HUD status pips, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md`, not yet implemented.

## Proposed Change
Implement Phase 6 visual styling and UI components in `lib/features/gameplay`:

### 1. Optical Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Light Beams (`BlendMode.plus`):**
  - Beams drawn as linear geometric paths using `BlendMode.plus` blending.
  - Soft luminous glow achieved via pre-baked multi-stop alpha gradient stroke (`Color(0xFFFFE082)` at core, fading to `0x00FFE082` at edges).
  - Explicitly avoids runtime `MaskFilter.blur` to safeguard 60 fps mobile rasterization budgets.
- **Shadow Pockets (Dark Cells):**
  - Darkened regions render with a soft twilight vignette fabric shader (`alpha = 0.40`).
  - When light touches a shadow cell, the darkness dissipates via a 150 ms linear alpha fade, revealing underlying thread details.
- **Prism Clasp Indicators:**
  - Faceted crystal body featuring numeric status pips (`0/2`, `1/2`, `2/2`) denoting active incident rays.
  - Emits bright central star glint when both beam slots are activated.
- **Hourglass Lamp (M253):**
  - Brass lantern body featuring glowing runic move indicators showing intervals remaining before next toggle (e.g., `3/3`).
- **M251 Tinted Glass:**
  - Translucent colored glass pane with beveled golden frame and high-contrast color glyph overlay.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P6-1 (Level 2501):** "Lamplight Atelier!" — Shows an atelier lamp casting a beam across the board, illustrating how unraveling an obstructing thread lets the beam reach its goal.
- **Card P6-2 (Level 2511):** "Tinted Glass Filters!" — Shows white light passing through green glass to produce a green ray, opening a green Sun-Catcher.
- **Card P6-3 (Level 2631):** "Prism Clasps!" — Demonstrates intersecting two beams from different directions to shatter a heavy crystal lock.
- **Card P6-4 (Level 2751):** "Hourglass Lamps!" — Explains turn-based beam oscillation (beams toggle ON/OFF every 3 moves, independent of real time).
- **Card P6-5 (Level 2871):** "Shadow Pockets!" — Explains that threads hidden in shadow cells cannot be tapped until a light beam shines over them.

### 3. Accessibility & Responsive Adjustments
- **Color-Blind Optical Encoding:**
  - All chromatic filters (M251) and matching Sun-Catchers carry distinctive geometric embossings (Red = Triangle, Green = Diamond, Blue = Circle, Amber = Square).
- **Reduced Motion Support:**
  - Beam pulse animations and shadow fade transitions snap instantly when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/optical_painter.dart` (to be created: ray & filter rendering)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_6.dart` (to be created: tutorial dialogs)
- `assets/images/optical/` (to be created: lamp, prism, and glass textures)

## Risks
- Ray visual clutter when multiple colored beams intersect. Mitigated by additive `BlendMode.plus` blending that naturally brightens intersecting paths.

## Open Questions
None. UI and tutorial requirements match Phase 6 documentation.
