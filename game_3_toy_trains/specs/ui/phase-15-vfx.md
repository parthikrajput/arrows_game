Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-14-vfx.md.

# Spec: Visual Effects — Phase 15 VFX & Moving Platforms Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-14-vfx.md` for Phase 15 content)

## Goal
Specify the particle emitters, industrial motor steam exhausts, roller gear sparks, conveyor slip dust, pneumatic hiss vents, and haptic feedback for Phase 15 (Moving Platforms) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled glacial ice glints and alpine snow flurries.
- Phase 15 requires industrial motorized friction, pneumatic exhaust jets, and continuous tread motion feel.

## Proposed Change
Extend `VfxService` with Phase 15 industrial conveyor effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Motorized Conveyor & Mechanical Dynamics
- **Motor Exhaust Steam (M701–M704):** Conveyor drive drums emit rhythmic rhythmic white steam puffs during active belt transport.
- **Conveyor Slip Friction (Step 3):** When a train is held stationary while the belt slips underneath, rubber tread smoke motes (`#6B7280`) emerge from wheel contacts.
- **Pneumatic Brake Vent (M703):** Clamping the brake releases a high-pressure lateral air hiss with fine vapor droplets.

### 2. Base Mechanics (M701–M704) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M701 Switch Shift** | Industrial ratchet clack with brass gear teeth friction sparks. | Brass gear sparks (`#F59E0B`) | 4 / 12 / 20 |
| **M702 Belt Reversal** | Motor backfire steam burst and screeching roller sparks. | Motor steam & friction sparks | 6 / 15 / 25 |
| **M703 Brake Clamp** | High-pressure pneumatic air blast jet venting laterally. | Pressurized air vapor (`#E5E7EB`) | 6 / 16 / 28 |
| **M704 Loop Drive** | Continuous faint oil droplets and centrifugal gear sparkles along ring. | Machine oil droplets (`#374151`) | 4 / 10 / 18 |
| **L7500 Finale Win** | Automated yard celebration: cascading brass gear fireworks, factory steam whistles, golden cog confetti. | Brass gears & steam flares | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Pneumatic air blasts replaced with 100 ms opacity fade; motor vibration rumble disabled.
- **Tier Capping:** Low tier disables continuous oil particle drift on loop belts, using stationary static ring sheen.

## Affected Files
- `lib/core/vfx/emitters/motor_steam_emitter.dart` (to be created)
- `lib/core/vfx/emitters/pneumatic_vent_emitter.dart` (to be created)
- `lib/core/vfx/emitters/conveyor_slip_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 15 effect classes)

## Risks
- Multiple concurrent conveyor belts generating continuous particle spam. Mitigation: Static throttling limits total conveyor idle particles to $\le 15$ on low tier.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 15 docs.
