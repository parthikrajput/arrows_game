# Spec: Phase 14 Signature System — Reflecting Pond (Mirror Worlds)

Source docs: phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-13-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 Signature System — Reflecting Pond (Mirror Worlds) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Introduce bilateral reflection symmetry and mirrored kinetic physics: a reflective aquatic axis links insects on opposite shores, causing synchronized mirrored dashes and requiring players to balance moves against asymmetric obstacles.

---

## Current State

Design documented in `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md` and `phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Reflecting Pond** (Mirror Worlds architecture).
- Bilateral coordinate reflection matrix transforms across vertical axis ($x' = 2x_{\text{axis}} - x, \text{Left} \leftrightarrow \text{Right}$) or horizontal axis ($y' = 2y_{\text{axis}} - y, \text{Up} \leftrightarrow \text{Down}$).
- Single bonk penalty (−1 Heart) if either twin line encounters an obstacle.
- Four base mechanics introduced: M651 Pond Axis, M652 Reflection Lock, M653 Twin Pond, M654 Upside-Down Line.
- All prior phase mechanics (M001–M604) remain active in mirrored environments.

---

## Proposed Change

### 1. Axis Coordinate Transformation Matrix
- For a vertical mirror axis $x = x_{\text{axis}}$:
  - Coordinate mapping: $(x, y) \mapsto (2x_{\text{axis}} - x, y)$
  - Heading vector: $\text{Right} \leftrightarrow \text{Left}, \text{Up} \mapsto \text{Up}, \text{Down} \mapsto \text{Down}$
- For a horizontal mirror axis $y = y_{\text{axis}}$:
  - Coordinate mapping: $(x, y) \mapsto (x, 2y_{\text{axis}} - y)$
  - Heading vector: $\text{Up} \leftrightarrow \text{Down}, \text{Left} \mapsto \text{Left}, \text{Right} \mapsto \text{Right}$

### 2. Synchronized Bilateral Traversal (M651)
- Tapping an insect line on one side of the Pond Axis automatically initiates movement for its reflected counterpart on the opposite side.
- Both lines advance synchronously.
- **Single Bonk Rule:** If either the primary line or its reflection strikes an obstacle, both halt and recoil, deducting exactly 1 Heart (−1 Heart).

### 3. Cross-Shore Reflection Locks (M652)
- Reflection Locks are stationed on one shore with their key insect located symmetrically across the axis.
- The lock only dissolves when the mirrored key insect successfully exits its shore.

### 4. Inverted Kinetic Vectors (M654)
- Upside-Down Lines display an outward head direction but execute movement in the inverted direction along their axis, challenging player spatial intuition.

### 5. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player taps interactive insect line.
2. Mirror counterpart coordinate mapping computes in $\le 0.1$ ms.
3. Dual-path forward clearance checks evaluate atomically.
4. If either path is blocked, abort move with bonk (−1 Heart).
5. Both lines advance simultaneously.
6. Exit checks evaluate: if key insect exits, clear linked Reflection Lock (M652).
7. Water ripple shader updates along the axis (`p14_water_ripple_hz = 1.5`).

### Acceptance Criteria
- [ ] Tapping line initiates simultaneous movement of both primary insect and mirrored twin.
- [ ] Obstacle collision by either twin triggers a single bonk penalty (−1 Heart) and halts both lines.
- [ ] Reflection lock dissolves immediately when counterpart key insect exits.
- [ ] Upside-Down Line moves in direction inverted from its visible head.
- [ ] Coordinate transforms execute in $\le 0.1$ ms across 14×14 grids.
- [ ] L6501 tutorial overlay fires: "Reflecting Pond — The calm water reflects your moves. Tapping one insect moves its twin!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/reflecting_pond.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/pond_axis.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/reflection_lock.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/twin_pond.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/upside_down_line.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (mirror resolution) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (symmetry transform aware) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `13` → `14` | Unlock Phase 14 content |
| `p14_water_ripple_hz` | `1.5` | Water shimmer ripple frequency |

---

## Risks and Open Questions

1. **Non-Integer Mirror Axis Coordinates:** On even grid dimensions (e.g. 14×14), the axis may run between cells ($x_{\text{axis}} = 6.5$). The reflection formula must support half-integer boundary representations: $x' = 2 \times 6.5 - x = 13 - x$.
