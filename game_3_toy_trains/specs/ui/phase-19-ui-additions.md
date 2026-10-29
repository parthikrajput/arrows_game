Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-18-ui-additions.md, specs/gameplay/phase-19-signature-system.md.

# Spec: UI — Phase 19 UI & Remix B Kinetic Synergy Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, rotating turntable coupling overlays, incline seed trail painters, cross-table metronome dials, scythe pruner blades, and tutorial cards for Phase 19 (Remix B) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered individual kinetic components.
- Phase 19 requires composite visualizers linking turntable rotors, sliding gravity carts, and biological ivy growth.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Kinetic Synergy Visualizers
- **Turntable Coupler Disc (M901):**
  - Circular brass turntable disc embedded with magnetic buffer clamps. Angle indicator displays alignment lock status (`0° / 90° / 180° / 270°`).
- **Incline Spore Trail (M902):**
  - Luminous green spore particle trail trailing behind sliding seed wagons, with countdown pips showing sprout timing.
- **Cross-Table Bridge Metronome Dial (M903):**
  - Brass metronome meter spanning the gap between Table A and Table B showing synchronized beat status.
- **Twin Scythe Blades (M904):**
  - Whirling brass circular blades mounted on split train locomotive flanks, indicating ivy-clearing radius.

### 2. Tutorial Cards (`ftue_cards`)
- **L9011 (M901 Turntable Coupling Pad):** "Rotate the turntable yard to align the coupling pads with incoming trains!"
- **L9131 (M902 Incline Seed Wagon):** "The Seed Wagon rolls downhill and drops ivy seeds! Clear the path before they sprout!"
- **L9251 (M903 Cross Metronome Gate):** "Watch the beat of the bridge gate when sending trains between Table A and Table B!"
- **L9371 (M904 Hedge Split Pruner):** "Split this engine to send both pruners down parallel tracks and chop away wild ivy!"

### 3. Accessibility & Motion Options
- Option to freeze rotary turntable animation into instantaneous 90° snap.
- Color-blind support: Patterned icons distinguish sprout timers from standard countdown numbers.

## Affected Files
- `lib/features/gameplay/presentation/widgets/turntable_coupler_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/spore_trail_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 19 tutorial cards)

## Design
- Screen: Gameplay screen during Remix B levels.
- Design tokens: Kinetic wooden railway with overgrown mechanical elements (`#059669`, `#D97706`, `#2563EB`).

## Risks
- Multiple kinetic elements causing cognitive overload. Mitigation: Tutorial cards highlight the primary dynamic hazard first upon level load.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_19/06_UI_AND_QA_PHASE_19.md`.
