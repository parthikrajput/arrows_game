Source docs: phase/phase_16/02_LEVEL_PLAN_7501_8000.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-16-signature-system.md, specs/gameplay/phase-16-base-mechanics.md.

# Spec: Gameplay — Phase 16 Level Plan (Levels 7501–8000)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 16 (Ticket Office: Levels 7501–8000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_16/02_LEVEL_PLAN_7501_8000.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 16 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L7501–7510):** Signature Intro (Ticket Office Keys Overview) at L7501.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L7511: M751 Ticket Chain
  - L7631: M752 Ticket Punch
  - L7751: M753 Master Pass
  - L7871: M754 Ticket Swap Pad
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L7991–8000):**
  - L7991: "Mastery Mix" Review Level (P1–P16 mechanics synthesis).
  - L8000: "Master Ticket Bureau Terminal" Phase 16 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 wooden railway tabletop grid.
- **Train Population:** 36 to 52 trains per level.
- **Tier Division:**
  - **Tier P16-A (L7501–7750):** 36–44 trains, $D \in [60.0, 68.0]$.
  - **Tier P16-B (L7751–8000):** 42–52 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_16_plan.dart` (to be created)

## Risks
- Misordered key collection causing unwinnable deadlocks. Mitigation: CI solver asserts 100% solvability and verifies topological DAG order across all 500 seeds.

## Open Questions
- None. Level schedule matches `phase/phase_16/02_LEVEL_PLAN_7501_8000.md`.
