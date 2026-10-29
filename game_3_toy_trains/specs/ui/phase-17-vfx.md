Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-16-vfx.md.

# Spec: Visual Effects — Phase 17 VFX & Clock Towers Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-16-vfx.md` for Phase 17 content)

## Goal
Specify the particle emitters, church bell toll resonance, tower structural crumble dust, shield armor shatter, core beam vaporization rays, and haptic feedback for Phase 17 (Clock Towers) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled brass punch clicks and paper confetti showers.
- Phase 17 requires dramatic boss impact shocks, timber fracture debris, and optical core dissolution flares.

## Proposed Change
Extend `VfxService` with Phase 17 guardian boss effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Guardian Impact & Destruction Dynamics
- **Tower Structural Crumble (M801–M803):** Reaching 0 HP causes the clock tower to fracture, toppling into a burst of wooden timber blocks, brass gear fragments, and billowing pine dust.
- **Shield Armor Shatter (M802):** Completing the damage sequence detonates the chromatic shield into refractive glass-like polygon shards (`#60A5FA`).
- **Core Beam Vaporization (M804):** Direct signal light beam contact causes the core to hum with harmonic resonance, dissolving into a vertical column of golden light flares (`BlendMode.plus`).

### 2. Base Mechanics (M801–M804) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M801 Tower Collapse** | Tower shatters into falling timber chunks, brass gears, and dust cloud. | Wooden blocks & pine dust (`#92400E`) | 8 / 20 / 35 |
| **M802 Shield Shatter** | Chromatic hexagonal shield mesh fractures into bursting crystal fragments. | Shield crystal shards (`#3B82F6`) | 6 / 15 / 25 |
| **M803 Spawner Smoke** | Dark industrial coal smoke puff as a new buffer stop deploys onto track. | Industrial soot puff (`#374151`) | 4 / 12 / 20 |
| **M804 Core Dissolve** | Vertical ascending solar light pillar with floating golden clock gears. | Solar light flare (`#F59E0B`) | 8 / 20 / 35 |
| **L8500 Finale Win** | Citadel of Time victory barrage: golden gear fireworks, cathedral chimes, confetti. | Brass gears, chimes, fireworks | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Tower collapse replaced with 150 ms linear fade-out; camera boss-defeat rumble disabled.
- **Tier Capping:** Low tier disables complex polygon meshes on collapsing towers, using flat rectangular sprite fragments.

## Affected Files
- `lib/core/vfx/emitters/tower_collapse_emitter.dart` (to be created)
- `lib/core/vfx/emitters/shield_shatter_emitter.dart` (to be created)
- `lib/core/vfx/emitters/core_vaporize_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 17 effect classes)

## Risks
- Frame drop during large tower collapse explosion. Mitigation: Tower collapse particles despawn quickly after 350 ms with aggressive particle pooling.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 17 docs.
