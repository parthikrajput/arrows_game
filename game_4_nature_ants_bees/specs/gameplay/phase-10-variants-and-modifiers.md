# Spec: Phase 10 Variants and Modifiers — Garden Rhythm (45 Slots)

Source docs: phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-10-base-mechanics.md, specs/gameplay/phase-10-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 Variants and Modifiers — Garden Rhythm (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define the 45 variant slots for Phase 10, combining Garden Rhythm mechanics (M451–M454) and prior-phase mechanics with the 10 standard modifiers across levels L4521–L4981.

---

## Current State

Design documented in `phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md`, not yet implemented.

---

## Proposed Change

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L4521 | Frozen Cricket Gate | M451 | `Frozen(2)` |
| 4 | L4531 | Colored Cricket Gate | M451 | `Colored(Green)` |
| 5 | L4541 | Fogged Cricket Gate | M451 | `Fogged` |
| 6 | L4551 | Chained Cricket Gates | M451 | `Chained` |
| 7 | L4561 | Countdown Cricket Gate | M451 | `Countdown(8)` |
| 8 | L4571 | Phasing Cricket Gate | M451 | `Phasing` |
| 9 | L4581 | Mirrored Cricket Gate | M451 | `Mirrored` |
| 10 | L4591 | Armored Cricket Gate | M451 | `Armored` |
| 11 | L4601 | Growing Bramble Fence | M002 | `Growing(4)` |
| 12 | L4611 | Layered Cricket Gate | M451 | `Layered(ground)` |
| 13 | L4621 | Frozen Bead-String Lock | M452 | `Frozen(2)` |
| 15 | L4641 | Colored Bead-String Lock | M452 | `Colored(Red)` |
| 16 | L4651 | Fogged Bead-String Lock | M452 | `Fogged` |
| 17 | L4661 | Chained Bead-String Locks | M452 | `Chained` |
| 18 | L4671 | Phasing Honey Merge Pad | M401 | `Phasing` |
| 19 | L4681 | Countdown Bead Lock | M452 | `Countdown(10)` |
| 20 | L4691 | Mirrored Bead Lock | M452 | `Mirrored` |
| 21 | L4701 | Armored Bead Lock | M452 | `Armored` |
| 22 | L4711 | Layered Bead Lock | M452 | `Layered(air)` |
| 23 | L4721 | Growing Ivy Sprout | M074 | `Growing(3)` |
| 24 | L4731 | Frozen Queue Hedge | M453 | `Frozen(1)` |
| 25 | L4741 | Colored Queue Hedge | M453 | `Colored(Amber)` |
| 27 | L4761 | Fogged Queue Hedge | M453 | `Fogged` |
| 28 | L4771 | Chained Queue Hedges | M453 | `Chained` |
| 29 | L4781 | Countdown Queue Hedge | M453 | `Countdown(9)` |
| 30 | L4791 | Phasing Fork Twig | M402 | `Phasing` |
| 31 | L4801 | Mirrored Queue Hedge | M453 | `Mirrored` |
| 32 | L4811 | Armored Segment Clasp | M403 | `Armored` |
| 33 | L4821 | Layered Queue Hedge | M453 | `Layered(canopy)` |
| 34 | L4831 | Frozen Echo Bloom | M454 | `Frozen(3)` |
| 35 | L4841 | Growing Moss Spores | M027 | `Growing(5)` |
| 36 | L4851 | Colored Echo Bloom | M454 | `Colored(Sky)` |
| 37 | L4861 | Countdown Echo Bloom | M454 | `Countdown(12)` |
| 39 | L4881 | Fogged Echo Bloom | M454 | `Fogged` |
| 40 | L4891 | Chained Echo Blooms | M454 | `Chained` |
| 41 | L4901 | Phasing Echo Bloom | M454 | `Phasing` |
| 42 | L4911 | Mirrored Echo Bloom | M454 | `Mirrored` |
| 43 | L4921 | Armored Reunion Arch | M404 | `Armored` |
| 44 | L4931 | Layered Echo Bloom | M454 | `Layered(ground)` |
| 45 | L4941 | Growing Hedge Border | M071 | `Growing(4)` |
| 46 | L4951 | Colored Turntable | M301 | `Colored(Gold)` |
| 47 | L4961 | Countdown Morning Glory | M351 | `Countdown(8)` |
| 48 | L4971 | Phasing Dewdrop Marble | M202 | `Phasing` |
| 49 | L4981 | Chained Honeycomb Arch | M005 | `Chained` |

**Total variant slots: 45**

---

### Prior-Phase Cross-Combinations
- M002, M005 (Phase 1)
- M027, M071, M074 (Phase 2)
- M202 (Phase 5)
- M301 (Phase 7)
- M351 (Phase 8)
- M401, M402, M403, M404 (Phase 9)

---

## Acceptance Criteria
- [ ] All 45 variant intro levels (x1 slot) trigger unique tutorial cards.
- [ ] `Frozen(K)` Cricket Gate stays locked in closed state for $K$ moves, ignoring modulo evaluations until thawed.
- [ ] `Chained` Queue Hedges release their respective queues simultaneously when order requirements are met.
- [ ] `Phasing` Fork Twig switches branch availability on alternating moves.
- [ ] All 45 variant slots verified solvable by CI solver.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed |
| `assets/phase_10/variants/` | To be created |

---

## Risks and Open Questions

1. **Phasing vs Modulo Rhythm Interference:** M451 with `Phasing` modifier combines two separate periodic states (modulo $P$ and phase toggle). Period alignment must avoid permanent deadlocks where the gate is never simultaneously open and in active phase.
