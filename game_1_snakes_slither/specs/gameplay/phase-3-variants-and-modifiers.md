Source docs: phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-3-base-mechanics.md.

# Spec: Gameplay — Phase 3 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Implement the variant and modifier engine architecture for Phase 3, enabling existing base mechanics to combine with 10 generic modifiers across 45 designated variant slots in Levels 1001–1500.

## Current State
Design documented in `phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md`, `SCALING_TO_10000_LEVELS.md` §7, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phases 1 and 2 introduced unique standalone base mechanics (M001–M099) on every 10th level.
- Starting in Phase 3, content scales via combinatorial variants: `Variant = Existing Base Mechanic × Modifier`.

## Proposed Change
Implement the modifier decorator pattern in `packages/puzzle_core/lib/src/modifiers/`:

### 1. 10 Generic Modifiers Specification (standard §11, SCALING §7)
| Modifier | Exact Rule | Target Categories | JSON Representation |
|---|---|---|---|
| `Frozen(K)` | Remains inert until **K orthogonally adjacent snakes exit**. While frozen: lane mechanics act as single blockers; interactive taps register as locked taps. | B, D, T, G | `{"kind": "Frozen", "k": int}` |
| `Colored(c)` | Effect applies **only to lanes of color c**; other colors treat cell as a solid blocker. | D, G, L (ramps, portals, gates) | `{"kind": "Colored", "color": String}` |
| `Fogged` | Covered under 1-cell Jungle Mist (M010 rules): hidden & non-interactive until an adjacent snake exits. | All except X | `{"kind": "Fogged"}` |
| `Chained` | Two instances of the same base mechanic are linked: an action on one applies simultaneously to both in the same Move. | T, D, C | `{"kind": "Chained", "linkedId": String}` |
| `Countdown(N)` | Functions for the first **N valid Moves**, then permanently dissolves into plain floor. | B, D, T, G | `{"kind": "Countdown", "n": int}` |
| `Phasing` | Present on **even** move counts, plain floor on odd move counts (pre-increment parity check). | B, D, G | `{"kind": "Phasing"}` |
| `Armored` | Immune to Magic Stone Hammer; immune to Boom Puffball and domino chain blasts. | B, C, X | `{"kind": "Armored"}` |
| `Layered(l)` | Affects **only layer l** (0=Ground, 1=Canopy, 2=Treetop); other layers pass through without interaction. | B, D, T, G | `{"kind": "Layered", "layer": int}` |
| `Mirrored` | Handedness flip: CW ↔ CCW rotation, conveyor flow reversed, mirror reflection angle inverted (`/` ↔ `\`). | D, T | `{"kind": "Mirrored"}` |
| `Growing(N)` | Every N Moves, instance expands 1 cell into its first free orthogonal neighbor (U, R, D, L order; max 4 cells). | B | `{"kind": "Growing", "n": int}` |

### 2. 45 Variant Slots Architecture (Phase 3)
- Populates the `x1` intro slots of blocks 3–13, 15–25, 27–37, 39–49 in Levels 1001–1500.
- Level JSON encodes modifiers under `params.mod`:
  ```json
  {
    "id": "o101_v1",
    "type": "M101",
    "cells": [[4, 6]],
    "params": {
      "inverted": false,
      "mod": {"kind": "Frozen", "k": 3}
    },
    "hammerable": false
  }
  ```
- **Intro Constraint:** An `x1` variant level contains only the intro variant plus at most 1 earlier mechanic type.

### 3. Auto-Composed Tutorial Cards
- Tutorial cards for variants combine:
  1. Base mechanic animation loop.
  2. Overlay badge depicting the modifier icon (e.g. ice crystals for `Frozen`, hourglass for `Countdown`).
  3. Localized template string: `variant_<modifier>_rule` with dynamic parameter interpolation.
  4. Grandpa Tortoise guidance one-liner.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/modifier_decorator.dart` (to be created)
- `packages/puzzle_core/lib/src/modifiers/` (10 modifier implementation files to be created)
- `packages/puzzle_core/lib/src/models/mechanic_instance.dart` (updated to parse `params.mod`)
- `lib/features/gameplay/presentation/widgets/tutorial_card_generator.dart` (to be created)

## Risks
- Combinatorial edge cases (e.g., `Frozen` applied to `Chained` mechanics). Solved by defining decorator precedence: `Frozen` checks occur before trigger dispatching.

## Open Questions
- None. 45 slot definitions and modifier behaviors match `phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md`.
