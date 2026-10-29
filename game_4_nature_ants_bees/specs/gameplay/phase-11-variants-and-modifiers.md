# Spec: Phase 11 Variants and Modifiers — Twin Gardens (45 Slots)

Source docs: phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-11-base-mechanics.md, specs/gameplay/phase-11-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 Variants and Modifiers — Twin Gardens (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define the 45 variant slots for Phase 11, combining Twin Gardens mechanics (M501–M504) and prior-phase mechanics with the 10 standard modifiers across levels L5021–L5481.

---

## Current State

Design documented in `phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md`, not yet implemented.

---

## Proposed Change

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L5021 | Frozen Garden Gate Link | M501 | `Frozen(2)` |
| 4 | L5031 | Colored Garden Gate Link | M501 | `Colored(Sky)` |
| 5 | L5041 | Fogged Garden Gate Link | M501 | `Fogged` |
| 6 | L5051 | Chained Garden Gate Links | M501 | `Chained` |
| 7 | L5061 | Countdown Garden Gate Link | M501 | `Countdown(8)` |
| 8 | L5071 | Phasing Garden Gate Link | M501 | `Phasing` |
| 9 | L5081 | Mirrored Garden Gate Link | M501 | `Mirrored` |
| 10 | L5091 | Armored Garden Gate Link | M501 | `Armored` |
| 11 | L5101 | Growing Bramble Border | M002 | `Growing(4)` |
| 12 | L5111 | Layered Garden Gate Link | M501 | `Layered(ground)` |
| 13 | L5121 | Frozen Pen-Pal Key | M502 | `Frozen(2)` |
| 15 | L5141 | Colored Pen-Pal Key | M502 | `Colored(Red)` |
| 16 | L5151 | Fogged Pen-Pal Key | M502 | `Fogged` |
| 17 | L5161 | Chained Pen-Pal Keys | M502 | `Chained` |
| 18 | L5171 | Phasing Cricket Gate | M451 | `Phasing` |
| 19 | L5181 | Countdown Pen-Pal Key | M502 | `Countdown(10)` |
| 20 | L5191 | Mirrored Pen-Pal Key | M502 | `Mirrored` |
| 21 | L5201 | Armored Pen-Pal Lock | M502 | `Armored` |
| 22 | L5211 | Layered Pen-Pal Key | M502 | `Layered(air)` |
| 23 | L5221 | Growing Ivy Arch | M074 | `Growing(3)` |
| 24 | L5231 | Frozen Reflecting Twin | M503 | `Frozen(1)` |
| 25 | L5241 | Colored Reflecting Twin | M503 | `Colored(Blue)` |
| 27 | L5261 | Fogged Reflecting Twin | M503 | `Fogged` |
| 28 | L5271 | Chained Reflecting Twins | M503 | `Chained` |
| 29 | L5281 | Countdown Reflecting Twin | M503 | `Countdown(7)` |
| 30 | L5291 | Phasing Honey Merge Pad | M401 | `Phasing` |
| 31 | L5301 | Mirrored Reflecting Twin | M503 | `Mirrored` |
| 32 | L5311 | Armored Bead-String Lock | M452 | `Armored` |
| 33 | L5321 | Layered Reflecting Twin | M503 | `Layered(canopy)` |
| 34 | L5331 | Frozen Relay Burrow | M504 | `Frozen(3)` |
| 35 | L5341 | Growing Moss Cluster | M027 | `Growing(5)` |
| 36 | L5351 | Colored Relay Burrow | M504 | `Colored(Brown)` |
| 37 | L5361 | Countdown Relay Burrow | M504 | `Countdown(12)` |
| 39 | L5381 | Fogged Relay Burrow | M504 | `Fogged` |
| 40 | L5391 | Chained Relay Burrows | M504 | `Chained` |
| 41 | L5401 | Phasing Relay Burrow | M504 | `Phasing` |
| 42 | L5411 | Mirrored Relay Burrow | M504 | `Mirrored` |
| 43 | L5421 | Armored Queue Hedge | M453 | `Armored` |
| 44 | L5431 | Layered Relay Burrow | M504 | `Layered(ground)` |
| 45 | L5441 | Growing Hedge Fence | M071 | `Growing(4)` |
| 46 | L5451 | Colored Fork Twig | M402 | `Colored(Amber)` |
| 47 | L5461 | Countdown Shears | M352 | `Countdown(9)` |
| 48 | L5471 | Phasing Turntable | M301 | `Phasing` |
| 49 | L5481 | Chained Honeycomb Arch | M005 | `Chained` |

**Total variant slots: 45**

---

### Prior-Phase Integrations
- M002, M005 (Phase 1)
- M027, M071, M074 (Phase 2)
- M301 (Phase 7)
- M352 (Phase 8)
- M401, M402 (Phase 9)
- M451, M452, M453 (Phase 10)

---

## Acceptance Criteria
- [ ] Each of the 45 variant slots (x1 intro) triggers a unique tutorial modal.
- [ ] `Armored Pen-Pal Lock` requires two key insects to exit before clearing.
- [ ] `Frozen(K)` Gate Link stays sealed for $K$ moves, disallowing inter-board crossings.
- [ ] `Growing(N)` Bramble Border expands across boundaries according to BFS rules.
- [ ] All 45 variant combinations verified solvable by CI solver.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed |
| `assets/phase_11/variants/` | To be created |

---

## Risks and Open Questions

1. **Cross-Board Chained Portals:** Chained Garden Gate Links (M501 × `Chained`) must avoid circular feedback loops where a transition immediately re-triggers its linked counterpart.
