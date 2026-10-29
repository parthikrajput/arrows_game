Source docs: ../../SCALING_TO_10000_LEVELS.md §2–§4, ../../SHARED_CORE_STANDARD.md §12. Depends on: specs/tech/frontend-implementation-and-qa.md.

# Spec: Tech — Shared On-Device Level Generation Infrastructure

## Status
Draft

## Type
New Feature

## Goal
Implement the core pure-Dart on-device deterministic level generator, reverse-construction pipeline, IDA* solver, validator, custom `xoshiro128**` PRNG, and cache freeze system shared across all 10,000-level expansion phases (Phases 3 to 20) for Yarn Unravel.

## Current State
Design documented in `SCALING_TO_10000_LEVELS.md` §2–§4 and `SHARED_CORE_STANDARD.md` §12, not yet implemented.
- Phases 1 and 2 bundled pre-baked level files (`assets/levels/phase_1.json.gz`, `phase_2.json.gz`).
- Phases 3 to 20 generate levels directly on user devices to prevent app bundle size bloat (~50 MB raw JSON avoided).

## Proposed Change
Implement the generator engine in `packages/puzzle_core` and the offline tooling in `tools/levelgen`:

### 1. Seed Generation & Hashing (standard §12, §17.35)
- **Hash Function (`hash64`):** Uses two independent 32-bit FNV-1a lanes with different offset bases concatenated `(hi << 32) | lo` over key `"gameId|level|generatorVersion"`:
  ```dart
  int hash64(String gameId, int level, int generatorVersion);
  ```
  Ensures identical 64-bit integer results across Dart VM/AOT, Flutter, and JavaScript build tools.
- **Attempt Sequence:** Generates using attempt seeds `seed + k`, where $k \in [0, 63]$.
- **Zero Device Retry:** CI pre-validates all 9,000 levels. Levels requiring $k \ne 0$ ship in `assets/levels/seed_overrides.json` (`{"1234": 5, ...}`). On-device generation uses the verified $k$ directly, eliminating runtime retry loops.

### 2. Custom PRNG (`Xoshiro128ss`)
- Dart `Random` is prohibited due to lack of cross-platform determinism guarantees.
- Implements `xoshiro128**` with 32-bit state words, initialized via `splitmix64`:
  - Produces uniform 32-bit integers, doubles, and bounded ranges.
  - Verified by golden test vectors (`test/prng/golden_test.dart`) across Android ARM64, iOS, and x64 desktop.

### 3. Reverse Construction Pipeline
1. **Grid Setup:** Instantiates $W \times H$ board grid according to tier parameters.
2. **Reverse Placement:** Places $P$ threads in **reverse of their solution order** (first placed is the last to unravel):
   - Selects candidate exit lane. The lane must be free of static obstacles and all previously placed threads.
   - Grows thread body backwards from needle head through free cells (length 2–8, 8-connected).
   - Threads are permitted to cross earlier threads' exit lanes, establishing dependency edges ($C$).
3. **Static Obstacles (B):** Placed only on cells that no solution lane crosses, ensuring solvability by mathematical construction.
4. **Stateful Mechanics (C, T, K, X):** Placed using structured template patterns.

### 4. Stateful Solver & Par Moves Computation
- Solves levels with stateful mechanics using Iterative Deepening A* (IDA*) / Breadth-First Search (BFS).
- State key: `(remainingThreads, mechanicStates, moveCount mod LCM, parity)`.
- CI limits: 2M nodes, search depth $\le 3 \times P$.
- Output: Optimal move sequence (`solution`) and optimal move count (`par_moves`).

### 5. Difficulty Metric Formula ($D$)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
```
- $P$: Total thread count.
- $C$: Longest dependency chain length (edges).
- $O$: Obstacle instances (excluding markers).
- $N$: Non-monotone interactive mechanics (levers, plates, countdowns).
- $S$: Extra solution interactive moves ($\text{Solution Moves} - P$).

### 6. Local Level Cache & Storage
- Levels generated on device are cached into a compact binary format in Hive box `levelCache`:
  - Header: 32 bytes.
  - Per thread: 5 bytes + 1 byte per cell ($x \cdot 16 + y$).
  - Per obstacle: ~10 bytes.
  - Solution: 1 byte per move.
  - Average level size: **582 bytes**.
  - 9,000 generated levels aggregate to ~5.2 MB max over the player's lifetime.

## Affected Files
- `packages/puzzle_core/lib/src/generator/generator.dart` (to be created: reverse construction algorithm)
- `packages/puzzle_core/lib/src/generator/prng.dart` (to be created: `xoshiro128**` implementation)
- `packages/puzzle_core/lib/src/generator/hash.dart` (to be created: 2-lane FNV-1a 64-bit hash)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (to be created: stateful IDA* solver)
- `tools/levelgen/bin/levelgen.dart` (to be created: CLI generation tool)

## Risks
- Dart AOT vs JIT integer bitwise operations divergence on web/Wasm. Mitigated by restricting all PRNG math to unsigned 32-bit operations masked with `0xFFFFFFFF`.

## Open Questions
None. Generator specification conforms directly to `SCALING_TO_10000_LEVELS.md` §2–§4 and `SHARED_CORE_STANDARD.md` §12.
