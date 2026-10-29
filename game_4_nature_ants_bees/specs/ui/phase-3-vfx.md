Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-3-signature-system.md.

# Spec: UI — Phase 3 VFX & Juice (Day & Night Visual Effects)

## Status
Draft

## Type
New Feature

## Goal
Implement the visual effects for the Day & Night Garden cycle transitions, M101–M104 mechanics, and the L1500 Finale, reusing existing effect classes within established particle and device tier budgets.

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Current VFX suite covers Phase 1 & 2 movement trails, bonks, water ripples, sunbeams, and push dust puffs.
- Full-screen ambient cycle sweeps and nocturnal bioluminescent particles are not yet implemented.

## Proposed Change
Extend `packages/puzzle_core/lib/src/vfx/` with Phase 3 effect mappings:

### 1. Cycle Transition VFX (Standard §4)
- **Day $\rightarrow$ Night Flip (`state_toggle` class):**
  - 300 ms linear screen sweep from top to bottom.
  - Background grass tint transitions smoothly from warm lawn (`#81C784`) to twilight slate (`#37474F`).
  - Spawns 12 soft bioluminescent firefly particles drifting slowly with subtle sine-wave alpha pulsing.
- **Night $\rightarrow$ Day Flip (`state_toggle` class):**
  - 300 ms golden dawn ray sweep across the board (`BlendMode.plus`, peak opacity 0.25).
  - Background grass restores to warm sunlight lawn; fireflies dissolve into golden pollen specks.

### 2. Base Mechanics VFX Mapping
| Event / Mechanic | Effect Class | Visual Effect Definition | Tier Budget (Low / Mid / High) |
|---|---|---|---|
| Sunrise Gate (M101) | `state_toggle` | Golden petals fan open at dawn; fold tight with dewdrop burst on night arrival. | 0 / 12 / 24 particles |
| Moonlit Bridge (M102) | `beam_glow` | Lunar ethereal glow activates under moonlight with soft shimmering vertical beam lines. | 0 / 16 / 32 particles |
| Dawn Burrow (M103) | `lane_warp` | Warm amber spiral swirl above entrance tile during daytime; collapses silently at night. | 0 / 14 / 28 particles |
| Day-Bloom Line (M104)| `morph_flash` | Line abdomen crossfades colors over 200 ms with tiny radial pollen sparkle burst. | 8 / 16 / 32 particles |
| L1500 Finale Win | `win_confetti` + `beam_glow` | Dual Sun-and-Moon fireworks: golden honey flakes and silvery starlight petals sweeping the board. | 30 / 80 / 150 particles |

### 3. Performance & Tier Constraints
- **Low Tier (Budget $\le 30$ particles):** Ambient color tint tween only; firefly and pollen particles omitted; screen shake disabled.
- **Mid Tier (Budget $\le 80$ particles):** 300 ms ambient tween, reduced particle counts, max 4 dp camera shake on finale.
- **High Tier (Budget $\le 150$ particles):** Full particle simulation, bloom shaders, max 6 dp shake on finale.
- **Reduce Motion:** When system accessibility flag `reduce_motion = true`, all sweeps become instantaneous 100 ms crossfades with zero camera shake.

## Affected Files
- `packages/puzzle_core/lib/src/vfx/cycle_vfx_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/vfx/effects/bioluminescent_firefly_effect.dart` (to be created)
- `packages/puzzle_core/lib/src/vfx/vfx_registry.dart` (changed to register Phase 3 mappings)

## Risks
- Thermal throttling from persistent firefly particle loops during Night state. Mitigated by freezing particle ticks when the board is idle (Ticker paused).

## Open Questions
- None. VFX mappings reuse canonical classes from `VFX_IMPLEMENTATION.md` §4.
