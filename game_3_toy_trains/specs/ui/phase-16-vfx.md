Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-15-vfx.md.

# Spec: Visual Effects — Phase 16 VFX & Ticket Office Game Feel

## Status
Draft

## Type
Improvement (extends VFX catalog and particle emitters from `specs/ui/phase-15-vfx.md` for Phase 16 content)

## Goal
Specify the particle emitters, ticket punch confetti bursts, chain link shattering sparks, master pass universal unlock flares, swap pad energy arcs, and haptic feedback for Phase 16 (Ticket Office) of Toy Trains: Wooden Railway Puzzle, maintaining strict device tier performance limits.

## Current State
Design documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md` and `../../VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases handled industrial conveyor friction and pneumatic vents.
- Phase 16 requires brass mechanical punch clicks, paper confetti showers, and golden unlock flashes.

## Proposed Change
Extend `VfxService` with Phase 16 ticket office effects adhering to tier particle budgets (Low 30 / Mid 80 / High 150):

### 1. Key Crafting & Unlock Dynamics
- **Ticket Punch Clack (M752):** Stamping stubs inside the booth releases a crisp brass punch clack, haptic tick, and shower of stamped paper circular chads (`#FEF08A`, `#FDE047`).
- **Chain Release Flash (M751):** Unlocking barrier reveals nested ticket car with snapping golden chain particles and metallic ping sound.
- **Master Pass Starburst (M753):** Consuming the Master Pass creates a radiant 360° golden starburst (`BlendMode.plus`) that dissolves the target barrier.

### 2. Base Mechanics (M751–M754) Particle Catalog
| Mechanic / Event | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M751 Chain Snap** | Snapping golden chain links scattering outward as barrier opens. | Brass chain fragments (`#D97706`) | 6 / 14 / 22 |
| **M752 Ticket Punch** | Conductor punch stamp confetti burst of colored paper chads. | Paper punch chads (`#FBBF24`) | 8 / 20 / 35 |
| **M753 Master Unlock** | Radiant omni-color starburst vaporizing barrier gate instantly. | Golden starburst flare (`#F59E0B`) | 8 / 20 / 35 |
| **M754 Ticket Swap** | Electric cyan magnetic arc jumping between swap pad trains. | Cyan energy arc (`#06B6D4`) | 6 / 15 / 26 |
| **L8000 Finale Win** | Master Bureau celebration: golden ticket streamer barrage, brass bell chimes, fireworks. | Golden ticket ribbons & stars | 30 / 80 / 150 |

### 3. Accessibility & Performance Constraints
- **Reduce Motion:** Punch chads and starburst flares replaced with simple 120 ms brightness fade; screen shake set to 0 dp.
- **Tier Capping:** Low tier disables additive blend modes on starburst flares, rendering solid flat star sprites.

## Affected Files
- `lib/core/vfx/emitters/ticket_punch_emitter.dart` (to be created)
- `lib/core/vfx/emitters/master_pass_emitter.dart` (to be created)
- `lib/core/vfx/emitters/swap_arc_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 16 effect classes)

## Risks
- Rapid chaining of unlocks causing multiple starbursts to overlap. Mitigation: Throttled to max 2 concurrent unlock bursts per frame.

## Open Questions
- None. VFX assets and particle thresholds match `VFX_IMPLEMENTATION.md` and Phase 16 docs.
