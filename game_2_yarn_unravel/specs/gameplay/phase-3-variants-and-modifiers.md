Source docs: phase/phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-3-base-mechanics.md.

# Spec: Gameplay — Phase 3 Variants & Craft Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 standardized craft modifiers and the 45 variant slot combinations for Yarn Unravel Phase 3 (Levels 1001–1500), detailing how base mechanics M101–M104 are wrapped by modifiers to deliver variety across the fixed plateau difficulty band (D 60–76).

## Current State
Design documented in `phase/phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Phases 1 and 2 relied on standalone base mechanics.
- Phase 3 introduces the standardized combinatorial modifier architecture where 10 modifiers combine with base mechanics across 45 designated block intro slots (x1).

## Proposed Change
Implement the modifier wrapper system in `packages/puzzle_core/lib/src/modifiers/`:

### 1. The 10 Craft Modifiers
Modifiers wrap base mechanics without altering their core identity:

| # | Formal Identifier | Themed Name | Gameplay Rule & Behavioral Contract |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Instance remains locked/inert until all $K$ adjacent threads exit the board. Blockers remain solid; interactive elements ignore taps. |
| 2 | `Colored(c)` | **Dyed** | Behavioral effect applies only to threads matching yarn color $c$; acts as a solid blocker to all other thread colors. |
| 3 | `Fogged` | **Fluffed** | Entity is concealed beneath wool fluff (M010); revealed only when an adjacent thread segment clears. |
| 4 | `Chained` | **Ribbon-Tied** | Two paired entities are linked with ribbon; state transitions (open/close/rotate) trigger simultaneously on both. |
| 5 | `Countdown(N)` | **Basting** | Displays a move counter $N$ which decrements by 1 on each player move; at count 0, the obstacle permanently vanishes or opens. |
| 6 | `Phasing` | **Sheer Silk** | Alternates between solid and semi-transparent ghost states on odd vs even move counts. |
| 7 | `Armored` | **Thimble-Reinforced** | Reinforced entity requiring 2 thread impacts or 2 Golden Scissors snips to clear. |
| 8 | `Layered` | **Multi-Layer** | Restricts entity interaction to a designated fabric layer (`layer` 0, 1, or 2). |
| 9 | `Mirrored` | **Reflected** | Twinned entities placed symmetrically across a board axis; moving one reflects on the other. |
| 10 | `Growing` | **Knit-Expanding** | Creeping tangle that grows 1 cell into an empty adjacent cell every $N$ moves. |

### 2. 45 Variant Slot Architecture (Blocks 3–49)
Phase 3 blocks 3 to 49 (excluding Base intros 14, 26, 38) dedicate slot x1 to modifier combinations:

- **M101 Loom Latch Variants (Blocks 3–13, L1021–L1130):**
  - L1021: M101 × Knotted (Loom Latch begins cycling only after key knot clears).
  - L1031: M101 × Dyed (Color-locked cycle latch).
  - L1041: M101 × Fluffed (Concealed cycle latch).
  - L1051: M101 × Ribbon-Tied (Dual linked cycle latches).
  - L1061: M101 × Basting (Cycle latch locks permanently after countdown).
  - L1071: M101 × Sheer Silk (Phasing cycle latch).
  - L1081: M101 × Thimble-Reinforced (Armored cycle latch).
  - L1091: M101 × Multi-Layer (Layer-specific cycle latch).
  - L1101: M101 × Reflected (Mirrored cycle latches).
  - L1111: M101 × Knit-Expanding (Cycle latch tied to wool growth).
  - L1121: M101 Multi-Combination (Knotted + Dyed Loom Latch).

- **M102 Day Bridge Variants (Blocks 15–25, L1141–L1250):**
  - L1141–L1241: Day Bridge wrapped sequentially with Knotted, Dyed, Fluffed, Ribbon-Tied, Basting, Sheer Silk, Thimble-Reinforced, Multi-Layer, Reflected, Knit-Expanding, and Combo.

- **M103 Night Pompom Variants (Blocks 27–37, L1261–L1370):**
  - L1261–L1361: Night Pompom wrapped with the 10 modifiers (e.g. L1261 Fluffed Pompom, L1271 Dyed Pompom, L1281 Knotted Pompom, L1291 Ribbon-Tied Pompom).

- **M104 Twilight Eyelet Variants & Multi-Base Ramp (Blocks 39–49, L1381–L1490):**
  - L1381–L1431: Twilight Eyelet with standard modifiers.
  - L1441–L1481: Multi-Base System Ramp: M101 + M102 combo (L1441), M101 + M103 combo (L1461), M102 + M104 combo (L1481).

### 3. Modifier Implementation Pipeline
- Modifiers implement `ModifierWrapper` decorating the underlying `MechanicController`.
- Stored in level JSON as decorator objects within `mechanics[].params.modifier`.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/modifier_wrapper.dart` (to be created: decorator base class)
- `packages/puzzle_core/lib/src/modifiers/*.dart` (to be created: 10 modifier implementations)
- `packages/puzzle_core/test/modifiers/modifiers_test.dart` (to be created)

## Risks
- Combinatorial explosion of modifier interactions causing unexpected soft-locks. Mitigated by CI solver validating every generated variant seed with zero-heart check.

## Open Questions
None. The 10 craft modifier names and slot map match Phase 3 documentation.
