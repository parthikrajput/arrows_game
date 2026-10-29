Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-17-vfx.md.

# Spec: Visual Effects — Phase 18 VFX & Remix A Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-17-vfx.md` for Phase 18 content)

## Goal
Specify the particle emitters, compound synergy flash sequences, elevator cable tension sparks, prism beam rainbow refractions, chute drop impacts, and haptic feedback for Phase 18 (Remix A) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled guardian boss collapse and church bell tolls.
- Phase 18 requires synchronized multi-system mechanical feedback and optical prismatic juice.

## Proposed Change
Extend `VfxService` with Phase 18 synergy effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Compound Synergy & Impact Dynamics
- **Prism Rainbow Flare (M853):** Beams passing through glass prisms split into radiant multi-spectral light flares (`#38BDF8`, `#34D399`, `#FBBF24`).
- **Elevator Vertical Transit (M852):** Hydraulic lift motion emits descending steam columns and steel cable tension creaks.
- **Chute Impact Clack (M854):** Ice carts crashing down into lower floor blackout pits trigger a heavy thud, frost crystal shatter, and tile-locking golden sparks.

### 2. Base Mechanics (M851–M854) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M851 Cycle Stamp** | Sun/Moon crest burst on cart when exiting Day/Night tunnel. | Amber/Silver starburst (`#F59E0B` / `#E5E7EB`) | 6 / 14 / 22 |
| **M852 Lift Steam** | Pressurized hydraulic steam venting as lift ascends/descends. | White hydraulic vapor (`#FFFFFF`) | 6 / 16 / 26 |
| **M853 Prism Flare** | Refracted rainbow particle stream cascading onto sensor gate. | Spectral prism particles | 8 / 20 / 35 |
| **M854 Chute Slam** | Frost shards and dust explosion as cart locks into blackout pit. | Ice shards & pine dust (`#93C5FD`) | 8 / 18 / 30 |
| **L9000 Finale Win** | First Era triumph: brass cog barrages, rainbow laser prism arches, confetti shower. | Prism lasers & golden confetti | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Prism rainbow flares replaced with static 100 ms opacity line; elevator vertical shake locked to 0 dp.
- **Tier Capping:** Low tier disables spectral dispersion shaders, rendering single dominant color beam.

## Affected Files
- `lib/core/vfx/emitters/prism_flare_emitter.dart` (to be created)
- `lib/core/vfx/emitters/hydraulic_lift_emitter.dart` (to be created)
- `lib/core/vfx/emitters/chute_slam_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 18 effect classes)

## Risks
- Multiple overlapping emitters from different systems exceeding particle budget. Mitigation: Global particle manager clamps total scene particles to tier ceilings.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 18 docs.
