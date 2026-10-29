Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, specs/ui/ui-ux-screens.md, SHARED_CORE_STANDARD.md §13, §14. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/phase-7-base-mechanics.md.

# Spec: UI — Phase 7 UI Additions (Turntable HUD & Rotation Cues)

## Status
Draft

## Type
New Feature

## Goal
Design and integrate UI elements for Phase 7: turntable center button states, perimeter turning hedge gap markers, spinning top propeller glyphs, pinned daisy anchor lock visuals, and Phase 7 tutorial notification cards.

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Current UI handles translation and optical paths.
- Circular sub-board rotation handles, rotating edge wall cues, and rotation anchor lock feedback do not exist.

## Proposed Change
Extend Flutter UI widgets in `lib/features/gameplay/widgets/`:

### 1. Flower-Bed Turntable Center Button
- Positioned at the exact geometric center of rotating circular flower beds (M301):
  - Displays a rotating floral dial with curved clockwise arrow glyphs.
  - Interactive State:
    - **Active:** Glowing golden button; tapping triggers smooth 250 ms rotational spin.
    - **Locked (Pinned or Boundary Straddled):** Button turns muted stone grey with a miniature padlock icon; tapping triggers a 150 ms locked shake and temporary tooltip: *"Line crossing boundary!"* or *"Anchored by Pinned Daisy!"*.

### 2. Turning Hedge Perimeter Edge Markers
- Rotating outer edge walls (M302) display small glowing chevron arrows along their borders indicating clockwise shifting direction.
- Open exit gaps highlight with soft green beacon flares to attract player attention to valid exit lanes.

### 3. Spinning Top Line Propeller Glyphs
- Spinning Top insect lines (M303) render with small animated propeller wings on their head, rotating gently while idle.
- An animated curved arrow above the head indicates the direction the line will face on the next turn.

### 4. Phase 7 Tutorial Overlay Cards
One-line non-modal notification banner presented at the top of the board during intro levels:
- **L3011:** *"Flower-Bed Turntable — Tap the center button to rotate the flower bed 90° clockwise!"*
- **L3131:** *"Turning Hedge — Outer hedge walls shift every few moves. Time your exit with the gaps!"*
- **L3251:** *"Spinning Top Line — This line turns 90° every time you move another insect."*
- **L3371:** *"Pinned Daisy — Deep-rooted daisy flowers anchor the turntable. Clear this line first!"*

## Affected Files
- `lib/features/gameplay/widgets/turntable_button_widget.dart` (to be created)
- `lib/features/gameplay/widgets/perimeter_hedge_painter.dart` (to be created)
- `lib/features/gameplay/widgets/tutorial_banner.dart` (changed to include Phase 7 cards)

## Design
- Matches design tokens in `specs/ui/ui-ux-screens.md`: 2D `CustomPainter` with soft-3D gradients, pre-baked drop shadows, and 48x48 dp minimum touch bounds.

## Risks
- Touch ambiguity between turntable center button and adjacent insect lines. Mitigated by expanding the central button touch target to 48 dp and establishing center tap precedence over underlying grid cells.

## Open Questions
- None. UI components and rotation cues match `phase/phase_7/06_UI_AND_QA_PHASE_7.md` §1.
