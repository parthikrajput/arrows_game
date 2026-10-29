Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-12-vfx.md.

# Spec: Visual Effects — Phase 13 VFX & Weather Station Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-12-vfx.md` for Phase 13 content)

## Goal
Specify the particle emitters, fog dissipation swirls, mirage shimmer ripples, painted wall flutter, lantern glow pulses, and haptic feedback for Phase 13 (Weather Station) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled timber incline creaks and sliding sawdust.
- Phase 13 requires fluid atmospheric mist dissipation, heat shimmers, and optical reveal effects.

## Proposed Change
Extend `VfxService` with Phase 13 atmospheric weather effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Mist Dissipation & Reveal Dynamics
- **Fog Parting Swirl (M601):** As the scout draisine exits, fog tiles disperse in curling steam vortices, evaporating into the mountain air.
- **Mirage Shimmer (M602):** Driving through a decoy train creates a chromatic heat ripple and evaporating steam flakes (`#E5E7EB`).
- **Backdrop Flutter (M603):** Trains passing through painted false fences trigger a canvas rustle and painted wooden flake flutter.

### 2. Base Mechanics (M601–M604) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M601 Scout Reveal** | Curling white steam swirl dispersing outward along the departure lane. | Steam smoke puffs (`#F3F4F6`) | 6 / 15 / 25 |
| **M602 Mirage Dissolve** | Heat distortion ripple and shimmering phantom locomotive dissolution. | Silver shimmer flecks (`#E5E7EB`) | 6 / 14 / 22 |
| **M603 Backdrop Flutter** | Wooden paint flakes and fluttering theatrical canvas curtain ripple. | Ochre paint specks (`#D97706`) | 4 / 10 / 18 |
| **M604 Lantern Warmth** | Pulsing radial amber light rays with floating firefly sparks around plate. | Firefly sparks (`#F59E0B`) | 6 / 16 / 28 |
| **L6500 Finale Win** | Observatory summit spectacle: auroral northern lights curtain and star flares. | Aurora flares & star sparks | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Fog swirl replaced with 100 ms linear crossfade; screen distortion ripple disabled.
- **Tier Capping:** Low tier disables particle swirling physics, rendering straight outward drift.

## Affected Files
- `lib/core/vfx/emitters/fog_parting_emitter.dart` (to be created)
- `lib/core/vfx/emitters/mirage_shimmer_emitter.dart` (to be created)
- `lib/core/vfx/emitters/lantern_warmth_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 13 effect classes)

## Risks
- Frame drop when clearing large fog areas simultaneously. Mitigation: Fog clearing serialized in 50 ms step cascades per cell.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 13 docs.
