# Spec: Phase 16 Signature System — Royal Keyring (Keys Deluxe)

Source docs: phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-15-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 Signature System — Royal Keyring (Keys Deluxe) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Introduce advanced multi-tier lock-and-key state machines: key-chain sequences, chromatic half-key crafting, cross-axis skeleton key sweeps, and dynamic key swap controllers expand traditional 1-to-1 key mechanics into multi-stage logical networks.

---

## Current State

Design documented in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md` and `phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Royal Keyring** (Keys Deluxe architecture).
- Multi-stage key transfer: unlocking Lock 1 bestows Key 2 to a designated waiting insect.
- Multi-key synthesis: exiting two complementary half-key insects creates a synthesized compound-colour master key.
- Four base mechanics introduced: M751 Dew Key Chain, M752 Key-Crafting Flower, M753 Skeleton Dew Key, M754 Key Swap Pad.
- All prior phase mechanics (M001–M704) remain active across boards and layers.

---

## Proposed Change

### 1. Key-Chain State Machine (M751)
- Lock $L_1$ maintains a reference pointer to target insect line $p_2$.
- When key insect $p_1$ exits the board and unlocks $L_1$, an unassigned key token for $L_2$ materializes dynamically on insect $p_2$.
- Insect $p_2$ can now unlock Lock $L_2$ upon its own successful exit.

### 2. Multi-Key Synthesis Node (M752)
- Key-Crafting Flower tracks two input half-key states (e.g. Red Half-Key + Yellow Half-Key).
- When both designated half-key insects exit the board, the flower combines them into an Orange Key, immediately opening the connected composite thorn gate.

### 3. Skeleton Cross-Ray Sweep (M753)
- When a Skeleton Dew Key insect exits, it triggers an orthogonal ray sweep originating from its initial start coordinate $(x_0, y_0)$.
- All standard thorn locks situated in row $y_0$ and column $x_0$ dissolve simultaneously.

### 4. Interactive Key Reallocation (M754)
- Tapping a Key Swap Pad costs 1 Move and exchanges active key attributes between two coupled insect lines.

### 5. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player taps/initiates move (or taps M754 Key Swap Pad).
2. Traversal and exit displacement process.
3. Exit resolution fires:
   - If Dew Key Chain (M751), bestows next-stage key icon to paired insect.
   - If Half-Key (M752), updates synthesis flower accumulator.
   - If Skeleton Key (M753), evaluates cross-axis row/column lock clearing in $\le 0.1$ ms.
4. Unlocked paths refresh; board state written.
5. UI HUD Keyring updates (`p16_skeleton_sweep_speed_ms = 120`).

### Acceptance Criteria
- [ ] Dew Key Chain transfers key 2 to line $p_2$ immediately upon lock 1 clearing.
- [ ] Key-Crafting Flower unlocks composite gate strictly after both half-key insects exit.
- [ ] Skeleton Key dissolves all locks along its initial row and column coordinates upon exit.
- [ ] Key Swap Pad exchanges key icons between paired insects at the cost of 1 move.
- [ ] Keys are cross-compatible across Ants (ground) and Bees (air/canopy).
- [ ] L7501 tutorial overlay fires: "Royal Keyring — Unlock chains of keys, craft combined colors, and swap keys between insects!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/royal_keyring.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/dew_key_chain.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/key_crafting_flower.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/skeleton_dew_key.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/key_swap_pad.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (keyring state resolution) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (dependency DAG solver) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `15` → `16` | Unlock Phase 16 content |
| `p16_skeleton_sweep_speed_ms` | `120` | Skeleton key unlock ray speed |

---

## Risks and Open Questions

1. **Circular Key Dependencies:** Multi-tier key chains must form a strict directed acyclic graph (DAG). The procedural level generator validator must verify zero cyclic deadlocks across all 500 seeds.
