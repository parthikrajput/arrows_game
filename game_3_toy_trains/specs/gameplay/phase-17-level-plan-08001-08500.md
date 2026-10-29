Source docs: phase/phase_17/02_LEVEL_PLAN_8001_8500.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-17-signature-system.md, specs/gameplay/phase-17-base-mechanics.md.

# Spec: Gameplay — Phase 17 Level Plan (Levels 8001–8500)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 17 (Clock Towers: Levels 8001–8500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_17/02_LEVEL_PLAN_8001_8500.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 17 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L8001–8010):** Signature Intro (Clock Towers Guardian Overview) at L8001.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L8011: M801 Twin Clock Towers
  - L8131: M802 Armoured Clock Tower
  - L8251: M803 Depot Tower
  - L8371: M804 Clock Core
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L8491–8500):**
  - L8491: "Mastery Mix" Review Level (P1–P17 mechanics synthesis).
  - L8500: "Citadel of the Grand Clock Tower" Phase 17 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 clockwork citadel tabletop grid.
- **Train Population:** 36 to 52 trains per level.
- **Tier Division:**
  - **Tier P17-A (L8001–8250):** 36–44 trains, $D \in [60.0, 68.0]$.
  - **Tier P17-B (L8251–8500):** 42–52 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_17_plan.dart` (to be created)

## Risks
- Boss tower placement obstructing central puzzle corridor. Mitigation: Generator places guardian towers strictly in non-critical perimeter or dedicated central square blocks.

## Open Questions
- None. Level schedule matches `phase/phase_17/02_LEVEL_PLAN_8001_8500.md`.
