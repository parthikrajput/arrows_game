# Spec: Phase 12 Variants and Modifiers — Falling Leaves (45 Slots)

Source docs: phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-12-base-mechanics.md, specs/gameplay/phase-12-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 Variants and Modifiers — Falling Leaves (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Define the 45 variant slots for Phase 12, combining Falling Leaves mechanics (M551–M554) and prior-phase mechanics with the 10 standard modifiers across levels L5521–L5981.

---

## Current State

Design documented in `phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md`, not yet implemented.

---

## Proposed Change

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L5521 | Frozen Wind-Vane Lever | M551 | `Frozen(2)` |
| 4 | L5531 | Colored Wind-Vane Lever | M551 | `Colored(Amber)` |
| 5 | L5541 | Fogged Wind-Vane Lever | M551 | `Fogged` |
| 6 | L5551 | Chained Wind-Vane Levers | M551 | `Chained` |
| 7 | L5561 | Countdown Wind-Vane Lever | M551 | `Countdown(8)` |
| 8 | L5571 | Phasing Wind-Vane Lever | M551 | `Phasing` |
| 9 | L5581 | Mirrored Wind-Vane Lever | M551 | `Mirrored` |
| 10 | L5591 | Armored Wind-Vane Lever | M551 | `Armored` |
| 11 | L5601 | Growing Bramble Patch | M002 | `Growing(4)` |
| 12 | L5611 | Layered Wind-Vane Lever | M551 | `Layered(ground)` |
| 13 | L5621 | Frozen Falling Acorns | M552 | `Frozen(2)` |
| 15 | L5641 | Colored Falling Acorns | M552 | `Colored(Brown)` |
| 16 | L5651 | Fogged Falling Acorns | M552 | `Fogged` |
| 17 | L5661 | Chained Falling Acorns | M552 | `Chained` |
| 18 | L5671 | Phasing Cricket Gate | M451 | `Phasing` |
| 19 | L5681 | Countdown Falling Acorns | M552 | `Countdown(10)` |
| 20 | L5691 | Mirrored Falling Acorns | M552 | `Mirrored` |
| 21 | L5701 | Armored Falling Acorns | M552 | `Armored` |
| 22 | L5711 | Layered Falling Acorns | M552 | `Layered(air)` |
| 23 | L5721 | Growing Ivy Tangle | M074 | `Growing(3)` |
| 24 | L5731 | Frozen Dandelion Puff Tile | M553 | `Frozen(1)` |
| 25 | L5741 | Colored Dandelion Puff Tile | M553 | `Colored(White)` |
| 27 | L5761 | Fogged Dandelion Puff Tile | M553 | `Fogged` |
| 28 | L5771 | Chained Dandelion Puff Tiles | M553 | `Chained` |
| 29 | L5781 | Countdown Dandelion Puff Tile | M553 | `Countdown(7)` |
| 30 | L5791 | Phasing Fork Twig | M402 | `Phasing` |
| 31 | L5801 | Mirrored Dandelion Puff Tile | M553 | `Mirrored` |
| 32 | L5811 | Armored Bead-String Lock | M452 | `Armored` |
| 33 | L5821 | Layered Dandelion Puff Tile | M553 | `Layered(canopy)` |
| 34 | L5831 | Frozen Heavy Beetle Line | M554 | `Frozen(3)` |
| 35 | L5841 | Growing Moss Spores | M027 | `Growing(5)` |
| 36 | L5851 | Colored Heavy Beetle Line | M554 | `Colored(Black)` |
| 37 | L5861 | Countdown Heavy Beetle Line | M554 | `Countdown(12)` |
| 39 | L5881 | Fogged Heavy Beetle Line | M554 | `Fogged` |
| 40 | L5891 | Chained Heavy Beetle Lines | M554 | `Chained` |
| 41 | L5901 | Phasing Heavy Beetle Line | M554 | `Phasing` |
| 42 | L5911 | Mirrored Heavy Beetle Line | M554 | `Mirrored` |
| 43 | L5921 | Armored Garden Gate Link | M501 | `Armored` |
| 44 | L5931 | Layered Heavy Beetle Line | M554 | `Layered(ground)` |
| 45 | L5941 | Growing Hedge Wall | M071 | `Growing(4)` |
| 46 | L5951 | Colored Turntable | M301 | `Colored(Gold)` |
| 47 | L5961 | Countdown Shears | M352 | `Countdown(9)` |
| 48 | L5971 | Phasing Honey Merge Pad | M401 | `Phasing` |
| 49 | L5981 | Chained Honeycomb Arch | M005 | `Chained` |

**Total variant slots: 45**

---

### Prior-Phase Integrations
- M002, M005 (Phase 1)
- M027, M071, M074 (Phase 2)
- M301 (Phase 7)
- M352 (Phase 8)
- M401, M402 (Phase 9)
- M451, M452 (Phase 10)
- M501 (Phase 11)

---

## Acceptance Criteria
- [ ] Unique tutorial dialogue card shown on first encounter with each of the 45 variants.
- [ ] `Frozen(K)` Falling Acorn does not shift with gravity until thawed.
- [ ] `Armored` Falling Acorn requires two impacts or double clear to remove.
- [ ] `Countdown(N)` Lever automatically shifts gravity vector upon counter reaching 0.
- [ ] All 45 variant levels verified solvable by automated CI solver.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed |
| `assets/phase_12/variants/` | To be created |

---

## Risks and Open Questions

1. **Countdown Gravity Lever (M551 × Countdown):** When countdown expires, automatic gravity shift occurs before player's next move. Settlement order must process before player can tap new lines.
