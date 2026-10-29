Source docs: phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, ../../SCALING_TO_10000_LEVELS.md §9. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 20 Signature System: The Endless Tapestry (All-Systems Synthesis)

## Status
Draft

## Type
New Feature

## Goal
Specify the Grand Master system synthesis, Level 10,000 Grand Finale architecture, post-10,000 endgame transition loop, moving boss guardian kinetics, and tick order integration for Yarn Unravel Phase 20 (Levels 9501–10,000).

## Current State
Design documented in `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md` and `phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md`, not yet implemented.
- Phases 1 through 19 introduced distinct mechanical disciplines (pins, cycles, layers, physics, beams, rotation, vines, splits, metronomes, linked boards, gravity, fog, mirrors, conveyors, keys, guardians, remixes).
- Phase 20 unites all 19 systems into The Endless Tapestry, culminating in Level 10,000 and establishing the permanent endgame loop.

## Proposed Change
Implement the Grand Master system within `packages/puzzle_core`:

### 1. Grand Master Mechanics & Synthesis
- **M951 — Moving Guardian (Living Tapestry):**
  - A dynamic $2\times 2$ velvet boss pincushion (8 HP).
  - Rather than remaining static, it traverses a predefined patrol loop, advancing 1 cell every 2 player moves.
  - Pin extraction damage rules apply identically: unravelling an adjacent thread extracts 1 pin (-1 HP). Upon reaching 0 HP, it permanently dissolves into silk ribbons.
- **M952 — Omni Gate (Chromatic Prism Gate):**
  - Universal logic gate requiring 3 simultaneous conditions to unlock: an active intersecting light beam, matching thread color, and Day/Night cycle state A.
- **M953 — Grand Loom Spool (Infinity Bobbin):**
  - Central spool that dispenses successive threads; as one thread unweaves completely, the spool dispenses the next queued thread onto the linen board.
- **M954 — Master Weaver Key (Grand Skeleton Charm):**
  - Grand master key thread that permanently unlocks all clasps, reflect locks, and segment gates across the entire board upon unravelling.

### 2. Level 10,000 Grand Finale Architecture
- **Composition:**
  - $14\times 14$ master canvas integrating every mechanical discipline into a unified puzzle: Day/Night cycles, multi-floor organza, sliding crates, prism beams, hoop rotors, ivy tendrils, rhythm metronomes, mirror seams, conveyors, and the Moving Guardian.
- **Target Difficulty:** $D \approx 154.0$ ($128 \times 1.20$).
- **Solvability Invariant:** CI verified 100% solvable with 0 hearts lost and 0 boosters required.

### 3. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels a thread OR triggers a board interaction (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Grand Master Resolution):**
  1. Moving Guardian (M951) updates position every 2 moves along patrol loop.
  2. Omni Gate (M952) evaluates beam, color, and cycle state confluence.
  3. Grand Loom Spool (M953) dispenses next thread if prior thread exited.
  4. Master Weaver Key (M954) broadcasts universal unlock on exit.
- **Step 5 (Gates & Clasps Update):** Apply state changes across all board clasps.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate snags from player unravel actions.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 4. Post-10,000 Endgame Loop
- Upon clearing Level 10,000:
  - Triggers the 1,800 ms cinematic "Endless Tapestry" camera pan-out.
  - Player earns the permanent "Grand Master Weaver" title and Golden Purl mascot badge.
  - Level progression transitions to the infinite endgame loop: Daily Stitch, Weekly Star Race, and procedural Golden Bobbin challenges without state corruption.

## Affected Files
- `packages/puzzle_core/lib/src/models/endless_tapestry_state.dart` (to be created)
- `packages/puzzle_core/lib/src/logic/grand_master_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: Level 10,000 deep search heuristics)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: Level 10,000 grand composition generator)

## Risks and Open Questions
- None. System interactions comply with `SHARED_CORE_STANDARD.md` §11, §16.17, and `SCALING_TO_10000_LEVELS.md` §9.

