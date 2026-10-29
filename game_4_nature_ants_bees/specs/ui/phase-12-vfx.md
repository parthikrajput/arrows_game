# Spec: Phase 12 VFX — Falling Leaves Visual Effects

Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-12-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 VFX — Falling Leaves Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Define all visual effects for Phase 12 Falling Leaves mechanics (gravity shift wind sweep, acorn tumble dust, dandelion zero-g float, heavy beetle slide rumble, and L6000 Autumn Gale celebration) conforming to particle tier budgets, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Gravity Shift (M551) | `lane_warp` | Fresh gust of autumn wind sweeps across board carrying fluttering golden leaves (160 ms). | 10 / 25 / 50 |
| Acorn Tumble (M552) | `dust_puff` | Soft earthy thump and tiny dirt puff as acorn drops 1 tile into resting position. | 6 / 18 / 35 |
| Dandelion Float (M553) | `state_toggle` | Gentle white dandelion seeds drift upwards in zero gravity aura as item rests on tile. | 8 / 22 / 40 |
| Beetle Drift (M554) | `guardian_hit` | Subdued ground rumble and leaf rustle as heavy beetle line slides 1 step. | 6 / 20 / 40 |
| L6000 Finale Win | `win_confetti` | Grand Autumn Gale Gala: whirlwind of scarlet and amber maple leaves, honey rain cascades. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`lane_warp`, `dust_puff`, `state_toggle`, `guardian_hit`, `win_confetti`). No unapproved effect classes are used.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous falls across multiple lanes are aggregated and capped at the tier's per-frame maximum limit.

### Reduce Motion Adjustments
- `lane_warp` Gravity Shift: Wind sweep particles disabled; instantaneous compass rotation without flying leaves.
- `dust_puff` Acorn Tumble: Instantaneous cell shift; dust puff particles disabled.
- `state_toggle` Dandelion Float: Static glowing white ring; no floating filament seeds.
- `guardian_hit` Beetle Drift: Screen shake disabled; subtle 0.1 s opacity trail only.
- `win_confetti` L6000 Finale: Static celebratory autumn wreath overlay with subtle cross-fade.

### Colour-Blind Accessibility
- Golden leaf particles supplemented with distinct maple and oak leaf silhouettes.
- Gravity compass uses bold directional arrows with high-contrast numerical headings.
- Dandelion tiles utilize embossed flower-head textures distinguishable without colour cues.

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables flying leaves, dirt puffs, and screen shake.
- [ ] High-contrast directional shapes ensure full clarity under Protanopia, Deuteranopia, and Tritanopia.
- [ ] L6000 finale fireworks do not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/gravity_shift_wind_effect.dart` | To be created |
| `packages/vfx/lib/effects/acorn_tumble_effect.dart` | To be created |
| `packages/vfx/lib/effects/dandelion_float_effect.dart` | To be created |
| `packages/vfx/lib/effects/beetle_drift_effect.dart` | To be created |
| `packages/vfx/lib/effects/autumn_gale_confetti.dart` | To be created |
| `assets/phase_12/vfx/` | To be created |

---

## Risks and Open Questions

1. **Wind Gust Overlap with Line Drags:** When player initiates a move that triggers an automatic gravity shift, the wind sweep animation must not block immediate tactile input for subsequent moves.
