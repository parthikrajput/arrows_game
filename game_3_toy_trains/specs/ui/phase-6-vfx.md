Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-5.md.

# Spec: Visual Effects — Phase 6 VFX & Optical Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-5-vfx.md` for Phase 6 content)

## Goal
Specify the particle emitters, chromatic glow shaders, and optical juice effects for Phase 6 (Signal Lights+) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled physical push impacts and vertical transitions.
- Phase 6 requires optical glow shaders, chromatic flare pings, and blackout reveal effects.

## Proposed Change
Extend `VfxService` with Phase 6 optical effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Optical Beam & Chromatic Juice
- **Beam Emission:** Pulse of light particles emitted at source lamp aperture.
- **Lens Refraction:** When a beam enters M251 Coloured Lens, a subtle chromatic sparkle ring emits at the glass boundary.

### 2. Base Mechanics (M251–M254) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M251 Coloured Lens** | Prismatic refraction sparkles at lens surface upon beam entry. | Colored star flecks (`#FDE047`) | 4 / 10 / 18 |
| **M252 Twin Sensor** | Electric energy arc connects the two sensors when both are simultaneously illuminated. | Luminescent cyan arc spark | 6 / 15 / 25 |
| **M253 Lamp Timer** | Brass shutter click sparks on state flip; beam flares into life or fades. | Gold friction spark chips | 4 / 10 / 18 |
| **M254 Blackout Reveal** | Radial light blossom dissolves dark mist, revealing waking train cabin lights. | Soft radiant light orbs | 8 / 20 / 35 |
| **L3000 Finale Win** | Prismatic laser light show, rainbow confetti spirals, and golden steam whistles. | Rainbow star confetti & sparkles | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Laser show confetti replaced with smooth radial color fade; electric arcs render as static solid lines.
- **Tier Capping:** Low tier disables additive bloom blur around light beams, rendering sharp vector lines.

## Affected Files
- `lib/core/vfx/emitters/optical_sparkle_emitter.dart` (to be created)
- `lib/core/vfx/shaders/blackout_reveal_shader.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 6 effect classes)

## Risks
- GPU fill-rate throttling with multiple active chromatic beams on Low tier. Mitigation: Hard cap of 6 simultaneous active beam rays on Low tier devices.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 6 docs.
