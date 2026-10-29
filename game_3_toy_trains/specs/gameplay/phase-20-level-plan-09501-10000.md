Source docs: phase/phase_20/02_LEVEL_PLAN_9501_10000.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-20-signature-system.md, specs/gameplay/phase-20-base-mechanics.md.

# Spec: Gameplay — Phase 20 Level Plan (Levels 9501–10000)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the final 500 levels of Phase 20 (Grand Master: Levels 9501–10000), culminating in the historic Level 10,000 Climax Boss for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_20/02_LEVEL_PLAN_9501_10000.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 20 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L9501–9510):** Signature Intro (Grand Master Omni-Convergence Overview) at L9501.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Supreme Combo Mechanic Intros:
  - L9511: M951 Clockwork Conveyor Guardian
  - L9631: M952 Gravity Mirror Relay
  - L9751: M953 Day/Night Ticket Master Pass
  - L9871: M954 Prism Bloom Arch
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L9991–10000):**
  - L9991: "The Grand Review Concourse" (All 19 systems synthesis).
  - L10000: "The Grand Sovereign Terminus" — The Marching Clock Tower Climax Boss ($D \approx 91.0$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels (L9501–9990).
- **Finale Climax:** Level 10000 targets peak design difficulty $D \approx 91.0$.
- **Board Dimensions:** 14×14 ultimate wooden railway layout.
- **Train Population:** 40 to 56 trains per level (L10000: 56 trains).
- **Tier Division:**
  - **Tier P20-A (L9501–9750):** 40–48 trains, $D \in [60.0, 68.0]$.
  - **Tier P20-B (L9751–10000):** 46–56 trains, $D \in [68.0, 76.0]$ (L10000: $D \approx 91$).

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_20_plan.dart` (to be created)

## Risks
- Level 10000 performance drop with 56 simultaneous train paths and marching 3x3 boss. Mitigation: Rigid spatial hashing and static geometry batching.

## Open Questions
- None. Level schedule matches `phase/phase_20/02_LEVEL_PLAN_9501_10000.md`.
