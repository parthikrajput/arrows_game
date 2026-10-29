Source docs: ../../PERFORMANCE_OPTIMIZATION.md, ../../SPLASH_AND_INSTANT_LAUNCH.md, ../../SHARED_CORE_STANDARD.md, ../../SOUND_EFFECTS_IMPLEMENTATION.md

# Spec: VFX and Game Feel (Snakes Slither)

## Status
Draft

## Type
New Feature

## Goal
Collect and implement all visual effects and game feel (particles, shake, flashes, trails, haptic pairing) of Snakes Slither in one place, within the shared device-tier budgets, so every effect has a defined trigger, a tier limit and a QA check.

## Current State
VFX rules exist only as scattered notes. There is no VFX catalog yet. Nothing is implemented.
- Shared tier limits: ../../PERFORMANCE_OPTIMIZATION.md section 3.3 (quality profile) and the particle rules (object pool, one `drawAtlas` call).
- Bump rule: SHARED_CORE_STANDARD.md says a blocked path hits the blocker with "shake + haptic + sound" and returns (-1 Heart).
- Haptic mapping per event: ../../SOUND_EFFECTS_IMPLEMENTATION.md section 5 (SFX and haptic fire on the same frame; no haptic call when Settings Haptics is off).
- Intro effects for this game: ../../SPLASH_AND_INSTANT_LAUNCH.md section 7 (Jungle Dawn).

## Proposed Change
### 1. Tier limits (shared, same for all four games)
Gameplay rules never change by tier. Only visuals scale.
| Feature | Low | Mid | High |
|---|---|---|---|
| Particles (win confetti, exit sparkle) max live | 30 | 80 | 150 |
| Background ambient animation (swaying leaves, clouds) | Off (static image) | On, 30 fps update | On |
| Idle animation (snake breathing and eye blink) | Off | Only on the tapped item | All items, staggered |
| Exit trail effect | Simple fade | On | On |
| Screen shake (bump) | Off (haptic + red flash only) | On, 4 dp | On, 6 dp |
| Level Map parallax | Off | On | On |
| Shadows | Pre-baked into the sprite on all tiers | same | same |
Settings "Battery Saver" forces the Low profile. A tier is demoted after 3 janky levels (see specs/tech/performance-optimization.md once it exists).

### 2. Rendering rules (shared)
- Particles use a pre-allocated object pool and one `drawAtlas` call per frame. Counts stay inside the tier limit above.
- Glows and rays use `BlendMode.plus`. No per-frame `MaskFilter.blur`, no `BackdropFilter`, no `saveLayer` per particle.
- Alpha uses `Color.withValues(alpha:)`, not `withOpacity`.
- The on-demand Ticker starts when an effect is added and stops when the queue is empty, so a static board costs 0 frames.

### 3. Gameplay effect catalog for Snakes Slither
Events use the same IDs as SOUND_EFFECTS_IMPLEMENTATION.md section 5, so SFX, haptic and VFX fire together. The dynamic layer paints only: moving snakes, trail particles and tongue-flick previews.
| Event | Known today | VFX still to define |
|---|---|---|
| `path_tap` | Haptic `selectionClick` | tap response (must show within 50 ms) |
| `path_exit` / `path_exit_combo` | Haptic `lightImpact`; combo steps 1 to 5 | snake exit trail and sparkle; combo escalation look |
| `bump` | Shake (tier based) + red flash + haptic `mediumImpact` | bonk effect specific to this theme |
| `heart_lost` | Haptic `heavyImpact`; heart icon break animation | break particles |
| `shield_absorb` | Haptic `lightImpact` | shield pop |
| `last_path_exit` / win | Win confetti uses the particle cap | confetti look; star landing effect for `star_1` to `star_3` |
| `coins_fly` | Max 1 per 80 ms, max 8 per burst | coin trail look |
| Boosters: Glow Firefly Hint (Hint), Safety Shell Shield (Shield), Magic Stone Hammer (Hammer), Tongue-Flick Preview (free long-press) | Hint glow, hammer impact frame | per booster effect |
| Mechanic effects (M001 onwards) | SFX events listed per mechanic | one effect per mechanic group (gates, portals, beams, rotation, growth, guardians) |
Rule for new mechanics (Phase 3+): reuse an existing effect first. Add a new effect only when the player needs a new meaning, the same rule as SFX events.

### 4. Intro effects (already designed)
leafBurst (12/24/40 particles, life 300 ms, from the Play button), dawn light rays (BlendMode.plus, max alpha 0.35), dew sparkles (4, Mid/High only, settle track). The short intro (second cold start of the day) drops particles and rays. Details and timings: ../../SPLASH_AND_INSTANT_LAUNCH.md section 7 (Jungle Dawn).

### 5. Data and assets
- One effects atlas per game (particles, glows, sparkles) loaded with the gameplay atlases and pre-warmed before leaving Home.
- Effect parameters (count, life, size, colour tokens) live in this game's `theme.json`, so puzzle_core stays free of theme art.

### 6. QA checklist
- VFX-01: Every event in section 3 has an effect or a written "no effect" decision.
- VFX-02: Low tier never exceeds 30 live particles; Mid 80; High 150.
- VFX-03: Bump on Low tier shows haptic + red flash, no shake.
- VFX-04: Battery Saver switches to the Low profile at once, rules unchanged.
- VFX-05: Reduce Motion removes shake and particles.
- VFX-06: 60 fps and jank under 1% on a Low tier device during a win with full confetti.
- VFX-07: With Haptics off no haptic call is made and visual effects still play.
- VFX-08: SFX, haptic and VFX of one event start on the same frame.
- VFX-09: A static board produces 0 frames after all effects end.
- VFX-10: Effects work for colour-blind players (never colour only; the red flash is always paired with shake or an icon).

## Affected Files
- `apps/snakes_slither/lib/features/gameplay/render/vfx/particle_pool.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/render/vfx/vfx_catalog.dart` (to be created)
- `apps/snakes_slither/assets/vfx/atlas.webp` (to be created)
- `apps/snakes_slither/assets/theme.json` (VFX parameters, to be extended)

## Risks
- Too many particles on Low tier cause jank; the cap must be enforced in the pool, not in each effect.
- Red flash and shake can hurt accessibility; Reduce Motion must be honoured.

## Open Questions
- The effect for each event marked "VFX still to define" is not designed yet. It needs art direction for Snakes Slither.
- Whether win confetti and exit sparkle share one pool or use two.
- The Phase 3 to 20 signature systems (Cycles, Multi-floor, Light and Beams, Rotation, Growth, Gravity, Mirror and others) need their own effects. They are covered in each phase spec, not here.
