Source docs: phases/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-7-base-mechanics.md.

# Spec: Gameplay — Phase 8 Base Mechanics (M351–M354)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base growth mechanics for Phase 8 (Levels 3501–4000) — M351 Wild Vine, M352 Pruning Shears Tile, M353 Seed-Carrier Snake, and M354 Bloom Gate — including procedural expansion, pruning clearance, delayed seed pods, weed-clearance gates, and solver heuristics.

## Current State
Design documented in `phases/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md`, `phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Earlier phases operated on static barriers or rotational sub-grids.
- Phase 8 introduces dynamic organic sprawl, delayed obstacle emergence upon snake exits, and weed-clearing conditional victory gates.

## Proposed Change
Implement mechanics M351 through M354 in `packages/puzzle_core/lib/src/mechanics/phase_8/`:

### 1. Mechanic Specifications

#### A. M351: Wild Vine (Vine Spread+)
- **Intro Level:** L3511 (Block 2 x1).
- **Category:** Dynamic Organic Spreader (`B` / `D`).
- **Visual:** Thorny purple-green jungle vines with glowing bioluminescent sprouting buds.
- **Rule:**
  - Operates as a solid impassable obstacle to slithering snakes.
  - Every `spreadInterval` moves (default $N = 3$), the vine searches adjacent orthogonal floor cells in order: $\text{Up} \to \text{Right} \to \text{Down} \to \text{Left}$.
  - The first 2 unoccupied floor cells are colonized by new vine segments.
  - Cannot expand onto snakes, static walls, or interactive fixtures.
  - Hard cap of `maxCells` (default 8) per level.
- **JSON Format:**
  ```json
  {
    "id": "o351_1",
    "type": "M351",
    "cells": [[6, 6]],
    "params": {"spreadInterval": 3, "maxCells": 8},
    "hammerable": true
  }
  ```
- **Hammerable:** `true` (standard §16.18 — individual vine segments can be smashed by the Magic Stone Hammer).

#### B. M352: Pruning Shears Tile (Pruner Tile)
- **Intro Level:** L3631 (Block 14 x1).
- **Category:** Terrain Clearing Tile (`D`).
- **Visual:** A golden garden shears emblem carved into smooth stone flagging.
- **Rule:**
  - Passive floor tile that does not obstruct snake movement.
  - When an exiting snake slithers across this tile, it triggers a **Pruning Pulse**.
  - All Wild Vine (M351) cells located in the 4 adjacent orthogonal cells (`U, D, L, R`) are instantly severed and cleared from the board.
  - Severed cells immediately revert to passable Plain Floor.
- **JSON Format:**
  ```json
  {
    "id": "o352_1",
    "type": "M352",
    "cells": [[5, 5]],
    "params": {},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

#### C. M353: Seed-Carrier Snake (Seed Path)
- **Intro Level:** L3751 (Block 26 x1).
- **Category:** Path Exit Side-Effect (`D`).
- **Visual:** A green snake carrying a glistening exotic seed pod on its back.
- **Rule:**
  - Slithers normally according to core puzzle rules.
  - When the snake completely clears the board edge, it leaves behind an active **Seed Pod** at its designated `seedCell`.
  - The Seed Pod initiates a countdown of $K$ moves (default $K = 4$).
  - **Crushing:** If another snake slithers across the seed pod before the countdown reaches 0, the seed is trampled and destroyed harmlessly.
  - **Sprouting:** If the countdown reaches 0 without being trampled, the pod bursts and sprouts a new Wild Vine (M351) blocker.
- **JSON Format:**
  ```json
  {
    "id": "p_seed_1",
    "color": "green",
    "dir": "U",
    "body": [[7, 4], [7, 5], [7, 6]],
    "mods": {"seedCell": [7, 5], "sproutMoves": 4}
  }
  ```
- **Hammerable:** Standard snake rules apply.

#### D. M354: Bloom Gate (Bloom Gate)
- **Intro Level:** L3871 (Block 38 x1).
- **Category:** Conditional Weed-Clear Lock (`G`).
- **Visual:** A majestic lotus-bud stone archway choked with tangled root tendrils.
- **Rule:**
  - Operates as a solid impassable blocker while linked wild vines exist.
  - Linked to a specific group of vines via `linkedVineGroupId`.
  - **Open Condition:** When all vines in the linked group are completely eliminated (via Pruning Shears M352 or Hammer), the gate bloomed open permanently, clearing the path.
- **JSON Format:**
  ```json
  {
    "id": "o354_1",
    "type": "M354",
    "cells": [[11, 8]],
    "params": {"linkedVineGroupId": "vg_1", "state": "closed"},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

### 2. Solver & Validator Integration (Standard §12)
- **Growth Tree Pruning:** IDA* solver integrates deterministic growth projections; states where growth blocks all remaining exits are discarded immediately.
- **Trample Opportunism:** Solver prioritizes routes that trample active Seed Pods before they sprout into blockers.
- **Zero-Heart Guarantee:** Every generated level must possess a 0-heart optimal clear path.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_8/wild_vine.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_8/pruning_shears_tile.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_8/seed_carrier_snake.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_8/bloom_gate.dart` — to be created
- `packages/puzzle_core/lib/src/solver/state_evaluator.dart` — changed

## Risks and Open Questions
- **Trample Timing Tightness:** Seed pod countdowns of $K \le 2$ might create impossible reaction demands.
  - *Standard Guardrail:* Generator enforces $K \ge 4$ moves for all Seed Pod instances.

