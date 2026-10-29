Source docs: phases/phase_11/06_UI_AND_QA_PHASE_11.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6, ../../SOUND_EFFECTS_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-10-vfx.md.

# Spec: UI — Phase 11 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement hardware-accelerated water lily splashes, vine bridge transit particles, cross-board golden spark arcs, mirror twin luminescence, and the Level 5,500 Grand Finale pond convergence burst within device particle budgets.

## Current State
Design documented in `phases/phase_11/06_UI_AND_QA_PHASE_11.md`, `VFX_IMPLEMENTATION.md`, and `SOUND_EFFECTS_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered rhythmic pulses and celebratory fireworks.
- Phase 11 introduces aquatic multi-grid traversal effects, inter-board projectile arcs, synchronized shimmer auras, and water vortex burrow transitions.

## Proposed Change
Extend `lib/features/vfx/` with Phase 11 aquatic and dual-board effect classes:

### 1. Phase 11 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M501 Bridge Crossing** | `bridge_transfer_flow` | Gentle water ripples and floating green leaf motes drift underneath the suspension bridge as snake slithers across | Low: 0 particles (2D sprite motion)<br>Mid: 10 particles<br>High: 20 particles |
| **M502 Messenger Key Exit** | `cross_board_spark` | Golden lotus projectile spark traces a glowing parabolic trajectory from Pond 1 to Pond 2, detonating in a soft blossom | Low: 0 particles (line flash)<br>Mid: 12 particles<br>High: 24 particles |
| **M503 Mirror Movement** | `mirror_twin_shimmer` | Synchronous aquatic blue luminescence aura envelopes both mirror twins while in transit | Low: 0 particles (glow shader)<br>Mid: 8 particles<br>High: 16 particles |
| **M504 Relay Portal** | `water_portal_splash` | Submerged mossy vortex sucks snake downward with foaming whirlpool ring and re-ejects with water droplet fountain | Low: 0 particles (whirlpool scale)<br>Mid: 14 particles<br>High: 28 particles |
| **Cross-Board Blocked Bonk** | `water_ripple_bonk` | Concentric water ripples with gentle foam ring and harmless head-shake on blocked bridgehead | Low: 0 particles<br>Mid: 6 particles<br>High: 12 particles |
| **Level 5500 Grand Finale** | `ponds_unite_grand_burst` | Inter-board divider melts away into a unified golden lake, releasing flying lotus petals and rainbow water spouts | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Audio Mapping (SFX) Integration
- `sfx_bridge_slither.ogg`: Creaking bamboo and gentle water splashing as snake crosses bridge.
- `sfx_key_flight.wav`: Whistling magical fairy chime trailing across the screen.
- `sfx_mirror_slither.ogg`: Dual-channel harmonized water glide sound.
- `sfx_portal_splash.wav`: Resonant submerged splash and buoyant resurfacing bubble pop.
- `sfx_water_bonk.wav`: Soft aquatic bloop with zero-damage tone.
- `sfx_water_finale.ogg`: Grand tranquil orchestral water symphony.

---

### 3. Device Tier Budgets & Invariants
- **Particle Caps:**
  - Low-Tier ($\le 2\text{GB RAM}$): Maximum concurrent **30 particles**.
  - Mid-Tier ($4\text{GB RAM}$): Maximum concurrent **80 particles**.
  - High-Tier (Flagship): Maximum concurrent **150 particles**.
- **Unified Canvas Draw:** Both mini-grids and the inter-board bridge render in a single `CustomPainter.paint` pass to keep draw calls below 12.
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during Level 5500 finale burst.

---

### 4. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Parabolic flight sparks are replaced by immediate target gate lighting.
  - Bridge transit uses an immediate 50 ms fade-out / fade-in without water ripple animations.
  - Screen shake and ripple displacement shaders are disabled.

## Affected Files
- `lib/features/vfx/phase_11_vfx_pack.dart` (to be created)
- `assets/vfx/phase_11/` (to be created)
- `assets/audio/sfx/phase_11/` (to be created)
- `test/vfx/phase_11_vfx_budget_test.dart` (to be created)

## Risks and Open Questions
- **Simultaneous Particle Emitters Across Two Boards:** Emitters active on both Board 1 and Board 2 simultaneously must share a single global particle counter to guarantee aggregate particles never exceed the 30-particle cap on Low-Tier devices.
