Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-18-base-mechanics.md.

# Spec: UI — Phase 18 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 18 (Levels 8501–9000) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 18 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m851_cycle_crate_push` | `spool_roll` + `lane_warp` | Cycle crate glides with wooden sliding audio and subtle Day/Night dust trail. | `mediumImpact` |
| `m852_floor_beam_pass` | `sparkle_stream` | Light ray passes through floor; both layers display golden prism sparkles. | `lightImpact` |
| `m853_fogged_stair_reveal`| `pompom_poof` + `gate_open` | Wool fluff dissolves into fine fibers, revealing the staircase beneath. | `mediumImpact` |
| `m854_satin_unlock` | `key_unlock` + `morph_flash` | Crate impacts clasp, triggering a lock snap flash and fabric dissolve burst. | `heavyImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant crate slides and direct beam cutouts; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 180 ms parallax floor animations; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Full multi-layer optical refraction shaders, fiber dust puffs, and crate drop shadows; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, multi-layer parallax and sliding montages are replaced with instantaneous cross-fades, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_18_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add vertical beam sparkles and satin dissolve presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.
