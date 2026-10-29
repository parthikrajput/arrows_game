Source docs: phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-16-signature-system.md.

# Spec: Gameplay — Phase 16 Base Mechanics (M751–M754)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 16 base mechanics: Charm Chain (M751), Charm Crafting (M752), Skeleton Charm (M753), and Charm Swap Hoop (M754).

## Current State
Documented in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M751 — Charm Chain (Key Chain)
- **Catalog Metadata:** ID `M751` | Themed Name: Charm Chain | Generic: Key Chain | Intro: Level 7511 | Category: K | Hammerable: No
- **Behavior:**
  - A sequence of threads numbered with golden badges ($1, 2, 3$).
  - Threads must be resolved in ascending order.
  - Attempting to tap out-of-order triggers locked needle feedback (no move consumed, no heart loss).
- **JSON Schema:**
  ```json
  {
    "id": "m751_1",
    "type": "M751",
    "cells": [[3, 3]],
    "params": {
      "chainId": "chain_alpha",
      "index": 1,
      "total": 3
    },
    "hammerable": false
  }
  ```

### 2. M752 — Charm Crafting (Key Crafting)
- **Catalog Metadata:** ID `M752` | Themed Name: Charm Crafting | Generic: Key Crafting | Intro: Level 7631 | Category: K/D | Hammerable: No
- **Behavior:**
  - Two independent threads carry complementary half-charms (Left and Right halves).
  - When both threads exit cleanly, the halves assemble into a Grand Master Key that unlocks the target Grand Clasp.
- **JSON Schema:**
  ```json
  {
    "id": "m752_1",
    "type": "M752",
    "cells": [[6, 2], [9, 8]],
    "params": {
      "pairId": "craft_pair_1",
      "requiredThreadIds": ["t_14", "t_22"]
    },
    "hammerable": false
  }
  ```

### 3. M753 — Skeleton Charm (Skeleton Key)
- **Catalog Metadata:** ID `M753` | Themed Name: Skeleton Charm | Generic: Skeleton Key | Intro: Level 7751 | Category: K | Hammerable: Yes (1 charm per snip)
- **Behavior:**
  - An ornate thread carrying a universal golden master key emblem.
  - Passing through or crossing any colored clasp permanently opens it, regardless of clasp color.
  - Hammerable with golden scissors/hammer.
- **JSON Schema:**
  ```json
  {
    "id": "m753_1",
    "type": "M753",
    "cells": [[5, 6], [5, 7], [5, 8]],
    "params": {
      "universal": true
    },
    "hammerable": true
  }
  ```

### 4. M754 — Charm Swap Hoop (Key Swap)
- **Catalog Metadata:** ID `M754` | Themed Name: Charm Swap Hoop | Generic: Key Swap | Intro: Level 7871 | Category: D | Hammerable: No
- **Behavior:**
  - Interactive brass hoop placed on the linen canvas.
  - Tapping costs 1 move and exchanges key colors between two linked threads (e.g. Red Key $\leftrightarrow$ Blue Key).
- **JSON Schema:**
  ```json
  {
    "id": "m754_1",
    "type": "M754",
    "cells": [[7, 7]],
    "params": {
      "linkedThreadA": "t_03",
      "linkedThreadB": "t_09"
    },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m751_charm_chain.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m752_charm_crafting.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m753_skeleton_charm.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m754_charm_swap_hoop.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M751–M754 factory handlers)

## Risks and Open Questions
- None. Behaviors match catalog definitions in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md`.
