Source docs: phase/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-6-base-mechanics.md, specs/gameplay/phase-6-signature-system.md.

# Spec: Gameplay — Phase 6 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 optical craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 6 (Levels 2501–3000), maintaining the fixed difficulty plateau ($D \in [70, 86]$).

## Current State
Design documented in `phase/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for optical elements in `packages/puzzle_core`:

### 1. The 10 Optical Craft Modifiers
Modifiers modulate beam emitters, tinted panes, prism clasps, and shadow zones:

| # | Modifier | Yarn Flavour Name | Optical Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Tinted glass or prism locked by thread coils; beams cannot pass until $K$ threads unravel. |
| 2 | `Colored(c)` | **Dyed** | Prism clasp unlocks only when irradiated by filtered beam matching color $c$. |
| 3 | `Fogged` | **Fluffed** | Lamp emitter or shadow pocket concealed under wool tuft; revealed upon neighbor unravel. |
| 4 | `Chained` | **Ribbon-Tied** | Two lamps linked via ribbon; activating or toggling one synchronously toggles the other. |
| 5 | `Countdown(N)` | **Basting** | Tinted glass filter shatters and disappears after $N$ player moves, opening optical path. |
| 6 | `Phasing` | **Sheer Silk** | Tinted glass filter alternates between solid and intangible ghost on alternating moves. |
| 7 | `Armored` | **Thimble-Reinforced** | Reinforced crystal requires 2 Golden Scissors strikes to destroy. |
| 8 | `Layered` | **Multi-Layer** | Beams propagate strictly within their designated fabric layer without penetrating layers. |
| 9 | `Reflected` | **Reflected** | Prism reflects incoming beam across symmetrical mirror axis. |
| 10 | `Growing` | **Knit-Expanding** | Expanding wool knot expands into beam corridor, occluding light and re-shadowing cells. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M251–M254 with the 10 craft modifiers:
- **Blocks 3–13 (L2521–2630, 11 slots):** M251 Tinted Glass Variants:
  - Knotted Filter (L2521), Basting Glass (L2531), Dyed Filters + Multi-Prisms (L2541), Ribbon-Tied Filter Sliders (L2551), Sheer Silk Filter (L2561), Armored Glass Pane (L2571), Multi-Layer Chromatic Filter (L2581), Reflected Filter Rays (L2591), Knit-Expanding Filter Blockade (L2601), Fluffed Tinted Glass (L2611), Triple-Color Spectrum Ramp (L2621).
- **Blocks 15–25 (L2641–2750, 11 slots):** M252 Prism Clasp Variants:
  - Dyed Prism Clasp (L2641), Knotted Prism (L2651), Fluffed Prism (L2661), Ribbon-Tied Dual Prisms (L2671), Basting Prism Clasp (L2681), Sheer Silk Prism (L2691), Armored Prism Clasp (L2701), Multi-Layer Cross-Prism (L2711), Reflected Splitter Prism (L2721), Knit-Expanding Prism Encroachment (L2731), Triple-Beam Convergence Clasp (L2741).
- **Blocks 27–37 (L2761–2870, 11 slots):** M253 Hourglass Lamp Variants:
  - Chained Hourglass Lamps (L2761), Knotted Lamp Emitter (L2771), Dyed Beam Emitters (L2781), Timed Prism Synchronization (L2791), Fluffed Timed Lantern (L2801), Phasing Beam Interval (L2811), Armored Lantern Shield (L2821), Multi-Layer Timed Beams (L2831), Reflected Timed Rays (L2841), Knit-Expanding Timed Corridor (L2851), Alternating Lamp Oscillation (L2861).
- **Blocks 39–49 (L2881–2990, 11 slots):** M254 Shadow Pocket Variants & Atelier Mix:
  - Knotted Shadow Zone (L2881), Dyed Beam Shadow Penetration (L2891), Fluffed Shadow Chamber (L2901), Ribbon-Tied Shadow Enclaves (L2911), Basting Shadow Dissolve (L2921), Sheer Silk Shadow Pockets (L2931), Armored Shadow Clasps (L2941), Multi-Layer Dark Fabric (L2951), Reflected Ray Shadow Clearing (L2961), Knit-Expanding Darkness (L2971), Pre-Mastery Atelier Optical Synthesis (L2981).

### 3. Solvability Constraints
- CI generator enforces that all optical prerequisite graphs remain acyclic and solvable.
- Maximum ray reflection bounce capped at 16 in all simulator checks.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/optical_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_6_variant_builder.dart` (to be created: slot composer)

## Risks
- Ray reflection cycles with reflected prisms causing calculation slowdowns. Mitigated by bitmask ray-tracing and hard bounce termination.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 6 docs.
