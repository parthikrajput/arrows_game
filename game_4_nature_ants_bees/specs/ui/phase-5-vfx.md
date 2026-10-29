Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-5-signature-system.md.

# Spec: UI — Phase 5 VFX & Juice (Acorn Physics Visual Effects)

## Status
Draft

## Type
New Feature

## Goal
Implement the visual effects for the Acorn Physics push system, M201–M204 mechanics, sliding momentum, pit fill ground compaction, and the L2500 Harvest Festival Finale, reusing existing effect classes within established particle and device tier budgets.

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Current VFX suite covers standard line movement, bonks, ambient day/night sweeps, and multi-floor camera slides.
- Dynamic sliding friction dust, water/dew trails, pit collapse soil clouds, and heavy stone impact shockwaves are not implemented.

## Proposed Change
Extend `packages/puzzle_core/lib/src/vfx/` with Phase 5 effect mappings:

### 1. Push Dynamics & Friction VFX
- **Sliding Dust Trail (`dust_puff` class):**
  - Continuous sliding Dewdrop Marble (M202) leaves a shimmering misty water trail and tiny translucent droplets behind it.
  - Standard rolling acorn produces soft grass-dust puffs at each cell boundary crossed.
- **Heavy Block Impact (`hazard_sparks` / `state_toggle` class):**
  - When double-file lines impact a Stone Pumpkin (M204), a heavy stone thud sound accompanies a localized radial shockwave ring and 2 dp camera nudge.

### 2. Base Mechanics VFX Mapping
| Event / Mechanic | Effect Class | Visual Effect Definition | Tier Budget (Low / Mid / High) |
|---|---|---|---|
| Mole Hole Fill (M201) | `dust_puff` + `state_toggle` | Block plunges down with an earth-dust cloud; green daisy burst blooms as ground settles. | 0 / 14 / 28 particles |
| Dewdrop Marble Slide (M202) | `lane_warp` | Shimmering water refraction trail across tiles; crisp crystal clinking on impact. | 0 / 16 / 32 particles |
| Seed Key Pod Socket (M203) | `unlock_shatter` | Key pod locks into socket with bright golden radial flare and harmonic chime; thorn gates dissolve. | 8 / 20 / 40 particles |
| Stone Pumpkin Push (M204) | `dust_puff` | Heavy grinding stone sound with heavy dust billow as double-file lines push it forward. | 0 / 14 / 28 particles |
| L2500 Finale Win | `win_confetti` + `laser_beam` | **Harvest Moon Jubilation:** Massive golden acorn shower, cornucopia confetti, and harvest sun flare across the grid. | 30 / 80 / 150 particles |

### 3. Performance & Tier Constraints
- **Low Tier (Budget $\le 30$ particles):** Shimmer trails and dust billows omitted; pit filling uses standard 2D color crossfade; screen shake disabled.
- **Mid Tier (Budget $\le 80$ particles):** Full slide trail, standard particle counts, max 4 dp camera shake on finale.
- **High Tier (Budget $\le 150$ particles):** Refractive water droplets, multi-layer soil compaction bursts, max 6 dp shake on finale.
- **Reduce Motion:** When `reduce_motion = true`, all impact shockwaves and camera shakes are disabled; pit filling is a clean 100 ms crossfade.

## Affected Files
- `packages/puzzle_core/lib/src/vfx/push_physics_vfx.dart` (to be created)
- `packages/puzzle_core/lib/src/vfx/vfx_registry.dart` (changed to register Phase 5 mappings)

## Risks
- Frame drops when multiple push blocks slide simultaneously across long continuous paths. Mitigated by particle pooling and limiting active trail emitters to 2 instances.

## Open Questions
- None. VFX mappings reuse canonical classes from `VFX_IMPLEMENTATION.md` §4.

