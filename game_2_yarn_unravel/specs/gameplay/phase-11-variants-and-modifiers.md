Source docs: phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-11-base-mechanics.md, specs/gameplay/phase-11-signature-system.md.

# Spec: Gameplay — Phase 11 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 linked-board craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 11 (Levels 5001–5500), maintaining the fixed difficulty plateau ($D \in [85, 101]$).

## Current State
Design documented in `phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for linked-board mechanics in `packages/puzzle_core`:

### 1. The 10 Linked-Board Craft Modifiers
Modifiers modulate seam edges, cross charms, mirror threads, and relay portals across dual canvases:

| # | Modifier | Yarn Flavour Name | Twin Hoops Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Seam edge or relay portal locked; cross-hoop traversal opens only after $K$ threads clear. |
| 2 | `Colored(c)` | **Dyed** | Seam edge accepts only threads matching color $c$; other colors snag. |
| 3 | `Fluffed` | **Fluffed** | Cross charm key hidden beneath wool fluff on Hoop A; revealed upon neighbor unravel. |
| 4 | `Chained` | **Ribbon-Tied** | Two cross charms linked; clearing both unlocks synchronized clasps on Hoop B. |
| 5 | `Countdown(N)` | **Basting** | Seam edge closes and seals permanently after $N$ player moves, becoming a solid border. |
| 6 | `Phasing` | **Sheer Silk** | Relay pompom portal oscillates between active (odd moves) and inactive (even moves). |
| 7 | `Armored` | **Brass-Plated** | Cross charm is armored; cannot be snipped with scissors, requiring true thread clearance. |
| 8 | `Layered` | **Tulle** | Seam edge routes threads strictly to corresponding fabric layers on target hoop. |
| 9 | `Mirrored` | **Mirror-Stitched** | Hoop A and Hoop B obstacles and thread layouts exhibit exact symmetrical mirroring. |
| 10 | `Growing` | **Hoop-Spanning** | Relay pompom corridor expands by 1 cell every 10 moves across both boards. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M501–M504 with the 10 craft modifiers:
- **Blocks 3–13 (L5021–5130, 11 slots):** M501 Seam Edge Variants:
  - Knotted Seams (L5021), Dyed Seams (L5031), Basting Bridges (L5041), Ribbon-Tied Double Seams (L5051), Sheer Silk Seam (L5061), Brass-Plated Border (L5071), Multi-Layer Seam (L5081), Mirror-Stitched Edges (L5091), Hoop-Spanning Seam (L5101), Fluffed Seam Edges (L5111), Dual-Way Cross Seam (L5121).
- **Blocks 15–25 (L5141–5250, 11 slots):** M502 Cross Charm Variants:
  - Fluffed Charms (L5141), Brass-Plated Keys (L5151), Ribbon-Tied Charms (L5161), Knotted Cross Charm (L5171), Dyed Charm Clasp (L5181), Basting Key Lock (L5191), Sheer Silk Charm (L5201), Multi-Layer Cross Key (L5211), Mirror-Stitched Charms (L5221), Hoop-Spanning Key Pods (L5231), Triple-Charm Cross Network (L5241).
- **Blocks 27–37 (L5261–5370, 11 slots):** M503 Mirror Hoop Variants:
  - Phasing Twins (L5261), Tulle Mirrored Threads (L5271), Knotted Mirror Thread (L5281), Dyed Mirror Pair (L5291), Basting Mirror Sync (L5301), Fluffed Twin Threads (L5311), Armored Mirror Pair (L5321), Mirror-Stitched Inverted Twins (L5331), Hoop-Spanning Mirror Tails (L5341), Ribbon-Tied Quad Twins (L5351), Alternating Mirror Relay (L5361).
- **Blocks 39–49 (L5381–5490, 11 slots):** M504 Relay Pompom Variants & Twin Hoop Symbiosis:
  - Knotted Relay Portal (L5381), Dyed Pompom Tunnel (L5391), Ribbon-Tied Twin Portals (L5401), Basting Relay Portal (L5411), Brass-Plated Pompom (L5421), Sheer Silk Relay (L5431), Fluffed Pompom Cloud (L5441), Seam Edge + Cross Charm Harmonic (L5451), Relay Pompom + Mirror Sync (L5461), Dual-Board Tapestry Complex (L5471), Pre-Mastery Twin Hoops Synthesis (L5481).

### 3. Solvability Constraints
- CI generator enforces that cross-board dependency graphs are acyclic and solvable.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/linked_board_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_11_variant_builder.dart` (to be created: slot composer)

## Risks
- Cyclic routing where Thread A requires Seam B, but Seam B is blocked by Thread A. Mitigated by strict topological dependency analysis during level generation.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 11 docs.
