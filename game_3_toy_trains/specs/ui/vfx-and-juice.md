Source docs: ../../PERFORMANCE_OPTIMIZATION.md, ../../SPLASH_AND_INSTANT_LAUNCH.md, ../../SHARED_CORE_STANDARD.md, ../../SOUND_EFFECTS_IMPLEMENTATION.md, ../../VFX_IMPLEMENTATION.md, phase_1/01_GAME_CONCEPT_AND_RULES.md, phase_1/06_UI_UX_SCREENS.md

# Spec: VFX and Game Feel (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Collect and implement all visual effects and game feel (particles, shake, flashes, trails, haptic pairing) of Toy Trains in one place, within the shared device-tier budgets, so every effect has a defined trigger, a tier limit, and a QA check.

## Current State
Design documented in ../../VFX_IMPLEMENTATION.md, ../../PERFORMANCE_OPTIMIZATION.md, and phase_1/ docs.
- Shared tier limits: ../../PERFORMANCE_OPTIMIZATION.md section 3.3 and particle rules (object pool, one `drawAtlas` call).
- Bump rule: SHARED_CORE_STANDARD.md says a blocked path hits the blocker with "shake + haptic + sound" and returns (-1 Heart).
- Haptic mapping per event: ../../SOUND_EFFECTS_IMPLEMENTATION.md section 5 (SFX and haptic fire on the same frame; no haptic call when Settings Haptics is off).
- Intro effects for this game: ../../SPLASH_AND_INSTANT_LAUNCH.md section 9 (Toy Box Lid).

## Proposed Change
### 1. Tier Limits (Shared Budget Across All Four Games)
Gameplay rules never change by tier; only visual fidelity scales:
| Feature | Low Tier (Redmi 9A) | Mid Tier (Galaxy A14) | High Tier (Pixel 8) |
|---|---|---|---|
| **Max Live Particles (Confetti, Sparkles, Steam)** | **30** | **80** | **150** |
| **Background Ambient Animation (Steam, Tabletop Light)**| Off (static image) | On (30 fps update) | On (60/120 fps) |
| **Idle Train Wobble (Engine & Carriage Sway)** | Off | Only tapped train | All trains staggered |
| **Exit Steam Trail** | Simple fade | On | On |
| **Screen Shake (Buffer Clack Bump)** | Off (red flash + haptic only) | On (4 dp offset) | On (6 dp offset) |
| **Level Map Parallax** | Off | On (2 layers) | On (3 layers) |
| **Drop Shadows** | Pre-baked into sprites | Pre-baked | Pre-baked |

- Settings "Battery Saver" forces the Low profile immediately.
- Automatic tier demotion triggers after 3 consecutive janky levels (> 5% dropped frames).

### 2. Rendering Rules (Shared)
- Particles use a pre-allocated object pool and one `canvas.drawAtlas` call per frame. Counts are capped by the pool manager.
- Glows and rays use `BlendMode.plus`. Zero per-frame `MaskFilter.blur`, no `BackdropFilter`, and no `saveLayer` per particle.
- Alpha strictly uses `Color.withValues(alpha:)`, not `withOpacity`.
- The on-demand Ticker starts when an effect is active and halts when all effect queues are empty (0 fps on static board).

### 3. Gameplay Effect Catalog for Toy Trains
Events correspond 1:1 with `SOUND_EFFECTS_IMPLEMENTATION.md` event IDs, synchronizing audio, haptics, and visual feedback:
| Event ID | Known Trigger | Defined VFX Behavior (Toy Trains Theme) |
|---|---|---|
| `path_tap` | Tapped train accepts departure command | Instant micro-squash on engine (0.95 scale, 40 ms) + tiny chimney steam puff. Must appear within 50 ms. |
| `path_exit` / `path_exit_combo` | Train engine clears board boundary | Puffs of white steam trail each carriage; wheels emit golden friction sparkles. Combo steps 1–5 escalate steam plume volume and sparkle brilliance. |
| `bump` | Train buffers contact blocker | Buffers clack with squash-rebound (`Curves.easeOutBack`), 120 ms red flash on blocker, wooden splinter dust puff. Shake applied per tier. |
| `locked_tap` | Tap on locked/frozen/tangled train | Muted side wobble (2 cycles, 150 ms) + lock reason icon badge appears for 600 ms; no heart lost, no red flash. |
| `heart_lost` | Heart depleted on HUD | Wooden heart token splits with fracture line and scatters 4 wooden splinter particles. |
| `shield_absorb` | Cowcatcher Shield absorbs bump | Cowcatcher armor flashes brass shockwave; absorbs impact without heart loss; shield badge decrements. |
| `last_path_exit` / `win_stinger` | Final train departs board | Train accelerates with grand steam plume; win confetti fountain erupts in primary train colors (red, blue, yellow, green, brass) up to tier particle limit. |
| `star_1` / `star_2` / `star_3` | Stars land on Level Complete | Wooden stars slam into place with scale overshoot (1.3 -> 1.0) and expanding radial brass light ring (`BlendMode.plus`). |
| `coins_fly` | Level complete coins awarded | Brass coins arc from reward banner to HUD wallet counter (throttled max 1 per 80 ms, max 8 per burst). |
| `gift_open` / `chest_open` | Milestone crate / Phase chest unboxed | Wooden crate lid pops open with golden glow burst and particle confetti spray. |
| `booster_hint` | Green Signal Hint activated | Green signal lamp pops above target locomotive, casts soft radial green glow (`BlendMode.plus`), and engine pulses twice. |
| `booster_shield_on` | Cowcatcher Shield activated | Cowcatcher cowcatcher armor overlay attaches to HUD hearts with blue radiant aura flare. |
| `booster_hammer` | Track Crane activated | Target crosshair overlays valid items; crane hook lowers from top edge, clamps target, and hoists it off with clank sparks. |
| `preview_start` | Free Route Peek long-press | Dotted railway route renders on playmat: green dotted ties for clear exit; red dotted ties terminating in red ✕ on blocker. |

### 4. Mechanic Effect Classes (M001–M049)
Grouped by the 13 shared effect classes defined in `VFX_IMPLEMENTATION.md` section 4.4:
- **Blocker Hit (`bump_flash`):** M001 Buffer Stop, M002 Cargo Crate, M029 Table Edge Fence: Red flash + wood splinter debris.
- **Crack / Shards (`crack_shards`):** M003 Snowed-In (snow crystals disperse), M016 Rock Pile (gravel shards on HP decrement), M042 Repair Siding (splinters clear).
- **State Toggle (`state_toggle`):** M004/M043 Ticket Barriers (barrier arm swings up with brass flash), M005 Platform Gate, M007 Level Crossing (gate opens), M009 Signal Lever, M018 Track Switch, M019 Weighbridge Plate, M030 Station Exit, M031 Last Call Exit, M033 Locked Siding, M038 Junction Signal: Mechanical pop with illuminated signal glow.
- **Badge Pulse (`badge_pulse`):** M007, M017 Steam Pressure (red pulsing warning flare at 1 move remaining), M031, M041 Windmill Signal: Clockwork dial number countdown pulse.
- **Lane Warp (`lane_warp`):** M008 Tunnel Pair, M044 Bend Tunnel: Train dissolves into tunnel shadow and re-emerges from partner mouth.
- **Fog Dissolve (`fog_dissolve`):** M010 Steam Cloud: Volumetric steam cloud expands and evaporates into transparent alpha.
- **Grow Burst (`grow_burst`):** M027 Creeping Ivy (ivy foliage expands with leaf particles), M035 Depot Dispatcher (depot shed doors open, child tender rolls out), M047 Auto-Coupler Freight (new carriage couples with latch click spark).
- **Rotate Swoosh (`rotate_swoosh`):** M013 Turntable, M034 Rotating Yard 2x2: Turntable track circular plate rotates 90° CW with subtle radial speed streak.
- **Layering:** M015 Wooden Overpass, M032 Viaduct Deck: Pre-baked elevated drop shadow separating upper track from lower track.
- **Guardian Boss (`guardian_hit` & defeat):** M049 Clock Tower Guardian: HP hits trigger clockwork gear sparks; defeat triggers Westminster chime fanfare and brass celebratory burst.

### 5. Intro Effects ("Toy Box Lid")
- Steam puffs (12/24/40 particles by tier, life 450 ms, rise 30 dp), signal lamp glow (`BlendMode.plus`, max alpha 0.5), brass shimmer bands (1 band Low, 2 bands Mid/High), wooden letter block bounce squash and stretch. Details specified in `specs/tech/splash-and-instant-launch.md`.

### 6. Data and Asset Configuration
- Single shared VFX atlas: `assets/vfx/atlas.webp` (particles, sparks, steam puffs, star glows) pre-warmed at startup.
- Effect parameters (particle life, velocities, scales, color tint tokens) loaded from `assets/theme.json`.

### 7. QA Checklist (VFX-01 to VFX-10)
- **VFX-01:** Every gameplay event and mechanic in section 3 & 4 has an active effect class or explicit "no effect" entry.
- **VFX-02:** Low tier never exceeds 30 live particles; Mid capped at 80; High capped at 150.
- **VFX-03:** Buffer clack bump on Low tier triggers red flash and haptic only (zero screen shake).
- **VFX-04:** Battery Saver setting immediately demotes visual profile to Low tier.
- **VFX-05:** Reduce Motion accessibility setting completely removes screen shake and particle fountains.
- **VFX-06:** 60 fps maintained without jank on Low tier during L500 win celebration with full confetti.
- **VFX-07:** When Haptics setting is disabled, zero haptic calls are made while visual effects render normally.
- **VFX-08:** SFX, haptic pulse, and visual animation for any event initiate on the exact same frame.
- **VFX-09:** A static puzzle board produces 0 frames per second after all animations settle.
- **VFX-10:** Color-blind compliance: red bump flash is paired with physical buffer rebound; color gates display distinct geometric icons.

## Affected Files
- `apps/toy_trains/lib/features/gameplay/render/vfx/particle_pool.dart` (to be created)
- `apps/toy_trains/lib/features/gameplay/render/vfx/vfx_catalog.dart` (to be created)
- `apps/toy_trains/assets/vfx/atlas.webp` (to be created)
- `apps/toy_trains/assets/theme.json` (to be created)

## Risks
- Rapid tapping triggering multiple simultaneous steam puff particle bursts; pool manager drops oldest particles when ceiling is reached.

## Open Questions
- Final aesthetic styling of wooden letter block squash curves for the victory banner (defined during visual art pass).
- Whether win confetti and exit steam particles share a single global pool or two dedicated sub-pools.
