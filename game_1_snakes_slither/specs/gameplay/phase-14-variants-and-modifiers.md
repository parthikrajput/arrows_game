Source docs: phases/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-14-base-mechanics.md, specs/gameplay/phase-14-signature-system.md.

# Spec: Gameplay — Phase 14 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 procedural variant slots (V01–V45) across Blocks 653 to 700 for Phase 14 (Levels 6501–7000), documenting how the 4 Pond Reflections base mechanics (M651–M654) synthesize with the 10 core modifiers.

## Current State
Design documented in `phases/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Base mechanics M651–M654 establish reflective water axes, cross-shore reflection locks, identical twin boards, and inverse-vector polarities.
- Modifiers synthesize complex bilateral coordination puzzles, quad reflections, rotating water axes, and asymmetric twin lengths within the fixed plateau $D \in [60, 76]$ band.

## Proposed Change
Implement the 45 variant configurations in `packages/puzzle_core/lib/src/variants/phase_14/`:

### 1. The 10 Core Modifiers Applied to Phase 14
1. **MOD-01 (Multi-Stage / Chained):** Quad reflections (4 snakes moving simultaneously across 4 quadrants), multi-board cascades, or 3-inverse snake chains.
2. **MOD-02 (Directional / Polarized):** One-way reflection linkage (Snake A controls B, but B cannot command A) or horizontal-only inversion.
3. **MOD-03 (Color-Coded):** Chromatic reflection; only matched twin pairs reflect or unseal cross-shore locks.
4. **MOD-04 (Move Countdown / Expiry):** Timed axis dissipation (6 moves) or temporary inversion that normalizes after 4 turns.
5. **MOD-05 (Speed / Surge Reflections):** Simultaneous acceleration across both shores upon partner command.
6. **MOD-06 (Asymmetric Length / Inverted Parity):** Unequal twin lengths (e.g. 5-segment snake paired with 3-segment snake) or contrary pythons.
7. **MOD-07 (Paired Locks / Relays):** Symmetric dual gates opening in tandem or mutual cross-shore lock exchanges.
8. **MOD-08 (Rotating / Shifting Axis):** Central water axis translates 1 cell or rotates $90^\circ$ every 3–4 moves.
9. **MOD-09 (Ice Slide Reflection):** Symmetrical ice channels where both partners slide simultaneously.
10. **MOD-10 (Obstacle Guarded):** Reflection axes and locks guarded by floating giant lily pads, stone walls, or muddy banks.

---

### 2. Complete 45-Variant Catalog (Blocks 653–700)

| Var # | Block | Level (x1) | Base Mech | Modifier | Name & Rule |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 653 | 6521 | M651 | MOD-03 | **Chroma Mirror:** Only Azure Blue snakes mirror movement across the water axis. |
| **V02** | 654 | 6531 | M651 | MOD-06 | **Unequal Twins:** A 5-segment snake mirrors in tandem with a shorter 3-segment partner. |
| **V03** | 655 | 6541 | M651 | MOD-04 | **Timed Axis:** Mirror axis link dissolves into water if unused within 6 player moves. |
| **V04** | 656 | 6551 | M651 | MOD-05 | **Rapid Reflections:** Both mirror partners sprint at double velocity toward perimeter exits. |
| **V05** | 657 | 6561 | M651 | MOD-09 | **Glacier Mirror:** Both partners glide simultaneously across parallel frozen pond lanes. |
| **V06** | 658 | 6571 | M651 | MOD-10 | **Lily-Guarded Axis:** Massive floating lily pads partially obstruct the axis crossing line. |
| **V07** | 659 | 6581 | M651 | MOD-07 | **Dual Axis Grid:** Dual orthogonal reflection axes (horizontal and vertical cross). |
| **V08** | 660 | 6591 | M651 | MOD-08 | **Shifting Water Axis:** Axis shifts 1 coordinate cell eastward every 3 player moves. |
| **V09** | 661 | 6601 | M651 | MOD-01 | **Quad Reflection:** 4 snakes in 4 quadrants moving in 4-way radial symmetry. |
| **V10** | 662 | 6611 | M651 | MOD-02 | **One-Way Reflection:** Snake A commands partner B; tapping Snake B does not move Snake A. |
| **V11** | 663 | 6621 | M651 | MOD-03 | **Prism Mirror:** Chromatic multi-pair network where each hue has an independent axis. |
| **V12** | 665 | 6641 | M652 | MOD-03 | **Colored Key Lock:** Cross-shore gate unseals only when an Amethyst key snake exits. |
| **V13** | 666 | 6651 | M652 | MOD-01 | **Dual Reflection Locks:** Two distinct keys unseal two opposing cross-shore barriers. |
| **V14** | 667 | 6661 | M652 | MOD-04 | **Urgent Reflection:** Key snake must reach exit within 5 moves or lock hardens. |
| **V15** | 668 | 6671 | M652 | MOD-07 | **Symmetric Key Gate:** Gates on Shore A and Shore B open in simultaneous unlock harmony. |
| **V16** | 669 | 6681 | M652 | MOD-05 | **Surge Key Flight:** Liberating key snake sends high-velocity shockwave opening gate. |
| **V17** | 670 | 6691 | M652 | MOD-10 | **Rock Guarded Lock:** Target lock protected by crackable stone barriers. |
| **V18** | 671 | 6701 | M652 | MOD-08 | **Rotating Reflect Lock:** Gate rotates $90^\circ$ clockwise upon receiving cross-shore key spark. |
| **V19** | 672 | 6711 | M652 | MOD-09 | **Icy Reflect Lock:** Key snake must navigate slippery ice rinks to trigger remote unlock. |
| **V20** | 673 | 6721 | M652 | MOD-02 | **Directional Reflect Lock:** Lock only accepts the unlocking wave from the Northern shore. |
| **V21** | 674 | 6731 | M652 | MOD-06 | **Inverse Reflection Lock:** Liberating the key unlocks Shore A but closes a Shore B bypass. |
| **V22** | 675 | 6741 | M652 | MOD-01 | **Master Reflection Gate:** Triple cross-keys required to unseal grand central watergate. |
| **V23** | 677 | 6761 | M653 | MOD-03 | **Chroma Twin Ponds:** Chromatic pairs synchronized identically across dual mini-grids. |
| **V24** | 678 | 6771 | M653 | MOD-01 | **Multi-Board Sequence:** 3 mirrored boards solved in synchronized parallel sequence. |
| **V25** | 679 | 6781 | M653 | MOD-04 | **Synchronous Timer:** Both twin boards share an aggregate turn budget of 10 moves. |
| **V26** | 680 | 6791 | M653 | MOD-07 | **Linked Board Portals:** Clearing twin snakes unseals cross-board burrow conduits. |
| **V27** | 681 | 6801 | M653 | MOD-05 | **Rapid Twin Clear:** Twin snakes accelerate into fast slither upon initial clearance. |
| **V28** | 682 | 6811 | M653 | MOD-10 | **Muddy Twin Ponds:** One pond has muddy banks while twin pond features clear water. |
| **V29** | 683 | 6821 | M653 | MOD-08 | **Revolving Twin Boards:** Boards rotate in opposite directions post-clearance. |
| **V30** | 684 | 6831 | M653 | MOD-09 | **Glacier Twin Ponds:** Twin boards completely frozen over in frictionless ice flagging. |
| **V31** | 685 | 6841 | M653 | MOD-02 | **Diagonal Twin Boards:** Reflection axis oriented diagonally at $45^\circ$. |
| **V32** | 686 | 6851 | M653 | MOD-06 | **Inverted Twin Ponds:** Northward move on Pond 1 translates to Southward move on Pond 2. |
| **V33** | 687 | 6861 | M653 | MOD-01 | **Grand Twin Mirror:** Flawless dual-pond architecture requiring identical move parity. |
| **V34** | 689 | 6881 | M654 | MOD-03 | **Color Inversion:** Only Golden Yellow snakes move in reverse inverse polarity. |
| **V35** | 690 | 6891 | M654 | MOD-01 | **Dual Inverse Snakes:** Two separate inverse snakes moving in divergent directions. |
| **V36** | 691 | 6901 | M654 | MOD-04 | **Urgent Inversion:** Inverse snake reverts to normal forward movement after 4 moves. |
| **V37** | 692 | 6911 | M654 | MOD-07 | **Symmetric Opposites:** Inverse snake exit instantly releases forward partner snake. |
| **V38** | 693 | 6921 | M654 | MOD-05 | **Turbo Inversion:** Inverse snake springs backward with high-speed propulsion. |
| **V39** | 694 | 6931 | M654 | MOD-10 | **Rock Guarded Inversion:** Inverse snake path threads between crackable stone pillars. |
| **V40** | 695 | 6941 | M654 | MOD-08 | **Rotating Inverse Path:** Inversion vector shifts $90^\circ$ clockwise after each move. |
| **V41** | 696 | 6951 | M654 | MOD-09 | **Ice Inversion:** Inverse snake glides backward across frictionless frozen ponds. |
| **V42** | 697 | 6961 | M654 | MOD-02 | **Horizontal Inverse:** Reverse polarity restricted to horizontal East-West axis. |
| **V43** | 698 | 6971 | M654 | MOD-06 | **Contrarian Python:** Heavy long snake moving in reverse polarity to partner. |
| **V44** | 699 | 6981 | M654 | MOD-01 | **Inverse Cascade:** 3 inverse snakes executing sequential counter-moves. |
| **V45** | 700 | 6995 | M651 | MOD-01 | **Obsidian Mirror Symphony:** Master convergence of Axis, Reflect Lock, Twin Boards, and Inverse Snakes. |

---

### 3. Solver Verification
A* headless solver validates all 45 variant configurations under bilateral symmetry constraints, ensuring deterministic $0$-booster completion within standard search depth bounds.

## Affected Files
- `packages/puzzle_core/lib/src/variants/phase_14/` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_14_variant_rules.dart` (to be created)
- `test/variants/phase_14_variants_test.dart` (to be created)

## Risks and Open Questions
- **V09 Quad Reflection Solver Branching:** Coordinating 4 snakes concurrently creates high branching factors. Initial snake lengths must be capped at $\le 4$ segments to keep solver latency $< 150\text{ ms}$.
