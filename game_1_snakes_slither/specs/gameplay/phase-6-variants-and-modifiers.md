Source docs: phases/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md, phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, ../../SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-6-base-mechanics.md, specs/gameplay/phase-5-variants-and-modifiers.md.

# Spec: Gameplay — Phase 6 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and modifier integration rules for Phase 6 (Levels 2501–3000), coupling the 4 new optics base mechanics (M251–M254) and key legacy mechanics with the 10 generic modifiers.

## Current State
Design documented in `phases/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases defined variants for cycles, multi-floors, and push physics.
- Phase 6 extends modifiers to beam optics, chromatic filters, prism locks, and timed sundials.

## Proposed Change
Extend `packages/puzzle_core` with optics modifier handlers and validate the 45 variant slots across Blocks 3 through 49:

### 1. Modifier Rules on Optics Mechanics

1. **`Frozen(k)`:**
   - **Applied to Mirrors/Filters:** The mirror or filter is encased in ice and cannot rotate or transmit rays until $k$ snakes have successfully exited the board.
   - **Applied to Sundials:** The sundial cannot begin its countdown until $k$ snakes have cleared.
2. **`Colored(color)`:**
   - Explicitly locks the mechanic's target wavelength (e.g. `Ruby`, `Cyan`, `Emerald`, `Gold`, `Violet`).
   - Only light rays matching the exact designated color can trigger the receiver.
3. **`Countdown(n)`:**
   - The player must achieve the required beam illumination condition within the first $n$ moves of the attempt.
   - If move count exceeds $n$ before activation, the target locks shut and causes an unresolvable board state (handled by restart / undo).
4. **`Phasing`:**
   - On Even moves ($0, 2, 4\dots$), the filter/prism is active and permeable to light.
   - On Odd moves ($1, 3, 5\dots$), the filter phases out of reality, allowing sunlight to pass through unfiltered.
5. **`Armored`:**
   - Requires an extra pre-requisite hit or dual beam activation before normal functioning.
6. **`Chained`:**
   - Two optical gates or receivers are linked via `linkedId`. Activating one triggers both simultaneously.
7. **`Mirrored`:**
   - An optical component whose state or angle mirrors a paired component across the board's symmetry axis.

---

### 2. The 45 Variant Slots Mapping Table (Levels 2501–3000)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| **V01** | 3 | L2521 | M251 Petal Filter | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V02** | 4 | L2531 | M251 Petal Filter | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| **V03** | 5 | L2541 | M251 Petal Filter | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| **V04** | 6 | L2551 | M251 Petal Filter | `Phasing` | `{"kind": "Phasing"}` |
| **V05** | 7 | L2561 | M251 Petal Filter | `Armored` | `{"kind": "Armored"}` |
| **V06** | 8 | L2571 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| **V07** | 9 | L2581 | M009 Vine Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V08** | 10 | L2591 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| **V09** | 11 | L2601 | M020 Burrow | `Fogged` | `{"kind": "Fogged"}` |
| **V10** | 12 | L2611 | M053 Rolling Coconut | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V11** | 13 | L2621 | M201 Coconut Pit | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V12** | 15 | L2641 | M252 Prism Lock | `Colored(cyan)` | `{"kind": "Colored", "color": "cyan"}` |
| **V13** | 16 | L2651 | M252 Prism Lock | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| **V14** | 17 | L2661 | M252 Prism Lock | `Chained` | `{"kind": "Chained", "linkedId": "o252_b"}` |
| **V15** | 18 | L2671 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V16** | 19 | L2681 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| **V17** | 20 | L2691 | M069 Treetop Platform| `Colored(emerald)`| `{"kind": "Colored", "color": "emerald"}` |
| **V18** | 21 | L2701 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| **V19** | 22 | L2711 | M084 Sunbeam Reflector| `Mirrored` | `{"kind": "Mirrored"}` |
| **V20** | 23 | L2721 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V21** | 24 | L2731 | M090 Sun Dial Gate | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| **V22** | 25 | L2741 | M202 Dew-Slick Coconut| `Fogged` | `{"kind": "Fogged"}` |
| **V23** | 27 | L2761 | M253 Sundial Receiver | `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| **V24** | 28 | L2771 | M253 Sundial Receiver | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| **V25** | 29 | L2781 | M253 Sundial Receiver | `Chained` | `{"kind": "Chained", "linkedId": "o253_b"}` |
| **V26** | 30 | L2791 | M253 Sundial Receiver | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| **V27** | 31 | L2801 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| **V28** | 32 | L2811 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| **V29** | 33 | L2821 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| **V30** | 34 | L2831 | M032 Canopy Leaf | `Colored(violet)` | `{"kind": "Colored", "color": "violet"}` |
| **V31** | 35 | L2841 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| **V32** | 36 | L2851 | M077 River Raft | `Chained` | `{"kind": "Chained", "linkedId": "o77_b"}` |
| **V33** | 37 | L2861 | M204 Jackfruit Boulder| `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| **V34** | 39 | L2881 | M254 Shade Leaves | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| **V35** | 40 | L2891 | M254 Shade Leaves | `Countdown(12)` | `{"kind": "Countdown", "n": 12}` |
| **V36** | 41 | L2901 | M254 Shade Leaves | `Phasing` | `{"kind": "Phasing"}` |
| **V37** | 42 | L2911 | M254 Shade Leaves | `Armored` | `{"kind": "Armored"}` |
| **V38** | 43 | L2921 | M011 Log Roller | `Mirrored` | `{"kind": "Mirrored"}` |
| **V39** | 44 | L2931 | M016 Bamboo Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| **V40** | 45 | L2941 | M039 Thorn Trap | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| **V41** | 46 | L2951 | M061 Termite Mound | `Fogged` | `{"kind": "Fogged"}` |
| **V42** | 47 | L2961 | M085 Fixed Mirror | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| **V43** | 48 | L2971 | M088 Prism Splitter | `Colored(emerald)`| `{"kind": "Colored", "color": "emerald"}` |
| **V44** | 49 | L2981 | M203 Key Coconut | `Chained` | `{"kind": "Chained", "linkedId": "o203_b"}` |
| **V45** | 49 | L2985 | M252 Prism Lock | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/optics_modifier_handler.dart` — to be created
- `packages/puzzle_core/lib/src/generator/variant_slot_mapper.dart` — changed

## Risks and Open Questions
- **Modifier Stacking Complexity:** Combining `Phasing` with `Countdown` on a beam receiver could cause solver node explosion.
  - *Guardrail:* Generator limits variant combinations to exactly 1 modifier per mechanic instance per level.

