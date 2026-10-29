Source docs: phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-13-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 14 Signature System (Alpine Pass Reflection & Symmetry)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 14 signature system "Alpine Pass" (Reflection & Symmetry `S14`): central glacial mirror axes, paired reflection barrier locks, synchronized twin yard junctions, and inverted reverse engines for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md`, `phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated asymmetric layouts or distinct connected boards.
- Phase 14 introduces bilateral symmetry across a frozen glacial reflection axis with mirrored move execution.

## Proposed Change
Extend `packages/puzzle_core` with a bilateral reflection model and paired entity dispatchers:

### 1. Bilateral Symmetry & Mirror Dispatch
- **Central Mirror Axis (M651):**
  - Board bisected along vertical glacial line $X = X_{\text{mid}}$.
  - Tapping a train on the left half automatically triggers its mirrored counterpart on the right half to advance in horizontally reflected trajectory ($L \leftrightarrow R$).
  - Atomic execution: both paths must be completely unblocked; obstruction of either side aborts the move and triggers a buffer clack bump (-1 heart).
- **Reflection Lock (M652):**
  - Equidistant barrier gates on opposite sides of the glacial axis. Both open simultaneously only when both corresponding reflection triggers are fulfilled.
- **Alpine Twin Yard (M653):**
  - Synchronized switch tracks across the axis; toggling one lever reflects the switch state across the mirror plane.
- **Reverse Engine (M654):**
  - Inverted locomotive marked with looking-glass badge. Tapping it causes the locomotive to advance backward, reversing its standard arrow exit direction.

### 2. Solver Optimization
- Solver exploits bilateral symmetry to reduce search state space by up to 50% ($O(N/2)$ reduction).
- Reverse engine trajectories calculated via negated directional unit vectors.

## Affected Files
- `packages/puzzle_core/lib/src/engine/mirror_axis_evaluator.dart` (to be created)
- `packages/puzzle_core/lib/src/models/reflection_pair.dart` (to be created)

## Risks
- Misinterpretation of reverse engine travel direction. Mitigation: Roof glyph clearly indicates inverted forward direction.

## Open Questions
- None. Rules match `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md` and `SHARED_CORE_STANDARD.md` §11.
