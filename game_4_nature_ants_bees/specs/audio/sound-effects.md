Source docs: SOUND_EFFECTS_IMPLEMENTATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Audio Engine, Soundscape, and Haptic Feedback

## Status
Draft

## Type
New Feature

## Goal
Implement the audio engine, sunny garden soundscape, layer-specific insect sound effects, dynamic music ducking, and synchronized haptic feedback for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in SOUND_EFFECTS_IMPLEMENTATION.md and phase_1/07, not yet implemented.
- Pure-Dart `puzzle_core` emits generic `GameEvent`s; app-layer `GameBloc` maps them to `SoundCue(eventId)` and triggers `AudioService`.
- Audio assets mapped via game-specific `assets/audio/theme.json`.
- SFX budget <= 70 KB per file; music loops <= 2 MB per track; total Phase 1 audio budget <= 10 MB.
- Maximum 8 concurrent SFX voices; minimum 50 ms interval between identical event sounds.
- Latency target: tap to sound playback <= 50 ms on mid-tier hardware.

## Proposed Change
Implement the audio engine service, asset structure, and theme mappings in `apps/ants_bees/lib/features/audio/`:

### 1. Package & Platform Audio Setup
- **Audio Package:** `audioplayers` package.
- **Android Configuration:**
  - SFX: `PlayerMode.lowLatency` (backed by Android `SoundPool`).
  - Music: `PlayerMode.mediaPlayer`.
  - Audio Focus: `AndroidAudioFocus.gain` for music; `AndroidAudioFocus.none` for SFX (preserves background podcasts and external music).
- **iOS Configuration:**
  - `AVAudioSession` set to `ambient` category with `AudioContextConfig(respectSilence: true)`. Respects hardware silent/ringer switch.
- **Background Music Detection:**
  - If third-party music (Spotify, Apple Music) is playing when app starts, in-game background music is automatically muted while SFX remain active.

### 2. Audio Asset Specifications
| Audio Type | Format | Specification | Size Limit |
|---|---|---|---|
| **SFX** | `.wav` | PCM 16-bit, **mono**, 44.1 kHz, length 0.05–0.8 s (stingers <= 2.5 s). Lead silence <= 5 ms. Peak <= -1 dBTP | <= 70 KB each |
| **Music Loops** | `.m4a` | AAC-LC 128 kbps stereo, 44.1 kHz, 60–120 s seamless loop. 20 ms crossfade at loop points | <= 2 MB each |
| **Stingers** | `.m4a` | AAC 128 kbps, length <= 4 s | <= 100 KB each |

- OGG format is strictly prohibited due to lack of native iOS decoding.
- Total Phase 1 audio budget is strictly <= 10 MB.
- Integrated loudness: Music at -18 LUFS.

### 3. Ants & Bees Theme Mapping (`theme.json`)
The generic event IDs are mapped to custom garden audio assets:
| Generic Event ID | Ants & Bees Sound Asset | Description & Timing |
|---|---|---|
| `path_tap` | `audio/sfx/path_tap.wav` | Tiny antenna tick (ant) / subtle wing flick (bee) on valid tap accepted |
| `path_exit` | `path_exit_ground_v1..v3.wav` / `path_exit_air_v1..v3.wav` | Ground: crisp pitter-patter march; Air: gentle bzzz fly-away |
| `path_exit_combo` | `path_exit_combo_1.wav` ... `_5.wav` | Rising pitch chimes for consecutive exits without bump |
| `bump` | `bump_ground.wav` / `bump_air.wav` | Cute comic "bonk" on obstacle collision frame |
| `locked_tap` | `locked_tap.wav` | Tiny "tsk" chirp warning |
| `heart_lost` | `heart_lost.wav` | Delicate floral petal flutter and shatter |
| `shield_absorb` | `shield_absorb.wav` | Resonant royal honey chime |
| `preview_start` | `preview_start.wav` | Gentle antenna rustle on long-press preview start |
| `last_path_exit` | `last_path_exit.wav` | Final garden fanfare flourish before level win |
| `blocker_hit_hard` | `pebble_click.wav` | Crisp stone click for Garden Pebble (M001) |
| `blocker_hit_soft` | `twig_snap.wav` | Woody snap for Twig Fence (M002) |
| `dew_free` | `dew_pop.wav` | Water bubble pop for Dew-Stuck Line (M003) |
| `lock_open` | `thorn_unlock.wav` | Untwisting thorn sound for Thorn Lock (M004) |
| `gate_open` | `petal_gate_open.wav` | Flower petal unfolding for Petal Gate (M005) |
| `portal_whoosh` | `burrow_whoosh.wav` | Subterranean earth whoosh for Burrow Tunnel (M008) |
| `lever_toggle` | `lever_toggle.wav` | Clean twig click for Twig Lever (M009) |
| `mist_clear` | `mist_clear.wav` | Light breeze clearing Morning Mist (M010) |
| `daisy_rotate` | `daisy_rotate.wav` | Whirring petal spin for Spinning Daisy (M013) |
| `crumb_eat` | `crumb_nibble.wav` | Cute munch for Hungry Line (M036) |
| `spider_defeat` | `spider_defeat.wav` | Web dissolve and spider scuttle for Great Orb Spider (M049) |
| `booster_hint` | `booster_hint.wav` | Nectar drip glissando and shimmer |
| `booster_shield_on` | `booster_shield_on.wav` | Golden honeycomb bubble activation hum |
| `booster_hammer` | `booster_hammer.wav` | Leaf blower swirling wind gust |
| `win_stinger` | `win_stinger.m4a` | Cheerful garden chimes and bee harmony fanfare |
| `coins_fly` | `coins_fly.wav` | Honey-coin drip clink (throttled to max 1 per 80 ms) |
| `gift_open` / `chest_open` | `gift_open.wav` / `chest_open.wav` | Flower-box rustle / royal treasure fanfare |

### 4. Music Tracks
- `music_home.m4a`: Home, Shop, Settings (acoustic guitar, light flute, ambient birdsong bed, 75–90 BPM).
- `music_map.m4a`: Level Map (harmonically matched to `music_home` for crossfading).
- `music_gameplay_t1.m4a` through `music_gameplay_t5.m4a`: Tier-specific ambient garden tracks (Lawn Meadow, Clover Patch, Sunlit Orchard, Shady Bramble, Twilight Canopy).
- `music_rush.m4a`: Up-tempo 30-second percussion track for Golden Nectar Rush.
- `music_finale.m4a`: Grand celebratory garden theme for Level 500 "Queen's Garden Gala".
- `music_daily.m4a`: Morning acoustic garden tune for Daily Almanac.

### 5. Mixer, Buses, Ducking & Preloading
- **Buses:** Master (1.0), Music (0.55), SFX (1.0), UI (0.7).
- **Ducking:** Win stinger and Phase complete stingers duck background music by -8 dB with a 300 ms recovery envelope.
- **Selective Preload:** On level launch, `AudioService` preloads only the specific SFX required by that level's active mechanics. Core gameplay and UI SFX are preloaded at startup.

## Affected Files
- `apps/ants_bees/lib/features/audio/services/audio_service.dart` (to be created)
- `apps/ants_bees/lib/features/audio/services/haptic_service.dart` (to be created)
- `apps/ants_bees/lib/features/audio/models/sound_theme.dart` (to be created)
- `apps/ants_bees/assets/audio/theme.json` (to be created)
- `apps/ants_bees/assets/audio/CREDITS.md` (to be created)

## Risks
- Audio glitches or latency if mono WAV format is not strictly observed.
- Layer sound differentiation (`path_exit_ground` vs `path_exit_air`) must be reliably mapped based on path layer.

## Open Questions
- None. Theme sound assets and specifications conform to SOUND_EFFECTS_IMPLEMENTATION.md §9.
