Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-6-vfx.md.

# Spec: Visual Effects — Phase 7 VFX & Rotational Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-6-vfx.md` for Phase 7 content)

## Goal
Specify the particle emitters, rotational angular easing curves, and tactile gear juice effects for Phase 7 (Turntable Yards+) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled optical beam shaders and physical push impacts.
- Phase 7 requires mechanical gear sparks, rotating disc friction feedback, and clockwork winding animations.

## Proposed Change
Extend `VfxService` with Phase 7 rotational effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Rotational Easing & Gear Haptics
- **Rotor Easing:** 4x4 Sub-board rotation uses custom cubic overshoot curve (`Curves.easeOutBack`, overshoot = 1.05) giving tactile wooden momentum.
- **Rotor Locking Clack:** At the end of 90° rotation, brass teeth emit a metallic snap sound and a burst of micro-friction sparks.

### 2. Base Mechanics (M301–M304) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M301 4x4 Rotor** | Peripheral brass gear teeth emit circular friction sparks as disc rotates; locking clack dust. | Brass friction sparks (`#F59E0B`) | 6 / 15 / 28 |
| **M302 Spinning Exits** | Subtle wooden track dust sliding along perimeter groove as exit shifts position. | Fine wood dust specks (`#D7CCC8`) | 4 / 10 / 18 |
| **M303 Spinner Engine** | Clockwork winding key twirls rapidly emitting tiny golden star sparkles from chimney. | Golden star flecks (`#FBBF24`) | 4 / 10 / 16 |
| **M304 Turntable Lock**| Iron padlock shatters with metal fragments and snapping chain links upon key train departure. | Iron shard fragments (`#6B7280`) | 8 / 18 / 32 |
| **L3500 Finale Win** | Spectacular spinning windmill fireworks, golden cogwheels confetti, and quadruple whistles. | Golden gear confetti & rainbow streamers | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Rotor rotation animation duration clamped to instantaneous 100 ms linear crossfade; screen micro-shakes disabled (0 dp).
- **Tier Capping:** Low tier renders rotor as a flat 2D picture without real-time gear teeth spark emitters.

## Affected Files
- `lib/core/vfx/emitters/gear_spark_emitter.dart` (to be created)
- `lib/core/vfx/emitters/lock_shatter_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 7 effect classes)

## Risks
- Matrix transformation lag during 4x4 rotor animation with 8+ trains. Mitigation: Render rotating trains into cached picture layer during active rotation tween.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 7 docs.
