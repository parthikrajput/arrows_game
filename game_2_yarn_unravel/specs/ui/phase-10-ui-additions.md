Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-10-signature-system.md.

# Spec: UI — Phase 10 UI Additions & Pattern Book Art

## Status
Draft

## Type
New Feature

## Goal
Specify the canvas rendering for metronome pendulums, chromatic sequence brooches, numbered hem stitches, echo cards, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 10 (Levels 4501–5000).

## Current State
Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md`, not yet implemented.

## Proposed Change
Implement Phase 10 visual styling and UI components in `lib/features/gameplay`:

### 1. Sequencing Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Metronome Gate (Rhythm Gate):**
  - Carved beechwood pendulum needle oscillating smoothly on an eased 150 ms curve across each valid player move.
  - Open state: Warm emerald fabric glow (`Color(0xFF81C784)`).
  - Closed state: Crimson basting cross-stitches framing the gate boundaries.
- **Pattern Clasp Brooch:**
  - Jeweled filigree brooch displaying sequential woolen yarn pips.
  - As correct threads unravel, an embroidered gold checkmark stamps down onto that pip with a subtle spring scale animation.
- **Ordered Hem Markings:**
  - Gilded Roman numerals or Arabic digits ($1, 2, 3$) cross-stitched directly onto perimeter border canvas cells.
  - Currently expected number pulses softly with an amber border glow.
- **Echo Card HUD Widget:**
  - Compact sewing swatch card anchored in the top corner, recording and displaying the $k$-color sequence prefix.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P10-1 (Level 4501):** "Pattern Book Sequencing!" — Explains that threads must unravel in coordinated order to satisfy design goals.
- **Card P10-2 (Level 4511):** "Metronome Gates!" — Demonstrates rhythmic open/close cycles linked to move counts.
- **Card P10-3 (Level 4631):** "Pattern Clasps!" — Illustrates matching the exact color sequence shown on the brooch to open it.
- **Card P10-4 (Level 4751):** "Ordered Hems!" — Shows that border numbers dictate the exact sequence threads must follow to exit without snagging.
- **Card P10-5 (Level 4871):** "Echo Cards!" — Demonstrates repeating the color order established by your first few unraveled threads.

### 3. Accessibility & Responsive Adjustments
- **Dual Visual Encoding:** All color sequence indicators feature shape emblems (triangle, diamond, star) alongside hues for color-blind players.
- **Reduced Motion Support:** Metronome pendulums snap instantaneously (0 ms) when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/sequence_painter.dart` (to be created: metronome & brooch rendering)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_10.dart` (to be created: tutorial dialogs)
- `assets/images/sequencing/` (to be created: brooch SVGs and metronome textures)

## Risks
- Cluttered screen space with multiple floating HUD cards. Mitigated by compact 36 dp swatch card footprints.

## Open Questions
None. UI and tutorial requirements match Phase 10 documentation.
