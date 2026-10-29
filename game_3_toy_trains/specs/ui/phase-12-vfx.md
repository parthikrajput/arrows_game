Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-11-vfx.md.

# Spec: Visual Effects — Phase 12 VFX & Hill Line Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-11-vfx.md` for Phase 12 content)

## Goal
Specify the particle emitters, timber creaks, crate collision sawdust, anti-grav sparkles, ballast smoke puffs, and haptic feedback for Phase 12 (Hill Line) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled cross-table lasers and portal warps.
- Phase 12 requires physical incline shift thuds, sliding friction dust, and suspension glows.

## Proposed Change
Extend `VfxService` with Phase 12 gravity and incline effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Incline Shift & Sliding Dynamics
- **Tilt Fulcrum Thud (M551):** Activating the tilt lever triggers a heavy wooden board clunk, 100 ms camera tilt rumble, and sawdust puff at the fulcrum hinge.
- **Crate Impact Dust (M552):** Crates halting against obstructions kick up a burst of wooden sawdust flecks (`#D97706`).

### 2. Base Mechanics (M551–M554) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M551 Tilt Thud** | Fulcrum sawdust burst and slight board elevation tilt animation. | Pine wood shavings (`#D97706`) | 6 / 14 / 22 |
| **M552 Crate Slide Dust** | Continuous ground friction trail as loose crates slide across rails. | Dust motes (`#FBBF24`) | 4 / 12 / 20 |
| **M553 Balloon Glow** | Soft buoyant aura with ascending air bubble sparkles around suspended crates. | Cyan air bubbles (`#38BDF8`) | 6 / 15 / 26 |
| **M554 Ballast Roll** | Heavy rolling soot puffs escaping engine chimney during autonomous motion. | Charcoal soot clouds (`#4B5563`) | 6 / 16 / 28 |
| **L6000 Finale Win** | Mountain summit celebration: pine needle showers, golden cog wheels, and victory steam. | Pine needles, golden cogs, steam | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Camera tilt locked to 0 dp; crate sliding rendered with instantaneous 120 ms linear translation without overshoot.
- **Tier Capping:** Low tier disables bubble shader blur on Balloon Pads, using flat circular sprites.

## Affected Files
- `lib/core/vfx/emitters/tilt_dust_emitter.dart` (to be created)
- `lib/core/vfx/emitters/crate_slide_emitter.dart` (to be created)
- `lib/core/vfx/emitters/balloon_glow_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 12 effect classes)

## Risks
- Rapid sliding of multiple crates simultaneously overloading particle count. Mitigation: Maximum 3 active slide dust emitters clamped concurrently.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 12 docs.
