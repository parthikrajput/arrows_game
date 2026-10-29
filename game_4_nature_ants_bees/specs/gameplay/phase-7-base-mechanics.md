Source docs: phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 7 Base Mechanics (M301–M304)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 7 (Levels 3001–3500) in Ants & Bees: Garden Trails: Flower-Bed Turntable (M301), Turning Hedge (M302), Spinning Top Line (M303), and Pinned Daisy (M304).

## Current State
Design documented in `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Previous phases featured fixed grid geometry and static boundary exit gaps.
- Sub-board rotating circular beds, perimeter shifting walls, dynamic spinning orientation lines, and rotation-locking anchor flowers do not exist.

## Proposed Change
Implement M301–M304 in `packages/puzzle_core` with deterministic rotational logic:

### 1. M301 — Flower-Bed Turntable (Sub-board Rotor)
- **ID:** `M301` | **Category:** T / C (Interactive Rotating Grid) | **Intro Level:** `L3011` (Block 2 x1).
- **Rule:**
  - A $4\times 4$ or $5\times 5$ circular floral garden bed.
  - Features an interactive center button. Tapping the button costs 1 Move and rotates all contained lines, push blocks, and obstacles $90^\circ$ clockwise.
  - If any insect line crosses the turntable boundary, or if a Pinned Daisy (M304) is present inside, the button is locked (produces locked tap wobble, 0 moves consumed).
- **Layer & Collision Rules:**
  - Rotates all layers (ants, worker bees, canopy bees) within the sector.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

### 2. M302 — Turning Hedge (Rotating Edges)
- **ID:** `M302` | **Category:** B / T (Perimeter Moving Blocker) | **Intro Level:** `L3131` (Block 14 x1).
- **Rule:**
  - Thorny hedge walls lining the outer perimeter of the board.
  - Every $N$ player Moves ($N = 2$ or $3$), the hedges shift 1 cell clockwise along the board's edge.
  - Shifting walls dynamically relocate open exit gaps, requiring the player to time insect departures when the exit is aligned.
- **Layer & Collision Rules:**
  - Ground ants blocked by standard hedge; when `tall: true`, also blocks worker bees and canopy scouts.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

### 3. M303 — Spinning Top Line (Spin Path)
- **ID:** `M303` | **Category:** P (Dynamic Direction Insect Line) | **Intro Level:** `L3251` (Block 26 x1).
- **Rule:**
  - An insect line fitted with spinning flower-propeller wings.
  - On any turn where the player makes a move with another line or turntable, this line's direction automatically rotates $90^\circ$ clockwise.
  - The player must plan turns in advance so the line faces an open exit lane when ready to move.
- **Layer & Collision Rules:**
  - Can be either ground ants or air bees.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

### 4. M304 — Pinned Daisy (Rotation Lock)
- **ID:** `M304` | **Category:** K / D (Rotation Immune Anchor) | **Intro Level:** `L3371` (Block 38 x1).
- **Rule:**
  - A deeply rooted white daisy pinned to an insect line.
  - Immune to all rotation effects: cannot be rotated by turntables or spin effects.
  - If located inside a Flower-Bed Turntable (M301), it completely anchors the turntable, preventing it from rotating until the pinned line exits the sector.
- **Layer & Collision Rules:**
  - Can pin ground ants or worker bees.
- **Hammerable:** No. | **Non-Monotone (N):** Yes.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m301_flowerbed_turntable.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m302_turning_hedge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m303_spinning_top_line.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m304_pinned_daisy.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/mechanic_registry.dart` (registered M301–M304)

## Risks
- Scent Trail Preview calculating incorrect direction for Spinning Top Lines. Mitigated by evaluating instantaneous direction for the current move.

## Open Questions
- None. Rules, parameters, and intro levels strictly match `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md`.
