Source docs: phase/phase_11/02_LEVEL_PLAN_5001_5500.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.34. Depends on: specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-11-base-mechanics.md.

# Spec: Gameplay — Phase 11 Level Plan (Levels 5001–5500)

## Status
Draft

## Type
New Feature

## Goal
Specify the level generation plan, cadence map, slot allocations, and tier difficulty bounds for the 500 levels of Phase 11 (Twin Tables: Levels 5001–5500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_11/02_LEVEL_PLAN_5001_5500.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the Phase 11 slot allocation and generator parameters in `tools/levelgen`:

### 1. Cadence & Slot Architecture
50 blocks × 10 levels = 500 levels:
- **Block 1 (L5001–5010):** Signature Intro (Twin Tables Dual Sub-boards) at L5001.
- **Blocks 2, 14, 26, 38 (x1 levels):** 4 Base Mechanic Intros:
  - L5011: M501 Table Bridge
  - L5131: M502 Inter-table Ticket
  - L5251: M503 Mirror Table
  - L5371: M504 Relay Tunnel
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1 levels):** 45 Variant Slots.
- **Block 50 (L5491–5500):**
  - L5491: "Mastery Mix" Review Level (P1–P11 mechanics synthesis).
  - L5500: "Twin Grand Central Terminals" Phase 11 Finale ($D \approx 91$).

### 2. Difficulty Plateau & Parameters
- **Plateau Window:** Difficulty strictly bounded within $D \in [60.0, 76.0]$ across procedural levels.
- **Board Dimensions:** Dual 8×8 to 9×9 sub-boards rendered concurrently.
- **Train Population:** 34 to 46 trains per level.
- **Tier Division:**
  - **Tier P11-A (L5001–5250):** 34–40 trains, $D \in [60.0, 68.0]$.
  - **Tier P11-B (L5251–5500):** 38–46 trains, $D \in [68.0, 76.0]$.

### 3. Level Block Cadence (x1–x0)
- `x1`: New Intro / Variant debut (Difficulty D).
- `x2–x4`: Procedural ramp-up (D to D + 4).
- `x5`: Breather level (Difficulty D - 6).
- `x6–x8`: Complex multi-mechanic layout (D + 4 to D + 8).
- `x9`: Hard Challenge with Red Badge (Difficulty D + 10).
- `x0`: Milestone level unlocking Conductor's Gift Crate (300 coins + 1 booster).

## Affected Files
- `tools/levelgen/lib/src/plans/phase_11_plan.dart` (to be created)

## Risks
- Dual boards overcrowding screen space on mobile viewports. Mitigation: Auto-fit camera with smooth pinch-to-zoom support.

## Open Questions
- None. Level schedule matches `phase/phase_11/02_LEVEL_PLAN_5001_5500.md`.
