Source docs: phase/phase_12/02_LEVEL_PLAN_5501_6000.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-12-base-mechanics.md.

# Spec: Gameplay — Phase 12 Level Plan (Levels 5501–6000)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 12 (Hill Line: Levels 5501–6000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_12/02_LEVEL_PLAN_5501_6000.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 12 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L5501–5510):** Signature Intro (Hill Line Incline Overview) at L5501.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L5511: M551 Tilt Lever
  - L5631: M552 Loose Crates
  - L5751: M553 Balloon Pad
  - L5871: M554 Ballast Train
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L5991–6000):**
  - L5991: "Mastery Mix" Review Level (P1–P12 mechanics synthesis).
  - L6000: "Hill Climb Mountain Terminal" Phase 12 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 sloped wooden tabletop grid.
- **Train Population:** 34 to 46 trains per level.
- **Tier Division:**
  - **Tier P12-A (L5501–5750):** 34–40 trains, $D \in [60.0, 68.0]$.
  - **Tier P12-B (L5751–6000):** 38–46 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_12_plan.dart` (to be created)

## Risks
- Rapid difficulty spikes when combining crates with tight siding tracks. Mitigation: Solver validates at least 2 distinct safe siding bays per level.

## Open Questions
- None. Level schedule matches `phase/phase_12/02_LEVEL_PLAN_5501_6000.md`.
