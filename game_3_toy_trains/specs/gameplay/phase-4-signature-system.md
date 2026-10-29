Source docs: phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-3-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 4 Signature System (Station Floors Multi-Floor)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 4 signature system "Station Floors" (Multi-Floor `S04`): a 3D multi-level terminus station architecture spanning up to three vertical floors (F1 Ground Yard, F2 Mezzanine Platform, F3 High Line Viaduct) with floor navigation tabs, vertical train transport, and multi-floor solver models.

## Current State
Design documented in `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md`, `phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated within a single 2D board plane with local elevation viaducts (M032, M069).
- Phase 4 introduces true multi-floor station levels where each floor has its own independent grid layer.

## Proposed Change
Extend `packages/puzzle_core` with a `MultiFloorBoard` representation and floor switching controls:

### 1. Multi-Floor Station Architecture
- **Floor Hierarchy:** Up to 3 vertical station floors per level:
  - `F1`: Ground Yard (Base level depot and heavy shunting tracks).
  - `F2`: Mezzanine Platform (Passenger platforms and pedestrian crossings).
  - `F3`: High Line Viaduct (Elevated perimeter tracks and bypass lines).
- **Navigation Controls:**
  - Viewport features floating floor selector tabs (`F1`, `F2`, `F3`) on the right HUD.
  - Tapping a floor tab switches camera viewport to that floor instantly (or via smooth vertical slide).
  - Floor switching costs **0 Moves**, does not advance move counters, and causes no heart loss.
- **Inter-Floor Relationships:**
  - Solid wooden ceilings obscure lower floors by default, except where transparent Glass Platforms (M152) or vertical shafts (M151, M153, M154) exist.
  - Trains can only interact or collide with obstacles and other trains on their active floor.

### 2. Vertical Train Routing Lifecycle
- When an exiting train encounters a vertical portal (Station Stairs M151, Goods Chute M153, or Goods Lift M154):
  - The train transitions across floor boundaries along its heading vector.
  - Target cell must be clear on arrival; if occupied, triggers buffer clack bump (-1 heart).
  - Relocation moves (Goods Chute) position the train onto the new floor awaiting a subsequent tap to resume departure.

### 3. Solver Heuristics & Determinism
- Stateful solver models multi-floor boards as a 3D coordinate tensor `(x, y, floor)`.
- State key: `(remainingTrainsByFloor, verticalPortalStates, activeFloor)`.
- Reverse construction places trains on target floors first, ensuring all vertical transport transitions are provably solvable.

## Affected Files
- `packages/puzzle_core/lib/src/models/multi_floor_board.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/floor_manager.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/floor_tab_bar.dart` (to be created)

## Design
- HUD Element: Vertical pill selector on right edge with brass engraved buttons ("F1", "F2", "F3").
- Active floor glows with golden train track border.

## Risks
- Player confusion regarding which floor contains remaining un-cleared trains. Mitigation: Floor tabs display a mini badge showing the count of remaining trains on that floor (e.g. "F2 (3)").

## Open Questions
- None. Multi-floor rules, camera transitions, and portal mechanics match `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §11.

