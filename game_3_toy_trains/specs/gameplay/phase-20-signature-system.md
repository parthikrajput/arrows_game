Source docs: phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-19-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 20 Signature System (Grand Master Omni-System Convergence)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 20 signature system "Grand Master" (Omni-System Convergence `S20`): the ultimate convergence of all 19 preceding signature systems, culminating in the historic Level 10,000 Climax Boss "The Marching Clock Tower" on a 14x14 grid for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md`, `phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases developed individual and paired system synergies.
- Phase 20 unifies all 19 systems into an omni-system engine resolving Day/Night cycles, multi-floors, push physics, optical beams, turntables, ivy growth, splitting trains, timetables, twin tables, gravity inclines, fog of war, reflections, conveyors, ticket networks, and guardian clock towers.

## Proposed Change
Extend `packages/puzzle_core` with the omni-system engine and marching boss mechanics:

### 1. Omni-System Convergence Architecture
- Unified turn pipeline executing strictly ordered phases:
  - **Step 1 (Player Action):** Direct taps, train dispatches, switch flips, split commands.
  - **Step 2 (Passive Triggers):** Beam raycasts, key crafting, ticket unlocks, sensor activations.
  - **Step 3 (Mechanic Ticks):** Conveyor shifts, gravity sliding, ivy growth, metronome advances, guardian cooldowns, and boss marching.

### 2. Level 10000 Climax: The Marching Clock Tower
- **Board Grid:** 14×14 ultimate wooden railway layout with 56 trains ($D \approx 91.0$).
- **Boss Entity:** 3×3 Marching Clock Tower Boss with 12 Hit Points.
- **Marching Trajectory:** Every 5 moves (Step 3 tick), the tower advances 1 cell downward, crushing track cells beneath its foundation.
- **Victory Condition:** Players coordinate optical beams, conveyor loops, and day/night portals to dispatch 56 trains, dealing 12 damage to collapse the tower and achieve the 10,000-level grand victory.

## Affected Files
- `packages/puzzle_core/lib/src/engine/omni_system_engine.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/marching_boss_controller.dart` (to be created)

## Risks
- Severe performance hit from calculating 19 systems simultaneously. Mitigation: Systems evaluate only when active entities of that system type exist on the board.

## Open Questions
- None. Rules match `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md` and `SHARED_CORE_STANDARD.md` §11.
