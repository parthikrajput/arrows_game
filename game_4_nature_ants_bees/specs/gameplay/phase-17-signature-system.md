# Spec: Phase 17 Signature System — Garden Guardians (Guardians)

Source docs: phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17, §17.38. Depends on: specs/gameplay/phase-16-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 Signature System — Garden Guardians |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define the system architecture, state tracking, tick execution order, and layer obstruction rules for Garden Guardians (Guardians): $2\times 2$ multi-cell boss obstacles, shared HP pools, armor stripping mechanisms, dynamic periodic spawners, and core-piercing hit detection.

---

## Current State

Design documented in `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md` and `phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. Guardian Entity Architecture
- Guardians are multi-cell entities occupying a $2\times 2$ footprint on the board grid.
- All Guardians have `tall: true`, unconditionally obstructing movement for ground ants, air worker bees, and canopy scout bees.
- Guardians possess an integer hit-point pool (`hp`), where $1 \le \text{hp} \le 8$.
- When a Guardian's `hp` reaches 0, it is immediately defeated: all its occupied cells revert to passable empty board cells after a 300 ms defeat animation (`p17_guardian_defeat_ms`).

### 2. Core Subsystems

#### Shared HP Pool System (M801)
- Two distinct $2\times 2$ guardian bodies (Twin Hornets A & B) bind to a single shared `hp` variable.
- Whenever a linked insect exits the grid safely, the shared `hp` decrements by 1.
- At $\text{hp} = 0$, both Twin Hornet entities dissolve simultaneously from the board.

#### Armor Shield State (M802)
- Guardian possesses a boolean state: `armored: true/false`.
- While `armored == true`, line exits deal 0 damage to the Guardian's `hp`.
- Interacting with an associated Ivy Lever / switch sets `armored = false`, shattering the shell and making the Guardian vulnerable to exit damage.

#### Periodic Obstacle Spawner (M803)
- Guardian maintains an internal move counter (`moves_until_spawn`).
- Every $N$ player moves (default $N = 4$):
  - Searches 4-directional adjacent perimeter cells in standard order: Up $\to$ Right $\to$ Down $\to$ Left.
  - Spawns a 1-cell mud blocker in the first unblocked cell found.
  - Spawning stops permanently once Guardian `hp` reaches 0.

#### Core Piercing Trajectory Check (M804)
- Guardian features a designated central Core Tile at its anchor coordinate.
- Exiting lines only deal damage if their complete exit trajectory directly intersects the Core Tile cell coordinate. Perimeter-grazing lines do not deal damage.

### 3. Tick Order Integration (SHARED_CORE_STANDARD.md §16.17)
1. Player tap action registered; insect movement validated.
2. Moving line advances along path, checking collisions against Guardian $2\times 2$ footprints.
3. If line exits board boundary:
   - Line exit event fired.
   - Core intersection check (for M804) and Armor check (for M802) evaluated.
   - If valid, Guardian `hp` decrements by 1.
   - If `hp <= 0`, Guardian defeat sequence initiates; occupied footprint cells freed.
4. Spawner counter decremented (`moves_until_spawn--`).
5. If counter reaches 0 and Guardian is alive:
   - Neighbor search evaluated; mud blocker placed on grid.
   - Counter resets to $N$.
6. Board state stability validated; solver parity updated.

### 4. Cross-Layer Interactions
- Ants cannot tunnel beneath or walk through Guardian cells.
- Bees cannot fly over Guardian cells due to `tall: true` flag.
- Conveyor currents (Phase 15) stop immediately upon reaching a Guardian footprint edge.
- Mirror worlds (Phase 14) duplicate Guardian footprints symmetrically if placed across pond axes.

---

## Verification Plan

### Automated Tests
1. Verify $2\times 2$ footprint blocks all 3 layers (`Ant`, `WorkerBee`, `CanopyScoutBee`).
2. Verify Twin Hornets decrement shared HP from independent line exits and vanish simultaneously at 0.
3. Verify Armored Rhino Beetle ignores damage while `armored == true`, and accepts damage after lever toggle.
4. Verify Wasp Nest spawns blockers exactly every $N$ moves in U-R-D-L priority order.

### Manual Verification
1. Inspect boss defeat animation across low/mid/high tiers for frame rate stability (no drops below 60 fps).
2. Validate visual reticle on Heart-Seed Guardian clearly indicates when an insect trajectory aligns with core.
