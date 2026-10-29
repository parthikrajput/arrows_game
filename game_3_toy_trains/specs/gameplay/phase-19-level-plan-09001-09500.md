Source docs: phase/phase_19/02_LEVEL_PLAN_9001_9500.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-19-signature-system.md, specs/gameplay/phase-19-base-mechanics.md.

# Spec: Gameplay — Phase 19 Level Plan (Levels 9001–9500)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 19 (Remix B: Levels 9001–9500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_19/02_LEVEL_PLAN_9001_9500.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 19 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L9001–9010):** Signature Intro (Remix B Mid-Era Synergy Overview) at L9001.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Combo Mechanic Intros:
  - L9011: M901 Turntable Coupling Pad
  - L9131: M902 Incline Seed Wagon
  - L9251: M903 Cross-Table Metronome Gate
  - L9371: M904 Hedge-Trimming Split Train
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L9491–9500):**
  - L9491: "Mastery Mix" Review Level (P1–P19 mechanics synthesis).
  - L9500: "Mid-Era Alpine Concourse" Phase 19 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** 12×12 to 14×14 composite kinetic wooden grid.
- **Train Population:** 38 to 54 trains per level.
- **Tier Division:**
  - **Tier P19-A (L9001–9250):** 38–46 trains, $D \in [60.0, 68.0]$.
  - **Tier P19-B (L9251–9500):** 44–54 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_19_plan.dart` (to be created)

## Risks
- Extreme puzzle complexity from simultaneous kinetic elements. Mitigation: Solver validates move count $\le 45$ moves on all seeds.

## Open Questions
- None. Level schedule matches `phase/phase_19/02_LEVEL_PLAN_9001_9500.md`.
