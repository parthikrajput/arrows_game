Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-2.md.

# Spec: Visual Effects — Phase 3 VFX & Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/vfx-phase-2.md` for Phase 3 content)

## Goal
Specify the particle systems, ambient lighting shaders, and visual juice effects for Phase 3 (Day & Night Timetable) of Toy Trains: Wooden Railway Puzzle, ensuring strict compliance with device tier performance limits.

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier VFX specs handled physical train collisions, sparks, and optical light beams.
- Phase 3 introduces global lighting transitions and cyclic mechanism transformations.

## Proposed Change
Extend `VfxService` with Phase 3 effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Day & Night Transition Sequence
When the cycle advances from State A to State B (or vice versa):
- **Ambient Lighting Shift:** 300 ms linear color temperature tween across the tabletop background.
- **Sunburst Transition (Night -> Day):**
  - Radiant solar flare ring expands outward from the Sun dial icon across the tabletop (Low: 8 / Mid 20 / High 35 golden particles).
- **Moonlit Transition (Day -> Night):**
  - Subtle indigo mist wisps drift across tabletop track boundaries (Low: 8 / Mid 20 / High 35 soft smoke circles).

### 2. Base Mechanics (M101–M104) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M101 Day/Night Gate** | Brass latch snaps open/shut; tiny golden friction sparks on state flip. | Brass spark flecks (`#F59E0B`) | 4 / 10 / 18 |
| **M102 Day/Night Overpass**| Bridge deck descends into blocked position; miniature wood dust ring at contact points. | Fine sawdust puff (`#D97706`) | 6 / 15 / 25 |
| **M103 Day/Night Tunnel** | Heavy iron portcullis slams down across tunnel arch; metallic shockwave ring. | Iron dust flecks & spark chips | 8 / 18 / 30 |
| **M104 Day/Night Livery** | Wet lacquer wave sweeps from engine smokestack to rear carriage, repainting the body. | Color wash procedural shader | n/a (Shader) |
| **L1500 Finale Win** | Spectacular dual day/night fireworks burst with golden suns and silver crescent stars. | Metallic foil confetti stars | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** When active, transitions discard particle rings and utilize subtle 200 ms opacity crossfades.
- **Battery Saver Mode:** Ambient tabletop lighting overlay renders as a static non-blended tinted overlay; particle emitters disabled.

## Affected Files
- `lib/core/vfx/emitters/cycle_transition_emitter.dart` (to be created)
- `lib/core/vfx/shaders/livery_recolor_shader.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 3 effect classes)

## Risks
- Heavy fill-rate overhead from full-screen ambient lighting tweens on low-end Mali GPUs. Mitigation: Draw single cached quad with opacity tween rather than per-pixel fragment shader passes on Low tier.

## Open Questions
- None. All effect classes and particle limits match `VFX_IMPLEMENTATION.md` and Phase 3 docs.

