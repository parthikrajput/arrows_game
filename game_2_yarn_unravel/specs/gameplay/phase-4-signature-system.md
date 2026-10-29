Source docs: phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-3-signature-system.md.

# Spec: Gameplay — Phase 4 Signature System: Sewing Room Floors (Multi-Floor)

## Status
Draft

## Type
New Feature

## Goal
Implement the Sewing Room Floors (Multi-Floor) signature system for Yarn Unravel Phase 4 (Levels 1501–2000), allowing boards to span up to 3 vertical architectural levels (Floor 1 Embroidery Table, Floor 2 Cutting Table, Floor 3 Attic Loom) with free camera gliding, cross-floor path previews, and unified multi-floor win condition verification.

## Current State
Design documented in `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 3 operated on a single multi-layered canvas oscillating between Day and Night cycle states.
- Phase 4 expands boards into separate vertical floor layers where threads and obstacles inhabit distinct floors linked by vertical mechanisms (stairs, holes, lifts).

## Proposed Change
Extend `packages/puzzle_core` with multi-floor models:

### 1. Architectural Structure
- Boards contain up to 3 floors: `Floor 1` (Embroidery Table, base), `Floor 2` (Cutting Table, mid), `Floor 3` (Attic Loom, top).
- Level root JSON defines `"floors": 2` or `3`.
- Each floor possesses its own independent $W \times H$ cell grid, thread list, and obstacle array.
- Coordinates are expressed as `(floor, x, y)`.

### 2. Viewport Navigation & Camera Gliding
- Player switches active view between floors using the HUD Floor Switcher tabs (`F1`, `F2`, `F3`).
- **Cost:** Switching active floor costs **0 Moves**; it is purely a camera viewport pan.
- **Camera Transition:** Smooth 250 ms vertical glide with ease-in-out interpolation (`Curves.easeInOutCubic`).
- **Input Routing:** Taps on the board canvas interact only with threads and obstacles on the currently viewed floor (with the exception of Organza Floors M152).

### 3. Thread Peek & Path Tracing Integration
- Initiating a Thread Peek (long-press >= 350 ms) on a thread whose exit lane traverses a Spiral Spool Stair (M151) or Drop Hole (M153) continues tracing the path across target floors.
- The path preview line renders an elevator/stair indicator arrow pointing toward the connected floor.

### 4. Move Counting & Win Conditions
- Unravelling a thread across multiple floors via stairs counts as a single standard Move.
- Dropping a thread down a Drop Hole (M153) or operating a Bobbin Lift (M154) to relocate a thread costs 1 Move.
- **Victory Condition:** A multi-floor level is won only when **all threads across all floors** have successfully unraveled and cleared the board.

## Affected Files
- `packages/puzzle_core/lib/src/models/multi_floor_board.dart` (to be created: multi-floor board model)
- `packages/puzzle_core/lib/src/models/floor_level_data.dart` (to be created: floor data container)
- `lib/features/gameplay/bloc/floor_navigation_cubit.dart` (to be created: floor camera state)

## Risks
- Players losing track of threads on inactive floors. Mitigated by persistent remaining thread count badges displayed directly on each floor HUD tab.

## Open Questions
None. Multi-floor system rules and 3-floor ceiling conform to `SHARED_CORE_STANDARD.md` §11.
