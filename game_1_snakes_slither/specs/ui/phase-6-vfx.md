Source docs: phases/phase_6/06_UI_AND_QA_PHASE_6.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-5-vfx.md.

# Spec: UI — Phase 6 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement the hardware-accelerated particle effects, beam illumination shaders, chromatic flares, and dissolution effects for Phase 6 (Levels 2501–3000), respecting device tier budgets and accessibility settings.

## Current State
Design documented in `phases/phase_6/06_UI_AND_QA_PHASE_6.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered baseline slither trails, bonks, floor sweeps, and push momentum dust.
- Phase 6 requires visual feedback for light refraction, multi-beam convergence, countdown completions, and shadow dissolution.

## Proposed Change
Extend `lib/features/vfx/` with Phase 6 optical effect classes:

### 1. Phase 6 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M251 Petal Filter Passage** | `beam_glow` + `morph_flash` | As beam passes through filter, emitting colored chromatic sparks and localized radial bloom | Low: Beam tint only<br>Mid: 10 particles<br>High: 20 particles |
| **M252 Prism Lock Unlock** | `state_toggle` + `beam_glow` | Converging beams trigger crystalline refraction flare followed by golden stone latch drop | Low: Static open cut<br>Mid: 15 particles<br>High: 30 particles |
| **M253 Sundial Latch Complete** | `badge_pulse` + `win_confetti` | Completing countdown emits a radiant golden circular shockwave across adjacent tiles | Low: Badge flash only<br>Mid: 12 particles<br>High: 24 particles |
| **M254 Shade Leaves Dissolve** | `fog_dissolve` | Foliage dissolves into miniature green pollen particles as the sleeping snake awakens | Low: 0 particles<br>Mid: 8 particles<br>High: 16 particles |
| **L3000 Finale Sanctum Burst** | `win_confetti` + `chest_burst` | Grand celebratory solar nova explosion, rainbow light ribbons, and golden coin cascade | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Device Tier Limits (Standard §4.2)
- **Low-Tier Devices (≤ 2 GB RAM, e.g. Mali-G52):**
  - All complex particle emitters disabled.
  - Optical beams rendered as simple flat polyline paths without additive bloom shaders.
  - Maximum concurrent particles capped at **30 particles**.
- **Mid-Tier Devices (3–4 GB RAM, Snapdragon 680):**
  - Additive blending enabled on primary beam lines.
  - Maximum concurrent particles capped at **80 particles**.
- **High-Tier Devices (≥ 6 GB RAM / iPhone 12+):**
  - Full HDR bloom shaders, shimmering particle dust motes along active light rays.
  - Maximum concurrent particles capped at **150 particles**.

---

### 3. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled in device settings:
  - Beam pulse oscillations are frozen into a clean static glow.
  - Shade leaf dissolution executes as an instantaneous 50 ms alpha cut rather than a particle wipe.
  - Camera shake on gate latching is completely disabled.

## Affected Files
- `lib/features/vfx/effects/phase_6/chromatic_beam_painter.dart` — to be created
- `lib/features/vfx/effects/phase_6/prism_unlock_emitter.dart` — to be created
- `lib/features/vfx/effects/phase_6/shade_dissolve_effect.dart` — to be created
- `lib/features/vfx/vfx_service.dart` — changed

## Risks and Open Questions
- **GPU Overdraw with Multiple Beams:** Intersecting additive beam lines on 14×14 boards could cause frame drops on low-tier devices.
  - *Mitigation:* Beams are batched into a single static render pass using a combined `Path` canvas draw call.

