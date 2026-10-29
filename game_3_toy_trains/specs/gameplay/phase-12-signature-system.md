Source docs: phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-11-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 12 Signature System (Hill Line Gravity Physics)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 12 signature system "Hill Line" (Gravity & Incline `S12`): dynamic board tilt levers, sliding loose crates, anti-gravity balloon suspension pads, and autonomous rolling ballast trains for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md`, `phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases maintained flat boards where objects moved strictly when directly tapped or pushed.
- Phase 12 introduces directional gravity vectors affecting unanchored crates and weighted rolling engines.

## Proposed Change
Extend `packages/puzzle_core` with directional gravity simulation and incline physics:

### 1. Gravity Vector Lifecycle & Rules
- **Tilt Lever (M551):**
  - Tapping the tilt lever (1 Move) rotates active gravity vector 90° clockwise (`Down -> Left -> Up -> Right`).
  - Active gravity state stored on board context: `gravityDir: Direction`.
- **Loose Crates (M552):**
  - Evaluated in Step 3 (Environment Tick): sliding blockers roll 1 cell along the current gravity vector if the target cell is clear.
  - Crates collide with walls, stationary trains, or other crates without damage; moving trains hitting crates lose 1 heart.
- **Balloon Pad (M553):**
  - Anti-gravity suspension tile. Crates sliding onto a Balloon Pad become weightless and anchored in place against gravity until manually pushed.
- **Ballast Train (M554):**
  - Heavy rolling train. If its facing vector aligns with the active gravity vector and track ahead is clear, it rolls forward 1 cell autonomously each turn tick.

### 2. Solver Integration & Simulation
- Physics simulation deterministic across all platforms.
- State hash includes `(trainPositions, cratePositions, gravityDir)`.

## Affected Files
- `packages/puzzle_core/lib/src/engine/gravity_simulator.dart` (to be created)
- `packages/puzzle_core/lib/src/models/gravity_direction.dart` (to be created)

## Risks
- Infinite sliding loops. Mitigated by discrete single-step simulation per move tick and fixed board boundaries.

## Open Questions
- None. Rules match `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md` and `SHARED_CORE_STANDARD.md` §11.
