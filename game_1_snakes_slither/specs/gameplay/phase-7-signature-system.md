Source docs: phases/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.24, §17.38, §17.39. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-6-signature-system.md.

# Spec: Gameplay — Phase 7 Signature System (Whirlwind Valley)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 7 signature system "Whirlwind Valley" (Rotation): an advanced rotational puzzle model incorporating 4×4 sub-board rotor transformations, shifting perimeter hedge walls, automatic spinning snake orientations, and orientation-coupled gear locks across Levels 3001–3500.

## Current State
Design documented in `phases/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md`, `phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated on static orthogonal grid coordinates without mid-attempt sub-grid coordinate rotations.
- Phase 7 introduces dynamic matrix transformations of localized 4×4 sub-boards, rotating all enclosed snakes, obstacles, and directions by 90° clockwise.

## Proposed Change
Extend `packages/puzzle_core` with localized sub-grid transformation engines, boundary straddle invariants, and rotational move pipelines:

### 1. 4×4 Sub-Board Rotor Transformation Engine
- **Rotor Coordinate Bounds:** An Island Spinner (M301) defines an axis-aligned bounding box of exactly 4×4 grid cells $[x_{\min}, x_{\max}] \times [y_{\min}, y_{\max}]$.
- **90° Clockwise Matrix Transformation:**
  - When the rotor is triggered, any cell $(x, y)$ local to the 4×4 rotor rotates clockwise:
    $$(x', y') = (x_{\min} + (3 - (y - y_{\min})), y_{\min} + (x - x_{\min}))$$
  - All snake segments `body[i]` within the rotor are translated to their new coordinates $(x', y')$.
  - The snake's heading direction `dir` rotates 90° CW:
    $$\text{Up} \to \text{Right} \to \text{Down} \to \text{Left} \to \text{Up}$$
- **Boundary Straddle Invariant (Standard §17.39):**
  - **Rule:** A snake cannot be sliced or sheared.
  - If any snake has at least 1 segment inside the 4×4 rotor AND at least 1 segment outside the 4×4 rotor:
    - The rotor is **Hard Locked** (`locked = true`).
    - Tapping the rotor handle triggers a **Locked Tap** (soft side wobble, lock reason tooltip, 0 hearts lost, 0 moves spent).
    - The player must first slither the straddling snake completely out of the rotor zone before the rotor can be activated.
- **Tangled Direction Invariant (Standard §17.39):**
  - If a 90° rotation causes a snake's new `dir` vector to point directly into one of its own body segments, the snake becomes **Tangled** (locked tap if tapped; non-damaging).

---

### 2. Shifting Perimeter Boundaries (M302)
- Hedge wall obstacles positioned on the board perimeter advance **1 cell clockwise** around the border loop after each valid player move.
- Openings in the perimeter wall shift dynamically, requiring players to synchronize snake exits with the rotating exit aperture.

---

### 3. Turn Pipeline & Tick Order Integration (Standard §16.17)
Rotational updates execute deterministically during Step 3 of the move resolution lifecycle:
```
1. Action resolve:
   - If player tapped a snake: slither out or head bonk.
   - If player tapped a rotor handle: validate boundary invariant; execute 90° CW transform.
2. moveCount += 1.
3. Rotation Step:
   a. Turning Hedges (M302) advance 1 cell CW along perimeter.
   b. Spinning Snakes (M303) rotate head direction 90° CW.
   c. Re-evaluate Tangled status for all snakes on rotated tiles.
4. Derived states & Gear Locks (M304) update based on rotor angles.
5. Star and Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/rotation/sub_board_rotor.dart` — to be created
- `packages/puzzle_core/lib/src/rotation/rotation_matrix.dart` — to be created
- `packages/puzzle_core/lib/src/models/board_state.dart` — changed
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` — changed

## Risks and Open Questions
- **Accidental Rotor Taps:** Player attempting to tap a snake near the center of a 4×4 rotor might accidentally trigger the rotor.
  - *Resolution:* Tap hitboxes prioritize snake body segments over the rotor background; the rotor is only triggered by tapping its designated central flower handle widget.

