Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-11-ui-additions.md, specs/gameplay/phase-12-signature-system.md.

# Spec: UI — Phase 12 UI & Hill Line Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, gravity direction compass hud, sliding crate motion trails, balloon floating indicators, and tutorial cards for Phase 12 (Hill Line) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered stationary obstacles or player-pushed carts.
- Phase 12 introduces environmental gravity indicators and autonomous rolling trajectories.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Incline & Gravity Visualizers
- **Gravity Direction Compass (HUD):**
  - Brass compass mounted at top-center HUD featuring a carved wooden mountain arrow.
  - Rotates dynamically 90° whenever M551 Tilt Lever is activated, clearly displaying the current board slope (`Down`, `Left`, `Up`, `Right`).
- **Loose Crate Motion Trails (M552):**
  - Faint wooden friction streak lines behind moving crates indicating sliding path.
- **Balloon Suspension Halo (M553):**
  - Buoyant bobbing animation with gentle floating shadows for crates captured on Balloon Pads.
- **Ballast Train Weight Gauge (M554):**
  - Cast-iron weight dial on locomotive roof displaying forward momentum when aligned with gravity slope.

### 2. Tutorial Cards (`ftue_cards`)
- **L5511 (M551 Tilt Lever):** "Tap the Tilt Lever to change the slope of the railway! Watch which way things slide!"
- **L5631 (M552 Loose Crates):** "Loose crates slide downhill with the slope! Use them to clear paths or block hazards!"
- **L5751 (M553 Balloon Pad):** "Crates floating on Balloon Pads won't slide downhill! Bump them with a train to move them!"
- **L5871 (M554 Ballast Train):** "Heavy Ballast Trains roll downhill on their own if the track is clear!"

### 3. Accessibility & Motion Options
- Option to display persistent high-contrast direction arrows across the tabletop wood grain (`#B45309`).
- Reduced-motion mode disables floating crate bobbing, keeping static floating shadows.

## Affected Files
- `lib/features/gameplay/presentation/widgets/gravity_compass_widget.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/crate_slide_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 12 tutorial cards)

## Design
- Screen: Gameplay screen during Hill Line levels.
- Design tokens: Consistent with mountain railway and crafted wood motifs.

## Risks
- Rapid compass rotations causing visual disorientation. Mitigation: Smooth 200 ms cubic ease rotation curve.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_12/06_UI_AND_QA_PHASE_12.md`.
