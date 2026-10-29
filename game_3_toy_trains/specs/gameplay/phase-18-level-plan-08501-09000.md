Source docs: phase/phase_18/02_LEVEL_PLAN_8501_9000.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-18-signature-system.md, specs/gameplay/phase-18-base-mechanics.md.

# Spec: Gameplay — Phase 18 Level Plan (Levels 8501–9000)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 18 (Remix A: Levels 8501–9000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_18/02_LEVEL_PLAN_8501_9000.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 18 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L8501–8510):** Signature Intro (Remix A Early Era Synergy Overview) at L8501.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Combo Mechanic Intros:
  - L8511: M851 Day/Night Ticket Cart
  - L8631: M852 Station Floor Shunting Lift
  - L8751: M853 Prism Signal Sensor
  - L8871: M854 Ice Cart Blackout Chute
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L8991–9000):**
  - L8991: "Mastery Mix" Review Level (P1–P18 mechanics synthesis).
  - L9000: "Grand Terminus of the First Era" Phase 18 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 composite multi-floor wooden grid.
- **Train Population:** 36 to 52 trains per level.
- **Tier Division:**
  - **Tier P18-A (L8501–8750):** 36–44 trains, $D \in [60.0, 68.0]$.
  - **Tier P18-B (L8751–9000):** 42–52 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_18_plan.dart` (to be created)

## Risks
- Synergies creating unexpected path short-circuits. Mitigation: Solver validates that all required multi-step trigger dependencies are traversed in order.

## Open Questions
- None. Level schedule matches `phase/phase_18/02_LEVEL_PLAN_8501_9000.md`.
