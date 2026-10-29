# Spec: Phase 15 VFX — Brook & Rails Visual Effects

Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-15-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 VFX — Brook & Rails Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Define all visual effects for Phase 15 Brook & Rails mechanics (water drift foam wakes, sluice gate flip splash, tidal flow reversal bubbles, lazy river orbit ripples, and L7500 Rushing Waters celebration) within established particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Water Drift (M701) | `lane_warp` | Ant line glides effortlessly along stream with tiny white foam wakes (180 ms). | 6 / 18 / 35 |
| Sluice Gate Flip (M703) | `state_toggle` | Sturdy wooden gate pivots with hollow clunk, splashing sparkling water spray. | 8 / 22 / 45 |
| Tidal Reversal (M702) | `lane_warp` | Stream ripples decelerate, pause for 1 frame, and wash forcefully in reverse with bubbly foam. | 10 / 25 / 50 |
| Lazy Orbit (M704) | `state_toggle` | Serene circular water ripples accompany orbiting insects with floating water-lily petals. | 6 / 20 / 40 |
| L7500 Finale Win | `win_confetti` | Grand Rushing Waters Gala: geyser-like water fountains, shimmering iridescent bubbles, confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`lane_warp`, `state_toggle`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Conveyor drift foam wakes across multiple simultaneous drifting lines are pooled and clamped below the active tier budget.

### Reduce Motion Adjustments
- `lane_warp` Water Drift: Foam wakes disabled; smooth linear translation without trailing splash particles.
- `state_toggle` Sluice Gate Flip: Instantaneous gate sprite flip without water splash spray.
- `lane_warp` Tidal Reversal: Arrow direction flips instantly without reverse washing wave or bubble bursts.
- `state_toggle` Lazy Orbit: Concentric water ripples disabled; clean icon rotation only.
- `win_confetti` L7500 Finale: Static celebratory water fountain banner with subtle cross-fade.

### Colour-Blind Accessibility
- Flowing brook directions are marked by bold, high-contrast chevron lines independent of water colour.
- Sluice valves use high-contrast open/closed silhouettes (Open = Vertical bar, Closed = Horizontal cross-bar).

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables foam wakes, water sprays, and screen shake.
- [ ] High-contrast directional glyphs communicate stream direction under all forms of colour-blindness.
- [ ] L7500 finale celebration does not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/water_drift_wake.dart` | To be created |
| `packages/vfx/lib/effects/sluice_flip_splash.dart` | To be created |
| `packages/vfx/lib/effects/tidal_reversal_wave.dart` | To be created |
| `packages/vfx/lib/effects/lazy_orbit_ripple.dart` | To be created |
| `packages/vfx/lib/effects/rushing_waters_confetti.dart` | To be created |
| `assets/phase_15/vfx/` | To be created |

---

## Risks and Open Questions

1. **Multiple Concurrent Drifts:** In levels with 4–6 ants drifting simultaneously across connected streams, individual particle emitters must be batched through a single shared particle pool to prevent draw call spikes.
