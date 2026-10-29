Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-3.md.

# Spec: Visual Effects — Phase 4 VFX & Multi-Floor Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-3-vfx.md` for Phase 4 content)

## Goal
Specify the visual effects (VFX), vertical elevation particle systems, and glass platform shaders for Phase 4 (Station Floors) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled planar particle dynamics and day/night ambient tweens.
- Phase 4 requires vertical movement feedback, elevator hydraulics, and glass deck specular optics.

## Proposed Change
Extend `VfxService` with Phase 4 vertical effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Floor Camera Transition Juice
- When transitioning between floors (e.g. F1 -> F2):
  - Camera vertical pan accompanied by subtle directional motion streak lines.
  - Inactive floor gently fades opacity to 0.15 while target floor snaps into crisp focus.
  - Soft wooden whoosh sound with zero frame hitching.

### 2. Base Mechanics (M151–M154) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M151 Station Stairs** | Incline steam puffs scaling downward/upward along the stair ramp angle. | Miniature steam balls (`#ECEFF1`) | 6 / 15 / 25 |
| **M152 Glass Platform** | Specular glass reflection ping glints as locomotive wheels cross the platform. | 4-point glass glint flare (`#E0F7FA`) | 4 / 10 / 16 |
| **M153 Goods Chute** | Freefall drop lines followed by a circular sawdust shockwave ring upon lower floor landing. | Impact sawdust puff (`#D7CCC8`) | 8 / 20 / 35 |
| **M154 Goods Lift** | Pressurized hydraulic steam venting from elevator pistons during vertical transit. | Horizontal pressurized steam jet | 10 / 25 / 45 |
| **L2000 Finale Win** | Cascading multi-tier confetti fountains bursting simultaneously on F1, F2, and F3. | Golden star confetti & ribbon coils | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Vertical transitions jump instantaneously (0 ms) without motion blur; hydraulic steam vents replaced with static icon pips.
- **Tier Capping:** Low tier disables real-time glass platform specular shaders, utilizing a flat tinted polygon texture.

## Affected Files
- `lib/core/vfx/emitters/elevator_steam_emitter.dart` (to be created)
- `lib/core/vfx/emitters/chute_impact_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 4 effect classes)

## Risks
- Multi-floor particle overdraw if emitters are active on all three floors simultaneously. Mitigation: Emitters on inactive floors are automatically paused and culled.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 4 docs.

