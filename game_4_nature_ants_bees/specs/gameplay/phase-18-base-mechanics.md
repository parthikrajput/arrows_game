# Spec: Phase 18 Base Mechanics — Garden Festival I Combo Mechanics (M851–M854)

Source docs: phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, SCALING_TO_10000_LEVELS.md §6, SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-18-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 Base Mechanics — Garden Festival I Combo Mechanics (M851–M854) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define the detailed rules, parameters, edge cases, solver constraints, and introduction levels for the four data-driven combo mechanics of Phase 18: Day-Night Terrace (M851), Sunlit Acorn (M852), Shaded Stairs (M853), and Dawn Marble (M854).

---

## Current State

Design documented in `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md` and `SCALING_TO_10000_LEVELS.md §6`, not yet implemented.

---

## Proposed Change

### M851 — Day-Night Terrace (Cycles × Floors)
- **ID:** `M851`
- **Themed Name:** Day-Night Terrace (Generic: Day-Night Stairs)
- **Category:** T / C — Temporal Vertical Portal
- **Intro Level:** **L8511** (Block 2 x1)
- **Rule:** Composition of Cycles (Phase 3) and Multi-floor (Phase 4). Root-woven staircase linking Floor 1 and Floor 2. Active strictly during Day phase ($A$, toggling every 5 moves). During Night phase ($B$), the staircase recedes into the lawn, acting as flat passable turf; insects crossing it remain on their current floor.
- **Properties:**
  - `tall: per instance` (ground ants use ground stairs; flying bees use aerial ramps).
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** If an insect is paused midway or planning moves across the terrace when day/night shifts, valid exit trajectories recalculate against the new floor connectivity.

### M852 — Sunlit Acorn (Push × Beams)
- **ID:** `M852`
- **Themed Name:** Sunlit Acorn (Generic: Movable Prism Block)
- **Category:** T / O — Mobile Optical Push Blocker
- **Intro Level:** **L8631** (Block 14 x1)
- **Rule:** Composition of Push Physics (Phase 5) and Light & Beams (Phase 6). Heavy acorn fitted with a precision quartz prism. Can be pushed 1 cell into adjacent unoccupied space by an insect. Whenever a solar beam intersects the acorn's current coordinate, the beam refracts $90^\circ$ clockwise.
- **Properties:**
  - `tall: per instance`.
  - `hammerable: true` (removable with Leaf Blower booster).
  - `non_monotone: true`.
- **Edge Cases:** Pushing an acorn into an existing beam line immediately recalculates illumination for all receptors on the same simulation step.

### M853 — Shaded Stairs (Beams × Floors)
- **ID:** `M853`
- **Themed Name:** Shaded Stairs (Generic: Illuminated Elevator)
- **Category:** T / O — Beam-Unlocked Vertical Link
- **Intro Level:** **L8751** (Block 26 x1)
- **Rule:** Composition of Light & Beams (Phase 6) and Multi-floor (Phase 4). Vertical portal shrouded in dark brambles. Remains locked and impassable while in shadow. Directing a matching solar beam across its entrance activates photosensitive blossoms, illuminating the stairs and opening transit to Floor 2.
- **Properties:**
  - `tall: layer-dependent`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** If an active beam illuminating the stairs is obstructed by another line, the stairs extinguish and revert to an impassable barrier on the subsequent move.

### M854 — Dawn Marble (Cycles × Push)
- **ID:** `M854`
- **Themed Name:** Dawn Marble (Generic: Cycle Phase Marble)
- **Category:** T / C — State-Dependent Sliding Block
- **Intro Level:** **L8871** (Block 38 x1)
- **Rule:** Composition of Cycles (Phase 3) and Push Physics (Phase 5). High-density polished dew marble. During Day phase ($A$), it exhibits frictionless sliding: pushed by an insect, it slides continuously in the pushed vector until striking an obstacle or board boundary. During Night phase ($B$), surface moisture solidifies: the marble locks firmly into its current cell as an immovable stone block.
- **Properties:**
  - `tall: per instance`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Attempting to push a Dawn Marble at Night bonks the insect and deducts 1 Heart (standard blocker collision).

---

## Verification Plan

### Automated Tests
1. Verify M851: floor transition occurs in Day state; no floor transition in Night state.
2. Verify M852: beam angle deflects $90^\circ$ clockwise upon prism intersection; updates upon cell displacement.
3. Verify M853: unilluminated stairs act as solid obstacle; illuminated stairs permit vertical passage.
4. Verify M854: slides to border/obstacle in Day; acts as fixed collision obstacle in Night.

### Manual Verification
1. Verify Day-Night Terrace visual animation smoothly retracts and ascends with diurnal shifts.
2. Verify sound effect for pushing Sunlit Acorn into a beam triggers optical resonance harmonic.
