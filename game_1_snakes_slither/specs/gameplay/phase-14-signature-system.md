Source docs: phases/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.4, §16.17, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-13-signature-system.md.

# Spec: Gameplay — Phase 14 Signature System (Pond Reflections: Mirror Worlds)

## Status
Draft

## Type
New Feature

## Goal
Implement the Pond Reflections (Mirror Worlds) signature system for Phase 14 (Levels 6501–7000), coordinating bilateral symmetry across a reflective pond axis, cross-shore reflection locks, dual-board mirror synchronization, and inverse-vector polarity snakes.

## Current State
Design documented in `phases/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md`, `phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Earlier phases operated with isolated individual snakes or separate sub-grids.
- Phase 14 bisects the board with an aquatic reflection axis where snakes are paired across bilateral reflection planes, moving concurrently in parallel or opposite vectors.

## Proposed Change
Implement the mirror world architecture in `packages/puzzle_core/lib/src/systems/phase_14/`:

### 1. Mirror Worlds Core Architecture
```
[SIDE A: UPPER]       [Snake A] ------> (Tap: moves right)
====================  [M651 POND AXIS: REFLECTIVE WATER DIVIDER]
[SIDE B: LOWER]       [Snake B] ------> (Auto-mirrors: moves right)

[M654 INVERSE SNAKE]  <------ (Moves in exact OPPOSITE direction of partner)
```
1. **Mirror Pairing Registry:**
   ```dart
   class MirrorSnakePair {
     final int snakeA_Id;
     final int snakeB_Id;
     final MirrorAxisType axis; // horizontal or vertical
     final bool isInverse;      // true for M654 Upside-down Snake
   }
   ```
2. **Synchronized Bilateral Movement:**
   - Tapping Snake A queries the registry for its reflection partner Snake B.
   - For standard mirror pairs: $\vec{V}_B = \text{Reflect}(\vec{V}_A, \text{Axis})$.
   - For inverse snakes (M654): $\vec{V}_B = -\text{Reflect}(\vec{V}_A, \text{Axis})$.
3. **Synchronous Safety Constraint (Standard §16.4):**
   - Both forward paths must be simultaneously unblocked before movement begins.
   - If **either** Snake A or Snake B is obstructed by a wall, obstacle, or another snake, **neither snake moves**.
   - Both entities execute a synchronized head-bonk ripple at their rest coordinates (0 hearts lost).
4. **Cross-Shore Reflection Locks (M652):**
   - Gates on Shore A are cryptographically keyed to the exit of designated snakes on Shore B, enforcing cross-shore planning dependencies.

---

### 2. Engine Tick Integration (§16.17)
```
Step 1: Player Tap Input -> Active Snake Selection (Snake A)
Step 2: Partner Lookup -> Retrieve paired Snake B from MirrorSnakePairRegistry
Step 3: Vector Calculation:
        - If Normal Mirror (M651) -> Vector B = Reflect(Vector A, Axis)
        - If Inverse Snake (M654) -> Vector B = -Reflect(Vector A, Axis)
Step 4: Dual Path Clearance Check -> Concurrently evaluate collision for BOTH entities
Step 5: Movement Execution:
        - If BOTH clear -> Execute simultaneous slither animations for Snake A & Snake B
        - Increment Move Counter (Move += 1)
        - If Key Snake exits on Shore B -> Unseal linked M652 Reflection Lock on Shore A
Step 6: Collision Abort -> If EITHER blocked, abort movement and trigger dual bonk ripple (0 Hearts lost)
Step 7: Board Settled -> Settle coordinates and await next turn.
```

---

### 3. Interaction Matrix with Earlier Systems
- **M603 (Painted Walls):** If a partner snake's reflection vector routes through a painted wall, the probe confirms passage through the illusion without blocking the pair.
- **M551 (Wind Levers):** Directional gravity affects both shores symmetrically; falling fruits drop along the active gravity vector on both sides of the axis.
- **M451 (Drum Gates):** Rhythm gates placed symmetrically across the axis cycle on identical move counts.
- **M091 (Ice Lanes):** If one partner slides across ice, its partner slides across its respective mirrored ice lane.

---

### 4. Solver & Symmetry Guarantees
1. **Symmetric Solvability:** Procedural levels guarantee that mirror partners never mutually bottleneck each other's exit gates.
2. **Integer Vector Math:** All reflections and inverse polarities are computed on integer grid coordinates, eliminating floating-point rounding errors.

## Affected Files
- `packages/puzzle_core/lib/src/systems/phase_14/mirror_world_system.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_14/mirror_pair_registry.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_14/bilateral_vector_calculator.dart` (to be created)
- `test/systems/phase_14_mirror_world_test.dart` (to be created)

## Risks and Open Questions
- **Dual Snake Touch Ambiguity:** Can the player tap Snake B directly, or must they only tap Snake A? *Resolution:* Tapping either partner activates the synchronized move with identical behavior, maximizing player convenience.
