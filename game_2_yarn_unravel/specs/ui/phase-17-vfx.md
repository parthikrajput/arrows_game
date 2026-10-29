Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-17-base-mechanics.md.

# Spec: UI — Phase 17 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 17 (Levels 8001–8500) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 17 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m801_pin_extract` | `counter_pop` + `burst_sparks` | Pin lifts from velvet cushion with golden sparks, decreasing HP. | `mediumImpact` |
| `m801_guardian_collapse` | `gate_open` + `morph_flash` | Pincushion deflates into unravelled silk ribbons upon reaching 0 HP. | `heavyImpact` |
| `m802_shield_deflect` | `blocked_bump` | Metallic shield deflection with ring sparks and clank audio cue. | `rigidImpact` |
| `m803_button_spawn` | `grow_burst` | Pincushion sprouts a new wooden button blocker in an adjacent cell. | `lightImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant pin pop and HP drop; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 200 ms pin-pull animation with burst sparks; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Full velvet ripple distortion, dynamic pin-extraction dust, and guardian ribbon dissolve; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, pin extractions are replaced with an instantaneous cross-fade, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_17_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add pin extract sparks and silk ribbon dissolve presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.
