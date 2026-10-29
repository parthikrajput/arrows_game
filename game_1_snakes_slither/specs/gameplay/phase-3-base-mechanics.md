Source docs: phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-3-signature-system.md.

# Spec: Gameplay — Phase 3 Base Mechanics (M101–M104)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 3 (Levels 1001–1500) — M101 Sun-Moon Gate, M102 Moonlight Root Bridge, M103 Day-Night Burrows, and M104 Twilight Flower Gate — including exact collision rules, parameters, hammerable properties, and solver representations.

## Current State
Design documented in `phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Phase 1 & 2 introduced 98 base mechanics (M001–M049 and M051–M099).
- Phase 3 introduces the first 4 base mechanics in the 1000+ level range tied directly to the Day & Night cycle system.

## Proposed Change
Implement mechanics M101 through M104 in `packages/puzzle_core/lib/src/mechanics/phase_3/`:

### 1. Mechanic Specifications

#### A. M101: Sun-Moon Gate (Cycle Gate)
- **Intro Level:** L1011 (Block 2 x1).
- **Category:** Gate / Path-Blocker (`D` / `G`).
- **Visual:** Stone archway carved with sun and moon emblems.
- **Rule:**
  - Default: **OPEN during Day (State A)**, **CLOSED during Night (State B)**.
  - Inverted (`params.inverted: true`): CLOSED in Day, OPEN in Night.
  - While CLOSED: Behaves as a solid Single Blocker; colliding snakes bump and lose 1 Heart.
  - While OPEN: Exit lane passes freely.
  - *No-Clipping Safety Invariant:* If a snake's body occupies the gate cell when the cycle toggles, gate closure animation pauses until the snake clears the tile (safe exit guarantee, standard §2).
- **JSON Format:** `{"id": "o101_1", "type": "M101", "cells": [[x, y]], "params": {"inverted": false}, "hammerable": false}`
- **Hammerable:** `false` (Gate base mechanic, standard §16.18).

#### B. M102: Moonlight Root Bridge (Cycle Bridge)
- **Intro Level:** L1131 (Block 14 x1).
- **Category:** Terrain / Void Crossing (`D`).
- **Visual:** Luminous ethereal root bridge glowing under moonlight.
- **Rule:**
  - Active only in its designated state (Default: **Night / State B**).
  - While ACTIVE: Bridges across void or disconnected grid gaps, allowing snake lanes to cross safely.
  - While INACTIVE (Day / State A): The cell becomes an empty void/chasm; snakes attempting to cross bump (−1 Heart).
  - If a snake is stationary on the bridge when the cycle toggles, the bridge remains solid beneath the snake until it exits.
- **JSON Format:** `{"id": "o102_1", "type": "M102", "cells": [[x, y]], "params": {"activeState": "B"}, "hammerable": false}`
- **Hammerable:** `false`.

#### C. M103: Day-Night Burrows (Cycle Portal)
- **Intro Level:** L1251 (Block 26 x1).
- **Category:** Portal / Warp (`D`).
- **Visual:** Underground burrows radiating golden daylight or silver moonlight.
- **Rule:**
  - A burrow pair (entry and exit) is active only in its designated cycle state (Default: **Day / State A**).
  - While ACTIVE: Snakes entering the entry burrow emerge from the exit burrow maintaining direction and velocity.
  - While INACTIVE (Night): Burrow entrances seal shut with solid rock and act as single blockers.
- **JSON Format:** `{"id": "o103_1", "type": "M103", "cells": [[x1, y1], [x2, y2]], "params": {"activeState": "A"}, "hammerable": false}`
- **Hammerable:** `false`.

#### D. M104: Twilight Flower Gate (Cycle Color)
- **Intro Level:** L1371 (Block 38 x1).
- **Category:** Color Filter / Gate (`G`).
- **Visual:** Gigantic exotic flower whose petals alternate color between two shades every cycle transition.
- **Rule:**
  - Alternates between `colorDay` (e.g. Teal) in Day state and `colorNight` (e.g. Amber) in Night state.
  - Only snakes whose body color matches the gate's currently active cycle color can pass through.
  - Snakes of any other color collide and bump (−1 Heart).
- **JSON Format:** `{"id": "o104_1", "type": "M104", "cells": [[x, y]], "params": {"colorDay": "teal", "colorNight": "amber"}, "hammerable": false}`
- **Hammerable:** `false`.

### 2. Solver Integration & Plausibility
- Evaluated during Step 4 (Cycle Transition Step) of the move resolution lifecycle.
- In IDA* search, cycle states are pre-computed deterministically based on move depth, preventing branch bloat.
- Reverse construction ensures at least one valid clearance window exists for each snake traversing cyclic obstacles.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_3/m101_sun_moon_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m102_moonlight_root_bridge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m103_day_night_burrows.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m104_twilight_flower_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (register M101–M104)

## Risks
- Ambiguity when a snake is half-way across M102 or M101 during state toggle. Strict no-clipping rule guarantees snake safety until fully cleared.

## Open Questions
- None. Rules, IDs, and parameters match `phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §11.
