Source docs: phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 5 Base Mechanics (M201–M204)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 5 (Levels 2001–2500) in Ants & Bees: Garden Trails: Mole Hole (M201), Dewdrop Marble (M202), Seed Key Pod (M203), and Stone Pumpkin (M204).

## Current State
Design documented in `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 featured basic Rolling Acorns (M051) and Pinecone Bumpers (M052).
- Terrain pit filling, low-friction sliding marbles, pushable key blocks, and double-file heavy crates do not exist in the engine.

## Proposed Change
Implement M201–M204 in `packages/puzzle_core` with deterministic push physics resolution:

### 1. M201 — Mole Hole (Crate Holes)
- **ID:** `M201` | **Category:** D (Terrain / Hole) | **Intro Level:** `L2011` (Block 2 x1).
- **Rule:**
  - A deep earthen pit that blocks ground movement.
  - When any push block (M051 Rolling Acorn, M202 Dewdrop Marble, M203 Seed Key Pod) is pushed into the mole hole:
    - Both the block and the mole hole are consumed.
    - The tile converts permanently into normal traversable ground terrain.
- **Layer & Collision Rules:**
  - Blocks ground ants (`layer: 0`) until filled.
  - Worker bees and canopy scout bees fly over the mole hole completely unaffected (`tall: false` fixed).
- **Hammerable:** No. | **Non-Monotone (N):** Yes (fills and opens paths).

### 2. M202 — Dewdrop Marble (Sliding Ice Crates)
- **ID:** `M202` | **Category:** T (Interactive Push Block / Low Friction) | **Intro Level:** `L2131` (Block 14 x1).
- **Rule:**
  - Ultra low-friction spherical glass/dewdrop marble.
  - When pushed by an insect line along vector $\vec{v}$, it slides continuously across standard lawn tiles until it strikes a static obstacle, another block, a board edge, or falls into a Mole Hole (M201).
- **Layer & Collision Rules:**
  - Pushed by ground ants; if `tall: true`, can also be pushed by worker bees.
- **Hammerable:** Yes (can be removed by Leaf Blower). | **Non-Monotone (N):** Yes.

### 3. M203 — Seed Key Pod (Crate Keys)
- **ID:** `M203` | **Category:** K (Key & Lock / Movable Key) | **Intro Level:** `L2251` (Block 26 x1).
- **Rule:**
  - A color-coded pushable seed pod containing a royal garden key.
  - Pushing the pod onto a matching-colored Seed Socket Plate (M055) permanently unlocks associated Thorn Locks (M004).
- **Layer & Collision Rules:**
  - Evaluated according to instance `floor`, `layer`, and `tall` properties.
- **Hammerable:** No (key components must be solved via puzzle movement). | **Non-Monotone (N):** Yes.

### 4. M204 — Stone Pumpkin (Heavy Crate)
- **ID:** `M204` | **Category:** B / T (Heavy Push Blocker) | **Intro Level:** `L2371` (Block 38 x1).
- **Rule:**
  - Dense, heavy stone pumpkin blocker.
  - Standard 1-wide insect lines cannot push it alone (striking it causes a bonk, -1 Heart).
  - Can ONLY be moved 1 step forward when struck by a **Double-File (M024)** line or **Petal-Linked (M011/M066)** swarm lines hitting simultaneously.
- **Layer & Collision Rules:**
  - Ground blocker by default; if `tall: true`, wide bee swarms can push it.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m201_mole_hole.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m202_dewdrop_marble.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m203_seed_key_pod.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m204_stone_pumpkin.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/mechanic_registry.dart` (registered M201–M204)

## Risks
- Heavy crate deadlock: Player moving double-file lines out of position before pushing Stone Pumpkin into required slot. Mitigated by solver tracking heavy crate dependencies in IDA* state graph.

## Open Questions
- None. Rules and intro levels strictly match `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md`.

