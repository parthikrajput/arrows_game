Source docs: phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-3-base-mechanics.md.

# Spec: Gameplay — Phase 4 Base Mechanics (M151–M154)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 4 (Levels 1501–2000) in Ants & Bees: Garden Trails: Root Stairs (M151), Dew-Glass Terrace (M152), Rabbit Hole (M153), and Acorn Lift (M154).

## Current State
Design documented in `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Previous obstacles were planar, single-floor entities.
- Inter-floor traversal, vertical glass ray shadows, one-way drops, and interactive vertical elevators do not exist.

## Proposed Change
Implement M151–M154 in `packages/puzzle_core` with deterministic multi-floor transitions:

### 1. M151 — Root Stairs (Stairs)
- **ID:** `M151` | **Category:** D (Directional / Floor Transition) | **Intro Level:** `L1511` (Block 2 x1).
- **Rule:**
  - Connects floor $F_A$ to floor $F_B$ (`params.targetFloor`).
  - Lines entering the stairs emerge on the destination floor at the identical $(x, y)$ coordinate continuing in their forward direction.
- **Layer & Collision Rules:**
  - Ground ants (`layer: 0`) walk up/down root stairs.
  - Regular worker bees fly over standard stairs unaffected; only `tall: true` stairs ("Updraft Stairs") carry bees upward.
- **Hammerable:** No. | **Non-Monotone (N):** No.

### 2. M152 — Dew-Glass Terrace (Glass Floor)
- **ID:** `M152` | **Category:** B (Structural Blocker / Transparent Tile) | **Intro Level:** `L1631` (Block 14 x1).
- **Rule:**
  - Transparent glass terrace tile on floor $F+1$.
  - Any insect line or obstacle occupying the glass tile projects a vertical shadow block downward, blocking the lane of the identical $(x, y)$ coordinate on lower floor $F$.
  - When the upper line exits, the downward shadow block clears immediately.
- **Layer & Collision Rules:**
  - Shadows block lines matching the casting line's layer (ant shadow blocks ants, bee shadow blocks bees).
- **Hammerable:** No. | **Non-Monotone (N):** Yes (clears dynamically upon exit).

### 3. M153 — Rabbit Hole (Drop Hole)
- **ID:** `M153` | **Category:** D (Directional / Drop) | **Intro Level:** `L1751` (Block 26 x1).
- **Rule:**
  - One-way vertical drop from floor $F$ down to floor $F-1$.
  - Lines entering the hole drop down onto floor $F-1$ at $(x, y)$ and continue forward. Cannot be traversed upward.
- **Layer & Collision Rules:**
  - Ground ants fall through the hole.
  - Worker bees and canopy bees fly over the hole unaffected (`tall: false` fixed).
- **Hammerable:** No. | **Non-Monotone (N):** No.

### 4. M154 — Acorn Lift (Elevator)
- **ID:** `M154` | **Category:** T (Interactive Control / Vertical Lift) | **Intro Level:** `L1871` (Block 38 x1).
- **Rule:**
  - Interactive elevator platform. Tapping the lift costs 1 Move and transfers the line currently resting on it between floors (`params.floorA` $\leftrightarrow$ `params.floorB`).
  - Destination cell must be free of obstacles; otherwise, tap produces a locked wobble animation and does not consume a move.
- **Layer & Collision Rules:**
  - Transports both ground ants and worker bees.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m151_root_stairs.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m152_dew_glass_terrace.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m153_rabbit_hole.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m154_acorn_lift.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/mechanic_registry.dart` (registered M151–M154)

## Risks
- Vertical collision loops: Dew-Glass shadow projection causing mutual cross-floor blocking deadlocks. Mitigated by strict top-down topological ordering in solver.

## Open Questions
- None. Rules and parameters match `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md`.

