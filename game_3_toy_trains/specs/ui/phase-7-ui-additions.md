Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-6-ui-additions.md, specs/gameplay/phase-7-signature-system.md.

# Spec: UI — Phase 7 UI & Rotational Yard Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, 4x4 rotor disc rendering, perimeter moving exit indicators, clockwork spinner visual badges, and tutorial dialogs for Phase 7 (Turntable Yards+) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases handled planar tracks, optical beams, and multi-floor elevators.
- Phase 7 requires dynamic rendering of large rotating 4x4 circular wooden discs, perimeter moving exits, and clockwork locomotive dials.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Rotational Mechanics Visual Controls
- **4x4 Sub-Board Rotor Disc:**
  - Rendered as a massive circular inlaid wooden roundhouse turntable disc (`#78350F`) with brass peripheral gear cogs.
  - Central brass hub features an interactive lever knob.
  - Rotation animation runs a smooth 300 ms 90° ease-out angular tween (`Curves.easeInOutCubic`).
  - Straddling train collision warning: hovering lever highlights overlapping trains in warning red.
- **Perimeter Spinning Exits:**
  - Table border features wooden track grooves along which green illuminated exit arrows slide smoothly each move.
  - Aligned exits pulse with a gentle green depot lantern glow (`#10B981`).
- **Spinner Engine Clockwork Dial:**
  - Spinner Engine (M303) displays a brass winding key on its cab roof that visibly twirls 90° CW whenever any Move is completed.
- **Turntable Lock Overlay:**
  - Heavy cast-iron locking bar overlays the central lever of locked rotors, accompanied by a miniature padlock icon until the key train departs.

### 2. Tutorial Cards (`ftue_cards`)
- **L3001 (Turntable Yards Intro):** "Welcome to the Grand Rotary Yard! Tap central turntable levers to rotate entire track sectors!"
- **L3011 (4x4 Rotor):** "Big 4x4 Turntables rotate all trains inside them! Make sure no trains are caught on the border!"
- **L3131 (Spinning Exits):** "The station exit gates are moving around the border! Time your train departures to meet the open gate!"
- **L3251 (Spinner Engine):** "Clockwork Spinner Engines rotate 90° on every single Move you make! Plan ahead to catch the right track!"
- **L3371 (Turntable Lock):** "This Turntable is locked! Clear the Key Engine off the board first to unlock the rotation lever!"

### 3. Accessibility & Rotational Clarity
- High-contrast directional curved arrows stamped on the wooden rotor surface indicate CW rotation.
- Route Peek long-press on a rotor lever projects circular ghost rotation previews showing where trains will land after rotation.

## Affected Files
- `lib/features/gameplay/presentation/widgets/rotor_disc_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/spinning_exit_border.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 7 tutorial cards)

## Design
- Screen: Gameplay screen during rotary yard levels.
- Design tokens: Consistent with Phase 1–6 wooden toy railway aesthetic.

## Risks
- Rotation animation causing visual clipping with static tracks outside rotor bounds. Mitigation: Clip rotor disc rendering to circular path with 1 dp margin.

## Open Questions
- None. UI components and tutorial triggers match `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `SHARED_CORE_STANDARD.md`.
