Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-14-ui-additions.md, specs/gameplay/phase-15-signature-system.md.

# Spec: UI — Phase 15 UI & Moving Platforms Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, animated tread conveyor belt tiles, directional flow chevrons, reversing lever visualizers, brake indicators, and tutorial cards for Phase 15 (Moving Platforms) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases operated static railway sleepers and switches.
- Phase 15 requires dynamic tread conveyor graphics displaying direction and flow speed.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Conveyor Belt Presentation & Flow Indicators
- **Conveyor Belt Tread Painter (M701–M704):**
  - Rubberized ribbed tread slats (`#374151`) rolling over brass cylindrical drive drums.
  - Directional amber arrows (`>>>`) scrolling continuously along the belt surface indicating conveyor vector.
- **Reversing Lever Dial (M702):**
  - Two-position brass industrial lever showing dual-headed arrow indicator (`⇄`); flips 180° upon interaction.
- **Pneumatic Brake Clamps (M703):**
  - Bright crimson brake shoe clamps that lock down onto conveyor rollers when the Stop Lever is active.
- **Loop Belt Continuous Track (M704):**
  - Circular steel rail ring with radial gear teeth meshing into a central motorized turntable hub.

### 2. Tutorial Cards (`ftue_cards`)
- **L7011 (M701 Belt Switch):** "Conveyor tracks move trains automatically every turn! Tap the Belt Switch to change the track branch!"
- **L7131 (M702 Reversing Belt):** "Pull the Reversing Lever to make the conveyor belt roll backward!"
- **L7251 (M703 Belt Stop Lever):** "Need the conveyor to hold still? Tap the Stop Lever to clamp down the brakes!"
- **L7371 (M704 Loop Belt):** "Trains in the loop belt will circulate forever! Tap them when their exit spur is clear!"

### 3. Accessibility & Motion Options
- Option to disable continuous tread motion scroll; replaces moving animation with static directional chevrons.
- High-contrast mode renders high-visibility neon cyan border around all active conveyor belts.

## Affected Files
- `lib/features/gameplay/presentation/widgets/conveyor_belt_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/reversing_lever_widget.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/brake_lever_widget.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 15 tutorial cards)

## Design
- Screen: Gameplay screen during Moving Platforms levels.
- Design tokens: Industrial clockwork and factory yard aesthetic (`#4B5563`, `#F59E0B`, brass and steel accents).

## Risks
- Scrolling tread textures causing GPU fill rate overhead. Mitigation: Rendered via cached shader paint with simple UV offset.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_15/06_UI_AND_QA_PHASE_15.md`.
