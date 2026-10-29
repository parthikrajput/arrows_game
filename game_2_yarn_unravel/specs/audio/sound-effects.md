Source docs: ../../SOUND_EFFECTS_IMPLEMENTATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Audio Engine and Sound Effects

## Status
Draft

## Type
New Feature

## Goal
Implement the audio engine, cozy ASMR-inspired craft and needlework soundscape, low-latency sound effect playback, dynamic music ducking, and settings integration for Yarn Unravel Phase 1.

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
  - Audio focus: `AndroidAudioFocus.gain` for music; `AndroidAudioFocus.none` for SFX (never interrupts external podcast or music players).
- **iOS Configuration:**
  - `AVAudioSession` set to `ambient` category with `AudioContextConfig(respectSilence: true)`. Honors hardware silent/mute switch.
- **Background Music Detection:**
  - If third-party music (Spotify, Apple Music) is active at launch, in-game background music is automatically muted while SFX remain active. Settings toggles remain unchanged.

### 2. Audio Asset Specifications
| Audio Type | Format | Specification | Size Limit |
|---|---|---|---|
| **SFX** | `.wav` | PCM 16-bit, **mono**, 44.1 kHz, length 0.05–0.8 s (stingers <= 2.5 s). Lead silence <= 5 ms. Peak <= -1 dBTP | <= 70 KB each |
| **Music Loops** | `.m4a` | AAC-LC 128 kbps stereo, 44.1 kHz, 60–120 s seamless loop. 20 ms crossfade at loop points | <= 2 MB each |
| **Stingers** | `.m4a` | AAC 128 kbps, length <= 4 s | <= 100 KB each |

- OGG format is strictly forbidden due to lack of native decoding on iOS.
- Total Phase 1 audio budget is strictly <= 10 MB.
- Integrated loudness: Music at -18 LUFS.

### 3. Yarn Unravel Theme Mapping (`theme.json`)
The generic event IDs are mapped to custom cozy craft audio files:
| Generic Event ID | Yarn Unravel Sound Asset | Description & Timing |
|---|---|---|
| `path_tap` | `audio/sfx/yarn_tug.wav` | Yarn tug "fwp" when valid tap is accepted |
| `path_exit` | `path_exit_v1.wav` ... `_v3.wav` | Thread unravel "zzzip-fwip" (3 round-robin variants) |
| `path_exit_combo` | `path_exit_combo_1.wav` ... `_5.wav` | Pre-rendered pitch-up steps for 3+ consecutive exits |
| `bump` | `bump_snag_v1.wav`, `_v2.wav` | Thread snag "twang" (damped <= 3 kHz dominant; soft twang) |
| `locked_tap` | `locked_pluck.wav` | Muted thread pluck nuh-uh wobble |
| `heart_lost` | `heart_lost_rip.wav` | Soft fabric rip on heart loss |
| `shield_absorb` | `thimble_ding.wav` | Brass thimble "ding" when hit is absorbed |
| `preview_start` | `thread_peek.wav` | Soft needle glide on long-press preview start |
| `last_path_exit` | `last_thread_exit.wav` | Final thread unspool flourish before win screen |
| `booster_hint` | `needle_glint.wav` | Needle glint shimmer when Hint activates |
| `booster_hammer` | `scissors_snip.wav` | Golden scissors snip on target destruction |
| `gate_open` | `eyelet_pop.wav` | Eyelet pop when Color Eyelet opens |
| `lock_open` | `clasp_click.wav` | Clasp click when Charm unlocks |
| `portal_whoosh` | `pompom_puff.wav` | Pompom tunnel puff when entering portal |
| `guardian_defeat` | `pincushion_poof.wav` | Pincushion stuffing poof + cheer on boss defeat |
| `win_stinger` | `win_music_box.m4a` | Music-box flourish + kitten purr on level complete |
| `coins_fly` | `button_tinkle.wav` | Button-coin tinkle (max 1 per 80 ms, max 8 per burst) |
| **Background Music** | `bgm_cozy_hearth.m4a` | Lo-fi acoustic guitar, music box, and crackling fireplace bed |

### 4. Concurrency, Throttling & Voice Limits
- Global maximum of 8 simultaneous SFX audio voices.
- Voice eviction uses oldest-first priority, preserving `bump`, `heart_lost`, and `win_stinger`.
- Event throttling enforces a minimum 50 ms window between identical sound events.
- Dynamic ducking: background music ducks by -6 dB during `win_stinger` and level complete sequences, restoring over a 400 ms fade.

### 5. Settings & Persistence
- `sfx_enabled` (boolean, default true) and `music_enabled` (boolean, default true) saved in Hive `settings`.
- In-flight sounds halt immediately when toggled off.

## Affected Files
- `apps/yarn_unravel/lib/services/audio_service.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/bloc/audio_cue_listener.dart` (to be created)
- `apps/yarn_unravel/assets/audio/theme.json` (to be created)
- `apps/yarn_unravel/assets/audio/sfx/...` (to be created)

## Risks
- SoundPool latency on low-end Android devices must remain under 50 ms; assets must be pre-loaded into memory at level start.
- Damped "twang" bump sound must not contain harsh high frequencies (> 3 kHz) to preserve cozy ASMR game feel.

## Open Questions
- None. Theme mappings and audio parameters align with SOUND_EFFECTS_IMPLEMENTATION.md §9.

