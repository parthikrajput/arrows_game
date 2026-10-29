Source docs: phases/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-12-base-mechanics.md, specs/gameplay/phase-12-signature-system.md.

# Spec: Gameplay — Phase 12 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 procedural variant slots (V01–V45) across Blocks 553 to 600 for Phase 12 (Levels 5501–6000), documenting how the 4 Monsoon Winds base mechanics (M551–M554) synthesize with the 10 core modifiers.

## Current State
Design documented in `phases/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Base mechanics M551–M554 establish wind levers, falling fruit cascades, anti-gravity suspension, and autonomous heavy python slides.
- Modifiers introduce bi-directional toggles, cascading avalanches, auto-gust timers, and buoyant interactions within the $D \in [60, 76]$ plateau band.

## Proposed Change
Implement the 45 variant configurations in `packages/puzzle_core/lib/src/variants/phase_12/`:

### 1. The 10 Core Modifiers Applied to Phase 12
1. **MOD-01 (Multi-Stage / Chained):** Multi-lever networks, fruit avalanches (5 fruits domino), or 3-python cascades.
2. **MOD-02 (Directional / Polarized):** Bi-directional levers ($\downarrow \leftrightarrow \uparrow$) or upward-floating buoyant fruits.
3. **MOD-03 (Color-Coded):** Chromatic gating; fruits or levers interact only with snakes of matching hue.
4. **MOD-04 (Move Countdown / Expiry):** Auto-gust timers rotating wind every $K$ turns, or decaying fruits that dissolve after 8 moves.
5. **MOD-05 (Rapid Cascade):** Accelerated 2-cell descents or full wall-to-wall slides upon falling.
6. **MOD-06 (Inverted Gravity / Anti-Symmetry):** Inverted gravity vector, bouncing coconuts, or counter-clockwise lever rotations.
7. **MOD-07 (Paired Levers / Relays):** Linked dual wind vanes or interlocked python mass pairs.
8. **MOD-08 (Rotating / Drifting):** Self-rotating levers or drifting lily pads that shift 1 cell per turn.
9. **MOD-09 (Ice Slide Fruit):** Post-fall momentum carries fruits across frictionless ice lanes.
10. **MOD-10 (Obstacle Guarded):** Levers and fruits encased in mud coatings, stone barriers, or thorny vines.

---

### 2. Complete 45-Variant Catalog (Blocks 553–600)

| Var # | Block | Level (x1) | Base Mech | Modifier | Name & Rule |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 553 | 5521 | M551 | MOD-02 | **Bi-Directional Lever:** Toggles gravity exclusively between Up and Down orientations. |
| **V02** | 554 | 5531 | M551 | MOD-01 | **Dual Levers:** Two independent levers controlling separate board sector gravity zones. |
| **V03** | 555 | 5541 | M551 | MOD-04 | **Gust Timer:** Wind rotates autonomously $90^\circ$ every 5 moves if lever is unused. |
| **V04** | 556 | 5551 | M551 | MOD-07 | **Linked Wind Vanes:** Tapping one lever rotates both vanes by $180^\circ$ simultaneously. |
| **V05** | 557 | 5561 | M551 | MOD-09 | **Frozen Lever:** Lever is frozen solid; requires clearing ice coating before operation. |
| **V06** | 558 | 5571 | M551 | MOD-05 | **Turbulent Lever:** Lever activation causes all active fruits to plummet 2 cells instantly. |
| **V07** | 559 | 5581 | M551 | MOD-10 | **Muddy Lever:** Lever handle mired in mud; requires freeing to rotate. |
| **V08** | 560 | 5591 | M551 | MOD-08 | **Self-Rotating Lever:** Wind rotates $90^\circ$ automatically every 3 player moves. |
| **V09** | 561 | 5601 | M551 | MOD-06 | **Reverse Wind Lever:** Lever rotates gravity in counter-clockwise sequence. |
| **V10** | 562 | 5611 | M551 | MOD-03 | **Chroma Lever:** Lever unlocks only when commanded by an Amber-colored snake. |
| **V11** | 563 | 5621 | M551 | MOD-01 | **Master Wind Turbine:** 4 interconnected levers situated at board quadrant corners. |
| **V12** | 565 | 5641 | M552 | MOD-05 | **Heavy Mango:** Massive jungle fruit falling 2 cells per settling tick. |
| **V13** | 566 | 5651 | M552 | MOD-03 | **Colored Fruit:** Can only be nudged or pushed by snakes of matching hue. |
| **V14** | 567 | 5661 | M552 | MOD-09 | **Slick Melon:** Descends onto ice lane, sliding horizontally until hitting perimeter wall. |
| **V15** | 568 | 5671 | M552 | MOD-01 | **Cascade Fruits:** Impact of falling fruit triggers secondary fruit drops in domino wave. |
| **V16** | 569 | 5681 | M552 | MOD-04 | **Decaying Fruit:** Overripe fruit that dissolves and vanishes after 8 moves. |
| **V17** | 570 | 5691 | M552 | MOD-10 | **Mud-Coated Fruit:** Mud friction limits fall to exactly 1 cell per settling pass. |
| **V18** | 571 | 5701 | M552 | MOD-07 | **Twin Falling Melons:** Dual fruits falling along parallel vertical corridors. |
| **V19** | 572 | 5711 | M552 | MOD-08 | **Rolling Fruit:** Bounces off angled corner deflectors upon landing. |
| **V20** | 573 | 5721 | M552 | MOD-02 | **Upward Fruit:** Low-density buoyant fruit rising upward under inverse gravity. |
| **V21** | 574 | 5731 | M552 | MOD-06 | **Bouncing Coconut:** Hits floor and rebounds 1 cell upward before settling. |
| **V22** | 575 | 5741 | M552 | MOD-01 | **Fruit Avalanche:** 5 fruits falling in unison, dynamically blocking and clearing lanes. |
| **V23** | 577 | 5761 | M553 | MOD-01 | **Floating Lily Field:** Cluster of 3 anti-gravity lilies forming a high-altitude shelf. |
| **V24** | 578 | 5771 | M553 | MOD-04 | **Sinking Lily:** Pad sinks into water after supporting a fruit for 2 turns. |
| **V25** | 579 | 5781 | M553 | MOD-03 | **Colored Lily:** Provides anti-gravity buoyancy exclusively to matching-colored fruits. |
| **V26** | 580 | 5791 | M553 | MOD-08 | **Drifting Lily:** Floating pad drifts 1 cell along water channel on each move. |
| **V27** | 581 | 5801 | M553 | MOD-07 | **Paired Lilies:** Dual lilies sharing stability; vacating one collapses the other. |
| **V28** | 582 | 5811 | M553 | MOD-10 | **Bramble Lily:** Anti-gravity pad surrounded by M351 Wild Vines requiring pruning. |
| **V29** | 583 | 5821 | M553 | MOD-05 | **Spring Lily:** Elastic pad catapulting resting fruit 2 cells into adjacent corridor. |
| **V30** | 584 | 5831 | M553 | MOD-09 | **Frozen Lily:** Encased in ice; requires snake slither to activate anti-gravity field. |
| **V31** | 585 | 5841 | M553 | MOD-02 | **Directional Shield Lily:** Shields fruits from downward gravity while admitting lateral slides. |
| **V32** | 586 | 5851 | M553 | MOD-06 | **Repulsion Lily:** Pushes fruits away by 1 cell upon contact. |
| **V33** | 587 | 5861 | M553 | MOD-01 | **Sanctuary of Lilies:** Central sanctuary of 4 lilies creating a secure safe harbor for fruits. |
| **V34** | 589 | 5881 | M554 | MOD-03 | **Chroma Python:** Halts and supports only fruits matching its obsidian dorsal scales. |
| **V35** | 590 | 5891 | M554 | MOD-01 | **Twin Pythons:** Two heavy snakes that slide sequentially in alternating turns. |
| **V36** | 591 | 5901 | M554 | MOD-04 | **Sluggish Python:** Slides 1 cell only on every second move ($\text{Move} \pmod 2 == 0$). |
| **V37** | 592 | 5911 | M554 | MOD-05 | **Fast Fall Python:** Heavy snake slides all the way to boundary wall upon vacancy. |
| **V38** | 593 | 5921 | M554 | MOD-10 | **Mud-Weighted Python:** Mired in thick mud; resists gravity until mud is evacuated. |
| **V39** | 594 | 5931 | M554 | MOD-08 | **Rotating Python:** Reorients its head vector $90^\circ$ after executing an autonomous slide. |
| **V40** | 595 | 5941 | M554 | MOD-09 | **Glacier Python:** Heavy snake slides along ice lane to abruptly open egress corridor. |
| **V41** | 596 | 5951 | M554 | MOD-02 | **Horizontal Slider:** Python structured to slide horizontally rather than vertically. |
| **V42** | 597 | 5961 | M554 | MOD-06 | **Buoyant Python:** Reaches lily tile and becomes weightless, suspending in air. |
| **V43** | 598 | 5971 | M554 | MOD-07 | **Interlocked Pythons:** Two heavy pythons mutually bracing each other until one is cleared. |
| **V44** | 599 | 5981 | M554 | MOD-01 | **Python Squeeze:** 3 heavy snakes falling concurrently to open a tight central throat. |
| **V45** | 600 | 5995 | M551 | MOD-01 | **Eye of the Tempest:** Master synthesis of Wind Lever, Falling Fruit, Lily, and Heavy Python. |

---

### 3. Solver Constraints
The generator verifies that gravity transitions and fruit descents never induce endless cycles or permanent board blockages. Solver maintains a visited state set including active gravity vectors to guarantee $0$-booster completion in $< 200\text{ ms}$.

## Affected Files
- `packages/puzzle_core/lib/src/variants/phase_12/` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_12_variant_rules.dart` (to be created)
- `test/variants/phase_12_variants_test.dart` (to be created)

## Risks and Open Questions
- **V22 Fruit Avalanche Solver Depth:** Simulating 5 cascading fruits simultaneously increases potential board permutations. Generator rules must constrain grid bounds ($12 \times 12$) and cap movable fruits to 5 to preserve instant generation response.
