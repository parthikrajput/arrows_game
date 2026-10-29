Source docs: ../../SCALING_TO_10000_LEVELS.md §2–§4, ../../SHARED_CORE_STANDARD.md §12. Depends on: specs/tech/frontend-implementation-and-qa.md.

# Spec: Tech — Shared On-Device Level Generation Infrastructure

## Status
Draft

## Type
New Feature

## Goal
Specify the core pure-Dart on-device deterministic level generator, reverse-construction layout pipeline, IDA* solver, custom `xoshiro128**` PRNG, and cache freeze versioning architecture shared across all procedural expansion phases (Phases 3 to 20) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `../../SCALING_TO_10000_LEVELS.md` §2–§4 and `../../SHARED_CORE_STANDARD.md` §12, not yet implemented.
- Phases 1 and 2 bundled pre-baked JSON level files (`phase_1.json.gz`, `phase_2.json.gz`).
- Phases 3 to 20 generate levels directly on user devices to prevent application archive bloat (~50 MB raw JSON avoided across 9,000 levels).

## Proposed Change
Implement the procedural generator engine in `packages/puzzle_core` and the CI validation suite in `tools/levelgen`:

### 1. Seed Generation & Hashing (standard §12, §17.35)
- **Hash Function (`hash64`):** Concatenates two independent 32-bit FNV-1a lanes with different offset bases `(hi << 32) | lo` computed over the canonical key string `"toy_trains|level|generatorVersion"`:
  ```dart
  int hash64(String gameId, int level, int generatorVersion);
  ```
  Guarantees 100% identical 64-bit integer values across Flutter AOT, Dart VM, and Node.js build tools.
- **Attempt Sequence:** Generates levels using attempt seeds `seed + k`, where $k \in [0, 63]$.
- **Zero Device Retry:** CI pre-validates all 9,000 procedural levels. Any level requiring $k \ne 0$ is baked into `assets/levels/seed_overrides.json` (`{"1234": 5, ...}`). On-device generation uses the recorded $k$ directly, eliminating runtime trial-and-error loops.

### 2. Custom PRNG (`Xoshiro128ss`)
- Dart standard `Random` is prohibited due to lack of cross-platform reproducibility guarantees.
- Implements `xoshiro128**` with 32-bit state words, initialized via `splitmix64`:
  - Produces uniform 32-bit integers, doubles in $[0.0, 1.0)$, and bounded integer ranges.
  - Verified by golden test vectors (`test/prng/golden_test.dart`) across Android ARM64, iOS, and x64 desktop.

### 3. Reverse Construction Pipeline
1. **Grid Setup:** Instantiates $W \times H$ board grid according to tier parameters.
2. **Reverse Placement:** Places $P$ trains in **reverse order of their solution departure** (the first placed train is the last to exit):
   - Selects candidate exit lane. The lane must be free of static obstacles and all previously placed trains.
   - Grows train body backwards from engine head through free track cells (length 2–5 cells, king-adjacent orthogonal/diagonal links).
   - Trains are permitted to cross earlier trains' exit lanes, establishing dependency edges ($C$).
3. **Static Obstacles (B):** Placed strictly on cells that no solution departure lane crosses, guaranteeing solvability by construction.
4. **Stateful Mechanics (C, T, K, X):** Placed using structured template patterns.

### 4. Stateful Solver & Par Moves Computation
- Solves levels with stateful mechanics using Iterative Deepening A* (IDA*) / Breadth-First Search (BFS).
- State key: `(remainingTrains, mechanicStates, moveCount mod LCM, parity)`.
- CI limits: 2,000,000 nodes, search depth $\le 3 \times P$.
- Output: Optimal move sequence (`solution`) and optimal move count (`par_moves`).

### 5. Difficulty Metric Formula ($D$)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
```
- $P$: Total train count.
- $C$: Longest dependency chain length (edges).
- $O$: Obstacle instances (excluding markers).
- $N$: Non-monotone interactive mechanics (levers, plates, countdowns).
- $S$: Extra solution interactive moves ($\text{Solution Moves} - P$).

### 6. Cache Freeze & Versioning (`GENERATOR_VERSION`)
- Generated levels are saved to local Hive box `level_cache` as `gen/{level}.json.gz`.
- When `GENERATOR_VERSION` increments in an app update:
  - Reached levels ($\le \text{highestCleared} + 1$) remain permanently **frozen** in cache.
  - Unreached levels generate with the updated generator code.
  - Ensures a player never experiences an active level changing underneath them.

## Affected Files
- `packages/puzzle_core/lib/src/prng/xoshiro128ss.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/reverse_constructor.dart` (to be created)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (to be created)
- `lib/core/cache/level_cache_manager.dart` (to be created)

## Risks
- Memory bloat in Hive if 1,000+ generated levels are cached. Mitigation: Cache retains the latest 20 cleared levels and current target level, pruning older levels that can be deterministically re-generated on replay.

## Open Questions
- None. PRNG, hash function, and difficulty formula match `SCALING_TO_10000_LEVELS.md` §2–§4 and `SHARED_CORE_STANDARD.md` §12.

