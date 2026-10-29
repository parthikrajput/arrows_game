# Spec: Phase 9 Base Mechanics — M401 to M404 (Swarm Splits)

Source docs: phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-9-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 Base Mechanics — M401 to M404 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Define the four new base mechanics for Phase 9 (Swarm Splits): Honey Merge Pad, Fork Twig, Segment Clasp, and Reunion Arch — each with exact rule, parameters, edge cases, solver impact, and intro level.

---

## Current State

Design documented in phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, not yet implemented.

---

## Proposed Change

### M401 — Honey Merge Pad (Merger Pad)
| Field | Value |
|---|---|
| ID | `M401` |
| Themed Name | Honey Merge Pad |
| Generic | Merger Pad |
| Category | T — Stationary Line Fusion Tile |
| Intro Level | **L4011** (Block 2 x1) |

**Rule:**
- A golden sticky honey pad. The first linked line to reach this pad halts with its head anchored (becomes inactive).
- When the second linked line reaches the same pad, it couples behind the first and both advance together as a combined caravan in the second line's original direction.
- Same-layer coupling only: ant line + ant line, bee line + bee line.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If only one linked line reaches the pad and the other never arrives, the halted line stays permanently on the pad and may block other lines. CI solver must ensure all merge pads have both linked lines deliverable.
- A merged caravan that encounters another Merge Pad: behaviour undefined — flag as Open Question.

**Solver Impact:** Solver must track which lines are halted on Merge Pads as a special board state; the second line's path must account for the halted line's occupied cells.

---

### M402 — Fork Twig (Twin Splitter)
| Field | Value |
|---|---|
| ID | `M402` |
| Themed Name | Fork Twig |
| Generic | Twin Splitter |
| Category | T — Dynamic Line Splitting Node |
| Intro Level | **L4131** (Block 14 x1) |

**Rule:**
- A Y-shaped twig tile. When a line enters from its mouth direction, it splits into two halves: left branch exits 90° CCW, right branch exits 90° CW.
- If `L` is even: each branch gets `L/2` segments. If `L` is odd: left gets `⌈L/2⌉`, right gets `⌊L/2⌋`.
- **Atomic all-or-nothing:** Both exit paths must be completely clear. If either is blocked, the entire move fails (bonk, −1 Heart); no line advances.
- Ground (ant) lines: ground fork twig only. If `tall: true`, also splits bee lines.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Fork Twig entered from a non-mouth direction: treated as a wall (bonk).
- Split branch hitting another Fork Twig: results in a 4-way split — behaviour undefined, flag as Open Question.
- Coloured lines split into two coloured branches (same colour inherited).

**Solver Impact:** Solver must enumerate both branch paths simultaneously and check atomic clearance before committing the move.

---

### M403 — Segment Clasp (Segment Lock)
| Field | Value |
|---|---|
| ID | `M403` |
| Themed Name | Segment Clasp |
| Generic | Segment Lock |
| Category | K / P — Selective Body Segment Lock |
| Intro Level | **L4251** (Block 26 x1) |

**Rule:**
- A small golden buckle clasp attached to a line's body. While clasped, only the front free segment of the line can move; back segments are stationary and locked.
- The clasp unlocks when the linked key-line exits the board successfully.
- Upon unlock, the locked back segments become an independent free line.
- Applies to both ant and bee lines.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Multiple Segment Clasps on the same line: each has its own linked key-line; all must exit to fully unlock the line.
- The key-line itself may also be clasped — chain dependency must be acyclic. CI solver must verify no cyclic dependency in any level seed.
- If the linked key-line is blocked from exiting, the clasped line remains permanently locked — level is unsolvable. CI solver must catch this.

**Solver Impact:** Solver must track all active clasps and their linked key-lines as dependency chains; BFS must enumerate valid ordering of key-line exits.

---

### M404 — Reunion Arch (Rejoin Gate)
| Field | Value |
|---|---|
| ID | `M404` |
| Themed Name | Reunion Arch |
| Generic | Rejoin Gate |
| Category | G — Split Completion Gate |
| Intro Level | **L4371** (Block 38 x1) |

**Rule:**
- A green ivy arch gate. Opens only when both halves (left and right) of a Fork Twig (M402) split have exited the board successfully.
- Each arch tracks exactly one split pair; the arch does not open if only one half exits.
- When closed: blocks ground ant lines. If `tall: true`, also blocks bee lines.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- A Reunion Arch with no associated Fork Twig in the level: never opens — level is unsolvable. CI solver must catch this.
- Multiple Reunion Arches in one level: each tracks its own paired Fork Twig split.

**Solver Impact:** Solver must track split-half exit status per Fork Twig; Reunion Arch reachability depends on both halves exiting.

---

## Acceptance Criteria
- [ ] M401 intro fires at L4011; merge pad tutorial card shown once.
- [ ] M402 intro fires at L4131; fork twig tutorial card shown once.
- [ ] M403 intro fires at L4251; segment clasp tutorial card shown once.
- [ ] M404 intro fires at L4371; reunion arch tutorial card shown once.
- [ ] All 500 seeds (L4001–4500) pass CI solver with 0 hearts lost, 0 boosters required.
- [ ] Fork twig atomic check: bonk fires correctly when either branch is blocked.
- [ ] Merge pad coupling: merged caravan exits in correct direction.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/honey_merge_pad.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/fork_twig.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/segment_clasp.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/reunion_arch.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Merged caravan hitting a second Merge Pad:** Behaviour not specified in source docs.
2. **Branch hitting a second Fork Twig:** 4-way split behaviour not defined.
3. **Cyclic clasp dependency:** CI solver must detect and reject any level seed with a cyclic Segment Clasp key-line dependency.
4. **Colour inheritance on split branches:** Not explicitly addressed — assume same colour inherited by both branches.
