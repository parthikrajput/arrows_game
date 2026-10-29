Source docs: phases/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.24, §17.38. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-8-signature-system.md.

# Spec: Gameplay — Phase 9 Signature System (Twin Rivers)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 9 signature system "Twin Rivers" (Split & Merge): a dynamic topological transformation model supporting runtime snake entity merging, dual-branch splitting into autonomous child snakes, aggregate segment accounting, and split-pair reunion gates across Levels 4001–4500.

## Current State
Design documented in `phases/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md`, `phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases maintained static snake entity lifecycles from level start until board exit.
- Snake body segment counts were constant throughout each level attempt.
- Phase 9 introduces runtime entity creation (child snakes spawned upon splitting) and entity unification (two snakes combining into one contiguous body).

## Proposed Change
Extend `packages/puzzle_core` with dynamic entity lifecycle management, branching movement trajectories, and segment aggregation counters:

### 1. Snake Entity Merger Model (M401)
- **Merger Condition:** Two snakes $A$ and $B$ whose heads occupy adjacent cells of an active Merger Pad.
- **Unification Pipeline:**
  - Tapping the activated Merger Pad merges Snake $B$ into Snake $A$:
    $$\text{MergedSnake.body} = \text{Snake}_A.\text{body} + \text{Snake}_B.\text{body}$$
  - Head $B$ converts into a standard mid-body segment.
  - The unified snake inherits Snake $A$'s current heading direction `dir` and color theme.
  - Entity $B$ is deregistered from the active snake pool; Entity $A$'s length is updated.

---

### 2. Snake Entity Splitter Model (M402)
- **Branching Action:** When a snake traverses a Fork Stump (Twin Splitter):
  - The snake splits into two autonomous child entities: Left Child ($90^\circ$ left turn) and Right Child ($90^\circ$ right turn).
  - **Odd Segment Allocation (OD-P9-01):** For a snake of length $N$, the leading head child receives $\lceil N/2 \rceil$ segments; the secondary trailing child receives $\lfloor N/2 \rfloor$ segments with a newly designated head at the junction cell.
  - **Zero-Damage Gate Invariant:** Both left and right branch lanes must be unobstructed simultaneously. If either exit branch is blocked, the snake bonks against the splitter without splitting (0 hearts lost).

---

### 3. Turn Pipeline & Tick Order Integration (Standard §16.17)
Topological transformations resolve deterministically during Step 3 of the move resolution lifecycle:
```
1. Action resolve:
   - Identify tapped entity (Snake or active Merger Pad M401).
   - Evaluate branch clearance for Splitters (M402).
2. moveCount += 1.
3. Topological Mutation Step:
   a. If Merger Pad triggered: combine bodies, update entity registry.
   b. If Splitter traversed: spawn child entity, assign body subsets, set orthogonal directions.
4. Exit Lane & Counter Update:
   a. Exiting segments increment M403 Segment Bead Counter.
   b. Exiting child entities update M404 Reunion Gate paired checklist.
5. Lock State Updates:
   a. If M403 counter >= required segments: unlock Segment Lock.
   b. If both split children have exited: open M404 Reunion Gate.
6. Star and Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/topology/entity_merger.dart` — to be created
- `packages/puzzle_core/lib/src/topology/entity_splitter.dart` — to be created
- `packages/puzzle_core/lib/src/models/board_state.dart` — changed
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` — changed

## Risks and Open Questions
- **Memory & Identity Overhead:** Spawning runtime child entities could destabilize undo history trees if entity IDs collide.
  - *Mitigation:* Child snakes are assigned deterministic sub-IDs derived from parent (e.g. `p1_L` and `p1_R`); undo stacks restore parent entity atomically.
