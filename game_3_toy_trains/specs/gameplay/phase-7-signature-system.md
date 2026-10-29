Source docs: phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 7 Signature System (Turntable Yards+ Rotations)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 7 signature system "Turntable Yards+" (Rotations+ `S07`): advanced rotational railway yard dynamics featuring 4x4 sub-board turntable rotors, perimeter rotating exits, auto-spinning engines, and mechanical rotation locks for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md`, `phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured single-cell turntables (M013) and 3x3 rotating clusters (M091).
- Phase 7 expands rotational mechanics into large 4x4 sub-board turntable zones and perimeter moving exits.

## Proposed Change
Extend `packages/puzzle_core` with 4x4 rotor matrix transformations and rotational solver states:

### 1. Rotor Matrix Transformation Rules
- **4x4 Sub-Board Rotor (M301):**
  - Defines a $4 \times 4$ localized grid section with central rotation lever.
  - Tapping the lever (1 Move) transforms all coordinates within the rotor bounds by 90° Clockwise:
    $$\begin{pmatrix} x' \\ y' \end{pmatrix} = \begin{pmatrix} \text{origin}_x + (y - \text{origin}_y) \\ \text{origin}_y + (3 - (x - \text{origin}_x)) \end{pmatrix}$$
  - Head and carriage directions rotate 90° CW: $U \to R \to D \to L \to U$ (and diagonal equivalents).
- **Perimeter Edge Exits (M302):**
  - Table edge departure gaps rotate clockwise along the perimeter border every $N$ moves (Step 3 tick).
  - Trains must time their departure to hit an aligned gap; misaligned departures collide with borders (-1 heart).
- **Tangled Detection:**
  - If a rotation places an engine head facing directly into its own carriage, the train enters a "tangled" state (tap = locked tap, no move, 0 hearts) until rotated free.

### 2. Solver Heuristics & Determinism
- Stateful solver models rotor configurations within state key: `(remainingTrains, rotorAngles, exitGapPositions)`.
- Prunes tangled and deadlocked states where trains cannot escape the rotor zone.

## Affected Files
- `packages/puzzle_core/lib/src/engine/rotor_transform.dart` (to be created)
- `packages/puzzle_core/lib/src/models/sub_board_rotor.dart` (to be created)

## Risks
- Boundary clipping if trains straddle the boundary between the 4x4 rotor and the static board. Mitigated by strict validation: tapping rotor is locked if any train straddles the rotor boundary.

## Open Questions
- None. Rotational matrix rules match `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md` and `SHARED_CORE_STANDARD.md` §11.
