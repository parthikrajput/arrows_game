# Spec: Phase 19 Base Mechanics — Garden Festival II Combo Mechanics (M901–M904)

Source docs: phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, SCALING_TO_10000_LEVELS.md §6, SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-19-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 Base Mechanics — Garden Festival II Combo Mechanics (M901–M904) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define the detailed rules, parameters, edge cases, solver constraints, and introduction levels for the four data-driven combo mechanics of Phase 19: Falling Vines (M901), Rhythm Rotor (M902), Twin-Garden Fork (M903), and Gravity Turntable (M904).

---

## Current State

Design documented in `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md` and `SCALING_TO_10000_LEVELS.md §6`, not yet implemented.

---

## Proposed Change

### M901 — Falling Vines (Growth × Gravity)
- **ID:** `M901`
- **Themed Name:** Falling Vines (Generic: Spreading Gravity Vines)
- **Category:** B / T — Gravity-Sensitive Expanding Vines
- **Intro Level:** **L9011** (Block 2 x1)
- **Rule:** Composition of Growth (Phase 8) and Gravity (Phase 12). Morning glory vine clusters expand orthogonally into adjacent free cells every $N$ player moves (default $N = 3$), and subsequently slide 1 cell along the downward gravity vector. Can be trimmed using Garden Shears (M352) or blown away with Leaf Blower.
- **Properties:**
  - `tall: per instance` (blocks ground ants; blocks bees if tall).
  - `hammerable: true` (via Leaf Blower).
  - `non_monotone: true`.
- **Edge Cases:** If gravity pulls a vine segment into a cell already occupied by another stationary obstacle, the downward slide for that segment halts without causing damage.

### M902 — Rhythm Rotor (Sequencing × Rotation)
- **ID:** `M902`
- **Themed Name:** Rhythm Rotor (Generic: Auto-Timed Sub-board Turntable)
- **Category:** T / C — Modulo-Triggered Sub-Grid Rotor
- **Intro Level:** **L9131** (Block 14 x1)
- **Rule:** Composition of Sequencing (Phase 10) and Rotation (Phase 7). $4\times 4$ circular sub-board sector. Rotates automatically $90^\circ$ clockwise whenever $\text{moveCount} \bmod P == 0$ (default $P = 3$ or $4$) at the start of the end-of-turn settlement tick. Tapping the rotor directly is disabled.
- **Properties:**
  - `tall: grid region`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Insects caught entirely or partially inside the $4\times 4$ footprint rotate along with the turntable, updating their directional headings.

### M903 — Twin-Garden Fork (Linked Boards × Split/Merge)
- **ID:** `M903`
- **Themed Name:** Twin-Garden Fork (Generic: Cross-Board Twin Splitter)
- **Category:** T / G — Inter-Board Line Splitting Node
- **Intro Level:** **L9251** (Block 26 x1)
- **Rule:** Composition of Linked Boards (Phase 11) and Split/Merge (Phase 9). Positioned along the border channel of Board A. An insect line entering this node divides into two separate halves: Branch 1 veers $90^\circ$ locally on Board A, while Branch 2 teleports through a spatial rift directly onto the corresponding coordinate on Board B.
- **Properties:**
  - `tall: per instance`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Both downstream paths (on Board A and Board B) must be completely clear; if either branch encounters a collision obstacle, the split fails, the insect halts, and 1 Heart is lost.

### M904 — Gravity Turntable (Rotation × Gravity)
- **ID:** `M904`
- **Themed Name:** Gravity Turntable (Generic: Rotating Gravity Zone)
- **Category:** T / C — Sector-Specific Gravity Matrix
- **Intro Level:** **L9371** (Block 38 x1)
- **Rule:** Composition of Rotation (Phase 7) and Gravity (Phase 12). Circular turntable sector that can be rotated $90^\circ$ CW (costs 1 move). Rotating the sector rotates all internal tiles and also rotates the localized directional gravity vector by $90^\circ$ CW, causing internal pushable acorns and falling items to slide toward the newly aligned downhill edge.
- **Properties:**
  - `tall: grid region`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Items exiting the boundaries of the Gravity Turntable re-enter the global gravity vector field on the main board.

---

## Verification Plan

### Automated Tests
1. Verify M901: vines expand orthogonally and drift downward along gravity vector on growth moves.
2. Verify M902: automatic rotation fires strictly when $\text{moveCount} \bmod P == 0$; manual tap ignores input.
3. Verify M903: entering fork spawns simultaneous lines on Board A and Board B.
4. Verify M904: rotating turntable redirects internal gravity vector $90^\circ$ CW without altering external board gravity.

### Manual Verification
1. Verify audio chime on automatic Rhythm Rotor turn provides clear rhythmic feedback.
2. Confirm camera panning smoothly accommodates simultaneous line movement across linked boards.
