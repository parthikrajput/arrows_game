# Spec: Phase 8 Variants and Modifiers — Bloom Season (45 Slots)

Source docs: phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md, SCALING_TO_10000_LEVELS.md §7. Depends on: specs/gameplay/phase-8-base-mechanics.md, specs/gameplay/phase-8-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 Variants and Modifiers — Bloom Season (45 Slots) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define the 45 variant slots for Phase 8 that combine Bloom Season base mechanics (M351–M354) and prior-phase mechanics with the 10 standard modifiers, providing progressive difficulty escalation from L3521 through L3981.

---

## Current State

Design documented in phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md, not yet implemented. Modifier system defined in SCALING_TO_10000_LEVELS.md §7.

---

## Proposed Change

### Modifier Definitions (Standard — All Phases)
| Modifier | Behaviour |
|---|---|
| `Frozen(K)` | Mechanic is locked for `K` moves after placement; cannot be triggered or traversed until thawed |
| `Colored(c)` | Only lines of matching colour can interact with this mechanic |
| `Fogged` | Mechanic is hidden under fog until a line enters the same row or column |
| `Chained` | Two instances are linked; triggering one triggers the other simultaneously |
| `Countdown(N)` | Mechanic activates automatically after `N` moves regardless of player action |
| `Phasing` | Mechanic alternates between active and inactive states every move |
| `Armored` | Requires two triggers / two clears instead of one |
| `Layered(mask)` | Only lines on the specified layer (`ground`, `air`, `canopy`) interact with this mechanic |
| `Mirrored` | Two symmetrically placed instances always mirror each other's state |
| `Growing(N)` | Mechanic expands by 1 cell every `N` moves (Growth phase specific) |

---

### 45 Variant Slot Table

| Block | Intro Level | Variant Themed Name | Base Mechanic | Modifier |
|---|---|---|---|---|
| 3 | L3521 | Frozen Morning Glory | M351 | `Frozen(2)` |
| 4 | L3531 | Colored Morning Glory | M351 | `Colored(Purple)` |
| 5 | L3541 | Fogged Morning Glory | M351 | `Fogged` |
| 6 | L3551 | Chained Morning Glories | M351 | `Chained` |
| 7 | L3561 | Countdown Morning Glory | M351 | `Countdown(8)` |
| 8 | L3571 | Phasing Morning Glory | M351 | `Phasing` |
| 9 | L3581 | Mirrored Morning Glory | M351 | `Mirrored` |
| 10 | L3591 | Armored Morning Glory Root | M351 | `Armored` |
| 11 | L3601 | Growing Bramble Thicket | M002 | `Growing(3)` |
| 12 | L3611 | Layered Morning Glory | M351 | `Layered(ground)` |
| 13 | L3621 | Frozen Garden Shears | M352 | `Frozen(2)` |
| 15 | L3641 | Colored Garden Shears | M352 | `Colored(Silver)` |
| 16 | L3651 | Fogged Garden Shears | M352 | `Fogged` |
| 17 | L3661 | Chained Garden Shears | M352 | `Chained` |
| 18 | L3671 | Phasing Turntable | M301 | `Phasing` |
| 19 | L3681 | Countdown Garden Shears | M352 | `Countdown(10)` |
| 20 | L3691 | Mirrored Garden Shears | M352 | `Mirrored` |
| 21 | L3701 | Armored Shears Base | M352 | `Armored` |
| 22 | L3711 | Layered Garden Shears | M352 | `Layered(air)` |
| 23 | L3721 | Growing Ivy Vine | M074 | `Growing(4)` |
| 24 | L3731 | Frozen Seed-Dropping Line | M353 | `Frozen(1)` |
| 25 | L3741 | Colored Seed-Dropping Line | M353 | `Colored(Amber)` |
| 27 | L3761 | Fogged Seed-Dropping Line | M353 | `Fogged` |
| 28 | L3771 | Chained Seed-Dropping Lines | M353 | `Chained` |
| 29 | L3781 | Countdown Seed-Dropping Line | M353 | `Countdown(7)` |
| 30 | L3791 | Phasing Spinning Top Line | M303 | `Phasing` |
| 31 | L3801 | Mirrored Seed-Dropping Line | M353 | `Mirrored` |
| 32 | L3811 | Armored Turning Hedge | M302 | `Armored` |
| 33 | L3821 | Layered Seed-Dropping Line | M353 | `Layered(canopy)` |
| 34 | L3831 | Frozen Pollination Gate | M354 | `Frozen(3)` |
| 35 | L3841 | Growing Moss Spores | M027 | `Growing(5)` |
| 36 | L3851 | Colored Pollination Gate | M354 | `Colored(Pink)` |
| 37 | L3861 | Countdown Pollination Gate | M354 | `Countdown(12)` |
| 39 | L3881 | Fogged Pollination Gate | M354 | `Fogged` |
| 40 | L3891 | Chained Pollination Gates | M354 | `Chained` |
| 41 | L3901 | Phasing Pollination Gate | M354 | `Phasing` |
| 42 | L3911 | Mirrored Pollination Gate | M354 | `Mirrored` |
| 43 | L3921 | Armored Pinned Daisy | M304 | `Armored` |
| 44 | L3931 | Layered Pollination Gate | M354 | `Layered(canopy)` |
| 45 | L3941 | Growing Hedge Wall | M071 | `Growing(4)` |
| 46 | L3951 | Colored Dewdrop Marble | M202 | `Colored(Green)` |
| 47 | L3961 | Countdown Petal Filter | M251 | `Countdown(9)` |
| 48 | L3971 | Phasing Acorn Lift | M154 | `Phasing` |
| 49 | L3981 | Chained Honeycomb Gate | M005 | `Chained` |

**Total variant slots: 45** (Blocks 3–13, 15–25, 27–37, 39–49; Blocks 1, 2, 14, 26, 38 are base/signature intros; Block 50 is review level).

---

### Prior-Phase Mechanics Used in Variants
The following prior-phase mechanics appear as the base of cross-phase variants:
- M002 (Bramble Blocker — Phase 1)
- M005 (Honeycomb Gate — Phase 1)
- M027 (Moss Spores — Phase 2)
- M071, M074 (Phase 2 mechanics)
- M154 (Acorn Lift — Phase 4)
- M202 (Dewdrop Marble — Phase 5)
- M251 (Petal Filter — Phase 6)
- M301, M302, M303, M304 (Phase 7 mechanics)

All prior mechanics must be active and functional before Phase 8 variant levels unlock.

---

## Acceptance Criteria
- [ ] Each of the 45 variant intro levels (x1 slot) shows a one-time tutorial card naming the variant.
- [ ] All 45 variant levels pass CI solver with 0 hearts lost.
- [ ] `Frozen(K)` vines do not expand during their frozen period.
- [ ] `Growing(N)` modifier on prior-phase mechanics uses the same BFS expansion logic as M351.
- [ ] `Phasing` variants correctly alternate active/inactive each move.
- [ ] `Chained` pairs: triggering mechanic A simultaneously triggers mechanic B.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/modifiers/` | Changed (add Growing modifier support) |
| `packages/puzzle_core/lib/mechanics/` | Changed (Growing modifier applied to M002, M027, M071, M074) |
| `assets/phase_8/variants/` | To be created |

---

## Risks and Open Questions

1. **M002 + Growing(3) interaction:** M002 (Bramble Blocker) has not previously supported a Growing modifier. Confirm that the Growing modifier BFS logic is applicable to M002 without conflicts with M351 expansion.
2. **M074 reference:** M074 is used in "Growing Ivy Vine" variant but M074's canonical name and category are not defined in the Phase 8 docs. Cross-check against Phase 2 base mechanics spec.
3. **Block 50 review level:** Exactly which prior mechanics appear in the Mastery Mix (L3991) is not enumerated. This must be specified in the level seed.
