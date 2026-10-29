Source docs: ../../PERFORMANCE_OPTIMIZATION.md, ../../SPLASH_AND_INSTANT_LAUNCH.md, ../../SHARED_CORE_STANDARD.md, ../../SOUND_EFFECTS_IMPLEMENTATION.md, ../../VFX_IMPLEMENTATION.md, phase_1/01_GAME_CONCEPT_AND_RULES.md, phase_1/06_UI_UX_SCREENS.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: VFX and Game Feel (Yarn Unravel)

## Status
Draft

## Type
New Feature

## Goal
Collect and implement all visual effects and game feel (particles, shake, flashes, trails, haptic pairing) of Yarn Unravel in one place, within the shared device-tier budgets, so every effect has a defined trigger, a tier limit, and a QA check.

## Current State
Design documented in VFX_IMPLEMENTATION.md, PERFORMANCE_OPTIMIZATION.md, and phase_1 docs, not yet implemented.
- Shared tier limits: PERFORMANCE_OPTIMIZATION.md section 3.3 (quality profiles) and particle pooling rules (`canvas.drawAtlas`).
- Snag bump rule: SHARED_CORE_STANDARD.md specifies blocked thread snags with shake + haptic + twang sound, returning with 1 heart deducted.
- Haptic mapping per event: SOUND_EFFECTS_IMPLEMENTATION.md section 5 (SFX and haptic fire on identical frame; no haptic call when disabled in Settings).
- Intro effects for Yarn Unravel: SPLASH_AND_INSTANT_LAUNCH.md section 8 ("Hearth & Thread").

## Proposed Change
### 1. Tier Limits (Shared Across All Four Games)
Gameplay rules never change by tier. Only visuals scale:
| Feature | Low Tier (Redmi 9A, 2 GB) | Mid Tier (Galaxy A14) | High Tier (Pixel 8) |
|---|---|---|---|
| Particles (win confetti, exit sparkle) max live | **30** | **80** | **150** |
| Background ambient animation (hearth glow, wool tufts) | Off (static image) | On, 30 fps update | On, 60 fps update |
| Idle animation (thread breathing wobble) | Off | Only on tapped thread | All threads, staggered |
| Exit trail effect | Simple fade | On (tuft trail) | On (tuft trail + yarn ball roll) |
| Screen shake (snag bump) | **Off** (haptic + red flash only) | On, **4 dp** | On, **6 dp** |
| Level Map parallax | Off | On | On |
| Shadows | Pre-baked into sprites | Pre-baked | Pre-baked |

- Settings "Battery Saver" forces the Low quality profile immediately.
- Automatic runtime tier demotion occurs if janky frames exceed 5% across first 3 completed levels.

### 2. Rendering Rules
- Particles use a pre-allocated object pool and a single `canvas.drawAtlas` call per frame. Counts stay strictly within tier limits.
- Glows and rays use `BlendMode.plus`. Zero per-frame `MaskFilter.blur`, zero `BackdropFilter`, zero `saveLayer` inside particle loops.
- Color alpha strictly uses `Color.withValues(alpha:)`, not deprecated `withOpacity`.
- On-demand `Ticker` starts when an effect is enqueued and stops when empty; static board produces 0 rendered frames.

### 3. Gameplay Effect Catalog for Yarn Unravel
Events map to identical IDs in SOUND_EFFECTS_IMPLEMENTATION.md §5:
| Event | Effect Class | Visual Look & Mechanics | Haptic |
|---|---|---|---|
| `path_tap` | `tap_response` | Subtle thread plump/compression (scale 1.04x for 60 ms) | `selectionClick` |
| `path_exit` | `exit_trail` | Thread unravels around corners via `PathMetric`; small decorative yarn ball spools at edge; wool tuft particle trail (Low: simple fade, Mid: 6 tufts, High: 12 tufts) | `lightImpact` |
| `path_exit_combo` | `exit_trail` + escalation | Combo pitch escalation steps 1–5 accompanied by increasing particle brightness and golden glimmer on tufts | `lightImpact` |
| `bump` | `bump_flash` | Thread snags with spring-back tension; 120 ms red pulse flash on blocker; screen shake (Low: 0 dp, Mid: 4 dp, High: 6 dp) | `mediumImpact` |
| `locked_tap` | `denied_nudge` | Soft 3-cycle horizontal thread wobble (<= 200 ms); lock reason badge pops above thread for 600 ms | `selectionClick` |
| `heart_lost` | `heart_break` | Stitched felt heart unpicks with ripping stitch animation; 4 small red felt fiber particles burst | `heavyImpact` |
| `shield_absorb` | `shield_pop` | Brass thimble icon over heart pulses with golden ring shockwave, absorbing snag hit | `lightImpact` |
| `preview_start` | `preview_line` | Free Thread Peek chain-stitch dotted ray (green = clear, red = blocked with ✕ marker) | — |
| `last_path_exit` | `exit_trail` + slowmo | Final thread unspooling slows slightly (1.2x duration) with golden wool sparkle burst, leading into victory celebration | `mediumImpact` |
| `win_stinger` | `win_confetti` | Purl kitten celebration; confetti composed of miniature pastel buttons, thimbles, and wool pompom particles (Low: 30, Mid: 80, High: 150) | — |
| `star_1`, `star_2`, `star_3` | `star_land` | Embroidered stars drop and stitch onto celebration banner with radial glow pop; synced to 3 rising audio chime steps | `lightImpact` |
| `coins_fly` | `coin_trail` | Wool-coin sprites arc toward HUD balance; max 1 coin per 80 ms, max 8 per burst; HUD balance counter pops (`counter_pop`) | — |
| `chest_burst` | `chest_burst` | Craft Basket or Grand Sewing Chest lid unclasps with radiant golden rays (`BlendMode.plus`) and prize burst | `heavyImpact` |
| `booster_hint` | `hint_glow` | Silver needle glint with pulsing golden thread glow along solver's recommended move | — |
| `booster_shield_on` | `shield_aura` | Brass thimble shield aura envelopes HUD hearts with rotating thread ring | `lightImpact` |
| `booster_hammer` | `hammer_impact` | Golden Scissors snip target with white cross-cut impact frame and 8 severed wool fluff particles | `mediumImpact` |
| `heart_restore` | `heart_restore` | Stitched needle and golden thread re-stitch heart icon on revive or refill | `mediumImpact` |

### 4. Mechanic Effect Classes (M001 to M049)
Mechanic interactions reuse the core effect classes from VFX_IMPLEMENTATION.md §4.4:
- **Blocker Hit (M001 Wooden Button, M002 Ruler Strip, M029 Hem Wall):** `bump_flash` with subtle sawdust/wooden debris.
- **Crack / Break / Frozen (M003 Knotted Thread, M016 Tailor's Chalk):** `crack_shards` (unraveling knot loop, chalk powder erase puff).
- **Lock / Key / Gate / Lever / Switch / Plate (M004 Clasp, M005 Eyelet, M007 Basting, M009 Lever, M018 Switch, M019 Pedal):** `state_toggle` (metallic clasp snap, eyelet stitch glow, lever throw flip).
- **Counter / Countdown (M007 Basting Seam, M017 Fraying Thread, M031 Zipper Edge):** `badge_pulse` (stitched numeral countdown pulse on Move commit; red pulse when <= 2 moves remain).
- **Portal / Deflect / Jump (M008 Pompom Tunnel, M014 Hook Deflector, M038 Elastic Hop Pad):** `lane_warp` (fluffy pompom compression and puff on exit; crochet hook glint; elastic band stretch and release).
- **Fog / Reveal (M010 Wool Fluff):** `fog_dissolve` (soft fluff tufts dissolve outward like parting wool roving when neighbor exits).
- **Growth / Spawner / Beads (M027 Spreading Tangle, M035 Skein Spawner, M036 Bead-Stringer, M047 Growing Knit):** `grow_burst` (loose yarn loop expanding; bead sliding onto needle eye with chime sparkle).
- **Rotation (M013 Spool Spinner, M034 Quilt Block Rotor):** `rotate_swoosh` (spool turning 90 degrees with smooth circular motion blur).
- **Recolor / Morph / Phase (M021 Sheer Silk, M041 Ombre, M048 Color Bundle):** `morph_flash` (silk thread fading between translucent ghost weave and opaque solid thread; gradient hue shift).
- **Boss / Guardian (M049 Grand Pincushion Guardian):** `guardian_hit` (pin impact flash, vibrating needles, HP heart decrement) and `win_confetti` mini (pincushion pops into fluffy cloud of stuffing).
- **Finale (L500 The Grand Quilt):** Grand quilted background unfolds with shimmering golden stitch outlines across all 11x11 cells upon final clear.

### 5. Intro Effects ("Hearth & Thread")
Rose yarn ball hops (0–200 ms), rolls across screen (150–750 ms) unspooling running stitch underline, radial hearth fire glow blooms (alpha 0 -> 0.45 -> 0.12), wordmark stitched on by needle, and Purl's paw bats ball (800–1,150 ms). Low tier skips ambient hearth glow and fluff particles. Details in SPLASH_AND_INSTANT_LAUNCH.md §8.

### 6. QA Checklist
- **VFX-01:** Every event in section 3 and mechanic group in section 4 has an effect or an explicit "no effect" entry.
- **VFX-02:** Low tier never exceeds 30 live particles; Mid 80; High 150. Enforced at the object pool level.
- **VFX-03:** Snag bump on Low tier shows haptic + red flash, strictly 0 dp screen shake.
- **VFX-04:** Battery Saver setting switches immediately to the Low profile without altering gameplay logic.
- **VFX-05:** Reduce Motion accessibility setting completely removes screen shake and particle emissions.
- **VFX-06:** 60 fps maintained with jank < 1% on Low tier devices during full win confetti shower.
- **VFX-07:** With Haptics toggled off in Settings, zero haptic platform calls are dispatched while visual effects play normally.
- **VFX-08:** SFX, haptic feedback, and visual effect frame start on the identical frame.
- **VFX-09:** A stationary board produces 0 frames after all active animations and particle lifespans terminate.
- **VFX-10:** Visual indicators are fully color-blind safe (red bump flash always paired with snag spring oscillation and haptic; thread colors paired with persistent patterns).

## Affected Files
- `apps/yarn_unravel/lib/features/game/render/vfx/particle_pool.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/vfx/vfx_catalog.dart` (to be created)
- `apps/yarn_unravel/assets/vfx/atlas.webp` (to be created)
- `apps/yarn_unravel/assets/theme.json` (VFX parameters, to be extended)

## Risks
- Too many live particles on low-tier hardware causes raster jank; pool must enforce hard clamp at insertion.
- Screen shake and flashing must honor system accessibility and Reduce Motion settings.

## Open Questions
- Exact particle texture assets (felt scraps vs wooden button chips) to be finalized during final art pass.
