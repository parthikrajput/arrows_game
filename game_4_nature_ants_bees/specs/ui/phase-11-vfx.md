# Spec: Phase 11 VFX — Twin Gardens Visual Effects

Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-11-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 VFX — Twin Gardens Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define all visual effects for Phase 11 Twin Gardens mechanics (gate link boundary crossing, cross-board key projectile, mirror twin sync, burrow teleport, and L5500 Twin Jubilee celebration) within established particle tier limits, Reduce Motion, and accessibility standards.

---

## Current State

Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md`, not yet implemented. Effect classes defined in `VFX_IMPLEMENTATION.md §4`.

---

## Proposed Change

### VFX Mapping Table

All effects reuse established classes from `VFX_IMPLEMENTATION.md §4`:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Gate Link Crossing (M501) | `lane_warp` | Shimmering boundary veil parts as line smoothly transitions across gardens. | 8 / 22 / 45 |
| Cross-Board Unlock (M502) | `state_toggle` | Golden pollen streak shoots across screen, bursting thorn lock on destination board. | 10 / 25 / 50 |
| Mirror Synchronization (M503) | `state_toggle` | Blue water droplet ripples and reflection sparkles track synchronized insects. | 6 / 20 / 40 |
| Burrow Teleport (M504) | `dust_puff` + `lane_warp` | Soil puff as ant dives underground; matching soil fountain upon emerging in Garden B. | 10 / 26 / 50 |
| L5500 Finale Win | `win_confetti` | Grand Twin Garden Jubilee: dual rainbow light bridges, mirrored golden confetti showers. | 30 / 80 / 150 |

> [!NOTE]
> All effects map to established VFX classes (`lane_warp`, `state_toggle`, `dust_puff`, `win_confetti`). No novel effect classes required.

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

Cross-board projectile and portal animations must coordinate particle budgets across both viewports, clamping simultaneous particle counts below the tier ceiling.

### Reduce Motion Adjustments
- `lane_warp` Gate Link: Replaced by immediate boundary alpha cross-fade; no shimmering veil particles.
- `state_toggle` Cross-Board Unlock: Instant lock disappearance on destination board; projectile beam disabled.
- `state_toggle` Mirror Sync: Subtle static blue outline around paired insects; ripple waves removed.
- `dust_puff` + `lane_warp` Burrow Teleport: Immediate entrance/exit pop without soil fountain particles.
- `win_confetti` L5500 Finale: Static celebratory dual-rainbow banner with subtle 1.0 s opacity fade.

### Colour-Blind Accessibility
- Golden pollen streak (`#FFD54F`) accompanied by a flying leaf glyph.
- Mirror twin sync uses distinct dual-ring icons on paired insect bodies.
- Burrows utilize high-contrast earthen boundary rings clearly distinct from pitfall traps.

---

## Acceptance Criteria
- [ ] All 5 effect events use existing VFX classes without introducing unapproved classes.
- [ ] Particle counts per event adhere to tier constraints (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode completely disables flying projectiles, soil fountains, and screen shake.
- [ ] Distinct non-colour glyphs identify synchronized mirror pairs and burrow portals under all forms of colour-blindness.
- [ ] L5500 finale fireworks do not exceed 150 particles on High tier.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/gate_link_warp_effect.dart` | To be created |
| `packages/vfx/lib/effects/cross_board_unlock_effect.dart` | To be created |
| `packages/vfx/lib/effects/mirror_sync_effect.dart` | To be created |
| `packages/vfx/lib/effects/burrow_teleport_effect.dart` | To be created |
| `packages/vfx/lib/effects/twin_jubilee_confetti.dart` | To be created |
| `assets/phase_11/vfx/` | To be created |

---

## Risks and Open Questions

1. **Cross-Viewport Particle Continuity:** When an ant traverses through a burrow from Board A to Board B while both boards are visible in split-screen mode, VFX coordinate systems must translate seamlessly between world spaces.
