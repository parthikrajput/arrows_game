Source docs: phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-16-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 17 Signature System (Clock Towers Guardians)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 17 signature system "Clock Towers" (Guardians `S17`): interactive multi-cell guardian clock towers with hit point (HP) pools, chromatic shield armor sequences, blocker-spawning depots, and optical beam-vulnerable cores for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md`, `phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated passive barriers and dynamic track tiles.
- Phase 17 introduces active guardian entities that occupy 2x2 grids, track damage pools, spawn hazards, and require multi-step boss resolutions.

## Proposed Change
Extend `packages/puzzle_core` with guardian boss lifecycle states and damage resolution:

### 1. Guardian Entity Model & Rules
- **Boss State Vector:**
  - Tracks `towerId`, `cells: List<Cell>`, `currentHp`, `maxHp`, `shieldSequence`, and `spawnCooldown`.
- **Twin Clock Towers (M801):**
  - Two discrete 2x2 wooden clock towers that share a unified HP pool (e.g., 6 HP).
  - Dispatching an adjacent railway train inflicts 1 point of structural damage. When HP reaches 0, both towers collapse simultaneously, clearing the tracks.
- **Armoured Clock Tower (M802):**
  - Protected by an elemental shield. Only dispatches adhering to a displayed chromatic sequence (e.g. 🔴 -> 🔵 -> 🟡) breach the armor and inflict damage.
- **Depot Tower (M803):**
  - Spawner guardian. Every $N$ moves (Step 3 tick), deploys a Buffer Stop (M001) onto an adjacent open track cell until the tower's HP reaches 0.
- **Clock Core (M804):**
  - Vulnerable central core cell. Even when HP reaches 0, it persists as an obstacle until struck directly by an optical Signal Light Beam (M251).

### 2. Solver Heuristics & Spawner Management
- Solver prioritizes damaging spawner towers before track capacity becomes congested.
- Optical beam routes pre-planned concurrently with train dispatch sequences.

## Affected Files
- `packages/puzzle_core/lib/src/engine/guardian_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/models/guardian_tower.dart` (to be created)

## Risks
- Rapid spawning filling all available track cells, causing unwinnable board states. Mitigation: Spawner checks maximum board blocker density ceiling ($\le 8$ active spawned blockers).

## Open Questions
- None. Rules match `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md` and `SHARED_CORE_STANDARD.md` §11.
