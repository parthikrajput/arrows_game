Source docs: phases/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-13-base-mechanics.md, specs/gameplay/phase-13-signature-system.md.

# Spec: Gameplay — Phase 13 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 procedural variant slots (V01–V45) across Blocks 603 to 650 for Phase 13 (Levels 6001–6500), detailing how base mechanics M601–M604 synthesize with the 10 core modifiers.

## Current State
Design documented in `phases/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Base mechanics M601–M604 establish scout geckos, trick mist, painted false walls, and tactile glow stone plates.
- Modifiers synthesize complex visibility puzzles, directional illusions, and dual-plate circuits within the fixed plateau $D \in [60, 76]$ band.

## Proposed Change
Implement the 45 variant configurations in `packages/puzzle_core/lib/src/variants/phase_13/`:

### 1. The 10 Core Modifiers Applied to Phase 13
1. **MOD-01 (Multi-Stage / Chained):** Multi-tier fog, dual scouts, labyrinth of illusions (4 false walls), or cathedral of light (3 glow stones).
2. **MOD-02 (Directional / Polarized):** One-way painted walls (passable Eastward only) or directional glow beams.
3. **MOD-03 (Color-Coded):** Chromatic gating; only matched colors act as scouts, penetrate walls, or activate glow plates.
4. **MOD-04 (Move Countdown / Expiry):** Urgent scout deadlines (6 moves), creeping fog, or temporary painted walls hardening into stone.
5. **MOD-05 (Speed / Surge):** Rapid scouting with enlarged 2-cell reveal radiuses or surge false walls accelerating snakes.
6. **MOD-06 (Inverted / Shadow Mimic):** Dispersal mist shifting outward, or deceptive shadows mimicking resting snakes.
7. **MOD-07 (Paired Plates / Relays):** Dual glow stones or linked dual scouts that unlock sequentially.
8. **MOD-08 (Rotating / Shifting):** Swirling fog vortexes or painted walls that rotate $90^\circ$ post-traversal.
9. **MOD-09 (Ice Slide Mist):** Concealed ice tracks beneath fog layers revealed only via raycast probes.
10. **MOD-10 (Obstacle Guarded):** False walls and reveal plates guarded by rock barriers, mud patches, or bramble vines.

---

### 2. Complete 45-Variant Catalog (Blocks 603–650)

| Var # | Block | Level (x1) | Base Mech | Modifier | Name & Rule |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 603 | 6021 | M601 | MOD-03 | **Chroma Scout:** Only Sapphire Blue snakes possess the gecko crest and scouting ability. |
| **V02** | 604 | 6031 | M601 | MOD-01 | **Dual Scouts:** Two independent scout geckos placed in opposing board quadrants. |
| **V03** | 605 | 6041 | M601 | MOD-04 | **Urgent Scout:** Scout must be liberated within 6 moves or fog deepens across perimeter. |
| **V04** | 606 | 6051 | M601 | MOD-05 | **Sprint Scout:** Scout slithers at high velocity, expanding permanent reveal radius to 2 cells. |
| **V05** | 607 | 6061 | M601 | MOD-09 | **Icy Scout Path:** Scout glides across hidden ice lanes, uncovering a long continuous corridor. |
| **V06** | 608 | 6071 | M601 | MOD-10 | **Muddy Scout:** Scout snake is mired in mud; requires clearing mud obstacle first. |
| **V07** | 609 | 6081 | M601 | MOD-07 | **Linked Scouts:** Evacuating Scout 1 activates the dormant crest of Scout 2. |
| **V08** | 610 | 6091 | M601 | MOD-08 | **Radial Scout:** Scout generates a circular 3-cell radius reveal burst upon board departure. |
| **V09** | 611 | 6101 | M601 | MOD-02 | **Cross-Lane Scout:** Scout clears horizontal lanes exclusively, leaving vertical lanes veiled. |
| **V10** | 612 | 6111 | M601 | MOD-06 | **Dispersal Scout:** Clearing central mist pushes residual fog wisps toward outer boundaries. |
| **V11** | 613 | 6121 | M601 | MOD-01 | **Grand Scout Sweep:** Master scout whose departure permanently dissolves all board fog. |
| **V12** | 615 | 6141 | M602 | MOD-04 | **Dense Trick Mist:** Vacated snake tiles re-cloak with 2 adjacent cells shrouded. |
| **V13** | 616 | 6151 | M602 | MOD-03 | **Color Mimic Mist:** Trick mist spawns only upon the departure of Yellow snakes. |
| **V14** | 617 | 6161 | M602 | MOD-09 | **Frozen Fog:** Trick mist conceals slippery ice tiles beneath its opaque veil. |
| **V15** | 618 | 6171 | M602 | MOD-01 | **Creeping Fog:** Unrevealed fog creeps 1 additional cell inward every 2 player moves. |
| **V16** | 619 | 6181 | M602 | MOD-05 | **Rapid Mist:** Mist reforms instantaneously upon the departure of a standard snake. |
| **V17** | 620 | 6191 | M602 | MOD-10 | **Thorn-Guarded Mist:** Mist clusters around M351 Wild Vines; clearing vines clears mist. |
| **V18** | 621 | 6201 | M602 | MOD-07 | **Dual Fog Centers:** Two separate vortex epicenters respawning mist on alternating turns. |
| **V19** | 622 | 6211 | M602 | MOD-08 | **Swirling Fog:** Unrevealed mist vortex translates 1 cell clockwise along perimeter per move. |
| **V20** | 623 | 6221 | M602 | MOD-02 | **Directional Fog:** Mist re-cloaks only along Northern egress sectors. |
| **V21** | 624 | 6231 | M602 | MOD-06 | **Shadow Mimic:** Shrouded cells generate visual shadow silhouettes mimicking snakes. |
| **V22** | 625 | 6241 | M602 | MOD-01 | **Phantom Shroud:** 3rd snake exit triggers an unexpected localized fog resurgence. |
| **V23** | 627 | 6261 | M603 | MOD-02 | **One-Way Painted Wall:** Passage permitted strictly from West to East; East to West blocked. |
| **V24** | 628 | 6271 | M603 | MOD-01 | **Double False Wall:** Dual parallel painted walls concealing a secret bypass corridor. |
| **V25** | 629 | 6281 | M603 | MOD-03 | **Colored Painted Wall:** Wall canvas dyed Crimson; only Ruby Red snakes can pass through. |
| **V26** | 630 | 6291 | M603 | MOD-04 | **Temporary False Wall:** Wall hardens into genuine impassable stone after 5 player moves. |
| **V27** | 631 | 6301 | M603 | MOD-07 | **Mirror Painted Walls:** Symmetrical false walls guarding opposite perimeter exits. |
| **V28** | 632 | 6311 | M603 | MOD-10 | **Muddy False Wall:** Exiting through the false wall discharges the snake into deep mud. |
| **V29** | 633 | 6321 | M603 | MOD-05 | **Surge False Wall:** Penetrating the canvas imparts a burst of forward slither acceleration. |
| **V30** | 634 | 6331 | M603 | MOD-08 | **Rotating Painted Wall:** False wall orientation rotates $90^\circ$ after snake passage. |
| **V31** | 635 | 6341 | M603 | MOD-09 | **Glacier Painted Wall:** Both entry and exit approaches to the wall are frozen ice lanes. |
| **V32** | 636 | 6351 | M603 | MOD-06 | **Inverted False Wall:** Renders as an open archway but is actually an impassable painted gate. |
| **V33** | 637 | 6361 | M603 | MOD-01 | **Labyrinth of Illusions:** 4 false walls distributed across a dense stone maze. |
| **V34** | 639 | 6381 | M604 | MOD-03 | **Chroma Glow Stone:** Plate illuminates only when compressed by an Emerald Green snake. |
| **V35** | 640 | 6391 | M604 | MOD-01 | **Wide Glow Stone:** Mega-plate illuminating a massive $5 \times 5$ surrounding region. |
| **V36** | 641 | 6401 | M604 | MOD-04 | **Fading Plate:** Illumination lingers for 2 additional moves after snake vacates plate. |
| **V37** | 642 | 6411 | M604 | MOD-07 | **Dual Plate Circuit:** Both plates must be concurrently occupied to uncloak the board. |
| **V38** | 643 | 6421 | M604 | MOD-05 | **Pulse Stone:** Plate emits a rhythmic strobe pulse dispelling fog every other move. |
| **V39** | 644 | 6431 | M604 | MOD-10 | **Rock-Blocked Plate:** Jade plate is obstructed by rock barriers requiring hammer demolition. |
| **V40** | 645 | 6441 | M604 | MOD-08 | **Shifting Glow Plate:** Plate location teleports 2 cells along stone flags every 3 moves. |
| **V41** | 646 | 6451 | M604 | MOD-09 | **Ice-Covered Plate:** Snake must glide across frictionless ice to slide onto the plate. |
| **V42** | 647 | 6461 | M604 | MOD-02 | **Directional Glow:** Plate projects an illuminated beam in a single cardinal direction. |
| **V43** | 648 | 6471 | M604 | MOD-06 | **Negative Stone:** Pressing the plate dispels local fog while cloaking opposite quadrant. |
| **V44** | 649 | 6481 | M604 | MOD-01 | **Cathedral of Light:** 3 interconnected plates bathing the entire puzzle in permanent radiance. |
| **V45** | 650 | 6495 | M601 | MOD-01 | **Phantom Mastery:** Grand ensemble of Scout Gecko, Trick Mist, Painted Wall, and Glow Stones. |

---

### 3. Solver Verification
A* headless solver verifies all 45 variants with full omniscience of veiled tiles, guaranteeing 0-booster deterministic completion while confirming that long-press previews provide adequate information to eliminate blind guessing.

## Affected Files
- `packages/puzzle_core/lib/src/variants/phase_13/` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_13_variant_rules.dart` (to be created)
- `test/variants/phase_13_variants_test.dart` (to be created)

## Risks and Open Questions
- **V32 Inverted False Wall Fairness:** An open archway that is actually solid violates the intuitive visual rule. Long-press raycast must explicitly flag it with a flashing red warning cross to avoid player frustration.
