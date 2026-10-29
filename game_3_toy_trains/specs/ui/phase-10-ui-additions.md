Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-9-ui-additions.md, specs/gameplay/phase-10-signature-system.md.

# Spec: UI — Phase 10 UI & Timetable Sequencing Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, metronome beat visualizers, departure code ribbons, numbered platform order badges, echo sequence buffers, and tutorial cards for Phase 10 (Timetable Master Sequencing) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases provided coupling pads, visual split seams, and switch levers.
- Phase 10 requires real-time chronological and rhythm indicators on the game board and HUD.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Timetable & Sequencing Visualizers
- **Metronome Beat Indicator (M451):**
  - Clockwork brass pendulum meter mounted above the metronome gate archway.
  - Swings synchronously with each move tick; previews whether the gate will be "Open" (green dial) or "Closed" (red dial) on the next move.
- **Departure Code Ribbon (M452):**
  - Overhead wooden ribbon banner displaying required train departure colors (e.g. 🔴 -> 🔵 -> 🟢).
  - Successfully dispatched trains trigger an animated gold checkmark (✓) and glowing highlight on the corresponding ribbon slot.
- **Platform Order Badges (M453):**
  - Numbered enamel discs (①, ②, ③) rendered directly on platform exit tracks.
  - Discs dim or glow depending on whether that platform is the currently valid departure step.
- **Echo Sequence Buffer (M454):**
  - Circular clockwork HUD dock containing $N$ memory slots displaying the recent departure colors to mirror.

### 2. Tutorial Cards (`ftue_cards`)
- **L4511 (M451 Metronome Gate):** "This gate opens and closes to a steady rhythm! Watch the beat before sending your train!"
- **L4631 (M452 Departure Code Lock):** "Trains must exit in the exact color sequence shown on the billboard to open this gate!"
- **L4751 (M453 Platform Order Exit):** "Numbered platforms only accept trains in ascending order: 1, then 2, then 3!"
- **L4871 (M454 Echo Signal):** "Echo Signal remembers departing train colors! Your next departures must mirror the pattern!"

### 3. Accessibility & High-Contrast Support
- Pattern/symbol shapes accompany color codes on ribbons and echo buffers (e.g., Circle = Red, Square = Blue, Triangle = Green).
- Reduced-motion mode replaces swinging pendulum with instant binary dial flip (Open/Closed text label).

## Affected Files
- `lib/features/gameplay/presentation/widgets/metronome_indicator_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/departure_ribbon_bar.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/platform_order_badge.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 10 tutorial cards)

## Design
- Screen: Gameplay screen during Timetable Master levels.
- Design tokens: Consistent with wooden toy railway clockwork aesthetic (`#B45309`, `#F59E0B`, brass finishes).

## Risks
- Cluttered screen if ribbon bar overlays puzzle grid on smaller phone screens. Mitigation: Anchor ribbon bar to the top-center HUD above the puzzle grid.

## Open Questions
- None. UI components and tutorial triggers match `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `SHARED_CORE_STANDARD.md`.
