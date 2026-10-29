Source docs: phases/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md, phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-10-base-mechanics.md, specs/gameplay/phase-10-signature-system.md.

# Spec: Gameplay — Phase 10 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 procedural variant slots (V01–V45) across Blocks 453 to 500 for Phase 10 (Levels 4501–5000), documenting how the 4 sequencing base mechanics (M451–M454) synthesize with the 10 core modifiers.

## Current State
Design documented in `phases/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Base mechanics M451–M454 establish drum gates, totem pattern recognition, ordinal parade departures, and echo replication.
- Modifiers introduce counter-rhythms, multi-beat phases, inverted parity, and directional gating within the $D \in [60, 76]$ plateau band.

## Proposed Change
Implement the 45 variant configurations in `packages/puzzle_core/lib/src/variants/phase_10/`:

### 1. The 10 Core Modifiers Applied to Phase 10
1. **MOD-01 (Multi-Stage / Chained):** 4-beat rhythm cycles (`[O, O, C, C]`) or 3-tier cascade gates.
2. **MOD-02 (Directional / Polarized):** Compass-restricted gating; only eastward or southward exits advance patterns.
3. **MOD-03 (Color-Coded):** Strict chromatic gating; only specific hues trigger drum advances or match totem slots.
4. **MOD-04 (Move Countdown / Expiry):** Tight turn deadlines before pattern window resets.
5. **MOD-05 (Tempo Surge / Fast Rhythm):** Double-step rhythm shifts per move.
6. **MOD-06 (Inverted / Parity):** Anti-phase synchronization (Gate 1 OPEN $\iff$ Gate 2 CLOSED) or even-first parity.
7. **MOD-07 (Paired Totems / Relays):** Synchronized dual totems or dual parade exits required concurrently.
8. **MOD-08 (Rotating Sequence):** Sliding pattern ribbons or shifting gate locations post-exit.
9. **MOD-09 (Ice / Frictionless Slide):** Post-gate paths propel snakes directly across zero-friction ice lanes.
10. **MOD-10 (Obstacle Guarded):** Fixtures surrounded by rock barriers, mud swamps, or thorny vines.

---

### 2. Complete 45-Variant Catalog (Blocks 453–500)

| Var # | Block | Level (x1) | Base Mech | Modifier | Name & Rule |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 453 | 4521 | M451 | MOD-06 | **Counter-Rhythm Gates:** Dual drum gates operate in anti-phase (Gate A opens as Gate B closes). |
| **V02** | 454 | 4531 | M451 | MOD-01 | **4-Beat Drum:** Extended 4-move cycle: `[Open, Closed, Open, Closed]`. |
| **V03** | 455 | 4541 | M451 | MOD-02 | **Directional Drum Gate:** Gate permits entry exclusively from the Northern sector. |
| **V04** | 456 | 4551 | M451 | MOD-03 | **Color Beat:** Gate rhythm advances only when a Yellow snake takes a turn. |
| **V05** | 457 | 4561 | M451 | MOD-09 | **Icy Rhythm:** Open gate discharges snakes directly across 3-tile ice patches. |
| **V06** | 458 | 4571 | M451 | MOD-04 | **Tempo Rush:** Requires evacuating 2 snakes through the gate within 6 moves. |
| **V07** | 459 | 4581 | M451 | MOD-10 | **Muddy Drum:** Drum mechanism clogged with mud; requires clearing mud to cycle rhythm. |
| **V08** | 460 | 4591 | M451 | MOD-05 | **Double Beat:** Every player move advances the rhythm cycle by 2 beats. |
| **V09** | 461 | 4601 | M451 | MOD-07 | **Dual Drum Relay:** Two synchronized gates along a single corridor cycle in unison. |
| **V10** | 462 | 4611 | M451 | MOD-08 | **Shifting Drum:** Rhythm pattern permutes every 4 moves (`[O, C, O] -> [C, O, O]`). |
| **V11** | 463 | 4621 | M451 | MOD-01 | **Tri-Beat Cascade:** Three consecutive gates open sequentially in wave rhythm. |
| **V12** | 465 | 4641 | M452 | MOD-03 | **Strict Color Totem:** Strict 3-color sequence (`Red -> Green -> Blue`). |
| **V13** | 466 | 4651 | M452 | MOD-01 | **Dual Totem Pillars:** Two distinct totems unlock two independent perimeter walls. |
| **V14** | 467 | 4661 | M452 | MOD-04 | **Decaying Totem:** Incorrect color exit causes 1-turn lockout before resetting buffer. |
| **V15** | 468 | 4671 | M452 | MOD-08 | **Rotating Totem Ribbon:** Totem requirement shifts 1 color slot right after each match. |
| **V16** | 469 | 4681 | M452 | MOD-05 | **Fast Match Totem:** Both required color exits must occur on consecutive moves. |
| **V17** | 470 | 4691 | M452 | MOD-10 | **Bramble Totem:** Totem pillar entangled in M351 Wild Vines; requires pruning. |
| **V18** | 471 | 4701 | M452 | MOD-02 | **One-Way Totem Exit:** Only departures through the Western portal feed the totem buffer. |
| **V19** | 472 | 4711 | M452 | MOD-09 | **Glacier Totem:** Snakes must slide across frozen ponds into the totem exit. |
| **V20** | 473 | 4721 | M452 | MOD-07 | **Linked Totems:** Fulfilling Totem 1 activates the dormant eye of Totem 2. |
| **V21** | 474 | 4731 | M452 | MOD-06 | **Inverted Totem:** Gate unlocks only when excluded colors are cleared first. |
| **V22** | 475 | 4741 | M452 | MOD-01 | **Mega Totem:** Complex 4-color chromatic combination requirement. |
| **V23** | 477 | 4761 | M453 | MOD-03 | **Color Parade:** Snakes must match both ordinal number AND designated hue. |
| **V24** | 478 | 4771 | M453 | MOD-01 | **Reverse Parade:** Strictly descending evacuation sequence ($3 \to 2 \to 1$). |
| **V25** | 479 | 4781 | M453 | MOD-04 | **Timed Parade:** Successive parade departures must occur within $\le 3$ moves. |
| **V26** | 480 | 4791 | M453 | MOD-07 | **Dual Parade Gates:** Odd numbers evacuate North, even numbers evacuate South. |
| **V27** | 481 | 4801 | M453 | MOD-05 | **Sprint Parade:** Parade snakes surge into fast slither upon gate approach. |
| **V28** | 482 | 4811 | M453 | MOD-10 | **Rock Guarded Parade:** Snake #1 is entrapped behind crackable rock barriers. |
| **V29** | 483 | 4821 | M453 | MOD-08 | **Alternating Parade:** Strict alternating sequence between high and low badges. |
| **V30** | 484 | 4831 | M453 | MOD-09 | **Ice Slide Parade:** Egress channel leading to parade arch is completely frozen. |
| **V31** | 485 | 4841 | M453 | MOD-02 | **Cross-Corner Parade:** Diagonal exit vectors required for sequential numbers. |
| **V32** | 486 | 4851 | M453 | MOD-06 | **Even-First Parade:** Even-numbered snakes must all clear before Odd snakes begin. |
| **V33** | 487 | 4861 | M453 | MOD-01 | **Grand 5-Snake Parade:** 5 snakes strictly ordered in numerical ascension ($1 \dots 5$). |
| **V34** | 489 | 4881 | M454 | MOD-03 | **Chroma Echo:** Group B must mirror Group A across 4 distinct vibrant hues. |
| **V35** | 490 | 4891 | M454 | MOD-04 | **Strict Echo:** An out-of-order Group B attempt triggers immediate audible feedback. |
| **V36** | 491 | 4901 | M454 | MOD-07 | **Twin Echo Pairs:** Two independent dual-choir sets operating concurrently. |
| **V37** | 492 | 4911 | M454 | MOD-05 | **Rapid Echo:** Group B snakes accelerate in tempo upon Group A completion. |
| **V38** | 493 | 4921 | M454 | MOD-10 | **Muddy Echo:** Group B snakes start stuck in muddy swamps, delaying mirror response. |
| **V39** | 494 | 4931 | M454 | MOD-08 | **Inverted Echo:** Group B must evacuate in exact reverse chromatic order of Group A. |
| **V40** | 495 | 4941 | M454 | MOD-06 | **Length Matching Echo:** Group B snakes must mirror both color and segment lengths of Group A. |
| **V41** | 496 | 4951 | M454 | MOD-09 | **Ice Echo:** Echo choir must navigate slippery ice ribbons to mirror paths. |
| **V42** | 497 | 4961 | M454 | MOD-02 | **Directional Echo:** Group B departures restricted to opposite cardinal compass vector. |
| **V43** | 498 | 4971 | M454 | MOD-01 | **Cascade Echo:** 3-stage mirror hierarchy (Group A $\to$ Group B $\to$ Group C). |
| **V44** | 499 | 4981 | M454 | MOD-07 | **Master Echo Gate:** Grand temple gate unlocks only upon final echo cadence resolution. |
| **V45** | 500 | 4995 | M451 | MOD-01 | **Festival Symphony:** Master ensemble blending Drum Gate, Totem, and Parade into a unified puzzle. |

---

### 3. Generator Constraints
- **State Complexity Control:** In variants involving multi-stage echoes (V43) or 5-snake parades (V33), grid size is kept bounded ($12 \times 12$) to guarantee generator solver completion in $< 200\text{ ms}$.

## Affected Files
- `packages/puzzle_core/lib/src/variants/phase_10/` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_10_variant_generator.dart` (to be created)
- `test/variants/phase_10_variants_test.dart` (to be created)

## Risks and Open Questions
- **V39 Inverted Echo Cognitive Load:** Evacuating Group B in reverse chromatic order of Group A requires clear HUD visualization so players do not misinterpret the reversal as a bug. Addressed via the reversed arrow indicator in `phase-10-ui-additions.md`.
