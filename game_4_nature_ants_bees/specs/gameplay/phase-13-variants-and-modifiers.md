# Spec: Phase 13 Variants and Modifiers — Mystery Meadow (45 Slots)

Source docs: phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-13-base-mechanics.md, specs/gameplay/phase-13-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 Variants and Modifiers — Mystery Meadow (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define the 45 variant slots for Phase 13, combining Mystery Meadow mechanics (M601–M604) and prior-phase mechanics with the 10 standard modifiers across levels L6021–L6481.

---

## Current State

Design documented in `phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md`, not yet implemented.

---

## Proposed Change

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L6021 | Frozen Scout Ant | M601 | `Frozen(2)` |
| 4 | L6031 | Colored Scout Ant | M601 | `Colored(Yellow)` |
| 5 | L6041 | Fogged Scout Ant | M601 | `Fogged` |
| 6 | L6051 | Chained Scout Ants | M601 | `Chained` |
| 7 | L6061 | Countdown Scout Ant | M601 | `Countdown(8)` |
| 8 | L6071 | Phasing Scout Ant | M601 | `Phasing` |
| 9 | L6081 | Mirrored Scout Ant | M601 | `Mirrored` |
| 10 | L6091 | Armored Scout Ant | M601 | `Armored` |
| 11 | L6101 | Growing Bramble Patch | M002 | `Growing(4)` |
| 12 | L6111 | Layered Scout Ant | M601 | `Layered(ground)` |
| 13 | L6121 | Frozen Mirage Mist | M602 | `Frozen(2)` |
| 15 | L6141 | Colored Mirage Mist | M602 | `Colored(White)` |
| 16 | L6151 | Fogged Mirage Mist | M602 | `Fogged` |
| 17 | L6161 | Chained Mirage Mists | M602 | `Chained` |
| 18 | L6171 | Phasing Wind-Vane Lever | M551 | `Phasing` |
| 19 | L6181 | Countdown Mirage Mist | M602 | `Countdown(10)` |
| 20 | L6191 | Mirrored Mirage Mist | M602 | `Mirrored` |
| 21 | L6201 | Armored Mirage Mist | M602 | `Armored` |
| 22 | L6211 | Layered Mirage Mist | M602 | `Layered(air)` |
| 23 | L6221 | Growing Ivy Tangle | M074 | `Growing(3)` |
| 24 | L6231 | Frozen Painted Pebble | M603 | `Frozen(1)` |
| 25 | L6241 | Colored Painted Pebble | M603 | `Colored(Blue)` |
| 27 | L6261 | Fogged Painted Pebble | M603 | `Fogged` |
| 28 | L6271 | Chained Painted Pebbles | M603 | `Chained` |
| 29 | L6281 | Countdown Painted Pebble | M603 | `Countdown(7)` |
| 30 | L6291 | Phasing Falling Acorns | M552 | `Phasing` |
| 31 | L6301 | Mirrored Painted Pebble | M603 | `Mirrored` |
| 32 | L6311 | Armored Cricket Gate | M451 | `Armored` |
| 33 | L6321 | Layered Painted Pebble | M603 | `Layered(canopy)` |
| 34 | L6331 | Frozen Sunlit Plate | M604 | `Frozen(3)` |
| 35 | L6341 | Growing Moss Spores | M027 | `Growing(5)` |
| 36 | L6351 | Colored Sunlit Plate | M604 | `Colored(Gold)` |
| 37 | L6361 | Countdown Sunlit Plate | M604 | `Countdown(12)` |
| 39 | L6381 | Fogged Sunlit Plate | M604 | `Fogged` |
| 40 | L6391 | Chained Sunlit Plates | M604 | `Chained` |
| 41 | L6401 | Phasing Sunlit Plate | M604 | `Phasing` |
| 42 | L6411 | Mirrored Sunlit Plate | M604 | `Mirrored` |
| 43 | L6421 | Armored Garden Gate Link | M501 | `Armored` |
| 44 | L6431 | Layered Sunlit Plate | M604 | `Layered(ground)` |
| 45 | L6441 | Growing Hedge Wall | M071 | `Growing(4)` |
| 46 | L6451 | Colored Pen-Pal Key | M502 | `Colored(Amber)` |
| 47 | L6461 | Countdown Bead-String Lock | M452 | `Countdown(9)` |
| 48 | L6471 | Phasing Fork Twig | M402 | `Phasing` |
| 49 | L6481 | Chained Honeycomb Arch | M005 | `Chained` |

**Total variant slots: 45**

---

### Cross-Phase Integrations
- M002, M005 (Phase 1)
- M027, M071, M074 (Phase 2)
- M402 (Phase 9)
- M451, M452 (Phase 10)
- M501, M502 (Phase 11)
- M551, M552 (Phase 12)

---

## Acceptance Criteria
- [ ] Unique intro tutorial dialog presented for all 45 variant configurations.
- [ ] `Armored Painted Pebble` requires two traversals to crumble completely.
- [ ] `Chained Mirage Mists` trigger simultaneous 3×3 fog bursts when either is passed.
- [ ] `Phasing Sunlit Plate` alternates active illumination on alternating player moves.
- [ ] All 45 variant slots verified solvable by CI solver.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed |
| `assets/phase_13/variants/` | To be created |

---

## Risks and Open Questions

1. **Fogged Scout Ant (M601 × Fogged):** A Scout Ant that is itself shrouded under fog cannot be tapped until revealed by another mechanism (e.g. Sunlit Plate or proximity). Generator must ensure a visible starter scout is present.
