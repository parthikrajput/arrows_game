Source docs: phase/phase_15/02_LEVEL_PLAN_7001_7500.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-15-signature-system.md, specs/gameplay/phase-15-base-mechanics.md.

# Spec: Gameplay — Phase 15 Level Plan (Levels 7001–7500)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 15 (Moving Platforms: Levels 7001–7500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_15/02_LEVEL_PLAN_7001_7500.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 15 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L7001–7010):** Signature Intro (Moving Platforms Conveyors Overview) at L7001.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L7011: M701 Belt Switch
  - L7131: M702 Reversing Belt
  - L7251: M703 Belt Stop Lever
  - L7371: M704 Loop Belt
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L7491–7500):**
  - L7491: "Mastery Mix" Review Level (P1–P15 mechanics synthesis).
  - L7500: "Automated Transshipment Yard" Phase 15 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 mechanized wooden tabletop grid.
- **Train Population:** 36 to 50 trains per level.
- **Tier Division:**
  - **Tier P15-A (L7001–7250):** 36–44 trains, $D \in [60.0, 68.0]$.
  - **Tier P15-B (L7251–7500):** 42–50 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_15_plan.dart` (to be created)

## Risks
- Rapid conveyor movement overwhelming player reaction. Mitigation: Turn-based tick system guarantees conveyors shift only after deliberate player moves.

## Open Questions
- None. Level schedule matches `phase/phase_15/02_LEVEL_PLAN_7001_7500.md`.
