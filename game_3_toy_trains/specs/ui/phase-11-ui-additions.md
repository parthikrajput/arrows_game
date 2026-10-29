Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-10-ui-additions.md, specs/gameplay/phase-11-signature-system.md.

# Spec: UI — Phase 11 UI & Twin Tables Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the user interface additions, dual-table viewport camera controls, bridge chevron flow overlays, cross-board ticket link indicators, and tutorial cards for Phase 11 (Twin Tables) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered a single board grid plane.
- Phase 11 introduces side-by-side or stacked dual sub-boards with connecting transit links.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Twin Tables Viewport & Cross-Board Visualizers
- **Dual Table Layout:**
  - Landscape mode: Table A and Table B rendered side-by-side with wooden bridge gap.
  - Portrait mode: Table A and Table B stacked vertically.
  - Multi-touch camera controller supports pinch-to-zoom and pan across both boards.
- **Bridge Flow Chevrons (M501):**
  - Animated glowing gold directional chevrons (`>>>`) along the connecting bridge trestle indicating train transit trajectory.
- **Cross-Board Ticket Link Beam (M502):**
  - Faint ethereal cyan tracer line rendered between the collectible ticket on Table A and its corresponding barrier gate on Table B.
- **Mirror Train Emblem (M503):**
  - Dual-ring mirror symbol (⚏) hovering above the roof cab of synchronized twin trains.
- **Relay Tunnel Portals (M504):**
  - Matching color-banded stone tunnel portals on Table A and Table B indicating paired wormholes.

### 2. Tutorial Cards (`ftue_cards`)
- **L5011 (M501 Table Bridge):** "Tracks can cross between Table A and Table B via wooden bridges! Watch for incoming trains!"
- **L5131 (M502 Inter-table Ticket):** "Collect this ticket on Table A to unlock the barrier gate on Table B!"
- **L5251 (M503 Mirror Table):** "Twin trains move together across both tables in mirrored directions! Clear both paths!"
- **L5371 (M504 Relay Tunnel):** "Enter this tunnel on Table A to instantly emerge on Table B!"

### 3. Accessibility & Low-Vision Options
- Option to toggle high-contrast board borders (Table A in Navy Blue trim, Table B in Terracotta Orange trim).
- Zoom reset button in HUD resets view to frame both boards simultaneously.

## Affected Files
- `lib/features/gameplay/presentation/widgets/twin_table_viewport.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/bridge_flow_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/cross_board_link_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 11 tutorial cards)

## Design
- Screen: Gameplay screen during Twin Table levels.
- Design tokens: Consistent with wooden railway craft aesthetic.

## Risks
- Touch targeting small train tiles on zoomed-out dual views. Mitigation: Minimum tap hit box clamped to 48x48 dp regardless of camera zoom factor.

## Open Questions
- None. UI visualizers and tutorial copy match `phase/phase_11/06_UI_AND_QA_PHASE_11.md`.
