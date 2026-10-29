# Spec: Phase 17 Base Mechanics — Garden Guardians (M801–M804)

Source docs: phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, SCALING_TO_10000_LEVELS.md §6, SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-17-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 Base Mechanics — Garden Guardians (M801–M804) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define the detailed rules, parameters, edge cases, solver constraints, and introduction levels for the four new Phase 17 base mechanics: Twin Hornets (M801), Armored Rhino Beetle (M802), Wasp Nest Guardian (M803), and Heart-Seed Guardian (M804).

---

## Current State

Design documented in `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md` and `SCALING_TO_10000_LEVELS.md §6`, not yet implemented.

---

## Proposed Change

### M801 — Twin Hornets (Twin Guardian)
- **ID:** `M801`
- **Themed Name:** Twin Hornets (Generic: Twin Guardian)
- **Category:** B / G — Shared HP Dual Boss
- **Intro Level:** **L8011** (Block 2 x1)
- **Footprint:** Two independent $2\times 2$ entities placed on the board.
- **Rule:** Both hornets share an identical single `hp` pool (typically 4 or 6 HP). Whenever an insect designated to attack the hornets exits the board safely, the shared HP decreases by 1. When `hp == 0`, both hornets disintegrate in unison, simultaneously freeing all 8 occupied cells.
- **Properties:**
  - `tall: true` (fixed; blocks ground and airborne insects).
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** If a booster or simultaneous multi-line exit triggers multiple hits on the same frame, HP decrements by total hits without underflowing below 0.

### M802 — Armored Rhino Beetle (Shield Guardian)
- **ID:** `M802`
- **Themed Name:** Armored Rhino Beetle (Generic: Shield Guardian)
- **Category:** B / G — Shielded Boss Blocker
- **Intro Level:** **L8131** (Block 14 x1)
- **Footprint:** Single $2\times 2$ entity.
- **Rule:** Features heavy stone carapace providing absolute damage immunity. Exiting insects deal zero damage while carapace is active. Pulling an associated Ivy Lever / switch cracks and sheds the armor, setting `armored = false` and allowing subsequent line exits to decrement HP normally.
- **Properties:**
  - `tall: true` (fixed).
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** Re-toggling the lever (if multi-state) does not restore shattered armor unless explicitly configured with a regenerating modifier.

### M803 — Wasp Nest Guardian (Spawner Guardian)
- **ID:** `M803`
- **Themed Name:** Wasp Nest Guardian (Generic: Spawner Guardian)
- **Category:** B / T — Periodic Obstacle Spawner
- **Intro Level:** **L8251** (Block 26 x1)
- **Footprint:** Single $2\times 2$ hanging nest entity.
- **Rule:** Every $N$ player moves (default $N = 4$, configurable 3–6), the nest deposits a 1-cell mud obstacle in the first empty cell adjacent to its perimeter searching in order: Up $\to$ Right $\to$ Down $\to$ Left. Exiting designated lines damages the nest HP; upon defeat ($\text{hp} = 0$), spawning halts permanently.
- **Properties:**
  - `tall: true` (fixed).
  - `hammerable: false` (Nest cannot be hammered; spawned 1-cell mud blockers can be removed with Leaf Blower).
  - `non_monotone: true`.
- **Edge Cases:** If all adjacent neighbor perimeter cells are completely occupied when spawn triggers, the spawn event is skipped for that cycle.

### M804 — Heart-Seed Guardian (Guardian Core)
- **ID:** `M804`
- **Themed Name:** Heart-Seed Guardian (Generic: Guardian Core)
- **Category:** B / G — Precision Core Target Guardian
- **Intro Level:** **L8371** (Block 38 x1)
- **Footprint:** Single $2\times 2$ entity with an internal anchor Core Tile.
- **Rule:** Normal line exits do not damage this guardian. Only lines whose straight linear exit vector directly passes through the designated central Core Tile deal 1 point of damage to its HP.
- **Properties:**
  - `tall: true` (fixed).
  - `hammerable: false`.
  - `non_monotone: true`.
- **Edge Cases:** A line grazing the outer 3 cells of the $2\times 2$ footprint without intersecting the exact Core Tile coordinates registers a normal clear but does NOT decrement the guardian's HP.

---

## Verification Plan

### Automated Tests
1. Verify M801: 2 bodies share HP, both vanish when HP reaches 0.
2. Verify M802: HP is invariant to line exits until lever interaction occurs.
3. Verify M803: Counter decrements each player move; blocker spawns strictly into first empty adjacent cell (U-R-D-L priority).
4. Verify M804: Trajectory check accurately isolates core cell intersection vs perimeter transit.

### Manual Verification
1. Inspect UI feedback when attacking Armored Rhino Beetle while shielded (clang metallic audio + visual bounce).
2. Verify Mud Blocker spawn animation does not interrupt or delay user input.
