Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-13-ui-additions.md, specs/gameplay/phase-14-signature-system.md.

# Spec: UI — Phase 14 UI & Alpine Pass Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, central glacier mirror seam line, reflection highlight badges, reverse engine tail-facing chevron visualizer, and tutorial cards for Phase 14 (Alpine Pass) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases operated asymmetric tracks or distinct dual viewports.
- Phase 14 requires clear visual cues demarcating symmetrical mirror boundaries and inverted engine orientations.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Alpine Pass Reflection Visualizers
- **Glacial Mirror Seam Line (M651):**
  - Translucent crystalline blue glass seam (`#38BDF8`, opacity 0.6) running down the board midline.
  - Hovering or touching a mirror train emits a glowing reflection link ray connecting to its twin across the seam.
- **Reflection Lock Status (M652):**
  - Paired ice crystal padlocks flanking the mirror axis.
  - Unlocking triggers simultaneous ice shatter animations on both gates.
- **Twin Yard Synchronized Levers (M653):**
  - Symmetrical switch levers featuring matched color bands and synchronized flip arcs.
- **Reverse Engine Direction Badge (M654):**
  - Reversible wooden locomotive cabs render a double-ended arrow insignia on their boiler, with glowing reverse chevrons (`<<<`) indicating backward departure vector.

### 2. Tutorial Cards (`ftue_cards`)
- **L6511 (M651 Mirror Rail Axis):** "Welcome to Alpine Pass! Trains reflect across the central glacier line and move together!"
- **L6631 (M652 Reflection Lock):** "Glacier Locks are paired! Guide trains on both sides of the mirror line to open them together!"
- **L6751 (M653 Alpine Twin Yard):** "Switches on one side of the pass automatically turn their mirror switches on the other side!"
- **L6871 (M654 Reverse Engine):** "Looking-glass engines run in reverse! Tap them to back them out down the line!"

### 3. Accessibility & Symmetry Options
- Color-blind support: Distinct geometric emblems (Diamond vs Triangle) differentiate left-half and right-half mirror pairs.
- Option to toggle high-contrast midline ruler along the glacial axis.

## Affected Files
- `lib/features/gameplay/presentation/widgets/glacier_seam_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/reverse_engine_badge.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/reflection_lock_widget.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 14 tutorial cards)

## Design
- Screen: Gameplay screen during Alpine Pass levels.
- Design tokens: Frosty alpine craft aesthetic (`#38BDF8`, `#E0F2FE`, `#1E3A8A`).

## Risks
- Confusion between normal trains and reverse engines. Mitigation: Reverse engines feature distinct inverted smoke stacks and blue frost cab liveries.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_14/06_UI_AND_QA_PHASE_14.md`.
