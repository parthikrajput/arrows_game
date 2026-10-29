Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-19-base-mechanics.md.

# Spec: UI — Phase 19 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 19 (Levels 9001–9500) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 19 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m901_twirl_fall` | `spool_roll` + `counter_pop` | Thread twirls 90° with a metallic spin and slides smoothly in gravity direction. | `mediumImpact` |
| `m902_rotor_spin_grow` | `lane_warp` + `grow_burst` | 90° rotor turn with floating leaf bursts, redirecting ivy tendril growth. | `heavyImpact` |
| `m903_rhythm_step` | `counter_pop` | Belt snaps 1 cell forward in exact sync with rhythmic metronome tick audio. | `selectionClick` |
| `m904_seam_split_pass` | `morph_flash` + `burst_sparks` | Thread passes boundary seam, flashing with dual-strand particle split trails. | `mediumImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant rotation and step translation; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 200 ms spin and sprout animations; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Organic leaf particles, metallic thread spin trails, and dynamic drop shadows; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, spinning and sprouting animations are replaced with instantaneous cross-fades, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_19_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add organic leaf burst and metallic spin presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.

