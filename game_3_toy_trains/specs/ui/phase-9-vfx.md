Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-8-vfx.md.

# Spec: Visual Effects — Phase 9 VFX & Coupling Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-8-vfx.md` for Phase 9 content)

## Goal
Specify the particle emitters, coupling impact sparks, divergence steam jets, and tactile haptic feedback for Phase 9 (Couple & Uncouple) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled botanical foliage shredding and rotational gear friction.
- Phase 9 requires physical coupling knuckle clicks, splitting steam releases, and magnetic locking sparks.

## Proposed Change
Extend `VfxService` with Phase 9 coupling effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Coupling Impact Dynamics
- **Magnetic Coupling Snap:** When two trains merge on M401 Coupling Pad:
  - Buffers snap together with an elastic 120 ms spring bounce.
  - Burst of brass magnetic friction sparks at the coupling point.

### 2. Base Mechanics (M401–M404) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M401 Coupling Snap** | Twin brass couplers clamp shut emitting energetic magnetic sparks. | Brass spark flecks (`#F59E0B`) | 6 / 15 / 25 |
| **M402 Twin Split** | High-pressure pressurized steam jets burst laterally along central splitting seam. | Horizontal white steam jet (`#FFFFFF`) | 8 / 20 / 35 |
| **M403 Clamp Unlock** | Cast-iron clamp shatters with metal fragments and snapping chain links. | Iron shard fragments (`#4B5563`) | 6 / 14 / 24 |
| **M404 Rejoin Flash** | Luminous emerald energy beam pulses between both arch portals upon completion. | Emerald light flare (`#10B981`) | 8 / 18 / 30 |
| **L4500 Finale Win** | Interlocking golden coupling chain fireworks, brass whistles, and ribbon streamers. | Golden chain confetti & sparkles | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Steam jets replaced with clean 150 ms linear opacity fade; screen shake disabled (0 dp).
- **Tier Capping:** Low tier disables additive bloom blur around coupling sparks, rendering simple circular dots.

## Affected Files
- `lib/core/vfx/emitters/coupling_snap_emitter.dart` (to be created)
- `lib/core/vfx/emitters/split_steam_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 9 effect classes)

## Risks
- Frame drop if multiple coupled engines uncouple simultaneously. Mitigation: Split animations serialized or clamped to maximum 2 concurrent emitter instances.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 9 docs.
