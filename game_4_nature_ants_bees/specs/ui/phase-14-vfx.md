# Spec: Phase 14 VFX — Reflecting Pond Visual Effects

Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-14-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 VFX — Reflecting Pond Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Define all visual effects for Phase 14 Reflecting Pond mechanics (axis ripple wave, reflection lock water splash, twin pond ripple, inverted dash aquatic trail, and L7000 Mirrored Solstice celebration) conforming to particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Axis Ripple (M651) | `lane_warp` | Shimmering cerulean water wave pulses across the axis as mirrored insects move in unison. | 8 / 22 / 45 |
| Reflection Unlock (M652) | `state_toggle` | Water droplet splash erupts from the pond surface, shattering the lock into crystalline spray. | 10 / 25 / 50 |
| Twin Pond Tap (M653) | `state_toggle` | Dual water ripples expand from tap origin in both ponds simultaneously. | 6 / 18 / 35 |
| Inverted Dash (M654) | `lane_warp` | Insect dashes with rippling aquatic trail, splashing reverse droplets behind its departure. | 8 / 20 / 40 |
| L7000 Finale Win | `win_confetti` | Grand Mirrored Solstice Gala: dual rainbow light arcs, glowing water lilies, golden confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`lane_warp`, `state_toggle`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous twin dashes clamp total droplet emissions below the tier ceiling.

### Reduce Motion Adjustments
- `lane_warp` Axis Ripple: Water pulse waves disabled; static blue line brightness increase only.
- `state_toggle` Reflection Unlock: Lock fades out over 0.1 s; droplet burst disabled.
- `state_toggle` Twin Pond Tap: Simple static touch ring without expanding concentric ripples.
- `lane_warp` Inverted Dash: Reverse splash droplets disabled; direct line translation only.
- `win_confetti` L7000 Finale: Static celebratory dual-rainbow banner with smooth opacity fade.

### Colour-Blind Accessibility
- Cerulean water ripples (`#29B6F6`) are accompanied by geometric concentric ring overlays.
- Mirrored twin lines display matching non-colour symbols (e.g. Star ↔ Star, Diamond ↔ Diamond) on their dorsal plates.

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables flying water droplets, wave ripples, and screen shake.
- [ ] Dorsal symbols identify mirrored twin pairs under all types of colour-blindness.
- [ ] L7000 finale celebration does not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/axis_ripple_effect.dart` | To be created |
| `packages/vfx/lib/effects/reflection_unlock_splash.dart` | To be created |
| `packages/vfx/lib/effects/twin_pond_tap_ripple.dart` | To be created |
| `packages/vfx/lib/effects/inverted_dash_trail.dart` | To be created |
| `packages/vfx/lib/effects/mirrored_solstice_confetti.dart` | To be created |
| `assets/phase_14/vfx/` | To be created |

---

## Risks and Open Questions

1. **Dual Trajectory Droplet Clutter:** In rapid moves with multiple mirrored lines, droplet particles on both shores must not obscure active board obstacles.
