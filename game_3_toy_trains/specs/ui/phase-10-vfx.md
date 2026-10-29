Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-9-vfx.md.

# Spec: Visual Effects — Phase 10 VFX & Timetable Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-9-vfx.md` for Phase 10 content)

## Goal
Specify the particle emitters, rhythm pulses, departure code flares, order buzz shocks, and tactile haptic feedback for Phase 10 (Timetable Master) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled magnetic coupling sparks, split steam, and rotary friction.
- Phase 10 requires clockwork rhythmic pulses, code progression flares, and order violation alerts.

## Proposed Change
Extend `VfxService` with Phase 10 timetable sequencing effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Clockwork Pulse & Progression Dynamics
- **Rhythm Sonic Pulse (M451):** Every board move emits a radial sonic ring from the metronome gate: emerald green (`#10B981`) when opening, ruby crimson (`#EF4444`) when closing.
- **Departure Code Completion Flare (M452):** Matching the full sequence ignites a golden burst (`#F59E0B`, `BlendMode.plus`) that dissolves the barrier into floating brass gears.

### 2. Base Mechanics (M451–M454) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M451 Rhythm Pulse** | Expanding concentric sonic ring upon gate state toggle. | Expanding wave mesh (`#10B981` / `#EF4444`) | 4 / 10 / 18 |
| **M452 Code Unlock** | Golden gear confetti and bright lens flare across gate barrier. | Golden gear flecks & flare (`#F59E0B`) | 8 / 20 / 35 |
| **M453 Order Violation** | Buzz shock with crimson zigzag sparks and smoke puff on out-of-order exit. | Crimson sparks & smoke (`#DC2626`) | 6 / 15 / 25 |
| **M454 Echo Mirror Glow** | Sparkle ring pulses around Echo Signal when repeating pattern successfully. | Cyan sparkle ring (`#06B6D4`) | 6 / 16 / 28 |
| **L5000 Finale Win** | Master Clock Tower chime shower: brass chimes, pendulum gears, and golden streamers. | Chime notes, brass gears, confetti | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Pulses and rings replaced by instant 100 ms opacity fade; shake set to 0 dp.
- **Tier Capping:** Low tier disables additive blend modes on lens flares, using flat sprite rendering to ensure solid 60 fps.

## Affected Files
- `lib/core/vfx/emitters/rhythm_pulse_emitter.dart` (to be created)
- `lib/core/vfx/emitters/code_unlock_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 10 effect classes)

## Risks
- Rapid repetitive moves causing emitter stacking and stutter. Mitigation: Throttled to max 2 concurrent pulse emitters per frame.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 10 docs.
