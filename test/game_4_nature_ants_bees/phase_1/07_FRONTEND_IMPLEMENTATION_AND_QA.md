# 07 — Frontend Implementation & QA (ફ્રન્ટએન્ડ અમલીકરણ અને ચકાસણી)
Flutter architecture, rules engine (layer rule), renderer, input, audio, ads/IAP/consent, persistence, analytics, performance, error handling અને **QA checklist** (બધા items "Not run").

**Related docs:** [Shared Core Standard §12–§15](../../SHARED_CORE_STANDARD.md) · [Sound Effects](../../SOUND_EFFECTS_IMPLEMENTATION.md) · [Logging & Error Tracking](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md)

---

## 1. Architecture (આર્કિટેક્ચર)

| Area | Decision ([Standard §13](../../SHARED_CORE_STANDARD.md)) |
|---|---|
| Framework | Flutter 3.x stable, Dart 3, Impeller |
| Rendering | `CustomPainter` + `Ticker` game loop (**Flame નહીં**) |
| State | `flutter_bloc` |
| Engine | `packages/puzzle_core` (pure Dart, ચારેય games share): board, rules, mechanics, solver, generator, PRNG |
| Persistence | `hive_ce` typed adapters, save schema v1 |
| Ads / Consent | `google_mobile_ads` (UMP) |
| IAP | `in_app_purchase` + Firebase Function `verifyPurchase` |
| Analytics / Crash / Config | `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` |
| Leaderboards | `games_services` |
| Audio | `audioplayers` (`AudioService` + `AudioPool` for SFX) — [Sound doc](../../SOUND_EFFECTS_IMPLEMENTATION.md), §7 |
| Logging / errors | `AppLogger` + Crashlytics + `firebase_performance`, `TapLoggerScope` — [Logging doc](../../LOGGING_AND_ERROR_TRACKING.md), §12 |
| Haptics | Flutter `HapticFeedback` |
| Localization | `flutter_localizations` + ARB (en, gu, hi) |

Layering: **UI widgets → BLoCs → services (ads, iap, audio, save) → `puzzle_core`**. `puzzle_core` Flutter import નથી કરતું (pure Dart ⇒ CLI generator/validator પણ એ જ code વાપરે).

## 2. Folder Tree

```
repo/
├─ apps/
│  └─ ants_bees/
│     ├─ lib/
│     │  ├─ main.dart
│     │  ├─ app/              # router, theme tokens, l10n
│     │  ├─ blocs/            # game, progress, wallet, daily, streak, spin, shop, ads, consent, settings, rush
│     │  ├─ game/
│     │  │  ├─ board_view.dart       # Ticker + gestures + painters
│     │  │  ├─ painters/             # static_board, layer_painter, preview, overlays
│     │  │  ├─ animation/            # march, fly, bump, track math
│     │  │  └─ input/                # tap resolution, long-press
│     │  ├─ screens/          # one folder per screen (06)
│     │  ├─ services/         # ads, iap, audio, haptics, analytics, save, time_trust
│     │  └─ theme_g4/         # Game 4 names, sprite keys, sounds map
│     ├─ assets/
│     │  ├─ levels/phase_1.json.gz
│     │  ├─ levels/daily_fallback.json
│     │  ├─ sprites/atlas_ground.png, atlas_air.png, atlas_ui.png (+ .json)
│     │  ├─ audio/theme.json, audio/sfx/<event_id>_v<N>.wav, audio/music/<track_id>.m4a, audio/CREDITS.md
│     │  └─ fonts/
│     └─ test/ , integration_test/
├─ packages/
│  └─ puzzle_core/
│     ├─ lib/src/model/       # Cell, Dir, Layer, LineModel, BoardState
│     ├─ lib/src/rules/       # lane_rules.dart, move_engine.dart, undo_stack.dart
│     ├─ lib/src/mechanics/   # m001_single_blocker.dart … m049_guardian.dart
│     ├─ lib/src/solver/      # bfs, ida_star, hint
│     ├─ lib/src/gen/         # generator, reverse_construction, difficulty
│     └─ lib/src/prng/        # xoshiro128ss.dart
└─ tools/
   ├─ levelgen/               # Dart CLI
   └─ validator/              # CI entrypoint
```

## 3. Rules Engine — Layer Rule (puzzle_core)

Layer rule [01 §5](./01_GAME_CONCEPT_AND_RULES.md) engine માં એક જ જગ્યાએ:

```dart
// packages/puzzle_core/lib/src/rules/lane_rules.dart
enum Layer { ground, air }

enum Dir { up, down, left, right }

final class Cell {
  const Cell(this.x, this.y);
  final int x;
  final int y;

  @override
  bool operator ==(Object other) => other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

final class LineModel {
  const LineModel({
    required this.id,
    required this.layer,
    required this.dir,
    required this.body,
    required this.color,
  });
  final String id;
  final Layer layer;
  final Dir dir;
  final List<Cell> body; // body[0] = head insect
  final String color;
}

abstract class MechanicInstance {
  MechanicInstance({
    required this.id,
    required this.type,
    required this.cells,
    this.tall = false,
    this.hammerable = false,
  });
  final String id;
  final String type; // engine rule ID, e.g. "M001"
  final List<Cell> cells;
  final bool tall; // Game 4 extension, default false
  final bool hammerable;

  /// Mechanic-specific blocking test, layer-agnostic.
  bool blocksRaw(LineModel line, Dir laneDir, BoardState state);

  /// LR-3/LR-4/LR-5: ground lanes see every mechanic; air lanes only tall ones.
  bool affectsLayer(Layer layer) => layer == Layer.ground || tall;
}

abstract interface class BoardState {
  int get width;
  int get height;
  LineModel? lineAt(Cell cell, Layer layer);
  Iterable<MechanicInstance> mechanicsAt(Cell cell);
}

/// First blocking cell on [lane] for [line], or null when the lane is clear.
Cell? firstBlocker(BoardState state, LineModel line, List<Cell> lane) {
  for (final cell in lane) {
    // LR-2: only lines of the SAME layer block (ants never block bees and vice versa).
    final other = state.lineAt(cell, line.layer);
    if (other != null && other.id != line.id) return cell;
    for (final m in state.mechanicsAt(cell)) {
      if (m.affectsLayer(line.layer) && m.blocksRaw(line, line.dir, state)) {
        return cell;
      }
    }
  }
  return null;
}

/// LR-6: an ant line is locked while any bee body cell sits above any of its cells.
bool isCoverLocked(BoardState state, LineModel line) =>
    line.layer == Layer.ground &&
    line.body.any((cell) => state.lineAt(cell, Layer.air) != null);
```

- `laneCells(line)` portal / deflector / switch / jump pad / inner exit hops સંભાળે; દરેક hop mechanic પણ `affectsLayer` થી gate થાય.
- `MoveEngine.apply(Move) → MoveResult{exit|bump|locked|control, events[]}` pure function; `UndoStack` snapshots (immutable state, structural sharing).
- Move pipeline order ([Standard §16.17](../../SHARED_CORE_STANDARD.md), binding): (1) **action resolve** — tap target → lock check (LR-6 + mods) → lane trace → exit/bump → on-exit hooks (keys, M003 adjacency, M035 spawn) → (2) `moveCount += 1` → (3) counter ticks **in this order**: M007, M017, M031, M025, M027, M047, M041 → (4) derived states (plates, fog, cages, locks, cover-lock) → (5) heart loss (Shield પહેલાં absorb કરે) → (6) **win check** → (7) 0-heart check. Parity mechanic M021 step (2) **પહેલાં** ની `moveCount` parity વાપરે.

## 4. BLoCs, States & Events

| BLoC / Cubit | Events / methods | States |
|---|---|---|
| `GameBloc` | `LevelStarted(level, attempt)`, `LineTapped(id)`, `ControlTapped(id)`, `PreviewStarted(id)`, `PreviewEnded`, `BoosterPressed(type)`, `HammerTargetChosen(target)`, `TargetingCancelled`, `UndoPressed`, `ReviveRequested(ad/coins)`, `ReviveDeclined`, `AnimationFinished`, `Paused`, `Resumed`, `Restarted` | `GameLoading`, `GamePlaying{board, hearts, moves, shieldCharges, caps, busy, queuedTap, preview, targeting, hintTarget}`, `GameSecondChance{adAvailable, adUsed, refillsUsed}`, `GameWon{stars, coins, firstClear, triple}`, `GameFailed` |
| `ProgressCubit` | `recordWin(level, stars)`, `markAdRevive(level)` | `progress{highestCleared, stars[], adReviveUsed[]}` |
| `WalletCubit` | `addCoins(src, n)`, `spend(sku)`, `grantBooster(type, n)`, `consumeBooster(type)` | `wallet{coins, boosters}` |
| `RushBloc` | `RushStarted(level)`, `RushTap`, `RushTick`, `RushSkipped` | `RushIntro`, `RushRunning{secondsLeft, coins}`, `RushDone{coins}` |
| `DailyBloc` | `DailyOpened`, `DailyStarted`, `DailyWon`, `SaverChosen(ad/coins)` | `DailyLocked`, `DailyReady{modifier, silhouette}`, `DailyCleared`, `DailyTimeLocked`, `DailySaverOffer` |
| `StreakCubit` | `advance(dayKey)`, `applySaver()`, `reset()` | `streak{day, cycleSaverUsed, lastClaimDayKey, totalDays, trophyTier, frozen}` |
| `SpinCubit` | `spinFree()`, `spinAd()` | `SpinReady`, `SpinResult(prize)`, `SpinExhausted`, `SpinTimeLocked` |
| `ShopBloc` | `ShopOpened`, `BuyCoins(sku)`, `BuyIap(sku)`, `RestorePressed`, `FreeCoinsAd` | `ShopIdle{products}`, `ShopPending(sku)`, `ShopSuccess`, `ShopError(msg)` |
| `AdsCubit` | `onLevelWin(level, hasRewardScreen)`, `showRewarded(placement)` | `ads{winsSinceInterstitial, lastFullscreenUtc, dailyShopAds, dailySpinAds}` |
| `ConsentCubit` | `submitBirthYear(y)`, `requestUmp()` | `ConsentUnknown`, `ConsentReady{ageBand, canRequestAds}` |
| `SettingsCubit` | toggles, language | `settings{sound, music, haptics, language, ageBand, reduceMotion, reduceDarkness}` |

`GameBloc` engine call isolate માં નથી (apply < 1 ms); **on-device Hint solver** `Isolate.run` માં (50 ms budget, 50k nodes).

## 5. Game Loop & Renderer

### 5.1 Layers (paint order)
1. **Static board picture** (`PictureRecorder` cache): lawn tiles, rim, dew dots, **ground** obstacles, tall obstacle bases. Re-record માત્ર `boardVersion` બદલાય ત્યારે (gate flip, obstacle removed, fog cleared).
2. **Ground layer painter** — ant lines (repaint માત્ર ant animation દરમિયાન).
3. **Tall-obstacle tops + air layer painter** — bee lines, wing flutter (bees હોય ત્યારે દર frame).
4. Overlays — fog, Twilight mask (pre-rendered), preview lane, Hint glow, targeting dim.

દરેક layer `RepaintBoundary` માં. Shadows pre-baked sprites (per-frame `MaskFilter.blur` નહીં). Colors `Color.withValues(alpha:)`.

### 5.2 Geometry & cached board

```dart
// apps/ants_bees/lib/game/painters/static_board_painter.dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class BoardGeometry {
  const BoardGeometry({
    required this.cols,
    required this.rows,
    required this.cell,
    required this.origin,
  });

  final int cols;
  final int rows;
  final double cell;
  final Offset origin;

  /// 06 §4: cell = floor(min((availW - 32) / cols, availH / rows)).
  factory BoardGeometry.fit(Size area, int cols, int rows) {
    final cell = math.min((area.width - 32) / cols, area.height / rows).floorToDouble();
    final w = cell * cols;
    final h = cell * rows;
    return BoardGeometry(
      cols: cols,
      rows: rows,
      cell: cell,
      origin: Offset((area.width - w) / 2, (area.height - h) / 2),
    );
  }

  Rect cellRect(int x, int y) =>
      Rect.fromLTWH(origin.dx + x * cell, origin.dy + y * cell, cell, cell);

  Offset centerOf(int x, int y) => cellRect(x, y).center;

  (int, int)? cellAt(Offset p) {
    final x = ((p.dx - origin.dx) / cell).floor();
    final y = ((p.dy - origin.dy) / cell).floor();
    if (x < 0 || y < 0 || x >= cols || y >= rows) return null;
    return (x, y);
  }

  @override
  bool operator ==(Object other) =>
      other is BoardGeometry &&
      other.cols == cols &&
      other.rows == rows &&
      other.cell == cell &&
      other.origin == origin;

  @override
  int get hashCode => Object.hash(cols, rows, cell, origin);
}

class PictureCache {
  ui.Picture? _picture;
  Size? _size;
  int _version = -1;

  ui.Picture obtain(Size size, int version, void Function(Canvas canvas) draw) {
    final cached = _picture;
    if (cached != null && _size == size && _version == version) return cached;
    cached?.dispose();
    final recorder = ui.PictureRecorder();
    draw(Canvas(recorder));
    final fresh = recorder.endRecording();
    _picture = fresh;
    _size = size;
    _version = version;
    return fresh;
  }

  void dispose() {
    _picture?.dispose();
    _picture = null;
  }
}

class StaticBoardPainter extends CustomPainter {
  StaticBoardPainter({
    required this.geometry,
    required this.boardVersion,
    required this.cache,
    required this.drawStatic,
  });

  final BoardGeometry geometry;
  final int boardVersion; // bumped by GameBloc when static content changes
  final PictureCache cache;
  final void Function(Canvas canvas, BoardGeometry geometry) drawStatic;

  @override
  void paint(Canvas canvas, Size size) {
    final picture = cache.obtain(size, boardVersion, (c) => drawStatic(c, geometry));
    canvas.drawPicture(picture);
  }

  @override
  bool shouldRepaint(covariant StaticBoardPainter oldDelegate) =>
      oldDelegate.boardVersion != boardVersion || oldDelegate.geometry != geometry;
}
```

### 5.3 Layer painter (ants / bees) with wing flutter

**Wing flutter frequency:** સાચી મધમાખીની પાંખ ~200 Hz થી વધુ વાગે — 60 fps display પર તે aliasing થી સ્થિર/ઉલટી દેખાય. 60 fps નો Nyquist limit 30 Hz છે, અને 30 Hz પર દરેક cycle માં માત્ર 2 frames ⇒ flicker. તેથી **stylised 12 Hz** flutter (60 fps પર ~5 frames/cycle, 120 fps પર ~10) + pre-baked motion-blur wing sprite. Angle **elapsed time** પરથી (frame count પરથી નહીં) ⇒ 60/120 Hz બંને પર એક જ speed.

```dart
// apps/ants_bees/lib/game/painters/layer_painter.dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class LineRenderState {
  const LineRenderState({
    required this.segments,
    required this.colorKey,
    required this.headingRad,
    this.dimmed = false,
  });

  /// Pixel centres of insects, [0] = head insect (already animated).
  final List<Offset> segments;
  final String colorKey; // "red", "blue", ...
  final double headingRad;
  final bool dimmed; // cover-locked ant line (LR-6)
}

/// Mutable frame model; the painter repaints when it notifies.
class LayerFrame extends ChangeNotifier {
  double timeSeconds = 0;
  List<LineRenderState> lines = const [];

  void tick(double t) {
    timeSeconds = t;
    notifyListeners();
  }

  void setLines(List<LineRenderState> value) {
    lines = value;
    notifyListeners();
  }
}

class SpriteSheet {
  SpriteSheet(this.image, this._rects);
  final ui.Image image;
  final Map<String, Rect> _rects;
  Rect src(String key) => _rects[key] ?? Rect.zero;
}

class LayerPainter extends CustomPainter {
  LayerPainter({
    required this.frame,
    required this.cell,
    required this.sprites,
    required this.isAir,
    required this.reduceMotion,
  }) : super(repaint: frame);

  final LayerFrame frame;
  final double cell;
  final SpriteSheet sprites;
  final bool isAir;
  final bool reduceMotion;

  static const double wingHz = 12.0; // see 07 §5.3
  static const double bobHz = 1.5;
  static const double airLift = 6.0; // dp above ground

  final Paint _paint = Paint()..filterQuality = FilterQuality.medium;
  final Paint _dimPaint = Paint()
    ..filterQuality = FilterQuality.medium
    ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.75);

  @override
  void paint(Canvas canvas, Size size) {
    final t = frame.timeSeconds;
    final r = cell * 0.42;
    for (final line in frame.lines) {
      final body = line.dimmed ? _dimPaint : _paint;
      // Tail first so the head insect is drawn on top.
      for (var i = line.segments.length - 1; i >= 0; i--) {
        final c = line.segments[i];
        if (isAir) {
          final bob = reduceMotion ? 0.0 : 1.5 * math.sin(2 * math.pi * bobHz * t + i);
          final shadowRect =
              Rect.fromCircle(center: c + const Offset(airLift, airLift), radius: r);
          canvas.drawImageRect(sprites.image, sprites.src('bee_shadow'), shadowRect, _paint);
          final p = c.translate(0, -airLift + bob);
          _drawRotated(canvas, 'bee_${line.colorKey}', p, r, line.headingRad, body);
          final amp = reduceMotion ? 0.18 : 0.35;
          final wing = amp * math.sin(2 * math.pi * wingHz * t + i * 0.9);
          _drawRotated(canvas, 'bee_wing_l', p, r, line.headingRad - wing, _paint);
          _drawRotated(canvas, 'bee_wing_r', p, r, line.headingRad + wing, _paint);
        } else {
          final shadowRect = Rect.fromCircle(center: c + const Offset(1, 2), radius: r);
          canvas.drawImageRect(sprites.image, sprites.src('ant_shadow'), shadowRect, _paint);
          _drawRotated(canvas, 'ant_${line.colorKey}', c, r, line.headingRad, body);
        }
      }
    }
  }

  void _drawRotated(
      Canvas canvas, String key, Offset center, double r, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawImageRect(
        sprites.image, sprites.src(key), Rect.fromCircle(center: Offset.zero, radius: r), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LayerPainter oldDelegate) =>
      oldDelegate.frame != frame ||
      oldDelegate.cell != cell ||
      oldDelegate.sprites != sprites ||
      oldDelegate.isAir != isAir ||
      oldDelegate.reduceMotion != reduceMotion;
}
```

### 5.4 March / fly animation (track math)
- Track = `reverse(body)` + lane cells + `len` off-board cells (pixel centres, 1 cell spacing). Insect `k` (0 = head) at distance `s_k = (len − 1 − k) + advance`.
- **Exit:** `advance` 0 → `laneLen + len` over `min(450, 90 + 30·(laneLen + len))` ms, `Curves.easeInCubic` (ants), `Curves.easeInOutSine` (bees; + bob).
- **Bump:** advance 0 → `stopDistance` (blocker પહેલાંનો cell) in 45% time `Curves.easeOut`, "bonk" (haptic + SFX + 4 dp head shake) at peak, back to 0 in 55% `Curves.easeIn`; total 300 ms (≤ 450).
- Heading = direction of track segment under each insect (corners પર smooth via `Offset.lerp`).

```dart
// apps/ants_bees/lib/game/animation/track.dart
import 'dart:math' as math;
import 'dart:ui';

Offset pointAlong(List<Offset> track, double s) {
  if (track.isEmpty) return Offset.zero;
  final maxS = (track.length - 1).toDouble();
  final clamped = math.min(math.max(s, 0.0), maxS);
  final i = clamped.floor();
  if (i >= track.length - 1) return track.last;
  return Offset.lerp(track[i], track[i + 1], clamped - i)!;
}

double headingAlong(List<Offset> track, double s) {
  if (track.length < 2) return 0;
  final i = math.min(math.max(s.floor(), 0), track.length - 2);
  final d = track[i + 1] - track[i];
  return math.atan2(d.dy, d.dx);
}
```

### 5.5 Ticker
`BoardView` (`SingleTickerProviderStateMixin`) એક `Ticker` ચલાવે: દરેક tick પર active animation advance + `airFrame.tick(t)`. Bees ન હોય અને animation ન ચાલતું હોય ⇒ ticker `stop()` (battery). App paused (`AppLifecycleState.paused`) ⇒ animations final state પર snap, ticker stop.

## 6. Input Handling

```dart
// apps/ants_bees/lib/game/input/tap_resolver.dart
import 'dart:ui';

import 'package:puzzle_core/puzzle_core.dart';

import '../painters/static_board_painter.dart';

sealed class TapTarget {
  const TapTarget();
}

final class ControlTarget extends TapTarget {
  const ControlTarget(this.mechanicId);
  final String mechanicId;
}

final class LineTarget extends TapTarget {
  const LineTarget(this.lineId);
  final String lineId;
}

/// 01 §6.5 order: interactive control > bee (air, LR-7) > ant (ground).
TapTarget? resolveTap({
  required BoardState state,
  required BoardGeometry geometry,
  required Offset local,
  required String? Function(Offset local) controlHit, // lever/switch/daisy cell, rotor hub
}) {
  final control = controlHit(local);
  if (control != null) return ControlTarget(control);
  final xy = geometry.cellAt(local);
  if (xy == null) return null;
  final cell = Cell(xy.$1, xy.$2);
  final bee = state.lineAt(cell, Layer.air);
  if (bee != null) return LineTarget(bee.id);
  final ant = state.lineAt(cell, Layer.ground);
  if (ant != null) return LineTarget(ant.id);
  return null;
}
```

- `GestureDetector`: `onTapUp` ⇒ resolve; `onLongPressStart` (350 ms, custom `LongPressGestureRecognizer(duration: Duration(milliseconds: 350))` via `RawGestureDetector`) ⇒ preview; `onLongPressEnd` ⇒ preview off, **no tap**.
- Empty-cell tap: nearest line cell within 6 dp slop (same order).
- Busy (animation) ⇒ store only last tap (`queuedTap`), process on `AnimationFinished`.
- Leaf Blower targeting mode ⇒ resolver order: bee line > hammerable obstacle > ant line; controls ignored.
- Locked result ⇒ wobble anim + `locked` SFX + `HapticFeedback.selectionClick()`; Move counter unchanged.

## 7. Audio & Haptics

Audio નો source of truth: **[SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md)**. અહીં માત્ર Game 4 નો summary અને themed mapping.

- **Engine:** shared `AudioService` (singleton) — `SfxBank` (`AudioPool`, `PlayerMode.lowLatency`), `MusicPlayer` (2 × `AudioPlayer` crossfade), `Mixer` (buses `master`/`music`/`sfx`/`ui`, ducking), `SoundTheme` (`assets/audio/theme.json`: event ID → files). `puzzle_core` માત્ર `GameEvent` emit કરે; `GameBloc` તેને `SoundCue` માં map કરી animation ના સાચા frame પર વગાડે (bump sound **contact** frame પર).
- **Assets:** SFX `.wav` PCM 16-bit **mono** 44.1 kHz (`sfx/<event_id>_v<N>.wav`), music/stingers `.m4a` AAC-LC. **OGG નહીં.** દરેક file `assets/audio/CREDITS.md` માં.
- **Voices:** max **8** concurrent SFX voices; same event ⇒ min 50 ms gap; variants pre-rendered (`_v1…_v3`), runtime pitch shift નહીં.
- **Haptics:** Flutter `HapticFeedback` જ (Sound doc §5 haptic column); Settings → Haptics off ⇒ કોઈ call નહીં. Sound / Music / Haptics toggles [06 §11](./06_UI_UX_SCREENS.md).
- **Game 4 rule:** ants અને bees ના sounds હંમેશા અલગ — `path_exit_ground` / `path_exit_air` અને `bump` ના ground/air variants ([Sound doc §9](../../SOUND_EFFECTS_IMPLEMENTATION.md#9-game-wise-sound-design-theme-mapping)).

| Standard event ID | Game 4 themed sound | Game 4 usage |
|---|---|---|
| `path_tap` | Tiny antenna tick (ant) / wing flick (bee) | Line tap accepted |
| `path_exit` → `path_exit_ground` | March pitter-patter | Ant line exits |
| `path_exit` → `path_exit_air` | Soft buzz-away | Bee line exits |
| `bump` (`bump_ground` / `bump_air` variants) | Head "bonk" (tiny, cute) — ant: soil thud tail, bee: wing-flap tail | Bonk on contact frame |
| `locked_tap` | Tiny "tsk" chirp | Dew-stuck / fogged / cover-locked / caged line |
| `heart_lost` | Petal fall | Heart −1 |
| `shield_absorb` | Royal chime | Queen's Royal Shield charge used |
| `booster_hint` / `booster_undo` / `booster_hammer` | Nectar drip shimmer / Dewdrop rewind / Leaf-blower whoosh | Nectar Glow Hint / Dewdrop Rewind / Leaf Blower |
| `gate_open` / `lock_open` / `key_collect` | Petal gate open / Thorn lock untwist / dew-key sparkle | M005, M007, M009 gates / M004, M043, M046 locks |
| `portal_whoosh` | Burrow tunnel whoosh | M008, M044 Burrow Tunnels |
| `lever_toggle` / `rotate` / `switch_click` | Twig snap / daisy spin / clover click | M009, M045 / M013, M034 / M018 |
| `fog_clear`, `mud_stop`, `jump`, `gem_collect` | Mist puff, mud squelch, mushroom boing, crumb/nectar pop | M010, M037, M038, M026 |
| `guardian_hit` / `guardian_defeat` | Web twang / spider scurries away + cheer | M049 Great Orb Spider |
| `win_stinger` / `coins_fly` | Garden chimes + bee hum / honey-coin drip tinkle | Level Complete |
| Music (`music_home`, `music_map`, `music_gameplay_t1…t5`, `music_rush`, `music_finale`, `music_daily`) | Acoustic guitar, flute, birdsong bed (Twilight Garden M040 levels ⇒ softer `t5` mix) | Sound doc §5.6 |

બાકીના event IDs (UI, rewards, Spin, Rush) Sound doc §5 મુજબ — નવું ID બનાવવું નહીં. Audio errors ⇒ `E-AUD-001…003` (§12).

## 8. Ads, IAP & Consent Integration

- **Startup order:** save load → age gate (first run) → `ConsentInformation.instance.requestConsentInfoUpdate` → UMP form (if required) → `MobileAds.instance.initialize()` → `RequestConfiguration(tagForChildDirectedTreatment: child ? TagForChildDirectedTreatment.yes : TagForChildDirectedTreatment.unspecified, maxAdContentRating: child ? MaxAdContentRating.g : null)` → preload rewarded + interstitial.
- **Interstitial gate** (`AdsCubit.onLevelWin`): level ≥ 11 counted; show if `winsSinceInterstitial ≥ 5 && level ≥ 15 && now − lastFullscreenUtc ≥ 120 s && dailyCount < 20 && !vipActive && !hasRewardScreenThisWin`; else keep counter (deferred). Never after fail/daily/rush.
- **Rewarded** placements: `win_2x`, `revive`, `shop_coins` (5/day), `spin_extra` (1/day), `streak_saver`. Reward only on `onUserEarnedReward`.
- **Banner:** `AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width)`; Home, Map, Gameplay (L11+); 8 dp gap + 1 dp divider above banner in gameplay.
- **IAP:** `InAppPurchase.instance.purchaseStream` listener app start પર (પહેલી screen પહેલાં). Coin packs ⇒ `buyConsumable(purchaseParam: PurchaseParam(productDetails: p))`; Starter Pack (one-time) અને VIP subscription ⇒ `buyNonConsumable(purchaseParam: ...)` (plugin subscriptions માટે આ જ API વાપરે). Flow: `PurchaseStatus.purchased/restored` ⇒ server verify (`verifyPurchase`) ⇒ grant ⇒ `completePurchase` (જો `pendingCompletePurchase`). `pending` ⇒ UI pending. **Restore** = `restorePurchases()` (Settings). VIP: `vipActiveUntil` = verified expiry; app start/resume પર re-check.
- Load failures ⇒ exponential backoff (2, 4, 8 s), max 3 retries/session.

## 9. Persistence (Hive, schema v1)

| Box | Fields |
|---|---|
| `progress` | `highestCleared`, `stars[level]`, `adReviveUsed[level]` |
| `wallet` | `coins`, `boosters{hint, undo, shield, hammer}` |
| `streak` | `day`, `cycleSaverUsed`, `lastClaimDayKey`, `totalDays`, `trophyTier`, `frozen` |
| `time` | `lastTrustedUtc`, `lastServerUtc` |
| `ads` | `winsSinceInterstitial`, `lastFullscreenUtc`, `dailyShopAds`, `dailySpinAds`, `dayKey` |
| `iap` | `vipActiveUntil`, `starterPackShown`, `starterPackExpiresUtc` |
| `settings` | `sound`, `music`, `haptics`, `language`, `ageBand`, `reduceMotion`, `reduceDarkness` |
| `dailyBoardCache` | `dayKey → level JSON` (GENERATOR_VERSION freeze, 05 §12 D14; Standard §16.30) |
| `meta` | `saveSchema = 1`, `installId`, `ftueStep` |

- Writes: debounce 300 ms; win / purchase / reward grant ⇒ immediate `flush()`.
- Backup: daily snapshot `progress_bak`, `wallet_bak`; open failure ⇒ restore backup + `E-SAVE-002` non-fatal (§12).
- In-level state saved on pause (attempt resume) — `attempt{level, snapshot, hearts, refillsUsed, shield, caps}`.

## 10. Analytics

Standard minimum ([§15](../../SHARED_CORE_STANDARD.md)): `level_start{level, attempt}`, `level_win{level, moves, hearts_lost, stars, duration_s}`, `level_fail{level, moves}`, `booster_use{type, level}`, `revive{type, level}`, `ad_show{format, placement}`, `iap_purchase{sku}`, `daily_clear{dayKey, modifier}`, `streak_update{day}`, `ftue_step{step}`.
Game 4 extras: `level_win.bee_lines`, `bump{level, layer}`, `locked_tap{level, reason}`, `rush_end{level, coins, cleared}`, `streak_saver{type}`. Child ageBand ⇒ `setAnalyticsCollectionEnabled` મુજબ personalization off.

## 11. Performance Budget

| Metric | Target |
|---|---|
| Low-tier Android (2 GB, Redmi 9A class), 30 lines | **60 fps** |
| ProMotion iOS / 120 Hz Android | **120 fps** |
| Frame raster p95 (mid-tier) | **< 8 ms** |
| Cold start → Home | ≤ 2.5 s mid-tier |
| Level load (JSON parse + cache picture) | ≤ 150 ms |
| Memory (gameplay) | ≤ 250 MB low-tier |
| On-device Hint solver | ≤ 50 ms, 50k nodes |

Rules: static board picture cache; per-frame માત્ર moving layer repaint; pre-baked shadows; sprite atlases (≤ 2048²); no per-frame allocations in `paint` (Paints are fields); `Color.withValues(alpha:)`.

Device matrix: Redmi 9A (Android 10, 2 GB) · Samsung Galaxy A14 · Redmi Note 12 · Pixel 8 (120 Hz) · iPhone SE 2nd gen · iPhone 15 Pro (ProMotion) · Galaxy Tab A8 (4:3-ish 16:10) · iPad 9th gen (4:3).

## 12. Error Handling

બધા errors [LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md) મુજબ: `AppLogger` (ring buffer 300 entries + rotating file + Crashlytics breadcrumbs/non-fatals), stable error codes (`packages/puzzle_core/lib/logging/codes.dart`), `TapLoggerScope` `MaterialApp.builder` માં wrap (દરેક tap `I-TAP`, dead/rage/slow taps), level session replay upload on game/level errors. Error dialogs માં "Report" button ⇒ Settings → Help → "Report a problem" flow.

| Failure | Code | Handling |
|---|---|---|
| Level JSON missing / parse fail | `E-LVL-001` | Non-fatal + **"Level unavailable"** dialog with **Retry** (reload asset). Level **ક્યારેય skip કે cleared mark નહીં**; Map પર એ જ level current રહે |
| Level JSON schema mismatch | `E-LVL-002` | Same as above ("Level unavailable" + Retry) |
| Daily generator 64 attempts fail | `E-LVL-003` | `daily_fallback.json` Classic board |
| Hint solver timeout / isolate error | `E-LVL-004` | "Try Dewdrop Rewind" toast, Hint **not consumed** |
| Invariant violated (hearts < 0, line on 2 cells of one layer, …) | `E-GAME-001` | Non-fatal + replay; value clamp, game continues |
| Move rejected unexpectedly / stuck animation > 2 s | `E-GAME-002` / `E-GAME-003` | Snap to final state, log replay |
| Soft-lock (no winning sequence, level not lost) | `E-GAME-004` | "Stuck" sheet: Dewdrop Rewind (Undo) / Restart; heart loss નહીં, fail screen નહીં |
| Save box open fail / corrupt | `E-SAVE-001` / `E-SAVE-002` | Restore `_bak` backup, game continues; else fresh save with `installId` retained |
| Save migration / write fail | `E-SAVE-003` / `E-SAVE-004` | Retry next flush; error dialog only if repeated |
| Ad load / show fail, no-fill | `W-ADS-001` / `W-ADS-002` | Buttons disabled "Ad unavailable"; backoff (2, 4, 8 s, max 3) |
| Ad reward not granted after completion | `E-ADS-003` | Grant once (idempotent per placement) |
| IAP error / cancelled, verify fail, pending > 24 h, restore fail | `E-IAP-001…004` | Toast, no grant; pending ⇒ grant on stream event; verify retried on connectivity (token logged only as hash) |
| Server time / Remote Config fetch fail | `W-NET-001` / `W-NET-002` | Cached / bundled defaults |
| Clock tamper / skew | `W-TIME-001` / `W-TIME-002` | Time-travel lock (05 §9) |
| Audio asset missing / pool / playback | `E-AUD-001…003` | Sound skipped, game continues |
| FlutterError / image decode | `E-UI-001` / `E-UI-002` | Non-fatal; fallback widget |
| Level jank / slow load / memory | `W-PERF-001…003` | Perf trace `level_load`, dashboard |

## 13. QA Checklist

Status column: બધા **Not run** (કોઈ item execute થયું નથી).

| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-R01 | Rules: exit | 5×5, single ant line, clear lane, tap body middle cell | Line marches off ≤ 450 ms, Moves +1, line removed | Not run |
| QA-R02 | Rules: bump | Ant lane blocked by ant line; tap | Head bonks at blocker, returns to original cells, Hearts −1, Moves +1 | Not run |
| QA-R03 | Layer: ant over bee | Bee body in ant's lane | Ant exits (no bump) — LR-2 | Not run |
| QA-R04 | Layer: bee over ant | Ant body in bee's lane | Bee exits — LR-2 | Not run |
| QA-R05 | Layer: ground obstacle | Pebble (`tall:false`) in ant lane and in bee lane | Ant bumps; bee flies over | Not run |
| QA-R06 | Layer: tall obstacle | Sunflower Stalk (`tall:true`) in bee lane | Bee bumps −1 heart | Not run |
| QA-R07 | Layer: ant-only mechanic | Bamboo One-Way (wrong dir) in bee lane | Bee unaffected | Not run |
| QA-R08 | Cover lock | Bee covers 1 ant cell; tap uncovered ant cell | Locked wobble, no Move, no heart; after bee exits ant tappable | Not run |
| QA-R09 | Tap priority | Tap cell with bee over ant | Bee receives tap | Not run |
| QA-R10 | Control priority | Tap daisy cell holding ant head | Daisy rotates (1 Move); tap other body cell ⇒ exit | Not run |
| QA-R11 | Locked taps | Dew-stuck, fog, out-of-order, cage, ghost | Wobble + tsk, no Move, no heart | Not run |
| QA-R12 | Input queue | Tap 3 lines during animation | Only last tap processed after animation | Not run |
| QA-R13 | Preview | Long-press 350 ms then release | Dotted lane (green/red + ✓/✕; wavy for bees); no tap fires; no Move | Not run |
| QA-R14 | Win | Clear all lines incl. bees + gems goal | Level Complete after sparkle | Not run |
| QA-R15 | Determinism | Replay same Move sequence twice | Identical final state hash | Not run |
| QA-R16 | Exits | L1–200 levels | No interior exits; edge-only (M020 from L201) | Not run |
| QA-R17 | Tick order | Level with M007, M017, M025, M027, M041 + M021; make 1 Move; repeat with Undo | Ticks in §3 order (Standard §16.17); M021 uses pre-increment parity; win check before 0-heart check | Not run |
| QA-B01 | Hint | Use Hint on solution prefix | Correct next Move glows; Move not counted; count −1 | Not run |
| QA-B02 | Hint off-path | Diverge from solution, use Hint | On-device solver ≤ 50 ms result; fail ⇒ toast, not consumed | Not run |
| QA-B03 | Hint cap | Use 4th Hint in attempt | Blocked "Max for this try" | Not run |
| QA-B04 | Undo | Exit then Undo | Line returns, Moves −1, counters revert | Not run |
| QA-B05 | Undo heart | Bump then Undo | Moves revert, heart **not** restored | Not run |
| QA-B06 | Undo after Leaf Blower | Make 2 Moves, use Leaf Blower, then Undo; make 1 Move, Undo twice | Undo history cleared by Leaf Blower (button disabled); later Undo reverts only post-hammer Move; hammered item never returns, Leaf Blower never re-applied | Not run |
| QA-B07 | Shield | Activate, bump twice, bump third | First 2 absorbed (no heart, stars unaffected), third −1 | Not run |
| QA-B08 | Shield lapse | Activate, win with 1 charge, next attempt | Charge gone | Not run |
| QA-B09 | Leaf Blower line | Target covered cell; target uncovered cell of a covered ant line; target fogged line | Bee removed (non-lane exit hooks fire); covered ant and fogged line not valid targets (not consumed) | Not run |
| QA-B14 | Leaf Blower exit triggers | Hammer key line, Dew-Stuck neighbour, spider-linked line; hammer line whose lane crosses gem/clod/Dry Leaf Bridge | Key unlock, M003 adjacency, spider HP fire; gems not collected, clod HP and bridge crossing unchanged | Not run |
| QA-B15 | Leaf Blower last line with gems | M026 level, gems remain, 1 line left | Leaf Blower disabled on that line | Not run |
| QA-B10 | Leaf Blower obstacle | Target pebble, Twig Fence, dirt clod, Patrolling Ladybug, one Creeping Moss cell, broken Dry Leaf Bridge; target lock, gate, daisy, Brick Edging, spider | First six removed (moss: only that cell); others not targetable | Not run |
| QA-B11 | Leaf Blower cap | 3rd use in attempt | Blocked | Not run |
| QA-B12 | Booster unlock | Open L5 booster bar | Shield/Leaf Blower locked icons | Not run |
| QA-B13 | Count 0 | Tap booster with 0 | Mini shop sheet | Not run |
| QA-H01 | Second Chance | Lose 3 hearts | Popup with 10-s ring | Not run |
| QA-H02 | Ad revive once/level | Revive by ad, fail again, restart, fail | Ad option "Used" until level cleared | Not run |
| QA-H03 | Heart Refill | 120 coins ×2 then third | 2 allowed per attempt, third hidden | Not run |
| QA-H04 | Revive continuity | Revive | Board not reset | Not run |
| QA-H05 | Ad unavailable | Airplane mode | Ad disabled "Ad unavailable", coin option works | Not run |
| QA-H06 | Fail | Let countdown expire | Level Failed; Retry free with 3 hearts | Not run |
| QA-S01 | Stars | 0 / 1 / 2 hearts lost; any revive | ★★★ / ★★ / ★ / ★ | Not run |
| QA-S02 | Stars replay | Improve ★ on replay | Stars update, 0 coins | Not run |
| QA-C01 | Clear coins | First clear `tag` easy / normal (incl. `slot: intro`) / hard / finale | 15/20/30/50 | Not run |
| QA-C02 | Triple bonus | First ★★★ | +20 once | Not run |
| QA-C03 | 2X | Watch 2X ad | Base clear doubled, star bonus not | Not run |
| QA-G01 | Gift Box | Clear L10, L20, L40, L110, L490 | 150 + Hint, 150 + Leaf Blower (kept locked till L25), 150 + Undo, 180 + Shield, 300 + Hint (`(L/10) mod 4`) | Not run |
| QA-G02 | Chest | Clear L500 | 1,000 + 2 each booster + badge, no Gift Box | Not run |
| QA-G03 | Rush trigger | Clear L25, L50 | Rush after L25; at L50 Gift Box first then Rush | Not run |
| QA-G04 | Rush rules | Play Rush after L25, L125, L225, L325, L425; bump once; Skip mid-way; replay L25 | Lines 20/22/25/28/30 (tier table); 30 s, 10/line, +100 on full clear; bump = wobble, no heart; Skip keeps collected coins; no Rush on replay | Not run |
| QA-G05 | Rush ads | Finish Rush | No interstitial | Not run |
| QA-D01 | Daily unlock | Before/after L15 | Locked / available | Not run |
| QA-D02 | Daily pool | highestCleared 45 | No bees, Fri/Thu fallback Classic | Not run |
| QA-D03 | Daily seed | Two devices same dayKey + bracket | Identical puzzle | Not run |
| QA-D04 | Modifiers | Force each weekday at Ld 35 and Ld 495 | Mon–Sun rules; locked Thu/Fri/Sun modifiers ⇒ Classic | Not run |
| QA-D06 | Daily win screen | Clear Daily | No 2X Win offer; no interstitial | Not run |
| QA-D07 | Daily ad revive | Revive by ad, fail, retry same dayKey | Ad revive "Used" for that dayKey (`daily:<dayKey>`) | Not run |
| QA-D05 | Reward once | Clear daily twice | +100 + streak once | Not run |
| QA-K01 | Streak ladder | Clear 7 consecutive days | 50/75/100+H/125+2U/150+S/200+LB/450+H+S+LB+trophy | Not run |
| QA-K02 | Saver | Miss 1 day, return; (b) ignore offer and clear Daily | Queen's Favor offer (ad / 200); saver keeps index, missed reward not given; (b) offer gone, Day 1 | Not run |
| QA-K03 | Saver once/cycle | Miss again same cycle | Day 1 reset | Not run |
| QA-K04 | 2+ miss | Miss 2 days | Day 1, no offer | Not run |
| QA-K05 | Cycle | After Day 7 (×6 cycles) | Day 1, totalDays continues, trophy Bronze → Silver → Gold → Platinum → Diamond → Diamond | Not run |
| QA-A01 | Time travel | Set clock back 1 day | Daily/Streak/Spin locked | Not run |
| QA-A02 | 20 h rule | Claim at 23:59, again 00:01 | Second claim blocked | Not run |
| QA-A03 | Offline verify | Claim offline, go online with mismatch | Streak frozen, coins kept | Not run |
| QA-P01 | Shop coins | Buy each booster single/3-pack | Prices 60/150, 40/100, 80/200, 100/250 | Not run |
| QA-P02 | IAP | Buy coins S/M/L/XL (test accounts) | 350/1,000/2,200/5,500 after verify | Not run |
| QA-P03 | Starter Pack | Clear L15; wait 48 h | Offer visible 48 h then gone; content correct | Not run |
| QA-P04 | VIP | Subscribe | Interstitial + banner off; rewarded still offered | Not run |
| QA-P05 | VIP expiry | Let test sub expire | Ads return | Not run |
| QA-P06 | Restore | Reinstall, Restore | VIP + one-time items restored | Not run |
| QA-P07 | Free coins | Watch 6 shop ads | 5 × +50, 6th disabled | Not run |
| QA-P08 | Spin | Before / after L10 clear; free + ad spin; third | Locked before L10 clear; 2/day max; odds screen present | Not run |
| QA-V01 | Interstitial L1–10 | Win L1–10 | None | Not run |
| QA-V02 | Cadence | Win L11–L25 | First at L15 (if cooldown ok); every 5 wins; deferred on Gift/Rush wins | Not run |
| QA-V03 | Cooldown | Rewarded ad then eligible win < 120 s | Interstitial skipped | Not run |
| QA-V04 | Banner | Gameplay L10 vs L11 | None / present with 8 dp gap + divider | Not run |
| QA-V05 | Daily cap | 21 eligible | Max 20 interstitials/day | Not run |
| QA-X01 | Age gate | First launch | Birth year picker, no default | Not run |
| QA-X02 | Under-13 | Enter child year | Child-directed, rating G, analytics personalization off | Not run |
| QA-X03 | UMP | EEA test device | Consent form before any ad request | Not run |
| QA-X04 | Privacy options | Settings → Privacy options | UMP form re-opens | Not run |
| QA-F01 | Persistence | Kill app mid-level | Resume attempt state | Not run |
| QA-F02 | Save corruption | Corrupt box file | Backup restored | Not run |
| QA-F03 | Counters persist | Kill app after 3 wins | `winsSinceInterstitial` = 3 | Not run |
| QA-O01 | Offline | Airplane mode full session | Levels, daily, spin play; ads/IAP disabled gracefully | Not run |
| QA-M01 | Perf low-tier | Redmi 9A, 30-line T5 level, 2 min | ≥ 60 fps sustained, no jank > 2 frames | Not run |
| QA-M02 | Perf 120 Hz | Pixel 8 / iPhone 15 Pro | 120 fps, raster p95 < 8 ms | Not run |
| QA-M03 | Wing flutter | Record 240 fps video at 60 Hz and 120 Hz devices | Visibly 12 Hz flutter, no strobe/aliasing, same speed | Not run |
| QA-M04 | Device matrix | Run smoke on all §11 devices | Layout fits, cell ≥ 29 dp (11×11), no overlap | Not run |
| QA-Y01 | Color-blind | Deuteranopia simulator | Glyphs distinguish all colors; preview ✓/✕ | Not run |
| QA-Y02 | Text scale | System font 1.3 | No clipping in popups | Not run |
| QA-Y03 | Tap targets | Inspect UI | All controls ≥ 48 dp | Not run |
| QA-Y04 | Reduce motion | Toggle | Bob off, flutter ½, shake off | Not run |
| QA-Y05 | Screen reader | TalkBack/VoiceOver | Buttons and lines announced | Not run |
| QA-L01 | Localization | Switch en/gu/hi | All strings translated, fonts render | Not run |
| QA-MECH-M001 | M001 Garden Pebble (unit + golden) | Pebble in ant lane; same pebble in bee lane; tall Sunflower Stalk in bee lane; Leaf Blower pebble | Ant bump; bee clear; bee bump; pebble removed | Not run |
| QA-MECH-M002 | M002 Twig Fence (unit + golden) | 3-cell Twig Fence across ant lane; Bramble Row (tall) across bee lane; Leaf Blower | Ant bump; bee bump on Bramble; whole wall removed | Not run |
| QA-MECH-M003 | M003 Dew-Stuck Line (unit + golden) | Dew-stuck K=2 with 1 ant + 1 bee adjacent; exit both | Locked until both exit (cross-layer adjacency counts); badge 2→1→0 | Not run |
| QA-MECH-M032 | M032 Bee Lines (Air Layer) (unit + golden) | 2-layer board: bee over ant, bee lane over ant body, ant lane under bee | LR-2 no collisions; LR-6 cover lock; LR-7 tap goes to bee | Not run |
| QA-MECH-M005 | M005 Petal Gate (unit + golden) | Pink Petal Gate: pink ant, blue ant, blue bee (gate tall:false), blue bee (gate tall:true) | Pass; bump; pass; bump | Not run |
| QA-MECH-M006 | M006 Bamboo One-Way Tube (unit + golden) | One-way R; ant lane R, ant lane L, bee lane L | Pass; bump; bee unaffected | Not run |
| QA-MECH-M007 | M007 Morning Glory Gate (unit + golden) | Gate N=3, ant lane through; tap 3 other lines; Undo once | Blocked until 3 Moves then open permanently; Undo restores N | Not run |
| QA-MECH-M008 | M008 Burrow Tunnel Pair (unit + golden) | Portal pair; ant enters A; ant body on B; bee lane over A | Continues from B; blocked; bee unaffected | Not run |
| QA-MECH-M009 | M009 Twig Lever & Vine Gates (unit + golden) | Lever + 2 gates (1 tall); tap lever; Undo | Gates flip (Move +1); bee blocked only by tall closed gate; Undo reverts | Not run |
| QA-MECH-M010 | M010 Morning Mist (unit + golden) | Fog area with hidden ant + bee; exit touching line | Hidden lines locked & not Hint/Leaf Blower targets; area clears on exit | Not run |
| QA-MECH-M011 | M011 Petal-Linked Pair (unit + golden) | Ant pair one lane blocked; clear both | Both bump, −1 heart total; both exit in 1 Move; Leaf Blower removes both | Not run |
| QA-MECH-M012 | M012 Napping Line (unit + golden) | Napping bee: tap, tap | 1st = wake (Move +1, no lane check); 2nd = exit | Not run |
| QA-MECH-M013 | M013 Spinning Daisy (unit + golden) | Daisy under ant head; tap daisy; tap other body cell; rotate until head points into own body | dir 90° CW (Move +1); exit along new dir; head into own body ⇒ "tangled" locked tap (no bump, no heart) | Not run |
| QA-MECH-M014 | M014 Curled Leaf Deflector (unit + golden) | `/` leaf: ant R, bee R with tall false, bee R with tall true | Ant turns U; bee straight; bee turns U | Not run |
| QA-MECH-M015 | M015 Twig Bridge (unit + golden) | H bridge with ant on it; V ant lane passes under | Pass (no bump); bees unaffected | Not run |
| QA-MECH-M016 | M016 Crumbly Dirt Clod (unit + golden) | Clod HP 2; 2 ant exits passing adjacent; 1 bee exit adjacent | HP 2→1→0 removed; bee exit no damage | Not run |
| QA-MECH-M017 | M017 Rain-Alert Line (unit + golden) | Rain-alert N=3; make 3 other Moves; with Shield | At 0: −1 heart, reset to 3; Shield absorbs instead | Not run |
| QA-MECH-M018 | M018 Clover Switch (unit + golden) | Clover switch L; tap switch; ant lane through | Toggle R (Move +1); ant lane turns accordingly; bee unaffected | Not run |
| QA-MECH-M019 | M019 Acorn Pressure Plate (unit + golden) | Ant on plate, gate open; ant exits; bee on plate | Gate closes after ant exit; bee body doesn't press plate | Not run |
| QA-MECH-M020 | M020 Anthill & Hive Entrance (unit + golden) | Anthill + Hive; ant lane to Hive cell; bee lane to Hive | Ant passes under hive (to anthill/edge); bee exits into hive | Not run |
| QA-MECH-M021 | M021 Hide-and-Seek Line (unit + golden) | Phasing line at even/odd Move count | Even solid/tappable; odd ghost (locked tap, non-blocking own layer) | Not run |
| QA-MECH-M022 | M022 Backward-Walking Line (unit + golden) | Reverse line, tail lane clear, head lane blocked | Exits tail-first | Not run |
| QA-MECH-M023 | M023 Two-Way Scout Line (unit + golden) | Two-head line len 4; tap index 0, 3, middle | Exits head end; tail end; head end at exact middle | Not run |
| QA-MECH-M024 | M024 Double-File Line (unit + golden) | Wide ant line; 1 strip blocked | Bump; both strips clear ⇒ exit | Not run |
| QA-MECH-M025 | M025 Patrolling Ladybug (unit + golden) | Ladybug loop 4; ant body on next loop cell; Leaf Blower ladybug | Moves 1/Move; waits when blocked; bee lanes ignore; ladybug removed (hammerable) | Not run |
| QA-MECH-M026 | M026 Sugar Crumbs & Nectar Drops (unit + golden) | Sugar Crumb (layer 0) on bee lane; Nectar Drop on bee lane | Not collected by bee; collected; win requires all | Not run |
| QA-MECH-M027 | M027 Creeping Moss (unit + golden) | Moss N=2 with free neighbours U,R; Leaf Blower one moss cell | Grows U first every 2 Moves (oldest cell first); ant lanes blocked; bees not; only targeted cell removed | Not run |
| QA-MECH-M028 | M028 Marching Order (unit + golden) | Numbered 1 (bee), 2 (ant): tap 2 first | Locked tap; after 1 exits, 2 exits | Not run |
| QA-MECH-M029 | M029 Brick Edging (unit + golden) | Edge wall tall:false; ant and bee lanes to it; tall:true | Ant bump, bee exits; with tall both bump; not hammerable | Not run |
| QA-MECH-M030 | M030 Painted Garden Gate (unit + golden) | Red Painted Gate edge; blue ant; blue bee (tall false/true) | Ant bump; bee exits / bumps | Not run |
| QA-MECH-M031 | M031 Latching Gate (unit + golden) | Latching gate N=2, ant exits after 3 Moves | Bump after closure | Not run |
| QA-MECH-M004 | M004 Dew Key & Thorn Lock (unit + golden) | Blue lock (tall true) + key on bee line; bee exits; ant/bee lanes through lock | Before: both blocked; after key exit: open permanently; Leaf Blower can't target lock | Not run |
| QA-MECH-M033 | M033 Flower-Bud Cage (unit + golden) | Pink cage; 1 pink ant + 1 pink bee remain | Locked until both exit | Not run |
| QA-MECH-M034 | M034 Lily-Pad Rotor (unit + golden) | Rotor with 1 ant fully inside + 1 bee partially | Locked tap (partial); remove partial ⇒ rotate CW contents | Not run |
| QA-MECH-M035 | M035 Brood Line (unit + golden) | Brood ant exits, spawn cells occupied then freed | Child waits, spawns when free, same layer | Not run |
| QA-MECH-M036 | M036 Hungry Line (unit + golden) | Hungry bee lane clear but passes Snack Crumb (layer 0) only | **Bump −1 heart** (not locked tap); with Clover Blossom ⇒ exits, food consumed | Not run |
| QA-MECH-M037 | M037 Mud Puddle (unit + golden) | Ant lane hits mud; tap again; bee over mud | Stops at mud (Move); 2nd tap continues; bee unaffected | Not run |
| QA-MECH-M038 | M038 Mushroom Spring (unit + golden) | Spring then pebble then free; spring then tall stalk | Ant jumps pebble; bumps on tall | Not run |
| QA-MECH-M039 | M039 Mirror-Twin Lines (unit + golden) | Mirror twins axis V, one blocked | Both bump −1 total; clear ⇒ both exit mirrored | Not run |
| QA-MECH-M040 | M040 Twilight Garden (unit + golden) | Twilight level; long-press line | Only lit area visible; rules unchanged; preview lit | Not run |
| QA-MECH-M041 | M041 Rainbow Pollen Line (unit + golden) | Chameleon red at Move 0, Petal Gate green | Tap at Move 1 ⇒ green passes; at Move 0 bump | Not run |
| QA-MECH-M042 | M042 Dry Leaf Bridge (unit + golden) | Dry Leaf Bridge; 2 crossings | 1st passes; becomes Fallen Leaf blocker (hammerable) | Not run |
| QA-MECH-M043 | M043 Bramble Multi-Lock (unit + golden) | Multi-lock 2 keys (ant + bee) | Opens only after both key lines exit | Not run |
| QA-MECH-M044 | M044 Twisting Burrow (unit + golden) | Twisting burrow CW; ant enters A moving R | Exits B moving D | Not run |
| QA-MECH-M045 | M045 Root Gear Lever (unit + golden) | Gear lever linked to 2 daisies (ant head + bee head) | Both rotate in 1 Move; Undo reverts both | Not run |
| QA-MECH-M046 | M046 Ring-Around Line (unit + golden) | Loop line + key line | Locked until key exits, then opens at marked head and exits normally | Not run |
| QA-MECH-M047 | M047 Recruiting Line (unit + golden) | Recruiting bee N=2, free cell behind / blocked | Grows every 2 Moves; no growth when blocked | Not run |
| QA-MECH-M048 | M048 Colony Call (unit + golden) | Yellow group: 2 ants + 1 bee, 1 bee blocked | All bump −1 total; Leaf Blower removes only target | Not run |
| QA-MECH-M049 | M049 Great Orb Spider (unit + golden) | Spider HP 3 linked (2 ants + 1 bee); ant & bee lanes into web | Both bump (tall); each linked exit −1 HP; 0 ⇒ cells free; not hammerable | Not run |
| QA-MECH-FIN | L500 Queen's Garden Gala | Solve with reference solution; replay with solver | Solvable 0 hearts / 0 boosters; Chest + Rush flow | Not run |
| QA-CI01 | Level validator | Run `tools/validator` on `phase_1.json.gz` | All 500 levels pass §14 checks; report artefact | Not run |
| QA-CI02 | Validator negative | Inject: bee on tall cell; M004 at L100; tall at L30; unsolvable level | Each rejected with specific error code | Not run |
| QA-CI03 | Daily seeds | Pre-validate next 400 dayKeys × 50 brackets | All produce valid puzzle within 64 attempts or fallback logged | Not run |
| QA-E01 | Corrupt level JSON | Corrupt / delete one level asset (debug), open it | `E-LVL-001` logged; "Level unavailable" + Retry; level **not** skipped or marked cleared | Not run |
| QA-E02 | Soft-lock | Debug-force a state with no winning sequence | "Stuck" sheet (Undo / Restart), no heart loss, `E-GAME-004` | Not run |
| QA-E03 | Settings / diagnostics | Toggle Sound, Music, Haptics, Share diagnostics; Help → Report a problem | Each applies immediately and persists; diagnostics off ⇒ no upload; Report ID shown | Not run |
| QA-AUD | Audio (shared suite) | Run shared suite AUD-01…AUD-24 ([Sound doc §11](../../SOUND_EFFECTS_IMPLEMENTATION.md#11-qa-checklist-status-not-run)) for this game; AUD-23: ant vs bee exit/bump | All pass | Not run |
| QA-LOG | Logging (shared suite) | Run shared suite LOG-01…LOG-22 ([Logging doc §15](../../LOGGING_AND_ERROR_TRACKING.md#15-qa-checklist-status-not-run)) for this game | All pass | Not run |

Unit tests per M-ID: `packages/puzzle_core/test/mechanics/mXXX_test.dart` — દરેક file માં (a) rule happy path, (b) ants-vs-bees layer behaviour (card ના Ants/Bees/Tall fields), (c) Undo round-trip, (d) solver golden level. Coverage target `puzzle_core` ≥ 90% lines.

## 14. Level Validator (CI)

`tools/validator` (Dart CLI, `puzzle_core` reuse) દરેક PR પર, level JSON કે `puzzle_core` બદલાય ત્યારે:

| Code | Check |
|---|---|
| V01 | Schema v3 parse; `body[0]` head; coordinates in grid |
| V02 | Solvable with **0 hearts lost, 0 boosters** (solver BFS/IDA*, node limit 2M, depth ≤ 3×P) |
| V03 | D within slot band ±3 (Standard §9.4) |
| V04 | No line initially locked forever (incl. LR-6 cover lock, cages, loops) |
| V05 | Min cell ≥ 29 dp at 360×640 reference (Phase 1 grids ≤ 11×11) |
| V06 | Intro levels: intro mechanic + ≤ 1 earlier mechanic |
| V07 | L1–40 `layers: 1`; no `type: "M004"` before L321; `tall: true` only L42+ |
| V08 | LR-8: per layer ≤ 1 body per cell; no bee body on `tall: true` cell |
| V09 | Mechanic-specific rules ([03 §4](./03_OBSTACLE_CATALOG_PHASE_1.md)) |
| V10 | L1–3 optimal ≤ 4 Moves; L4–10 ≤ 8 Moves |
| V11 | `solution` replays to win; `par_moves` = solution length |
| V12 | `slot` + `tag` both present and consistent (Standard §16.15): x1 `intro`/`normal`, x2–x4 `practice`/`normal`, x5 `breather`/`easy`, x6–x8 `ramp`/`normal`, x9 `hard`/`hard` (L9 `ramp`/`normal`), x0 `milestone`/`normal`, L500 `finale`/`finale` |

Failures ⇒ PR blocked; report `validator_report.json` artefact. Phase 3+ seeds validation: [SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md).
