Source docs: phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-7-base-mechanics.md.

# Spec: Gameplay — Phase 8 Base Mechanics (M351–M354)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base botanical mechanics (M351–M354) introduced in Phase 8 (Levels 3501–4000) of Toy Trains: Wooden Railway Puzzle, establishing their rules, growth rates, pruning actions, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured static track foliage (M027 Sprouting Ivy).
- Phase 8 elevates botanical mechanics into an active growth system with aggressive spread, hedge pruning tools, seed-dropping engines, and bloom gates.

## Proposed Change
Implement the 4 base botanical mechanics in `packages/puzzle_core/lib/src/mechanics/phase_8/`:

### 1. M351 · Wild Ivy+ (Vine Spread+)
- **Intro Level:** L3511 (Block 2, x1).
- **Category:** C (Aggressive Spreader Blocker).
- **Exact Rule:** Fast-spreading wild bramble vine. Every `params.period` valid player Moves (ticks during Step 3), expands into up to `params.maxSpread` (default 2) adjacent vacant track cells following strict cardinal priority: `Up -> Right -> Down -> Left`. Overgrown cells become solid blockers causing buffer clack bumps (-1 heart).
- **Hammerable:** Yes (`hammerable: true`). Track Crane clears 1 ivy cell.
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M351", "cells": [[4, 4]], "params": {"period": 2, "maxSpread": 2}, "hammerable": true}
  ```

### 2. M352 · Hedge Trimmer Car (Pruner Tile)
- **Intro Level:** L3631 (Block 14, x1).
- **Category:** T (Active Track Cleaner).
- **Exact Rule:** Rotary blade track maintenance attachment. When a train's departure lane passes through this cell, mechanical scythe blades engage: all Wild Ivy cells orthogonally adjacent to the traveling train's lane are severed and cleared from the board immediately.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M352", "cells": [[5, 6]], "params": {}, "hammerable": false}
  ```

### 3. M353 · Seed Wagon (Seed Path)
- **Intro Level:** L3751 (Block 26, x1).
- **Category:** P (Spore Drop Locomotive).
- **Exact Rule:** Miniature freight train carrying botanical spores. When this train successfully departs off the board edge into the Toy Box Station, it drops 1 dormant seed onto the track coordinate vacated by its caboose (last carriage). After `params.seedDelay` Moves (default 3), the seed sprouts into a new active Wild Ivy node.
- **Hammerable:** Yes (Track Crane can lift and remove the train).
- **JSON Definition:**
  ```json
  {
    "paths": [
      {"id": "p1", "color": "green", "dir": "U", "body": [[2, 3], [2, 4]], "params": {"seedDelay": 3}}
    ],
    "mechanics": [
      {"id": "o3", "type": "M353", "cells": [], "params": {"path": "p1"}, "hammerable": false}
    ]
  }
  ```

### 4. M354 · Flower Arch (Bloom Gate)
- **Intro Level:** L3871 (Block 38, x1).
- **Category:** B (Botanical Condition Gate).
- **Exact Rule:** Trellis railway archway. Starts in closed/tangled state blocking track lanes (-1 heart bump). When active spreading Wild Ivy nodes contact `params.requiredIvy` (default 4) perimeter border cells of the archway, climbing roses bloom instantly across the trellis, permanently opening the archway for clear train transit.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M354", "cells": [[7, 5]], "params": {"requiredIvy": 4}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_8/m351_wild_ivy.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_8/m352_hedge_trimmer.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_8/m353_seed_wagon.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_8/m354_flower_arch.dart` (to be created)

## Risks
- Growth smothering the Flower Arch before required contact count is achieved if pruning occurs too early. Mitigated by solver dependency tree check.

## Open Questions
- None. All mechanics match `phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md` and `SHARED_CORE_STANDARD.md` §11.
