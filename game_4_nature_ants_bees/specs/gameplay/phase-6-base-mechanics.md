Source docs: phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 6 Base Mechanics (M251–M254)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 6 (Levels 2501–3000) in Ants & Bees: Garden Trails: Petal Filter (M251), Twin-Sun Lock (M252), Sundial Lens (M253), and Shade Patch (M254).

## Current State
Design documented in `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 featured basic monochrome sunbeams and single-receptor sunflower gates.
- Chromatic beam filtering, dual-receptor AND-locks, move-counted beam timers, and dark cell slumber mechanics do not exist.

## Proposed Change
Implement M251–M254 in `packages/puzzle_core` with deterministic optical raycasting:

### 1. M251 — Petal Filter (Color Filter)
- **ID:** `M251` | **Category:** O (Optical / Beam Filter) | **Intro Level:** `L2511` (Block 2 x1).
- **Rule:**
  - Translucent colored floral petal tile (Red, Yellow, Blue).
  - When a white sunbeam passes through, it takes on the filter's color identity.
  - Colored sunflower receivers activate ONLY when struck by a beam matching their hue.
  - Passing a colored beam through a conflicting secondary filter absorbs/terminates the beam completely.
- **Layer & Collision Rules:**
  - Non-blocking tile: insect lines pass over/through the petal filter tile without obstruction.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

### 2. M252 — Twin-Sun Lock (Beam Splitter Lock)
- **ID:** `M252` | **Category:** K / O (Optical Lock) | **Intro Level:** `L2631` (Block 14 x1).
- **Rule:**
  - A heavy bramble gate wired to two distinct sunflower light receivers.
  - Opens ONLY when BOTH receivers are simultaneously illuminated by matching-layer sunbeams on the same turn.
  - If either beam is interrupted by an insect body or block, the gate snaps shut immediately.
- **Layer & Collision Rules:**
  - When closed, blocks ground ants; when `tall: true`, also blocks worker bees and canopy scouts.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

### 3. M253 — Sundial Lens (Beam Timer)
- **ID:** `M253` | **Category:** O / T (Timed Emitter) | **Intro Level:** `L2751` (Block 26 x1).
- **Rule:**
  - Move-based periodic light emitter (`params.period: N`).
  - Emits light for $N$ valid player Moves, then powers down for $N$ Moves sequentially.
  - Strictly move-counted: no wall-clock timers. Advances only on valid player moves.
- **Layer & Collision Rules:**
  - Emits at its assigned layer (`params.layer: 0, 1, 2`).
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

### 4. M254 — Shade Patch (Dark Cells)
- **ID:** `M254` | **Category:** D / O (Environmental Constraint) | **Intro Level:** `L2871` (Block 38 x1).
- **Rule:**
  - A darkened rectangular canopy sector ($2\times 2$ or $3\times 3$).
  - Any insect line whose body cells reside in unlit shade tiles is **Shade-Locked** (cannot be tapped; produces "In the dark!" visual indicator).
  - Tapping a shaded line produces a locked wobble animation and does not consume a move.
  - When a sunbeam illuminates any body cell of the shaded line, it instantly awakens and becomes playable.
- **Layer & Collision Rules:**
  - Evaluated per layer: ground ants require ground sunbeams; bees require air/canopy sunbeams.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m251_petal_filter.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m252_twin_sun_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m253_sundial_lens.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m254_shade_patch.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/mechanic_registry.dart` (registered M251–M254)

## Risks
- Occlusion order ambiguity: An insect line moving through a beam while waking a second insect in a shade patch. Deterministic tick order (§16.17) guarantees optical state recalculates immediately upon move completion.

## Open Questions
- None. Rules, parameters, and intro levels strictly match `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md`.
