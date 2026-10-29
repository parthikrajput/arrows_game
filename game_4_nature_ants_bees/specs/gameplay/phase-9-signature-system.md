# Spec: Phase 9 Signature System — Swarm Splits (Split & Merge)

Source docs: phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-8-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 Signature System — Swarm Splits (Split & Merge) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Introduce dynamic line splitting and merging: ant and bee lines can now fork into two branches via Fork Twig tiles and reunite into longer caravans via Honey Merge Pads, requiring players to plan simultaneous multi-branch routing.

---

## Current State

Design documented in phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md and phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, not yet implemented.

Key facts:
- Signature system name: **Swarm Splits** (Split & Merge architecture).
- Splitting and merging are turn-based and deterministic.
- Fork split fires atomic all-or-nothing: both branches must be clear or the move fails.
- All prior phase mechanics (M001–M354) remain active.

---

## Proposed Change

### 1. Line Splitting Rules (via M402 Fork Twig)
- When a line of length `L` reaches a Fork Twig cell:
  - If `L` is even: both branches get `L/2` segments.
  - If `L` is odd: left branch gets `⌈L/2⌉`, right branch gets `⌊L/2⌋` segments.
- Left branch exits 90° CCW; right branch exits 90° CW.
- **Atomic Collision Check:** If either branch path is blocked, the entire move fails (bonk, −1 Heart) and no line advances.

### 2. Caravan Coupling Rules (via M401 Honey Merge Pad)
- First linked line reaches Merge Pad and halts there (becomes inactive, head anchored).
- When the second linked line reaches the same Merge Pad, it couples behind the first line.
- Both lines then advance together as a single combined caravan in the direction of the second line.
- Coupling is same-layer only: ant lines merge with ant lines, bee lines with bee lines.

### 3. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player commits move.
2. Atomic fork clearance check fires (M402): if blocked, bonk and stop.
3. Line splits execute (M402) or merge coupling executes (M401).
4. Segment Clasp checks fire (M403): locked segments remain, free segments advance.
5. Reunion Arch checks fire (M404): update per-arch exit counters.
6. Board state written; UI updated.

### 4. Signature System Interaction with Prior Systems
- Split branches inherit the original line's colour and layer.
- Vine cells (M351) from Phase 8 can block individual split branches independently.
- Segment Clasp (M403) applied to a merged caravan locks the back segments of the combined line.
- Reunion Arch (M404) tracks both halves of a Fork Twig split; does not open until both exit.

### Acceptance Criteria
- [ ] Fork split with even-length line: both branches exactly `L/2` segments.
- [ ] Fork split with odd-length line: left branch `⌈L/2⌉`, right `⌊L/2⌋`.
- [ ] Atomic check: if either branch blocked, move fails with bonk; no line advances.
- [ ] Merge pad: first line halts, second line couples and both exit as caravan.
- [ ] Same-layer-only coupling enforced: cross-layer merge rejected.
- [ ] `p9_split_stagger_ms = 0` (synchronous split animation mode) respected.
- [ ] L4001 tutorial overlay fires: "Swarm Splits — Ants and bees split into branches or unite into large caravans!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/swarm_splits.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/honey_merge_pad.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/fork_twig.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (add split/merge steps) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (dual-branch aware) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `8` → `9` | Unlock Phase 9 content |
| `p9_split_stagger_ms` | `0` | Fork split animation synchronous mode |

---

## Risks and Open Questions

1. **Solver complexity with dual branches:** Fork splits double the BFS branching factor. Solver performance on 14×14 grids with multiple fork twigs must be profiled; a pruning heuristic may be needed.
2. **Caravan length after merge:** The combined caravan after M401 merge may be very long (up to 40 segments). Grid bounds and visual presentation for very long caravans need to be verified.
3. **Branch colour inheritance:** If the original line has a colour modifier applied (e.g., `Colored(Red)`), do both split branches inherit the same colour? The source docs do not explicitly address this.
