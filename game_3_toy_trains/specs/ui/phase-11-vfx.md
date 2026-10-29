Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-10-vfx.md.

# Spec: Visual Effects — Phase 11 VFX & Twin Table Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-10-vfx.md` for Phase 11 content)

## Goal
Specify the particle emitters, bridge transit sparks, cross-board unlock lasers, mirror synchronization flashes, relay tunnel warps, and haptic feedback for Phase 11 (Twin Tables) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled clockwork rhythm pulses and departure flares.
- Phase 11 requires cross-table bridge traversal effects and dual-board portal transitions.

## Proposed Change
Extend `VfxService` with Phase 11 twin table effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Cross-Table Dynamics & Transit Effects
- **Bridge Transfer Glow (M501):** As a train crosses the Table Bridge trestle, amber light radiates through the wooden slats accompanied by rhythmic wheel clack audio.
- **Cross-Board Unlock Laser (M502):** Collecting an Inter-table Ticket fires an energetic cyan projectile across the gap from Table A to Table B, detonating into a starburst at the barrier gate (`BlendMode.plus`).

### 2. Base Mechanics (M501–M504) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M501 Bridge Transfer** | Golden spark flecks kick up from bridge ties under locomotive wheels. | Amber spark flecks (`#F59E0B`) | 6 / 14 / 22 |
| **M502 Ticket Unlock** | Flying cyan tracer beam with starburst detonation on target barrier. | Cyan energy particle stream (`#06B6D4`) | 8 / 20 / 35 |
| **M503 Mirror Sync Flash** | Synchronized sapphire sparkle burst above both twin train cabs upon dispatch. | Sapphire sparkle ring (`#3B82F6`) | 6 / 16 / 28 |
| **M504 Relay Portal Warp** | Concentric gravitational vortex swirl at entrance and reverse flash at exit. | Violet warp vortex (`#8B5CF6`) | 8 / 18 / 32 |
| **L5500 Finale Win** | Twin Grand Central firework barrage spanning both tables simultaneously. | Dual-colored confetti & fireworks | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Tracer beams and warp swirls replaced with simple 120 ms linear fade line; camera shake locked to 0 dp.
- **Tier Capping:** Low tier disables additive bloom on cross-board beams, maintaining solid 60 fps across dual sub-board rendering.

## Affected Files
- `lib/core/vfx/emitters/bridge_transfer_emitter.dart` (to be created)
- `lib/core/vfx/emitters/cross_ticket_laser_emitter.dart` (to be created)
- `lib/core/vfx/emitters/relay_warp_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 11 effect classes)

## Risks
- Rendering two sub-boards simultaneously while emitting cross-board lasers could cause frame drops on older GPUs. Mitigation: Emitter count capped strictly at 30 particles on Low tier.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 11 docs.
