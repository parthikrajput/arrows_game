# Spec: Phase 16 Base Mechanics — M751 to M754 (Royal Keyring)

Source docs: phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-16-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 Base Mechanics — M751 to M754 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define the four new base mechanics for Phase 16 (Royal Keyring): Dew Key Chain, Key-Crafting Flower, Skeleton Dew Key, and Key Swap Pad — specifying their operational logic, parameters, edge conditions, solver implications, and intro levels.

---

## Current State

Design documented in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md`, not yet implemented.

---

## Proposed Change

### M751 — Dew Key Chain (Key Chain)
| Field | Value |
|---|---|
| ID | `M751` |
| Themed Name | Dew Key Chain |
| Generic | Key Chain |
| Category | K — Progressive Chained Key Delivery |
| Intro Level | **L7511** (Block 2 x1) |

**Rule:**
- A progressive key delivery mechanic. When Key Insect 1 exits and clears Lock 1, the key token transforms into Key 2 and is transferred to linked Insect 2.
- Insect 2 can now unlock Lock 2 upon its own exit.
- Keys can hop across any insect layer (ant ↔ bee).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If Insect 2 exits before Lock 1 is cleared, it exits as a neutral line without carrying Key 2, breaking the chain and causing a softlock. CI validator must ensure Insect 2's exit path requires Lock 1 to be cleared first.

**Solver Impact:** Solver tracks dynamic token transfers and enforces strict topological sequencing.

---

### M752 — Key-Crafting Flower (Key Crafting)
| Field | Value |
|---|---|
| ID | `M752` |
| Themed Name | Key-Crafting Flower |
| Generic | Key Crafting |
| Category | K / T — Multi-Key Synthesis Node |
| Intro Level | **L7631** (Block 14 x1) |

**Rule:**
- A golden blossom situated on the board acting as a key synthesis forge.
- Requires two complementary half-key insects (e.g. Red Half-Key and Yellow Half-Key).
- When both insects exit successfully, the flower combines the half-keys into a composite key (Orange Key), immediately opening the linked composite gate.
- Insects may exit in either order.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If only one half-key insect exits, the gate remains locked.
- Half-keys can be carried by ground ants or flying bees independently.

**Solver Impact:** Solver models multi-condition conjunctive triggers (AND logic) for gate clearances.

---

### M753 — Skeleton Dew Key (Skeleton Key)
| Field | Value |
|---|---|
| ID | `M753` |
| Themed Name | Skeleton Dew Key |
| Generic | Skeleton Key |
| Category | K — Cross-Axis Multi-Lock Breaker |
| Intro Level | **L7751** (Block 26 x1) |

**Rule:**
- A master insect bearing an ornate golden crown glyph.
- Upon successful exit from the board, a golden energy wave propagates along the insect's starting row ($y = y_0$) and column ($x = x_0$).
- All standard thorn locks along that entire orthogonal crosshair dissolve simultaneously.
- Both ants and bees can act as Skeleton Key lines.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- The cross-axis sweep originates strictly from the insect's initial start coordinate $(x_0, y_0)$, not its exit coordinate.

**Solver Impact:** High-value clearance action that simultaneously removes multiple spatial constraints.

---

### M754 — Key Swap Pad (Key Swap)
| Field | Value |
|---|---|
| ID | `M754` |
| Themed Name | Key Swap Pad |
| Generic | Key Swap |
| Category | C / K — Key Reallocation Controller |
| Intro Level | **L7871** (Block 38 x1) |

**Rule:**
- An interactive ground pad marked with reciprocal circular arrows.
- Tapping the pad costs 1 Move and exchanges key types between two designated linked lines.
- Allows players to swap a key from a trapped line onto an unblocked line to open path corridors.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If one linked line has a key while the other carries no key, tapping the pad transfers the key to the empty line (1-way handoff).

**Solver Impact:** Solver branches on swap activations, exploring reallocated key states.

---

## Acceptance Criteria
- [ ] M751 intro fires at L7511; dew key chain tutorial displayed once.
- [ ] M752 intro fires at L7631; key crafting tutorial displayed once.
- [ ] M753 intro fires at L7751; skeleton key tutorial displayed once.
- [ ] M754 intro fires at L7871; key swap tutorial displayed once.
- [ ] All 500 seeds (L7501–8000) verified solvable by CI solver with 0 hearts lost.
- [ ] Skeleton key sweep correctly calculates initial start coordinate crosshairs.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/dew_key_chain.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/key_crafting_flower.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/skeleton_dew_key.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/key_swap_pad.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Skeleton Key Wave Timing:** In dense levels with 8+ locks along row and column, locks must dissolve with a staggered 120 ms sweep animation without delaying player's next move input.
