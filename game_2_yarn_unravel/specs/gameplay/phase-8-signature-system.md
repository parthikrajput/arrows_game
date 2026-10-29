Source docs: phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 8 Signature System: Growth (Garden Knitting)

## Status
Draft

## Type
New Feature

## Goal
Specify the organic vine expansion algorithms, directional growth priorities, pruning interactions, thread body collision gates, and step tick integration for Yarn Unravel Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md` and `phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 7 introduced coordinate transformations and moving perimeter edges.
- Phase 8 introduces dynamic topological cell occupation (Garden Knitting), where Ivy Yarn sprouts and spreads across unoccupied grid cells at periodic move intervals.

## Proposed Change
Implement the Growth system within `packages/puzzle_core`:

### 1. Ivy Yarn Spread Model
- **Root Spreader:** A seeded root origin cell `(rx, ry)` designated on the board canvas.
- **Spreading Interval & Batching:**
  - Every $N$ valid player moves (default: 3 moves), the active vine sprouts into 2 empty orthogonal neighbor cells.
  - Expansion priority is evaluated clockwise from the oldest active growth cell:
    $$\text{Up } (0, -1) \to \text{Right } (1, 0) \to \text{Down } (0, 1) \to \text{Left } (-1, 0)$$
- **Obstacle & Thread Body Impedance:**
  - Vines can only invade cells that are completely vacant.
  - Active thread bodies, wooden crates, solid buttons, and board boundaries prevent vine intrusion into that coordinate.
  - If all 4 adjacent cells are occupied or blocked, the branch stops expanding.

### 2. Gameplay & Collision Rules
- **Snag Interaction:** An ivy yarn cell acts as a solid blocker. If a player pulls a thread whose trajectory collides with an ivy vine cell, the thread snags (-1 Heart, twang sound).
- **Manual Pruning (Scissors):** Each ivy cell can be snipped and removed individually using 1 strike of Golden Scissors (Hammer).
- **Automatic Pruning (Snip Tiles M352):** Thread unravel trajectories traversing a Snip Tile clear all ivy cells within an 8-cell radius ($3 \times 3$ area centered on the tile).

### 3. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Selected thread unravels; if path crosses Snip Tile (M352), surrounding ivy cells are instantly pruned before move finishes.
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):**
  - Ivy spread counter ticks down. When interval $N$ is reached, 2 new ivy vine cells sprout.
  - Seed Bead Thread (M353) counters decrement by 1.
- **Step 4 (Derived States):**
  - Blossom Gates (M354) evaluate cleared neighbor counts; if threshold met, gates blossom open permanently.
- **Step 5 (Win / Loss Evaluation):** Check board clearance.

### 4. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Vine expansion is deterministic based on move count and clockwise priority.
  - Generator reverse construction calculates the minimum moves required to unravel threads before vine expansion seals un-unravelable exit channels.
  - Deadlock detection guarantees that boards remain 100% solvable without booster use.

## Affected Files
- `packages/puzzle_core/lib/src/models/vine_node.dart` (to be created: vine cell model)
- `packages/puzzle_core/lib/src/engine/growth_spreader.dart` (to be created: growth kinetics engine)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate growth tick into Step 3)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: deterministic growth forward projection)

## Risks
- Vine growth aggressively choking player path options if move count is misaligned. Mitigated by generous par move allowances and strategically positioned Snip Tiles.

## Open Questions
None. Growth rules and tick step integration match Phase 8 documentation and SHARED_CORE_STANDARD §11 and §16.17.
