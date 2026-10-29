Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-13-base-mechanics.md.

# Spec: UI — Phase 13 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 13 (Levels 6001–6500) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 13 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m601_scout_reveal` | `gate_open` + `sparkle_stream` | Fog dissolves along the scout path accompanied by glowing silver thread sparkles. | `mediumImpact` |
| `m602_decoy_poof` | `pompom_poof` | Decoy fluff disintegrates into a soft puff of loose wool fibers. | `lightImpact` |
| `m603_painted_reveal` | `morph_flash` | Painted wall sheds its 3D depth in a faint chalk dust flash, transforming into a 2D line. | `selectionClick` |
| `m604_lantern_glow` | `lane_warp` | Warm amber ray expansion radiates outwards from the plate, revealing underlying grid elements. | `lightImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant fog alpha cutout; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 200 ms soft alpha fade with wool dust particles; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Procedural fiber dissolve shader with dynamic warm amber illumination; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, particle streams are replaced with a single static 150 ms cross-fade, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_13_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add wool fluff and chalk dust presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.

