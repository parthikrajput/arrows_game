# Performance Optimization (ચારેય games)

> Game-wise copy for **Yarn Unravel** (`game_2_yarn_unravel`). This file lives in this game folder and is the version used here. The same document exists in the other three game folders; when a shared rule or number changes, update all four copies. Links to other games point to the sibling game folders.

> Mobile devices પર, ખાસ કરીને 2 GB RAM વાળા low-tier Android phones પર, game smooth ચાલે તે માટેના નિયમો. આ doc ચારેય games (Snakes, Yarn, Trains, Ants & Bees) ને લાગુ પડે છે, કારણ કે ચારેય એક જ `puzzle_core` engine અને એક જ rendering approach વાપરે છે.

**Related docs:** [SHARED_CORE_STANDARD.md §13](./SHARED_CORE_STANDARD.md#13-shared-tech-stack-ચારેય-games) (stack + base budget) · [SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) (audio memory/latency) · [LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) (`W-PERF-` codes, Firebase Performance)

**Precedence:** budget numbers માં ફરક દેખાય તો SHARED_CORE_STANDARD જીતે. આ doc તે numbers ને "કેવી રીતે મેળવવા" તે સમજાવે છે. Game folders ના `07_FRONTEND_IMPLEMENTATION_AND_QA.md` / `06_FRONTEND_AND_QA_PHASE_2.md` માં game-specific budgets છે, અને તે આ doc થી વધુ કડક હોઈ શકે, ઢીલા નહીં.

---

## 1. Goals અને સૌથી મહત્વની 5 વાતો

આપણી games **turn-based** છે: player tap કરે, એક path બહાર જાય, પછી board સ્થિર. એટલે મોટાભાગનો સમય screen પર કંઈ હલતું નથી. Performance નો સૌથી મોટો ફાયદો અહીંથી જ આવે છે.

1. **કંઈ હલતું ન હોય ત્યારે frame જ ન બનાવો.** `Ticker` માત્ર animation ચાલે ત્યારે ચાલુ. Idle board = 0 frames = battery બચે, phone ગરમ ન થાય. ([§4.1](#41-on-demand-ticker-સૌથી-મહત્વનો-નિયમ))
2. **Board ના બે layers:** static layer (grid, walls, સ્થિર paths, obstacles) એક વાર `ui.Picture` માં record. દરેક frame માં ફક્ત હલતો path paint થાય. ([§4.2](#42-static-layer-cache-picturerecorder))
3. **ભારે કામ main isolate પર નહીં:** solver, generator, મોટી JSON decode અને sync payload `Isolate.run` માં. ([§6](#6-cpu-work-isolates-અને-io))
4. **Startup પર ફક્ત જરૂરી વસ્તુ:** Firebase core, error hooks, save data. Ads, Remote Config fetch, audio preload, leaderboards પહેલા frame પછી. ([§8](#8-app-startup))
5. **Low-tier device પર માપો, flagship પર નહીં.** દરેક release પહેલાં Redmi 9A class device પર profile build થી measurement. ([§12](#12-measurement-tools-અને-ci))

## 2. Performance Budgets

| Metric | Budget | ક્યાં માપવું |
|---|---|---|
| Gameplay frame rate | **60 fps** low-tier (2 GB RAM, Redmi 9A class) with 30 paths. **120 fps** ProMotion iOS / 120 Hz Android | `FrameTiming` ([§12.2](#122-in-app-frame-monitor-frametiming)) |
| Raster time p95 | **< 8 ms** mid-tier | `FrameTiming.rasterDuration` |
| Janky frames (build અથવા raster > frame budget) | **< 1%** gameplay દરમિયાન (target). **> 5% ⇒ `W-PERF-001`** log | `FrameMonitor` |
| Static layer rebuild | ≤ 2 ms mid-tier (Phase 2 બોર્ડ 14×14: ≤ 3 ms), Move દીઠ એક વાર | Timeline event `static_rebuild` |
| Tap → પહેલો visual response | ≤ 50 ms (3 frames @ 60 Hz). > 200 ms ⇒ slow-input log ([LOGGING §tap](./LOGGING_AND_ERROR_TRACKING.md)) | `InputTrace` |
| Hit-test (tap કયા path પર) | ≤ 0.2 ms | Unit benchmark |
| Hint solver | Isolate, 50 ms / 50k nodes cap (standard §12) | Perf trace `hint_solve` |
| Level load (Play tap → board interactive) | ≤ 150 ms target. **> 1.5 s ⇒ `W-PERF-002`** | Perf trace `level_load` |
| Phase 3+ on-device level generation | ≤ 150 ms low-tier, isolate માં, next level prefetch | Perf trace `level_generate` |
| Cold start → Home first frame (= interactive) | ≤ 400 ms high, ≤ 600 ms mid, ≤ 1,200 ms low-tier. No loading screen ([SPLASH_AND_INSTANT_LAUNCH §2](./SPLASH_AND_INSTANT_LAUNCH.md#2-launch-budgets)) | Macrobenchmark `StartupTimingMetric`, perf trace `app_start` |
| Peak memory (RSS) | ≤ 250 MB low-tier (Phase 1), ≤ 280 MB (Phase 2, album સહિત) | DevTools Memory, Android `dumpsys meminfo` |
| Download size | ≤ 60 MB (AAB per-device download / App Store thinned) | Play Console, App Store Connect |
| Audio assets | ≤ 10 MB per game ([SOUND §assets](./SOUND_EFFECTS_IMPLEMENTATION.md)) | `tools/audio_check` |
| Battery | 30 min gameplay ⇒ ≤ 8% drop mid-tier, thermal throttling નહીં | Manual test ([PERF-20](#14-qa-checklist)) |
| Idle board CPU | Ticker stop પછી ~0% app CPU (Android Studio profiler) | Manual test |

**Frame budget:** 60 Hz = 16.6 ms, 90 Hz = 11.1 ms, 120 Hz = 8.3 ms. Build (UI thread) અને raster (GPU thread) બંને **અલગ-અલગ** આ budget માં રહેવા જોઈએ.

## 3. Device Tiers અને Adaptive Quality

### 3.1 Device matrix
Device matrix દરેક game ના frontend doc માં છે (Low: Redmi 9A, Galaxy A03 Core · Mid: Redmi Note 12, Galaxy A34 · High: Pixel 8, Galaxy S23 · iOS: iPhone SE 2nd gen, iPhone 13, iPhone 15 Pro · Tablet: iPad 9th gen, Galaxy Tab A8). Performance sign-off **Low tier** પર જ થાય.

### 3.2 Tier detection (first launch)
Tier એક વાર નક્કી થાય અને Hive `settings` box માં save થાય. Rule:

| Platform | Low | Mid | High |
|---|---|---|---|
| Android | `ActivityManager.isLowRamDevice()` = true **અથવા** total RAM ≤ 3 GB | 3–6 GB | > 6 GB |
| iOS | — (support કરેલા બધા iPhones ઓછામાં ઓછા Mid) | physical memory ≤ 3 GB | > 3 GB |

- RAM native side થી એક નાના `MethodChannel('perf/device')` દ્વારા: Android `ActivityManager.MemoryInfo.totalMem` + `isLowRamDevice()`, iOS `ProcessInfo.processInfo.physicalMemory`. નવું third-party package ઉમેરવાની જરૂર નથી.
- **Runtime demotion:** પહેલા 3 completed levels માં janky frames > 5% આવે તો tier એક step નીચે (High → Mid → Low), અને `W-PERF-001` સાથે `tier_demoted` analytics event. Promotion automatic નહીં.
- **Remote Config override:** `perf_tier_overrides` (JSON: `{"<manufacturer>/<model>": "low"}`). ખરાબ devices field data થી ખબર પડે ત્યારે release વગર fix.

### 3.3 Quality profile (tier મુજબ)
Gameplay **rules** ક્યારેય tier થી બદલાય નહીં. ફક્ત દેખાવ (visual polish) બદલાય.

| Feature | Low | Mid | High |
|---|---|---|---|
| Particles (win confetti, exit sparkle) max live | 30 | 80 | 150 |
| Background ambient animation (પાંદડાં, વાદળ, steam) | Off (static image) | On, 30 fps update | On |
| Path idle animation (સાપનું breathing, દોરાનો wobble, ant wiggle) | Off | ફક્ત tap કરેલા path પર | બધા paths, staggered |
| Exit trail effect | Simple fade | On | On |
| Screen shake (bump) | Off (ફક્ત haptic + red flash) | On, 4 dp | On, 6 dp |
| Level Map parallax | Off | On | On |
| Sprite atlas scale | 2.0x atlas (3.0x screens પર પણ) | Device DPR | Device DPR |
| `imageCache.maximumSizeBytes` | 48 MB | 96 MB | 160 MB |
| Shadows | Pre-baked sprite માં (બધા tiers માં) | same | same |

### 3.4 Settings: "Battery Saver" toggle
Settings screen માં **Battery Saver** toggle (default Off). On ⇒ tier ગમે તે હોય, Low quality profile વપરાય. Battery 20% થી નીચે હોય ત્યારે એક વાર soft suggestion toast ("Battery Saver ચાલુ કરશો?"), ફરી પૂછવું નહીં. દરેક game ના `06_UI_UX_SCREENS.md` Settings section માં આ toggle ઉમેરવો.

## 4. Rendering Rules (`CustomPainter` + `Ticker`)

### 4.1 On-demand Ticker (સૌથી મહત્વનો નિયમ)
Board માટે **એક જ** `Ticker`. Animation queue ખાલી થાય એટલે ticker stop. દરેક path માટે અલગ `AnimationController` નહીં.

```dart
/// Board ની બધી animations એક જ clock થી ચાલે. કંઈ હલતું ન હોય તો ticker બંધ.
class BoardAnimator extends ChangeNotifier {
  BoardAnimator(TickerProvider vsync) {
    _ticker = vsync.createTicker(_onTick);
  }

  late final Ticker _ticker;
  final List<BoardAnimation> _active = [];
  Duration _last = Duration.zero;

  bool get isAnimating => _active.isNotEmpty;

  void add(BoardAnimation anim) {
    _active.add(anim);
    if (!_ticker.isActive) {
      _last = Duration.zero; // Ticker.start() elapsed ને 0 થી ગણે છે
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _last;
    _last = elapsed;
    _active.removeWhere((a) => a.advance(dt)); // true = animation પૂરી
    notifyListeners(); // ફક્ત painter repaint થાય, widget rebuild નહીં
    if (_active.isEmpty) _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
```

- `TickerProviderStateMixin` વાળો State ticker આપે, એટલે app background માં જાય કે route ઢંકાય ત્યારે `TickerMode` ticker ને આપોઆપ mute કરે.
- Animation ની ગણતરી `dt` પરથી કરો, frame count પરથી નહીં. એટલે 60 Hz અને 120 Hz બંને પર speed સરખી રહે.
- `dt` ને 50 ms પર clamp કરો (`dt > 50 ms ⇒ 50 ms`), જેથી lag પછી path એક જ frame માં કૂદી ન જાય.

### 4.2 Static layer cache (`PictureRecorder`)

```dart
/// Static board (grid, walls, સ્થિર paths, obstacles) Move દીઠ એક જ વાર record થાય.
class StaticLayerCache {
  ui.Picture? _picture;
  int _version = -1;
  Size _size = Size.zero;

  ui.Picture obtain(BoardSnapshot board, Size size, BoardTheme theme) {
    final cached = _picture;
    if (cached != null && _version == board.staticVersion && _size == size) {
      return cached;
    }
    cached?.dispose();
    final recorder = ui.PictureRecorder();
    paintStaticLayer(Canvas(recorder), board, size, theme);
    _version = board.staticVersion;
    _size = size;
    return _picture = recorder.endRecording();
  }

  void dispose() => _picture?.dispose();
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.animator, this.cache, this.board, this.theme)
      : super(repaint: animator);

  final BoardAnimator animator;
  final StaticLayerCache cache;
  final BoardSnapshot board;
  final BoardTheme theme;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(cache.obtain(board, size, theme));
    paintMovingPaths(canvas, animator, theme); // ફક્ત હલતા paths + preview
  }

  @override
  bool shouldRepaint(BoardPainter old) =>
      old.board.staticVersion != board.staticVersion || old.theme != theme;
}
```

- `board.staticVersion` `puzzle_core` માં દરેક Move commit પર +1 થાય (path exit, obstacle state change, Hammer).
- Exit animation શરૂ થાય ત્યારે એ path static layer માંથી કાઢીને moving layer માં જાય. એ ક્ષણે એક વાર static rebuild થાય.
- Board ને `RepaintBoundary` માં રાખો, જેથી HUD (coins, hearts, Moves) બદલાય ત્યારે board raster ફરી ન થાય.
- **Phase 2 zoom/pan:** static picture board-space માં record થાય. Camera બદલાય ત્યારે ફક્ત `canvas.transform(matrix)` બદલાય, picture rebuild નહીં. 3 layers (Game 4: ground / air / canopy) હોય તો દરેક layer નું અલગ picture, અને ફક્ત બદલાયેલું layer rebuild.

### 4.3 Paint rules (Do / Don't)

| Do | Don't |
|---|---|
| Path geometry (`Path` objects) cache કરો, path બદલાય ત્યારે જ ફરી બનાવો | દરેક frame માં `Path()` નવેસરથી બનાવવું |
| ઘણા નાના sprites (snake segments, ants, wagons, beads) માટે `canvas.drawAtlas` / `drawRawAtlas` એક batch માં | દરેક sprite માટે અલગ `drawImageRect` |
| Shadows અને glow sprite માં pre-baked | Per-frame `MaskFilter.blur`, `ImageFilter.blur`, `BackdropFilter` |
| Transparency માટે `Paint()..color = c.withValues(alpha: a)` | Animated content પર `Opacity` widget / `saveLayer` (deprecated `withOpacity` પણ નહીં) |
| Rectangular clip (`clipRect`) | Gameplay માં `clipPath` અને anti-aliased complex clips |
| `Paint`, `TextPainter` objects reuse કરો (fields તરીકે) | `paint()` માં દર frame `Paint()` / `TextPainter.layout()` |
| Moves counter જેવા numbers માટે 0–9 digits ના pre-laid `TextPainter` cache | દરેક frame text layout |
| Gradient shader (`ui.Gradient`) એક વાર બનાવીને reuse | દર frame નવો shader |
| Popups ના blur background માટે static screenshot (`toImage`) blur એક વાર | Gameplay ઉપર live `BackdropFilter` |

### 4.4 Impeller નોંધ
- Impeller માં shader compilation jank નથી, એટલે SkSL warm-up ની જરૂર નથી. પણ **image decode jank** હજી થાય છે, તેથી next screen ની images `precacheImage` થી પહેલેથી decode કરો ([§7.1](#71-images-અને-atlases)).
- Android પર Impeller Vulkan વાપરે છે. Vulkan ન હોય તેવા devices પર Flutter OpenGL ES backend પર fallback કરે છે. Low-tier matrix માં ઓછામાં ઓછું એક device આ fallback path પર ચકાસો ([PERF-04](#14-qa-checklist)).

## 5. Widget Tree અને State (`flutter_bloc`)

- **Board widget tree rebuild નહીં થાય.** `GameBloc` નો નવો state આવે ત્યારે `BoardSnapshot` painter ને આપો. Board ઉપરનો `BlocBuilder` `buildWhen: (a, b) => a.board.staticVersion != b.board.staticVersion` વાપરે.
- HUD ના દરેક ભાગ (hearts, coins, Moves, boosters bar) અલગ `BlocSelector` થી. Coins બદલાય ત્યારે hearts widget rebuild ન થાય.
- શક્ય હોય ત્યાં `const` constructors. Flutter DevTools "Rebuild counts" માં gameplay દરમિયાન દરેક tap પર HUD સિવાય કોઈ widget rebuild ન દેખાવું જોઈએ.
- **Level Map (500 → 10,000 levels):** ક્યારેય બધા nodes એક સાથે build નહીં.
  - `CustomScrollView` + `SliverList.builder` (અથવા `ListView.builder`) અને fixed item extent (દા.ત. 1 chunk = 10 levels, `itemExtent` fixed).
  - દરેક chunk નો રસ્તો (nodes વચ્ચેની line) એક `CustomPainter` માં. 10 અલગ widgets નહીં.
  - `cacheExtent` ≈ 1 screen. Node art (lock, stars) એક atlas માંથી.
  - Map ખૂલે ત્યારે current level પર સીધો `jumpTo`, animate કરીને 900 levels scroll નહીં.
- Layout માં `IntrinsicHeight` / `IntrinsicWidth` અને nested `Wrap` ટાળો. Shop grid માં fixed `SliverGridDelegateWithFixedCrossAxisCount`.
- Popups (Win, Revive, Shop) ની entry animation `FadeTransition` / `ScaleTransition` થી, `AnimatedOpacity` કે `Opacity` થી નહીં.

## 6. CPU Work, Isolates અને I/O

| કામ | ક્યાં ચાલે | નોંધ |
|---|---|---|
| Rule step (tap → result) | Main isolate | `puzzle_core` step O(paths) છે, ≤ 1 ms. Synchronous રાખો, isolate overhead ન ઉમેરો |
| Hint solver | `Isolate.run` | 50 ms / 50k nodes cap. Fail ⇒ themed fallback toast, booster consume નહીં |
| Phase 3+ level generation | `Isolate.run` | Win screen દેખાય ત્યારે **next level prefetch** |
| Level pack decode (`phase_2.json.gz`, > 50 KB JSON) | `Isolate.run` | Per-level result memory માં cache (LRU 20) |
| Cloud sync payload build / parse | `Isolate.run` | Phase 2 sync batch ([05_OFFLINE_AND_CLOUD_SYNC](../game_1_snakes_slither/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md)) |
| Save write (Hive) | Main isolate, async | Level end, booster use અને `AppLifecycleState.paused` પર. Tap દીઠ કે frame દીઠ write નહીં |
| Log file flush | Async, 5 s interval | [LOGGING](./LOGGING_AND_ERROR_TRACKING.md) `LogFileSink` |

```dart
// Win screen ખૂલે ત્યારે જ next level તૈયાર થવા લાગે.
Future<LevelData> prefetchNext(int levelNo, int seed) {
  return Isolate.run(() => LevelGenerator(seed: seed).build(levelNo));
}
```

- `Isolate.run` ના closure માં `BuildContext`, `Bloc` કે platform channel objects capture ન કરો. ફક્ત plain data (seed, level number, bytes) મોકલો.
- **Hive:** startup પર ફક્ત `settings` અને `progress` boxes open. History / album / logs જેવા મોટા boxes `LazyBox` તરીકે અને જરૂર પડે ત્યારે open.
- Main isolate પર synchronous file I/O (`readAsStringSync` વગેરે) ક્યારેય નહીં.

## 7. Assets અને Memory

### 7.1 Images અને atlases
- **Format:** UI art માટે WebP (alpha સાથે). Sprite atlases માટે WebP lossless અથવા PNG. Atlas size ≤ 2048 × 2048.
- **Decode at display size:** મોટી images માટે `ResizeImage` / `Image.asset(cacheWidth: ...)` વાપરો. Album thumbnails 256 px પર decode.
- **Precache:** Home પરથી Play દબાય ત્યારે gameplay atlas પહેલેથી decode થયેલું હોય. Win screen પર next theme/background `precacheImage`.
- **Dispose:** level છોડ્યા પછી level-specific `ui.Image` અને `ui.Picture` `dispose()` કરો. Cosmetic skins માં ફક્ત equipped skin નું atlas memory માં રહે.
- `PaintingBinding.instance.imageCache.maximumSizeBytes` tier મુજબ set કરો ([§3.3](#33-quality-profile-tier-મુજબ)). Android `onTrimMemory` / iOS memory warning (`didHaveMemoryPressure`) પર `imageCache.clear()` અને `W-PERF-003` log.

### 7.2 Audio
- SFX `AudioPool` માં ફક્ત current screen ના cues preload. Music stream થાય, આખું memory માં load નહીં. વિગત: [SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md).
- Low tier પર simultaneous voices 8 થી ઘટાડીને 6.

### 7.3 Fonts
- ફક્ત વપરાતા weights bundle કરો (દા.ત. Regular + Bold).
- Gujarati અને Devanagari fonts subset કરતી વખતે OpenType layout features રાખવા ફરજિયાત (`pyftsubset ... --layout-features='*'`). નહીંતર જોડાક્ષરો (conjuncts) તૂટી જાય. Subset પછી ત્રણેય locales ના golden tests ફરી ચલાવો.

### 7.4 App size
- Android **AAB** (Play per-device APK બનાવે). Release build `--obfuscate --split-debug-info` સાથે (symbols Crashlytics પર upload, [LOGGING](./LOGGING_AND_ERROR_TRACKING.md)).
- Material icons tree-shaking ચાલુ (default) રાખો. `cupertino_icons` વપરાતું ન હોય તો કાઢો.
- Phase 2+ cosmetic packs અને album art **Firebase Storage** પરથી on-demand download, app bundle માં નહીં.
- Phase 3+ levels device પર seed થી generate થાય, એટલે level files ઉમેરાતી નથી. ફક્ત `phase_N_meta.bin` (નાની) download થાય.

## 8. App Startup

Full launch pipeline (native Kotlin splash, engine pre-warm, intro, budgets, QA): [SPLASH_AND_INSTANT_LAUNCH.md](./SPLASH_AND_INSTANT_LAUNCH.md). `main()` ત્યાં §5.1 માં છે: Firebase init **await નથી થતું** (errors buffer થાય), ફક્ત Home boxes ખૂલે, પછી તરત `runApp`. Loading screen નથી.

`DeferredInit.run()` નો ક્રમ (પહેલો frame પછી; ભારે ભાગ intro પૂરું થયા પછી, SPLASH §5.2):
1. UMP consent info update (અને જરૂર હોય તો form), પછી જ `MobileAds.instance.initialize()` અને પહેલું interstitial preload. Consent Home render ને block ન કરે.
2. Remote Config: છેલ્લે activate થયેલી values તરત વાપરો. `fetchAndActivate()` background માં, અને નવી values **next session** થી લાગુ (mid-session tuning બદલાય નહીં).
3. Home ના audio cues + music preload.
4. `games_services` sign-in (silent).
5. Current level data + gameplay atlas prefetch.

બીજા નિયમો:
- Native launch screen (Android 12 SplashScreen API via `core-splashscreen`, iOS `LaunchScreen.storyboard`) game ના `splash_bg` color માં, અને Flutter નો પહેલો frame બરાબર એવો જ (SPLASH §5.10), જેથી flash ન દેખાય.
- Startup પર network call ની રાહ ક્યારેય નહીં. Offline માં પણ એ જ budgets (SPLASH §2).
- `--trace-startup` થી `start_up_info.json` માં "time to first frame" release candidate દીઠ record કરો.

## 9. Animations અને Effects

- બધી board animations [§4.1](#41-on-demand-ticker-સૌથી-મહત્વનો-નિયમ) ના `BoardAnimator` પર. UI widgets (buttons, popups) માં Flutter ના implicit/explicit animations ચાલે, પણ gameplay દરમિયાન screen પર એક સાથે ≤ 3 UI animations.
- **Particles:** object pool (start પર allocate, પછી reuse). Max count tier મુજબ ([§3.3](#33-quality-profile-tier-મુજબ)). એક `drawAtlas` call માં બધા particles.
- Infinite / looping animations (pulsing Play button, idle sway) ફક્ત ત્યારે ચાલે જ્યારે તે screen visible હોય. Gameplay screen પર Home નું loop ચાલુ ન રહે.
- Coin fly-to-counter animation: max 10 coin sprites. 500 coins મળે તો પણ 10 sprites અને number tween.
- Haptics (`HapticFeedback`) cheap છે, પણ એક frame માં એક થી વધુ haptic call નહીં.

## 10. Ads, IAP, Firebase અને Network

- **Ads:** interstitial / rewarded **gameplay ચાલુ હોય ત્યારે load ન થાય.** Load window: Win screen, Home, Level Map. Ad show થાય ત્યારે board ticker અને music pause ([SOUND](./SOUND_EFFECTS_IMPLEMENTATION.md) ducking rules).
- Gameplay screen પર banner કે બીજા platform views (`AdWidget`, WebView) નહીં. Platform views compositing cost વધારે છે.
- **IAP:** store product query Shop ખૂલે ત્યારે, startup પર નહીં (purchase stream listener startup પર જ, pending purchases માટે).
- **Analytics:** events level start / end / booster / purchase જેવા milestones પર. Tap દીઠ analytics event નહીં (tap trace local ring buffer માં રહે, [LOGGING](./LOGGING_AND_ERROR_TRACKING.md)).
- **Firebase Performance custom traces:** `app_start`, `level_load`, `level_generate`, `hint_solve`, `sync_push`. Attributes: `tier`, `phase`, `game`.
- **Cloud sync (Phase 2):** level end પર batch, Move દીઠ નહીં. `connectivity_plus` listener offline થી online થાય ત્યારે queue flush.

## 11. Battery, Thermal અને Lifecycle

- Idle board પર ticker stop ([§4.1](#41-on-demand-ticker-સૌથી-મહત્વનો-નિયમ)). Wakelock package નહીં. Audio `stayAwake: false` ([SOUND](./SOUND_EFFECTS_IMPLEMENTATION.md)).
- `AppLifecycleState.inactive` / `paused`: ticker mute (TickerMode), music pause, save flush, log flush. `resumed` પર ફરી શરૂ. Coin Rush 30 s timer background માં pause રહે (standard મુજબ).
- Background ambient animations 30 fps update પર (Mid tier). 120 Hz device પર પણ ambient effects ને 120 Hz ની જરૂર નથી, એટલે તે દર બીજા/ચોથા tick પર જ update.
- Sustained 30 min play પછી device throttle થાય (fps ઘટે) તો [§3.2](#32-tier-detection-first-launch) runtime demotion લાગુ.

## 12. Measurement, Tools અને CI

### 12.1 Manual profiling
- Performance હંમેશાં **profile mode** માં માપો (`flutter run --profile`). Debug mode ના numbers અર્થ વગરના છે.
- DevTools: Performance view (frame chart, UI vs Raster), CPU profiler, Memory view (leaks: level 10 વાર open/close પછી memory baseline પર પાછી આવવી જોઈએ), "Track widget rebuilds".
- `debugProfilePaintsEnabled` / `debugProfileBuildsEnabled` ફક્ત local investigation માટે.
- Android: `adb shell dumpsys gfxinfo <package>` અને `dumpsys meminfo`. iOS: Xcode Instruments (Time Profiler, Allocations, Energy Log).

### 12.2 In-app frame monitor (`FrameTiming`)
Release builds માં પણ ચાલે. Level end પર summary Firebase Performance + logger ને જાય.

```dart
class FrameMonitor {
  int _frames = 0;
  int _janky = 0;
  final List<int> _rasterUs = [];
  late int _budgetUs;

  void start() {
    final hz = PlatformDispatcher.instance.views.first.display.refreshRate;
    _budgetUs = (1e6 / (hz > 0 ? hz : 60)).round();
    _frames = 0;
    _janky = 0;
    _rasterUs.clear();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      _frames++;
      final build = t.buildDuration.inMicroseconds;
      final raster = t.rasterDuration.inMicroseconds;
      if (build > _budgetUs || raster > _budgetUs) _janky++;
      if (_rasterUs.length < 5000) _rasterUs.add(raster);
    }
  }

  /// Level end પર call. Jank > 5% ⇒ W-PERF-001.
  FrameSummary stop() {
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    final sorted = [..._rasterUs]..sort();
    final p95 = sorted.isEmpty ? 0 : sorted[(sorted.length * 0.95).floor()];
    final jankPct = _frames == 0 ? 0.0 : _janky * 100 / _frames;
    if (jankPct > 5) {
      AppLogger.instance.log(LogLevel.warn, LogCat.perf, 'W-PERF-001', 'level jank',
          {'jank_pct': jankPct, 'raster_p95_us': p95, 'frames': _frames});
    }
    return FrameSummary(frames: _frames, jankPct: jankPct, rasterP95Us: p95);
  }
}
```

- Ticker idle હોય ત્યારે frames આવતા જ નથી, એટલે jank % ફક્ત હલતા frames પર ગણાય. આ સાચું માપ છે.
- Field data: Firebase Performance dashboard માં `tier` attribute મુજબ p95 raster અને jank %. Android પર slow/frozen frames Firebase આપોઆપ પણ માપે છે.

### 12.3 Automated perf tests (CI)
- `integration_test` ના `IntegrationTestWidgetsFlutterBinding.watchPerformance` થી scripted runs: L1 (FTUE), L250, L480 (30 paths), L1000 (Phase 2, 14×14, 40 paths), Level Map fling 0 → 500, Shop open/close × 20.
- **Profile mode** માં Firebase Test Lab ના physical devices પર (ઓછામાં ઓછા 1 low-tier Android + 1 iPhone) nightly અને દરેક release branch પર.
- Result JSON ને baseline સાથે સરખાવો. **p90 raster અથવા jank % માં > 10% regression ⇒ release blocked**, perf owner sign-off વગર merge નહીં.
- `puzzle_core` benchmarks (pure Dart, CI દરેક PR પર): rule step, hit-test, solver 50k nodes, generator per phase. Regression > 15% ⇒ PR warning.

## 13. Game-wise Notes

| Game | Hot spot | ઉપાય |
|---|---|---|
| **1 Snakes Slither** | દરેક સાપ ઘણા segments નો; slither animation બધા segments ખસેડે | Segments `drawRawAtlas` (`Float32List` transforms reuse); body curve per-frame ફક્ત moving snake માટે; tongue-flick preview એક જ sprite |
| **2 Yarn Unravel** | લાંબા curvy threads (bezier) અને મોટી stroke width | Thread `Path` cache; unravel દરમિયાન `PathMetric.extractPath` થી ફક્ત બાકી ભાગ; wool texture `ImageShader` એક વાર બનાવીને reuse; stroke અને fill બંને એક સાથે ન કરો |
| **3 Toy Trains** | Rails + wagons + Phase 2 beams/rotation | Rails static layer માં; wagons atlas; M079 board rotation વખતે static picture rotate કરો, rebuild નહીં; steam puff particles tier limit માં |
| **4 Ants & Bees** | 2–3 layers (ground / air / canopy), ઘણા નાના sprites | દરેક layer નું અલગ static picture; ants/bees એક atlas, એક `drawAtlas` per layer; bee shadow pre-baked; Low tier પર wing-flap 2 frames |

## 14. QA Checklist

| ID | Test | Expected | Status |
|---|---|---|---|
| PERF-01 | Low-tier (Redmi 9A class), 30-path T5 level, 2 min play | ≥ 60 fps, jank < 1%, no jank > 2 frames in a row | Not run |
| PERF-02 | Mid-tier raster p95 (L480) | < 8 ms | Not run |
| PERF-03 | 120 Hz devices (iPhone 15 Pro, Pixel 8) exit animation | 120 fps; animation speed 60 Hz device જેટલી જ | Not run |
| PERF-04 | Vulkan વગરનો Android device (GLES fallback) | Game render થાય, 60 fps | Not run |
| PERF-05 | Idle board 60 s (કોઈ tap નહીં) | DevTools માં 0 frames; app CPU ~0% | Not run |
| PERF-06 | Tap → visual response | ≤ 50 ms (high-speed video અથવા `InputTrace`) | Not run |
| PERF-07 | Static layer rebuild per Move (mid-tier) | ≤ 2 ms (Phase 2: ≤ 3 ms) | Not run |
| PERF-08 | HUD update (coins +50) | Board raster ફરી નહીં (DevTools repaint rainbow) | Not run |
| PERF-09 | Rebuild counts દરેક tap પર | HUD સિવાય કોઈ widget rebuild નહીં | Not run |
| PERF-10 | Level load L1 → L500, L1000 | ≤ 150 ms; ક્યારેય > 1.5 s નહીં | Not run |
| PERF-11 | Hint solver hardest level | ≤ 50 ms અથવા fallback toast; UI frames drop નહીં | Not run |
| PERF-12 | Phase 3 generator (low-tier) | ≤ 150 ms isolate માં; Win screen દરમિયાન prefetch | Not run |
| PERF-13 | Cold start (mid / low, offline સહિત) | Home first frame ≤ 600 ms / ≤ 1,200 ms (SPLASH SPL-02) | Not run |
| PERF-14 | Level Map fling 1 → 1,000 (Phase 2) | 60 fps, memory spike ≤ 30 MB | Not run |
| PERF-15 | Memory leak: 10 levels play + Home | Memory baseline ± 10 MB પર પાછી | Not run |
| PERF-16 | Peak memory low-tier (Phase 1 / Phase 2 album) | ≤ 250 MB / ≤ 280 MB | Not run |
| PERF-17 | Memory pressure simulation (Android `am send-trim-memory`) | `imageCache` clear, `W-PERF-003` log, crash નહીં | Not run |
| PERF-18 | Download size (Play / App Store) | ≤ 60 MB | Not run |
| PERF-19 | Win confetti on Low tier | ≤ 30 particles, no jank | Not run |
| PERF-20 | 30 min continuous play (mid-tier) | Battery drop ≤ 8%, thermal throttle નહીં | Not run |
| PERF-21 | Background → foreground 20 વાર | Ticker/music યોગ્ય pause-resume; Coin Rush timer pause | Not run |
| PERF-22 | Ad close પછી પહેલો frame | ≤ 100 ms, board state સાચો | Not run |
| PERF-23 | Battery Saver toggle On | Low quality profile તરત લાગુ; rules બદલાય નહીં | Not run |
| PERF-24 | Runtime demotion (forced jank via Remote Config test flag) | 3 levels પછી tier નીચે, `tier_demoted` event | Not run |
| PERF-25 | Gujarati / Hindi locale + text scale 2.0 | Layout jank નહીં, conjuncts સાચા (font subset) | Not run |
| PERF-26 | CI perf baseline compare | > 10% regression હોય તો pipeline fail | Not run |

## 15. Release Gate

Release candidate ત્યારે જ store પર જાય જ્યારે:
1. PERF-01, 02, 05, 10, 13, 16 **pass** (P0).
2. CI perf baseline compare માં regression નહીં ([§12.3](#123-automated-perf-tests-ci)).
3. Staged rollout (10%) ના પહેલા 48 કલાકમાં Firebase Performance પર low-tier `jank_pct` p75 < 5% અને `level_load` p95 < 1.5 s. નહીંતર rollout halt ([LOGGING runbook](./LOGGING_AND_ERROR_TRACKING.md)).
