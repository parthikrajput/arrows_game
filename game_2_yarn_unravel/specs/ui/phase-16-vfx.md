Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-16-base-mechanics.md.

# Spec: UI — Phase 16 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 16 (Levels 7501–8000) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 16 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m751_chain_step` | `counter_pop` | Numbered charm badge pulses with gold shimmer, unlocking next link. | `selectionClick` |
| `m752_craft_forge` | `morph_flash` + `sparkle_stream` | Both key halves fuse together in a brilliant starburst flash, forging the master key. | `heavyImpact` |
| `m753_skeleton_unlock` | `key_unlock` | Skeleton key touches clasp, snapping it open with golden shimmer dust. | `mediumImpact` |
| `m754_color_swap` | `lane_warp` | Swap hoop radiates a dual-color chromatic wave as colors invert. | `lightImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant key unlock and snap forge; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 200 ms crafting sparks and golden flash; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Full jeweled shimmer particles, key forging light bursts, and chromatic dust trails; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, key forging montage is replaced with an instantaneous cross-fade, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_16_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add key forge starburst and chromatic swap presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.
