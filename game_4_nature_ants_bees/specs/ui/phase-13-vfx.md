# Spec: Phase 13 VFX — Mystery Meadow Visual Effects

Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-13-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 VFX — Mystery Meadow Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define all visual effects for Phase 13 Mystery Meadow mechanics (fog dissolve sunbeams, mirage mist burst, false wall crumble, sunlit plate beam sweep, and L6500 Solstice Dawn celebration) within established particle tier limits, Reduce Motion, and accessibility standards.

---

## Current State

Design documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Fog Dissolve (M601) | `glow_burst` | Warm sunbeams pierce the fog, smoothly evaporating mist with sparkling water dew (200 ms). | 10 / 25 / 50 |
| Mirage Trigger (M602) | `dust_puff` | Sudden swirling burst of cool vapor blanket expands across 3x3 tiles. | 8 / 20 / 40 |
| False Wall Crumble (M603) | `state_toggle` | Hollow pebble cracks into colorful paint flakes and leaves a clear lawn tile. | 6 / 18 / 35 |
| Sunlit Plate Beam (M604) | `state_toggle` | High-intensity golden light wash sweeps horizontally and vertically across the grid. | 10 / 26 / 50 |
| L6500 Finale Win | `win_confetti` | Grand Solstice Dawn Gala: prismatic sun halos, sparkling morning dewdrops, golden confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`glow_burst`, `dust_puff`, `state_toggle`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Simultaneous fog dissolve and plate illumination events are batched together to stay within per-frame particle allowances.

### Reduce Motion Adjustments
- `glow_burst` Fog Dissolve: Replaced by immediate 0.1 s opacity cross-fade; no dewdrops or light rays.
- `dust_puff` Mirage Trigger: Instant mist overlay appearance without swirling vapor particles.
- `state_toggle` False Wall: Pebble instantly disappears, replaced by clear lawn sprite; paint flake bursts disabled.
- `state_toggle` Sunlit Plate: Static golden crosshair grid lines without ray sweeps.
- `win_confetti` L6500 Finale: Static celebratory golden sunburst banner with 1.0 s fade-in.

### Colour-Blind Accessibility
- Sunlit beam golden tones (`#FFD54F`) accompanied by high-contrast border brackets.
- Fogged cells display a distinct hatched texture under High Contrast / Color-Blind accessibility settings.
- Painted Pebble cracks show geometric shards alongside colour flakes.

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables flying particles, swirling vapors, and screen shake.
- [ ] High-contrast boundary overlays identify revealed sectors under all forms of colour-blindness.
- [ ] L6500 finale celebration does not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/fog_dissolve_sunbeam.dart` | To be created |
| `packages/vfx/lib/effects/mirage_mist_puff.dart` | To be created |
| `packages/vfx/lib/effects/false_wall_crumble.dart` | To be created |
| `packages/vfx/lib/effects/sunlit_plate_beam.dart` | To be created |
| `packages/vfx/lib/effects/solstice_dawn_confetti.dart` | To be created |
| `assets/phase_13/vfx/` | To be created |

---

## Risks and Open Questions

1. **Light Sweep Shader Performance on Low-End GPUs:** Sunlit plate orthogonal beam sweeps must run as simple quad transforms rather than heavy post-processing bloom shaders to protect frame rates.
