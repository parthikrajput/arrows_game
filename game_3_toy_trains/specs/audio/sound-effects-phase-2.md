Source docs: SOUND_EFFECTS_IMPLEMENTATION.md, phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/audio/sound-effects.md.

# Spec: Audio — Phase 2 Sound Effects & Music Additions (Toy Trains)

## Status
Draft

## Type
Improvement (extends audio catalog and music tracks from `specs/audio/sound-effects.md` for Phase 2 content)

## Goal
Specify the audio assets, background music loops, sound effects (SFX) for Phase 2 mechanics (M051–M099), LiveOps event audio triggers (Sticker Album, Star Race, Piggy Bank), and audio pool budgets for Toy Trains: Wooden Railway Puzzle Phase 2.

## Current State
Design documented in `SOUND_EFFECTS_IMPLEMENTATION.md` and `phase/phase_2/` docs, not yet implemented.
- Phase 1 audio (`specs/audio/sound-effects.md`) established the base tactile wooden toy ASMR audio engine, `AudioPool` integration, and Phase 1 SFX within a 10 MB budget.
- Phase 2 allocates an additional +4 MB audio budget (total 14 MB) to incorporate P2-A and P2-B music tiers, Level 1000 Finale, mechanics SFX, and LiveOps stings.

## Proposed Change
Extend `AudioService` and sound manifests to incorporate Phase 2 audio assets:

### 1. Phase 2 Music Tracks
| Track Key | Usage | Style & Description | Length | Target Loudness |
|---|---|---|---|---|
| `music_gameplay_p2a` | Tier P2-A (Levels 501–750) | Cozy wooden railway chimes, toy glockenspiel, and playful flute melodies | 60 s loop | -18 LUFS |
| `music_gameplay_p2b` | Tier P2-B (Levels 751–1000) | Alpine mountain locomotive rhythm, resonant wooden marimba, and brass train horns | 75 s loop | -18 LUFS |
| `music_finale_p2` | Level 1000 Finale | Triumphant orchestral music-box hybrid with grand brass whistle accents | 90 s loop | -16 LUFS |

### 2. Phase 2 Mechanic Sound Effects
Mapped to physical wooden toy tactile sounds adhering to `SOUND_EFFECTS_IMPLEMENTATION.md` §5:

| SFX Key | Mechanic / Trigger | Sound Description | Max Polyphony |
|---|---|---|---|
| `sfx_whistle_diag` | M051 Diagonal Express | Cheerful high-pitched double toot with 45° stereo pan | 2 |
| `sfx_cart_shove` | M053 Push Cart | Heavy hollow wooden cart clattering across track ties | 2 |
| `sfx_slide_ice` | M054 Frosty Rails | Smooth crystalline scrape and sliding hiss across frosty rails | 2 |
| `sfx_weighbridge_ding`| M055 Cart Weighbridge | Solid brass mechanical bell chime upon cart depression | 2 |
| `sfx_light_beam` | M084 Signal Lamp | Warm optical lamp hum and glass lens flare shimmer | 2 |
| `sfx_mirror_align` | M086 Signal Mirror | Crisp metallic spring click when mirror reflects ray | 2 |
| `sfx_roundhouse_turn` | M070 Roundhouse / M079 Playmat | Heavy wooden gear ratchet grinding and locking into position | 1 |
| `sfx_jam_squelch` | M087 Jam Spill | Sticky adhesive suction pop as locomotive breaks free | 2 |
| `sfx_domino_cascade` | M097 Domino Crates | Rapid rhythmic clack-clack-clack of cascading wooden crates | 1 |
| `sfx_marching_clock` | M098 Marching Clock Tower | Heavy brass pendulum thud and gear tick on patrol step | 1 |

### 3. LiveOps Event Audio Stings
| Event ID | Feature | Sound Description | Timing & Ducking |
|---|---|---|---|
| `sfx_sticker_stamp` | Depot Sticker Album | Heavy wooden wax seal stamp pressing into paper parchment | Immediate, ducks BGM by -6 dB for 400 ms |
| `sfx_race_notch` | Star Express Race | Energetic brass chime and wooden counter notch pop | On Level Complete dialog |
| `sfx_race_podium`| Star Express Race | Triumphant fanfare with cheerful station master whistle | Results dialog popup |
| `sfx_piggy_smash` | Ticket Piggy Bank | Ceramic piggy bank shatter followed by an energetic coin shower burst | During break transaction resolution |

### 4. Technical Integration & Audio Budget
- All Phase 2 SFX encoded in OGG Opus format (`.opus`) or OGG Vorbis (`.ogg`) at 44.1 kHz, 24 kbps mono.
- Music loops encoded in 44.1 kHz, 64 kbps stereo OGG.
- Combined memory footprint of pre-loaded Phase 2 audio assets strictly capped at `<= 4.0 MB`.

## Affected Files
- `assets/audio/music/music_gameplay_p2a.ogg` (to be added)
- `assets/audio/music/music_gameplay_p2b.ogg` (to be added)
- `assets/audio/music/music_finale_p2.ogg` (to be added)
- `assets/audio/sfx/phase_2/*.ogg` (to be added)
- `lib/core/audio/sound_effects.dart` (changed: register Phase 2 sound keys)

## Risks
- Audio memory overflow on low-end devices if all Phase 1 and 2 SFX remain pinned in RAM. Mitigation: Dynamically unload Phase 1 tier-specific music tracks and load Phase 2 tracks only when active tier is entered.

## Open Questions
- None. All audio categories and decibel targets match `SOUND_EFFECTS_IMPLEMENTATION.md` and Phase 2 docs.
