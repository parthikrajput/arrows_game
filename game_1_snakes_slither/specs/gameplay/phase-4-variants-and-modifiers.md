Source docs: phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-3-variants-and-modifiers.md, specs/gameplay/phase-4-base-mechanics.md.

# Spec: Gameplay — Phase 4 Variants & Modifiers

## Status
Draft

## Type
Improvement (extends the variant and modifier system from `specs/gameplay/phase-3-variants-and-modifiers.md` into Phase 4 multi-floor mechanics)

## Goal
Implement the 45 variant slots for Phase 4 (Levels 1501–2000), combining new multi-floor base mechanics (M151–M154) and legacy mechanics with 10 generic modifiers, specifying slot mappings, interaction rules, and tutorial card compositions.

## Current State
Design documented in `phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md`, `SCALING_TO_10000_LEVELS.md` §7, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 3 established the modifier decorator pattern and defined the first 45 variant slots across Levels 1001–1500.
- Phase 4 expands this architecture into vertical dimensions with multi-floor obstacles.

## Proposed Change
Extend `packages/puzzle_core` with Phase 4 variant definitions and modifier decorator behaviors:

### 1. 45 Variant Slots Mapping Table (Levels 1501–2000)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| **V01** | 3 | L1521 | M151 Root Stairs | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V02** | 4 | L1531 | M151 Root Stairs | `Colored(blue)` | `{"kind": "Colored", "color": "blue"}` |
| **V03** | 5 | L1541 | M151 Root Stairs | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V04** | 6 | L1551 | M151 Root Stairs | `Phasing` | `{"kind": "Phasing"}` |
| **V05** | 7 | L1561 | M151 Root Stairs | `Armored` | `{"kind": "Armored"}` |
| **V06** | 8 | L1571 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| **V07** | 9 | L1581 | M010 Jungle Mist | `Fogged` | `{"kind": "Fogged"}` |
| **V08** | 10 | L1591 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| **V09** | 11 | L1601 | M020 Burrow | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V10** | 12 | L1611 | M053 Rolling Coconut | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V11** | 13 | L1621 | M101 Sun-Moon Gate | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V12** | 15 | L1641 | M152 Dewglass Floor | `Colored(green)` | `{"kind": "Colored", "color": "green"}` |
| **V13** | 16 | L1651 | M152 Dewglass Floor | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| **V14** | 17 | L1661 | M152 Dewglass Floor | `Chained` | `{"kind": "Chained", "linkedId": "o152_b"}` |
| **V15** | 18 | L1671 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V16** | 19 | L1681 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| **V17** | 20 | L1691 | M069 Treetop Platform | `Colored(orange)` | `{"kind": "Colored", "color": "orange"}` |
| **V18** | 21 | L1701 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| **V19** | 22 | L1711 | M084 Sunbeam Reflector | `Mirrored` | `{"kind": "Mirrored"}` |
| **V20** | 23 | L1721 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V21** | 24 | L1731 | M090 Sun Dial Gate | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| **V22** | 25 | L1741 | M102 Moonlight Bridge | `Fogged` | `{"kind": "Fogged"}` |
| **V23** | 27 | L1761 | M153 Knot Hole | `Colored(purple)` | `{"kind": "Colored", "color": "purple"}` |
| **V24** | 28 | L1771 | M153 Knot Hole | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| **V25** | 29 | L1781 | M153 Knot Hole | `Chained` | `{"kind": "Chained", "linkedId": "o153_b"}` |
| **V26** | 30 | L1791 | M153 Knot Hole | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| **V27** | 31 | L1801 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| **V28** | 32 | L1811 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| **V29** | 33 | L1821 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| **V30** | 34 | L1831 | M032 Canopy Leaf | `Colored(yellow)` | `{"kind": "Colored", "color": "yellow"}` |
| **V31** | 35 | L1841 | M042 Fragile Vine Bridge | `Phasing` | `{"kind": "Phasing"}` |
| **V32** | 36 | L1851 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| **V33** | 37 | L1861 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| **V34** | 39 | L1881 | M154 Vine Lift | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V35** | 40 | L1891 | M154 Vine Lift | `Chained` | `{"kind": "Chained", "linkedId": "o154_b"}` |
| **V36** | 41 | L1901 | M154 Vine Lift | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V37** | 42 | L1911 | M060 Chameleon Log | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| **V38** | 43 | L1921 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| **V39** | 44 | L1931 | M075 Creeping Moss | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V40** | 45 | L1941 | M082 River Rapids Belt | `Phasing` | `{"kind": "Phasing"}` |
| **V41** | 46 | L1951 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V42** | 47 | L1961 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| **V43** | 48 | L1971 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| **V44** | 49 | L1981 | M103 Day-Night Burrows | `Chained` | `{"kind": "Chained", "linkedId": "o103_c"}` |
| **V45** | 49 | L1985 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |

### 2. Multi-Floor Modifier Interaction Rules
- **M151 Root Stairs × Modifiers:**
  - `Frozen(K)`: Stairs are encased in frost and act as solid blocker walls until $K$ adjacent snakes exit on either floor.
  - `Colored(c)`: Only snakes matching color $c$ can ascend/descend; snakes of other colors bump and lose 1 Heart.
  - `Countdown(N)`: Stairs function for $N$ valid moves, then decay into open void/unlinked cells.
  - `Phasing`: Stairs are traversable only on even move counts ($moveCount \% 2 == 0$); on odd moves, entry cell behaves as solid blocker.
- **M152 Dewglass Floor × Modifiers:**
  - `Colored(c)`: Dewglass provides transparency and non-blocking traversal only for snakes of color $c$; other colors treat it as opaque solid floor.
  - `Countdown(N)`: Crystal glass clouds over and becomes standard opaque floor after $N$ moves.
  - `Chained`: Two glass tiles on different floors share visibility states.
- **M153 Knot Hole × Modifiers:**
  - `Colored(c)`: Gravity drop only accepts snakes matching color $c$.
  - `Countdown(N)`: Knot hole seals permanently after $N$ moves.
  - `Frozen(K)`: Hole is iced over until $K$ adjacent snakes exit.
- **M154 Vine Lift × Modifiers:**
  - `Countdown(N)`: Lift operates for $N$ total activations before becoming immobile.
  - `Chained`: Tapping one lift moves both linked lifts simultaneously across floors.
  - `Frozen(K)`: Lift lever is frozen; tap produces Locked Tap until thawed.

### 3. Intro-Level Constraints & Tutorial Cards
- In each `x1` variant level, the board contains ONLY the intro variant plus at most 1 earlier mechanic.
- Dynamic tutorial cards automatically combine base mechanic illustration with modifier icon badges (e.g. ice crystals for `Frozen`, hourglass for `Countdown`).

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/phase_4_variants.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_profiles/phase_4_slots.dart` (updated with V01–V45 mappings)
- `lib/features/gameplay/presentation/widgets/tutorial_card_generator.dart` (extended for Phase 4 variants)

## Risks
- Unexpected behavior when `Chained` modifier operates across different floors. Solved by decoupling floor index from chained trigger dispatching.

## Open Questions
- None. All 45 variant slots and modifier mappings match `phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md`.
