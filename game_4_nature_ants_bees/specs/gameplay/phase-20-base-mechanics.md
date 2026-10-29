# Spec: Phase 20 Base Mechanics — Grand Combo Mechanics (M951–M954)

Source docs: phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, SCALING_TO_10000_LEVELS.md §6, SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-20-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 Base Mechanics — Grand Combo Mechanics (M951–M954) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define the detailed rules, parameters, edge cases, solver constraints, and introduction levels for the four Grand Combo mechanics of Phase 20: Eternal Bloom Canopy (M951), Twin Cascade Nexus (M952), Shrouded Guardian Aegis (M953), and Prismatic Rhythm Turntable (M954).

---

## Current State

Design documented in `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md` and `SCALING_TO_10000_LEVELS.md §6`, not yet implemented.

---

## Proposed Change

### M951 — Eternal Bloom Canopy (Pool P3–P8 Combo)
- **ID:** `M951`
- **Themed Name:** Eternal Bloom Canopy (Generic: Cyclical Growth Flora)
- **Category:** B / T — Cyclic Spreading Barrier
- **Intro Level:** **L9511** (Block 2 x1)
- **Rule:** Composition of Cycles (Phase 3) and Growth (Phase 8). Cyclical spreading floral vines that rotate through distinct biological phases (Sprouting $\to$ Full Bloom $\to$ Withered). In the Withered phase, vines are harmlessly passable. In the Full Bloom phase, they act as an impassable barrier and sprout outward into adjacent free cells. Can be trimmed for 1 cycle with Garden Shears (M352) or Leaf Blower.
- **Properties:**
  - `tall: true` (affects ground ants and low-flying bees).
  - `hammerable: true` (via Leaf Blower).
  - `non_monotone: true`.
- **Edge Cases:** If an insect is paused midway through an empty tile when bloom expansion triggers on that tile, the insect is halted and 1 Heart is lost.

### M952 — Twin Cascade Nexus (Pool P9–P12 Combo)
- **ID:** `M952`
- **Themed Name:** Twin Cascade Nexus (Generic: Linked Gravitational Swarm Fork)
- **Category:** T / G — Multi-Board Gravity Splitter
- **Intro Level:** **L9631** (Block 14 x1)
- **Rule:** Composition of Linked Boards (Phase 11), Split/Merge (Phase 9), and Gravity (Phase 12). Split node positioned at the boundary threshold between Board A and Board B. When an insect line traverses this nexus, it divides into two independent halves: Branch 1 descends with Board A's downward gravitational slope; Branch 2 teleports through a spatial nexus onto Board B and rides Board B's lateral/upward gravitational flow.
- **Properties:**
  - `tall: per instance`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Both gravity trajectories on both boards must remain completely unobstructed; a collision on either board halts the entire swarm action and deducts 1 Heart.

### M953 — Shrouded Guardian Aegis (Pool P13–P17 Combo)
- **ID:** `M953`
- **Themed Name:** Shrouded Guardian Aegis (Generic: Shrouded Guardian Lockgate)
- **Category:** O / B — Hidden Key-Locked Heavy Boss Barrier
- **Intro Level:** **L9751** (Block 26 x1)
- **Rule:** Composition of Mystery Fog (Phase 13), Royal Keys (Phase 16), and Guardians (Phase 17). Colossal $2\times 2$ guardian hornet shrouded in thick impenetrable garden mist. The guardian's heavy armor is secured by 3 Royal Dew Keys hidden beneath surrounding fog patches. Ground ants must clear the fog and retrieve all 3 keys to shatter the armor and allow line exits to pass.
- **Properties:**
  - `tall: true` (blocks all 3 layers).
  - `hammerable: false`.
  - `non_monotone: false`.
- **Edge Cases:** Clearing fog without collecting all 3 keys reveals the guardian's HP bar but keeps the armor carapace active.

### M954 — Prismatic Rhythm Turntable (Pool P18–P19 Combo)
- **ID:** `M954`
- **Themed Name:** Prismatic Rhythm Turntable (Generic: Multi-Kinetic Prismatic Rotor)
- **Category:** T / C — Synchronized Light-Bending Turntable
- **Intro Level:** **L9871** (Block 38 x1)
- **Rule:** Composition of Sunlit Beams (Phase 6), Whirling Rotors (Phase 7), and Rhythm Sequencing (Phase 10). A massive $4\times 4$ turntable platform fitted with optical prisms. Automatically rotates $90^\circ$ clockwise every 4 player moves. Each rotation alters the angles of all light beams striking the turntable, dynamically opening and closing photosensitive gates across the entire grid.
- **Properties:**
  - `tall: grid region`.
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Pushing an insect across the turntable during a non-rotation turn must account for future beam realignments.

---

## Verification Plan

### Automated Tests
1. Verify M951: passable during Withered state; blocks and expands during Full Bloom state.
2. Verify M952: divides line into dual streams on Board A and Board B, adhering to independent local gravity flows.
3. Verify M953: requires exactly 3 hidden keys to strip guardian armor; rejects damage before keys are assembled.
4. Verify M954: rotates $90^\circ$ CW every 4 moves and updates beam raycast angles across the board.

### Manual Verification
1. Inspect visual feedback on Prismatic Rhythm Turntable when light beams refract across rotating crystal facets.
2. Verify sound effect for shattering Shrouded Guardian Aegis plays a multi-layered royal chime.
