Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, ../../VFX_IMPLEMENTATION.md §4.4, §7. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-20-base-mechanics.md.

# Spec: UI — Phase 20 VFX

## Status
Draft

## Type
New Feature

## Goal
Specify the particle animations, haptic feedback, tier budgets, and visual effects for Phase 20 (Levels 9501–10,000) mechanics, extending existing VFX classes.

## Current State
Documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md`, adhering to `VFX_IMPLEMENTATION.md`.

## Proposed Change
Implement Phase 20 VFX mappings in `packages/puzzle_ui/lib/src/vfx/`:

### 1. Mechanic VFX & Haptic Mappings
Reusing shared effect classes per `VFX_IMPLEMENTATION.md` §4.4:

| Event | Effect Class | Visual Presentation | Haptic Trigger |
|---|---|---|---|
| `m951_moving_step` | `spool_roll` + `counter_pop` | Moving guardian steps forward 1 cell with a mechanical ratchet sound and soft thump. | `mediumImpact` |
| `m952_omni_unlock` | `gate_open` + `sparkle_stream` | Omni Gate unlocks with a prismatic multi-color ray burst. | `heavyImpact` |
| `m953_spool_dispense` | `grow_burst` + `lane_warp` | Central spool unrolls a new golden thread with smooth spinning ribbon sparks. | `lightImpact` |
| `m954_master_key_flash` | `key_unlock` + `morph_flash` | Master key unweaves, broadcasting a board-wide golden unlock wave. | `heavyImpact` |
| `l10000_grand_celebration` | `confetti_shower` + `royal_sparkles` | Grand Finale celebration with golden wool fiber confetti and mascot sparkle bursts. | `heavyImpact` |

### 2. Device Tier Budgets & Performance Invariants
Per `VFX_IMPLEMENTATION.md` §7:
- **Low-End Tier ($\le 2\text{ GB}$ RAM):**
  - Instant guardian translation and static celebration banner; maximum 30 active particles.
  - Screen shake disabled (0 dp).
- **Mid-End Tier (2–4 GB RAM):**
  - 200 ms cinematic animations and confetti shower; maximum 80 particles.
  - Screen shake capped at 4 dp.
- **High-End Tier ($> 4\text{ GB}$ RAM):**
  - Full cinematic camera zoom, golden wool fiber showers, and royal mascot aura effects; maximum 150 particles.
  - Full screen shake up to 6 dp.

### 3. Accessibility & Motion Settings
- **Reduce Motion:** When enabled, celebratory confetti showers and camera pans are replaced with instantaneous cross-fades, and screen shake is completely suppressed.

## Affected Files
- `packages/puzzle_ui/lib/src/vfx/phase_20_vfx_coordinator.dart` (to be created)
- `packages/puzzle_ui/lib/src/vfx/particle_presets.dart` (changed: add prismatic omni burst and golden wool confetti presets)

## Risks and Open Questions
- None. Follows established tier budgets and accessibility invariants.

