# Logging, Error Tracking & Production Debugging Standard

> Game-wise copy for **Toy Trains** (`game_3_toy_trains`). This file lives in this game folder and is the version used here. The same document exists in the other three game folders; when a shared rule or number changes, update all four copies. Links to other games point to the sibling game folders.

> Deploy થયેલી ચારેય games માં errors, crashes અને "user એ tap કર્યું પણ કંઈ થયું નહીં / ખોટું થયું" પ્રકારના issues **capture, track અને debug** કરવા માટેના નિયમો: log levels, tap/input logging, error codes, deterministic replay, bug reports, privacy, dashboards, alerts અને debugging runbook.

**Related docs:** [SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) (§13 Tech, §14 Save, §15 Analytics) · [SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) (`E-AUD-*`) · દરેક game નું `phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md` (error-handling table આ doc ને follow કરે)

---

## 1. Goals (હેતુ)

1. **દરેક crash અને error** (Dart, Flutter framework, native, ANR) Firebase Crashlytics માં context સાથે પહોંચે: કયું level, કઈ screen, છેલ્લા taps કયા હતા.
2. **દરેક tap નો trace** હોય (device પર local, privacy-safe). Error આવે ત્યારે "error પહેલાં user એ શું કર્યું" તરત દેખાય.
3. **Silent issues** પકડાય: dead taps (tap નો કોઈ response નહીં), rage taps (frustration), slow input, stuck animations, invariant violations (દા.ત. hearts < 0).
4. Game engine deterministic છે, એટલે **user ની level session બરાબર replay** કરી શકાય: bug report મળે તો developer machine પર એ જ moves ફરી ચલાવીને bug reproduce કરી શકાય.
5. **Privacy first:** કોઈ PII નહીં, બાળકો (under-13) માટે વધારાના નિયંત્રણો.
6. Logging ને કારણે game ધીમી ન પડે: per-tap overhead **< 0.2 ms**, અને log કરતી વખતે error આવે તો game ક્યારેય crash ન થાય.

## 2. Tooling

| Need | Tool | Package |
|---|---|---|
| Crashes, non-fatals, breadcrumbs, custom keys | **Firebase Crashlytics** | `firebase_crashlytics` |
| Aggregated behaviour metrics (rage/dead taps, fail rates) | Firebase Analytics → BigQuery export | `firebase_analytics` |
| Performance traces (app start, level load, hint solver), slow/frozen frames | **Firebase Performance Monitoring** | `firebase_performance` |
| Remote log level / sampling switches | Firebase Remote Config | `firebase_remote_config` |
| Bug reports + replays upload | Cloud Firestore + Cloud Storage (Phase 1: Storage only via Callable Function) | `cloud_functions`, `firebase_storage` |
| Local structured log | `AppLogger` (in-house, §5) — ring buffer + rotating file | `path_provider` |
| Android ANR / native crashes | Crashlytics NDK + Play Console Android Vitals | `firebase_crashlytics` (NDK enabled) |

> Crashlytics, Analytics અને Performance ને "diagnostics" data તરીકે Play **Data safety** અને App Store **Privacy Nutrition Label** માં declare કરવું ફરજિયાત છે.

## 3. Log Levels & Routing

| Level | ઉપયોગ | Debug build | Release build |
|---|---|---|---|
| `trace` | Per-frame / very noisy (animation ticks) | console | **off** |
| `debug` | Taps, state transitions, ad loads | console + ring buffer | ring buffer only |
| `info` | Level start/win/fail, purchases, screen views | console + ring buffer | ring buffer + file |
| `warn` | Recoverable problems: ad no-fill, slow input, dead/rage tap, retry | + Crashlytics `log()` breadcrumb | ring buffer + file + Crashlytics breadcrumb |
| `error` | Handled exception, invariant violation, save/IAP failure | + Crashlytics **non-fatal** | same (non-fatal + ring-buffer dump) |
| `fatal` | Unhandled exception / crash | Crashlytics fatal | Crashlytics fatal |

- Release min level = `info`, Remote Config `log_min_level` થી બદલી શકાય (દા.ત. કોઈ issue investigate કરતી વખતે `debug`).
- **Ring buffer:** memory માં છેલ્લી **300 entries**. Error/fatal વખતે છેલ્લી 50 entries Crashlytics `log()` માં dump થાય (Crashlytics breadcrumb limit 64 KB ની અંદર).
- **Local file:** `appDocuments/logs/app_log_0.jsonl` અને `_1.jsonl`, બે files માં rotation, દરેક max 512 KB. Bug report સાથે attach થાય. App uninstall થતાં delete થાય.

## 4. Categories & Error Codes

દરેક log entry = `category` + stable `code`. Code નામ ક્યારેય બદલવા નહીં, કારણ કે dashboards અને alerts તેના પર બને છે.

| Category | Prefix | Examples |
|---|---|---|
| `input` | `I-` | `I-TAP`, `I-DEAD-TAP`, `I-RAGE-TAP`, `I-SLOW-INPUT`, `I-TAP-DURING-ANIM` |
| `game` | `E-GAME-` | `E-GAME-001` invariant violated, `E-GAME-002` move rejected unexpectedly, `E-GAME-003` stuck animation (> 2 s), `E-GAME-004` no valid move but level not lost (soft-lock) |
| `level` | `E-LVL-` | `E-LVL-001` JSON parse fail, `E-LVL-002` schema mismatch, `E-LVL-003` generator 64 attempts fail, `E-LVL-004` solver timeout on Hint |
| `save` | `E-SAVE-` | `E-SAVE-001` Hive open fail, `E-SAVE-002` corrupt ⇒ backup restored, `E-SAVE-003` migration fail, `E-SAVE-004` write fail |
| `ads` | `W-ADS-` / `E-ADS-` | `W-ADS-001` load fail (with AdMob code), `W-ADS-002` show fail, `E-ADS-003` reward not granted after completion |
| `iap` | `E-IAP-` | `E-IAP-001` purchase error, `E-IAP-002` verification fail, `E-IAP-003` pending > 24 h, `E-IAP-004` restore fail |
| `net` | `W-NET-` | `W-NET-001` server time fetch fail, `W-NET-002` Remote Config fetch timeout |
| `time` | `W-TIME-` | `W-TIME-001` clock moved backward (time-travel lock), `W-TIME-002` server/device skew > 2 h |
| `audio` | `E-AUD-` | `E-AUD-001` asset missing, `E-AUD-002` pool create fail, `E-AUD-003` playback error |
| `ui` | `E-UI-` | `E-UI-001` FlutterError (layout overflow, build exception), `E-UI-002` image decode fail |
| `perf` | `W-PERF-` | `W-PERF-001` level jank > 5% frames, `W-PERF-002` level load > 1.5 s, `W-PERF-003` memory warning, `W-PERF-004` slow cold start / splash safety cap, `W-PERF-005` launch intro jank guard ([SPLASH §12](./SPLASH_AND_INSTANT_LAUNCH.md#12-measurement-logging-and-analytics)) |
| `sync` (Phase 2) | `E-SYNC-` | `E-SYNC-001` conflict unresolved, `E-SYNC-002` op rejected by server |

Error code ની સંપૂર્ણ list `packages/puzzle_core/lib/logging/codes.dart` માં constants તરીકે રાખો. Docs અને code એક જ list વાપરે.

## 5. AppLogger (Dart)

```dart
// app/lib/logging/app_logger.dart
import 'dart:collection';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

enum LogLevel { trace, debug, info, warn, error, fatal }

enum LogCat { input, game, level, save, ads, iap, net, time, audio, ui, perf, sync, nav }

class LogEntry {
  LogEntry(this.level, this.cat, this.code, this.message, this.data)
      : utc = DateTime.now().toUtc();

  final DateTime utc;
  final LogLevel level;
  final LogCat cat;
  final String code;
  final String message;
  final Map<String, Object?> data;

  Map<String, Object?> toJson() => {
        't': utc.toIso8601String(),
        'l': level.name,
        'c': cat.name,
        'code': code,
        'm': message,
        if (data.isNotEmpty) 'd': data,
      };

  String encode() => jsonEncode(toJson(), toEncodable: (o) => o.toString());
}

class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  static const int _capacity = 300;
  final ListQueue<LogEntry> _ring = ListQueue<LogEntry>(_capacity);

  LogLevel minLevel = kReleaseMode ? LogLevel.info : LogLevel.trace;
  bool crashlyticsEnabled = true;

  void log(
    LogLevel level,
    LogCat cat,
    String code,
    String message, [
    Map<String, Object?> data = const {},
  ]) {
    if (level.index < minLevel.index) return;
    try {
      final entry = LogEntry(level, cat, code, message, data);
      if (_ring.length == _capacity) _ring.removeFirst();
      _ring.addLast(entry);
      if (!kReleaseMode) debugPrint(entry.encode());
      if (crashlyticsEnabled && level.index >= LogLevel.warn.index) {
        FirebaseCrashlytics.instance.log(entry.encode());
      }
      if (level.index >= LogLevel.info.index) LogFileSink.instance.append(entry);
    } catch (_) {
      // Logging must never break the game.
    }
  }

  Future<void> recordError(
    LogCat cat,
    String code,
    Object error,
    StackTrace? stack, {
    Map<String, Object?> data = const {},
    bool fatal = false,
  }) async {
    log(fatal ? LogLevel.fatal : LogLevel.error, cat, code, error.toString(), data);
    if (!crashlyticsEnabled) return;
    try {
      for (final e in lastEntries(50)) {
        FirebaseCrashlytics.instance.log(e.encode());
      }
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: code,
        fatal: fatal,
        information: data.entries.map((e) => '${e.key}=${e.value}'),
      );
    } catch (_) {}
  }

  Iterable<LogEntry> lastEntries(int n) =>
      _ring.length <= n ? _ring : _ring.skip(_ring.length - n);

  List<Map<String, Object?>> snapshot() =>
      _ring.map((e) => e.toJson()).toList(growable: false);
}
```

`LogFileSink` = buffered writer: flush દર 5 sec, `warn+` પર તરત, અને `AppLifecycleState.paused` પર. 512 KB પર rotation. Write fail થાય તો sink પોતે disable થઈ જાય (crash નહીં).

```dart
// app/lib/logging/log_file_sink.dart
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'app_logger.dart';

class LogFileSink {
  LogFileSink._();
  static final LogFileSink instance = LogFileSink._();

  static const int _maxBytes = 512 * 1024;
  final List<String> _pending = [];
  File? _file;
  bool _disabled = false;
  Timer? _timer;

  Future<void> init() async {
    try {
      final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/logs');
      await dir.create(recursive: true);
      _file = File('${dir.path}/app_log_0.jsonl');
      _timer = Timer.periodic(const Duration(seconds: 5), (_) => flush());
    } catch (_) {
      _disabled = true;
    }
  }

  void append(LogEntry e) {
    if (_disabled) return;
    _pending.add(e.encode());
    if (e.level.index >= LogLevel.warn.index) unawaited(flush());
  }

  Future<void> flush() async {
    final file = _file;
    if (_disabled || file == null || _pending.isEmpty) return;
    final lines = List<String>.of(_pending);
    _pending.clear();
    try {
      if (await file.exists() && await file.length() > _maxBytes) {
        await file.rename('${file.parent.path}/app_log_1.jsonl'); // replaces previous _1
      }
      await file.writeAsString('${lines.join('\n')}\n', mode: FileMode.append, flush: true);
    } catch (_) {
      _disabled = true;
      _timer?.cancel();
    }
  }
}
```
`AppLogger` file માં `import 'log_file_sink.dart';` ઉમેરો. App start પર `await LogFileSink.instance.init();` બોલાવો (Firebase init પછી).

### 5.1 Global error hooks (`main.dart`)
```dart
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (details) {
    AppLogger.instance.log(LogLevel.error, LogCat.ui, 'E-UI-001', details.exceptionAsString());
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.instance.recordError(LogCat.game, 'E-UNCAUGHT', error, stack, fatal: true);
    return true;
  };

  Isolate.current.addErrorListener(RawReceivePort((List<dynamic> pair) {
    final error = pair.first as Object;
    final stack = StackTrace.fromString(pair.last.toString());
    AppLogger.instance.recordError(LogCat.game, 'E-ISOLATE', error, stack, fatal: true);
  }).sendPort);

  runApp(const GameApp());
}
```
- Hint solver અને level generator isolates (`Isolate.run`) ના errors `try/catch` થી પકડીને `E-LVL-004` / `E-LVL-003` તરીકે log કરો.
- Release builds: `flutter build appbundle --obfuscate --split-debug-info=build/symbols`. Pipeline માં symbols upload (`firebase crashlytics:symbols:upload --app=<id> build/symbols`) **ફરજિયાત**, નહીં તો stack traces વાંચી શકાશે નહીં. iOS dSYM upload Xcode build phase script થી.

### 5.2 Crashlytics custom keys (હંમેશા update રાખો)
| Key | Example | Updated when |
|---|---|---|
| `game_id` | `snakes_slither` | App start |
| `app_version` / `build` | `1.3.0` / `130` | App start |
| `screen` | `gameplay` | Route change |
| `level` / `phase` | `141` / `1` | Level load |
| `level_seed` / `generator_version` | `0x00A1…` / `3` | Level load |
| `attempt` / `moves` / `hearts` | `2` / `9` / `1` | Each Move |
| `boosters_active` | `shield:1` | Booster use |
| `save_version` | `1` | App start |
| `vip` / `age_band` | `false` / `13plus` | App start / change |
| `ad_state` | `interstitial_showing` | Ad lifecycle |
| `last_input` | `board:p7:bump` | Each tap |

`FirebaseCrashlytics.instance.setUserIdentifier(installId)`: `installId` એ random UUID છે, PII નથી (§10).

## 6. Tap & Input Logging ("user ક્યાંય પણ tap કરે")

### 6.1 What every tap records
App root પર એક **global `Listener`** દરેક pointer down/up પકડે છે (UI અને board બંને), અને પછી જે handler tap સંભાળે તે result report કરે.

| Field | Example | Notes |
|---|---|---|
| `seq` | 1842 | Session tap counter |
| `screen` | `gameplay` | Current route name |
| `nx`, `ny` | 0.412, 0.733 | Normalized position (0–1). Raw pixels કે device ID નહીં |
| `target` | `board:cell(4,7):p7` / `btn:shop.buy.hint3` / `none` | Semantic ID (§6.2) |
| `result` | `exit` / `bump` / `locked` / `ui_ok` / `ignored_anim` / `queued` / `dead` | Handler result |
| `latency_ms` | 12 | Pointer up → handler done |
| `state_hash` | `9f3c…` | Board state hash (game screen only) |

Taps release build માં **`debug` level** પર log થાય: માત્ર local ring buffer અને file, Crashlytics/network પર નહીં. Error થાય ત્યારે ring buffer dump દ્વારા છેલ્લા taps Crashlytics breadcrumbs તરીકે જાય. **Tap-by-tap analytics events મોકલવા નહીં** (cost, privacy). માત્ર aggregated signals (§6.3).

### 6.2 Semantic IDs
- દરેક tappable widget `LoggedTap(id: 'shop.buy.hint3', child: …)` થી wrap થાય. ID format: `<screen>.<area>.<action>`.
- Board taps: rules engine નું `TapResult` (`exit`, `bump`, `locked`, `noTarget`, `interactive:<mechanicId>`) ⇒ `board:cell(x,y):<pathId|mechanicId>`.
- Lint rule (custom `analysis_options` + CI grep): `GestureDetector`/`InkWell` સીધા વાપરવા નહીં; હંમેશા `LoggedTap` અથવા `LoggedButton`.

### 6.3 Detectors (silent issues)
| Signal | Rule | Level / code | Analytics event (aggregated) |
|---|---|---|---|
| **Dead tap** | Pointer up પછી 300 ms માં કોઈ handler એ tap claim ન કર્યો, અને tap board/known widget પર નહોતો | `debug I-DEAD-TAP` | Session end પર `dead_taps{screen, count}` જો count ≥ 3 |
| **Rage tap** | ≥ 4 taps, 1.5 s ની અંદર, 48 dp radius માં | `warn I-RAGE-TAP` | `rage_tap{screen, target}` (max 3/session) |
| **Slow input** | Pointer up → visible response > 200 ms | `warn I-SLOW-INPUT` | `slow_input{screen, ms_bucket}` |
| **Tap during animation** | Queue full (rule §2.8 of standard) ⇒ tap dropped | `debug I-TAP-DURING-ANIM` | — |
| **Stuck animation** | Move animation > 2 s (normal ≤ 450 ms) | `error E-GAME-003` + non-fatal + force-complete animation | — |
| **Soft-lock** | Remaining paths > 0, hearts > 0, પણ solver કહે કોઈ valid sequence નથી (Hammer વિના) | `error E-GAME-004` + auto-suggest Restart | `softlock{level}` |

```dart
// app/lib/logging/tap_logger.dart
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_logger.dart';

class InputTrace {
  InputTrace._();
  static final InputTrace instance = InputTrace._();

  int _seq = 0;
  int? _pendingSeq;
  String screen = 'unknown';
  final List<({DateTime t, Offset p})> _recent = [];

  int beginTap(Offset globalPos, Size screenSize) {
    final seq = ++_seq;
    _pendingSeq = seq;
    _detectRage(globalPos);
    AppLogger.instance.log(LogLevel.debug, LogCat.input, 'I-TAP', 'down', {
      'seq': seq,
      'screen': screen,
      'nx': (globalPos.dx / screenSize.width).toStringAsFixed(3),
      'ny': (globalPos.dy / screenSize.height).toStringAsFixed(3),
    });
    return seq;
  }

  /// Called by LoggedTap / board input handler when it consumes the tap.
  void markHandled(String target, String result, {int latencyMs = 0}) {
    final seq = _pendingSeq;
    _pendingSeq = null;
    AppLogger.instance.log(LogLevel.debug, LogCat.input, 'I-TAP', 'handled', {
      'seq': seq,
      'target': target,
      'result': result,
      'latency_ms': latencyMs,
    });
    if (latencyMs > 200) {
      AppLogger.instance.log(LogLevel.warn, LogCat.input, 'I-SLOW-INPUT', target, {'ms': latencyMs});
    }
  }

  void endTap(int seq) {
    Timer(const Duration(milliseconds: 300), () {
      if (_pendingSeq == seq) {
        _pendingSeq = null;
        AppLogger.instance.log(LogLevel.debug, LogCat.input, 'I-DEAD-TAP', screen, {'seq': seq});
      }
    });
  }

  void _detectRage(Offset p) {
    final now = DateTime.now();
    _recent.removeWhere((e) => now.difference(e.t) > const Duration(milliseconds: 1500));
    _recent.add((t: now, p: p));
    final near = _recent.where((e) => (e.p - p).distance <= 48).length;
    if (near >= 4) {
      AppLogger.instance.log(LogLevel.warn, LogCat.input, 'I-RAGE-TAP', screen, {'taps': near});
      _recent.clear();
    }
  }
}

class TapLoggerScope extends StatelessWidget {
  const TapLoggerScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    int? seq;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) => seq = InputTrace.instance.beginTap(e.position, MediaQuery.sizeOf(context)),
      onPointerUp: (_) {
        final s = seq;
        if (s != null) InputTrace.instance.endTap(s);
      },
      child: child,
    );
  }
}
```
- `TapLoggerScope` ને `MaterialApp.builder` માં wrap કરો, જેથી દરેક route અને dialog cover થાય.
- `screen` ને `NavigatorObserver` (`RouteAwareLogger`) update કરે, અને તે route change ને `info nav` તરીકે log કરે.
- Multi-touch: માત્ર પહેલી pointer (`e.pointer` lowest active) track કરો. Board માં pinch-zoom (Phase 2) ને tap ગણવું નહીં.

## 7. Game Session Replay (deterministic reproduction)

દરેક level attempt નો compact record. Engine deterministic હોવાથી આ record થી bug 100% reproduce થઈ શકે.

```json
{
  "v": 1, "game": "toy_trains", "app": "1.3.0+130", "gen": 3, "schema": 3,
  "level": 141, "seed": "0x00A1B2C3D4E5F607", "attempt": 2,
  "start_state_hash": "5be1…",
  "moves": [
    {"t": 1830, "a": "tap", "tgt": "p3", "r": "exit"},
    {"t": 4120, "a": "tap", "tgt": "o2", "r": "interactive"},
    {"t": 5011, "a": "booster", "tgt": "hammer", "r": "ok"},
    {"t": 7302, "a": "tap", "tgt": "p7", "r": "bump"}
  ],
  "end": {"result": "error", "code": "E-GAME-001", "state_hash": "c04d…", "hearts": 2, "moves": 4}
}
```

- Device પર છેલ્લા **3 attempts** ના replays રાખો (memory + file). Size સામાન્ય રીતે < 3 KB.
- Upload ક્યારે થાય: (a) `error`/`fatal` game/level category માં, (b) user "Report a problem" મોકલે, (c) Remote Config `replay_sample_rate` (default 0) થી QA/beta માટે random sampling.
- Upload: Callable Cloud Function `uploadReplay` ⇒ Cloud Storage `replays/<game>/<app_version>/<date>/<uuid>.json` અને Crashlytics key `replay_id`.
- **Replay tool** (`tools/replay`, Dart CLI + debug-build in-app viewer): JSON load ⇒ `puzzle_core` માં move-by-move ચલાવે ⇒ દરેક step પછી `state_hash` compare. Mismatch હોય તો તે version-specific bug છે અથવા non-determinism છે ⇒ P1.
- `state_hash` = board state (paths, mechanics states, counters, hearts) નો FNV-1a 64-bit hash. Debug builds દરેક Move પર compute કરે, release builds માત્ર start/end અને error વખતે.

## 8. Invariant Checks (release builds માં soft asserts)

Rules engine દરેક Move પછી cheap checks ચલાવે. Fail થાય તો crash **ન** કરો: `E-GAME-001` non-fatal (state snapshot + replay સાથે) log કરો અને safe recovery કરો.

| Invariant | Recovery |
|---|---|
| `0 ≤ hearts ≤ 3` | Clamp |
| `coins ≥ 0`, booster counts ≥ 0 | Clamp at 0, wallet resync from ledger |
| Path cells બીજા path કે blocking mechanic સાથે overlap ન થાય (same layer) | Abort move, restore pre-move snapshot |
| `remainingPaths == 0` ⇒ win state | Force win flow |
| Animation queue ≤ 1 | Drop extra |
| Level JSON `schema == 3` અને ids unique | Show "Level unavailable" + Retry; level skip ક્યારેય નહીં |
| Ad reward callback ⇒ reward granted exactly once | Idempotency key per ad impression |

## 9. Domain-specific Logging

| Area | Log (level) | Never log |
|---|---|---|
| **Ads** | load/show success (debug), failure with AdMob `code`/`domain`/`message` (warn), reward granted (info), time-to-load ms | Ad ID / advertising ID |
| **IAP** | purchase flow states `pending→purchased→verified→delivered` (info), errors with store code (error), restore results | Full purchase token / receipt (માત્ર SHA-256 first 12 chars) |
| **Save** | load/migrate duration, backup restore (warn), write failures (error) | Full save contents (માત્ર sizes + version) |
| **Time / Streak** | time-travel lock (warn `W-TIME-001`), server skew, claim results | Exact timezone નામ (માત્ર UTC offset) |
| **Level/generator** | load ms, generator attempts `k`, solver nodes/time for Hint | — |
| **Performance** | per level: avg/p95 frame build+raster ms, janky frame % (`SchedulerBinding.instance.addTimingsCallback`), level load ms; Perf traces `app_start`, `level_load`, `hint_solve` | — |
| **Audio** | `E-AUD-*` per [Sound doc §8](./SOUND_EFFECTS_IMPLEMENTATION.md#8-implementation-dart) | — |
| **Phase 2 Sync** | op upload/ack, conflicts (warn), rejections (error) | Auth tokens |

## 10. Privacy, Children & Compliance

- **Identifiers:** માત્ર `installId` (random UUID v4, app install વખતે બને). Name, email, phone, precise location, contacts, advertising ID, IP address વગેરે logs માં **ક્યારેય નહીં**. Phase 2 Firebase Auth UID logs માં hashed રાખો.
- **Free text:** Bug report માં free-text box **માત્ર 13+** users માટે (max 500 chars, client-side email/phone pattern masking). Under-13 users માટે માત્ર category picker ("Game stuck", "Tap not working", "Lost coins", "Ad problem", "Other").
- **Screenshots:** Bug report માં optional અને user ની explicit opt-in સાથે જ. Under-13 માટે disabled.
- **Consent:** UMP consent ads માટે છે. Crash/diagnostics collection: Crashlytics collection app start પર enabled (legitimate interest, privacy policy માં disclose). Settings → Privacy → "Share diagnostics" toggle off ⇒ `setCrashlyticsCollectionEnabled(false)` + analytics collection off + replay upload off. Local ring buffer ચાલુ રહે, પણ device છોડતું નથી.
- **Retention:** Crashlytics: default 90 days. Replays/bug reports (Storage/Firestore): **90 days TTL** (Firestore TTL policy, Storage lifecycle rule). Local log files: 2 × 512 KB rotation.
- **Data deletion:** Settings → "Delete my data" ⇒ local logs wipe + server-side `deleteUserData` function (Phase 2 account flow) ⇒ replays/bug reports by `installId` delete.
- Play **Families policy**: logs અને crash reports માં બાળકોના personal data નહીં. Crashlytics/Analytics Families-compatible configuration (`firebase_analytics`: under-13 ⇒ `setAnalyticsCollectionEnabled` મર્યાદિત, ad personalization signals off).

## 11. In-Game "Report a Problem"

- **Where:** Settings → Help → "Report a problem". Error dialogs માં "Report" button પણ.
- **Collects:** category, optional text (13+), app/device info (model, OS, RAM bucket, locale), last 300 log entries, last 3 replays, current save **summary** (versions, counts, no tokens), optional screenshot (13+, opt-in).
- **Sends:** Callable Function `submitBugReport` ⇒ Firestore `bug_reports/<id>` (metadata) + Storage (attachments). User ને **Report ID** (`BR-7F3K2Q`) બતાવો, જેથી support તે ID થી શોધી શકે.
- **Offline:** report queue થાય (max 3), online થતાં મોકલાય.
- **Beta / internal builds:** shake gesture ⇒ same report screen (release માં Remote Config `shake_to_report` off).
- **Rate limit:** device દીઠ દિવસમાં max 5 reports (server-side enforced).

## 12. Remote Config Switches

| Key | Default | Purpose |
|---|---|---|
| `log_min_level` | `info` | Release logging level |
| `crashlytics_breadcrumb_level` | `warn` | Minimum level sent as Crashlytics breadcrumbs |
| `replay_sample_rate` | `0.0` | Random replay upload ratio (0–1) |
| `replay_upload_on_error` | `true` | Upload replay with game/level errors |
| `tap_analytics_enabled` | `true` | Aggregated dead/rage/slow tap events |
| `perf_frame_sampling` | `0.1` | Fraction of sessions collecting frame stats |
| `debug_install_ids` | `[]` | These install IDs get `debug` level + full replay upload (support investigations) |
| `shake_to_report` | `false` | Shake gesture for bug report |

## 13. Dashboards & Alerts

| Dashboard / metric | Source | Target / alert |
|---|---|---|
| Crash-free users | Crashlytics | ≥ **99.5%** per release; < 99.0% ⇒ alert P0 |
| Crash velocity (new issue spike) | Crashlytics velocity alert | Alert to `#game-alerts` Slack/email |
| ANR rate | Play Console Vitals | < 0.47% (Play bad-behaviour threshold) |
| Top non-fatals by code | Crashlytics + BigQuery | Any code > 1% of sessions ⇒ P1 ticket |
| Rage taps per screen / target | Analytics → BigQuery | Week-over-week +50% ⇒ UX review |
| Dead taps per screen | Analytics → BigQuery | Top 5 targets reviewed every release |
| Level fail rate & avg bumps per level | Analytics `level_fail`/`level_win` | Fail rate > 60% on non-Hard level ⇒ re-band (D) |
| Soft-lock count | `softlock` event | Any > 0 ⇒ P1 (validator gap) |
| Ad errors by code | `W-ADS-*` | No-fill > 30% ⇒ check mediation/config |
| IAP failures | `E-IAP-*` | Any `E-IAP-002/003` spike ⇒ P0 (revenue) |
| Level load / jank | Firebase Performance | p95 level load > 1.5 s or jank > 5% ⇒ P2 |

BigQuery export (Analytics + Crashlytics) ચાલુ રાખો. ચારેય games માટે saved queries એક જ (game_id filter સાથે).

## 14. Debugging Runbook (issue આવે ત્યારે)

1. **Detect:** Alert / Crashlytics issue / user Report ID / store review.
2. **Triage (≤ 1 business day):** severity assign કરો.
   - **P0:** crash spike, progress/coins loss, IAP not delivered.
   - **P1:** soft-lock, wrong rules, ad reward not granted.
   - **P2:** perf/jank, UI glitch.
   - **P3:** cosmetic.
3. **Context:** Crashlytics issue ⇒ custom keys (game, level, seed, screen, last_input) + breadcrumbs (છેલ્લા 50 logs = છેલ્લા taps) + stack trace (symbolicated).
4. **Reproduce:** `replay_id` હોય તો `tools/replay --file <replay.json>` ચલાવો ⇒ failing step શોધો. Replay ન હોય તો Remote Config `debug_install_ids` માં user નો installId (Report ID થી મળે) ઉમેરો ⇒ next occurrence પર full replay મળશે.
5. **Fix + test:** failing replay ને **regression test fixture** તરીકે `puzzle_core/test/replays/` માં ઉમેરો (CI હંમેશા ચલાવે).
6. **Release:** level/data fix હોય તો Remote Config / level hotfix bundle થી; code fix હોય તો app update (staged rollout 10% → 50% → 100%, crash-free monitor).
7. **Verify & close:** fixed version માં code ની frequency 0 થયાની ખાતરી કરો. Report ID વાળા users ને (Phase 2 inbox) "Fixed" message.

## 15. QA Checklist (status: Not run)

| ID | Test | Expected | Status |
|---|---|---|---|
| LOG-01 | Debug build: force `throw` in a button handler | Crashlytics fatal with symbolicated stack (after symbols upload), keys set, last 50 breadcrumbs present | Not run |
| LOG-02 | Release build with `--obfuscate`: same | Stack trace readable in console | Not run |
| LOG-03 | Tap 20 different UI buttons + board | Ring buffer has `I-TAP` down + handled for each with correct semantic IDs | Not run |
| LOG-04 | Tap empty background 5 times | `I-DEAD-TAP` entries; `dead_taps` event at session end | Not run |
| LOG-05 | Tap same spot 6× in 1 s | One `I-RAGE-TAP` warn + analytics event | Not run |
| LOG-06 | Inject 300 ms delay in a handler | `I-SLOW-INPUT` warn | Not run |
| LOG-07 | Corrupt save file | `E-SAVE-002`, backup restored, game continues | Not run |
| LOG-08 | Delete a level JSON in debug | `E-LVL-001` non-fatal + "Level unavailable" dialog, no crash | Not run |
| LOG-09 | Force invariant (hearts = −1) via debug menu | `E-GAME-001` non-fatal with replay; hearts clamped | Not run |
| LOG-10 | Play level, trigger error, run `tools/replay` on uploaded replay | Same error at same move; hashes match until failure | Not run |
| LOG-11 | Airplane mode ad load | `W-ADS-001` with AdMob code; UI handles gracefully | Not run |
| LOG-12 | IAP test card decline | `E-IAP-001`; token not in logs (only hash) | Not run |
| LOG-13 | Clock moved back 1 day | `W-TIME-001`; streak/daily locked | Not run |
| LOG-14 | Report a problem (13+ and under-13 profiles) | Report ID shown; under-13 has no free text/screenshot; attachments uploaded | Not run |
| LOG-15 | Offline report | Queued; sent on reconnect | Not run |
| LOG-16 | "Share diagnostics" off | No Crashlytics/analytics/replay network traffic (verify with proxy) | Not run |
| LOG-17 | Remote Config `log_min_level = debug` | Debug entries appear in file sink after fetch | Not run |
| LOG-18 | Performance: 1,000 taps | Avg logging overhead per tap < 0.2 ms; log files ≤ 2 × 512 KB | Not run |
| LOG-19 | Network inspection of all log/report payloads | No PII (email, phone, ad ID, IP in body) | Not run |
| LOG-20 | Kill app mid-level | Next launch: previous session file intact; no corruption | Not run |
| LOG-21 | Solver isolate throws (debug fault injection) | `E-LVL-004` logged; Hint not consumed; "Try Restart" toast | Not run |
| LOG-22 | Crashlytics alerts configured | Velocity + crash-free alerts reach team channel | Not run |
