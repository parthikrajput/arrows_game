Source docs: phases/phase_8/06_UI_AND_QA_PHASE_8.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-7-vfx.md.

# Spec: UI — Phase 8 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement the hardware-accelerated sprouting tendril growth animations, pruning shear slices, seed pod bursts, and floral bloom transitions for Phase 8 (Levels 3501–4000), respecting device performance budgets and accessibility guidelines.

## Current State
Design documented in `phases/phase_8/06_UI_AND_QA_PHASE_8.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered rotational swooshes and dust puffs.
- Phase 8 requires organic growth animations, slicing feedback, and floral blooming celebrations.

## Proposed Change
Extend `lib/features/vfx/` with Phase 8 growth effect classes:

### 1. Phase 8 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M351 Wild Vine Sprout** | `growth_sprout` | Thorny tendril uncurls into new tile over 250 ms with green leaf motes and soil displacement | Low: 0 particles (instant scale up)<br>Mid: 10 particles<br>High: 20 particles |
| **M352 Pruning Shears Slice** | `slash_cut` | Golden scissor trail slices through adjacent vines, severing tendrils into falling leaf shreds | Low: 0 particles<br>Mid: 12 particles<br>High: 25 particles |
| **M353 Seed Pod Burst** | `seed_burst` | Pod bursts into a miniature cluster of green sparks or crushes into green sap splash | Low: 0 particles<br>Mid: 8 particles<br>High: 16 particles |
| **M354 Bloom Gate Blossom** | `state_toggle` + `flower_bloom` | Lotus petals unfurl in radiant floral bloom with drifting pollen spores and golden glow | Low: 0 particles<br>Mid: 15 particles<br>High: 30 particles |
| **L4000 Finale Overgrowth Burst** | `win_confetti` + `chest_burst` | Grand jungle flower burst, radiant sunbeams, golden serpentine ribbons, and confetti | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Device Tier Limits & Performance Invariant
- **Instanced Tendril Rendering:**
  - Vine segments share an instanced tile texture atlas. Growing tendrils use procedural sprite scaling without triggering full canvas redraws.
- **Particle Capping:**
  - Low-Tier: Max concurrent **30 particles**.
  - Mid-Tier: Max concurrent **80 particles**.
  - High-Tier: Max concurrent **150 particles**.

---

### 3. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Vine sprouting executes as an immediate 50 ms alpha fade instead of a curling growth animation.
  - Slicing slash cuts and flower petal particle emitters are disabled.
  - Camera shake on bloom opening is suppressed.

## Affected Files
- `lib/features/vfx/effects/phase_8/vine_sprout_painter.dart` — to be created
- `lib/features/vfx/effects/phase_8/prune_slash_emitter.dart` — to be created
- `lib/features/vfx/effects/phase_8/bloom_gate_animator.dart` — to be created
- `lib/features/vfx/vfx_service.dart` — changed

## Risks and Open Questions
- None. Cleanly bounded within existing particle budgets.

