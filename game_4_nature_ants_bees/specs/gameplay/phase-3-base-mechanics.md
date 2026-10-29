Source docs: phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-3-signature-system.md, specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 3 Base Mechanics (M101–M104)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 3 (Levels 1001–1500) in Ants & Bees: Garden Trails: Sunrise Gate (M101), Moonlit Twig Bridge (M102), Dawn Burrow (M103), and Day-Bloom Line (M104).

## Current State
Design documented in `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Previous gates, bridges, and portals were either static, key-locked, or operated on individual move counters.
- Cyclic terrain mechanisms synchronized with the global 5-move day/night state machine do not exist in the engine.

## Proposed Change
Implement M101–M104 in `packages/puzzle_core` with deterministic state updates driven by `CycleState`:

### 1. M101 — Sunrise Gate (Cycle Gate)
- **ID:** `M101` | **Category:** B (Static Blocker / Gate) | **Intro Level:** `L1011` (Block 2 x1).
- **Rule:**
  - Open in State A (Day); closed in State B (Night) as floral petals fold inward.
  - Optional parameter `params.openIn: "B"` reverses behavior (Moonrise Gate).
- **Layer & Collision Rules:**
  - When closed, blocks ground ant lanes (`layer: 0`).
  - When `tall: true`, also blocks air worker bees (`layer: 1`) and canopy scout bees (`layer: 2`).
  - When open, all layers pass through freely.
- **Hammerable:** No (Leaf Blower cannot blow away structural stone/flower gates).
- **Non-Monotone (N):** Yes (opens and closes repeatedly).

### 2. M102 — Moonlit Twig Bridge (Cycle Bridge)
- **ID:** `M102` | **Category:** L (Layer / Bridge) | **Intro Level:** `L1131` (Block 14 x1).
- **Rule:**
  - In State B (Night), lunar luminescence forms an elevated over/under crossing allowing intersecting orthogonal paths to cross without colliding.
  - In State A (Day), the bridge dematerializes into flat ground; paths intersecting at that cell collide and bonk.
- **Layer & Collision Rules:**
  - Ant-only ground mechanic (`tall: false` fixed).
  - Worker bees and canopy bees fly over the cell unobstructed in both states.
- **Hammerable:** No.
- **Non-Monotone (N):** Yes.

### 3. M103 — Dawn Burrow (Cycle Portal)
- **ID:** `M103` | **Category:** D (Directional / Portal) | **Intro Level:** `L1251` (Block 26 x1).
- **Rule:**
  - Linked portal pair `(entry, exit)` active only in State A (Day).
  - In State B (Night), burrows seal tight; entering lines cannot tunnel through and treat the cells as regular walkable ground tiles with no teleportation.
- **Layer & Collision Rules:**
  - Affects ground ants (`layer: 0`).
  - Bees fly over burrows unaffected (`tall: false` fixed).
- **Hammerable:** No.
- **Non-Monotone (N):** Yes.

### 4. M104 — Day-Bloom Line (Cycle Color)
- **ID:** `M104` | **Category:** P (Path-Variant) | **Intro Level:** `L1371` (Block 38 x1).
- **Rule:**
  - The line dynamically transforms its color identity and head glyph between cycles: `colorA` in State A (Day) $\leftrightarrow$ `colorB` in State B (Night).
  - Downstream Color Gates (M021), Petal Baskets (M026), and Color Receptors evaluate the line's instantaneous active color upon arrival.
- **Layer & Collision Rules:**
  - Applies to both ground ant lines and air bee lines.
- **Hammerable:** Yes (treated as a standard line removable by Leaf Blower).
- **Non-Monotone (N):** Yes.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m101_sunrise_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m102_moonlit_bridge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m103_dawn_burrow.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m104_day_bloom_line.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/mechanic_registry.dart` (registered M101–M104)

## Risks
- Path prediction desynchronization: Scent Trail Preview must calculate future cycle state when previewing a multi-step move across cyclic gates or bridges.

## Open Questions
- None. All parameters, intro levels, and collision rules are strictly aligned with `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.
