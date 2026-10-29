Source docs: phase_3/06_UI_AND_QA_PHASE_3.md, ../../VFX_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-2.md.

# Spec: UI — Phase 3 Visual Effects (VFX)

## Status
Draft

## Type
Improvement (extends VFX engine and particle emitters from `specs/ui/vfx-and-juice.md` and `specs/ui/vfx-phase-2.md` for Phase 3 content)

## Goal
Specify particle effects, board illumination shaders, and visual feedback for the Day & Night cycle system, Base Mechanics M101–M104, and the Level 1500 Finale, conforming strictly to tier particle caps and accessibility standards.

## Current State
Design documented in `phase_3/06_UI_AND_QA_PHASE_3.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Phase 1 & 2 established particle pools and effect classes in `specs/ui/vfx-and-juice.md` and `specs/ui/vfx-phase-2.md`.
- Phase 3 requires atmospheric cycle lighting and visual event mappings for M101–M104 without introducing unbudgeted shader passes.

## Proposed Change
Extend `VfxService` to bind Phase 3 gameplay events to generic effect classes (standard §4):

### 1. Phase 3 Event to VFX Class Mapping
| Trigger Event | Effect Class | Visual Details | Particle Limits (Low / Mid / High) |
|---|---|---|---|
| Day ↔ Night Swap | `morph_flash` + ambient tween | 300 ms board-wide soft ambient wave: warm gold (Day) or deep sapphire (Night) | Low: 0, Mid: 15, High: 30 |
| M101 Sun-Moon Gate Toggle | `state_toggle` | Luminous stone shimmer and ancient glyph glow on open/close | Low: 0, Mid: 8, High: 16 |
| M102 Moonlight Bridge Form | `lane_warp` | Silver root filaments weave across void with soft starlight sparkles | Low: 0, Mid: 10, High: 20 |
| M103 Day-Night Burrows Warp | `portal_whoosh` | Dual-spiral golden/silver vortex when snake enters burrow | Low: 0, Mid: 12, High: 24 |
| M104 Flower Color Shift | `morph_flash` | Petals unfurl with swirling pollen bursts in active cycle color | Low: 0, Mid: 8, High: 16 |
| Variant `Frozen(K)` Thaw | `crack_shards` | Crystalline ice shatters into geometric shards | Low: 0, Mid: 10, High: 20 |
| Level 1500 Finale Burst | `win_confetti` + `chest_burst` | Grand celestial fireworks with cascading sun and moon coins | Low: 30, Mid: 80, High: 150 |

### 2. Rendering Rules & Performance Invariants
- **Atlas Consolidation:** All Phase 3 particle sprites (sun rays, silver roots, petals) are packed into `assets/vfx/atlas.webp`.
- **Single Ticker Dynamic Layer:** Effects render strictly on the dynamic board layer (`CustomPainter`) managed by one board `Ticker`. Static tiles and inactive obstacles remain cached.
- **Tier Caps:** Total active particles on screen cannot exceed **Low: 30, Mid: 80, High: 150** (standard §5).

### 3. Accessibility & Safe Play
- **Reduce Motion:** Disables ambient flash waves and portal vortex swirls; uses soft 150 ms cross-fades.
- **Photosensitivity / Contrast:** Ambient lighting tweens avoid harsh strobing. Board tile contrast remains >= 3:1 against snake bodies in both Day and Night states.

## Affected Files
- `lib/features/gameplay/presentation/vfx/phase_3_vfx_bindings.dart` (to be created)
- `lib/features/gameplay/presentation/painters/cycle_ambient_overlay.dart` (to be created)

## Risks
- Rapid 5-move cycling causing visual fatigue. Mitigated by soft color temperatures and subtle easing curves.

## Open Questions
- None. VFX mappings and particle limits conform to `VFX_IMPLEMENTATION.md` §4 and `phase_3/06_UI_AND_QA_PHASE_3.md`.
