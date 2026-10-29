Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-19-vfx.md.

# Spec: Visual Effects — Phase 20 VFX & Grand Sovereign Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-19-vfx.md` for Phase 20 content)

## Goal
Specify the particle emitters, seismic boss footstep impacts, rail splintering bursts, night master pass spectral trails, prism bloom starbursts, and climactic Level 10,000 victory ceremony visual juice for Phase 20 (Grand Master) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled intermediate boss collapses and kinetic synergies.
- Phase 20 requires seismic marching rumbles, catastrophic rail crushing dust, and the game's ultimate celebration pyrotechnics.

## Proposed Change
Extend `VfxService` with Phase 20 grand master effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Seismic Marching & Climax Dynamics
- **Marching Footstep Slam (Level 10000):** Every 5 moves, the 3x3 boss marching step triggers a heavy wooden impact thud, a 150 ms haptic impulse, and a radial blast of pine splinters and shattered iron shards.
- **Night Master Pass Aura (M953):** In Night Phase B, the locomotive leaves an undulating celestial comet trail (`#818CF8`, `#C084FC`) that illuminates track tiles beneath it.
- **Prism Bloom Detonation (M954):** Unlocking the arch ignites an optical lens flare that explodes into golden floral pollen petals.

### 2. Base Mechanics (M951–M954) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M951 Conveyor Boss Hit** | Golden gear debris and mechanical chime ping on successful train strike. | Brass cog shards (`#F59E0B`) | 6 / 15 / 25 |
| **M952 Gravity Relay Shift** | Twin opposing dust swirls across Table A and Table B upon tilt. | Inverted dust motes (`#D97706`) | 6 / 14 / 22 |
| **M953 Celestial Pass** | Luminous starry comet trail with trailing stardust during night phase. | Celestial stardust (`#A78BFA`) | 8 / 20 / 35 |
| **M954 Bloom Starburst** | Floral golden pollen burst accompanied by multi-spectral prism flare. | Pollen petals & prism rays | 8 / 20 / 35 |
| **L10000 Climax Boss Death** | Cataclysmic cathedral collapse: golden gear geysers, blinding white flash, 3-second golden crown fireworks. | Gold gears, royal streamers, fireworks | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Marching footstep screen shake locked to 0 dp; boss death flash replaced with 300 ms linear white crossfade.
- **Tier Capping:** Low tier disables additive blend modes on celestial stardust, keeping solid circular sprite motes.

## Affected Files
- `lib/core/vfx/emitters/marching_stomp_emitter.dart` (to be created)
- `lib/core/vfx/emitters/celestial_trail_emitter.dart` (to be created)
- `lib/core/vfx/emitters/bloom_starburst_emitter.dart` (to be created)
- `lib/core/vfx/emitters/grand_climax_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 20 effect classes)

## Risks
- Frame drop during climactic Level 10000 boss defeat sequence. Mitigation: Particle bursts are staggered across 5 discrete 200 ms waves rather than all spawning in frame 1.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 20 docs.
