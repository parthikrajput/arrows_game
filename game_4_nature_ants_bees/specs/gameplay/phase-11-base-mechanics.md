# Spec: Phase 11 Base Mechanics — M501 to M504 (Twin Gardens)

Source docs: phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-11-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 Base Mechanics — M501 to M504 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define the four new base mechanics for Phase 11 (Twin Gardens): Garden Gate Link, Pen-Pal Key, Reflecting Pond Board, and Relay Burrow — detailing their operational rules, parameters, edge conditions, solver implications, and intro levels.

---

## Current State

Design documented in `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md`, not yet implemented.

---

## Proposed Change

### M501 — Garden Gate Link (Board Link Edge)
| Field | Value |
|---|---|
| ID | `M501` |
| Themed Name | Garden Gate Link |
| Generic | Board Link Edge |
| Category | T / G — Inter-Board Boundary Portal |
| Intro Level | **L5011** (Block 2 x1) |

**Rule:**
- An open floral archway situated on the shared boundary edge between Board A and Board B.
- A line entering the gate on Board A emerges instantly on the corresponding perimeter coordinate of Board B and continues forward.
- Traversal requires that the destination cell on Board B and its forward lane be clear; otherwise, an atomic bonk (−1 Heart) occurs on Board A.
- Ants pass through by default; if `tall: true`, bee flight lanes are also transferred.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Cross-board loopback: If Gate Link 1 leads from Board A to Board B, and Gate Link 2 leads back from Board B to Board A, loops must be finite and resolvable.
- Line spanning both boards: Segments exist across Board A and Board B simultaneously until full exit.

**Solver Impact:** Solver tracks line head and segment arrays spanning compound dual-board coordinate systems.

---

### M502 — Pen-Pal Key (Cross-board Key)
| Field | Value |
|---|---|
| ID | `M502` |
| Themed Name | Pen-Pal Key |
| Generic | Cross-board Key |
| Category | K — Remote Inter-Board Key |
| Intro Level | **L5131** (Block 14 x1) |

**Rule:**
- A designated insect on Board A carrying a golden key glyph on its carapace.
- When this key insect exits Board A completely, a distant thorn lock (Pen-Pal Lock) on Board B instantly dissolves, opening blocked pathways.
- Any insect layer (ant or bee) can serve as a Pen-Pal Key.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If the Pen-Pal Key insect bonks or gets trapped on Board A, the linked lock on Board B remains permanently closed (unsolvable state; CI validator must catch).
- Multiple keys can target different locks on the opposite board.

**Solver Impact:** Solver treats cross-board locks as state dependencies; Board A key lines must be prioritized before Board B paths requiring the unlocked lane.

---

### M503 — Reflecting Pond Board (Mirror Board)
| Field | Value |
|---|---|
| ID | `M503` |
| Themed Name | Reflecting Pond Board |
| Generic | Mirror Board |
| Category | P / T — Inter-Board Synchronized Pair |
| Intro Level | **L5251** (Block 26 x1) |

**Rule:**
- A synchronized insect pair: one situated on Board A and its twin on Board B.
- Initiating movement on Board A triggers simultaneous movement of the twin on Board B in identical or mirrored directional vectors.
- Both insects must exit successfully. If either collides with an obstacle or another insect, an immediate bonk (−1 Heart) occurs.
- Strictly same-layer pairing (ground ant ↔ ground ant; bee ↔ bee).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Asymmetric path lengths: If Twin A reaches exit in 4 cells while Twin B requires 8 cells, Twin A exits smoothly while Twin B continues moving until complete.

**Solver Impact:** Solver must validate simultaneous multi-grid trajectories, pruning moves where either board yields a collision.

---

### M504 — Relay Burrow (Relay Portal)
| Field | Value |
|---|---|
| ID | `M504` |
| Themed Name | Relay Burrow |
| Generic | Relay Portal |
| Category | T — Cross-Board Subterranean Tunnel |
| Intro Level | **L5371** (Block 38 x1) |

**Rule:**
- A subterranean tunnel system connecting an entrance mound on Board A with an exit mound on Board B.
- Ant lines enter the burrow on Board A, disappear underground, and emerge immediately at the designated mound on Board B.
- **Ground Ants Only:** Bees cannot enter burrows (`tall: false` fixed).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Burrow exit on Board B occupied by another ant: move cannot proceed, ant waits or bonks.
- Flying insects attempting to tap into burrow are rejected with invalid action sound.

**Solver Impact:** Connects distant topological nodes across the two boards as directed tunnel edges in the pathfinding graph.

---

## Acceptance Criteria
- [ ] M501 intro fires at L5011; board link tutorial displayed once.
- [ ] M502 intro fires at L5131; pen-pal key tutorial displayed once.
- [ ] M503 intro fires at L5251; reflecting pond tutorial displayed once.
- [ ] M504 intro fires at L5371; relay burrow tutorial displayed once.
- [ ] All 500 seeds (L5001–5500) pass CI solver without boosters or heart loss.
- [ ] Relay Burrow rejects flying bee paths strictly.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/garden_gate_link.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/pen_pal_key.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/reflecting_pond_board.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/relay_burrow.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Simultaneous Dual-Board Rendering:** Low-tier mobile devices may experience memory pressure keeping textures for two 14×14 boards loaded in VRAM concurrently.
2. **Asymmetric Twin Motion Timing:** Ensure that when Twin A exits before Twin B, camera tracking doesn't jump abruptly between viewports.
