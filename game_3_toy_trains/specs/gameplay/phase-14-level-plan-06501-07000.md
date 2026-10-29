Source docs: phase/phase_14/02_LEVEL_PLAN_6501_7000.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-14-base-mechanics.md.

# Spec: Gameplay — Phase 14 Level Plan (Levels 6501–7000)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 14 (Alpine Pass: Levels 6501–7000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_14/02_LEVEL_PLAN_6501_7000.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 14 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L6501–6510):** Signature Intro (Alpine Pass Reflection Overview) at L6501.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L6511: M651 Mirror Rail Axis
  - L6631: M652 Reflection Lock
  - L6751: M653 Alpine Twin Yard
  - L6871: M654 Reverse Engine
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L6991–7000):**
  - L6991: "Mastery Mix" Review Level (P1–P14 mechanics synthesis).
  - L7000: "Great Alpine Pass Mountain Junction" Phase 14 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 symmetrical wooden railway tabletop grid.
- **Train Population:** 36 to 50 trains per level.
- **Tier Division:**
  - **Tier P14-A (L6501–6750):** 36–44 trains, $D \in [60.0, 68.0]$.
  - **Tier P14-B (L6751–7000):** 42–50 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_14_plan.dart` (to be created)

## Risks
- Symmetrical board layouts becoming visually repetitive. Mitigation: Organic alpine terrain obstacles (ice boulders, pine trees) vary asymmetric decorative patterns outside active rails.

## Open Questions
- None. Level schedule matches `phase/phase_14/02_LEVEL_PLAN_6501_7000.md`.
