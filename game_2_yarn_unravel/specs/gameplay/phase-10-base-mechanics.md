Source docs: phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-10-signature-system.md.

# Spec: Gameplay — Phase 10 Base Mechanics (M451–M454)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 10 craft base mechanics: M451 Metronome Gate, M452 Pattern Clasp, M453 Ordered Hem, and M454 Echo Card.

## Current State
Design documented in `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md`, not yet implemented.

## Proposed Change
Implement M451 through M454 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M451 — Metronome Gate (Rhythm Gate)
- **ID:** `M451`
- **Themed Name:** Metronome Gate
- **Generic Equivalent:** Rhythm Gate
- **Intro Level:** L4511
- **Category:** Blocker / Periodic (B)
- **Hammerable:** No.
- **Rule:** A wooden metronome barrier that oscillates between Open and Closed states according to a fixed periodic move pattern (e.g., `["O", "C", "C"]`). At the end of every valid move (Step 3), the state advances. When closed, it is an immovable blocker; threads attempting to pass through snag (-1 Heart).
- **Edge Cases:** Invalid taps or bumps do not advance the move counter or shift the metronome.
- **JSON Schema:**
  ```json
  {
    "id": "m451_1",
    "type": "M451",
    "cells": [[6, 7]],
    "params": {
      "pattern": ["O", "C", "C"],
      "offset": 0
    },
    "hammerable": false
  }
  ```

#### M452 — Pattern Clasp (Pattern Lock)
- **ID:** `M452`
- **Themed Name:** Pattern Clasp
- **Generic Equivalent:** Pattern Lock
- **Intro Level:** L4631
- **Category:** Key / Blocker (K/B)
- **Hammerable:** No.
- **Rule:** An ornate embroidery brooch displaying a sequence of 2 to 4 color swatches (e.g., `["red", "yellow", "blue"]`). As threads exit the board, their colors are evaluated against the required sequence. When all colors have unraveled in the exact specified order, the clasp unlocks permanently with a golden shimmer, opening its cell.
- **Edge Cases:** Exiting an unrelated color pauses progress without resetting already cleared steps.
- **JSON Schema:**
  ```json
  {
    "id": "m452_1",
    "type": "M452",
    "cells": [[3, 9]],
    "params": {
      "colorSequence": ["red", "yellow", "blue"]
    },
    "hammerable": false
  }
  ```

#### M453 — Ordered Hem (Order Edge)
- **ID:** `M453`
- **Themed Name:** Ordered Hem
- **Generic Equivalent:** Order Edge
- **Intro Level:** L4751
- **Category:** Blocker / Edge (B/E)
- **Hammerable:** No.
- **Rule:** A section of folded calico edge seam requiring ascending thread exit numbers ($1 \to 2 \to 3 \dots$). Threads attempting to exit through this hem out of numerical sequence collide and snag (-1 Heart), bouncing backward with an audible twang.
- **Edge Cases:** Threads exiting through standard, non-ordered board edges are unaffected by the hem constraint.
- **JSON Schema:**
  ```json
  {
    "id": "m453_1",
    "type": "M453",
    "cells": [[0, 5], [0, 6], [0, 7]],
    "params": {
      "expectedSequence": [1, 2, 3]
    },
    "hammerable": false
  }
  ```

#### M454 — Echo Card (Echo Sequence)
- **ID:** `M454`
- **Themed Name:** Echo Card
- **Generic Equivalent:** Echo Sequence
- **Intro Level:** L4871
- **Category:** Key / Tracker (K)
- **Hammerable:** No.
- **Rule:** An on-screen pattern reference card. The color order of the first $k$ (2–3) threads unraveled by the player is recorded dynamically into the card. The subsequent $k$ unraveled threads must strictly mirror this recorded color sequence. Tapping a non-matching thread triggers an locked denial wobble (0 hearts lost).
- **Edge Cases:** Once the echo sequence is successfully matched, the card completes and vanishes from the HUD.
- **JSON Schema:**
  ```json
  {
    "id": "m454_1",
    "type": "M454",
    "cells": [[1, 1]],
    "params": {
      "windowSize": 3
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen`:
  - M451: Reverse calculates move-step offsets to ensure rhythm gates are open when threads reach them.
  - M452: Builds color dependency graphs guaranteeing correct color threads can clear without prerequisite deadlocks.
  - M453: Assigns numerical tags to reverse-laid paths, enforcing monotonic exit sequences.
  - M454: Checks that color distributions allow balanced $k$-length prefix and echo matching.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m451_metronome_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m452_pattern_clasp.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m453_ordered_hem.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m454_echo_card.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M451–M454)

## Risks
- Frustration if color order requirements are too strict. Mitigated by explicit HUD color sequence pips showing next expected color.

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 10 documentation.
