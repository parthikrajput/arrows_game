Source docs: phase/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-9-base-mechanics.md, specs/gameplay/phase-9-signature-system.md.

# Spec: Gameplay — Phase 9 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 split & merge craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 9 (Levels 4001–4500), maintaining the fixed difficulty plateau ($D \in [79, 95]$).

## Current State
Design documented in `phase/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for split/merge mechanics in `packages/puzzle_core`:

### 1. The 10 Split & Merge Craft Modifiers
Modifiers modulate twisting pads, twin splitters, stitch locks, and rejoin gates:

| # | Modifier | Yarn Flavour Name | Ply & Twist Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Twisting pad or splitter locked; activates only after $K$ neighboring threads unravel. |
| 2 | `Colored(c)` | **Dyed** | Twisting pad merges only threads matching color $c$; inert for mismatched colors. |
| 3 | `Fluffed` | **Fluffed** | Stitch lock or rejoin gate hidden beneath wool fluff; revealed upon neighbor unravel. |
| 4 | `Chained` | **Ribbon-Tied** | Two splitters linked via ribbon; threading one triggers both simultaneously. |
| 5 | `Countdown(N)` | **Basting** | Twisting pad dissolves and vanishes from the board if not used within $N$ moves. |
| 6 | `Phasing` | **Sheer Silk** | Rejoin gate alternates between solid blocker (odd moves) and intangible phantom (even moves). |
| 7 | `Armored` | **Brass-Plated** | Stitch lock cannot be snipped with scissors; unlocks strictly via key-thread unravel. |
| 8 | `Layered` | **Tulle** | Splitting occurs strictly on fabric layer 1; layer 2 threads pass underneath unaffected. |
| 9 | `Mirrored` | **Mirror-Stitched** | Thread splitting on the left half mirrors an inverted split trajectory on the right half. |
| 10 | `Growing` | **Ply-Expanding** | Child split ply generates 1 additional body segment every 3 moves until unraveled. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M401–M404 with the 10 craft modifiers:
- **Blocks 3–13 (L4021–4130, 11 slots):** M401 Twisting Pad Variants:
  - Knotted Pad (L4021), Colored Twist (L4031), Basting Merger (L4041), Ribbon-Tied Twin Pads (L4051), Fluffed Merger Pad (L4061), Brass-Plated Twist Frame (L4071), Multi-Layer Merger (L4081), Mirror-Stitched Pads (L4091), Ply-Expanding Merge (L4101), Sheer Silk Twisting (L4111), Triple-Thread Compound Merge (L4121).
- **Blocks 15–25 (L4141–4250, 11 slots):** M402 Double Split Variants:
  - Ribbon-Tied Splitters (L4141), Fluffed Splitter (L4151), Knotted Double Split (L4161), Dyed Splitter Eyes (L4171), Basting Splitter (L4181), Sheer Silk Split (L4191), Brass-Plated Split Frame (L4201), Multi-Layer Split Tracks (L4211), Mirror-Stitched Split (L4221), Ply-Expanding Split (L4231), Quad-Ply Cascade Split (L4241).
- **Blocks 27–37 (L4261–4370, 11 slots):** M403 Stitch Lock Variants:
  - Chained Stitch Locks (L4261), Basting Stitch Locks (L4271), Brass-Plated Segment Locks (L4281), Knotted Stitch Lock (L4291), Dyed Key Lock (L4301), Fluffed Stitch Lock (L4311), Sheer Silk Segment Lock (L4321), Multi-Layer Stitch Lock (L4331), Mirror-Stitched Locks (L4341), Ply-Expanding Locked Thread (L4351), Dual-Segment Sequential Lock (L4361).
- **Blocks 39–49 (L4381–4490, 11 slots):** M404 Rejoin Gate Variants & Full Ply-Twist Mix:
  - Knotted Rejoin Gate (L4381), Dyed Rejoin Gate (L4391), Ribbon-Tied Dual Buckles (L4401), Basting Rejoin Gate (L4411), Brass-Plated Rejoin (L4421), Sheer Silk Rejoin (L4431), Fluffed Buckle Gate (L4441), Split + Merge Circuit Combo (L4451), Split + Stitch Lock Dependency (L4461), Multi-Gate Tapestry Weave (L4471), Pre-Mastery Ply-Twist Synthesis (L4481).

### 3. Solvability Constraints
- Reverse generator ensures split plies have independent clearance channels.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/ply_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_9_variant_builder.dart` (to be created: slot composer)

## Risks
- Rapid board choking from `Ply-Expanding` child plies. Mitigated by maximum ply length ceilings.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 9 docs.
