Source docs: phases/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md, phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, ../../SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-8-base-mechanics.md, specs/gameplay/phase-7-variants-and-modifiers.md.

# Spec: Gameplay — Phase 8 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and modifier integration rules for Phase 8 (Levels 3501–4000), coupling the 4 new growth base mechanics (M351–M354) and legacy mechanics with the 10 generic modifiers.

## Current State
Design documented in `phases/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases covered cycles, multi-floors, push physics, optics, and rotations.
- Phase 8 extends modifiers to dynamic plant sprawl, pruning radius alteration, and seed dormancy.

## Proposed Change
Extend `packages/puzzle_core` with growth modifier handlers and map the 45 variant slots across Blocks 3 through 49:

### 1. Modifier Rules on Growth Mechanics

1. **`Frozen(k)`:**
   - Applied to Pruning Shears Tile (M352): The shears are frozen in ice and will not trigger a pruning pulse until $k$ snakes have cleared the board.
   - Applied to Wild Vine (M351): The vine is dormant and will not begin its spread counter until $k$ snakes exit.
2. **`Countdown(n)`:**
   - Applied to Bloom Gate (M354): All linked vines must be eradicated within the first $n$ moves; otherwise the gate petrifies and remains permanently locked.
3. **`Phasing`:**
   - Applied to Wild Vine (M351): On Even moves, the vine is solid and blocking. On Odd moves, the vine blossoms and becomes passable floor.
4. **`Armored`:**
   - Applied to Wild Vine (M351): Requires 2 pruning pulses or 2 hammer hits to fully uproot.
5. **`Growing(n)`:**
   - Accelerated sprawl: Vine expands every $n$ moves (e.g. $n = 2$ instead of normal 3).
6. **`Chained`:**
   - Two Bloom Gates (M354_A and M354_B) linked together. Both open only when all vines across both linked gardens are eradicated.

---

### 2. The 45 Variant Slots Mapping Table (Levels 3501–4000)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| **V01** | 3 | L3521 | M351 Wild Vine | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| **V02** | 4 | L3531 | M351 Wild Vine | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V03** | 5 | L3541 | M351 Wild Vine | `Phasing` | `{"kind": "Phasing"}` |
| **V04** | 6 | L3551 | M351 Wild Vine | `Armored` | `{"kind": "Armored"}` |
| **V05** | 7 | L3561 | M351 Wild Vine | `Countdown(12)` | `{"kind": "Countdown", "n": 12}` |
| **V06** | 8 | L3571 | M005 Thorn Bush | `Chained` | `{"kind": "Chained", "linkedId": "o05_b"}` |
| **V07** | 9 | L3581 | M011 Log Roller | `Mirrored` | `{"kind": "Mirrored"}` |
| **V08** | 10 | L3591 | M017 Stone Gate | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V09** | 11 | L3601 | M024 Firefly Lantern | `Fogged` | `{"kind": "Fogged"}` |
| **V10** | 12 | L3611 | M055 Coconut Sump | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V11** | 13 | L3621 | M251 Petal Filter | `Colored(emerald)`| `{"kind": "Colored", "color": "emerald"}` |
| **V12** | 15 | L3641 | M352 Pruner Tile | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V13** | 16 | L3651 | M352 Pruner Tile | `Chained` | `{"kind": "Chained", "linkedId": "o352_b"}` |
| **V14** | 17 | L3661 | M352 Pruner Tile | `Phasing` | `{"kind": "Phasing"}` |
| **V15** | 18 | L3671 | M056 Spring Mushroom | `Armored` | `{"kind": "Armored"}` |
| **V16** | 19 | L3681 | M064 Mud Geyser | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V17** | 20 | L3691 | M071 Tree Canopy | `Mirrored` | `{"kind": "Mirrored"}` |
| **V18** | 21 | L3701 | M086 Crystal Prism | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| **V19** | 22 | L3711 | M203 Key Coconut | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| **V20** | 23 | L3721 | M252 Prism Lock | `Countdown(10)`| `{"kind": "Countdown", "n": 10}` |
| **V21** | 24 | L3731 | M301 Island Spinner | `Chained` | `{"kind": "Chained", "linkedId": "o301_b"}` |
| **V22** | 25 | L3741 | M302 Turning Hedges | `Fogged` | `{"kind": "Fogged"}` |
| **V23** | 27 | L3761 | M353 Seed-Carrier Snake| `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V24** | 28 | L3771 | M353 Seed-Carrier Snake| `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V25** | 29 | L3781 | M353 Seed-Carrier Snake| `Armored` | `{"kind": "Armored"}` |
| **V26** | 30 | L3791 | M353 Seed-Carrier Snake| `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| **V27** | 31 | L3801 | M006 Hollow Stump | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| **V28** | 32 | L3811 | M015 Bamboo Shoot | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| **V29** | 33 | L3821 | M021 Phasing Ghost | `Mirrored` | `{"kind": "Mirrored"}` |
| **V30** | 34 | L3831 | M035 Spider Sentry | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V31** | 35 | L3841 | M044 Petal Bridge | `Phasing` | `{"kind": "Phasing"}` |
| **V32** | 36 | L3851 | M204 Jackfruit Boulder| `Armored` | `{"kind": "Armored"}` |
| **V33** | 37 | L3861 | M254 Shade Leaves | `Countdown(14)`| `{"kind": "Countdown", "n": 14}` |
| **V34** | 39 | L3881 | M354 Bloom Gate | `Countdown(15)`| `{"kind": "Countdown", "n": 15}` |
| **V35** | 40 | L3891 | M354 Bloom Gate | `Chained` | `{"kind": "Chained", "linkedId": "o354_b"}` |
| **V36** | 41 | L3901 | M354 Bloom Gate | `Phasing` | `{"kind": "Phasing"}` |
| **V37** | 42 | L3911 | M354 Bloom Gate | `Armored` | `{"kind": "Armored"}` |
| **V38** | 43 | L3921 | M023 Ancient Totem | `Mirrored` | `{"kind": "Mirrored"}` |
| **V39** | 44 | L3931 | M027 Bamboo Trap | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V40** | 45 | L3941 | M059 River Whirlpool| `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V41** | 46 | L3951 | M088 Prism Splitter | `Fogged` | `{"kind": "Fogged"}` |
| **V42** | 47 | L3961 | M202 Dew-Slick Coconut| `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V43** | 48 | L3971 | M253 Sundial Receiver | `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| **V44** | 49 | L3981 | M303 Spinning Snake | `Chained` | `{"kind": "Chained", "linkedId": "p_spin_b"}` |
| **V45** | 49 | L3985 | M351 Wild Vine | `Growing(2)` | `{"kind": "Growing", "n": 2}` |

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/growth_modifier_handler.dart` — to be created
- `packages/puzzle_core/lib/src/generator/variant_slot_mapper.dart` — changed

## Risks and Open Questions
- None. Cleanly separated.

