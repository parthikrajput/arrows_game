Source docs: phases/phase_7/06_UI_AND_QA_PHASE_7.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-6-vfx.md.

# Spec: UI — Phase 7 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement the hardware-accelerated rotational swoosh animations, perimeter dust shifts, spinning snake directional flares, and celebratory summit bursts for Phase 7 (Levels 3001–3500), respecting device performance budgets and accessibility guidelines.

## Current State
Design documented in `phases/phase_7/06_UI_AND_QA_PHASE_7.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered optical beam glows, flares, and shadow dissolving.
- Phase 7 requires 4×4 canvas rotation matrix transitions and perimeter sliding particle effects.

## Proposed Change
Extend `lib/features/vfx/` with Phase 7 rotational effect classes:

### 1. Phase 7 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M301 Sub-board Rotation** | `rotate_swoosh` | 4×4 sub-board rotates 90° CW over 350 ms with swirling leaves and circular motion blur | Low: 0 particles (matrix transform only)<br>Mid: 15 particles<br>High: 30 particles |
| **M302 Shifting Hedges** | `dust_puff` | Border hedge advances 1 cell with a localized earthy dust puff along the perimeter line | Low: 0 particles<br>Mid: 6 particles<br>High: 12 particles |
| **M303 Spinning Snake Turn** | `lane_warp` | Snake head direction pivots 90° CW with an emerald spiral spark trailing the turn | Low: 0 particles<br>Mid: 8 particles<br>High: 16 particles |
| **M304 Gear Lock Latch** | `state_toggle` + `badge_pulse` | Stone gear gate grinds open with stone grinding dust and a mechanical bronze chime | Low: 0 particles<br>Mid: 10 particles<br>High: 20 particles |
| **L3500 Finale Summit Burst** | `win_confetti` + `chest_burst` | Grand summit cyclone burst, golden autumn leaves, sparkling stars, and victory banner | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Device Tier Limits & Performance Invariant
- **No Layer Re-Recording During Rotation:**
  - The 4×4 sub-board area is rendered to a cached `Picture` or offscreen texture.
  - The 350 ms rotation animation executes via a single hardware-accelerated `Canvas.rotate` matrix transform around the local center point $(x_c, y_c)$ without triggering Flutter widget tree rebuilds.
- **Particle Capping:**
  - Low-Tier: Max concurrent **30 particles**.
  - Mid-Tier: Max concurrent **80 particles**.
  - High-Tier: Max concurrent **150 particles**.

---

### 3. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - 4×4 sub-board rotation executes as an instantaneous **100 ms snap cut** instead of a 350 ms continuous rotation.
  - Swirling leaf particle emitters are suppressed.
  - Camera shake on gear gate opening is disabled.

## Affected Files
- `lib/features/vfx/effects/phase_7/rotor_swoosh_painter.dart` — to be created
- `lib/features/vfx/effects/phase_7/hedge_dust_emitter.dart` — to be created
- `lib/features/vfx/effects/phase_7/spin_turn_flare.dart` — to be created
- `lib/features/vfx/vfx_service.dart` — changed

## Risks and Open Questions
- **Visual Tearing at Sub-Board Edges:** Rotating a 4×4 sub-grid inside a static 14×14 board could show visible seams or pixel tearing at boundary cell edges.
  - *Mitigation:* Sub-board boundary is masked with an anti-aliased circular clip boundary with a 2 dp mossy stone rim outline.

