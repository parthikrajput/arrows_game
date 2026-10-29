Source docs: phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-12-base-mechanics.md, specs/gameplay/phase-12-signature-system.md.

# Spec: Gameplay — Phase 12 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 gravity craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 12 (Levels 5501–6000), maintaining the fixed difficulty plateau ($D \in [88, 104]$).

## Current State
Design documented in `phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for gravity mechanics in `packages/puzzle_core`:

### 1. The 10 Gravity Craft Modifiers
Modifiers modulate plumb levers, dropping buttons, float patches, and weighted threads:

| # | Modifier | Yarn Flavour Name | Gravity Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Plumb lever locked; gravity direction cannot be shifted until $K$ threads unravel. |
| 2 | `Colored(c)` | **Dyed** | Weighted thread translates under gravity only if it matches active color $c$. |
| 3 | `Fluffed` | **Fluffed** | Float patch or dropping button hidden beneath wool fluff; revealed upon neighbor unravel. |
| 4 | `Chained` | **Ribbon-Tied** | Two dropping buttons linked via ribbon; slide concurrently on parallel tracks. |
| 5 | `Countdown(N)` | **Basting** | Float patch dissolves after $N$ moves, causing resting objects to fall under gravity. |
| 6 | `Phasing` | **Sheer Silk** | Dropping button alternates between solid obstacle and intangible ghost on alternating moves. |
| 7 | `Armored` | **Brass-Plated** | Dropping button is armored; cannot be snipped with scissors, requiring gravitational manipulation. |
| 8 | `Layered` | **Tulle** | Weighted thread translates strictly on its assigned fabric layer without blocking other layers. |
| 9 | `Mirrored` | **Mirror-Stitched** | Button falling downward triggers a mirror button ascending upward simultaneously. |
| 10 | `Growing` | **Mass-Expanding** | Dropping button expands by 1 cell in size each time it slides to a new resting position. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M551–M554 with the 10 craft modifiers:
- **Blocks 3–13 (L5521–5630, 11 slots):** M551 Plumb Lever Variants:
  - Knotted Levers (L5521), Basting Plumbs (L5531), Phasing Levers (L5541), Ribbon-Tied Levers (L5551), Dyed Gravity Lever (L5561), Fluffed Plumb Lever (L5571), Brass-Plated Lever (L5581), Multi-Layer Gravity Shift (L5591), Mirror-Stitched Inverted Levers (L5601), Mass-Expanding Plumb (L5611), 3-Way Cardinal Shift (L5621).
- **Blocks 15–25 (L5641–5750, 11 slots):** M552 Dropping Buttons Variants:
  - Chained Droppers (L5641), Brass-Plated Buttons (L5651), Mirrored Drops (L5661), Knotted Dropping Buttons (L5671), Dyed Falling Buttons (L5681), Fluffed Drop Zones (L5691), Basting Buttons (L5701), Sheer Silk Droppers (L5711), Multi-Layer Falling Buttons (L5721), Mass-Expanding Drop Blocks (L5731), Triple-Button Avalanche (L5741).
- **Blocks 27–37 (L5761–5870, 11 slots):** M553 Float Patch Variants:
  - Dyed Patches (L5761), Tulle Floats (L5771), Countdown Floats (L5781), Knotted Float Patch (L5791), Ribbon-Tied Floating Zones (L5801), Fluffed Float Patches (L5811), Brass-Plated Float Platform (L5821), Mirror-Stitched Float Zones (L5831), Mass-Expanding Float Bed (L5841), Phasing Anti-Grav Patches (L5851), Dual-Level Floating Matrix (L5861).
- **Blocks 39–49 (L5881–5990, 11 slots):** M554 Weighted Thread Variants & Gravity Dynamics Mix:
  - Knotted Weighted Thread (L5881), Dyed Metal-Core Yarn (L5891), Ribbon-Tied Weighted Pairs (L5901), Basting Heavy Threads (L5911), Brass-Plated Wire Thread (L5921), Sheer Silk Heavy Threads (L5931), Fluffed Weighted Threads (L5941), Lever + Button Cascade Circuit (L5951), Float Patch + Weighted Thread Combo (L5961), Quad-Directional Gravity Symphony (L5971), Pre-Mastery Hanging Loom Synthesis (L5981).

### 3. Solvability Constraints
- Reverse generator enforces that sliding obstacles do not create irreversible deadlock traps.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/gravity_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_12_variant_builder.dart` (to be created: slot composer)

## Risks
- Rapid compounding size from `Mass-Expanding` buttons choking board corridors. Mitigated by maximum 3-cell growth caps.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 12 docs.
