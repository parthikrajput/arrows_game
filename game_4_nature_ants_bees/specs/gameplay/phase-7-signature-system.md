Source docs: phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 7 Signature System (Whirling Garden Rotation)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 7 signature system "Whirling Garden" (Rotation): $90^\circ$ clockwise coordinate matrix transformations for sub-grid sectors, line orientation reassignment, perimeter edge wall shifting, and rotation containment rules in Ants & Bees: Garden Trails.

## Current State
Design documented in `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md`, `phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Previous phases maintained static grid coordinates and fixed obstacle orientations.
- Sub-board rotating turntables, perimeter edge motion, and dynamic orientation spinning lines do not exist.

## Proposed Change
Extend `packages/puzzle_core` with a sub-grid rotation engine:

### 1. Sub-Grid Coordinate Transform Matrix (90° CW)
- When a sub-grid turntable centered at $(x_c, y_c)$ rotates $90^\circ$ clockwise:
  - For every cell $(x, y)$ inside the rotating sector:
    $$x' = x_c + (y - y_c)$$
    $$y' = y_c - (x - x_c)$$
  - Line orientations rotate $90^\circ$ clockwise:
    - Orthogonal: $\text{Right} \to \text{Down} \to \text{Left} \to \text{Up} \to \text{Right}$.
    - Diagonal: $\text{Down-Right} \to \text{Down-Left} \to \text{Up-Left} \to \text{Up-Right} \to \text{Down-Right}$.
- **Containment Rule:** An insect line can rotate with the turntable ONLY if all of its body cells reside strictly inside the turntable perimeter. Any line straddling the boundary pins the turntable, preventing rotation until that line exits.

### 2. Multi-Layer Rotation
- Turntable rotation transforms all layers simultaneously: ground ants (`layer: 0`), worker bees (`layer: 1`), and canopy scout bees (`layer: 2`) within the sector rotate together with their respective obstacles.

### 3. Turn Pipeline & Tick Order Integration (Standard §16.17)
```
1. Action resolve: Player taps turntable center or insect line moves.
2. If turntable activated: Sector rotates 90° CW (costs 1 Move).
3. moveCount += 1.
4. Perimeter Turning Hedges (M302) shift 1 step CW if moveCount % N == 0.
5. Idle Spinning Top Lines (M303) rotate 90° CW.
6. Optical beams and derived states re-evaluate.
7. Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/engine/rotation_engine.dart` (to be created)
- `packages/puzzle_core/lib/src/models/turntable_sector.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to include rotation phase)

## Design
- Turntable sectors rendered with circular border inlay, center gear/flower icon, and animated 250 ms `Curves.easeInOutCubic` smooth rotational transition.

## Risks
- Grid coordinate misalignment if floating-point math is used. Engine strictly uses pure-integer matrix transformation formulas.

## Open Questions
- None. Transformation formulas and containment rules strictly match `SHARED_CORE_STANDARD.md` §11.
