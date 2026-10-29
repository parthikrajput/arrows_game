Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-7-vfx.md.

# Spec: Visual Effects — Phase 8 VFX & Botanical Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-7-vfx.md` for Phase 8 content)

## Goal
Specify the particle emitters, foliage slicing shaders, and floral bloom juice animations for Phase 8 (Overgrown Branch Line) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_8/06_UI_AND_QA_PHASE_8.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled mechanical rotational sparks and optical lasers.
- Phase 8 requires organic leaf shedding, growth expansion pops, and flower petal bursts.

## Proposed Change
Extend `VfxService` with Phase 8 botanical effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Botanical Growth Dynamics
- **Sprout Pop:** When ivy claims a cell, a tiny green foliage puff pops upward with light leaf flakes.
- **Pruning Shred:** When Hedge Trimmer slices vines, severed green leaves spray outward orthogonally.

### 2. Base Mechanics (M351–M354) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M351 Wild Ivy Spread** | Leafy sprout animation as vines coil forward into adjacent cells. | Green foliage flakes (`#22C55E`) | 4 / 10 / 18 |
| **M352 Hedge Trimmer** | High-velocity leaf slicing spray along departure corridors as vines are cut. | Shredded leaf particles (`#16A34A`) | 8 / 20 / 35 |
| **M353 Seed Drop** | Acorn seed drops with soft soil dust puff upon caboose exit. | Miniature dirt flecks (`#78350F`) | 4 / 8 / 16 |
| **M354 Flower Bloom** | Floral trellis bursts into blossoms accompanied by a cascading petal shower. | Pink rose petals (`#FDA4AF`) | 8 / 18 / 32 |
| **L4000 Finale Win** | Botanical blossom explosion with floral confetti garlands, green ribbons, and steam whistles. | Rose petals & gold leaf stars | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Leaf slicing showers replaced with clean 150 ms linear prune fade; sprout pops clamped to 0 dp scale bounce.
- **Tier Capping:** Low tier disables flying leaf physics particles, utilizing a flat 2D sprite vanish tween.

## Affected Files
- `lib/core/vfx/emitters/leaf_shred_emitter.dart` (to be created)
- `lib/core/vfx/emitters/petal_bloom_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 8 effect classes)

## Risks
- Rapid successive vine pruning overwhelming particle pools. Mitigation: Emitter recycles active leaf particles and clamps simultaneous active prune emitters to 2.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 8 docs.
