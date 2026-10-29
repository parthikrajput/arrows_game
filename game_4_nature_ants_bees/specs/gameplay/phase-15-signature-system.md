# Spec: Phase 15 Signature System — Brook & Rails (Conveyors & Tracks)

Source docs: phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-14-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 Signature System — Brook & Rails (Conveyors & Tracks) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Introduce moving conveyor fluid dynamics via garden brooks: shallow water streams carry resting ground ants 1 tile per turn in the flow direction, while flying bees remain completely immune to drift forces.

---

## Current State

Design documented in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md` and `phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Brook & Rails** (Conveyors & Tracks architecture).
- Flow vectors automatically displace ground ants 1 cell per turn during post-move settlement.
- Obstacle buffer rule: ants drifting into occupied or blocked cells halt peacefully without bonk penalty.
- Flying insects (Worker Bees, Canopy Scouts) are completely immune to water conveyor currents.
- Four base mechanics introduced: M701 Brook Fork, M702 Tide Brook, M703 Sluice Lever, M704 Lazy River.
- All prior phase mechanics (M001–M654) remain active alongside conveyor brooks.

---

## Proposed Change

### 1. Water Current Drift Mechanics
- Following player turn execution, any ant line body resting on a conveyor brook tile shifts 1 cell forward in the direction of the stream vector $\vec{v}_{\text{stream}}$.
- **Safe Halting Rule:** If the target cell ahead contains an obstacle, wall, or another resting insect, the drifting ant immediately stops in place with 0 heart penalty.
- Bees traverse above brook tiles on air and canopy layers with 0 drift displacement.

### 2. Sluice Gate Control & Routing (M701, M703)
- Brook Fork tiles (M701) branch into two diverging stream directions.
- Tapping a Sluice Lever (M703) costs 1 Move and toggles the junction's wooden guide paddle, redirecting subsequent ant drift.

### 3. Periodic Tidal Current Reversal (M702)
- Tide Brook streams reverse their flow direction $180^\circ$ every $N$ moves (`moveCount % reverseEvery == 0`, where $N \in [3, 4]$).

### 4. Continuous Closed Loops (M704)
- Lazy River features $3\times 3$ or $4\times 4$ closed circuit water carousels.
- Ants in the loop circulate 1 cell clockwise per turn until tapped to branch into an exit canal.

### 5. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player commits line move (or taps M703 Sluice Lever).
2. Move displacement evaluates and score updates.
3. Tidal reversal evaluated if `moveCount % reverseEvery == 0` (M702).
4. Conveyor drift settlement phase executes:
   - Identify all ant segments on brook tiles.
   - Displace eligible ants 1 cell along stream vectors in $\le 0.2$ ms.
   - Halt displaced ants at obstacle boundaries.
5. Exit evaluations and gate triggers process.
6. Board state written; UI plays drift animations (`p15_brook_drift_anim_ms = 180`).

### Acceptance Criteria
- [ ] Ground ants on brook tiles drift exactly 1 cell in flow direction per turn.
- [ ] Bees cross brook tiles without any drift displacement.
- [ ] Ant drifting into blocked cell halts without bonk penalty (−0 Hearts).
- [ ] Sluice Lever toggles brook fork branches reliably.
- [ ] Tidal streams reverse direction every $N$ moves as configured in level parameters.
- [ ] Conveyor drift algorithm executes in $\le 0.2$ ms across 14×14 grids.
- [ ] L7001 tutorial overlay fires: "Brook & Rails — Flowing streams drift resting ants forward with the water current!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/brook_and_rails.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/brook_fork.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/tide_brook.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/sluice_lever.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/lazy_river.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (conveyor settlement step) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (drift-aware pathfinding) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `14` → `15` | Unlock Phase 15 content |
| `p15_brook_drift_anim_ms` | `180` | Conveyor drift animation duration |

---

## Risks and Open Questions

1. **Drift Cascade Order:** When two ant lines occupy adjacent brook tiles along the same stream, settlement must process from downstream to upstream to prevent false collisions.
2. **Interaction with Gravity (Phase 12):** When a level combines both Brook Conveyors (Phase 15) and Gravity (Phase 12), the tick order must strictly specify whether conveyor drift or gravity settlement executes first. Standard §16.17 dictates conveyor drift processes before global gravity shifts.
