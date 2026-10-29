Source docs: phase_4/06_UI_AND_QA_PHASE_4.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-2.md, specs/ui/phase-3-vfx.md.

# Spec: UI — Phase 4 Visual Effects (VFX)

## Status
Draft

## Type
Improvement (extends VFX engine and particle emitters from `specs/ui/vfx-and-juice.md`, `specs/ui/vfx-phase-2.md`, and `specs/ui/phase-3-vfx.md` for Phase 4 content)

## Goal
Specify particle effects, camera transition visuals, and aesthetic juice for the Great Tree Floors signature system, Base Mechanics M151–M154, and the Level 2000 Finale, conforming strictly to tier particle budgets, atlas packing, and accessibility standards.

## Current State
Design documented in `phase_4/06_UI_AND_QA_PHASE_4.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Phase 1–3 established generic effect classes, tier limits (Low 30 / Mid 80 / High 150), and dynamic layer rendering.
- Phase 4 requires visual feedback for vertical floor transitions, transparent glass refraction, gravity drops, and elevator mechanics.

## Proposed Change
Extend `VfxService` to bind Phase 4 gameplay events to generic effect classes (`VFX_IMPLEMENTATION.md` §4):

### 1. Phase 4 Event to VFX Class Mapping

| Trigger Event / Mechanic | Effect Class | Visual Details | Particle Limits (Low / Mid / High) |
|---|---|---|---|
| Floor Camera Slide | `lane_warp` | Gentle vertical sweep across screen with subtle floating jungle leaves | Low: 0, Mid: 10, High: 20 |
| M151 Root Stairs Transition | `portal_whoosh` | Emerald leaf sparkles and spiraling vine twirls as snake enters/exits stair cell | Low: 0, Mid: 8, High: 16 |
| M152 Dewglass Floor Passage | `beam_glow` | Crystal specular gleam and dew shimmer as snake body slides over glass tile | Low: 0, Mid: 6, High: 12 |
| M153 Knot Hole Drop | `dust_puff` | Soft dust ring at knot hole rim upon entry, and soft landing cloud on lower floor | Low: 0, Mid: 10, High: 18 |
| M154 Vine Lift Movement | `state_toggle` + `dust_puff` | Creaking vine tension spark and platform settling dust when lift shifts floors | Low: 0, Mid: 12, High: 24 |
| Level 2000 Finale Crown Burst | `win_confetti` + `chest_burst` | Grand canopy crown fireworks, golden foliage burst, and cascading jungle gems | Low: 30, Mid: 80, High: 150 |

### 2. Rendering Rules & Performance Invariants
- **Atlas Consolidation:** All Phase 4 particle sprites (stair leaves, crystal sheen, dew droplets, bark dust) are compiled into `assets/vfx/atlas.webp`.
- **Single Ticker Dynamic Layer:** Effects are rendered exclusively on the dynamic board layer (`CustomPainter`) managed by one board `Ticker`. Inactive floors and stationary tiles remain cached via `PictureRecorder`.
- **Tier Enforced Caps:** Total live particles across the active viewport cannot exceed **Low: 30, Mid: 80, High: 150** (enforced centrally by `EffectPool`).

### 3. Accessibility & Safe Play
- **Reduce Motion:**
  - Disables the camera sweep leaf particles and platform vibration dust.
  - Replaces the 200 ms camera vertical slide with an instant cut or 100 ms cross-fade.
- **Photosensitivity / Contrast:**
  - M152 Dewglass Floor maintains high-contrast border outlines ($\ge 3:1$ contrast against both the floor background and snake textures) so see-through tiles remain clearly legible for players with visual impairments.
  - Screen shake is strictly disabled on Low-tier profiles and replaced with haptic feedback (`mediumImpact`).

## Affected Files
- `lib/features/gameplay/presentation/vfx/phase_4_vfx_bindings.dart` (to be created)
- `lib/features/gameplay/presentation/painters/dewglass_overlay_painter.dart` (to be created)

## Risks
- Frame drops during simultaneous camera slide and particle emission on older GPUs. Mitigated by skipping particle emission during camera translation on Low and Mid tiers.

## Open Questions
- **OD-P4-02:** Confirmation of silhouette alpha level (30% opacity) for snakes partially visible through Dewglass on adjacent floors.
