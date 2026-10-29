Source docs: SCALING_TO_10000_LEVELS.md §2–§4, SHARED_CORE_STANDARD.md §12. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Tech — Shared On-Device Level Generation Infrastructure

## Status
Draft

## Type
New Feature

## Goal
Implement the core pure-Dart on-device deterministic level generator, multi-layer reverse-construction pipeline, IDA* solver, validator, custom `xoshiro128**` PRNG, and cache freeze system shared across all 10,000-level expansion phases (Phases 3 to 20) for Ants & Bees: Garden Trails.

## Current State
Design documented in `SCALING_TO_10000_LEVELS.md` §2–§4 and `SHARED_CORE_STANDARD.md` §12, not yet implemented.
- Phases 1 and 2 bundled pre-baked level files (`phase_1.json.gz`, `phase_2.json.gz`).
- Phases 3 to 20 generate levels procedurally on user devices from deterministic seeds, avoiding app bundle bloat (~50 MB raw JSON avoided).

## Proposed Change
Implement the generator engine in `packages/puzzle_core` and the offline tooling in `tools/levelgen`:

### 1. Seed Generation & Hashing (Standard §12, §17.35)
- **Hash Function (`hash64`):** Uses two independent 32-bit FNV-1a lanes with different offset bases concatenated `(hi << 32) | lo` over key `"gameId|level|generatorVersion"`:
  ```dart
  int hash64(String gameId, int level, int generatorVersion);
  ```
  Guarantees 100% deterministic, platform-independent 64-bit integer values across Android ARM64, iOS, macOS, Windows, and x64 desktop.
- **Attempt Sequence:** Generates using attempt seeds `seed + k`, where $k \in [0, 63]$.
- **Zero Device Retry:** CI pre-validates all 9,000 levels. Levels requiring $k \ne 0$ ship in `assets/levels/seed_overrides.json` (`{"1234": 5, ...}`). On-device generation uses the verified $k$ directly, eliminating runtime retry loops.

### 2. Custom PRNG (`Xoshiro128ss`)
- Standard Dart `Random` is strictly prohibited due to platform and compiler variance.
- Implements `xoshiro128**` with 32-bit state words, initialized via `splitmix64`:
  - Produces uniform 32-bit integers, doubles, and bounded ranges.
  - Verified by golden test vectors (`test/prng/golden_test.dart`) across all target architectures.

### 3. Multi-Layer Reverse Construction Pipeline
1. **Grid Setup:** Instantiates $W \times H$ board grid according to tier parameters ($12\times 12$ to $14\times 14$).
2. **Reverse Placement:** Places $P$ insect lines in **reverse of their solution order** (first placed is the last to exit):
   - Selects candidate exit lane. Evaluates layer constraints:
     - Ground Ants (`layer: 0`): lane must be free of ant bodies and ground obstacles.
     - Worker Bees (`layer: 1`): lane must be free of bee bodies and `tall: true` obstacles.
     - Canopy Scout Bees (`layer: 2`): lane evaluated against canopy level boundaries.
   - Grows line body backwards from head through free cells (length 2–8, orthogonal or diagonal where allowed).
   - Lines are permitted to cross earlier lines' exit lanes, establishing dependency edges ($C$) and cover-locks.
3. **Static Obstacles (B):** Placed only on cells that no solution lane crosses, ensuring solvability by mathematical construction.
4. **Stateful Mechanics (C, T, K, X):** Placed using structured template patterns aligned with Phase signature systems.

### 4. Stateful Solver & Par Moves Computation
- Solves levels with stateful mechanics using Iterative Deepening A* (IDA*) / Breadth-First Search (BFS).
- State key: `(remainingLines, mechanicStates, moveCount mod LCM, parity)`.
- CI limits: 2M nodes, search depth $\le 3 \times P$.
- Output: Optimal move sequence (`solution`) and optimal move count (`par_moves`).

### 5. Difficulty Metric Formula ($D$)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
```
- $P$: Total line count (ants + bees).
- $C$: Longest dependency chain length (edges).
- $O$: Obstacle instances (excluding markers).
- $N$: Non-monotone interactive mechanics (switches, cyclic gates, countdowns).
- $S$: Extra solution interactive moves ($\text{Solution Moves} - P$).

### 6. Cache Freeze & Versioning (`GENERATOR_VERSION`)
- Generated levels are cached in local Hive box `level_cache` as `gen/{level}.json.gz`.
- When `GENERATOR_VERSION` increments in an app update:
  - Reached levels ($\le \text{highestCleared} + 1$) remain permanently **frozen** in cache.
  - Unreached levels generate with the new generator code.
  - Guarantees player experience consistency.

## Affected Files
- `packages/puzzle_core/lib/src/prng/xoshiro128ss.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/reverse_construction.dart` (to be created)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (to be created)
- `packages/puzzle_core/lib/src/validator/level_validator.dart` (to be created)
- `tools/levelgen/bin/levelgen.dart` (CLI generator tool to be created)

## Risks
- Background isolate generation latency. Mitigated by worker isolate prefetching 2 levels in advance during gameplay.

## Open Questions
- None. Algorithm, PRNG implementation, and formulas are fully specified in `SCALING_TO_10000_LEVELS.md` §2–§4 and `SHARED_CORE_STANDARD.md` §12.
