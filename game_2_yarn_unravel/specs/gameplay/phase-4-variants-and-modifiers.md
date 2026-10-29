Source docs: phase/phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md, ../../SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-4-base-mechanics.md, specs/gameplay/phase-3-variants-and-modifiers.md.

# Spec: Gameplay — Phase 4 Variants & Multi-Floor Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and modifier integrations for Yarn Unravel Phase 4 (Levels 1501–2000), detailing how base mechanics M151–M154 are wrapped by the 10 standardized craft modifiers across multi-floor puzzle architectures.

## Current State
Design documented in `phase/phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md` and `SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Phase 3 applied modifiers to cyclic mechanics.
- Phase 4 adapts the modifier library to vertical transportation, floor transparency, and drop-hole mechanics.

## Proposed Change
Extend the modifier pipeline for multi-floor entities:

### 1. Multi-Floor Modifier Integrations
The 10 standard craft modifiers wrap Phase 4 base mechanics:
1. **Knotted (`Frozen(K)`):** Spiral Spool Stair (M151) or Bobbin Lift (M154) is blocked by tangled yarn knots until $K$ adjacent threads unravel.
2. **Dyed (`Colored(c)`):** Spiral Spool Stair or Drop Hole accepts only threads matching yarn color $c$.
3. **Fluffed (`Fogged`):** Organza Floor (M152) or Drop Hole is concealed beneath wool fluff; revealed when an adjacent thread clears.
4. **Ribbon-Tied (`Chained`):** Paired Bobbin Lifts linked with silk ribbon; operating one lift automatically moves the linked lift on the opposite floor.
5. **Basting (`Countdown(N)`):** Stair or lift active for $N$ total traversals before locking permanently.
6. **Sheer Silk (`Phasing`):** Drop Hole or Organza section that alternates between solid and open states on odd/even moves.
7. **Thimble-Reinforced (`Armored`):** Heavy reinforced lift gate requiring 2 interactive taps to operate.
8. **Multi-Layer (`Layered`):** Stair or organza section restricted to specific fabric layers.
9. **Reflected (`Mirrored`):** Twinned stairs positioned symmetrically across the board.
10. **Knit-Expanding (`Growing`):** Creeping yarn growth that threatens to obstruct floor elevator shafts.

### 2. 45 Variant Slot Distribution (Blocks 3–49)
- **M151 Spiral Spool Stair Variants (Blocks 3–13, L1521–L1630):**
  - Sequentially combines M151 with Knotted (L1521), Dyed (L1531), Fluffed (L1541), Ribbon-Tied (L1551), Basting (L1561), Sheer Silk (L1571), Thimble-Reinforced (L1581), Multi-Layer (L1591), Reflected (L1601), Knit-Expanding (L1611), and Multi-Combo (L1621).
- **M152 Organza Floor Variants (Blocks 15–25, L1641–L1750):**
  - M152 paired with Dyed organza (L1651), Fluffed organza (L1661), Phasing organza (L1691), and Multi-Layer stacks (L1711).
- **M153 Drop Hole Variants (Blocks 27–37, L1761–L1870):**
  - Drop Holes wrapped with Knotted constraints (L1761), Color-filtered chutes (L1771), and Countdown timers (L1801).
- **M154 Bobbin Lift Variants & System Ramp (Blocks 39–49, L1881–L1990):**
  - Lift paired with Ribbon linkages (L1881), Basting countdowns (L1901), followed by cross-mechanic fusions: M151 + M152 (L1941), M151 + M153 (L1961), M152 + M154 (L1981).

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/multi_floor_decorators.dart` (to be created)
- `packages/puzzle_core/test/modifiers/phase_4_variants_test.dart` (to be created)

## Risks
- Color-filtered stairs (Dyed M151) creating impossible deadlocks if all threads of matching color have already exited. Mitigated by CI solver enforcing zero-heart solvability.

## Open Questions
None. Variant distribution matches Phase 4 documentation.
