Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-14-base-mechanics.md.

# Spec: UI — Phase 14 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 14 (Levels 6501–7000) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 14 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m651_mirror_unravel` | `lane_warp` + `sparkle_stream` | Dual twin threads unravel simultaneously with silver sparkle trails along both trajectories. | `mediumImpact` |
| `m652_reflect_unlock` | `key_unlock` + `morph_flash` | Unlocking one clasp sends a brilliant light burst across the seam, popping the mirror clasp open. | `heavyImpact` |
| `m653_twin_quilt_flip` | `counter_pop` | Quilt toggle flip radiates a twin ripple across the fabric canvas, updating dual state. | `selectionClick` |
| `m654_inverse_motion` | `spool_roll` | Inverse thread glides smoothly in reverse with a subtle glass reflection shimmer trail. | `lightImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant twin unravel motion; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 180 ms silver shimmer trails and mirror wave pulses; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Full silver thread reflection particles, resonant bloom pulses, and dynamic dual shaders; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, particle streams are replaced with a single static 150 ms cross-fade, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_14_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add silver shimmer and resonant mirror presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.

