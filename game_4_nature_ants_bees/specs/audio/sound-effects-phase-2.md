Source docs: SOUND_EFFECTS_IMPLEMENTATION.md, phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/audio/sound-effects.md

# Spec: Audio Engine and Sound Effects (Phase 2 Additions)

## Status
Draft

## Type
Improvement

## Goal
Specify the Phase 2 audio asset additions, 3rd-layer insect sounds, push physics audio, sunbeam/prism cues, and LiveOps sound effects for Ants & Bees: Garden Trails.

## Current State
Design documented in SOUND_EFFECTS_IMPLEMENTATION.md and phase_2/06.
- Extends `specs/audio/sound-effects.md`.
- Phase 1 covered ground ants and mid-air bees with a 10 MB budget.
- Phase 2 adds canopy layer flight, push physics, sunbeam optics, and LiveOps audio events with an additional 4 MB budget (total <= 14 MB).

## Proposed Change
Extend `apps/ants_bees/assets/audio/theme.json` and `AudioService` with Phase 2 audio cues:

### 1. Phase 2 Audio Specifications
- **Audio Format:** WAV mono 16-bit 44.1 kHz for SFX (<= 70 KB each).
- **Phase 2 Audio Budget:** <= +4 MB additional assets (total Phase 1 + 2 audio <= 14 MB).
- **Latency Target:** <= 50 ms tap-to-sound maintained on all tiers.

### 2. Phase 2 Event Catalog Additions (`theme.json`)
| Event ID | Sound Asset | Audio Description |
|---|---|---|
| `path_exit_canopy` | `audio/sfx/path_exit_canopy_v1..v3.wav` | High-altitude airy wing flutter and ethereal chime for Canopy Scout Bees (M069). |
| `push_block` | `audio/sfx/acorn_push.wav` | Woody friction thud when Rolling Acorn (M053) is nudged. |
| `ice_slide` | `audio/sfx/leaf_slide.wav` | Smooth watery swoosh as push block glides across Dew-Slick Lily Leaf (M054). |
| `plate_socket` | `audio/sfx/socket_click.wav` | Deep resonant click when acorn settles into Seed Socket Plate (M055). |
| `swap_whoosh` | `audio/sfx/mushroom_swap.wav` | Spore puff and spatial swap whoosh for Twin Mushroom Swap (M060). |
| `beam_on` | `audio/sfx/sunbeam_hum.wav` | Continuous low crystalline shimmer when Solar Lens (M084) ignites. |
| `beam_reflect` | `audio/sfx/mirror_ting.wav` | Sharp glassy reflection ping on Beetle-Shell Mirror (M086). |
| `prism_split` | `audio/sfx/prism_chord.wav` | Harmonic floral triad chord when Dew Prism (M089) splits white sunlight. |
| `stag_beetle_march`| `audio/sfx/beetle_step.wav` | Heavy armored carapace step for Patrolling Great Stag Beetle (M098). |
| `master_door_open` | `audio/sfx/hive_door_unlock.wav` | Grand golden honeycomb gate slide for Royal Hive Door (M099). |
| `album_stamp` | `audio/sfx/album_stamp.wav` | Resonant soft leather journal stamp SFX upon placing Compendium sticker. |
| `bank_deposit` | `audio/sfx/honey_drip_coin.wav` | Distinctive honey drop splash into bank (+10 coins deposit). |
| `bank_break` | `audio/sfx/honeycomb_break.wav` | Triumphant honeycomb rupture and coin cascade when bank is unlocked. |
| `race_win` | `audio/sfx/race_fanfare.m4a` | 3-second celebratory garden trumpet and bee buzzing victory stinger. |

### 3. Music Additions
- `music_gameplay_p2a.m4a`: Sunny meadow canopy soundtrack for Levels 501–750 (80 BPM).
- `music_gameplay_p2b.m4a`: Dense sunlit forest canopy theme for Levels 751–1000 (85 BPM).
- `music_jubilee_finale.m4a`: Grand royal garden symphony for Level 1000 "Queen's Midsummer Jubilee".

## Affected Files
- `apps/ants_bees/assets/audio/theme.json` (to be extended)
- `apps/ants_bees/lib/features/audio/services/audio_service.dart` (to preload Phase 2 cues)

## Risks
- Audio overlapping during multi-beam reflection chains; resolved by setting audio voice pooling to max 2 concurrent instances per beam event.

## Open Questions
- None. Phase 2 audio mappings conform to SOUND_EFFECTS_IMPLEMENTATION.md §9 and phase_2/06.
