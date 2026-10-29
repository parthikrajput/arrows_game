Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-9-signature-system.md.

# Spec: UI — Phase 9 UI Additions & Ply-Twist Atelier Art

## Status
Draft

## Type
New Feature

## Goal
Specify the canvas rendering for twisting pads, half-ply thread strokes, rejoin buckles, stitch locks, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 9 (Levels 4001–4500).

## Current State
Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md`, not yet implemented.

## Proposed Change
Implement Phase 9 visual styling and UI components in `lib/features/gameplay`:

### 1. Split & Merge Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Twisting Pad (Merger Pad):**
  - Polished hardwood oval frame holding a spiral wool fleece pad across 2 adjacent cells.
  - When two eligible needles arrive, the pad activates with an ambient golden glow pulse (`alpha = 0.6`).
  - Upon tapping, a 180 ms twisting animation wraps both threads together with rotating spiral shaders.
- **Double Split (Twin Splitter):**
  - Precision dual brass guide eyelets set into linen.
  - Child plies render at exactly half standard stroke width (2.5 dp vs standard 5 dp) to visibly communicate half-ply status.
- **Stitch Lock (Segment Lock):**
  - Tiny silver safety clasp clamped around a thread body segment.
  - Carries a colored jewel inlay matching its prerequisite key-thread.
- **Rejoin Gate:**
  - Heavy ornamental belt buckle gate.
  - Shines with a partial amber glow when 1 of 2 child plies has passed; snaps open with full golden glint when both plies exit.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P9-1 (Level 4001):** "Ply & Twist!" — Explains that threads can divide into parallel half-plies or merge into thick yarns.
- **Card P9-2 (Level 4011):** "Twisting Pads!" — Demonstrates landing two needles on the pad and tapping it to twist them into one.
- **Card P9-3 (Level 4131):** "Double Splitters!" — Shows a thread passing through the eyelets to split into two parallel half-ply threads.
- **Card P9-4 (Level 4251):** "Stitch Locks!" — Illustrates a clamped segment that cannot move until its designated key-thread exits.
- **Card P9-5 (Level 4371):** "Rejoin Gates!" — Explains that both split plies must pass through the buckle before it unlocks.

### 3. Accessibility & Responsive Adjustments
- **Half-Ply Stroke Contrast:** High-contrast edge outlines ensure thin half-plies remain legible on high-DPI displays.
- **Reduced Motion Support:** Thread twisting and splitting snap instantly (0 ms) when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/ply_twist_painter.dart` (to be created: pad, splitter, and buckle rendering)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_9.dart` (to be created: tutorial dialogs)
- `assets/images/ply_twist/` (to be created: buckle and splitter textures)

## Risks
- Thin 2.5 dp half-ply threads being hard to see on small viewports. Mitigated by pinch-zoom capability and dark drop shadows.

## Open Questions
None. UI and tutorial requirements match Phase 9 documentation.
