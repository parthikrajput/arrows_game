Source docs: phase/phase_13/02_LEVEL_PLAN_6001_6500.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-13-base-mechanics.md.

# Spec: Gameplay — Phase 13 Level Plan (Levels 6001–6500)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 13 (Weather Station: Levels 6001–6500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_13/02_LEVEL_PLAN_6001_6500.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 13 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L6001–6010):** Signature Intro (Weather Station Fog Overview) at L6001.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L6011: M601 Scout Draisine
  - L6131: M602 Mirage Steam
  - L6251: M603 Painted Backdrop
  - L6371: M604 Lantern Plate
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L6491–6500):**
  - L6491: "Mastery Mix" Review Level (P1–P13 mechanics synthesis).
  - L6500: "Weather Station Observatory Terminal" Phase 13 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 wooden railway tabletop grid.
- **Train Population:** 34 to 48 trains per level.
- **Tier Division:**
  - **Tier P13-A (L6001–6250):** 34–42 trains, $D \in [60.0, 68.0]$.
  - **Tier P13-B (L6251–6500):** 40–48 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_13_plan.dart` (to be created)

## Risks
- Obscured exits causing dead-end moves. Mitigation: Generator guarantees at least 1 scout draisine is available at initial board state.

## Open Questions
- None. Level schedule matches `phase/phase_13/02_LEVEL_PLAN_6001_6500.md`.
