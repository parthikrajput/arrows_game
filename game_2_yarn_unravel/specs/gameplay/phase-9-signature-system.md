Source docs: phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 9 Signature System: Split & Merge (Ply & Twist)

## Status
Draft

## Type
New Feature

## Goal
Specify the dynamic multi-ply thread topology, parallel splitting kinematics, dual-needle merger pad unification, and step tick integration for Yarn Unravel Phase 9 (Levels 4001–4500).

## Current State
Design documented in `phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md` and `phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, not yet implemented.
- Previous phases treated threads as unitary entities with fixed thickness and immutable head/tail topology.
- Phase 9 introduces Split & Merge (Ply & Twist), enabling threads to divide into dual parallel plies or merge two distinct threads into a combined double-ply yarn.

## Proposed Change
Implement the Split & Merge system within `packages/puzzle_core`:

### 1. Multi-Ply Thread Topology & Kinematics
- **Thread Thickness Model:**
  - Standard thread: full ply thickness ($1.0\times$ visual stroke).
  - Split thread ply: half-ply thickness ($0.5\times$ visual stroke).
- **Parallel Double Splitting (M402):**
  - When a thread's needle head enters a Twin Splitter tile at `(x, y)`:
    - The thread divides into two independent half-ply threads.
    - Unlike M029 Split-Ply (orthogonal split), both child threads retain the parent's forward heading (`dir`), advancing on adjacent parallel tracks.
- **Twisting Pad Merger (M401):**
  - Occupies 2 adjacent cells `[(x1, y1), (x2, y2)]`.
  - When two compatible thread needle heads rest on these coordinates:
    - The player can tap the Twisting Pad (costs 1 move).
    - The two threads unify into a single consolidated thread with combined length and the leading needle's direction.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player pulls thread or taps active Twisting Pad (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Derived States / Split-Merge Pass):**
  1. Splitting threads synthesize child thread entities on board.
  2. Merged threads consolidate state structures.
  3. Stitch Locks (M403) evaluate key-thread clearance.
  4. Rejoin Gates (M404) verify if both child plies have traversed through, opening permanently upon completion.
- **Step 5 (Win / Loss Evaluation):** Check remaining threads; all threads (including all child plies) must unravel completely.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Branching factor expands dynamically when threads split.
  - State representations encode active ply IDs and parent-child linkage trees.
  - Zero-heart solvability verification enforces that every child ply retains a conflict-free unravel route to board edges.

## Affected Files
- `packages/puzzle_core/lib/src/models/ply_thread_entity.dart` (to be created: multi-ply thread model)
- `packages/puzzle_core/lib/src/engine/ply_twist_resolver.dart` (to be created: split/merge resolver)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate ply/twist resolution into Step 4)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: handle dynamic thread count expansion)

## Risks
- Combinatorial state explosion when multiple threads split concurrently. Mitigated by restricting boards to a maximum of 2 active Twin Splitters per level.

## Open Questions
None. Topology rules and tick order integration match Phase 9 documentation.
