Source docs: SOUND_EFFECTS_IMPLEMENTATION.md, phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/audio/sound-effects.md.

# Spec: Audio — Phase 2 Sound Effects & Music Additions

## Status
Draft

## Type
Improvement (extends audio catalog and music tracks from `specs/audio/sound-effects.md` for Phase 2 content)

## Goal
Specify the audio assets, background music loops, sound effects (SFX) for Phase 2 mechanics (M051–M099), LiveOps event audio triggers (Sticker Album, Star Race, Piggy Bank), and audio pool budgets for Snakes Slither Phase 2.

## Current State
Design documented in `SOUND_EFFECTS_IMPLEMENTATION.md` and `phase_2/` docs, not yet implemented.
- Phase 1 audio in `specs/audio/sound-effects.md` defined the base ASMR jungle audio engine, `AudioPool` integration, and Phase 1 SFX within a 10 MB budget.
- Phase 2 adds +4 MB to the audio budget (total 14 MB) to cover P2-A and P2-B music tiers, Level 1000 Finale, mechanics SFX, and LiveOps stings.

## Proposed Change
Extend `AudioService` and `theme.json` audio manifests to incorporate Phase 2 audio assets:

### 1. Phase 2 Music Tracks
| Track Key | Usage | Style & Description | Length | Target Loudness |
|---|---|---|---|---|
| `music_gameplay_p2a` | Tier P2-A (Levels 501–750) | Gentle waterfall ambient, marimba melodies, warm rainforest bird calls | 60 s loop | -18 LUFS |
| `music_gameplay_p2b` | Tier P2-B (Levels 751–1000) | Ancient temple stone percussions, resonant crystal chimes, mystic tones | 75 s loop | -18 LUFS |
| `music_finale_p2` | Level 1000 Finale | Epic-cozy jungle orchestral blend with royal mongoose percussion | 90 s loop | -16 LUFS |

### 2. Phase 2 Mechanic Sound Effects
Mapped to generic SFX event categories adhering to `SOUND_EFFECTS_IMPLEMENTATION.md` §5:

| SFX Key | Mechanic / Trigger | Sound Description | Max Polyphony |
|---|---|---|---|
| `sfx_push_coconut` | M053 Rolling Coconut | Heavy wooden hollow thud across soil | 2 |
| `sfx_slide_ice` | M054 Ice Slide Crate | Smooth crystalline scrape across ice floor | 2 |
| `sfx_plate_depress` | M055 Pressure Plate | Solid stone mechanical click | 2 |
| `sfx_beam_strike` | M084 / M087 Sunbeam | Warm solar hum and crystal harmonic chime | 3 |
| `sfx_mirror_turn` | M085 Stone Mirror | Heavy polished stone grinding 90° CW | 2 |
| `sfx_rotor_turn` | M079 Island Rotor | Sub-board stone rotation whoosh and locking clack | 1 |
| `sfx_quicksand_sink`| M067 Quicksand | Wet, squelching mud suction | 2 |
| `sfx_centipede_split`| M092 Segment Worm | Soft wooden bead snap as segments disengage | 3 |
| `sfx_mongoose_growl`| M098 Prowling Mongoose | Low-frequency playful animal growl on step | 1 |

### 3. LiveOps Event Audio Stings
| Event ID | Feature | Sound Description | Timing & Ducking |
|---|---|---|---|
| `sfx_stamp_thump` | Sticker Album | Heavy wooden wax stamp pressing into paper | Immediate, ducks BGM by -6 dB for 400 ms |
| `sfx_race_notch` | Star Race | Cheerful brass cheer and energetic track notch pop | On Level Complete dialog |
| `sfx_race_podium`| Star Race | Triumphant fanfare with cascading jungle chimes | Results dialog popup |
| `sfx_piggy_smash` | Piggy Bank | Ceramic pot smash with resounding coin shower burst | During break transaction resolution |

### 4. Technical Integration & Memory Footprint
- All Phase 2 SFX are encoded in Opus format (.opus) or OGG (.ogg) at 44.1 kHz, 24 kbps mono.
- Music loops encoded in 44.1 kHz, 64 kbps stereo OGG.
- Memory usage of pre-warmed Phase 2 audio assets strictly capped at <= 4.0 MB.

## Affected Files
- `assets/audio/music/music_gameplay_p2a.ogg` (to be added)
- `assets/audio/music/music_gameplay_p2b.ogg` (to be added)
- `assets/audio/music/music_finale_p2.ogg` (to be added)
- `assets/audio/sfx/phase_2/` (directory of 15 SFX files to be added)
- `lib/core/audio/audio_service.dart` (extended with Phase 2 event maps)

## Risks
- Rapid successive diagonal snake exits and sliding blocks causing audio channel clipping. Mitigated by `AudioPool` instance limits (max 3 instances per SFX key) and 40 ms throttle windows.

## Open Questions
- None. Track definitions, LUFS standards, and mechanic SFX match `SOUND_EFFECTS_IMPLEMENTATION.md` and `phase_2/` docs.
