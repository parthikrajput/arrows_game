Source docs: phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-4-variants-and-modifiers.md, specs/gameplay/phase-5-base-mechanics.md.

# Spec: Gameplay — Phase 5 Variants & Modifiers

## Status
Draft

## Type
Improvement (extends the variant and modifier system from `specs/gameplay/phase-4-variants-and-modifiers.md` into Phase 5 push physics mechanics)

## Goal
Implement the 45 variant slots for Phase 5 (Levels 2001–2500), combining new push physics base mechanics (M201–M204) and legacy mechanics with 10 generic modifiers, specifying slot mappings, interaction rules, and tutorial card compositions.

## Current State
Design documented in `phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md`, `SCALING_TO_10000_LEVELS.md` §7, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases applied generic modifiers to cycle gates, multi-floor stairs, and standard obstacles.
- Phase 5 applies modifiers to terrain holes, sliding ice blocks, and heavy push obstacles.

## Proposed Change
Extend `packages/puzzle_core` with Phase 5 variant definitions and modifier decorator behaviors:

### 1. 45 Variant Slots Mapping Table (Levels 2001–2500)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| **V01** | 3 | L2021 | M201 Coconut Pit | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V02** | 4 | L2031 | M201 Coconut Pit | `Colored(amber)` | `{"kind": "Colored", "color": "amber"}` |
| **V03** | 5 | L2041 | M201 Coconut Pit | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V04** | 6 | L2051 | M201 Coconut Pit | `Phasing` | `{"kind": "Phasing"}` |
| **V05** | 7 | L2061 | M201 Coconut Pit | `Armored` | `{"kind": "Armored"}` |
| **V06** | 8 | L2071 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| **V07** | 9 | L2081 | M009 Vine Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V08** | 10 | L2091 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| **V09** | 11 | L2101 | M020 Burrow | `Fogged` | `{"kind": "Fogged"}` |
| **V10** | 12 | L2111 | M053 Rolling Coconut | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| **V11** | 13 | L2121 | M151 Root Stairs | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V12** | 15 | L2141 | M202 Dew-Slick Coconut | `Colored(cyan)` | `{"kind": "Colored", "color": "cyan"}` |
| **V13** | 16 | L2151 | M202 Dew-Slick Coconut | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| **V14** | 17 | L2161 | M202 Dew-Slick Coconut | `Chained` | `{"kind": "Chained", "linkedId": "o202_b"}` |
| **V15** | 18 | L2171 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V16** | 19 | L2181 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| **V17** | 20 | L2191 | M069 Treetop Platform | `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| **V18** | 21 | L2201 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| **V19** | 22 | L2211 | M084 Sunbeam Reflector | `Mirrored` | `{"kind": "Mirrored"}` |
| **V20** | 23 | L2221 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V21** | 24 | L2231 | M090 Sun Dial Gate | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V22** | 25 | L2241 | M152 Dewglass Floor | `Fogged` | `{"kind": "Fogged"}` |
| **V23** | 27 | L2261 | M203 Key Coconut | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| **V24** | 28 | L2271 | M203 Key Coconut | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| **V25** | 29 | L2281 | M203 Key Coconut | `Chained` | `{"kind": "Chained", "linkedId": "o203_b"}` |
| **V26** | 30 | L2291 | M203 Key Coconut | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| **V27** | 31 | L2301 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| **V28** | 32 | L2311 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| **V29** | 33 | L2321 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| **V30** | 34 | L2331 | M032 Canopy Leaf | `Colored(mint)` | `{"kind": "Colored", "color": "mint"}` |
| **V31** | 35 | L2341 | M042 Fragile Vine Bridge | `Phasing` | `{"kind": "Phasing"}` |
| **V32** | 36 | L2351 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| **V33** | 37 | L2361 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| **V34** | 39 | L2381 | M204 Jackfruit Boulder | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V35** | 40 | L2391 | M204 Jackfruit Boulder | `Chained` | `{"kind": "Chained", "linkedId": "o204_b"}` |
| **V36** | 41 | L2401 | M204 Jackfruit Boulder | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V37** | 42 | L2411 | M060 Chameleon Log | `Colored(bronze)` | `{"kind": "Colored", "color": "bronze"}` |
| **V38** | 43 | L2421 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| **V39** | 44 | L2431 | M075 Creeping Moss | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| **V40** | 45 | L2441 | M082 River Rapids Belt | `Phasing` | `{"kind": "Phasing"}` |
| **V41** | 46 | L2451 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V42** | 47 | L2461 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| **V43** | 48 | L2471 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| **V44** | 49 | L2481 | M153 Knot Hole | `Chained` | `{"kind": "Chained", "linkedId": "o153_c"}` |
| **V45** | 49 | L2485 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |

### 2. Push Physics Modifier Interaction Rules
- **M201 Coconut Pit × Modifiers:**
  - `Frozen(K)`: Pit is frozen over with thick permafrost; cannot accept coconuts until $K$ adjacent snakes exit.
  - `Colored(c)`: Only accepts coconuts or snakes matching color $c$; mismatching objects treat the cell as an impermeable wall.
  - `Countdown(N)`: Pit automatically fills with earth and becomes Plain Floor after $N$ valid moves even if no coconut was pushed into it.
  - `Phasing`: Pit is active (blocking) on even move counts, but phase-shifts into walkable floor on odd move counts.
- **M202 Dew-Slick Coconut × Modifiers:**
  - `Colored(c)`: Can only be pushed by snakes matching color $c$; mismatching snakes bump and lose 1 Heart Berry.
  - `Countdown(N)`: Dew evaporates after $N$ moves, converting M202 into a standard 1-cell rolling coconut (M053).
  - `Chained`: Pushing one sliding coconut simultaneously slides its linked counterpart in the same direction.
- **M203 Key Coconut × Modifiers:**
  - `Colored(c)`: Lock matching requires both the key token and the pushing snake to match color $c$.
  - `Countdown(N)`: Key token dissolves after $N$ moves, reverting into an inert standard coconut.
  - `Frozen(K)`: Key coconut is frozen in place until $K$ adjacent snakes exit.
- **M204 Jackfruit Boulder × Modifiers:**
  - `Countdown(N)`: Boulder crumbles away into clear floor after $N$ moves.
  - `Chained`: Moving one boulder requires a coordinated double push, displacing both linked boulders simultaneously.
  - `Frozen(K)`: Boulder is encased in ice; cannot be pushed even by Giant Anaconda until thawed.

### 3. Intro-Level Constraints & Tutorial Cards
- In each `x1` variant level, the board contains ONLY the intro variant plus at most 1 earlier mechanic.
- Dynamic tutorial cards automatically combine base mechanic illustration with modifier icon badges (e.g. ice crystals for `Frozen`, hourglass for `Countdown`).

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/phase_5_variants.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_profiles/phase_5_slots.dart` (updated with V01–V45 mappings)
- `lib/features/gameplay/presentation/widgets/tutorial_card_generator.dart` (extended for Phase 5 variants)

## Risks
- Sliding physics edge cases when `Chained` Dew-Slick Coconuts slide into different length paths. Governed by rule: each chained block slides independently until its own collision occurs.

## Open Questions
- None. All 45 variant slots and modifier mappings match `phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md`.
