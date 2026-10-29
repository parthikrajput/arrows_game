# Spec: Phase 13 Signature System — Mystery Meadow (Hidden Info)

Source docs: phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-12-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 Signature System — Mystery Meadow (Hidden Info) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Introduce imperfect information and reconnaissance gameplay to the garden: portions of the board are shrouded in morning mist that conceals lines and obstacles until uncovered by Scout Ants, Sunlit Plates, or exploration.

---

## Current State

Design documented in `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md` and `phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Mystery Meadow** (Hidden Info architecture).
- Volumetric fog conceals tiles; lines concealed under fog cannot be directly tapped ("Scout needed!").
- Chebyshev distance metric defines fog reveal radius ($\le 2$).
- Four base mechanics introduced: M601 Scout Ant, M602 Mirage Mist, M603 Painted Pebble, M604 Sunlit Plate.
- All prior phase mechanics (M001–M554) remain active under and outside fog.

---

## Proposed Change

### 1. Fog of War Mechanics & Tap Protection
- Cells marked as fogged are masked with a semi-opaque mist overlay ($40\%$ opacity).
- Concealed lines cannot be selected or dragged. Attempting to tap a shrouded line triggers a gentle shake with a tooltip banner: *"Scout needed!"*.
- Scent Trail Preview on visible lines reveals collision warnings with fogged boundaries.

### 2. Chebyshev Fog Radius Calculation (M601)
- When a Scout Ant (M601) exits the board, all cells within Chebyshev distance $\le 2$ from any coordinate along its traversed path are permanently cleared:
  $$\max(|x - x_{\text{path}}|, |y - y_{\text{path}}|) \le 2$$
- Uncovered lines instantly become interactive and fully rendered.

### 3. Persistent Row/Column Illumination (M604)
- When an ant line halts with any segment stationed upon a Sunlit Plate (M604), all cells along that plate's full orthogonal crosshairs (same row $y = y_{\text{plate}}$ and same column $x = x_{\text{plate}}$) are revealed and interactive.
- If the ant vacates the plate, unrevealed cells without permanent clearance return to fog shroud.

### 4. Illusionary Walls (M603)
- Painted Pebbles visually mimic standard rock blockers but possess no collision boundary.
- Insects pass directly through M603 without bonking (−0 Hearts). Upon traversal, the illusion shatters into clear terrain.

### 5. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player initiates move on an uncovered, active line.
2. Traversal evaluates:
   - Proximity to Mirage Mist (M602) generates dynamic 3×3 fog banks.
   - Passage through Painted Pebble (M603) dissolves false wall.
3. Exit evaluations fire:
   - If Scout Ant (M601), trigger Chebyshev radius $\le 2$ fog clearance.
4. Stationed pressure plate checks (M604) evaluate row/col reveals.
5. Board state written; fog mask bitmap texture re-composited (`p13_fog_dissolve_ms = 200`).

### Acceptance Criteria
- [ ] Concealed lines under fog cannot be tapped until revealed.
- [ ] Scout Ant exit clears all cells within Chebyshev radius 2 along its complete path.
- [ ] Mirage Mist triggers a 3×3 fog expansion upon orthogonal proximity.
- [ ] Painted Pebbles permit passage with zero heart loss.
- [ ] Sunlit Plate reveals entire row and column while an ant rests upon it.
- [ ] L6001 tutorial overlay fires: "Mystery Meadow — Morning fog hides garden paths. Send scouts to clear the way!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/mystery_meadow.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/scout_ant.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/mirage_mist.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/painted_pebble.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/sunlit_plate.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (fog updates) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (imperfect info tree) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `12` → `13` | Unlock Phase 13 content |
| `p13_fog_dissolve_ms` | `200` | Fog clearance transition speed |

---

## Risks and Open Questions

1. **Solver Determinism with Hidden Info:** The CI solver must know the full board topology upfront to verify solvability while ensuring human player constraints (cannot tap shrouded lines) are strictly adhered to in valid move sequences.
2. **GPU Fog Mask Performance:** Dynamic bitmap mask regeneration on 14×14 grids must strictly respect the $\le 0.3$ ms budget on low-tier mobile devices.
