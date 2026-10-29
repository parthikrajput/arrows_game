Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-17-ui-additions.md, specs/gameplay/phase-18-signature-system.md.

# Spec: UI — Phase 18 UI & Remix A Synergy Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, compound synergy status badges, multi-system HUD dials, cart elevator indicators, optical prism beam tracers, and tutorial cards for Phase 18 (Remix A) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered isolated mechanics on individual layers.
- Phase 18 requires composite presentation widgets showing interlocked mechanic states.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Multi-System Synergy Visualizers
- **Day/Night Ticket Cart Badge (M851):**
  - Shuntable cart displays a dynamic solar sun / lunar crescent crest that shifts glowing color whenever passing through a day/night tunnel.
- **Station Lift Floor Indicator (M852):**
  - Vertical elevator shaft wireframe featuring glowing level arrows (`▲ F2`, `▼ F1`) and cart weight capacity icons.
- **Prism Sensor Alignment Reticle (M853):**
  - Multi-faceted crystalline prism overlay showing refracted color split beams directed at optical sensors.
- **Ice Chute Drop Target (M854):**
  - Concentric target rings on lower-floor blackout patches highlighting where sliding ice carts will land.

### 2. Tutorial Cards (`ftue_cards`)
- **L8511 (M851 Day/Night Ticket Cart):** "Push the Ticket Cart through Day/Night Tunnels to change its active time cycle!"
- **L8631 (M852 Floor Shunting Lift):** "Push carts onto the Station Lift to send them up to Floor 2!"
- **L8751 (M853 Prism Signal Sensor):** "Aim the Signal Light Beam through the Prism to strike the sensor and lower the bridge!"
- **L8871 (M854 Ice Cart Blackout Chute):** "Slide Ice Carts into goods chutes to drop them into dark pits and complete the line below!"

### 3. Accessibility & HUD Consolidation
- Combined Synergy HUD minimizes clutter by unifying the Day/Night dial, floor selector tabs, and beam status into an ergonomic top-right corner dock.
- High-contrast lines clearly demarcate multi-floor chute trajectories.

## Affected Files
- `lib/features/gameplay/presentation/widgets/synergy_hud_dock.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/prism_beam_tracer.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 18 tutorial cards)

## Design
- Screen: Gameplay screen during Remix A levels.
- Design tokens: Synthesis of vintage wooden craftsmanship with polished brass and optical crystal accents.

## Risks
- Screen clutter from overlapping HUD widgets. Mitigation: Unified synergy dock auto-collapses inactive indicators.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_18/06_UI_AND_QA_PHASE_18.md`.
