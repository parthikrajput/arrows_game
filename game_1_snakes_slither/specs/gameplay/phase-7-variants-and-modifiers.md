Source docs: phases/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md, phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, ../../SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-7-base-mechanics.md, specs/gameplay/phase-6-variants-and-modifiers.md.

# Spec: Gameplay — Phase 7 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and modifier integration rules for Phase 7 (Levels 3001–3500), coupling the 4 new rotation base mechanics (M301–M304) and legacy mechanics with the 10 generic modifiers.

## Current State
Design documented in `phases/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases defined variants for cycles, multi-floors, push physics, and beam optics.
- Phase 7 extends modifiers to sub-board turntables, perimeter rotating walls, and orientation-coupled gates.

## Proposed Change
Extend `packages/puzzle_core` with rotation modifier handlers and map the 45 variant slots across Blocks 3 through 49:

### 1. Modifier Rules on Rotational Mechanics

1. **`Frozen(k)`:**
   - Applied to Island Spinner (M301): The rotor turntable is locked in ice and cannot be turned until $k$ snakes have successfully exited the board.
   - Applied to Spinning Snake (M303): The snake does not auto-rotate its heading until $k$ snakes have cleared.
2. **`Countdown(n)`:**
   - Applied to Gear Lock (M304): The player must rotate the linked rotor into alignment within the first $n$ moves; otherwise the lock latches shut permanently.
3. **`Phasing`:**
   - On Even moves, the rotor is active and responsive to player taps.
   - On Odd moves, the rotor handle is inactive (locked tap; 0 moves spent).
4. **`Chained`:**
   - Two Island Spinners (M301_A and M301_B) are linked. Tapping either one rotates both 4×4 sub-grids simultaneously by 90° CW.
   - Both sub-boards must satisfy the boundary straddle invariant; if either rotor is straddled, the linked action is blocked.
5. **`Mirrored`:**
   - Two paired rotors where rotating one 90° CW causes the mirrored rotor to rotate **90° Counter-Clockwise (CCW)**.
6. **`Growing(n)`:**
   - Applied to Turning Hedges (M302): The hedge segment extends its length along the perimeter by 1 cell every $n$ moves, progressively shrinking the open exit gaps.

---

### 2. The 45 Variant Slots Mapping Table (Levels 3001–3500)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| **V01** | 3 | L3021 | M301 Island Spinner | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V02** | 4 | L3031 | M301 Island Spinner | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| **V03** | 5 | L3041 | M301 Island Spinner | `Chained` | `{"kind": "Chained", "linkedId": "o301_b"}` |
| **V04** | 6 | L3051 | M301 Island Spinner | `Mirrored` | `{"kind": "Mirrored"}` |
| **V05** | 7 | L3061 | M301 Island Spinner | `Phasing` | `{"kind": "Phasing"}` |
| **V06** | 8 | L3071 | M003 Frozen Vine | `Armored` | `{"kind": "Armored"}` |
| **V07** | 9 | L3081 | M008 Pressure Plate | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V08** | 10 | L3091 | M013 Rotating Bamboo| `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V09** | 11 | L3101 | M019 Mud Pit | `Fogged` | `{"kind": "Fogged"}` |
| **V10** | 12 | L3111 | M054 Ice Sliding Crate| `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V11** | 13 | L3121 | M202 Dew-Slick Coconut| `Chained` | `{"kind": "Chained", "linkedId": "o202_b"}` |
| **V12** | 15 | L3141 | M302 Turning Hedges | `Growing(4)` | `{"kind": "Growing", "n": 4}` |
| **V13** | 16 | L3151 | M302 Turning Hedges | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V14** | 17 | L3161 | M302 Turning Hedges | `Phasing` | `{"kind": "Phasing"}` |
| **V15** | 18 | L3171 | M057 One-Way Flap | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V16** | 19 | L3181 | M062 Termite Wall | `Armored` | `{"kind": "Armored"}` |
| **V17** | 20 | L3191 | M067 Vine Chasm | `Mirrored` | `{"kind": "Mirrored"}` |
| **V18** | 21 | L3201 | M073 Water Lily Float| `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| **V19** | 22 | L3211 | M085 Fixed Mirror | `Chained` | `{"kind": "Chained", "linkedId": "o85_b"}` |
| **V20** | 23 | L3221 | M091 Day/Night Flower| `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| **V21** | 24 | L3231 | M201 Coconut Pit | `Fogged` | `{"kind": "Fogged"}` |
| **V22** | 25 | L3241 | M251 Petal Filter | `Countdown(10)`| `{"kind": "Countdown", "n": 10}` |
| **V23** | 27 | L3261 | M303 Spinning Snake | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V24** | 28 | L3271 | M303 Spinning Snake | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| **V25** | 29 | L3281 | M303 Spinning Snake | `Chained` | `{"kind": "Chained", "linkedId": "p_spin_b"}` |
| **V26** | 30 | L3291 | M303 Spinning Snake | `Armored` | `{"kind": "Armored"}` |
| **V27** | 31 | L3301 | M002 Hollow Trunk | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| **V28** | 32 | L3311 | M010 Jungle Mist | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| **V29** | 33 | L3321 | M018 Leaf Dam | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V30** | 34 | L3331 | M030 Boulder Drop | `Mirrored` | `{"kind": "Mirrored"}` |
| **V31** | 35 | L3341 | M040 Bramble Snare | `Phasing` | `{"kind": "Phasing"}` |
| **V32** | 36 | L3351 | M078 Current Vortex | `Chained` | `{"kind": "Chained", "linkedId": "o78_b"}` |
| **V33** | 37 | L3361 | M252 Prism Lock | `Countdown(12)`| `{"kind": "Countdown", "n": 12}` |
| **V34** | 39 | L3381 | M304 Gear Lock | `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| **V35** | 40 | L3391 | M304 Gear Lock | `Countdown(15)`| `{"kind": "Countdown", "n": 15}` |
| **V36** | 41 | L3401 | M304 Gear Lock | `Phasing` | `{"kind": "Phasing"}` |
| **V37** | 42 | L3411 | M304 Gear Lock | `Armored` | `{"kind": "Armored"}` |
| **V38** | 43 | L3421 | M012 Thorn Barrier | `Mirrored` | `{"kind": "Mirrored"}` |
| **V39** | 44 | L3431 | M022 Spider Web | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V40** | 45 | L3441 | M047 Quicksand | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V41** | 46 | L3451 | M065 Vine Bridge | `Fogged` | `{"kind": "Fogged"}` |
| **V42** | 47 | L3461 | M087 Solar Receptor | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V43** | 48 | L3471 | M204 Jackfruit Boulder| `Colored(amber)`| `{"kind": "Colored", "color": "amber"}` |
| **V44** | 49 | L3481 | M253 Sundial Receiver | `Chained` | `{"kind": "Chained", "linkedId": "o253_b"}` |
| **V45** | 49 | L3485 | M301 Island Spinner | `Growing(2)` | `{"kind": "Growing", "n": 2}` |

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/rotation_modifier_handler.dart` — to be created
- `packages/puzzle_core/lib/src/generator/variant_slot_mapper.dart` — changed

## Risks and Open Questions
- **Dual Chained Rotor Straddles:** If two rotors are chained together, a straddling snake on either rotor blocks the entire dual action.
  - *Feedback:* UI highlights both rotors in yellow with an alert badge indicating which snake is causing the straddle lock.

