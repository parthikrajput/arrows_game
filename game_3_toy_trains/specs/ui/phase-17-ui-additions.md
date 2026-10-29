Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-16-ui-additions.md, specs/gameplay/phase-17-signature-system.md.

# Spec: UI — Phase 17 UI & Clock Towers Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, multi-cell wooden clock tower graphics, overhead boss HP health bars, shield sequence banners, spawner countdown dials, and tutorial cards for Phase 17 (Clock Towers) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered flat board tiles and barriers.
- Phase 17 introduces massive multi-tile 3D wooden clock tower structures, animated ticking pendulums, and dynamic boss health bars.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Clock Tower Guardian Visualizers
- **Clock Tower 2x2 Structures (M801–M804):**
  - Carved wooden clock towers with Roman numeral dials, brass gear gables, and animated swinging pendulums.
- **Overhead Guardian HP Bars:**
  - Segmented brass-trimmed health meter floating above each clock tower displaying remaining HP pips.
  - Decrements with a red damage flash and floating "-1" combat text.
- **Armour Sequence Ribbon (M802):**
  - Billboard banner suspended on the tower displaying required train departure colors (e.g. 🔴 -> 🔵 -> 🟡).
- **Spawner Cooldown Dial (M803):**
  - Rotating clock hand on depot roof counting down moves remaining until next Buffer Stop spawn.
- **Clock Core Target Indicator (M804):**
  - Radiant optical crosshair reticle hovering over the 0 HP core, highlighting alignment with incoming signal light beams.

### 2. Tutorial Cards (`ftue_cards`)
- **L8011 (M801 Twin Clock Towers):** "These Guardian Clock Towers block the yard! Dispatch trains from adjacent tracks to deal damage to their shared HP!"
- **L8131 (M802 Armoured Clock Tower):** "This tower is shielded! Dispatch trains in the exact color sequence shown on the billboard to break its armor!"
- **L8251 (M803 Depot Tower):** "Watch out! The Depot Tower spawns new buffer stops every few turns! Bring its HP to zero to shut it down!"
- **L8371 (M804 Clock Core):** "The Clock Core is vulnerable! Once its HP hits zero, direct a Signal Light Beam onto it to destroy it permanently!"

### 3. Accessibility & Low-Vision Support
- Textual HP display option (e.g. `HP: 3/6`) alongside visual health bar pips.
- Screen reader announces spawner countdown warning when cooldown reaches 1 move.

## Affected Files
- `lib/features/gameplay/presentation/widgets/clock_tower_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/guardian_hp_bar.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/shield_sequence_banner.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 17 tutorial cards)

## Design
- Screen: Gameplay screen during Clock Tower levels.
- Design tokens: Clockwork citadel motif (`#78350F`, `#D97706`, `#F59E0B`, brass finishes).

## Risks
- Large 2x2 towers visually occluding trains parked immediately behind them. Mitigation: Semi-transparent silhouette outline rendered for trains situated behind tower geometry.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_17/06_UI_AND_QA_PHASE_17.md`.
