Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-18-vfx.md.

# Spec: Visual Effects — Phase 19 VFX & Remix B Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-18-vfx.md` for Phase 19 content)

## Goal
Specify the particle emitters, rotor friction sparks, spore puff clouds, cross-table metronome sonic ripples, scythe foliage shredding, and haptic feedback for Phase 19 (Remix B) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled hydraulic lift steam and rainbow prism flares.
- Phase 19 requires spinning mechanical blade shredding, botanical spore emissions, and cross-board acoustic resonance.

## Proposed Change
Extend `VfxService` with Phase 19 kinetic synergy effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Kinetic Synergy Dynamics
- **Rotor Coupling Snap (M901):** Aligning the turntable triggers an immediate double buffer snap with magnetic spark arcs (`#F59E0B`).
- **Spore Seed Dispersion (M902):** Moving seed wagons expel fine emerald spore clouds (`#10B981`) that settle onto track ballast.
- **Scythe Blade Shredding (M904):** Advancing pruner engines shred ivy into explosive showers of chopped pine leaves and severed vines.

### 2. Base Mechanics (M901–M904) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M901 Turntable Lock** | Mechanical gear locking clack and twin magnetic coupling spark flash. | Brass sparks (`#F59E0B`) | 6 / 15 / 24 |
| **M902 Spore Puff** | Billowing green pollen clouds ejected behind rolling seed wagon. | Pollen spore puffs (`#10B981`) | 6 / 14 / 22 |
| **M903 Bridge Pulse** | Expanding concentric sonic ripple across Table Bridge upon beat advance. | Cyan acoustic wave (`#06B6D4`) | 4 / 10 / 18 |
| **M904 Scythe Shred** | Explosive leaf debris spray as rotating blades chop overgrown ivy. | Pine needle shreds (`#047857`) | 8 / 20 / 35 |
| **L9500 Finale Win** | Mid-Era Concourse triumph: emerald and gold firework arches, floral confetti, brass bells. | Emerald/Gold fireworks & confetti | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Scythe blade rotation locked to static angle; spore puffs replaced with 100 ms opacity dot.
- **Tier Capping:** Low tier disables particle physics on leaf debris, using simple 2D downward gravity fall.

## Affected Files
- `lib/core/vfx/emitters/spore_puff_emitter.dart` (to be created)
- `lib/core/vfx/emitters/scythe_shred_emitter.dart` (to be created)
- `lib/core/vfx/emitters/bridge_pulse_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 19 effect classes)

## Risks
- Frame drop when cutting extensive ivy patches with both split engines simultaneously. Mitigation: Particle emission throttled to max 25 particles total across both blades.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 19 docs.
