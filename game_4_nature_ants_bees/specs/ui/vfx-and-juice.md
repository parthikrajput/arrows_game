Source docs: ../../PERFORMANCE_OPTIMIZATION.md, ../../SPLASH_AND_INSTANT_LAUNCH.md, ../../SHARED_CORE_STANDARD.md, ../../SOUND_EFFECTS_IMPLEMENTATION.md, ../../VFX_IMPLEMENTATION.md, phase_1/01_GAME_CONCEPT_AND_RULES.md, phase_1/03_OBSTACLE_CATALOG_PHASE_1.md

# Spec: VFX and Game Feel (Ants & Bees)

## Status
Draft

## Type
New Feature

## Goal
Collect and specify all visual effects and game feel (particles, screen shake, flashes, trails, haptic pairing) of Ants & Bees: Garden Trails Phase 1 in one place, within the shared device-tier budgets, so every effect has a defined trigger, a tier limit, and a QA check.

## Current State
Design documented across VFX_IMPLEMENTATION.md, PERFORMANCE_OPTIMIZATION.md, SPLASH_AND_INSTANT_LAUNCH.md, and phase_1 docs, not yet implemented.
- Shared tier limits: PERFORMANCE_OPTIMIZATION.md §3.3 and VFX_IMPLEMENTATION.md §5 (pre-allocated pool, one `drawAtlas` call).
- Bump rule: SHARED_CORE_STANDARD.md specifies head collision triggers "shake + haptic + sound" and returns (-1 Heart).
- Haptic mapping per event: SOUND_EFFECTS_IMPLEMENTATION.md §5 (SFX and haptic fire on the same frame; no haptics when disabled).
- Launch intro effects: SPLASH_AND_INSTANT_LAUNCH.md §10 (Garden Flight).

## Proposed Change
### 1. Tier Limits (Shared Across All Games)
Gameplay rules never change by tier. Only visual fidelity scales:
| Feature | Low | Mid | High |
|---|---|---|---|
| Particles (win confetti, exit sparkle) max live | 30 | 80 | 150 |
| Background ambient animation (swaying grass, sunlight) | Off (static image) | On, 30 fps update | On, 60/120 fps update |
| Idle animation (ant wiggle, bee wing flutter) | Off | Only on tapped insect | All insects, staggered |
| Exit trail effect | Simple fade | On | On |
| Screen shake (bump) | Off (haptic + red flash only) | On, 4 dp | On, 6 dp |
| Level Map parallax | Off | On | On |
| Shadows | Pre-baked into sprite atlas | Pre-baked | Pre-baked |

- Settings "Battery Saver" immediately enforces the Low profile.
- Dynamic demotion: If 3 consecutive levels experience > 5% frame drops, the profile drops by 1 tier.

### 2. Rendering Rules
- Particles use a pre-allocated object pool and a single `Canvas.drawAtlas()` call per frame. Active counts strictly respect the tier limits above.
- Glows and light rays use `BlendMode.plus`. Zero per-frame `MaskFilter.blur`, zero `BackdropFilter`, and zero `Canvas.saveLayer()` calls per particle.
- Alpha blending uses `Color.withValues(alpha:)`, never `withOpacity`.
- An on-demand `Ticker` starts when an effect is queued and stops when all active effects settle, ensuring a static board costs exactly 0 frames.

### 3. Gameplay Effect Catalog for Ants & Bees
Events use the identical IDs as SOUND_EFFECTS_IMPLEMENTATION.md §5, guaranteeing SFX, haptics, and VFX fire synchronously on the same frame. Dynamic layer renders active movements, previews, and particle emitters:

| Event ID | Effect Class | Ants & Bees Themed VFX Definition | Haptic |
|---|---|---|---|
| `path_tap` | `tap_response` | Antenna twitch and subtle ripple pulse under head insect (displays within 50 ms). | `selectionClick` |
| `path_exit` | `exit_trail` | Ground (Ants): Tiny dirt puffs and green grass sparkles along path. Air (Bees): Golden pollen dust trail and gentle sine-wave flight bob. | `lightImpact` |
| `path_exit_combo` | `exit_trail` (combo) | Consecutive exits without bonk trigger expanding amber glow rings and brighter pollen flares (steps 1–5). | `lightImpact` |
| `bump` | `bump_flash` | Head insect bonk squash against obstacle. Blocker flashes with 120 ms soft danger red highlight. Screen shake per tier (Low 0 dp, Mid 4 dp, High 6 dp). | `mediumImpact` |
| `locked_tap` | `denied_nudge` | Gentle lateral wobble (<= 200 ms) with lock tooltip (no red flash, no heart loss). | `selectionClick` |
| `heart_lost` | `heart_break` | UI Heart icon shatters into 4 floral petal fragments with soft downward drift. | `heavyImpact` |
| `shield_absorb` | `shield_pop` | Honeycomb bubble shield fractures into translucent honey droplets. | `lightImpact` |
| `preview_start` | `preview_line` | Long-press (>= 350 ms) renders dotted exit lane: straight dots for ants, wavy dots for bees. Green checkmark for clear, red cross on blocker. | None |
| `last_path_exit` | `exit_trail` + slowmo | Final line clears board with golden halo flourish and 300 ms garden sparkle pause before win. | `mediumImpact` |
| `win_stinger` | `win_confetti` | Burst of flower petals, green leaf confetti, and golden pollen sparkles within tier particle cap. | `heavyImpact` |
| `star_1..star_3` | `star_land` | Star drops onto Level Complete banner with golden radial flash and chime ring. | `lightImpact` |
| `coins_fly` | `coin_trail` | Honey-gold coins arc to HUD counter with trailing nectar sparkles (max 1 per 80 ms, max 8 per burst). | None |
| `booster_hint` | `hint_glow` | Radiant golden nectar pulse illuminates optimal line body and its clear exit path. | None |
| `booster_shield_on` | `shield_aura` | Translucent amber hexagonal honeycomb bubble expands around the garden board. | `lightImpact` |
| `booster_hammer` | `hammer_impact` | Swirling autumn leaf cyclone with gust distortion lines blows away targeted line or obstacle. | `mediumImpact` |
| `gift_open` / `chest_open` | `chest_burst` | Flower gift box pops open with petal fountain; Royal Honey Chest erupts with grand golden burst. | `heavyImpact` |

### 4. Phase 1 Mechanics VFX Mapping
| Mechanic Group | Classes | Ants & Bees Themed Look |
|---|---|---|
| Blockers (M001, M002) | `bump_flash` + debris | Pebble emits stone sparks; Twig fence emits dry wood chips. |
| Dew-Stuck Line (M003) | `crack_shards` | Clear water droplet bubble pops with 6 flying dew particles. |
| Two Layers (M032 Bee Lines) | Layer rendering | Bees rendered with 6 dp upward vertical offset and translucent wings with 12 Hz flutter. |
| Petal & Glory Gates (M005, M007) | `state_toggle` | Flower petals bloom outward or fold closed with color glow. |
| Burrow Tunnels (M008, M044) | `lane_warp` | Ants spiral into miniature earthen burrow mound with tiny soil puff. |
| Levers & Switches (M009, M018, M045) | `state_toggle` | Woody twig snaps 45° with green foliage gleam. |
| Morning Mist (M010) | `fog_dissolve` | Translucent morning fog dissipates radially when adjacent line moves. |
| Spinning Daisy / Rotor (M013, M034) | `rotate_swoosh` | 90° clockwise rotation with sweeping circular petal blur. |
| Crumbs & Nectar (M026, M036) | `grow_burst` | Crumb or flower nectar pops with sweet sparkle puff upon insect consumption. |
| Great Orb Spider (M049) | `guardian_hit` | Web strands vibrate with tension; defeat dissolves web into shimmering amber dust. |
| L500 Queen's Garden Gala | Grand Finale | Spectacular multi-layered fireworks of golden pollen and celebratory fireflies. |

### 5. Launch Intro Effects ("Garden Flight")
- Grass parting: Front lawn blades part left/right with depth scale.
- Sun sweep: Additive golden sunlight ray sweeps across canvas (`BlendMode.plus`, alpha 0.3).
- Bee flight: S-curve flight with nectar sparkle trail (12/24/40 particles by tier, life 400 ms).
- Play landing: Golden honey drop falls and splats into Play button with `easeOutBack` pop.
- Marching ants: 8 worker ants march in single-file under wordmark.

### 6. Assets & Performance Pipeline
- One effects atlas `assets/vfx/atlas.webp` containing all particles, glows, and sparkle frames.
- Effect parameters (lifespan, speed, scale, color tokens) externalized in `assets/theme.json`.
- Zero runtime image decoding during puzzle play.

### 7. QA Checklist
- **VFX-01:** Every event in section 3 has a defined visual effect or an explicit "no effect" entry.
- **VFX-02:** Active particles strictly capped: Low <= 30; Mid <= 80; High <= 150.
- **VFX-03:** Bump on Low tier displays haptic and red border flash, with screen shake disabled.
- **VFX-04:** Battery Saver switches to Low tier profile immediately without altering game logic.
- **VFX-05:** Reduce Motion removes screen shake and reduces particle bursts to soft short fades.
- **VFX-06:** 60 fps maintained on low-tier reference device during L500 win confetti explosion.
- **VFX-07:** When Haptics are disabled in Settings, visual effects play normally without haptic calls.
- **VFX-08:** SFX, haptics, and VFX trigger on the exact same frame.
- **VFX-09:** Idle board produces 0 frames once all active particle lifetimes expire.
- **VFX-10:** All effects are color-blind verified (color flashes always accompanied by shape or icon).

## Affected Files
- `apps/ants_bees/lib/features/gameplay/render/vfx/particle_pool.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/vfx/vfx_catalog.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/vfx/vfx_service.dart` (to be created)
- `apps/ants_bees/assets/vfx/atlas.webp` (to be created)
- `apps/ants_bees/assets/theme.json` (to be extended)

## Risks
- Too many active particles on budget devices can cause frame stutter; strictly enforced at the pool level.
- Red flash must be soft to prevent photo-sensitivity discomfort.

## Open Questions
- Signature systems for Phases 3 to 20 (Cycles, Multi-floor, Gravity, etc.) will have their specific VFX defined in their respective phase specs.
