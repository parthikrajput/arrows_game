Source docs: phases/phase_9/06_UI_AND_QA_PHASE_9.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6, ../../SOUND_EFFECTS_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-8-vfx.md.

# Spec: UI — Phase 9 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement hardware-accelerated fluid river animations, entity fusion flashes, bifurcation particle bursts, bead absorption energy streams, and reunion waterfall blossoms for Phase 9 (Levels 4001–4500), strictly respecting device particle budgets and accessibility guidelines.

## Current State
Design documented in `phases/phase_9/06_UI_AND_QA_PHASE_9.md`, `VFX_IMPLEMENTATION.md`, and `SOUND_EFFECTS_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered organic vine tendrils and botanical slicing.
- Phase 9 introduces fluid dynamic aquatic particle streams, topological entity transformations, and synchronized pair completion effects.

## Proposed Change
Extend `lib/features/vfx/` with Phase 9 aquatic and split/merge effect classes:

### 1. Phase 9 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M401 Snake Merge** | `merge_flash` | Golden-cyan convergence flare at pad intersection; body segment seam dissolves with sparkling water droplets | Low: 0 particles (alpha pulse only)<br>Mid: 12 particles<br>High: 24 particles |
| **M402 Snake Split** | `split_burst` | Bifurcation ray severs snake at stump threshold; water foam splashes outwards as two child heads materialize | Low: 0 particles (clean cut)<br>Mid: 15 particles<br>High: 30 particles |
| **M403 Bead Absorb** | `bead_absorb_stream` | Luminous sapphire energy trail arcs from exiting snake segment to gate bead sockets | Low: 0 particles (instant bead fill)<br>Mid: 8 particles<br>High: 16 particles |
| **M404 Reunion Open** | `water_gate_open` | Twin stream arcs meet at the center portal, dissipating water barrier into crystalline mist | Low: 0 particles (fade out)<br>Mid: 16 particles<br>High: 32 particles |
| **Split Blocked Bonk** | `bonk_ripple` | Water ripple and blunt impact starburst with head wobble animation on blocked stump | Low: 0 particles<br>Mid: 6 particles<br>High: 12 particles |
| **L4500 Finale Convergence** | `river_convergence_burst` | Majestic multi-colored water spouts, golden serpentine ribbon trails, and triumphant fireworks | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Audio Mapping (SFX) Integration
- `sfx_snake_merge.ogg`: Deep resonant harmonic chime and water rush.
- `sfx_snake_split.wav`: Crisp aquatic bifurcation swoosh.
- `sfx_bead_click.wav`: High-pitched melodic gem drop chime.
- `sfx_reunion_water.ogg`: Grand rushing cascade waterfall splash.
- `sfx_stump_bonk.wav`: Hollow wooden hollow log thud with zero damage cue.
- `sfx_finale_rapids.ogg`: Full orchestral river victory fanfare.

---

### 3. Device Tier Budgets & Invariants
- **Particle Caps:**
  - Low-Tier ($\le 2\text{GB RAM}$): Maximum concurrent **30 particles**.
  - Mid-Tier ($4\text{GB RAM}$): Maximum concurrent **80 particles**.
  - High-Tier (Flagship): Maximum concurrent **150 particles**.
- **Frame Budget:** 60 FPS guaranteed on all tiers; minimum 50 FPS under peak split stress on Low-Tier.
- **Shader Pipeline:** Reuses unified GPU particle buffer; water ripples utilize shared sin-wave displacement shader.

---

### 4. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Splitting and merging occur as immediate 50 ms alpha crossfades without expanding burst particles.
  - Energy arc streams from exiting segments are replaced by immediate bead lighting.
  - Screen shake on Level 4500 Grand Finale is disabled.

## Affected Files
- `lib/features/vfx/phase_9_vfx_pack.dart` (to be created)
- `assets/vfx/phase_9/` (to be created)
- `assets/audio/sfx/phase_9/` (to be created)
- `test/vfx/phase_9_vfx_budget_test.dart` (to be created)

## Risks and Open Questions
- **Simultaneous Particle Emitters:** In levels with multiple splitters firing in rapid succession, aggregate particles could exceed the 30-particle cap on Low-Tier devices. An active particle throttling manager must cull oldest particles when budget saturation reaches 90%.
