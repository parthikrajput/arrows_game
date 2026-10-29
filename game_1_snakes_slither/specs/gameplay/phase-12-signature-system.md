Source docs: phases/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-11-signature-system.md.

# Spec: Gameplay — Phase 12 Signature System (Monsoon Winds: Gravity)

## Status
Draft

## Type
New Feature

## Goal
Implement the Monsoon Winds (Gravity Physics) signature system for Phase 12 (Levels 5501–6000), coordinating 4-way rotating directional gravity vectors, post-move falling obstacle settling, anti-gravity suspension tiles, and autonomous heavy python slides.

## Current State
Design documented in `phases/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md`, `phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous phases maintained static cell coordinates for obstacles and uncommanded snakes.
- Phase 12 introduces dynamic environmental physics where obstacles fall and uncommanded heavy snakes slide following rotating directional vectors after each turn.

## Proposed Change
Implement the core gravity engine architecture in `packages/puzzle_core/lib/src/systems/phase_12/`:

### 1. Monsoon Winds Core System
```
[GRAVITY: DOWN V]
[M552 FRUIT] 
     | (falls 1 cell if empty)
     V
[EMPTY CELL] ---> [RESTS ON BOARD BOUNDARY OR SNAKE]

[M551 WIND LEVER] (Tap -> Gravity Rotates 90° CW to RIGHT >)
```
1. **Directional Gravity State:**
   - Vector rotates through four orthogonal orientations:
     ```dart
     enum GravityDirection { down, right, up, left }
     ```
   - Default initial state: `GravityDirection.down`.
   - Activating an M551 Wind Lever advances direction clockwise:
     $$\text{Direction}_{\text{next}} = (\text{Direction}_{\text{curr}} + 1) \pmod 4$$
2. **Post-Move Falling Cascade:**
   - Evaluated after every player move (slither exit or lever tap).
   - Iterates in gravity-aligned scan order (scanning closest to the downward boundary first) to guarantee deterministic collision stacking.
   - Any M552 Falling Fruit whose adjacent cell in the gravity direction is vacant shifts downward by 1 cell until resting against a wall, another fruit, or a snake body.
3. **Snake Support & Zero-Damage Invariant:**
   - Falling fruits treat resting snakes as solid impassable terrain.
   - Falling obstacles never crush snakes or deduct player hearts. If a snake slithers away on a subsequent turn, the fruit above it falls to fill the vacated space.
4. **Anti-Gravity Exemption (M553):**
   - Objects or fruits resting on an M553 Floaty Lily ignore gravity until physically displaced by a snake.

---

### 2. Engine Tick Integration (§16.17)
```
Step 1: Player Input Phase -> Tap Snake (slither exit) OR Tap M551 Wind Lever
Step 2: If Lever Tapped:
        - Rotate GravityDirection 90° CW
        - Increment Move Counter (Move += 1)
Step 3: If Snake Tapped:
        - Validate clearance and slither snake off board
        - Increment Move Counter (Move += 1)
Step 4: Post-Move Physics Settling Phase (Loop while moved > 0, max iterations = GridSize):
        - For each M552 Fruit not on M553 Lily:
            If cell[gravity_dir] == Empty -> Move Fruit
        - For each M554 Heavy Python:
            If all_cells_below_body == Empty -> Shift Python
Step 5: Equilibrium Reached -> Settle coordinates, update HUD wind vector
Step 6: Board Settled -> Ready for Next Turn.
```

---

### 3. Interaction Matrix with Earlier Systems
- **M501 (Vine Bridges):** Falling fruits cannot cross vine bridges into sibling boards; gravity applies locally within each board frame.
- **M451 (Drum Gates):** Drum gates cycle states on every move, including moves consumed by tapping the Wind Lever.
- **M351 (Wild Vines):** Vines provide solid support platforms. Falling fruits land on top of wild vines without destroying them.
- **M091 (Ice Lanes):** If an obstacle falls onto an ice lane, it slides along the ice in the gravity direction until hitting an obstruction.

---

### 4. Solver Invariants & Anti-Softlock Rules
1. **Finite Physics Guarantee:** Falling cascades are finite and strictly acyclic, completing in at most $\max(R, C)$ iterations.
2. **No Egress Trapping:** Generator rules ensure that falling fruit clusters never permanently seal all exit vectors of remaining snakes.

## Affected Files
- `packages/puzzle_core/lib/src/systems/phase_12/gravity_physics_system.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_12/falling_cascade_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_12/wind_vector_state.dart` (to be created)
- `test/systems/phase_12_gravity_test.dart` (to be created)

## Risks and Open Questions
- **Cascade Calculation Latency:** On large $14 \times 14$ grids with 15 falling fruits, iterative settling loops must resolve in $< 2\text{ ms}$ on low-tier hardware to prevent UI jank. Implemented via bitboard occupancy masks.
