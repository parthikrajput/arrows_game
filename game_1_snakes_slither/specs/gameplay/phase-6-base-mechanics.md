Source docs: phases/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/phase-5-base-mechanics.md.

# Spec: Gameplay — Phase 6 Base Mechanics (M251–M254)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base optics mechanics for Phase 6 (Levels 2501–3000) — M251 Petal Filter, M252 Prism Lock, M253 Sundial Receiver, and M254 Shade Leaves — including chromatic mutation, multi-angle ray convergence, consecutive beam timers, shadow dormancy, and solver heuristics.

## Current State
Design documented in `phases/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md`, `phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Earlier phases provided basic monochrome light sensors and mirrors.
- Phase 6 introduces dynamic wavelength alteration, multi-ray convergence validation, temporal beam latching, and illumination-dependent snake activation.

## Proposed Change
Implement mechanics M251 through M254 in `packages/puzzle_core/lib/src/mechanics/phase_6/`:

### 1. Mechanic Specifications

#### A. M251: Petal Filter (Color Filter)
- **Intro Level:** L2511 (Block 2 x1).
- **Category:** Optical Filter (`D`).
- **Visual:** A large exotic jungle flower with translucent colored petals (e.g. Ruby, Cyan, Emerald, Gold, Violet).
- **Rule:**
  - When an incoming light beam traverses the cell of a Petal Filter, the ray's color parameter mutates to the filter's designated color (`filterColor`).
  - **Passable Floor:** The filter occupies a cell but does not obstruct snakes. Snakes can slither through or stop on the filter cell.
  - **Opaque Snake Obstruction:** If a snake body segment rests on the filter cell, the beam cannot penetrate the snake and is blocked before color transformation can occur.
  - **Receiver Compatibility:** Colored receivers (M087, M252, M253) only trigger when illuminated by a ray matching their exact required color.
- **JSON Format:**
  ```json
  {
    "id": "o251_1",
    "type": "M251",
    "cells": [[4, 5]],
    "params": {"filterColor": "ruby"},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (standard §16.18 — environmental optical fixtures cannot be hammered).

#### B. M252: Prism Lock (Beam Splitter Lock)
- **Intro Level:** L2631 (Block 14 x1).
- **Category:** Optical Lock (`G`).
- **Visual:** A reinforced stone gate with an embedded faceted crystalline prism core.
- **Rule:**
  - Operates as a solid impassable obstacle until unlocked.
  - **Activation Condition:** Requires $\ge 2$ light beams striking the prism simultaneously from different orthogonal angles in the same turn.
  - **Partial Illumination:** If struck by only 1 beam, the prism pulses partially but remains locked.
  - **Permanent Latch:** Once illuminated by the required beam count ($\ge 2$), the gate permanently latches open (`state = "open"`), retracting into the floor for the remainder of the level attempt.
- **JSON Format:**
  ```json
  {
    "id": "o252_1",
    "type": "M252",
    "cells": [[8, 8]],
    "params": {"requiredBeams": 2, "state": "closed"},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (standard §16.18 — gate structures cannot be hammered).

#### C. M253: Sundial Receiver (Beam Timer)
- **Intro Level:** L2751 (Block 26 x1).
- **Category:** Timed Optical Sensor (`D` / `G`).
- **Visual:** An ancient carved stone sundial with astronomical glyphs and a central light-focus gnomon.
- **Rule:**
  - Does not open upon initial illumination.
  - **Consecutive Move Requirement:** Requires sustained illumination for $N$ **consecutive player moves** (indicated by countdown badge $N$).
  - **Countdown Tick:** Each completed move where the beam remains continuously active decrements the counter ($N \to N-1$).
  - **Full Reset on Interruption:** If at any point the beam is obstructed, redirected, or interrupted before reaching 0, the counter **immediately resets back to its full initial value $N$**.
  - **Permanent Latch:** When the counter reaches 0, the receiver permanently latches open and lowers its associated gate barrier.
- **JSON Format:**
  ```json
  {
    "id": "o253_1",
    "type": "M253",
    "cells": [[6, 3]],
    "params": {"requiredConsecutiveMoves": 3, "remainingMoves": 3, "illuminated": false, "state": "closed"},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

#### D. M254: Shade Leaves (Dark Cells)
- **Intro Level:** L2871 (Block 38 x1).
- **Category:** Light-Dependent Cell Lock (`B` / `D`).
- **Visual:** Dense dark jungle canopy foliage casting a deep shadowy pool over 1 or more grid cells.
- **Rule:**
  - Any snake whose head rests inside a Shade Leaf dark cell is in **Shadow Dormancy** (locked state).
  - Tapping a dormant snake produces a **Locked Tap** ("nuh-uh" wobble, lock reason icon, 0 hearts lost, 0 moves spent).
  - **Illumination Awakening:** When any active light beam passes through the dark cell:
    1. The shadowy foliage dissolves.
    2. The snake awakens and transitions to active interactive state.
    3. The awakened snake remains active for all future moves even if the beam is later redirected.
- **JSON Format:**
  ```json
  {
    "id": "o254_1",
    "type": "M254",
    "cells": [[9, 4]],
    "params": {"illuminated": false},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

### 2. Solver & Validator Integration (Standard §12)
- **State Representation:** Solver models include beam paths, ray color attributes, M252 beam counts, M253 remaining consecutive move counters, and M254 illumination flags.
- **Complexity Guardrails:** IDA* node limit is 2,000,000 nodes. Levels requiring beam sustainment (M253) prune branches that prematurely sever the light beam.
- **Zero-Heart Guarantee:** Every generated seed must have a verified 0-heart solution requiring zero booster usage.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_6/petal_filter.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_6/prism_lock.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_6/sundial_receiver.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_6/shade_leaves.dart` — to be created
- `packages/puzzle_core/lib/src/solver/state_evaluator.dart` — changed

## Risks and Open Questions
- **M253 Reset Frustration:** Resetting the timer back to $N$ upon a single interruption could lead to player abandonment if $N > 4$.
  - *Constraint:* CI validator strictly caps $N \le 3$ across all generated Phase 6 levels.

