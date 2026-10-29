Source docs: phase_2/02_LEVEL_PROGRESSION_0501_1000.md, SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/level-progression-0001-0500.md

# Spec: Level Progression (Levels 501–1000)

## Status
Draft

## Type
Improvement

## Goal
Specify the Phase 2 progression system covering Levels 501–1000, tier structures (P2-A and P2-B), the L501–510 zoom onboarding block, 49 Phase 2 mechanics introductions, and the Level 1000 Phase Finale for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/02_LEVEL_PROGRESSION_0501_1000.md and SHARED_CORE_STANDARD.md.
- Extends `specs/gameplay/level-progression-0001-0500.md`.
- Phase 1 culminated at Level 500 (Queen's Garden Gala).
- Phase 2 delivers 500 additional bundled levels (501–1000) via `assets/levels/phase_2.json.gz`.
- Grid scales up to 14x14; line counts scale up to 40; introduces 49 new mechanics (M051 to M099).

## Proposed Change
Implement the Phase 2 level progression and onboarding logic:

### 1. Phase 2 Tier Architecture
| Tier | Levels | Grid Range | Lines (P) | Max Obstacles (O) | Difficulty (D) Band |
|---|---|---|---|---|---|
| **P2-A** | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 |
| **P2-B** | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

- Progression difficulty never drops below previous tier mid-point ($D \ge 45$ maintained across transition).
- Board cell size dynamically adjusts with pinch-zoom support on all grids >= 12x12.

### 2. Zoom Onboarding Block (Levels 501–510)
Levels 501–510 use 12x12 boards with familiar Phase 1 mechanics only (no new mechanics), focusing strictly on gesture mastery:
- **L501 (12×12, 24 lines, D 45):** Pinch-to-zoom tutorial. Animated gesture overlay prompts: "Pinch with two fingers to zoom in on crowded trails."
- **L502 (12×12, 25 lines, D 45):** Pan gesture tutorial. "Drag with one finger while zoomed to inspect distant garden gates."
- **L503 (12×12, 26 lines, D 46):** Fit button tutorial. "Tap the 🔍 icon in the HUD to instantly fit the entire garden."
- **L504–L508:** Practice zoomable boards with mixed ant and bee lines.
- **L509 (12×12, 28 lines, D 47):** Hard level (red badge, +10% target difficulty).
- **L510 (12×12, 28 lines, D 46):** Milestone level awarding Queen's Gift Box (300 coins + 1 booster).

### 3. Layer and Feature Integration Schedule
- **L511 (M051 Diagonal Lines):** Introduces diagonal movement (`UL, UR, DL, DR`).
- **L531 (M053 Rolling Acorn):** Introduces push physics.
- **L691 (M069 Canopy Scout Bees):** Introduces the 3rd layer (`layer: 2`, Canopy).
- **L841 (M084 Solar Lens):** Introduces sunbeams and light receiver mechanics.
- **L991 (M099 Hive Queen's Scepter):** Master puzzle item unifying 3 layers, beams, and push blocks.

### 4. 10-Level Block Cadence in Phase 2
- **x1 (Intro):** Introduces new mechanic (M051 at L511, M052 at L521, etc.). Tag: `normal` (20 coins).
- **x2–x4 (Practice):** Blends new mechanic with existing systems. Tag: `normal` (20 coins).
- **x5 (Breather):** Reduced density, straightforward chains. Tag: `easy` (15 coins).
- **x6–x8 (Ramp):** Multi-layer and diagonal complexity. Tag: `normal` (20 coins).
- **x9 (Hard):** Red badge on map/HUD, +10% difficulty. Tag: `hard` (30 coins).
- **x0 (Milestone):** Awards enhanced **Queen's Gift Box** (300 coins + rotating booster).
- **Golden Nectar Rush:** Triggered every 25 levels cleared, featuring 30 lines on an 11x11 board.

### 5. Level 1000 Phase Finale: "Queen's Midsummer Jubilee"
- **Grid:** 14×14 grand festival layout.
- **Lines:** 40 lines spanning all 3 layers (Ants, Bees, Canopy Scouts) with orthogonal and diagonal paths.
- **Boss Encounter:** Features the Patrolling Great Stag Beetle (M098) guarding central solar receivers.
- **Completion Reward:** Awards the **Royal Honey Chest**:
  - 1,000 coins
  - 2 Nectar Glow Hints, 2 Queen's Royal Shields, 2 Leaf Blowers
  - Exclusive "Jubilee Champion" cosmetic insect frame and title badge.

## Affected Files
- `apps/ants_bees/assets/levels/phase_2.json.gz` (bundled asset pack)
- `packages/puzzle_core/lib/src/engine/level_validator.dart` (to be updated for Phase 2 limits)
- `apps/ants_bees/lib/features/gameplay/data/level_repository.dart` (to load Phase 2 levels)

## Risks
- High line count (up to 40) on 14x14 boards could exceed memory budgets if path metrics are not pooled.

## Open Questions
- None. Block allocations and tier difficulty metrics follow SHARED_CORE_STANDARD.md §9 and §11.
