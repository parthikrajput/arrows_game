# VFX & Game Feel Implementation Standard

> Game-wise copy for **Ants & Bees** (`game_4_nature_ants_bees`). This file lives in this game folder and is the version used here. The same document exists in the other three game folders; when a shared rule or number changes, update all four copies. Links to other games point to the sibling game folders.

> ચારેય games માં visual effects (particles, shake, flash, trail, glow) અને game feel કેવી રીતે implement કરવા તેના નિયમો, effect classes, event mapping, tier limits અને QA checklist. VFX ની બાબતમાં આ document એકમાત્ર source of truth છે. Numbers (tier limits, haptic) બીજા shared docs માંથી લીધેલા છે; અહીં નવો number ત્યારે જ છે જ્યારે "Proposed" લખ્યું હોય.

**Related docs:** [SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) (bump rule, §13 Tech stack) · [PERFORMANCE_OPTIMIZATION.md](./PERFORMANCE_OPTIMIZATION.md) (§3.3 quality profile, particles) · [SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) (event IDs, haptic) · [SPLASH_AND_INSTANT_LAUNCH.md](./SPLASH_AND_INSTANT_LAUNCH.md) (intro effects) · Game folders: [Snakes](../game_1_snakes_slither/README.md) · [Yarn](../game_2_yarn_unravel/README.md) · [Trains](../game_3_toy_trains/README.md) · [Ants & Bees](./README.md)

---

## 1. Goals (હેતુ)

1. દરેક player action નો visual feedback **તરત** મળે: tap → visual response **≤ 50 ms** (PERFORMANCE_OPTIMIZATION).
2. Effects **cozy અને relaxing** લાગે: soft, rounded, કોઈ harsh flash નહીં; 10 થી 50 વર્ષના players માટે comfortable.
3. **Effects વગર પણ game પૂરેપૂરું સમજાય.** VFX ફક્ત feedback છે, rules નથી. Tier, Battery Saver કે Reduce Motion થી gameplay rules ક્યારેય બદલાય નહીં.
4. ચારેય games એક જ **effect classes** અને **event IDs** વાપરે (SFX જેવા જ). માત્ર art (atlas, colour tokens, parameters) theme પ્રમાણે બદલાય.
5. Static board = **0 frames** (on-demand Ticker). Effects પૂરા થાય એટલે Ticker બંધ.

## 2. Architecture

```
puzzle_core (pure Dart)            app layer (Flutter)
RulesEngine ── emits GameEvent ──▶ GameBloc ──▶ VfxService ──▶ EffectPool + BoardAnimator
 (event ID, cell/path)                           │               (dynamic layer, one Ticker)
                                                 ├─▶ AudioService   (same event ID, same frame)
                                                 └─▶ HapticService  (same event ID, same frame)
```

- `puzzle_core` માં કોઈ art કે effect code નહીં. તે ફક્ત event ID અને position emit કરે છે.
- `VfxService` event ID ને **effect class** (§4) સાથે map કરે છે; parameters game ના `theme.json` માંથી આવે છે.
- SFX, haptic અને VFX એક જ event થી **એક જ frame** પર શરૂ થાય.
- Effects ફક્ત **dynamic layer** માં દોરાય. Static layer (grid, obstacles, stationary paths) effects થી rebuild નથી થતું.

## 3. Rendering Rules (બધા games)

| Rule | Detail |
|---|---|
| Ticker | એક `Ticker` per board (`BoardAnimator`). Effect add થાય ત્યારે શરૂ, queue ખાલી થાય ત્યારે બંધ |
| Particles | Pre-allocated object pool, એક `drawAtlas` call per frame. Tier max નીચે §5 |
| Blend | Glows/rays `BlendMode.plus`. `MaskFilter.blur` per frame, `BackdropFilter`, per-particle `saveLayer` **પ્રતિબંધિત** |
| Alpha | `Color.withValues(alpha:)`; `withOpacity` નહીં |
| Shadows | Sprite માં pre-baked (બધા tiers) |
| Atlas | દરેક game નો એક effects atlas (`assets/vfx/atlas.webp`), gameplay atlases સાથે load, Home છોડતા પહેલાં pre-warm |
| Parameters | count, life, size, colour tokens `theme.json` માં; code માં hardcode નહીં |
| Easing | Intro ના easing set સાથે મેળ ([SPLASH §5](./SPLASH_AND_INSTANT_LAUNCH.md)): `easeOutCubic`, `easeOutBack`, `easeIn`, `linear` |
| Colour-blind | Effect ફક્ત colour પર નિર્ભર નહીં. Red flash સાથે હંમેશાં shake/icon/shape |
| Reduce Motion | OS "Remove animations" અથવા in-game Reduce Motion ચાલુ હોય તો: shake બંધ, particles બંધ, ફક્ત short fade |

## 4. Effect Classes (generic — ચારેય games)

Event IDs = [SOUND_EFFECTS_IMPLEMENTATION.md §5](./SOUND_EFFECTS_IMPLEMENTATION.md) ના જ. નવો mechanic આવે ત્યારે પહેલાં existing effect class reuse કરો; નવો class ત્યારે જ ઉમેરો જ્યારે player ને નવો અર્થ સમજાવવો જરૂરી હોય.

### 4.1 Core gameplay
| Event ID | Effect class | જે નક્કી છે | Haptic |
|---|---|---|---|
| `path_tap` | `tap_response` | દેખાવ ≤ 50 ms માં | `selectionClick` |
| `path_exit` | `exit_trail` | Low: simple fade · Mid/High: trail + sparkle | `lightImpact` |
| `path_exit_combo` | `exit_trail` + combo escalation | steps 1–5 (SFX pitch જેવા) | `lightImpact` |
| `bump` | `bump_flash` | Shake + red flash + haptic. Low: shake બંધ (haptic + red flash). Mid 4 dp, High 6 dp | `mediumImpact` |
| `locked_tap` | `denied_nudge` | નાનું nudge/shake, red નહીં (Heart જતો નથી) | `selectionClick` |
| `heart_lost` | `heart_break` | Heart icon break animation | `heavyImpact` |
| `shield_absorb` | `shield_pop` | Shield charge વપરાય તે ક્ષણે | `lightImpact` |
| `preview_start` | `preview_line` | Long-press preview line (free, dynamic layer) | — |
| `last_path_exit` | `exit_trail` + `slowmo_hint` (Proposed) | win પહેલાંનો છેલ્લો exit | `mediumImpact` |

### 4.2 Win & rewards
| Event ID | Effect class | Detail |
|---|---|---|
| `win_stinger` | `win_confetti` | Particles tier cap મુજબ (§5) |
| `star_1`, `star_2`, `star_3` | `star_land` | દરેક star પડે ત્યારે glow/pop; SFX 3 rising pitches સાથે sync |
| `coins_fly` | `coin_trail` | Max 1 per 80 ms, max 8 per burst (SFX જેવું throttle) |
| `coins_total` | `counter_pop` | Wallet count-up end |
| Gift Box / Phase Chest open | `chest_burst` (Proposed) | Reward reveal; particles cap માં |

### 4.3 Boosters
| Event ID | Effect class | Haptic |
|---|---|---|
| `booster_hint` | `hint_glow` | — |
| `booster_shield_on` | `shield_aura` | `lightImpact` |
| `booster_hammer` | `hammer_impact` (impact frame + debris) | `mediumImpact` |
| `heart_refill` / `revive` | `heart_restore` | `mediumImpact` |

### 4.4 Mechanics (Phase 1 & 2)
Mechanic ના effects SFX event groups ને અનુસરે; દરેક group નો એક effect class:

| Group | SFX events | Effect class |
|---|---|---|
| Blocker hit | `blocker_hit_soft/hard` | `bump_flash` + material debris (soft: પાંદડાં/રૂ, hard: spark) |
| Crack / break / frozen | `crack`, `break`, `frozen_crack/free` | `crack_shards` |
| Lock / key / gate / lever / switch / plate | `lock_open`, `key_collect`, `gate_*`, `lever_toggle`, `switch_click`, `plate_*` | `state_toggle` (glow + small pop) |
| Counter / countdown | `counter_tick`, `countdown_warning` | `badge_pulse` |
| Portal / jump / deflect | `portal_whoosh`, `jump`, `deflect` | `lane_warp` |
| Fog / reveal | `fog_clear` | `fog_dissolve` |
| Growth / spawn / eat | `grow`, `spawn`, `eat` | `grow_burst` |
| Rotation | `rotate`, `board_rotate` | `rotate_swoosh` (board rotation માં static picture rotate, rebuild નહીં) |
| Beams | `beam_on`, `beam_hit` | `beam_glow` (`BlendMode.plus`) |
| Recolor / split / merge / phase | `color_change`, `split`, `merge`, `phase_shift` | `morph_flash` |
| Guardian | `guardian_hit`, `guardian_defeat` | `guardian_hit` + defeat `win_confetti` mini |
| Push / slide | `push_block`, `slide_block`, `mud_stop` | `dust_puff` |
| Chain | `domino_chain` | `bump_flash`-free chain pulse, 60 ms apart (SFX જેવું) |

દરેક mechanic નું exact look game ની spec (`specs/ui/vfx-and-juice.md`) માં નક્કી થાય. Phase 3+ ની signature systems (Cycles, Multi-floor, Gravity વગેરે) ના effects દરેક phase ની `06_UI_AND_QA_PHASE_N` અને phase spec માં આવે; અહીં ફક્ત generic class ઉમેરાય.

## 5. Quality Profile (tier મુજબ) — PERFORMANCE_OPTIMIZATION §3.3 મુજબ

Gameplay **rules** tier થી બદલાતા નથી.

| Feature | Low | Mid | High |
|---|---|---|---|
| Particles (win confetti, exit sparkle) max live | 30 | 80 | 150 |
| Background ambient animation | Off (static) | On, 30 fps update | On |
| Path idle animation | Off | ફક્ત tapped path પર | બધા, staggered |
| Exit trail | Simple fade | On | On |
| Screen shake (bump) | Off (haptic + red flash) | On, 4 dp | On, 6 dp |
| Level Map parallax | Off | On | On |
| Shadows | Pre-baked | Pre-baked | Pre-baked |

- Particle cap pool માં enforce થાય, દરેક effect માં નહીં.
- Settings "Battery Saver" તરત Low profile લાગુ કરે.
- Tier demotion (3 levels માં janky > 5%) પછી effects આપોઆપ નીચલા tier પર.

## 6. Intro Effects
App intro (splash) ના effects [SPLASH_AND_INSTANT_LAUNCH.md](./SPLASH_AND_INSTANT_LAUNCH.md) માં છે (leaf burst, wool fluff, steam, nectar sparkle વગેરે, tier caps 12/24/40). તે ત્યાં જ રહે; અહીં duplicate નહીં.

## 7. Game-wise VFX Design (theme mapping)

દરેક game ની spec: `specs/ui/vfx-and-juice.md`. Theme મુજબ ફક્ત art બદલાય.

| Game | Exit / sparkle theme | Ambient (Mid/High) | Booster look | Spec |
|---|---|---|---|---|
| 1 Snakes Slither | snake exit trail, leaf sparkle | swaying leaves, clouds | Glow Firefly, Safety Shell, Magic Stone | [spec](../game_1_snakes_slither/specs/ui/vfx-and-juice.md) |
| 2 Yarn Unravel | thread pull-off trail, wool tuft | hearth glow, fluff | Needle Glow, Thimble, Golden Scissors | [spec](../game_2_yarn_unravel/specs/ui/vfx-and-juice.md) |
| 3 Toy Trains | steam trail, spark | steam, tabletop light | Green Signal, Cowcatcher, Track Crane | [spec](../game_3_toy_trains/specs/ui/vfx-and-juice.md) |
| 4 Ants & Bees | ant dust and bee nectar sparkle (બે layers) | swaying grass, sunlight | Nectar Glow, Queen's Shield, Leaf Blower | [spec](./specs/ui/vfx-and-juice.md) |

Game-specific effect (દા.ત. exact particle sprite, colour, count) **Open decision** છે જ્યાં સુધી art direction ન થાય.

## 8. CI & Validation
- Effect parameter validator: દરેક effect class ના `theme.json` માં parameters હોવા જ જોઈએ; missing = build fail.
- Particle cap test: Low 30 / Mid 80 / High 150 થી વધુ live particles ન બને.
- Event coverage test: SFX catalog ના દરેક event ID માટે effect class અથવા લેખિત "no effect" નિર્ણય.
- Forbidden API lint: `MaskFilter.blur` per frame, `BackdropFilter`, `withOpacity`.

## 9. QA Checklist (status: Not run)

| ID | Test | Expected | Status |
|---|---|---|---|
| VFX-01 | દરેક event ID નો effect class | Effect અથવા "no effect" નિર્ણય છે | Not run |
| VFX-02 | Low tier win confetti | ≤ 30 live particles, 0 jank | Not run |
| VFX-03 | Bump on Low tier | Haptic + red flash, shake નહીં | Not run |
| VFX-04 | Battery Saver toggle | તરત Low profile, rules એ જ | Not run |
| VFX-05 | Reduce Motion | Shake અને particles બંધ, short fade | Not run |
| VFX-06 | Low tier 60 fps | Jank < 1% full confetti પર | Not run |
| VFX-07 | Haptics off | Haptic call નહીં, visuals ચાલે | Not run |
| VFX-08 | SFX + haptic + VFX sync | એક જ frame | Not run |
| VFX-09 | Static board | Effects પછી 0 frames | Not run |
| VFX-10 | Colour-blind | Red flash સાથે shake/icon | Not run |
| VFX-11 | Tap response | ≤ 50 ms | Not run |
| VFX-12 | 20 rapid background/foreground | Pool/Ticker સ્વસ્થ, leak નહીં | Not run |

## 10. Open decisions
- `slowmo_hint` અને `chest_burst` (Proposed) રાખવા કે નહીં.
- દરેક effect class નો exact look, count અને life દરેક game ની art direction પછી.
- Win confetti અને exit sparkle એક pool કે બે pool.
