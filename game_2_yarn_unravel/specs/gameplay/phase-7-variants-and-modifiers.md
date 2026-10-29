Source docs: phase/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-7-base-mechanics.md, specs/gameplay/phase-7-signature-system.md.

# Spec: Gameplay — Phase 7 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 rotational craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 7 (Levels 3001–3500), maintaining the fixed difficulty plateau ($D \in [73, 89]$).

## Current State
Design documented in `phase/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for rotational elements in `packages/puzzle_core`:

### 1. The 10 Rotational Craft Modifiers
Modifiers modulate hoop rotors, perimeter hems, twirl threads, and ratchet locks:

| # | Modifier | Yarn Flavour Name | Rotational Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Hoop rotor is wound with yarn coils; cannot be tapped until $K$ adjacent threads unravel. |
| 2 | `Colored(c)` | **Dyed** | Turning hem exit gap accepts only threads matching color $c$; other colors snag. |
| 3 | `Fluffed` | **Fluffed** | One quadrant of the rotor is concealed by wool fluff; revealed upon neighbor unravel. |
| 4 | `Chained` | **Ribbon-Tied** | Two hoop rotors linked via ribbon; tapping either rotates both synchronously by 90° CW. |
| 5 | `Countdown(N)` | **Basting** | Rotor permanently seizes or twirl thread locks direction after $N$ player moves. |
| 6 | `Phasing` | **Sheer Silk** | Twirl thread alternates between solid and intangible ghost on alternating moves. |
| 7 | `Armored` | **Thimble-Reinforced** | Ratchet pin requires 2 key-threads to clear instead of 1 before popping open. |
| 8 | `Layered` | **Multi-Layer** | Sub-grid rotation affects only the upper fabric plane; lower layer remains stationary. |
| 9 | `Reflected` | **Reflected** | Pushing/rotating primary rotor CW causes a mirrored rotor to rotate counter-clockwise (CCW). |
| 10 | `Growing` | **Knit-Expanding** | Growing thread inside rotor twists dynamically with rotation, expanding perimeter bounds. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M301–M304 with the 10 craft modifiers:
- **Blocks 3–13 (L3021–3130, 11 slots):** M301 Hoop Rotor Variants:
  - Knotted Rotor (L3021), Fluffed Rotor (L3031), Ribbon-Tied Twin Rotors (L3041), Basting Rotor (L3051), Sheer Silk Rotor (L3061), Armored Rotor Frame (L3071), Multi-Layer Rotor (L3081), Reflected Dual-Rotors (L3091), Knit-Expanding Rotor (L3101), Dual Concentric Rotors (L3111), Quad-Rotor Grid Complex (L3121).
- **Blocks 15–25 (L3141–3250, 11 slots):** M302 Turning Hem Variants:
  - Dyed Turning Hems (L3141), Multi-Gap Hems (L3151), Knotted Border Hem (L3161), Ribbon-Tied Synchronized Hems (L3171), Basting Hem Gaps (L3181), Sheer Silk Hem Sections (L3191), Armored Perimeter Hem (L3201), Multi-Layer Boundary Hems (L3211), Reflected Border Gaps (L3221), Fluffed Hem Gaps (L3231), Variable-Speed Rotating Border (L3241).
- **Blocks 27–37 (L3261–3370, 11 slots):** M303 Twirl Thread Variants:
  - Chained Twirl Threads (L3261), Phasing Twirl Thread (L3271), Knotted Spinner (L3281), Dyed Twirl Heads (L3291), Basting Twirl Spinners (L3301), Fluffed Twirl Threads (L3311), Armored Twirl Tips (L3321), Multi-Layer Twirl Path (L3331), Reflected Opposed Spinners (L3341), Knit-Expanding Twirl Tail (L3351), Dual-Head Twirl Thread (L3361).
- **Blocks 39–49 (L3381–3490, 11 slots):** M304 Ratchet Pin Variants & Kaleidoscope Mix:
  - Knotted Ratchet Pin (L3381), Dyed Key Ratchet (L3391), Ribbon-Tied Interlocked Ratchets (L3401), Basting Pin Release (L3411), Armored Dual-Key Ratchet (L3421), Reflected Ratchet Locks (L3431), Fluffed Ratchet Pin (L3441), Rotor + Turning Hem Hybrid (L3451), Rotor + Twirl Thread Combo (L3461), Multi-Rotor Kaleidoscope Workshop (L3471), Pre-Mastery Turning Synthesis (L3481).

### 3. Solvability Constraints
- CI generator enforces that rotation sequences avoid infinite cycles or irreversible dead-end tangles.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/rotation_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_7_variant_builder.dart` (to be created: slot composer)

## Risks
- Combinatorial state growth during reflected counter-rotations. Mitigated by restricting reflected rotors to symmetric board partitions.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 7 docs.
