Source docs: phase_2/03_OBSTACLE_CATALOG_PHASE_2.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Obstacle Catalog (Phase 2 Mechanics M051–M099)

## Status
Draft

## Type
New Feature

## Goal
Implement the 49 new jungle mechanics (M051–M099) introduced across Levels 511 to 991, their collision rules, interaction behaviors, hammerable properties, solver models, and Phase 2 Finale boss mechanics.

## Current State
Design documented in `phase_2/03_OBSTACLE_CATALOG_PHASE_2.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 implemented mechanics M001–M049 in `specs/gameplay/obstacle-catalog-phase-1.md`.
- Phase 2 expands the mechanic library with 49 additional mechanics, including diagonal snakes, push blocks, sunbeams, board rotators, multi-part entities, and periodic gates.

## Proposed Change
Implement mechanics M051 to M099 in `packages/puzzle_core` adhering to standard interfaces and tick pipelines:

### 1. Mechanic Groups & Key Mechanics Overview
- **Diagonals & Bouncing (M051–M052):**
  - `M051` Sidewinder Snake: 8-direction movement (`UL`, `UR`, `DL`, `DR`).
  - `M052` Corner Bumper: Deflects orthogonal/diagonal snakes at 90-degree angles.
- **Push Physics (M053–M055):**
  - `M053` Rolling Coconut: Push block moving 1 cell forward when nudged by a snake; falls off open edges. Hammerable.
  - `M054` Ice Slide Crate: Slides continuously across ice floor until blocked. Hammerable.
  - `M055` Pressure Plate (Heavy): Requires a push block or Giant Anaconda to stay pressed.
- **Elevation & Layers (M056, M069):**
  - `M056` Jungle Ramp: Shifts snake lane from Ground to Canopy or vice versa.
  - `M069` Treetop Platform: Adds the 3rd layer (Treetop) with independent occlusion.
- **Periodic & Moves-based Ticks (M057, M058, M063, M067, M068, M075, M079, M082, M090, M096):**
  - `M057` Bamboo Gate (Even/Odd): Opens and closes on alternate moves (evaluates parity *before* move increment).
  - `M058` 4-Phase Flower Clock: Rotates open state across 4 cardinal directions every Move.
  - `M063` Magnetic Termite: Pulls nearest snake in line-of-sight toward it.
  - `M067` Sinking Quicksand: Increments depth per move passing over it; traps snakes when deep.
  - `M068` Snail Slime Trail: Leaves sticky trail on vacated lane cells for next 2 moves.
  - `M075` Creeping Ivy: Spreads from oldest fog cell into adjacent free cells every N moves.
  - `M079` Island Rotor: Rotates entire 4x4 sub-board CW every 4 Moves.
  - `M082` River Rapids Belt: Moves snakes resting on conveyor 1 cell along stream each turn.
  - `M090` Sun Dial Gate: Moves-based timer gate requiring daylight alignment.
  - `M096` Chameleon Stepping Stones: Toggles color every 2 moves.
- **Color Manipulation & Matching (M059, M060, M071, M072, M094, M095):**
  - `M059` Berry Bush (Recolor): Colors passing snake (mixes primaries: red+yellow=orange, etc.).
  - `M060` Chameleon Log (Swap): Swaps positions of two identically-shaped snakes.
  - `M071` Color Quota Door: Opens once N snakes of matching color have exited.
  - `M072` Rainbow Gate: Requires snakes to exit in designated color sequence.
  - `M094` Paint Bloom: Splatters color to adjacent cells upon exit.
  - `M095` Dual-Tone Snake: Has two colors across split body segments.
- **Sunbeams & Optics (M084–M089):**
  - `M084` Sunbeam Emitter: Emits continuous straight beam of light across board.
  - `M085` Polished Stone Mirror: Reflects sunbeams at 90 degrees; can be rotated by tap.
  - `M086` Crystal Prism: Splits incoming beam into two perpendicular beams.
  - `M087` Sun Receiver: Opens linked gate when illuminated by a sunbeam.
  - `M088` Shadow Gate: Closed while illuminated; opens only in darkness.
  - `M089` Solar Lens: Focuses beam to melt ice or trigger heat-sensitive vines.
- **Multi-Part & Compound Entities (M091–M093, M097, M098):**
  - `M091` Entangled Vine Knot: Links two snakes; both must exit in sync.
  - `M092` Segmented Centipede: Breaks into independent segments when moving.
  - `M093` Two-Headed Serpent: Moves in either direction depending on tapped head.
  - `M097` Bamboo Dominoes: Cascading chain reaction obstacle.
  - `M098` Prowling Mongoose (Boss/Patrol): Multi-cell entity moving on board; blocks exits.
- **Phase 2 Finale (M099):**
  - `M099` Sun Temple Master Shrine: Compound puzzle requiring beam alignment, key placement, and boss evasion.

### 2. Hammerable Rules for Phase 2 (standard §16.18)
- **Hammerable:** M053 (Rolling Coconut), M054 (Ice Slide Crate), M077 (Bomb before blast), M097 (First domino tile only).
- **Not Hammerable:** M051, M052, M055, M056, M057, M058, M059, M060, M063, M067, M068, M069, M070, M071, M072, M074, M075, M076, M079, M080, M082, M084–M089, M090, M091, M092, M093, M094, M095, M096, M098, M099.

### 3. Solver & Invariant Rules
- Every level containing stateful mechanics (C, T, K, X, push, rotation, beams) must be solved by IDA* / BFS solver with 2M node limit to confirm 0-hearts solvability.
- Cyclic mechanics (periods 2, 4, 2n) are incorporated into solver state key: `(remainingSnakes, mechanicStates, moveCount mod LCM)`.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_2/` (directory and 49 mechanic class files to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (registered M051–M099)
- `packages/puzzle_core/lib/src/solver/state_encoder.dart` (updated for Phase 2 state keys)

## Risks
- Cyclic and push physics mechanics increase solver search space. Managed via node limits and reverse construction constraints.
- Visual clarity on 14x14 boards with active sunbeams, multiple layers, and diagonal lanes.

## Open Questions
- None. Complete specifications match `phase_2/03_OBSTACLE_CATALOG_PHASE_2.md`.
