# Spec: Phase 8 VFX — Bloom Season Visual Effects

Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-8-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 VFX — Bloom Season Visual Effects |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define all visual effects for Phase 8 Bloom Season mechanics (vine expansion, shears snip, seed drop/sprout, gate pollination, finale win) using existing effect classes where possible, respecting tier particle budgets, Reduce Motion, and colour-blind rules.

---

## Current State

Design documented in phase/phase_8/06_UI_AND_QA_PHASE_8.md, not yet implemented. Effect classes defined in VFX_IMPLEMENTATION.md §4.

---

## Proposed Change

### VFX Mapping Table

All effects reuse existing classes from VFX_IMPLEMENTATION.md §4:

| Event / Mechanic | Effect Class | Description | Particles (Low/Mid/High) |
|---|---|---|---|
| Vine Expansion (M351) | `state_toggle` | Rapid creeping green shoot with a cheerful pop of purple morning glory blossoms. | 8 / 25 / 50 |
| Shears Snip (M352) | `lane_warp` | Crisp metallic snip with green leaf shreds and sparkling dew scattering outwards. | 6 / 20 / 40 |
| Seed Drop (M353) | `dust_puff` | Soft earthy puff as a glowing golden seed drops onto the start head tile. | 4 / 15 / 30 |
| Seed Sprout (M353) | `state_toggle` | Seed cracks open with a green vegetative burst, hardening into a weathered pebble. | 8 / 25 / 50 |
| Gate Pollination (M354) | `state_toggle` | Golden pollen sparkles drift onto closed buds; petals unfurl with a sweet chime. | 10 / 30 / 60 |
| L4000 Finale Win | `win_confetti` | Giant floral petal fireworks, golden pollen clouds, honey sparkles — Eternal Bloom Gala. | 30 / 80 / 150 |

> [!NOTE]
> No new effect classes are introduced in Phase 8. All effects map to existing classes (`state_toggle`, `lane_warp`, `dust_puff`, `win_confetti`).

### Tier Particle Budgets

| Tier | Max Particles | Screen Shake |
|---|---|---|
| Low | ≤ 30 | Off |
| Mid | ≤ 80 | 4 dp |
| High | ≤ 150 | 6 dp |

All Phase 8 individual event particle counts are within tier budgets. Simultaneous events (e.g., multiple vines expanding at once) must sum within the tier budget; the effect system must queue or batch concurrent effects.

### Reduce Motion
- `state_toggle` vine expansion: replaced by instant cell colour change (green flash, 1 frame).
- `lane_warp` shears snip: replaced by instant vine removal, no shred particles.
- `dust_puff` seed drop: replaced by seed token appearing instantly with a single ring pulse.
- `state_toggle` seed sprout: instant pebble appearance, no crack animation.
- `win_confetti` L4000 finale: reduced to 8 static petal overlays fading in over 1 s.

### Colour-Blind Rules
- Vine expansion green (`#4CAF50`) is supplemented with a leaf-growth shape cue.
- Shears snip silver is supplemented with a scissor-cut shape cue.
- Pollen golden (`#FFD700`) is supplemented with a sparkle shape cue (star burst).
- All effects must pass Deuteranopia, Protanopia, and Tritanopia simulation checks.

---

## Acceptance Criteria
- [ ] All 6 effect events use existing VFX classes (no new class required).
- [ ] Particle counts per event within tier limits (Low ≤ 30, Mid ≤ 80, High ≤ 150).
- [ ] Reduce Motion mode passes: no particle animations; only static/instant visual cues.
- [ ] Colour-blind supplemental cues present for all colour-coded effects.
- [ ] L4000 finale `win_confetti` does not exceed 150 particles on High tier.
- [ ] Simultaneous vine expansions (multiple cells same tick) batch correctly within budget.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/vfx/lib/effects/state_toggle_vine.dart` | To be created (subclass of state_toggle) |
| `packages/vfx/lib/effects/shears_snip.dart` | To be created (subclass of lane_warp) |
| `packages/vfx/lib/effects/seed_drop_puff.dart` | To be created (subclass of dust_puff) |
| `packages/vfx/lib/effects/pollination_sparkle.dart` | To be created (subclass of state_toggle) |
| `packages/vfx/lib/effects/bloom_gala_confetti.dart` | To be created (subclass of win_confetti) |
| `assets/phase_8/vfx/` | To be created |

---

## Risks and Open Questions

1. **Concurrent vine expansion budget:** When 10–15 vine cells all expand simultaneously on a 14×14 grid (each firing a `state_toggle`), the combined particle count may exceed Mid or Low tier budget. The VFX system must implement a per-frame cap or effect merging strategy.
2. **Audio sync for shears snip:** The `lane_warp` class has an associated sound effect; confirm that the snip sound asset is distinct from Phase 7 warp sounds (different audio ID) to avoid confusion.
3. **Petal confetti at L4000:** The `win_confetti` class needs a custom petal asset (not the generic confetti shape). Confirm asset creation is in scope for Phase 8 art sprint.
