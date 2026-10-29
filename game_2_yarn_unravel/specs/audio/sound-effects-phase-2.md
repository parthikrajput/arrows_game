Source docs: SOUND_EFFECTS_IMPLEMENTATION.md, phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/audio/sound-effects.md.

# Spec: Audio — Phase 2 Sound Effects & Music Additions

## Status
Draft

## Type
Improvement (extends audio assets, music loops, and sound effects from `specs/audio/sound-effects.md` for Phase 2 content)

## Goal
Specify the audio assets, background music loops, sound effects (SFX) for Phase 2 mechanics (M051–M099), LiveOps event audio triggers (Scrapbook, Star Race, Knitted Piggy Bank, Wardrobe), and audio pool budgets for Yarn Unravel Phase 2.

## Current State
Design documented in `SOUND_EFFECTS_IMPLEMENTATION.md` and `phase/phase_2/` docs, not yet implemented.
- Phase 1 audio in `specs/audio/sound-effects.md` established the cozy craft ASMR soundscape (needle tug, unravel zzzip, damped twang snag <= 3 kHz) within a 10 MB budget.
- Phase 2 expands the audio budget by +4 MB (total 14 MB) to incorporate P2-A and P2-B music tiers, Level 1000 Finale, mechanics SFX, and LiveOps stings.

## Proposed Change
Extend `AudioService` and sound manifest mappings in `assets/audio/`:

### 1. Phase 2 Music Tracks
All music tracks are mastered to -18 LUFS (-16 LUFS for finale) and delivered in 128 kbps Ogg Vorbis (Android) and AAC (iOS):

| Track Key | Target Usage | Style & Instrumentation | Loop Length | Target Loudness |
|---|---|---|---|---|
| `music_gameplay_p2a` | Tier P2-A (Levels 501–750) | Warm fingerstyle acoustic guitar, gentle woolen bell chimes, soft hearth crackle | 60 s | -18 LUFS |
| `music_gameplay_p2b` | Tier P2-B (Levels 751–1000) | Contemplative solo cello, vintage music-box melodies, cozy atelier wood ambiance | 75 s | -18 LUFS |
| `music_finale_p2` | Level 1000 Finale ("The Heirloom Tapestry") | Rich acoustic chamber ensemble with rhythmic wooden loom percussions | 90 s | -16 LUFS |

### 2. Phase 2 Mechanic Sound Effects
Mapped to ASMR cozy audio standards adhering to `SOUND_EFFECTS_IMPLEMENTATION.md` §5 & §9:

| SFX Key | Mechanic / Trigger | Sound Description | Max Polyphony | Audio File |
|---|---|---|---|---|
| `sfx_push_crate` | M053 Bobbin Crate | Hollow wooden crate scraping firmly across loom floor | 2 | `sfx_push_crate.ogg` |
| `sfx_slide_satin` | M054 Satin Glide Patch | Silky smooth fabric friction whoosh | 2 | `sfx_slide_satin.ogg` |
| `sfx_plate_latch` | M055 Crate Dock Plate | Solid wooden latch clicking into spring-loaded socket | 2 | `sfx_plate_latch.ogg` |
| `sfx_beam_shine` | M084 Sewing Lamp | Gentle electric filament hum and crystal optical shimmer | 3 | `sfx_beam_shine.ogg` |
| `sfx_mirror_clack`| M086 Vanity Mirror | Delicate brass hinge swivel and polished glass clack | 2 | `sfx_mirror_clack.ogg` |
| `sfx_frame_turn` | M079 Turning Quilt Frame | Heavy embroidery frame rotating with wood friction and solid latch | 1 | `sfx_frame_turn.ogg` |
| `sfx_fluff_expand`| M075 Creeping Fluff | Soft wool batting puff expanding gently | 2 | `sfx_fluff_expand.ogg` |
| `sfx_guardian_step`| M098 Wandering Guardian | Whimsical pincushion waddle accompanied by subtle metallic pin-clinks | 1 | `sfx_guardian_step.ogg` |

### 3. LiveOps Event Audio Stings
| Event ID | Feature Context | Sound Description | Mixing & Ducking Rules |
|---|---|---|---|
| `sfx_stamp_thump` | Scrapbook Album | Heavy brass wax stamp pressing firmly into thick parchment with paper rustle | Ducks BGM by -6 dB for 400 ms |
| `sfx_race_star_gain` | Weekly Star Race | Cheerful woolen xylophone ding and energetic track notch pop | Plays during level victory tally |
| `sfx_race_podium` | Weekly Star Race | Warm celebratory brass fanfare with cascading music-box chimes | Plays on race completion dialog |
| `sfx_piggy_break` | Knitted Piggy Bank | Ceramic jar smash accompanied by joyful burst of cascading coins | High priority; plays over break animation |
| `sfx_wardrobe_equip` | Wardrobe Cosmetics | Delicate silk ribbon flutter and soft chime | Immediate feedback upon equip |

### 4. Audio Quality & Performance Checklist
- Audio memory footprint verified under the 14 MB Phase 2 ceiling.
- Polyphony caps strictly enforced in `AudioPool` to prevent audio clipping or thread stutters.
- Low-latency sound playback maintained (< 50 ms response time on tap).

## Affected Files
- `lib/core/audio/audio_service.dart` (changed: register Phase 2 audio keys)
- `assets/audio/sfx/*.ogg` (to be created: Phase 2 SFX files)
- `assets/audio/music/*.ogg` (to be created: Phase 2 music tracks)

## Risks
- Multiple simultaneous crate slides and beam hits exceeding device audio channel limits. Mitigated by strict `AudioPool` polyphony limits (max 2 per key).

## Open Questions
None. Audio mappings match `SOUND_EFFECTS_IMPLEMENTATION.md` §9.
