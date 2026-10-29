Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-15-base-mechanics.md.

# Spec: UI — Phase 15 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 15 (Levels 7001–7500) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 15 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m701_switch_toggle` | `lane_warp` | Junction arrow snaps cleanly to new branch with subtle steel click. | `selectionClick` |
| `m702_belt_reverse` | `morph_flash` | Reversing belt inverts direction accompanied by gear ratchet sparks. | `mediumImpact` |
| `m703_lever_click` | `counter_pop` | Clutch lever throws, activating/stopping conveyor lines with brake puff. | `lightImpact` |
| `m704_loop_step` | `spool_roll` | Thread translates 1 cell along track loop with smooth yarn sliding trail. | `lightImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant conveyor shift; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 180 ms conveyor tread slide animations; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Full mechanical feed dog tread animations, gear sparks, and dynamic yarn drop-shadows; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, conveyor tread slides are replaced with an instant 1-cell step jump, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_15_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add gear spark and conveyor tread presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.
