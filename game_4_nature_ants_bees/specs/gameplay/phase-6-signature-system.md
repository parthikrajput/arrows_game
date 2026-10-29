Source docs: phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 6 Signature System (Sunlit Garden Light & Beams+)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 6 signature system "Sunlit Garden" (Light & Beams+): multi-layer raycasting optical networks, color-filtered sunbeams, dual-receptor splitter locks, move-based periodic sundial emitters, and illuminated shade patch unlocking in Ants & Bees: Garden Trails.

## Current State
Design documented in `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md`, `phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 introduced basic sunbeam emitters (M084) and sunflower receivers (M085).
- Advanced chromatic filtering, dual-beam logic gates, move-period sundials, and dark cell line awakening do not exist in the engine.

## Proposed Change
Extend `packages/puzzle_core` with an optical simulation pipeline:

### 1. Multi-Layer Raycasting Engine
- **Layer-Bound Propagation:** Each beam emitter specifies its operating layer (`params.layer: 0 (ground), 1 (air), 2 (canopy)`).
- **Collision & Occlusion:**
  - Ground beams are blocked by ground insect lines, rocks, and static blockers.
  - Air beams are blocked by worker bee bodies and `tall: true` obstacles; pass over ground ants and low ground debris.
  - Prisms (M089) and Petal Filters (M251) bend or tint beams matching their layer.
- **Reflection Limit:** A beam can reflect at most 8 times before terminating, preventing infinite loops between opposing mirrors.
- **Complexity:** Deterministic recalculation triggered after every valid move; execution budget $\le 0.2\text{ ms}$ on $14\times 14$ grids.

### 2. Dual Receptor & Logic Gates
- **Twin-Sun Locks (M252):** Optical AND gate requiring two distinct sunflower receivers to be illuminated simultaneously by matching beams within the same turn state.
- **Sundial Lenses (M253):** Periodic emitters toggling ON/OFF every $N$ valid player Moves based on `moveCount % (2N) < N`.

### 3. Shade Patches (M254 Dark Cells)
- Defined rectangular garden sectors ($2\times 2$ to $3\times 3$) covered in dense shade.
- Any line whose body cells reside within an unlit shade patch is **Shade-Locked** (cannot be tapped; produces "In the dark!" feedback).
- When a matching-layer sunbeam intersects any body cell of the shaded line, the line awakens instantly and becomes selectable.

### 4. Turn Pipeline & Tick Order Integration (Standard §16.17)
```
1. Action resolve: Insect moves or push block shifts.
2. moveCount += 1.
3. Sundial timers and cyclic counters advance.
4. Optical Raycasting Recalculation:
   - Emits rays from all active emitters.
   - Traces reflections and petal color filters.
   - Evaluates receiver states and twin-sun locks.
   - Updates shade patch illumination and line lock states.
5. Derived gate transitions resolve.
6. Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/optics/raycast_engine.dart` (to be created)
- `packages/puzzle_core/lib/src/optics/beam_segment.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to include optical recalculation step)

## Design
- Glowing laser-like sunlight beams rendered via `CustomPainter` with additive blending (`BlendMode.plus`) and animated pollen dust specks along beam paths.

## Risks
- Raycast recalculation latency on complex boards with multiple prisms. Mitigated by caching static obstacles and raycasting only against dynamic lines and push blocks.

## Open Questions
- None. Raycast rules, layer isolation, and reflection limits strictly match `SHARED_CORE_STANDARD.md` §11.
