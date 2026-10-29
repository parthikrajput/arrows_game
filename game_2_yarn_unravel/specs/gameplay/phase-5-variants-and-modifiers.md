Source docs: phase/phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-5-base-mechanics.md, specs/gameplay/phase-5-signature-system.md.

# Spec: Gameplay — Phase 5 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 push-physics craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 5 (Levels 2001–2500), maintaining the fixed difficulty plateau ($D \in [67, 83]$).

## Current State
Design documented in `phase/phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for movable crates and static pits in `packages/puzzle_core`:

### 1. The 10 Push-Physics Craft Modifiers
Modifiers attach to base mechanics M201–M204 or standard crates to modulate kinematic rules without expanding board dimensions:

| # | Modifier | Yarn Flavour Name | Push Physics Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Crate is bound with thread coils; cannot be pushed until $K$ adjacent threads have unraveled. |
| 2 | `Colored(c)` | **Dyed** | Crate can only be pushed by thread matching color $c$; threads of different colors snag upon collision. |
| 3 | `Fogged` | **Fluffed** | Crate is hidden under fluffy wool pile; reveals its type and pushability when an adjacent thread unravels. |
| 4 | `Chained` | **Ribbon-Tied** | Two crates linked via ribbon band; pushing one displaces the linked crate parallelly in the same direction. |
| 5 | `Countdown(N)` | **Basting** | Crate disintegrates and vanishes after $N$ player moves, leaving an open cell. |
| 6 | `Phasing` | **Sheer Silk** | Crate is solid on odd move counts; becomes ethereal ghost on even moves (threads pass through). |
| 7 | `Armored` | **Thimble-Reinforced** | Crate requires 2 Golden Scissors strikes to destroy instead of 1. |
| 8 | `Layered` | **Multi-Layer** | Crate sits exclusively on the top fabric layer without colliding with threads underneath. |
| 9 | `Reflected` | **Reflected** | Pushing a crate on one board half causes a mirror crate to slide symmetrically in the opposite direction. |
| 10 | `Growing` | **Knit-Expanding** | Filling a pit triggers a 1-cell perimeter wool puff expansion that must be cleared. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots (each residing at index x1 of its block) combine base mechanics M201–M204 with the 10 craft modifiers:
- **Blocks 3–13 (L2021–2130, 11 slots):** M201 Crate Pit Variants:
  - Knotted Pit (L2021), Dyed Crate + Pit (L2031), Ribbon-Tied Double Pits (L2041), Basting Pits (L2051), Sheer Silk Pit (L2061), Thimble-Reinforced Crate + Pit (L2071), Multi-Layer Pit (L2081), Reflected Crates + Pits (L2091), Knit-Expanding Pit (L2101), Fluffed Crate Pit (L2111), Compound Dual-Pit Ramp (L2121).
- **Blocks 15–25 (L2141–2250, 11 slots):** M202 Satin Crate Variants:
  - Satin Crate + Directional Arrows M006 (L2141), Knotted Satin Crate (L2151), Dyed Satin Crate (L2161), Ribbon-Tied Twin Satin Crates (L2171), Deflector Satin Crate M014 (L2181), Sheer Silk Slider (L2191), Thimble Satin Box (L2201), Multi-Layer Satin Crate (L2211), Reflected Satin Sliders (L2221), Fluffed Satin Crate (L2231), Satin-to-Pit Long Slide (L2241).
- **Blocks 27–37 (L2261–2370, 11 slots):** M203 Charm Crate Variants:
  - Knotted Charm Crate (L2261), Dyed Charm Crate (L2271), Ribbon-Tied Charm Crates (L2281), Multi-Clasp Charm Crate M043 (L2291), Basting Charm Crate (L2301), Sheer Silk Charm Crate (L2311), Armored Charm Crate (L2321), Reflected Charm Crates (L2331), Fluffed Charm Crate (L2341), Satin Charm Crate Combo (L2351), Dual Clasp Sequential Unlock (L2361).
- **Blocks 39–49 (L2381–2490, 11 slots):** M204 Iron Crate Variants & Complex Workshop Combos:
  - Knotted Iron Crate (L2381), Dyed Iron Crate (L2391), Ribbon-Tied Chenille + Iron Crate (L2401), Basting Iron Crate (L2411), Armored Iron Crate (L2421), Reflected Iron Crates (L2431), Fluffed Iron Crate (L2441), Iron Crate + Satin Crate Hybrid (L2451), Iron Crate to Heavy Pit Fill (L2461), Compound Multi-Modifier Workshop (L2471), Pre-Mastery Workshop Synthesis (L2481).

### 3. Solvability Constraints
- CI generator enforces that no modifier combination produces an unsolvable box lock (e.g., crate pushed into unfillable dead corner where subsequent key paths are permanently severed).
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/push_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_5_variant_builder.dart` (to be created: slot composer)

## Risks
- Emergent physics bugs when combining sliding crates (M202) with reflected movements. Mitigated by strict sequential resolution order in tick Step 3.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 5 docs.
