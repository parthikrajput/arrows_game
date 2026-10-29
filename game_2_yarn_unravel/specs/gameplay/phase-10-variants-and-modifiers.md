Source docs: phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md, ../../SCALING_TO_10000_LEVELS.md §7–§8. Depends on: specs/gameplay/phase-10-base-mechanics.md, specs/gameplay/phase-10-signature-system.md.

# Spec: Gameplay — Phase 10 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 sequencing craft modifiers and their composition across the 45 variant slots for Yarn Unravel Phase 10 (Levels 4501–5000), maintaining the fixed difficulty plateau ($D \in [82, 98]$).

## Current State
Design documented in `phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md`, not yet implemented.

## Proposed Change
Implement the modifier application system for sequencing mechanics in `packages/puzzle_core`:

### 1. The 10 Sequencing Craft Modifiers
Modifiers modulate metronome gates, pattern clasps, ordered hems, and echo trackers:

| # | Modifier | Yarn Flavour Name | Sequencing Mechanic Rule |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Metronome gate locked stationary; rhythmic oscillation begins only after $K$ threads clear. |
| 2 | `Colored(c)` | **Dyed** | Ordered hem verifies numerical sequence strictly for threads matching color $c$. |
| 3 | `Fluffed` | **Fluffed** | Next required color in pattern clasp sequence hidden under wool fluff; revealed on neighbor unravel. |
| 4 | `Chained` | **Ribbon-Tied** | Two metronome gates linked; toggle in inverse phases (one opens as the other closes). |
| 5 | `Countdown(N)` | **Basting** | Ordered hem constraint dissolves after $N$ player moves, becoming a normal open border. |
| 6 | `Phasing` | **Sheer Silk** | Pattern clasp alternates between solid barrier and intangible ghost on alternating moves. |
| 7 | `Armored` | **Brass-Plated** | Pattern clasp is reinforced; cannot be bypassed or forced with boosters. |
| 8 | `Layered` | **Tulle** | Rhythm gates block passage only for threads residing on a specific fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Color sequence on the right board sector must be performed in exact reverse of the left sector. |
| 10 | `Growing` | **Step-Expanding** | Echo card requirement window length expands by 1 step every 10 moves. |

### 2. 45 Variant Slot Assignment (Blocks 3–49)
The 45 variant slots combine base mechanics M451–M454 with the 10 craft modifiers:
- **Blocks 3–13 (L4521–4630, 11 slots):** M451 Metronome Gate Variants:
  - Knotted Metronome (L4521), Phasing Beats (L4531), Ribbon-Tied Inverted Gates (L4541), Basting Rhythm Gate (L4551), Dyed Metronome (L4561), Fluffed Metronome Gate (L4571), Brass-Plated Gate Frame (L4581), Multi-Layer Rhythm Gates (L4591), Mirror-Stitched Beats (L4601), Step-Expanding Interval (L4611), Triple-Gate Harmonic Beat (L4621).
- **Blocks 15–25 (L4641–4750, 11 slots):** M452 Pattern Clasp Variants:
  - Fluffed Sequence (L4641), Mirrored Pattern Locks (L4651), Dyed Clasps (L4661), Knotted Pattern Clasp (L4671), Ribbon-Tied Dual Clasps (L4681), Basting Pattern Lock (L4691), Sheer Silk Clasp (L4701), Brass-Plated Brooch (L4711), Multi-Layer Clasp Sequence (L4721), Step-Expanding Color Sequence (L4731), Quad-Color Spectrum Lock (L4741).
- **Blocks 27–37 (L4761–4870, 11 slots):** M453 Ordered Hem Variants:
  - Basting Hems (L4761), Armored Boundaries (L4771), Multi-Tier Hems (L4781), Knotted Border Hem (L4791), Dyed Ordered Hem (L4801), Fluffed Hem Numbers (L4811), Ribbon-Tied Border Hems (L4821), Sheer Silk Border Gaps (L4831), Mirror-Stitched Numbered Edges (L4841), Step-Expanding Number Series (L4851), Alternating Odd/Even Hem (L4861).
- **Blocks 39–49 (L4881–4990, 11 slots):** M454 Echo Card Variants & Pattern Book Mix:
  - Knotted Echo Card (L4881), Dyed Echo Mirror (L4891), Ribbon-Tied Echo Cards (L4901), Basting Echo Window (L4911), Brass-Plated Echo Tracker (L4921), Sheer Silk Echo (L4931), Fluffed Echo Swatches (L4941), Metronome + Pattern Clasp Harmonic (L4951), Ordered Hem + Echo Loop (L4961), Multi-Stage Orchestrated Pattern (L4971), Pre-Mastery Pattern Synthesis (L4981).

### 3. Solvability Constraints
- Reverse generator ensures at least one legal sequence permutation exists without heart loss or dead ends.
- Verified 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/sequence_modifiers.dart` (to be created: modifier definitions)
- `tools/levelgen/lib/src/generators/phase_10_variant_builder.dart` (to be created: slot composer)

## Risks
- Excessive cognitive load if sequence length exceeds 4 steps. Mitigated by capping maximum sequence lengths to 4.

## Open Questions
None. Variant slots and modifier specifications adhere to SCALING §7 and Phase 10 docs.
