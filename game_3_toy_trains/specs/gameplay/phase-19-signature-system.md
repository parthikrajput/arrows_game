Source docs: phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-18-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 19 Signature System (Remix B Mid-Era Systems Synergy)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 19 signature system "Remix B" (Mid-Era Synergy `S19`): data-driven synergistic fusions of Phase 7 through 12 mechanics, synthesizing 4x4 turntable rotors, botanical spore growth, train splitting & merging, timetable metronome rhythms, twin linked boards, and gravity inclines for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md`, `phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated isolated rotational, botanical, or gravity subsystems.
- Phase 19 represents the mid-era kinetic convergence where dynamic track geometry meshes directly with autonomous rolling and botanical lifecycle ticks.

## Proposed Change
Extend `packages/puzzle_core` with kinetic cross-system coordination pipelines:

### 1. Mid-Era Fusion Dynamics
- **Turntable Coupling Pad (M901):**
  - Rotatable 4x4 sub-board turntable equipped with magnetic coupling pads. Candidate trains can only couple when the rotor is aligned 90° with the external track network.
- **Incline Seed Wagon (M902):**
  - Gravity-driven ballast wagon that rolls downhill autonomously each move tick, dropping fertile spore seeds that sprout into obstructive ivy after $N$ turns.
- **Cross-Table Metronome Gate (M903):**
  - Table Bridge connecting Table A and Table B gated by a rhythmic metronome barrier that toggles open/closed with move ticks.
- **Hedge-Trimming Split Train (M904):**
  - Split locomotive dividing into twin engines, each equipped with rotating scythe blades that prune wild ivy along their transit corridors.

### 2. Solver Graph Expansion
- Puzzle graph integrates rotor angle permutations, gravity vector raycasts, and ivy growth frontiers simultaneously.
- Dual-table states evaluated atomically across cross-table metronome cycles.

## Affected Files
- `packages/puzzle_core/lib/src/engine/remix_b_adapter.dart` (to be created)
- `packages/puzzle_core/lib/src/models/remix_b_state.dart` (to be created)

## Risks
- Combinatorial explosion from rotor permutations coupled with spore spread. Mitigation: Max 1 active rotor and max 1 seed wagon per puzzle layout.

## Open Questions
- None. Rules match `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md` and `SHARED_CORE_STANDARD.md` §11.
