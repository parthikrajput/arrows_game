Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-4.md.

# Spec: Visual Effects — Phase 5 VFX & Shunting Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-4-vfx.md` for Phase 5 content)

## Goal
Specify the particle emitters, impact shaders, and tactile visual juice effects for Phase 5 (Yard Shunting+) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled vertical transitions and lighting shifts.
- Phase 5 requires physical shunting feedback, sliding friction particles, and pit impact effects.

## Proposed Change
Extend `VfxService` with Phase 5 shunting effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Shunting Impact Dynamics
When a locomotive strikes a push cart:
- **Coupling Impact:** Miniature wooden buffer rebound animation (150 ms ease-out).
- **Sawdust Ring:** Radial sawdust particle ring emitted at contact buffers (Low: 6 / Mid 14 / High 24 particles).

### 2. Base Mechanics (M201–M204) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M201 Cart Pit Fill** | Heavy downward thud dust cloud as cart settles into the pit; wooden planks snap flush with track. | Dense wood dust plume (`#8D6E63`) | 8 / 18 / 32 |
| **M202 Ice Cart Slide** | Frictionless crystalline frost trail and icy mist wisps streaming behind sliding cart. | Cyan ice crystals (`#E0F7FA`) | 10 / 25 / 50 |
| **M203 Ticket Cart Pad** | Expanding golden key ring and sparkling star burst when cart locks onto pad. | Golden star sparkle burst (`#FBBF24`) | 8 / 20 / 35 |
| **M204 Ballast Resistance**| Engine boiler strains against heavy cart; dual dark soot puffs vent from smokestack. | Dark grey smoke puff (`#374151`) | 6 / 15 / 25 |
| **L2500 Finale Win** | Triple brass whistle fireworks, golden shunting wrench ribbons, and confetti cascades. | Shunting wrench confetti & gold stars | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Heavy screen micro-shakes (2–4 dp) are clamped to 0 dp; impact dust rings replaced with a gentle 150 ms flash.
- **Battery Saver Mode:** Continuous ice sliding mist particles disabled; cart renders with static frost aura.

## Affected Files
- `lib/core/vfx/emitters/shunting_impact_emitter.dart` (to be created)
- `lib/core/vfx/emitters/frost_trail_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 5 effect classes)

## Risks
- Rapid successive cart shunts overwhelming particle emitter pools. Mitigation: Emitter pool recycles active particles and clamps concurrent emitters to max 3.

## Open Questions
- None. All effect classes and particle caps match `VFX_IMPLEMENTATION.md` and Phase 5 docs.

