Source docs: phases/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-11-base-mechanics.md, specs/gameplay/phase-11-signature-system.md.

# Spec: Gameplay — Phase 11 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 procedural variant slots (V01–V45) across Blocks 503 to 550 for Phase 11 (Levels 5001–5500), detailing how the dual-board base mechanics (M501–M504) synthesize with the 10 core modifiers.

## Current State
Design documented in `phases/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Base mechanics M501–M504 establish vine bridge edge transits, cross-board messenger locks, synchronized reflection pairs, and inter-board wormholes.
- Modifiers synthesize complex dual-grid interactions across the fixed plateau difficulty band $D \in [60, 76]$.

## Proposed Change
Implement the 45 variant specifications in `packages/puzzle_core/lib/src/variants/phase_11/`:

### 1. The 10 Core Modifiers Applied to Phase 11
1. **MOD-01 (Multi-Stage / Chained):** Multi-hop transits (Board 1 $\to$ Board 2 $\to$ Board 1), zig-zag bridges, or quad-reflection arrays.
2. **MOD-02 (Directional / Polarized):** Strictly one-way transit vectors (Board 1 to Board 2 only, or compass-restricted entries).
3. **MOD-03 (Color-Coded):** Chromatic gating; only matched colors can cross specific bridges, carry messenger keys, or enter portals.
4. **MOD-04 (Move Countdown / Expiry):** Withering bridges or decaying portals that seal after $K$ moves.
5. **MOD-05 (Speed / Surge Transit):** Accelerated slither velocity across inter-board thresholds.
6. **MOD-06 (Inverted / Anti-Symmetry):** Inverted mirror movement (Snake A moves North while Snake B moves South) or reverse exit orientation.
7. **MOD-07 (Paired Keys / Relays):** Dual parallel bridges, mutual key exchanges, or synchronized symmetric gates.
8. **MOD-08 (Rotating / Shifting):** Bridge edge coordinates translate or portal exit vectors rotate after each transit.
9. **MOD-09 (Ice Slide Transit):** Inter-board bridge or portal ejects snakes directly onto frictionless ice channels.
10. **MOD-10 (Obstacle Guarded):** Bridgeheads and burrows guarded by giant lily pads, stone barriers, or bramble vines.

---

### 2. Complete 45-Variant Catalog (Blocks 503–550)

| Var # | Block | Level (x1) | Base Mech | Modifier | Name & Rule |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 503 | 5021 | M501 | MOD-03 | **Color Bridge:** Only Green snakes are permitted to traverse this vine bridge. |
| **V02** | 504 | 5031 | M501 | MOD-02 | **One-Way Vine:** One-way transit from Board 1 to Board 2 only; reverse transit blocked. |
| **V03** | 505 | 5041 | M501 | MOD-04 | **Withering Bridge:** Bridge withers and collapses if unused within 6 player moves. |
| **V04** | 506 | 5051 | M501 | MOD-05 | **Rapid Crossing:** Snake accelerates to double slither velocity upon crossing bridge threshold. |
| **V05** | 507 | 5061 | M501 | MOD-09 | **Icy Entrance:** Entry cell on Board 2 discharges snake into a 3-tile frictionless ice slide. |
| **V06** | 508 | 5071 | M501 | MOD-10 | **Lily-Blocked Bridge:** A giant floating lily pad obstructs bridgehead; requires clearing first. |
| **V07** | 509 | 5081 | M501 | MOD-07 | **Twin Parallel Bridges:** Dual bridges between boards that must be navigated in coordination. |
| **V08** | 510 | 5091 | M501 | MOD-08 | **Shifting Bridge:** Bridge connection shifts 1 cell along perimeter every 3 player moves. |
| **V09** | 511 | 5101 | M501 | MOD-01 | **Zig-Zag Bridge:** Diagonal winding bridge linking opposite corner coordinates of both ponds. |
| **V10** | 512 | 5111 | M501 | MOD-06 | **Anti-Gravity Bridge:** Snake inverts its orientation vector upon emerging onto Board 2. |
| **V11** | 513 | 5121 | M501 | MOD-03 | **Rainbow Crossing:** Chromatic multi-bridge network where each hue has a dedicated lane. |
| **V12** | 515 | 5141 | M502 | MOD-03 | **Chroma Key:** Messenger snake hue must match the chromatic receptor of the target lock. |
| **V13** | 516 | 5151 | M502 | MOD-01 | **Dual Cross Keys:** Two distinct messenger snakes required to unseal two separate barrier gates. |
| **V14** | 517 | 5161 | M502 | MOD-04 | **Urgent Messenger:** Messenger snake must evacuate within 5 moves or the key dissipates. |
| **V15** | 518 | 5171 | M502 | MOD-07 | **Mutual Exchange:** Board 1 key opens Board 2 gate; Board 2 key opens Board 1 gate. |
| **V16** | 519 | 5181 | M502 | MOD-05 | **Sprint Messenger:** Messenger snake slithers with accelerated speed toward the exit edge. |
| **V17** | 520 | 5191 | M502 | MOD-10 | **Rock Guarded Key:** Messenger snake is entrapped behind crackable rock barriers. |
| **V18** | 521 | 5201 | M502 | MOD-08 | **Rotating Lock:** Target lock rotates its passable face $90^\circ$ after receiving key spark. |
| **V19** | 522 | 5211 | M502 | MOD-09 | **Glacier Key:** Messenger snake must traverse frozen pond terrain to reach exit portal. |
| **V20** | 523 | 5221 | M502 | MOD-02 | **Directional Key Gate:** Lock only accepts the incoming key spark along the Northern vector. |
| **V21** | 524 | 5231 | M502 | MOD-06 | **Inverse Key:** Releasing messenger unlocks primary gate but seals secondary gate. |
| **V22** | 525 | 5241 | M502 | MOD-01 | **Master Lotus Key:** Golden messenger unlocks 3 simultaneous gates across both boards. |
| **V23** | 527 | 5261 | M503 | MOD-06 | **Inverted Mirror:** Snake A moves North while partner Snake B moves South synchronously. |
| **V24** | 528 | 5271 | M503 | MOD-03 | **Color Twin Mirrors:** Only twin pairs of identical coloration mirror movements. |
| **V25** | 529 | 5281 | M503 | MOD-04 | **Timed Mirroring:** Mirror synchronization link expires after 4 moves, decoupling twins. |
| **V26** | 530 | 5291 | M503 | MOD-01 | **Quad Reflection:** 4 snakes (2 on Board 1, 2 on Board 2) move in 4-way unison. |
| **V27** | 531 | 5301 | M503 | MOD-07 | **Symmetric Gate:** Dual exit gates open only if both mirror twins arrive on the same turn. |
| **V28** | 532 | 5311 | M503 | MOD-10 | **Muddy Mirror:** One twin is mired in mud, causing both twins to slither at half speed. |
| **V29** | 533 | 5321 | M503 | MOD-05 | **Surge Reflections:** Both mirror twins sprint simultaneously toward opposite exits. |
| **V30** | 534 | 5331 | M503 | MOD-08 | **Perpendicular Mirror:** Snake A translates horizontally while Snake B translates vertically. |
| **V31** | 535 | 5341 | M503 | MOD-09 | **Ice Mirroring:** Both mirror twins navigate mirrored ice rinks on their respective ponds. |
| **V32** | 536 | 5351 | M503 | MOD-02 | **Restricted Mirror:** Reflection linkage active only when moving along the East-West axis. |
| **V33** | 537 | 5361 | M503 | MOD-01 | **Master Mirror Array:** Complete board mirroring requiring all snakes to evacuate in reflection. |
| **V34** | 539 | 5381 | M504 | MOD-03 | **Chroma Portal:** Portal tunnel only permits snakes matching Sapphire Blue hue. |
| **V35** | 540 | 5391 | M504 | MOD-04 | **Unstable Burrow:** Portal collapses and seals permanently after 3 snakes have transited. |
| **V36** | 541 | 5401 | M504 | MOD-07 | **Dual Portal Pair:** Two separate independent portal channels linking alternating quadrants. |
| **V37** | 542 | 5411 | M504 | MOD-05 | **Turbo Burrow:** Emerging snake launches from portal exit with a burst of forward velocity. |
| **V38** | 543 | 5421 | M504 | MOD-10 | **Bramble Portal:** Burrow entrance choked with thorny M351 Wild Vines; requires pruning. |
| **V39** | 544 | 5431 | M504 | MOD-08 | **Rotating Exit Portal:** Portal output vector rotates $90^\circ$ clockwise after each transit. |
| **V40** | 545 | 5441 | M504 | MOD-06 | **Reversed Portal:** Snake emerges with reversed head-tail polarity into Board 2. |
| **V41** | 546 | 5451 | M504 | MOD-09 | **Ice Burrow Slide:** Portal mouth directly feeds onto an ice lane across Board 2. |
| **V42** | 547 | 5461 | M504 | MOD-02 | **One-Way Burrow:** Portal operates strictly from Board 2 to Board 1; reverse entry blocked. |
| **V43** | 548 | 5471 | M504 | MOD-01 | **Multi-Hop Portal:** 3-stage loop: Board 1 $\to$ Board 2 $\to$ Board 1 return path. |
| **V44** | 549 | 5481 | M504 | MOD-07 | **Cascade Relay:** Exiting the burrow instantly clears downstream Vine Bridge gate. |
| **V45** | 550 | 5495 | M501 | MOD-01 | **Pond Masterpiece:** Grand convergence uniting Vine Bridge, Messenger Key, Mirror, and Portal. |

---

### 3. Solver Constraints
The generator verifies that all dual-grid state spaces avoid infinite bridge loops and satisfy $0$-booster deterministic solvability within search budgets ($\le 50{,}000$ states evaluated per seed).

## Affected Files
- `packages/puzzle_core/lib/src/variants/phase_11/` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_11_variant_rules.dart` (to be created)
- `test/variants/phase_11_variants_test.dart` (to be created)

## Risks and Open Questions
- **V26 Quad Reflection Complexity:** Coordinating 4 synchronized snakes across 2 boards creates tight spatial contention. Generator rules must restrict initial snake lengths to $\le 4$ segments to keep solver latency $< 150\text{ ms}$.
