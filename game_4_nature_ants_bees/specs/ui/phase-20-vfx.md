# Spec: Phase 20 VFX — Grand Master Garden & Finale Visual Effects

Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-20-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 VFX — Grand Master Garden & Finale Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define all visual effects for Phase 20 Grand Master Garden mechanics (canopy bloom pollen bursts, cascade nexus stream warps, shrouded guardian aegis shatter, prismatic rotor rainbow rays, L10,000 boss armor sparks, and the Queen's Coronation Grand Victory sequence) within established particle tier limits, Reduce Motion, and accessibility rules.

---

## Current State

Design documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Bloom Canopy Cycle (M951) | `state_toggle` + `dust_puff` | Giant golden petals bloom or wither with gentle floral pollen particles. | 8 / 18 / 35 |
| Cascade Nexus Split (M952) | `lane_warp` | Line divides into shimmering dual streams; one cascades with gravity, one warps via linked portal. | 10 / 25 / 50 |
| Shrouded Guardian Unlock (M953) | `state_toggle` + `glow_burst` | Golden keys merge into guardian's shield, shattering fog and emitting warm royal light burst. | 12 / 30 / 60 |
| Prismatic Rotor Turn (M954) | `state_toggle` + `glow_burst` | 4x4 crystal platform rotates smoothly; light beams refract in rainbow colors across the board. | 10 / 25 / 50 |
| Hornet Armor Crack (L10,000) | `state_toggle` | Heavy metallic fracture chime with golden nectar sparks as armor layer shatters. | 8 / 20 / 40 |
| L10,000 Grand Finale Victory | `win_confetti` + `glow_burst` | **The Queen's Coronation:** Massive 14x14 golden bee swarm dance, blooming Crown Flower, fireworks, and confetti. | 30 / 80 / 150 |

> [!NOTE]
> All effects map directly to standard classes (`state_toggle`, `dust_puff`, `lane_warp`, `glow_burst`, `win_confetti`). No novel effect classes are needed.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Concurrently firing multi-system particle bursts across the full 14×14 grid are strictly pooled and clamped below the active tier budget.

### Reduce Motion Adjustments
- `state_toggle` Bloom Canopy Cycle: Instantaneous sprite state swap; floral pollen particles disabled.
- `lane_warp` Cascade Nexus Split: Instantaneous branch division without portal warp distortion.
- `state_toggle` + `glow_burst` Shrouded Guardian: 50 ms shield flash; key merging orbit animation disabled.
- `state_toggle` + `glow_burst` Prismatic Rotor: Instant 90° platform snap without trailing rainbow rays.
- `win_confetti` L10,000 Grand Finale: Confetti count reduced to 15 particles, zero screen shake; instant coronation dialogue.

---

## Verification Plan

### Automated Tests
1. Particle clamp test: verify simultaneous rotor turn, hornet armor crack, and bloom expansion never exceeds 150 particles on High tier and 30 on Low tier.
2. Reduce Motion setting: verify screen shake is 0 dp across all Grand Master events when accessibility toggle is on.

### Manual Verification
1. Verify L10,000 Queen's Coronation victory sequence plays cleanly with triumphant orchestral fanfare.
2. Verify prismatic rainbow beam refractions render without artifacts or depth-sorting issues on mobile devices.
