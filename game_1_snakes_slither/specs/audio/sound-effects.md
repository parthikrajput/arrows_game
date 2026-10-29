Source docs: ../../SOUND_EFFECTS_IMPLEMENTATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Audio Engine and Sound Effects

## Status
Draft

## Type
New Feature

## Goal
Implement the audio engine, ASMR-inspired jungle soundscape, low-latency sound effect playback, dynamic music ducking, and settings integration for Snakes Slither Phase 1.

## Current State
Design documented in ../../SOUND_EFFECTS_IMPLEMENTATION.md and phase_1/07, not yet implemented.
- Pure-Dart `puzzle_core` emits generic `GameEvent`s; app-layer `GameBloc` maps them to `SoundCue(eventId)` and triggers `AudioService`.
- Audio assets mapped via game-specific `assets/audio/theme.json`.
- SFX budget <= 70 KB per file; music loops <= 2 MB per track; total game audio budget <= 10 MB.
- Maximum 8 concurrent SFX voices; minimum 50 ms interval between identical event sounds.
- Latency target: tap to sound playback <= 50 ms on mid-tier hardware.

## Proposed Change
Implement the audio engine service, asset structure, and theme mappings:

### 1. Package & Platform Audio Setup
- **Audio Package:** `audioplayers` package (shared across all games).
- **Android Configuration:**
  - SFX: `PlayerMode.lowLatency` (backed by Android `SoundPool`).
  - Music: `PlayerMode.mediaPlayer`.
  - Audio focus: `AndroidAudioFocus.gain` for music; `AndroidAudioFocus.none` for SFX (never terminates external podcast/music players).
- **iOS Configuration:**
  - `AVAudioSession` set to `ambient` category with `AudioContextConfig(respectSilence: true)`. Honours hardware silent/mute switch.
- **Background Music Detection:**
  - If third-party music (Spotify, Apple Music) is already active at launch, in-game background music is automatically muted while SFX remain active. Settings toggles remain unchanged.

### 2. Audio Asset Specifications
| Audio Type | Format | Specification | Size Limit |
|---|---|---|---|
| **SFX** | `.wav` | PCM 16-bit, **mono**, 44.1 kHz, length 0.05–0.8 s (stingers <= 2.5 s). Lead silence <= 5 ms. Peak <= -1 dBTP | <= 70 KB each |
| **Music Loops** | `.m4a` | AAC-LC 128 kbps stereo, 44.1 kHz, 60–120 s seamless loop. 20 ms crossfade at loop points | <= 2 MB each |
| **Stingers** | `.m4a` | AAC 128 kbps, length <= 4 s | <= 100 KB each |

- OGG format is strictly forbidden due to lack of native decoding on iOS.
- Total Phase 1 audio budget is strictly <= 10 MB.
- Integrated loudness: Music at -18 LUFS.

### 3. Snakes Slither Theme Mapping (`theme.json`)
The generic event IDs are mapped to custom jungle audio files:
| Generic Event ID | Snakes Slither Sound Asset | Description & Timing |
|---|---|---|
| `path_tap` | `audio/sfx/path_tap.wav` | Soft scale rustle when valid tap is accepted |
| `path_exit` | `path_exit_v1.wav` ... `_v3.wav` | Slithery "swish" + cute pop (3 round-robin variants) |
| `path_exit_combo` | `path_exit_combo_1.wav` ... `_5.wav` | Pre-rendered pitch-up steps for 3+ consecutive exits |
| `bump` | `bump_v1.wav`, `bump_v2.wav` | Soft "boink" on snout playing on blocker contact frame |
| `locked_tap` | `locked_tap.wav` | Sleepy "hmm-mm" nuh-uh wobble |
| `heart_lost` | `heart_lost.wav` | Leaf heart-berry flutter-pop on heart loss |
| `shield_absorb` | `shield_absorb.wav` | Safety Shell "clink" when hit is absorbed |
| `preview_start` | `preview_start.wav` | Soft tongue flick on long-press preview start |
| `last_path_exit` | `last_path_exit.wav` | Final snake exit flourish before win screen |
| `blocker_hit_hard` | `blocker_hit_hard.wav` | Rock bonk layer for Garden Rock (M001) |
| `blocker_hit_soft` | `blocker_hit_soft.wav` | Wood bonk layer for Fallen Log (M002) |
| `frozen_crack` / `_free` | `frozen_crack.wav` / `_free.wav` | Ice cracking / shattering on Frost Coil (M003) |
| `lock_open` / `key_collect` | `lock_open.wav` / `key_collect.wav` | Bamboo cage creak / key flying to lock (M004) |
| `gate_open` / `gate_close` | `gate_open.wav` / `gate_close.wav` | Flower petal bloom / close (M005, M007, M009) |
| `portal_whoosh` | `portal_whoosh.wav` | Burrow "fwump" on Rabbit Burrows (M008, M044) |
| `lever_toggle` | `lever_toggle.wav` | Branch snap / toggle (M009, M045) |
| `fog_clear` | `fog_clear.wav` | Gentle breeze clearing Jungle Mist (M010) |
| `wake_up` | `wake_up.wav` | Sleepy yawn/stretch for Sleepy Python (M012) |
| `rotate` | `rotate.wav` | Water ripple swirl for Spinning Lilypad (M013) |
| `eat` | `eat.wav` | Cute chomp for Hungry Caterpillar (M036) |
| `guardian_defeat` | `guardian_defeat.wav` | Grumpy Mongoose "poof" + cheer (M049) |
| `booster_hint` | `booster_hint.wav` | Firefly sparkle glissando |
| `booster_shield_on` | `booster_shield_on.wav` | Shell equipping chime |
| `booster_hammer` | `booster_hammer.wav` | Cartoon stone smash impact |
| `win_stinger` | `win_stinger.m4a` | Cheerful jungle marimba flourish |
| `coins_fly` | `coins_fly.wav` | Throttled soft gold-leaf coin tinkle (max 1 per 80 ms) |
| `gift_open` / `chest_open` | `gift_open.wav` / `chest_open.wav` | Basket rustle / treasure chest fanfare |

### 4. Music Tracks
- `music_home.m4a`: Home, Shop, Settings (calm marimba/kalimba, 70–90 BPM).
- `music_map.m4a`: Level Map (harmonically matched to `music_home` for crossfading).
- `music_gameplay_t1.m4a` through `music_gameplay_t5.m4a`: Tier-specific ambient biome music (Meadow, Bamboo, Orchard, Swamp, Moonlit Jungle).
- `music_rush.m4a`: Up-tempo 30-second percussion track for Golden Slither Rush.
- `music_finale.m4a`: Boss track for Level 500 "Mongoose King's Garden".
- `music_daily.m4a`: Daily Jungle Puzzle track.

### 5. Mixer, Buses & Ducking
- **Buses:** Master (1.0), Music (0.55), SFX (1.0), UI (0.7).
- **Ducking Rules:**
  - Win stinger / Phase complete: Music ducks by -8 dB for the duration of stinger + 300 ms release.
  - Second Chance popup & Level Failed: Music ducks by -6 dB.
  - Full-screen ads (interstitial / rewarded): Music is paused and SFX muted immediately. Restored with 300 ms fade-in upon ad dismissal.
  - App background / incoming call: All audio paused; resumes on foreground return.
  - Screen transitions: 600 ms crossfade between tracks; identical track continues without interruption.
- **Concurrency & Rate Limits:** Maximum 8 simultaneous SFX voices. If voice limit is exceeded, lowest-priority oldest sounds are dropped. Same event ID has a minimum 50 ms throttle.

### 6. Settings & Persistence
- Audio settings saved in Hive `settings` box: `sound` (bool), `music` (bool), `haptics` (bool).
- Toggles take effect immediately without requiring app restart.
- Device silent mode mutes both SFX and music while keeping haptic feedback functional.

### 7. Audio QA Checklist
All items initialized with status **"Not run"**:
- AUD-01: Tap path to sound latency <= 50 ms on mid-tier hardware.
- AUD-02: Bump sound fires on exact contact frame, not tap frame.
- AUD-03: Rapid spam tapping (10 taps/sec) handles voice limits without crackling or memory leaks.
- AUD-04: Sound toggle disables SFX/UI audio; music unaffected.
- AUD-05: Music toggle stops/resumes loop with smooth fade.
- AUD-06: Haptics toggle disables device vibration.
- AUD-07: iOS silent switch mutes audio.
- AUD-08: Android ringer silent mode mutes audio.
- AUD-09: Background music from other apps mutes in-game music while SFX play.
- AUD-10: Ad presentation pauses game audio and restores on return.
- AUD-11: App lifecycle pause/resume handles audio correctly.
- AUD-12: Incoming phone call interrupts and resumes correctly.
- AUD-13: Unplugging headphones on Android pauses music.
- AUD-14: Screen navigation crossfades music without stutter.
- AUD-15: 10-minute music loop plays without audible seams or clicks.
- AUD-16: Coin Rush switches to rush music and restores cleanly.
- AUD-17: Win screen ducks music and throttles coin sounds.
- AUD-18: Mechanic intro levels trigger appropriate themed audio cues.
- AUD-19: Missing audio asset logs `E-AUD-001` without crashing gameplay.
- AUD-20: Audio memory overhead <= 15 MB on 2 GB RAM device.
- AUD-21: Full level playable on mute with clear visual accessibility equivalents.
- AUD-22: `tools/audio_check` passes all asset validation rules on CI.
- AUD-23: Ant vs bee sounds distinguished in engine (Game 4 check).
- AUD-24: `CREDITS.md` accounts for commercial/CC0 licensing of every audio asset.

## Affected Files
- `apps/snakes_slither/lib/services/audio_service.dart` (to be created)
- `apps/snakes_slither/lib/services/haptics.dart` (to be created)
- `apps/snakes_slither/assets/audio/theme.json` (to be created)
- `apps/snakes_slither/assets/audio/CREDITS.md` (to be created)
- `tools/audio_check/bin/audio_check.dart` (to be created)

## Risks
- Audio latency on low-end Android devices: requires pre-allocating `AudioPool` instances during level load.
- Seamless music looping: AAC files may introduce header padding gaps; `audioplayers` must use 20 ms crossfade at boundaries.

## Open Questions
- All sound assets must be licensed for commercial distribution (CC0 or purchased commercial libraries) and referenced in `CREDITS.md`.
