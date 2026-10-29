# Spec: Phase 16 Variants and Modifiers — Royal Keyring (45 Slots)

Source docs: phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-16-base-mechanics.md, specs/gameplay/phase-16-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 Variants and Modifiers — Royal Keyring (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define the 45 variant slots for Phase 16, combining Royal Keyring mechanics (M751–M754) and prior-phase mechanics with the 10 standard modifiers across levels L7521–L7981.

---

## Current State

Design documented in `phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md`, not yet implemented.

---

## Proposed Change

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L7521 | Frozen Dew Key Chain | M751 | `Frozen(2)` |
| 4 | L7531 | Colored Dew Key Chain | M751 | `Colored(Gold)` |
| 5 | L7541 | Fogged Dew Key Chain | M751 | `Fogged` |
| 6 | L7551 | Chained Dew Key Chains | M751 | `Chained` |
| 7 | L7561 | Countdown Key Chain | M751 | `Countdown(8)` |
| 8 | L7571 | Phasing Dew Key Chain | M751 | `Phasing` |
| 9 | L7581 | Mirrored Key Chain | M751 | `Mirrored` |
| 10 | L7591 | Armored Key Chain Lock | M751 | `Armored` |
| 11 | L7601 | Growing Bramble Patch | M002 | `Growing(4)` |
| 12 | L7611 | Layered Dew Key Chain | M751 | `Layered(ground)` |
| 13 | L7621 | Frozen Crafting Flower | M752 | `Frozen(2)` |
| 15 | L7641 | Colored Crafting Flower | M752 | `Colored(Purple)` |
| 16 | L7651 | Fogged Crafting Flower | M752 | `Fogged` |
| 17 | L7661 | Chained Crafting Flowers | M752 | `Chained` |
| 18 | L7671 | Phasing Brook Fork | M701 | `Phasing` |
| 19 | L7681 | Countdown Crafting Flower | M752 | `Countdown(10)` |
| 20 | L7691 | Mirrored Crafting Flower | M752 | `Mirrored` |
| 21 | L7701 | Armored Crafting Lock | M752 | `Armored` |
| 22 | L7711 | Layered Crafting Flower | M752 | `Layered(air)` |
| 23 | L7721 | Growing Ivy Tangle | M074 | `Growing(3)` |
| 24 | L7731 | Frozen Skeleton Dew Key | M753 | `Frozen(1)` |
| 25 | L7741 | Colored Skeleton Dew Key | M753 | `Colored(Silver)` |
| 27 | L7761 | Fogged Skeleton Dew Key | M753 | `Fogged` |
| 28 | L7771 | Chained Skeleton Keys | M753 | `Chained` |
| 29 | L7781 | Countdown Skeleton Key | M753 | `Countdown(7)` |
| 30 | L7791 | Phasing Tide Brook | M702 | `Phasing` |
| 31 | L7801 | Mirrored Skeleton Key | M753 | `Mirrored` |
| 32 | L7811 | Armored Reflection Lock | M652 | `Armored` |
| 33 | L7821 | Layered Skeleton Key | M753 | `Layered(canopy)` |
| 34 | L7831 | Frozen Key Swap Pad | M754 | `Frozen(3)` |
| 35 | L7841 | Growing Moss Spores | M027 | `Growing(5)` |
| 36 | L7851 | Colored Key Swap Pad | M754 | `Colored(Cyan)` |
| 37 | L7861 | Countdown Key Swap Pad | M754 | `Countdown(12)` |
| 39 | L7881 | Fogged Key Swap Pad | M754 | `Fogged` |
| 40 | L7891 | Chained Key Swap Pads | M754 | `Chained` |
| 41 | L7901 | Phasing Key Swap Pad | M754 | `Phasing` |
| 42 | L7911 | Mirrored Key Swap Pad | M754 | `Mirrored` |
| 43 | L7921 | Armored Sluice Lever | M703 | `Armored` |
| 44 | L7931 | Layered Key Swap Pad | M754 | `Layered(ground)` |
| 45 | L7941 | Growing Hedge Border | M071 | `Growing(4)` |
| 46 | L7951 | Colored Scout Ant | M601 | `Colored(Amber)` |
| 47 | L7961 | Countdown Wind-Vane Lever | M551 | `Countdown(9)` |
| 48 | L7971 | Phasing Lazy River | M704 | `Phasing` |
| 49 | L7981 | Chained Honeycomb Arch | M005 | `Chained` |

**Total variant slots: 45**

---

### Cross-Phase Integrations
- M002, M005 (Phase 1)
- M027, M071, M074 (Phase 2)
- M551 (Phase 12)
- M601 (Phase 13)
- M652 (Phase 14)
- M701, M702, M703, M704 (Phase 15)

---

## Acceptance Criteria
- [ ] Unique intro tutorial dialog shown for all 45 variant configurations.
- [ ] `Armored Crafting Lock` requires synthesized master key to strike twice.
- [ ] `Frozen(K) Skeleton Key` cannot initiate exit until freeze duration expires.
- [ ] `Countdown(N) Key Swap Pad` triggers automatic key swap every $N$ turns.
- [ ] All 45 variant slots verified solvable by automated CI solver.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed |
| `assets/phase_16/variants/` | To be created |

---

## Risks and Open Questions

1. **Countdown Key Swap Timing:** Automatic swap must evaluate before player move commit so that insect key states are fully updated when line selections are registered.
