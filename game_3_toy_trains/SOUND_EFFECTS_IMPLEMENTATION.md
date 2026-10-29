# Sound Effects & Music Implementation Standard

> Game-wise copy for **Toy Trains** (`game_3_toy_trains`). This file lives in this game folder and is the version used here. The same document exists in the other three game folders; when a shared rule or number changes, update all four copies. Links to other games point to the sibling game folders.

> ચારેય games માં sound effects (SFX), music અને audio behaviour કેવી રીતે implement કરવા તેના નિયમો, event catalog, asset specs, game-wise sound list અને QA checklist. Audio ની બાબતમાં આ document એકમાત્ર source of truth છે; દરેક game ના `07_FRONTEND_IMPLEMENTATION_AND_QA.md` માં audio section માત્ર આ doc ને link કરે છે.

**Related docs:** [SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) (§13 Tech stack, §14 Save) · [LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) (audio errors) · Game folders: [Snakes](../game_1_snakes_slither/README.md) · [Yarn](../game_2_yarn_unravel/README.md) · [Trains](./README.md) · [Ants & Bees](../game_4_nature_ants_bees/README.md)

---

## 1. Goals (હેતુ)

1. દરેક player action નો **તરત** audio feedback મળે: tap → sound latency **≤ 50 ms** (mid-tier device).
2. Sound ગેમને **ASMR / relaxing** feel આપે: soft, rounded sounds, કોઈ harsh buzzer નહીં, 10 થી 50 વર્ષના players માટે comfortable.
3. **Sound વગર પણ game પૂરેપૂરું રમી શકાય.** દરેક sound નો visual equivalent હોય (accessibility, silent mode).
4. ચારેય games એક જ **Audio Engine** (`AudioService` in `puzzle_core` ના app layer) અને એક જ **event IDs** વાપરે. માત્ર asset files theme પ્રમાણે બદલાય.

## 2. Architecture

```
puzzle_core (pure Dart)            app layer (Flutter)
┌──────────────────────┐   emits   ┌────────────────────────────┐
│ RulesEngine          │──────────▶│ GameBloc                   │
│  → List<GameEvent>   │           │  → SoundCue(eventId, ctx)  │
└──────────────────────┘           └─────────────┬──────────────┘
                                                 ▼
                                   ┌────────────────────────────┐
                                   │ AudioService (singleton)   │
                                   │  ├─ SfxBank  (AudioPool×N) │
                                   │  ├─ MusicPlayer (2 players │
                                   │  │   for crossfade)        │
                                   │  ├─ Mixer (buses, ducking) │
                                   │  └─ SoundTheme (eventId →  │
                                   │      asset variants)       │
                                   └────────────────────────────┘
```

- `puzzle_core` audio વિશે કંઈ જાણતું નથી. તે માત્ર `GameEvent` (દા.ત. `PathExited`, `Bumped`, `GateOpened`) emit કરે છે.
- `GameBloc` દરેક event ને `SoundCue` માં map કરે અને animation ના સાચા frame પર play કરાવે. ઉદાહરણ: bump sound blocker સાથે **contact** થાય ત્યારે વાગે, tap વખતે નહીં.
- `SoundTheme` = game-specific mapping (`assets/audio/theme.json`). Engine code ચારેય games માં identical રહે છે.

## 3. Packages & Platform Setup

| Item | Decision |
|---|---|
| Package | `audioplayers` (shared standard §13). SFX માટે `AudioPool` (low-latency, pre-loaded). Music માટે 2 × `AudioPlayer` (crossfade). |
| Android | SFX: `PlayerMode.lowLatency` (SoundPool backed). Music: `PlayerMode.mediaPlayer`. Audio focus: `AndroidAudioFocus.gainTransientMayDuck` **નહીં**. Music માટે `AndroidAudioFocus.gain`, SFX માટે `AndroidAudioFocus.none` (બીજી app ના audio ને રોકે નહીં). |
| iOS | `AVAudioSession` category **`ambient`**: silent switch respect કરે અને બીજી app નું music ચાલુ રહે. `AudioContextConfig(respectSilence: true)`. |
| Other app music already playing | Launch વખતે (iOS `secondaryAudioShouldBeSilencedHint`, Android `AudioManager.isMusicActive` via small platform channel) બીજું music ચાલતું હોય તો **game music આપમેળે mute** થાય અને SFX ચાલુ રહે. Settings બદલાતા નથી. |

```dart
// app/lib/services/audio/audio_context.dart
import 'package:audioplayers/audioplayers.dart';

Future<void> configureGlobalAudio() async {
  await AudioPlayer.global.setAudioContext(
    AudioContextConfig(
      respectSilence: true, // iOS: ambient category, Android: honours ringer mode for SFX
      stayAwake: false,
    ).build(),
  );
}
```

## 4. Asset Specifications

| Type | Format | Spec | Size limit |
|---|---|---|---|
| **SFX** | `.wav` PCM 16-bit, **mono**, 44.1 kHz | Length 0.05–0.8 s (stingers ≤ 2.5 s). Start પર silence ≤ 5 ms. Peak ≤ −1 dBTP. | ≤ 70 KB each |
| **Music loops** | `.m4a` AAC-LC 128 kbps stereo, 44.1 kHz | 60–120 s seamless loop. Start/end bars musically matching. Loop point પર 20 ms crossfade (AAC encoder padding gap છુપાવવા). | ≤ 2 MB each |
| **Stingers** (win, phase complete) | `.m4a` AAC 128 kbps | ≤ 4 s | ≤ 100 KB |

- **Why WAV for SFX:** AAC/MP3 માં ~20–50 ms encoder delay/padding હોય છે, જે ≤ 50 ms latency target તોડે છે. ટૂંકા mono WAV નાના હોય છે અને decode overhead નથી.
- **Why AAC for music:** Android અને iOS બંને native decode કરે છે. OGG iOS પર supported નથી, એટલે **OGG વાપરવું નહીં**.
- **Total audio budget per game:** ≤ 10 MB (Phase 1). Phase 2 additions ≤ +4 MB.
- **Loudness targets:** Music integrated **−18 LUFS**, SFX (normalize per category, §6 table) એવી રીતે કે mix માં music ઉપર સ્પષ્ટ સંભળાય.
- **Folder & naming:**
  ```
  assets/audio/
  ├── theme.json                       # eventId → files mapping (per game)
  ├── sfx/<event_id>[_v<N>].wav        # e.g. path_exit_v1.wav, path_exit_v2.wav
  └── music/<track_id>.m4a             # e.g. music_gameplay_t1.m4a
  ```
  File names lowercase `snake_case`, event ID થી શરૂ થાય, `_v1…_v3` variants.
- **Licensing:** દરેક sound original (in-house/commissioned) અથવા royalty-free commercial license (CC0 / purchased library) વાળો હોય. `assets/audio/CREDITS.md` માં file → source → license → proof link રાખવું. Copyrighted music કે બીજી games ના sounds **ક્યારેય નહીં**.

## 5. Sound Event Catalog (generic — ચારેય games)

દરેક event ID નું asset દરેક game ના `theme.json` માં હોવું ફરજિયાત છે. Priority: 1 = highest (voice limit વખતે ઓછી priority વાળો sound drop થાય). Haptic column = shared haptic mapping (`HapticFeedback`, Settings → Haptics off હોય તો call નહીં).

### 5.1 Core gameplay
| Event ID | Trigger (exact moment) | Variants | Bus | Priority | Haptic |
|---|---|---|---|---|---|
| `path_tap` | Valid path tap accepted (motion શરૂ) | 1 | sfx | 3 | `selectionClick` |
| `path_exit` | Path head board edge પાર કરે | 3 (round-robin) | sfx | 2 | `lightImpact` |
| `path_exit_combo` | 3+ exits without bump ⇒ દરેક next exit (pitch-up pre-rendered steps 1–5) | 5 | sfx | 2 | `lightImpact` |
| `bump` | Head blocker ને contact કરે | 2 | sfx | 1 | `mediumImpact` |
| `locked_tap` | Locked path / disabled control tap | 1 | sfx | 4 | `selectionClick` |
| `heart_lost` | Heart icon break animation start | 1 | sfx | 1 | `heavyImpact` |
| `shield_absorb` | Shield charge consumed | 1 | sfx | 1 | `lightImpact` |
| `preview_start` | Long-press preview line appear | 1 | sfx | 5 | — |
| `level_start` | Board intro animation end | 1 | sfx | 3 | — |
| `last_path_exit` | છેલ્લો path exit (win પહેલાં) | 1 | sfx | 1 | `mediumImpact` |

### 5.2 Mechanics (Phase 1 & 2)
| Event ID | Used by (mechanic IDs) | Trigger |
|---|---|---|
| `blocker_hit_soft` / `blocker_hit_hard` | M001, M002, M029, M074… | Bump material: soft (wood/leaf/fabric) vs hard (stone/metal) |
| `frozen_crack` / `frozen_free` | M003 | Counter −1 / fully free |
| `lock_open` | M004, M043, M046, M080, M088, M099 | Lock opens |
| `key_collect` | M004 key path exit | Key flies to lock |
| `gate_open` / `gate_close` | M005, M007, M009, M019, M031, M055, M057, M064, M090 | State change |
| `counter_tick` | M007, M017, M031, M047, M057 (≤ 3 remaining પર જ) | Move tick |
| `countdown_warning` | M017 at 1 remaining | Badge pulse |
| `portal_whoosh` | M008, M044, M076 | Lane enters portal |
| `lever_toggle` | M009, M045, M070, M074 | Lever tap |
| `fog_clear` | M010, M065, M075 | Fog area clears |
| `link_strain` | M011, M039, M048, M066 | Linked group bump (bump ઉપરાંત layer) |
| `wake_up` | M012, M073, M087 | 1st tap of 2-tap paths |
| `rotate` | M013, M034, M058, M079, M091 | Rotation anim start |
| `deflect` | M014, M052, M086 | Lane turns |
| `crack` / `break` | M016, M042, M067 | HP −1 / removed |
| `switch_click` | M018 | Switch toggle |
| `plate_press` / `plate_release` | M019, M055, M083 | Plate state |
| `inner_exit` | M020, M061 | Path exits into hole |
| `phase_shift` | M021, M096 | Path becomes ghost/solid |
| `patrol_step` | M025, M098 | Patrol moves (quiet, priority 5) |
| `gem_collect` | M026 | Gem collected |
| `grow` | M027, M047, M075 | Spreader / growth |
| `wrong_order` | M028, M072 | Out-of-order tap (plays instead of `locked_tap`) |
| `spawn` | M035 | Child path appears |
| `eat` | M036 | Food consumed |
| `mud_stop` | M037 | Path stops in mud |
| `jump` | M038 | Jump pad leap |
| `color_change` | M041, M059, M094 | Recolor |
| `guardian_hit` / `guardian_defeat` | M049, M098 | HP −1 / vanish (stinger) |
| `push_block` / `slide_block` | M053, M054 | Push / ice slide |
| `beam_on` / `beam_hit` | M084, M085, M089 | Beam toggles / receiver hit |
| `split` / `merge` | M093, M094 | Path split / paint mix |
| `board_rotate` | M079 | Whole board turn |
| `trail_fade` | M068 | Trail blocker disappears |
| `domino_chain` | M097 | Chain clear (sequenced 60 ms apart) |

નવું mechanic (Phase 3+) ઉમેરાય ત્યારે: પહેલાં existing event ID reuse કરો. નવું ID ત્યારે જ ઉમેરો જ્યારે player ને નવો અર્થ સમજાવવો જરૂરી હોય. નવું ID આ table માં add કરો.

### 5.3 Boosters
| Event ID | Trigger | Haptic |
|---|---|---|
| `booster_hint` | Hint glow appears | — |
| `booster_shield_on` | Shield activates | `lightImpact` |
| `booster_hammer` | Hammer impact frame | `mediumImpact` |
| `booster_locked` | Locked booster / empty inventory tap | `selectionClick` |
| `heart_refill` / `revive` | Heart Refill / ad revive granted | `mediumImpact` |

### 5.4 Rewards & meta
| Event ID | Trigger |
|---|---|
| `win_stinger` | Level Complete screen open (music ducks) |
| `star_1`, `star_2`, `star_3` | Each star lands (3 rising pitches) |
| `coins_fly` | Coins fly to wallet (throttled: max 1 per 80 ms, max 8 per burst) |
| `coins_total` | Wallet count-up end |
| `gift_open` / `chest_open` | Gift Box / Phase Chest open |
| `rush_start` / `rush_tick` / `rush_end` | Coin Rush (`rush_tick` only last 5 sec) |
| `spin_start` / `spin_tick` / `spin_win` / `spin_jackpot` | Lucky Spin (tick per segment, throttled ≥ 40 ms) |
| `streak_claim` / `streak_day7` | Streak reward / Day 7 |
| `daily_unlock` | Daily Challenge unlock popup |
| `phase_complete` | Phase Complete screen (stinger) |
| `level_fail` | Level Failed screen (soft, never harsh) |
| `second_chance` | Second Chance popup open |

### 5.5 UI
| Event ID | Trigger |
|---|---|
| `ui_tap` | Any primary button |
| `ui_back` | Back / close |
| `ui_toggle` | Switch/toggle |
| `ui_popup_open` / `ui_popup_close` | Modal sheets |
| `ui_purchase_success` | IAP / coin purchase success |
| `ui_error` | Error dialog (gentle "bloop", never buzzer) |
| `ui_tab` | Shop / map tab change |

### 5.6 Music tracks
| Track ID | Where | Notes |
|---|---|---|
| `music_home` | Home, Shop, Settings | Calm, 70–90 BPM |
| `music_map` | Level Map | Same key as `music_home` for seamless crossfade |
| `music_gameplay_t1` … `music_gameplay_t5` | Gameplay by tier (Phase 1) | Tier ની biome mood. Minimal melody, puzzle focus |
| `music_gameplay_p2a`, `music_gameplay_p2b` | Phase 2 tiers | |
| `music_rush` | Coin Rush | Up-tempo, 30 s + tail |
| `music_finale` | L500 / L1000 Finale | Epic-cozy |
| `music_daily` | Daily Challenge | |

## 6. Mixer, Buses & Ducking

| Bus | Default volume | Contents |
|---|---|---|
| `master` | 1.0 | બધું |
| `music` | 0.55 | Music loops |
| `sfx` | 1.0 | Gameplay + mechanic SFX |
| `ui` | 0.7 | UI SFX |

| Situation | Behaviour |
|---|---|
| Win stinger / Phase complete | Music −8 dB for stinger length + 300 ms release |
| Second Chance popup, Level Failed | Music −6 dB |
| Coin Rush | Gameplay music crossfade (600 ms) → `music_rush` |
| **Full-screen ad (interstitial/rewarded) shown** | Music **pause** + SFX mute; ad close પછી resume (300 ms fade-in) |
| App background (`AppLifecycleState.paused`/`hidden`) | All audio pause; resume on `resumed` |
| Phone call / audio interruption | Pause; resume after interruption ends **only if** app foreground |
| Headphones unplugged (Android `ACTION_AUDIO_BECOMING_NOISY`) | Music pause, button tap પર resume |
| Screen transition | Music crossfade 600 ms when track changes; same track ⇒ no restart |

**Voice limits:** max **8** concurrent SFX voices (`AudioPool` total). Same event ID ⇒ min **50 ms** gap (spam tap પર stacking ટાળવા). Voice limit વખતે સૌથી ઓછી priority (§5 table) અને સૌથી જૂનો sound પહેલાં drop થાય.

**Variation:** Runtime pitch shift નહીં કરવો (Android/iOS પર `setPlaybackRate` અલગ રીતે વર્તે છે). Variation માટે **pre-rendered variants** (`_v1…_v3`) round-robin વાપરો. Combo pitch steps (`path_exit_combo`) પણ pre-rendered રાખો.

## 7. Settings & Persistence

| Setting (Settings screen) | Default | Save key (`settings`) |
|---|---|---|
| Sound Effects (SFX + UI) | On | `sound` |
| Music | On (auto-muted if other app audio playing at launch) | `music` |
| Haptics | On | `haptics` |

- Toggle બદલાય ⇒ તરત લાગુ (restart જરૂરી નથી), Hive માં persist.
- Device silent mode (iOS ringer switch / Android ringer silent) ⇒ SFX અને music બંને silent (`respectSilence`). Haptics settings પ્રમાણે ચાલુ રહે.
- Volume sliders Phase 1 માં નથી, માત્ર on/off toggles (simple UI). Phase 2 માં optional.

## 8. Implementation (Dart)

```dart
// app/lib/services/audio/audio_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

enum AudioBus { sfx, ui }

class SoundTheme {
  SoundTheme(this.sfx, this.music);

  /// eventId -> asset paths relative to `assets/` (variants in round-robin order)
  final Map<String, List<String>> sfx;
  final Map<String, String> music;

  static Future<SoundTheme> load() async {
    final raw = await rootBundle.loadString('assets/audio/theme.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final sfx = (json['sfx'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, (v as List<dynamic>).cast<String>()),
    );
    final music = (json['music'] as Map<String, dynamic>).cast<String, String>();
    return SoundTheme(sfx, music);
  }
}

class AudioService {
  AudioService(this._theme);

  final SoundTheme _theme;
  final Map<String, List<AudioPool>> _pools = {};
  final Map<String, int> _nextVariant = {};
  final Map<String, DateTime> _lastPlayed = {};

  bool sfxEnabled = true;
  bool _muted = false; // ads / background
  static const Duration _minGap = Duration(milliseconds: 50);

  /// Preload gameplay SFX before the board appears (called from LevelLoad).
  Future<void> preload(Iterable<String> eventIds) async {
    for (final id in eventIds) {
      if (_pools.containsKey(id)) continue;
      final files = _theme.sfx[id];
      if (files == null || files.isEmpty) continue; // missing mapping is caught by CI check (§10)
      _pools[id] = [
        for (final f in files)
          await AudioPool.createFromAsset(path: f, maxPlayers: 2),
      ];
    }
  }

  void play(String eventId, {AudioBus bus = AudioBus.sfx}) {
    if (!sfxEnabled || _muted) return;
    final now = DateTime.now();
    final last = _lastPlayed[eventId];
    if (last != null && now.difference(last) < _minGap) return;
    final variants = _pools[eventId];
    if (variants == null || variants.isEmpty) return;
    _lastPlayed[eventId] = now;
    final i = (_nextVariant[eventId] ?? 0) % variants.length;
    _nextVariant[eventId] = i + 1;
    final volume = bus == AudioBus.ui ? 0.7 : 1.0;
    unawaited(variants[i].start(volume: volume));
  }

  void setMuted(bool muted) => _muted = muted;

  Future<void> dispose() async {
    for (final list in _pools.values) {
      for (final pool in list) {
        await pool.dispose();
      }
    }
    _pools.clear();
  }
}
```

`theme.json` example (Snakes):
```json
{
  "sfx": {
    "path_exit": ["audio/sfx/path_exit_v1.wav", "audio/sfx/path_exit_v2.wav", "audio/sfx/path_exit_v3.wav"],
    "bump": ["audio/sfx/bump_v1.wav", "audio/sfx/bump_v2.wav"],
    "locked_tap": ["audio/sfx/locked_tap.wav"]
  },
  "music": {
    "music_home": "audio/music/music_home.m4a",
    "music_gameplay_t1": "audio/music/music_gameplay_t1.m4a"
  }
}
```

**Rules:**
- `AudioService` ને `AppLifecycleListener` (Flutter 3.13+) થી pause/resume કરો. Ads service `onAdShowedFullScreenContent` ⇒ `setMuted(true)` + music pause, `onAdDismissedFullScreenContent` ⇒ restore.
- Level load વખતે માત્ર તે level માં વપરાતા mechanics ના SFX preload કરો (level JSON ના `mechanics[].type` ⇒ event IDs map). Core + UI SFX app start પર preload.
- Audio failure (asset missing, decoder error) ⇒ game **ક્યારેય crash ન થાય**. Exception catch કરીને [LOGGING doc](./LOGGING_AND_ERROR_TRACKING.md) ના `E-AUD-*` code સાથે log કરો, અને એ sound skip કરો.
- `HapticFeedback` calls `HapticService` માં રાખો, જે `settings.haptics` check કરે. SFX અને haptic એક જ frame પર trigger થાય.

## 9. Game-wise Sound Design (theme mapping)

Asset files event IDs પ્રમાણે નામવાળી રહે (`path_exit_v1.wav`), પણ **અવાજ** theme પ્રમાણે અલગ હોય. Sound designer માટે brief:

| Event ID | 🐍 Snakes Slither | 🧶 Yarn Unravel | 🚂 Toy Trains | 🐜 Ants & Bees |
|---|---|---|---|---|
| `path_tap` | Soft scale rustle | Yarn tug "fwp" | Wooden click + tiny toot | Tiny antenna tick (ant) / wing flick (bee) |
| `path_exit` | Slithery "swish" + cute pop | Thread unravel "zzzip-fwip" | Toot-toot + wooden wheels roll | March pitter-patter (ant) / soft buzz-away (bee) — **2 sub-sets: `path_exit_ground`, `path_exit_air`** |
| `bump` | Soft "boink" on snout | Thread snag "twang" (damped) | Buffer "clack" | Head "bonk" (tiny, cute) |
| `locked_tap` | Sleepy "hmm-mm" | Muted thread pluck | Wooden knock | Tiny "tsk" chirp |
| `heart_lost` | Leaf heart flutter-pop | Soft fabric rip | Wooden heart crack | Petal fall |
| `shield_absorb` | Shell "clink" | Thimble "ding" | Cowcatcher metal ring | Royal chime |
| `booster_hint` | Firefly sparkle | Needle glint shimmer | Signal bell "ding-ding" | Nectar drip shimmer |
| `booster_hammer` | Stone smash (cartoon) | Golden scissors snip | Crane lift + clank | Leaf-blower whoosh |
| `gate_open` | Flower bud bloom | Eyelet pop | Level-crossing bell + barrier lift | Petal gate open |
| `lock_open` | Bamboo cage creak | Clasp click | Ticket punch + barrier | Thorn lock untwist |
| `portal_whoosh` | Burrow "fwump" | Pompom tunnel puff | Tunnel echo whoosh | Burrow tunnel whoosh |
| `guardian_defeat` | Mongoose "poof" + cheer | Pincushion stuffing poof | Clock-tower chime + cheer | Spider scurries away + cheer |
| `win_stinger` | Jungle marimba flourish | Music-box + kitten purr | Toy whistle + music-box | Garden chimes + bee hum |
| `coins_fly` | Soft coin tinkle | Button-coin tinkle | Coin clink on wood | Honey-coin drip tinkle |
| Music mood | Marimba, kalimba, soft jungle ambience | Lo-fi acoustic, music box, crackling fireplace bed | Wooden xylophone, music-box, light ragtime | Acoustic guitar, flute, birdsong bed |

- **Game 4 extra rule:** ants અને bees ના sounds હંમેશા અલગ હોય (`path_exit_ground` vs `path_exit_air`, `bump` ના ground/air variants). જેથી player ને layer નો તફાવત અવાજથી પણ સમજાય.
- **Game 3:** `path_exit` દરમિયાન trains ની લંબાઈ પ્રમાણે wheel-roll loop **ન** વગાડો. 1 short sample જ, જેથી 40 trains ના board પર અવાજનો ઢગલો ન થાય.
- **Game 2:** "twang" sounds high-pitched તીખા ન હોવા જોઈએ (≤ 3 kHz dominant).

## 10. CI & Validation

`tools/audio_check` (Dart CLI, PR પર ચાલે):
1. `theme.json` માં §5 ના **દરેક required event ID** માટે ≥ 1 file હોય. Missing ⇒ PR fail.
2. દરેક file exist કરે, format/spec §4 મુજબ હોય (WAV mono 16-bit 44.1k, length ≤ 0.8 s, stingers ≤ 2.5 s). Music `.m4a`.
3. Size limits અને total budget (≤ 10 MB) check.
4. `CREDITS.md` માં દરેક file ની entry હોય.
5. Level JSON ના દરેક mechanic type નો event mapping હોય.

## 11. QA Checklist (status: Not run)

| ID | Test | Expected | Status |
|---|---|---|---|
| AUD-01 | Tap path on mid-tier Android (Galaxy A14 class) & iPhone 11; measure tap → sound with 240 fps video | ≤ 50 ms | Not run |
| AUD-02 | Bump timing | Sound on contact frame (± 1 frame), not on tap | Not run |
| AUD-03 | Spam-tap 10 taps/sec for 10 s | No crackle, no stacking > 8 voices, no crash, no memory growth | Not run |
| AUD-04 | Sound toggle off | No SFX/UI sounds; music unaffected | Not run |
| AUD-05 | Music toggle off/on | Stops / resumes with fade; persists after restart | Not run |
| AUD-06 | Haptics toggle off | No haptic calls | Not run |
| AUD-07 | iOS silent switch on | Silent, haptics per setting | Not run |
| AUD-08 | Android ringer silent | Silent | Not run |
| AUD-09 | Spotify playing, launch game | Game music muted, SFX play, Spotify keeps playing | Not run |
| AUD-10 | Interstitial / rewarded ad | Game audio paused during ad, restored after | Not run |
| AUD-11 | App background → foreground | Audio pauses / resumes, no double music | Not run |
| AUD-12 | Incoming call during level | Audio pauses; resumes after call only in foreground | Not run |
| AUD-13 | Headphones unplug (Android) | Music pauses | Not run |
| AUD-14 | Screen transitions Home ↔ Map ↔ Gameplay | Crossfade, no gap/restart for same track | Not run |
| AUD-15 | Music loop 10 min | No audible gap/click at loop point | Not run |
| AUD-16 | Coin Rush | Music switches, `rush_tick` only last 5 s, restores after | Not run |
| AUD-17 | Win screen | Music ducks for stinger, stars rise in pitch, coins throttled | Not run |
| AUD-18 | Every mechanic intro level (L11…L491, L511…L991) | Mechanic event sounds play at correct moment | Not run |
| AUD-19 | Delete one SFX asset in debug build | No crash; `E-AUD-001` logged; game continues | Not run |
| AUD-20 | Low-end device (2 GB RAM) | Audio memory ≤ 15 MB; no frame drops on sound trigger | Not run |
| AUD-21 | Accessibility: play full level muted | Every audio cue has visible equivalent | Not run |
| AUD-22 | `tools/audio_check` on CI | Passes for all 4 games | Not run |
| AUD-23 | Game 4 | Ant vs bee exit/bump sounds distinguishable | Not run |
| AUD-24 | Licensing | Every file listed in `CREDITS.md` with valid license | Not run |
