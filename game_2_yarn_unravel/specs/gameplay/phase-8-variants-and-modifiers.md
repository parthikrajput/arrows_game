Source docs: phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-8-base-mechanics.md, specs/gameplay/phase-8-signature-system.md.

# Spec: Gameplay — Phase 8 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 organic growth craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 8 (Levels 3501–4000), maintaining the fixed difficulty plateau ($D \in [76, 92]$).

## Current State
Design documented in `phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for growth elements in `packages/puzzle_core`:

### 1. The 10 Organic Growth Craft Modifiers
Modifiers modulate vine roots, snip pruners, seed beads, and blossom gates:

| # | Modifier | Yarn Flavour Name | Growth Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Ivy root dormant; spreading starts only after $K$ threads have unraveled. |
| 2 | `Colored(c)` | **Dyed** | Blossom gate opens only when pruned by threads of color $c$. |
| 3 | `Fluffed` | **Fluffed** | Snip tile or seed bead concealed beneath wool tuft; revealed on neighbor clear. |
| 4 | `Chained` | **Ribbon-Tied** | Two ivy roots linked via ribbon; sprout simultaneously into parallel sectors. |
| 5 | `Countdown(N)` | **Basting** | Ivy vine withered and automatically disintegrates after $N$ moves. |
| 6 | `Phasing` | **Sheer Silk** | Ivy vines alternate between solid blocker and intangible ghost on alternating moves. |
| 7 | `Armored` | **Thimble-Reinforced** | Reinforced ivy cell requires 2 Golden Scissors strikes to prune. |
| 8 | `Layered` | **Multi-Layer** | Ivy vines propagate strictly on designated fabric layer without intruding on other layers. |
| 9 | `Reflected` | **Reflected** | Sprouting vine in one quadrant mirrors symmetrical sprout in opposing quadrant. |
| 10 | `Growing` | **Knit-Expanding** | Newly sprouted cells act as secondary roots, compounding subsequent growth speed. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M351–M354 with the 10 craft modifiers:
- **Blocks 3–13 (L3521–3630, 11 slots):** M351 Ivy Yarn Variants:
  - Knotted Root (L3521), Basting Vines (L3531), Ribbon-Tied Double Spreaders (L3541), Dyed Ivy Sprouts (L3551), Fluffed Ivy Chambers (L3561), Armored Ivy Stems (L3571), Multi-Layer Ivy Creepers (L3581), Reflected Vine Sprouting (L3591), Knit-Expanding Secondary Roots (L3601), Sheer Silk Ghost Vines (L3611), Triple-Spreader Garden Ramp (L3621).
- **Blocks 15–25 (L3641–3750, 11 slots):** M352 Snip Tile Variants:
  - Fluffed Shears (L3641), Multi-Radius Snips (L3651), Armored Pruner Frame (L3661), Knotted Snip Tile (L3671), Dyed Pruner Trigger (L3681), Ribbon-Tied Twin Shears (L3691), Basting Pruner (L3701), Sheer Silk Pruner (L3711), Multi-Layer Pruning Shears (L3721), Reflected Prune Waves (L3731), Chained Pruning Cascade (L3741).
- **Blocks 27–37 (L3761–3870, 11 slots):** M353 Seed Bead Thread Variants:
  - Chained Seeds (L3761), Fast Sprouting Beads (L3771), Dyed Seeds (L3781), Knotted Seed Threads (L3791), Basting Seed Beads (L3801), Fluffed Seed Clusters (L3811), Armored Germination (L3821), Multi-Layer Seed Drops (L3831), Reflected Twin Seeds (L3841), Knit-Expanding Seed Pods (L3851), Triple-Seed Sequential Drop (L3861).
- **Blocks 39–49 (L3881–3990, 11 slots):** M354 Blossom Gate Variants & Blooming Garden Mix:
  - Knotted Blossom Gate (L3881), Dyed Blossom Petals (L3891), Ribbon-Tied Dual Gates (L3901), Basting Bloom Release (L3911), Armored Blossom Locks (L3921), Reflected Blossom Gates (L3931), Fluffed Garden Gates (L3941), Vine + Snip Tile Dynamic Circuit (L3951), Seed Bead to Garden Obstacle Cycle (L3961), Quad-Blossom Garden Complex (L3971), Pre-Mastery Garden Synthesis (L3981).

### 3. Solvability Constraints
- Reverse generator enforces that vine sprawl leaves at least one valid path clearing route.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/growth_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_8_variant_builder.dart` (to be created: slot composer)

## Risks
- Rapid compounding growth in `Growing` modifier causing board lockouts. Mitigated by setting hard maximum active vine cell caps (max 16 cells).

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 8 docs.
