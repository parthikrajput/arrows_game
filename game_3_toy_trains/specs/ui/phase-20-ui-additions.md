Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-19-ui-additions.md, specs/gameplay/phase-20-signature-system.md.

# Spec: UI — Phase 20 UI & Grand Sovereign Terminus Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, Marching Clock Tower boss visuals, footprint crush danger overlays, supreme convergence HUD indicators, grand celebration modal, and tutorial cards for Phase 20 (Grand Master) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases handled standard 2x2 boss towers or kinetic tracks.
- Phase 20 requires an imposing 3x3 marching boss structure, crushed track indicators, and the game's ultimate completion ceremony UI.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Marching Boss & Omni-Convergence Visualizers
- **3x3 Marching Clock Tower (Level 10000):**
  - Colossal carved cathedral clock tower occupying a 3x3 grid footprint. Features moving mechanical cog legs, dual pendulum chimes, and a 12-segment golden boss HP meter.
- **Footprint Danger Warning Overlay:**
  - Red pulsing hazard warning stripes (`#EF4444`) on the row of track cells directly ahead of the marching boss, signaling impending footprint crush.
- **Crushed Track Splinter Tiles:**
  - Track tiles trampled beneath the boss render as shattered wooden splinters and twisted iron rails.
- **Level 10,000 Grand Sovereign Victory Ceremony:**
  - Full-screen gold-leaf victory banner, crown awarding sequence, permanent stats recap modal (10,000 levels cleared, total trains dispatched, stars collected), and golden liveries showcase.

### 2. Tutorial Cards (`ftue_cards`)
- **L9511 (M951 Conveyor Guardian):** "The Clock Tower sits inside an automated conveyor! Time your exits to deal damage to the tower!"
- **L9631 (M952 Gravity Mirror Relay):** "Flipping this lever changes gravity in opposite directions on Table A and Table B!"
- **L9751 (M953 Day/Night Master Pass):** "Wait for the Night Phase! At night, this train transforms into an invincible skeleton key!"
- **L9871 (M954 Prism Bloom Arch):** "Feed wild ivy to the arch while aiming the colored light beam at its crystal peak to unlock the way!"
- **L10000 (The Marching Boss):** "The Marching Clock Tower advances every 5 moves, crushing rails beneath it! Clear trains and destroy it before it reaches the station!"

### 3. Accessibility & Climax Presentation
- Reduce-motion mode replaces marching camera shake with static warning banner.
- High-contrast mode renders high-visibility yellow perimeter around the marching boss entity.

## Affected Files
- `lib/features/gameplay/presentation/widgets/marching_boss_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/crushed_track_tile.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/grand_sovereign_modal.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 20 tutorial cards)

## Design
- Screen: Gameplay screen during Phase 20 and Level 10,000 Climax.
- Design tokens: Imperial gold and royal purple palette (`#7C3AED`, `#F59E0B`, `#FDE047`, `#1F2937`).

## Risks
- 3x3 boss geometry occluding large swathes of the board. Mitigation: Semi-transparent X-ray silhouette rendered for trains obstructed behind boss tower.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_20/06_UI_AND_QA_PHASE_20.md`.
