Source docs: phases/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.24, §17.38. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-5-signature-system.md.

# Spec: Gameplay — Phase 6 Signature System (Sun Temple Light)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 6 signature system "Sun Temple Light" (Light & Beams+): an advanced dynamic optical puzzle model incorporating continuous ray tracing, chromatic beam filtering, multi-beam prism latch gates, timed sundial receivers, and shadow-casting leaf cells across Levels 2501–3000.

## Current State
Design documented in `phases/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md`, `phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 introduced basic static light emitters (M084 Sunbeam Reflector, M085 Fixed Mirror, M086 Crystal Prism).
- Earlier optics were static monochrome rays triggering single binary light sensors.
- There was no support for ray color alteration, chromatic matching requirements, multi-angle concurrent beam locks, consecutive-move beam timers, or light-dependent dormant snake states.

## Proposed Change
Extend `packages/puzzle_core` with continuous ray tracing engines, color-state models, and multi-beam synchronization pipelines:

### 1. Optical Ray Tracing & Propagation Model
- **Ray Origin & Direction:** Solar beams emit from border emitters or crystalline fixtures traveling in straight orthogonal rays until reaching an obstruction or board edge.
- **Ray Reflections:** Rays contacting mirrors (M085) or prisms deflect at precise 90° angles based on mirror orientation (`/` or `\`).
- **Opaque Body Blocking (Standard §16.17):**
  - Snake bodies are completely opaque. Any snake segment intersecting an active beam stops the ray at that coordinate.
  - When a snake slithers out of the beam path, the ray instantly re-traces through the newly vacated cells during Step 4 of the turn resolution cycle.
- **Ray Tracing Execution Budget:** Total ray-casting resolution across all emitters must complete in $\le 2\text{ ms}$ on low-tier mobile devices.

### 2. Chromatic Filtering Architecture
- **Base Beam Color:** Unfiltered sunlight emits as standard `White` beam.
- **Filter Mutation:** When a beam passes through a Petal Filter (M251), the ray acquires the filter's chromatic spectrum (e.g. `Ruby`, `Cyan`, `Emerald`, `Gold`, `Violet`).
- **Chromatic Matching:** Colored receivers and locks respond strictly to their assigned matching spectrum. A mismatched color beam striking a receiver produces zero activation and is absorbed.
- **Filter Stacking:** Passing through a second filter of a different color blocks the beam (subtractive absorption), terminating the ray at the second filter.

### 3. Multi-Beam Concurrency & Splitter Locks
- **Prism Locks (M252):** Optical gates that require concurrent illumination from $\ge 2$ distinct beam angles in the exact same move turn.
- **Simultaneous Resolution:** Step 4 evaluates all active ray endpoints concurrently. If $\ge 2$ beams converge on the prism lock tile, the gate transitions to `LatchedOpen` permanently.

### 4. Turn Pipeline & Tick Order Integration (Standard §16.17)
Ray tracing and optical sensor updates execute deterministically during Step 4 of the move resolution lifecycle:
```
1. Action resolve (Snake slithers or interactive mirror rotated).
2. moveCount += 1.
3. Move-based obstacle counters tick (Countdown, Timers).
4. Ray Casting Step:
   a. Clear all dynamic ray segments and beam states.
   b. Trace rays from all solar emitters across grid.
   c. Apply chromatic mutations via Petal Filters (M251).
   d. Evaluate converging rays on Prism Locks (M252).
   e. Update consecutive illumination timers on Sundial Receivers (M253).
   f. Update illumination flags on Shade Leaves (M254).
5. Derived states, door opens/closes, and unlocked snake flags update.
6. Star and Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/optics/ray_caster.dart` — to be created
- `packages/puzzle_core/lib/src/optics/beam_segment.dart` — to be created
- `packages/puzzle_core/lib/src/optics/chromatic_color.dart` — to be created
- `packages/puzzle_core/lib/src/models/board_state.dart` — changed
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` — changed

## Risks and Open Questions
- **Performance Risk:** Boards with multiple rotating mirrors and splitters can produce ray deflection loops.
  - *Resolution:* Ray caster enforces a hard cap of maximum 32 ray segments per beam. If segment count exceeds 32, the ray terminates to prevent infinite loops.
- **Color-Blind Accessibility:** Ray colors must not rely solely on hue. Each chromatic beam has an animated glyph watermark overlay (Ruby = Triangle, Cyan = Square, Gold = Diamond).

