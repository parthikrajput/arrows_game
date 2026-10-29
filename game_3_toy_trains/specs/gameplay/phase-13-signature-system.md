Source docs: phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-12-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 13 Signature System (Weather Station Atmospheric Fog)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 13 signature system "Weather Station" (Atmospheric Fog of War `S13`): obscuring steam clouds, scout draisines that permanently reveal tracks upon exit, mirage steam decoys, painted false backdrop walls, and persistent lantern pressure plates for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md`, `phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases maintained full board visibility.
- Phase 13 introduces dynamic fog-of-war layers that conceal track connections and train positions until actively scouted or illuminated.

## Proposed Change
Extend `packages/puzzle_core` with a fog-of-war vision model and reconnaissance mechanics:

### 1. Fog-of-War Lifecycle & Visibility Rules
- **Visibility Model:**
  - Board maintains a binary visibility grid: `revealedMask: BitGrid(cols, rows)`.
  - Hidden cells obscure train orientations and switch directions under white atmospheric steam clouds.
  - Long-press Route Peek briefly highlights the true trajectory in green or red.
- **Scout Draisine (M601):**
  - When the lightweight scout draisine exits the board, all cells within 1-cell Manhattan radius along its entire exit trajectory are permanently revealed.
- **Mirage Steam (M602) & Painted Backdrop (M603):**
  - M602 renders an illusory train silhouette inside fog; M603 renders a false wooden fence. Both are non-blocking pass-throughs.
- **Lantern Plate (M604):**
  - While occupied by any train, lifts fog within a 2-cell radius. When vacated, fog returns unless previously cleared by a scout.

### 2. Solver Determinism
- Core game state remains fully observable to the CI solver; fog affects player perception only.
- Hints (Green Signal Booster) prioritize scouting or direct unblocked clears with 100% reliability.

## Affected Files
- `packages/puzzle_core/lib/src/engine/fog_vision_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/models/vision_mask.dart` (to be created)

## Risks
- Frustration from hidden deadlocks. Mitigation: Long-press Route Peek is always free and provides immediate ground-truth trajectory feedback.

## Open Questions
- None. Rules match `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md` and `SHARED_CORE_STANDARD.md` §11.
