Source docs: phase_5/06_UI_AND_QA_PHASE_5.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-2.md, specs/ui/phase-4-vfx.md.

# Spec: UI — Phase 5 Visual Effects (VFX)

## Status
Draft

## Type
Improvement (extends VFX engine and particle emitters from `specs/ui/vfx-and-juice.md`, `specs/ui/vfx-phase-2.md`, and `specs/ui/phase-4-vfx.md` for Phase 5 content)

## Goal
Specify particle effects, terrain modification transitions, and tactile juice for the Coconut Grove Physics signature system, Base Mechanics M201–M204, and the Level 2500 Finale, conforming strictly to tier particle budgets, atlas packing, and accessibility standards.

## Current State
Design documented in `phase_5/06_UI_AND_QA_PHASE_5.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Earlier phases established generic effect classes, tier limits (Low 30 / Mid 80 / High 150), and dynamic layer rendering.
- Phase 5 requires visual feedback for earthen pit filling, continuous sliding dust trails, key socketing bursts, and heavy boulder earth tremors.

## Proposed Change
Extend `VfxService` to bind Phase 5 gameplay events to generic effect classes (`VFX_IMPLEMENTATION.md` §4):

### 1. Phase 5 Event to VFX Class Mapping

| Trigger Event / Mechanic | Effect Class | Visual Details | Particle Limits (Low / Mid / High) |
|---|---|---|---|
| M201 Coconut Falls in Pit | `dust_puff` + `state_toggle` | Soft earthen dust ring as coconut settles into pit + green moss expansion | Low: 0, Mid: 10, High: 18 |
| M202 Dew-Slick Slide | `dust_puff` + `lane_warp` | Continuous light mist and dewdrop sparkle trail along the slide path | Low: 0, Mid: 8, High: 16 |
| M203 Key Coconut Unlocks | `state_toggle` + `crack_shards` | Radiant golden brass flare and dissolving lock chains | Low: 0, Mid: 12, High: 24 |
| M204 Heavy Boulder Push | `bump_flash` + `dust_puff` | Earth tremor dust burst, pebble debris, and subtle screen shake (Mid 4 dp, High 6 dp) | Low: 0, Mid: 15, High: 30 |
| Level 2500 Finale Shrine Burst | `win_confetti` + `chest_burst` | Golden shrine fireworks, bursting coconut confetti, and cascading starlight | Low: 30, Mid: 80, High: 150 |

### 2. Rendering Rules & Performance Invariants
- **Atlas Consolidation:** All Phase 5 particle sprites (earthen dust puffs, dew trails, key flares, pebble shards) are compiled into `assets/vfx/atlas.webp`.
- **Single Ticker Dynamic Layer:** Effects are rendered exclusively on the dynamic board layer (`CustomPainter`) managed by one board `Ticker`. Static tiles and filled pit ground textures are committed to the static picture cache.
- **Tier Enforced Caps:** Total live particles across the active viewport cannot exceed **Low: 30, Mid: 80, High: 150** (enforced centrally by `EffectPool`).

### 3. Accessibility & Safe Play
- **Reduce Motion:**
  - Disables earth tremor screen shake on M204 pushes; replaces with clean haptic feedback (`mediumImpact`).
  - Sliding blocks emit zero particle trails under Reduce Motion.
- **Photosensitivity / Contrast:**
  - Key unlocking flare avoids sudden high-luminance flashes; uses smooth 200 ms alpha cross-fade.
  - Pit filled ground texture maintains $\ge 3:1$ contrast against snake bodies.

## Affected Files
- `lib/features/gameplay/presentation/vfx/phase_5_vfx_bindings.dart` (to be created)
- `lib/features/gameplay/presentation/painters/pit_transformation_painter.dart` (to be created)

## Risks
- Frame stutter during multi-tile continuous sliding (M202) if particle generation is unbounded. Controlled by throttling particle spawn interval to $\ge 60\text{ ms}$.

## Open Questions
- None. VFX mappings and particle limits conform to `VFX_IMPLEMENTATION.md` §4 and `phase_5/06_UI_AND_QA_PHASE_5.md`.
