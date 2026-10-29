Source docs: phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 8 Signature System (Overgrown Branch Line Growth)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 8 signature system "Overgrown Branch Line" (Growth `S08`): dynamic botanical growth simulation where wild ivy aggressively spreads across railway tracks, hedge trimmers clear overgrown track beds, seed wagons drop future ivy spores, and blooming floral arches unlock upon receiving ivy contact for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md`, `phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured static obstacles, rotating sectors, and optical beams.
- Phase 8 introduces dynamic procedural growth expansion of blockers across active train corridors.

## Proposed Change
Extend `packages/puzzle_core` with a cellular automata growth engine and botanical interaction rules:

### 1. Cellular Automata Ivy Growth Rules
- **Expansion Schedule (Step 3 of Turn Tick):**
  - Every $N$ valid player Moves (`moveCount % period == 0`), active Wild Ivy nodes expand into adjacent empty track cells.
  - Directional Order: Growth evaluates adjacent unblocked cells in deterministic cardinal order: `Up -> Right -> Down -> Left`.
  - Max Spread Rate: Each growth pulse occupies a maximum of **2 vacant cells** per active cluster, preventing runaway board occlusion.
  - Obstacles and trains act as barriers: ivy cannot grow into occupied cells, station platforms, or closed gates.
- **Track Collision:**
  - Cells overgrown with ivy become solid blocking obstacles.
  - A train colliding with an ivy-covered cell halts, shakes, and loses 1 heart (buffer clack bump).
  - Track Crane (Hammer) can remove any single ivy cell (`hammerable: true`).

### 2. Pruning & Botanical Gate Interactions
- When a train departs through a Hedge Trimmer (M352), all ivy cells orthogonally adjacent to the departure lane are pruned and restored to clear track.
- When expanding ivy touches the perimeter of a Flower Arch (M354) on $K$ contact cells, the gate blooms into full floral foliage and permanently unlocks.

### 3. Solver Heuristics & Determinism
- Stateful solver (IDA* / BFS) tracks growth state in bitmasks: `(remainingTrains, ivyOccupancyBitmask, seedCounters)`.
- Solver prunes paths where growth irreversibly blocks all remaining train exits before pruning tools can be reached.

## Affected Files
- `packages/puzzle_core/lib/src/engine/growth_engine.dart` (to be created)
- `packages/puzzle_core/lib/src/models/ivy_node.dart` (to be created)

## Risks
- Growth smothering all viable exits if a player hesitates or takes sub-optimal moves. Mitigated by CI solver ensuring all levels have generous move safety margins before critical track lanes are compromised.

## Open Questions
- None. Growth rules, tick orders, and spread rates match `phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md` and `SHARED_CORE_STANDARD.md` §11.
