# Spec: Phase 12 Signature System — Falling Leaves (Gravity)

Source docs: phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-11-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 Signature System — Falling Leaves (Gravity) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Introduce directional gravity simulation across the garden grid: loose acorns and heavy beetles slide or fall in the active gravity vector after each player turn, shifting board topology while flying bees remain immune to gravitational pull.

---

## Current State

Design documented in `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md` and `phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Falling Leaves** (Gravity architecture).
- Directional gravity vector $\vec{g} \in \{(0, 1), (0, -1), (-1, 0), (1, 0)\}$ (Down, Up, Left, Right).
- Deterministic settlement order after each valid player move.
- Flying insects (Worker Bees, Canopy Scouts) are completely immune to gravity.
- Four base mechanics introduced: M551 Wind-Vane Lever, M552 Falling Acorns, M553 Dandelion Puff Tile, M554 Heavy Beetle Line.
- All prior phase mechanics (M001–M504) remain fully active.

---

## Proposed Change

### 1. Gravity Settlement Algorithm
- Gravity settles deterministically following player move completion:
  - The grid is scanned starting from the edge furthest along $\vec{g}$ and moving backwards against $\vec{g}$, ensuring lead elements advance before trailing ones.
  - Any unpinned, gravity-sensitive element (M552 Falling Acorn, M554 Heavy Beetle Line) checks the adjacent cell in direction $\vec{g}$.
  - If the target cell is empty and the element does not rest on an anti-gravity tile (M553), it shifts forward by 1 cell.
  - If the target cell contains a wall, blocker, stationary line, or another resting element, movement stops immediately.
  - **No Crushing:** Falling elements never fall onto or crush an existing line; they halt immediately adjacent to it.

### 2. Gravity Shift Control (M551)
- Wind-Vane Lever serves as a global controller.
- Tapping the lever costs 1 Move and cycles $\vec{g}$ to the next orthogonal vector (e.g. Down → Left → Up → Right).
- Gravity settlement executes immediately upon vector change.

### 3. Anti-Gravity Zones (M553)
- Elements resting on Dandelion Puff Tiles are exempt from gravitational acceleration, maintaining fixed spatial coordinates regardless of shifts in $\vec{g}$.

### 4. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player commits line move (or taps M551 Wind-Vane Lever).
2. Move displacement evaluates and score updates.
3. Gravity settlement phase fires:
   - Scan grid against $\vec{g}$.
   - Shift eligible M552 Acorns and M554 Heavy Beetles by 1 tile.
   - Clamp movements at boundary walls or occupied cells.
4. Line exit checks and gate evaluations fire.
5. Board state written; UI updates with slide animations (`p12_gravity_slide_anim_ms = 150`).

### Acceptance Criteria
- [ ] Directional gravity shifts smoothly through U, L, D, R via Wind-Vane Lever.
- [ ] Falling acorns and heavy beetles slide exactly 1 tile per turn into unoccupied adjacent cells.
- [ ] Elements on Dandelion Puff Tiles remain fixed in place.
- [ ] Bees fly completely unaffected by active gravity vectors.
- [ ] Falling elements never crush insect lines; halt at nearest obstacle.
- [ ] Gravity settlement takes ≤ 0.3 ms across a 14×14 grid.
- [ ] L5501 tutorial overlay fires: "Falling Leaves — Gravity pulls loose acorns and heavy beetles with the wind!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/falling_leaves.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/wind_vane_lever.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/falling_acorns.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/dandelion_puff_tile.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/heavy_beetle_line.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (add gravity settlement step) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (gravity-aware state tree) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `11` → `12` | Unlock Phase 12 content |
| `p12_gravity_slide_anim_ms` | `150` | Slide animation speed |

---

## Risks and Open Questions

1. **Deadlock from Falling Blocker Traps:** If an acorn falls into the only exit corridor for an ant line, the board may become unsolvable. The procedural generator validator must check reachability across all potential gravity cycles.
2. **Multi-Item Cascade Performance:** On dense 14×14 boards with 10+ falling blockers, cascading settlements must avoid recursive overhead; single-pass reverse-scan ensures linear $O(N)$ execution.
