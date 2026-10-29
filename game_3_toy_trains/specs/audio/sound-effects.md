Source docs: ../../SOUND_EFFECTS_IMPLEMENTATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Sound Effects & Music Implementation (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the railway audio engine, low-latency SoundPool playback, wooden toy ASMR soundscapes, music-box loops, ducking, and concurrency controls for Toy Trains Phase 1.

## Current State
Design documented in ../../SOUND_EFFECTS_IMPLEMENTATION.md and phase_1/07, not yet implemented.
- Pure Dart `puzzle_core` emits generic `GameEvent` notifications; app layer maps them to themed audio cues.
- Tactile wooden toy railway aesthetic (wooden buffer clacks, whistle toots, signal bells, music box BGM).
- Strict tap-to-audio latency target <= 50 ms on mid-tier hardware.
- Safe concurrency caps (max 8 voices, min 50 ms same-event throttle).

## Proposed Change
Implement the audio service, asset catalog, and mixing pipeline in `apps/toy_trains/lib/services/audio_service.dart`:

### 1. Audio Architecture & Pipeline
- **Package:** `audioplayers` utilizing `AudioPool` instances for pre-loaded SFX and dual `AudioPlayer` instances for seamless music crossfading.
- **Android Configuration:**
  - SFX: `PlayerMode.lowLatency` backed by native `SoundPool`. Focus `AndroidAudioFocus.none` so external music continues playing.
  - Music: `PlayerMode.mediaPlayer`.
- **iOS Configuration:**
  - `AVAudioSessionCategory.ambient` with `respectSilence: true` (respects hardware silent switch).
- **External Audio Coexistence:**
  - On launch, if background music is active (e.g. Spotify), game music automatically mutes while railway SFX play normally.
- **Asset Specifications:**
  - SFX: Uncompressed `.wav`, PCM 16-bit, **mono**, 44.1 kHz, duration 0.05–0.8 s (stingers <= 2.5 s), peak <= -1 dBTP, size <= 70 KB each.
  - Music Loops: `.m4a` AAC-LC 128 kbps stereo, 44.1 kHz, 60–120 s loop with 20 ms crossfade, size <= 2 MB each.
  - Total Phase 1 audio budget: **<= 10 MB**.

### 2. Toy Trains Sound Event Mapping
All sound assets are defined in `assets/audio/theme.json`:
| Event ID | Themed Audio Asset Description | Variants | Priority | Paired Haptic |
|---|---|---|---|---|
| `path_tap` | Wooden click + tiny locomotive toot | 1 | 3 | `selectionClick` |
| `path_exit` | Toot-toot whistle + wooden rolling wheels (short sample, no continuous loops) | 3 | 2 | `lightImpact` |
| `path_exit_combo` | Melodic pitch-up whistle steps 1 through 5 (pre-rendered) | 5 | 2 | `lightImpact` |
| `bump` | Wooden buffer "clack" | 2 | 1 | `mediumImpact` |
| `locked_tap` | Muted wooden knock | 1 | 4 | `selectionClick` |
| `heart_lost` | Wooden heart cracking splinter sound | 1 | 1 | `heavyImpact` |
| `shield_absorb` | Cowcatcher metallic chime ring | 1 | 1 | `lightImpact` |
| `booster_hint` | Railway signal bell "ding-ding" | 1 | 3 | — |
| `booster_hammer` | Track Crane hydraulic lift + metallic clank | 1 | 2 | `mediumImpact` |
| `gate_open` | Level-crossing bell + wooden barrier lift | 1 | 3 | — |
| `lock_open` | Conductor ticket punch click + gate pop | 1 | 2 | — |
| `portal_whoosh` | Acoustic tunnel echo whoosh | 1 | 3 | — |
| `lever_toggle` | Heavy railway ground-lever clunk | 1 | 3 | `selectionClick` |
| `rotate` | Turntable cogwheel ratcheting rotation | 1 | 3 | — |
| `crack` / `break` | Cargo crate / rock pile splintering break | 2 | 2 | — |
| `counter_tick` | Clockwork mechanical ratchet tick | 1 | 4 | — |
| `guardian_hit` | Clock tower bell resonance strike | 1 | 1 | `mediumImpact` |
| `guardian_defeat` | Harmonious clock-tower Westminster chime + celebration | 1 | 1 | `heavyImpact` |
| `win_stinger` | Joyful toy whistle + music-box fanfare | 1 | 1 | `mediumImpact` |
| `level_fail` | Soft, gentle wooden descending cadence (never a harsh buzzer) | 1 | 2 | — |
| `coins_fly` | Brass coin clinking onto wood (throttled: max 1 per 80 ms, max 8 per burst) | 3 | 3 | — |
| `star_1` / `star_2` / `star_3` | Rising xylophone bell tones | 3 | 2 | `lightImpact` |

### 3. Music Tracks & Mood
- **Musical Palette:** Toy xylophone, acoustic piano, music-box, light nostalgic ragtime (70–90 BPM).
- **Tracks:**
  - `music_home`: Main menu, Shop, and Settings loop.
  - `music_map`: Level Map exploration loop (keyed to crossfade seamlessly with `music_home`).
  - `music_gameplay_t1` through `t5`: Minimalist wooden puzzle beds tailored to each tier.
  - `music_rush`: Fast-paced, energetic 30-second brass track for Golden Express Coin Rush.
  - `music_finale`: Cozy-epic orchestration for Level 500 Grand Central Finale.

### 4. Mixer, Ducking & Voice Management
- **Buses:** `master` (1.0), `music` (0.55), `sfx` (1.0), `ui` (0.7).
- **Ducking Rules:**
  - Win stinger or Phase complete ducks `music` by -8 dB for duration + 300 ms release.
  - Second Chance popup ducks `music` by -6 dB.
  - Full-screen ads immediately pause `music` and mute `sfx`; restored with 300 ms fade-in on ad dismiss.
- **Voice Allocation:** Hard ceiling of 8 simultaneous SFX channels. Lowest priority drops first. Minimum 50 ms spacing between identical event IDs prevents spam distortion.

### 5. Audio QA Matrix (AUD-01 to AUD-10)
All tests verified against Android (Galaxy A14) and iOS (iPhone 11):
- **AUD-01:** Tap-to-sound latency <= 50 ms (verified via high-speed camera).
- **AUD-02:** Buffer clack bump audio fires exactly on contact frame, not on initial tap.
- **AUD-03:** 10 taps/sec spam produces no audio distortion, memory leak, or voice exhaustion.
- **AUD-04/05/06:** Settings toggles for Sound, Music, and Haptics operate independently and persist across app restart.
- **AUD-07/08:** Hardware silent switch (iOS) and silent mode (Android) mute gameplay SFX.
- **AUD-09:** External audio (Spotify) continues playing; game music mutes automatically.
- **AUD-10:** Ads pause and restore audio cleanly without popping or glitching.

## Affected Files
- `apps/toy_trains/lib/services/audio_service.dart` (to be created)
- `apps/toy_trains/lib/services/haptics_service.dart` (to be created)
- `apps/toy_trains/assets/audio/theme.json` (to be created)
- `apps/toy_trains/assets/audio/CREDITS.md` (to be created)
- `tools/audio_check/bin/audio_check.dart` (to be created)

## Risks
- SoundPool latency regressions on budget MediaTek chips; mitigated by keeping WAV assets mono and under 70 KB.

## Open Questions
- None. Asset specifications and ducking contracts match SOUND_EFFECTS_IMPLEMENTATION.md.
