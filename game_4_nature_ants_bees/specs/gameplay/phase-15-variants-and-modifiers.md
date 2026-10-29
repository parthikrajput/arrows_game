# Spec: Phase 15 Variants and Modifiers — Brook & Rails (45 Slots)

Source docs: phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-15-base-mechanics.md, specs/gameplay/phase-15-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 Variants and Modifiers — Brook & Rails (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Define the 45 variant slots for Phase 15, combining Brook & Rails mechanics (M701–M704) and prior-phase mechanics with the 10 standard modifiers across levels L7021–L7481.

---

## Current State

Design documented in `phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md`, not yet implemented.

---

## Proposed Change

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L7021 | Frozen Brook Fork | M701 | `Frozen(2)` |
| 4 | L7031 | Colored Brook Fork | M701 | `Colored(Blue)` |
| 5 | L7041 | Fogged Brook Fork | M701 | `Fogged` |
| 6 | L7051 | Chained Brook Forks | M701 | `Chained` |
| 7 | L7061 | Countdown Brook Fork | M701 | `Countdown(8)` |
| 8 | L7071 | Phasing Brook Fork | M701 | `Phasing` |
| 9 | L7081 | Mirrored Brook Fork | M701 | `Mirrored` |
| 10 | L7091 | Armored Brook Fork | M701 | `Armored` |
| 11 | L7101 | Growing Bramble Patch | M002 | `Growing(4)` |
| 12 | L7111 | Layered Brook Fork | M701 | `Layered(ground)` |
| 13 | L7121 | Frozen Tide Brook | M702 | `Frozen(2)` |
| 15 | L7141 | Colored Tide Brook | M702 | `Colored(Sky)` |
| 16 | L7151 | Fogged Tide Brook | M702 | `Fogged` |
| 17 | L7161 | Chained Tide Brooks | M702 | `Chained` |
| 18 | L7171 | Phasing Pond Axis | M651 | `Phasing` |
| 19 | L7181 | Countdown Tide Brook | M702 | `Countdown(10)` |
| 20 | L7191 | Mirrored Tide Brook | M702 | `Mirrored` |
| 21 | L7201 | Armored Tide Brook | M702 | `Armored` |
| 22 | L7211 | Layered Tide Brook | M702 | `Layered(ground)` |
| 23 | L7221 | Growing Ivy Tangle | M074 | `Growing(3)` |
| 24 | L7231 | Frozen Sluice Lever | M703 | `Frozen(1)` |
| 25 | L7241 | Colored Sluice Lever | M703 | `Colored(Amber)` |
| 27 | L7261 | Fogged Sluice Lever | M703 | `Fogged` |
| 28 | L7271 | Chained Sluice Levers | M703 | `Chained` |
| 29 | L7281 | Countdown Sluice Lever | M703 | `Countdown(7)` |
| 30 | L7291 | Phasing Reflection Lock | M652 | `Phasing` |
| 31 | L7301 | Mirrored Sluice Lever | M703 | `Mirrored` |
| 32 | L7311 | Armored Scout Ant | M601 | `Armored` |
| 33 | L7321 | Layered Sluice Lever | M703 | `Layered(ground)` |
| 34 | L7331 | Frozen Lazy River | M704 | `Frozen(3)` |
| 35 | L7341 | Growing Moss Spores | M027 | `Growing(5)` |
| 36 | L7351 | Colored Lazy River | M704 | `Colored(Green)` |
| 37 | L7361 | Countdown Lazy River | M704 | `Countdown(12)` |
| 39 | L7381 | Fogged Lazy River | M704 | `Fogged` |
| 40 | L7391 | Chained Lazy Rivers | M704 | `Chained` |
| 41 | L7401 | Phasing Lazy River | M704 | `Phasing` |
| 42 | L7411 | Mirrored Lazy River | M704 | `Mirrored` |
| 43 | L7421 | Armored Wind-Vane Lever | M551 | `Armored` |
| 44 | L7431 | Layered Lazy River | M704 | `Layered(ground)` |
| 45 | L7441 | Growing Hedge Border | M071 | `Growing(4)` |
| 46 | L7451 | Colored Cricket Gate | M451 | `Colored(Gold)` |
| 47 | L7461 | Countdown Falling Acorns | M552 | `Countdown(9)` |
| 48 | L7471 | Phasing Honey Merge Pad | M401 | `Phasing` |
| 49 | L7481 | Chained Honeycomb Arch | M005 | `Chained` |

**Total variant slots: 45**

---

### Cross-Phase Integrations
- M002, M005 (Phase 1)
- M027, M071, M074 (Phase 2)
- M401 (Phase 9)
- M451 (Phase 10)
- M551, M552 (Phase 12)
- M601 (Phase 13)
- M651, M652 (Phase 14)

---

## Acceptance Criteria
- [ ] Unique intro tutorial dialog presented for all 45 variant configurations.
- [ ] `Frozen(K) Tide Brook` stops water current and suspends ant drift until thawed.
- [ ] `Chained Sluice Levers` toggle both connected sluice valves synchronously.
- [ ] `Phasing Lazy River` toggles active current on alternating moves (stops ant drift on inactive phases).
- [ ] All 45 variant slots verified solvable by automated CI solver.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed |
| `assets/phase_15/variants/` | To be created |

---

## Risks and Open Questions

1. **Phasing Lazy River (M704 × Phasing):** An ant trapped in a phasing river loop only advances on active phase turns. Solvers must calculate circulation rate at half speed (0.5 cells/turn average).
