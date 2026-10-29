Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-13-vfx.md.

# Spec: Visual Effects — Phase 14 VFX & Alpine Pass Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-13-vfx.md` for Phase 14 content)

## Goal
Specify the particle emitters, glacier refraction shimmers, paired barrier drop flashes, reverse steam backtracks, alpine snow flurries, and haptic feedback for Phase 14 (Alpine Pass) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled mist parting swirls and heat shimmers.
- Phase 14 requires glacial ice reflections, frost crystal fracturing, and reverse locomotive steam dynamics.

## Proposed Change
Extend `VfxService` with Phase 14 alpine reflection effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Glacier Reflection & Inversion Dynamics
- **Glacier Refraction Shimmer (M651):** Moving mirror trains cast shimmering specular ice glints along the central glass seam line (`BlendMode.plus`).
- **Paired Barrier Shatter (M652):** Unlocking reflection locks shatters the frost barrier with icy diamond shards (`#93C5FD`) and deep crystalline chime resonance.
- **Reverse Steam Backtrack (M654):** Reverse engines emit steam jets backward from the boiler front rather than backward from the cab, highlighting reverse propulsion.

### 2. Base Mechanics (M651–M654) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M651 Mirror Glint** | Crystalline specular glint travelling along central glacier line. | Ice diamond glints (`#BAE6FD`) | 6 / 15 / 24 |
| **M652 Glacier Shatter** | Paired frost barrier fractures into exploding ice crystal fragments. | Glacier ice shards (`#38BDF8`) | 8 / 20 / 35 |
| **M653 Twin Yard Click** | Synchronized frost sparks at mirrored switch pivot points. | Frost sparks (`#E0F2FE`) | 4 / 10 / 18 |
| **M654 Reverse Steam** | Inverted white steam jet puffing counter to forward heading. | Forward steam jet (`#FFFFFF`) | 6 / 16 / 28 |
| **L7000 Finale Win** | Great Alpine summit fireworks: glacial prism beams, diamond snow flurry, brass victory chimes. | Prism beams & snow flurry | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Crystalline glints replaced with static 120 ms brightness flash; screen shake locked to 0 dp.
- **Tier Capping:** Low tier disables refraction distortion shaders, rendering flat crystalline polygon particles.

## Affected Files
- `lib/core/vfx/emitters/glacier_shimmer_emitter.dart` (to be created)
- `lib/core/vfx/emitters/ice_shatter_emitter.dart` (to be created)
- `lib/core/vfx/emitters/reverse_steam_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 14 effect classes)

## Risks
- Paired emitters firing concurrently on both halves of the board exceeding particle budget. Mitigation: Particle count per emitter automatically halved when dual mirror emitters trigger simultaneously.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 14 docs.
