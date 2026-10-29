# 07 · Frontend Implementation & QA — Toy Trains: Wooden Railway Puzzle
> હેતુ: Flutter app ની architecture, folder tree, BLoCs, game loop + renderer (trains & tracks), input, audio/haptics, ads/IAP/consent, persistence, analytics, performance, error handling અને **QA checklist** (બધા items status "Not run").

**Related docs:** [Shared Core Standard §12–§15](../../SHARED_CORE_STANDARD.md) · [Sound Effects Standard](../../SOUND_EFFECTS_IMPLEMENTATION.md) · [Logging & Error Tracking Standard](../../LOGGING_AND_ERROR_TRACKING.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md)

---

## 1. Architecture

| Area | Decision (standard §13) |
|---|---|
| Framework | Flutter 3.x stable, Dart 3, Impeller |
| Rendering | `CustomPainter` + `Ticker`-driven loop (**Flame નહીં**) |
| State | `flutter_bloc` (Riverpod નહીં) |
| Engine | `packages/puzzle_core` (pure Dart, shared by all four games): board model, rules, mechanics M001–M049, solver, generator, xoshiro128** PRNG |
| Persistence | `hive_ce` typed adapters, save schema v1 |
| Ads / consent | `google_mobile_ads` (UMP included) |
| IAP | `in_app_purchase` + Firebase Function `verifyPurchase` |
| Analytics / crash / config | `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` |
| Leaderboards | `games_services` |
| Audio | `audioplayers` (`AudioService` + `AudioPool` for SFX) — [Sound Effects Standard](../../SOUND_EFFECTS_IMPLEMENTATION.md) |
| Logging / errors | `AppLogger` + Crashlytics + `firebase_performance`, `TapLoggerScope` — [Logging Standard](../../LOGGING_AND_ERROR_TRACKING.md) |
| Haptics | Flutter `HapticFeedback` (third-party vibrate package નહીં) |
| Localization | `flutter_localizations` + ARB: English, ગુજરાતી, हिन्दी |

Layering: **UI (widgets) → BLoCs → services/repositories → puzzle_core**. `puzzle_core` has no Flutter import; the game app only maps engine events to animations.

## 2. Folder Tree

```
repo/
├─ packages/puzzle_core/
│  ├─ lib/src/model/        board.dart, cell.dart, path.dart, mechanic.dart, level.dart
│  ├─ lib/src/rules/        move_resolver.dart, lane_tracer.dart, tick_order.dart
│  ├─ lib/src/mechanics/    m001_single_blocker.dart … m049_guardian.dart
│  ├─ lib/src/solver/       bfs_solver.dart, hint_service.dart
│  ├─ lib/src/gen/          generator.dart, difficulty.dart, xoshiro128ss.dart
│  └─ test/                 rules/, mechanics/m001_test.dart … m049_test.dart, solver/
├─ tools/levelgen/          Dart CLI: generate, validate, pack phase_1.json.gz
└─ apps/toy_trains/
   ├─ assets/levels/phase_1.json.gz
   ├─ assets/daily/silhouettes.json
   ├─ assets/audio/  assets/images/  assets/fonts/
   ├─ lib/
   │  ├─ main.dart  app.dart  router.dart
   │  ├─ theme/            tokens.dart, train_palette.dart
   │  ├─ game/
   │  │  ├─ bloc/          game_bloc.dart, game_event.dart, game_state.dart
   │  │  ├─ render/        board_picture_cache.dart, train_board_painter.dart, train_route.dart
   │  │  ├─ input/         board_gesture_layer.dart
   │  │  └─ widgets/       hud.dart, booster_bar.dart, second_chance.dart
   │  ├─ features/         home/, level_map/, daily/, streak/, spin/, shop/, vip/,
   │  │                    rush/, gift/, leaderboards/, settings/, consent/
   │  ├─ services/         ads_service.dart, iap_service.dart, audio_service.dart,
   │  │                    haptics_service.dart, analytics_service.dart, time_service.dart,
   │  │                    remote_config_service.dart, level_repository.dart
   │  └─ data/             save_repository.dart, hive_adapters.dart
   └─ test/  integration_test/
```

## 3. BLoCs, States & Events

| BLoC / Cubit | Events / methods | State (key fields) |
|---|---|---|
| `GameBloc` | `LevelStarted(level|daily)`, `CellTapped(cell)`, `PreviewStarted(cell)`, `PreviewEnded`, `BoosterPressed(type)`, `CraneTargetTapped(cell)`, `AnimationFinished`, `ReviveByAd`, `HeartRefill`, `SecondChanceDeclined`, `RestartPressed`, `Paused/Resumed` | `status {loading, idle, animating, craneTarget, secondChance, won, failed}`, `board`, `hearts`, `shieldCharges`, `moveCount`, `history`, `boostersUsed{type:count}`, `refillsThisAttempt`, `pendingTap`, `preview`, `hintTarget`, `lastEvent` |
| `WalletCubit` | `add(coins, source)`, `spend(coins, sink)`, `grantBooster`, `consumeBooster` | `coins`, `boosters{hint, undo, shield, hammer}` |
| `ProgressCubit` | `levelCleared(level, stars, tag)` | `highestCleared`, `stars[]`, `adReviveUsed[]`, `giftsClaimed` |
| `RewardFlowCubit` | `onWin(level)` ⇒ ordered queue | queue: `[complete, gift|chest, rush, interstitial?, phaseComplete?]` |
| `RushBloc` | `RushStarted`, `RushTap`, `RushTick(1s)`, `RushEnded` | `remainingSec`, `exited`, `coins` |
| `DailyBloc` | `DailyOpened(dayKey)`, `DailyCleared` | `board`, `modifier`, `claimedToday`, `timeLock` |
| `StreakCubit` | `onDailyClaim`, `offerSaver`, `useSaver(ad|coins)` | `day`, `cycleSaverUsed`, `totalDays`, `trophyTier` |
| `SpinCubit` | `spinFree`, `spinAd` | `freeUsed`, `adUsed`, `lastPrize` |
| `ShopBloc` | `LoadProducts`, `BuyBooster`, `BuyIap(sku)`, `Restore`, `WatchFreeCoins` | `products`, `pending`, `vipActiveUntil`, `dailyShopAds` |
| `AdsCubit` | `onLevelWin(level, hasRewardScreen)`, `onFullscreenShown` | `winsSinceInterstitial`, `lastFullscreenUtc`, `dailyCount` |
| `ConsentCubit` | `ageSubmitted(year)`, `umpCompleted` | `ageBand`, `canRequestAds` |
| `SettingsCubit` | toggles | `sound, music, haptics, language, reduceMotion` |

`GameBloc` uses `puzzle_core.MoveResolver.apply(state, move)` ⇒ returns `MoveOutcome {newState, events[]}`. Events: `TrainExited(id, route)`, `TrainBumped(id, route, contactDistance)`, `InteractiveToggled(id)`, `CounterTicked`, `HeartLost(source)`, `ShieldAbsorbed`, `MechanicChanged(id)`, `Won`. The bloc emits `animating` with the outcome; the view plays it and sends `AnimationFinished`; then queued tap (max 1) is processed.

Booster rules in bloc: Hint cap 3, Shield cap 1 (and only one active), Crane cap 2, Undo uncapped; caps from Remote Config defaults.

## 4. Game Loop

- `GameView` owns one `AnimationController` (vsync `TickerProviderStateMixin`) per move; duration = `min(450 ms, f(distance))` for exits, 400 ms for bumps, 180 ms turntable, 120 ms switch.
- No continuous simulation: frames render only while an animation runs (idle board = cached picture, 0 repaints).
- Decorative loops (steam puffs, Night Run lamps) use a separate low-frequency `Ticker` throttled to 30 fps and only when visible; disabled under Reduce motion.
- App lifecycle `paused` ⇒ complete current animation instantly, save, show Pause on resume.

## 5. Renderer (CustomPainter — trains & tracks)

Static layer (tabletop, grid dots, exit-lane tracks, obstacles, resting trains) is recorded once per board state into a `ui.Picture`. Per frame only the moving train(s) are drawn. Cars follow the **body polyline** (tail → engine) and then the **straight lane** off the board; bump = forward to contact then roll back (`Curves.easeOutBack` overshoot gives the buffer "clack" bounce).

```dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Lightweight view models (mapped from puzzle_core state by the view layer).
class GridCell {
  const GridCell(this.x, this.y);
  final int x;
  final int y;
}

enum Heading { up, down, left, right }

extension HeadingVector on Heading {
  Offset get unit => switch (this) {
        Heading.up => const Offset(0, -1),
        Heading.down => const Offset(0, 1),
        Heading.left => const Offset(-1, 0),
        Heading.right => const Offset(1, 0),
      };
}

enum CarPattern { stripes, dots, chevrons, checks, waves, hatch }

class TrainView {
  const TrainView({
    required this.id,
    required this.color,
    required this.pattern,
    required this.heading,
    required this.body,
  });

  final String id;
  final Color color;
  final CarPattern pattern;
  final Heading heading;
  final List<GridCell> body; // body[0] = engine
}

class BoardGeometry {
  const BoardGeometry({
    required this.origin,
    required this.cellSize,
    required this.cols,
    required this.rows,
  });

  final Offset origin;
  final double cellSize;
  final int cols;
  final int rows;

  Offset centerOf(GridCell c) =>
      origin + Offset((c.x + 0.5) * cellSize, (c.y + 0.5) * cellSize);

  Rect get boardRect => origin & Size(cols * cellSize, rows * cellSize);

  GridCell? cellAt(Offset p) {
    final local = p - origin;
    final x = (local.dx / cellSize).floor();
    final y = (local.dy / cellSize).floor();
    if (x < 0 || y < 0 || x >= cols || y >= rows) return null;
    return GridCell(x, y);
  }
}

/// Arc-length parametrised polyline: tail → … → engine → lane cells → off-board.
class TrainRoute {
  TrainRoute(this.points) : _cum = _cumulative(points);

  final List<Offset> points;
  final List<double> _cum;

  static List<double> _cumulative(List<Offset> pts) {
    final out = <double>[0];
    for (var i = 1; i < pts.length; i++) {
      out.add(out.last + (pts[i] - pts[i - 1]).distance);
    }
    return out;
  }

  double get length => _cum.last;

  Offset positionAt(double s) {
    if (points.length == 1) return points.first;
    final double d = s.clamp(0.0, length).toDouble();
    var i = 1;
    while (i < points.length - 1 && _cum[i] < d) {
      i++;
    }
    final seg = _cum[i] - _cum[i - 1];
    final t = seg == 0 ? 0.0 : (d - _cum[i - 1]) / seg;
    return Offset.lerp(points[i - 1], points[i], t)!;
  }

  /// Heading smoothed over a small window so cars rotate gradually on bends.
  double angleAt(double s, double window) {
    final a = positionAt(s - window);
    final b = positionAt(s + window);
    return math.atan2(b.dy - a.dy, b.dx - a.dx);
  }
}

/// Builds the route for [train] given the lane cells returned by puzzle_core
/// (already following tunnels/curves/switches) and the final travel heading.
TrainRoute buildRoute(
  TrainView train,
  List<GridCell> lane,
  Heading finalHeading,
  BoardGeometry g,
) {
  final pts = <Offset>[for (final c in train.body.reversed) g.centerOf(c)];
  for (final c in lane) {
    pts.add(g.centerOf(c));
  }
  // Extend past the edge far enough for the tail car to leave the board.
  pts.add(pts.last + finalHeading.unit * (g.cellSize * (train.body.length + 1)));
  return TrainRoute(pts);
}

/// One moving train: exit (travel to route end) or bump (to contact, then back).
class MovingTrain {
  MovingTrain.exit(this.train, this.route, this.cellSize)
      : contactDistance = null;
  MovingTrain.bump(this.train, this.route, this.cellSize, double contact)
      : contactDistance = contact;

  final TrainView train;
  final TrainRoute route;
  final double cellSize;
  final double? contactDistance; // engine travel until buffers touch

  bool get isBump => contactDistance != null;

  /// Distance travelled by every car at animation progress [t] in 0..1.
  double travelAt(double t) {
    if (!isBump) {
      final engineStart = (train.body.length - 1) * cellSize;
      return Curves.easeInCubic.transform(t) * (route.length - engineStart);
    }
    const forwardShare = 0.45;
    if (t < forwardShare) {
      return Curves.easeOut.transform(t / forwardShare) * contactDistance!;
    }
    final back = Curves.easeOutBack.transform((t - forwardShare) / (1 - forwardShare));
    return (1 - back) * contactDistance!;
  }
}

class TrainBoardPainter extends CustomPainter {
  TrainBoardPainter({
    required this.geometry,
    required this.staticBoard,
    required this.progress,
    required this.moving,
  }) : super(repaint: progress);

  final BoardGeometry geometry;
  final ui.Picture staticBoard; // tabletop + tracks + obstacles + resting trains
  final Animation<double> progress;
  final List<MovingTrain> moving; // 0, 1, or a group (coupled / twins / convoy)

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(staticBoard);
    canvas.save();
    // Clip slightly outside the board so cars visibly roll off the table edge.
    canvas.clipRect(geometry.boardRect.inflate(geometry.cellSize * 0.6));
    for (final m in moving) {
      final travel = m.travelAt(progress.value);
      final n = m.train.body.length;
      final spacing = m.cellSize;
      for (var i = n - 1; i >= 0; i--) {
        final s = (n - 1 - i) * spacing + travel; // car i arc position
        final pos = m.route.positionAt(s);
        final angle = m.route.angleAt(s, spacing * 0.3);
        paintCar(canvas, pos, angle, m.train, isEngine: i == 0, cell: spacing);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(TrainBoardPainter oldDelegate) =>
      oldDelegate.staticBoard != staticBoard ||
      oldDelegate.moving != moving ||
      oldDelegate.geometry != geometry;
}

/// Shared by the painter and the static picture builder.
void paintCar(
  Canvas canvas,
  Offset center,
  double angle,
  TrainView train, {
  required bool isEngine,
  required double cell,
}) {
  final w = cell * 0.84;
  final h = cell * 0.62;
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.rotate(angle);
  final body = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset.zero, width: w, height: h),
    Radius.circular(cell * 0.16),
  );
  // Pre-baked style shadow: offset darker shape, no blur.
  canvas.drawRRect(
    body.shift(Offset(0, cell * 0.06)),
    Paint()..color = const Color(0xFF5A3E2B).withValues(alpha: 0.25),
  );
  canvas.drawRRect(body, Paint()..color = train.color);
  _paintPattern(canvas, body.outerRect, train.pattern, cell);
  if (isEngine) {
    // Chimney + direction arrow on the cowcatcher (heading = +x after rotate).
    canvas.drawCircle(
      Offset(w * 0.18, 0),
      cell * 0.1,
      Paint()..color = const Color(0xFF2B2B2A),
    );
    final arrow = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.32, -h * 0.22)
      ..lineTo(w * 0.32, h * 0.22)
      ..close();
    canvas.drawPath(arrow, Paint()..color = const Color(0xFFFFFFFF));
  }
  canvas.restore();
}

void _paintPattern(Canvas canvas, Rect r, CarPattern pattern, double cell) {
  final p = Paint()
    ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.55)
    ..strokeWidth = math.max(1.0, cell * 0.05)
    ..style = PaintingStyle.stroke;
  final inner = r.deflate(cell * 0.1);
  switch (pattern) {
    case CarPattern.stripes:
      for (var i = 1; i <= 2; i++) {
        final y = inner.top + inner.height * i / 3;
        canvas.drawLine(Offset(inner.left, y), Offset(inner.right, y), p);
      }
    case CarPattern.dots:
      final fill = Paint()..color = p.color;
      for (var i = 0; i < 3; i++) {
        canvas.drawCircle(
          Offset(inner.left + inner.width * (i + 0.5) / 3, inner.center.dy),
          cell * 0.05,
          fill,
        );
      }
    case CarPattern.chevrons:
      final chevron = Path()
        ..moveTo(inner.left, inner.top)
        ..lineTo(inner.center.dx, inner.center.dy)
        ..lineTo(inner.left, inner.bottom);
      canvas.drawPath(chevron, p);
    case CarPattern.checks:
      canvas.drawRect(
        Rect.fromLTWH(inner.left, inner.top, inner.width / 2, inner.height / 2),
        p,
      );
      canvas.drawRect(
        Rect.fromLTWH(inner.center.dx, inner.center.dy, inner.width / 2, inner.height / 2),
        p,
      );
    case CarPattern.waves:
      final wave = Path()
        ..moveTo(inner.left, inner.center.dy)
        ..quadraticBezierTo(inner.left + inner.width * 0.25, inner.top,
            inner.center.dx, inner.center.dy)
        ..quadraticBezierTo(inner.left + inner.width * 0.75, inner.bottom,
            inner.right, inner.center.dy);
      canvas.drawPath(wave, p);
    case CarPattern.hatch:
      canvas.drawLine(inner.bottomLeft, inner.topRight, p);
  }
}

/// Records the static layer once per board state (not per frame).
class BoardPictureCache {
  ui.Picture? _picture;
  Object? _key;

  ui.Picture obtain({
    required Object stateKey, // e.g. board revision number
    required Size size,
    required BoardGeometry geometry,
    required List<TrainView> restingTrains,
    required void Function(Canvas canvas) paintObstacles,
  }) {
    final cached = _picture;
    if (cached != null && stateKey == _key) return cached;
    cached?.dispose();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Offset.zero & size);
    _paintTabletop(canvas, geometry);
    for (final t in restingTrains) {
      _paintLaneTrack(canvas, geometry, t);
    }
    paintObstacles(canvas);
    for (final t in restingTrains) {
      for (var i = t.body.length - 1; i >= 0; i--) {
        final angle = _restingAngle(t, i, geometry);
        paintCar(canvas, geometry.centerOf(t.body[i]), angle, t,
            isEngine: i == 0, cell: geometry.cellSize);
      }
    }
    final picture = recorder.endRecording();
    _picture = picture;
    _key = stateKey;
    return picture;
  }

  void dispose() {
    _picture?.dispose();
    _picture = null;
  }

  static double _restingAngle(TrainView t, int i, BoardGeometry g) {
    if (i == 0) {
      final u = t.heading.unit;
      return math.atan2(u.dy, u.dx);
    }
    final ahead = g.centerOf(t.body[i - 1]);
    final here = g.centerOf(t.body[i]);
    return math.atan2(ahead.dy - here.dy, ahead.dx - here.dx);
  }

  static void _paintTabletop(Canvas canvas, BoardGeometry g) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(g.boardRect.inflate(6), const Radius.circular(14)),
      Paint()..color = const Color(0xFFF3E9DC),
    );
    final dot = Paint()..color = const Color(0xFFE5D4C0);
    for (var y = 0; y < g.rows; y++) {
      for (var x = 0; x < g.cols; x++) {
        canvas.drawCircle(g.centerOf(GridCell(x, y)), g.cellSize * 0.05, dot);
      }
    }
  }

  /// Faint straight track ahead of the engine to the board edge.
  static void _paintLaneTrack(Canvas canvas, BoardGeometry g, TrainView t) {
    final tie = Paint()
      ..color = const Color(0xFFC89D7C).withValues(alpha: 0.4)
      ..strokeWidth = g.cellSize * 0.08;
    final u = t.heading.unit;
    var c = t.body.first;
    while (true) {
      c = GridCell(c.x + u.dx.toInt(), c.y + u.dy.toInt());
      if (c.x < 0 || c.y < 0 || c.x >= g.cols || c.y >= g.rows) break;
      final center = g.centerOf(c);
      final perp = Offset(-u.dy, u.dx) * (g.cellSize * 0.3);
      canvas.drawLine(center - perp, center + perp, tie);
    }
  }
}
```

Notes:
- The static lane track is drawn straight from the engine; lanes bent by curves/tunnels are shown only in Route Peek (engine-traced).
- `MovingTrain` group moves (M011/M039/M048) share one controller ⇒ simultaneous animation.
- Tunnel (M008/M044) routes are passed as two segments; the view clips cars at portal mouths (mask layer) — implementation in `tunnel_mask.dart`.
- Picture cache invalidates on every `MoveOutcome` (board revision++) and on resize.

## 6. Input Handling

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BoardGestureLayer extends StatelessWidget {
  const BoardGestureLayer({
    super.key,
    required this.onTapCell,
    required this.onPreviewStart,
    required this.onPreviewEnd,
    required this.child,
  });

  final void Function(Offset localPosition) onTapCell;
  final void Function(Offset localPosition) onPreviewStart;
  final VoidCallback onPreviewEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          TapGestureRecognizer.new,
          (r) => r.onTapUp = (d) => onTapCell(d.localPosition),
        ),
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(
            duration: const Duration(milliseconds: 350),
          ),
          (r) => r
            ..onLongPressStart = (d) => onPreviewStart(d.localPosition)
            ..onLongPressEnd = (_) => onPreviewEnd()
            ..onLongPressCancel = onPreviewEnd,
        ),
      },
      child: child,
    );
  }
}
```

- Hit test: `geometry.cellAt(localPosition)` ⇒ tap resolution order: (1) crane target mode ⇒ target; (2) upper layer train (M032); (3) interactive cell (turntable, switch, lever, yard, gear lever) — 01 §5.9; (4) train car; (5) nothing ⇒ ignore.
- Rotor/Turntable: train આંશિક રીતે અંદર ⇒ interactive tap = locked tap; rotation પછી engine પોતાના carriage તરફ ("tangled", standard §17.39) ⇒ train tap = locked tap.
- During `animating`: store only the latest tap in `pendingTap` (queue = 1).
- Locked tap ⇒ wobble animation (80 ms ×2), `locked_tap` sound event (wooden knock), `HapticFeedback.selectionClick()`; no Move.
- Tap logging: `TapLoggerScope` `MaterialApp.builder` માં wrap; board taps `board:cell(x,y):<trainId|mechanicId>` semantic ID + `TapResult` (`exit` / `bump` / `locked` / `interactive:<id>`) સાથે `AppLogger` (`I-TAP`, `I-DEAD-TAP`, `I-RAGE-TAP`, `I-SLOW-INPUT`) — [Logging §6](../../LOGGING_AND_ERROR_TRACKING.md).

## 7. Audio & Haptics

Audio ની સંપૂર્ણ spec shared standard માં છે: **[SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md)** (architecture, event catalog §5, mixer/ducking §6, settings §7, Dart code §8, CI §10, QA §11). Toy Trains માત્ર `assets/audio/theme.json` (eventId → files) અને asset files બદલે છે; engine code ચારેય games માં identical.

- `AudioService` (singleton) + SFX માટે `AudioPool` (`PlayerMode.lowLatency`), music માટે 2 × `AudioPlayer` (600 ms crossfade). **Max 8** concurrent SFX voices; same event ID ⇒ min 50 ms gap.
- Assets: SFX **`.wav`** PCM 16-bit **mono** 44.1 kHz (≤ 70 KB each), music / stingers **`.m4a`** AAC-LC 128 kbps. **OGG નહીં** (iOS support નથી). File names = event ID (`path_exit_v1.wav`, `music_gameplay_t1.m4a`). Total ≤ 10 MB (Phase 1).
- Haptics: Flutter `HapticFeedback` only, sound doc §5 mapping; Settings → Haptics off ⇒ no call. Sound / Music / Haptics toggles = 06 Settings.
- 03 cards માં લખેલા `sfx_*` નામ sound-designer brief labels છે; shipped file હંમેશા નીચેના standard event ID થી નામાયેલી હોય.
- Game 3 rule (sound doc §9): `path_exit` = 1 short sample; train ની લંબાઈ પ્રમાણે wheel-roll loop **નહીં**.

**Toy Trains theme mapping (sound doc §9 + §5):**

| Standard event ID | Toy Trains sound | Haptic |
|---|---|---|
| `path_tap` | Wooden click + tiny toot | `selectionClick` |
| `path_exit` (3 variants) / `path_exit_combo` | Toot-toot + short wooden wheels roll | `lightImpact` |
| `bump` | Buffer "clack" (on contact frame) | `mediumImpact` |
| `locked_tap` / `wrong_order` | Wooden knock / "wrong ticket" knock (M028) | `selectionClick` |
| `heart_lost` | Wooden heart crack | `heavyImpact` |
| `shield_absorb` | Cowcatcher metal ring | `lightImpact` |
| `booster_hint` | Signal bell "ding-ding" (Green Signal Hint) | — |
| `booster_undo` | Reverse-gear clunk (Reverse Gear Undo) | `selectionClick` |
| `booster_hammer` | Crane lift + clank (Track Crane) | `mediumImpact` |
| `gate_open` / `gate_close` | Level-crossing bell + barrier lift / drop | — |
| `lock_open` / `key_collect` | Ticket punch + barrier (M004, M043, M046) | — |
| `portal_whoosh` | Tunnel echo whoosh (M008, M044) | — |
| `lever_toggle` / `switch_click` / `rotate` | Signal lever clunk (M009, M045) / points click (M018) / turntable & yard creak (M013, M034) | `selectionClick` |
| `fog_clear` | Steam cloud hiss-away (M010) | — |
| `crack` / `break` | Rock pile crack (M016) / trestle collapse (M042) | — |
| `eat` | Coal shovel (M036) | — |
| `guardian_hit` / `guardian_defeat` | Clock-tower tick / clock-tower chime + cheer (M049) | — |
| `win_stinger` | Toy whistle + music-box | — |
| `coins_fly` | Coin clink on wood | — |
| `gift_open` / `chest_open` | Gift Crate lid / Grand Central Chest | — |
| `rush_start` / `rush_tick` / `rush_end` | Golden Express whistle / last-5 s bell / brake hiss | — |
| `spin_tick` / `spin_win` | Lucky Turntable click / chime | — |
| Music `music_home`, `music_map`, `music_gameplay_t1…t5`, `music_rush`, `music_finale`, `music_daily` | Wooden xylophone, music-box, light ragtime | — |

બાકીના બધા event IDs (sound doc §5.2–§5.5) પણ `theme.json` માં ફરજિયાત (CI `tools/audio_check`). Audio errors: `E-AUD-001…003` ([Logging §4](../../LOGGING_AND_ERROR_TRACKING.md)).

## 8. Ads, IAP & Consent Integration

1. App start: load save ⇒ age gate (first launch) ⇒ `ConsentInformation.instance.requestConsentInfoUpdate(...)` ⇒ show UMP form if required ⇒ `MobileAds.instance.initialize()` ⇒ `RequestConfiguration` (`tagForChildDirectedTreatment` + `maxAdContentRating: G` for child band) ⇒ preload rewarded + interstitial.
2. `AdsService.maybeShowInterstitial(level)` implements 04 §8: `level > 10`, `winsSinceInterstitial >= 5`, `now − lastFullscreenUtc ≥ 120 s`, no reward screen this win, not Daily/Rush/fail, daily cap 20, VIP inactive. If deferred, counter is kept.
3. Rewarded: grant only in `onUserEarnedReward`; dismissed without reward ⇒ no grant. Revive sets `adReviveUsed[level] = true`.
4. Banner: adaptive anchored, created only on Home, Level Map, Gameplay (L11+); disposed on route pop; hidden when VIP.
5. IAP: `InAppPurchase.instance.purchaseStream` listener at app start ⇒ pending/verified/error; verification via Firebase Function `verifyPurchase`; grant ⇒ `completePurchase`. VIP: `vipActiveUntil` from verified receipt expiry; re-checked on launch and on restore.
6. Load fail ⇒ exponential backoff (2 s, 4 s, 8 s), max 3 retries/session.

## 9. Persistence Schema (Hive, save schema v1)

```
progress { highestCleared:int, stars: Map<int,int>, adReviveUsed: Map<int,bool>, giftsClaimed: Set<int> }
wallet   { coins:int, boosters { hint, undo, shield, hammer } }
streak   { day:int, cycleSaverUsed:bool, lastClaimDayKey:String, totalDays:int, trophyTier:int }
time     { lastTrustedUtc:DateTime, lastServerUtc:DateTime?, uptimeAtClaim:int, bootId:String }
ads      { winsSinceInterstitial:int, lastFullscreenUtc:DateTime?, dailyShopAds:int, dailySpinAds:int, dayKey:String }
iap      { vipActiveUntil:DateTime?, starterPackShown:bool, starterPackUntil:DateTime? }
settings { sound, music, haptics:bool, language:String, ageBand:String, reduceMotion:bool }
daily    { dayKey:String, boardJson:String, claimed:bool, spin{freeUsed, adUsed} }
session  { inProgressLevel:int?, attemptSnapshot:String? }   // resume after kill
```
- `giftsClaimed`, `daily`, `session`, `uptimeAtClaim`, `bootId`, `reduceMotion`, `starterPackUntil` = game-level additions to standard §14 (same schema v1 box, additive).
- Writes: after each level end, reward grant, purchase, settings change (debounced 300 ms); atomic via Hive `put` + backup box copy on level win.
- Migration: `schemaVersion` key; unknown higher version ⇒ read-only + prompt update.

## 10. Analytics (minimum, standard §15)

`level_start{level, attempt}`, `level_win{level, moves, hearts_lost, stars, duration_s}`, `level_fail{level, moves}`, `booster_use{type, level}` (type = hint|undo|shield|hammer), `revive{type: ad|coins, level}`, `ad_show{format, placement}`, `iap_purchase{sku}`, `daily_clear{dayKey, modifier}`, `streak_update{day}`, `ftue_step{step}`. Child band ⇒ analytics personalization off (`setAnalyticsCollectionEnabled` stays on; ad personalization signals off).

## 11. Performance Budget

| Metric | Target |
|---|---|
| Low-tier Android (2 GB RAM, Redmi 9A class), 30 trains | **60 fps** |
| ProMotion iOS / 120 Hz Android flagships | **120 fps** |
| Frame raster p95 (mid-tier) | **< 8 ms** |
| Static layer | `PictureRecorder` cache; rebuild only on board change |
| Per frame | only moving train(s) repaint |
| Shadows | pre-baked; no per-frame `MaskFilter.blur` |
| Colours | `Color.withValues(alpha:)` (no deprecated `withOpacity`) |
| Level load | < 150 ms (JSON decode in isolate, gz asset decoded once at start) |
| Hint solver | isolate, 50 ms budget, 50k nodes |
| Cold start | < 2.5 s to Home on mid-tier |
| APK size | < 60 MB (audio: WAV SFX + M4A music ≤ 10 MB; images WebP) |

## 12. Error Handling & Level Validator CI

બધા errors `AppLogger` મારફતે stable codes સાથે log થાય (ring buffer + file + Crashlytics non-fatal); full spec: **[LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md)** (codes §4, global hooks §5.1, tap logging §6, replay §7, invariants §8, privacy §10, Report a problem §11).

| Failure | Code | Handling |
|---|---|---|
| Level JSON missing / parse fail | `E-LVL-001` | Non-fatal + replay; dialog **"Level unavailable"** + **Retry** (asset re-load). Level **ક્યારેય skip નહીં**, cleared mark નહીં, coins નહીં (Logging §8) |
| Level JSON schema ≠ 3 / duplicate ids | `E-LVL-002` | Same: "Level unavailable" + Retry; never skip |
| Daily generator 64 attempts fail | `E-LVL-003` | Fallback Classic preset (`daily_fallback.json`, standard §16.21) |
| Hint solver timeout / isolate error | `E-LVL-004` | "Try Reverse Gear" toast, no Hint consumed |
| Invariant violated (hearts, overlap, win state) | `E-GAME-001` | Soft assert: clamp / restore pre-move snapshot / force win flow (Logging §8) |
| Stuck animation > 2 s | `E-GAME-003` | Complete animation instantly, unlock input |
| Soft-lock (no winning sequence) | `E-GAME-004` | "Stuck" sheet: Reverse Gear Undo / Restart, no heart loss, no Level Failed (standard §17.31) |
| Hive open fail / save corrupt | `E-SAVE-001` / `E-SAVE-002` | Restore backup box (`E-SAVE-002`); else fresh save; game continues |
| Save write fail | `E-SAVE-004` | Retry on next write; keep in-memory state |
| Ad load / show error | `W-ADS-001` / `W-ADS-002` | Disable button with "Ad unavailable"; never block flow |
| Ad reward not granted after completion | `E-ADS-003` | Idempotency key per impression; grant exactly once |
| IAP error / verify fail / pending > 24 h | `E-IAP-001` / `E-IAP-002` / `E-IAP-003` | Keep pending; retry on next launch; no double grant (transaction id dedupe) |
| Remote Config fetch timeout / server time fail | `W-NET-002` / `W-NET-001` | Bundled defaults (= standard values) / last trusted time |
| Clock moved backward | `W-TIME-001` | Time-travel lock (05) |
| Audio asset missing / pool fail | `E-AUD-001` / `E-AUD-002` | Skip that sound, game continues (sound doc §8) |
| FlutterError / image decode | `E-UI-001` / `E-UI-002` | Non-fatal; fallback widget / placeholder |

**Level validator (CI, `tools/levelgen validate`)** on every PR touching levels or `puzzle_core`: solvable with 0 hearts & 0 boosters (BFS/IDA*, node limit 2M, depth ≤ 3×P) · D in slot band ±3 · grid/trains/obstacles within tier · no train initially locked forever · min cell ≥ 29 dp at 360 dp · intro levels = intro mechanic + ≤ 1 earlier · FTUE optimal Moves (L1–3 ≤ 4, L4–10 ≤ 8) · `solution` replays to Win · M036 every tender has a reachable coal pile · M026 sacks reachable.

## 13. QA Checklist

All items **Status: Not run** (no test executed yet).

| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-RUL-01 | Tap exit | Tap any car of a train with clear lane | Train departs, carriages follow body then lane, removed; Move +1 | Not run |
| QA-RUL-02 | Bump | Tap train with blocked lane | Rolls to blocker, clack, rolls back; −1 heart; Move +1; board unchanged | Not run |
| QA-RUL-03 | Locked tap | Tap Snowed-In train (K>0) | Wobble + knock; hearts and Move unchanged; counters not ticked | Not run |
| QA-RUL-04 | Interactive Move | Tap lever / turntable / switch / yard / gear lever | State changes; Move +1; counters tick; no heart | Not run |
| QA-RUL-05 | Tap priority | Tap overlap cell (Viaduct), turntable cell with engine, yard hub over a train car, yard with a partially inside train | Upper train tapped; turntable rotates (train not driven); yard rotates (§16.19); partial train ⇒ yard locked tap | Not run |
| QA-RUL-11 | Tangled train | Rotate turntable so engine faces its own carriage, tap train | Locked tap (wobble + knock), no heart, no Move; rotate again ⇒ tappable (§17.39) | Not run |
| QA-RUL-12 | Soft-lock | Debug board with no winning sequence | "Stuck" sheet with Undo / Restart; no heart lost; no Level Failed; `E-GAME-004` logged | Not run |
| QA-RUL-06 | Input queue | Tap 3 trains during an animation | Only last tap executes after animation | Not run |
| QA-RUL-07 | Route Peek | Long-press 350 ms on train | Dotted lane, red ✕ on blocker / green; no Move | Not run |
| QA-RUL-08 | Win | Exit last train with Mail Sacks remaining vs all collected | Win only when all sacks collected | Not run |
| QA-RUL-09 | Tick order | Scripted Move with M007+M017+M025 | Matches 01 §5.11 order (golden test) | Not run |
| QA-RUL-10 | Determinism | Replay same Move list twice | Identical final state hash | Not run |
| QA-HRT-01 | Hearts | Bump 3 times | Second Chance with 10 s ring | Not run |
| QA-HRT-02 | Ad revive per level | Revive by ad, fail again, restart, fail again | Ad option hidden after first use until level cleared | Not run |
| QA-HRT-03 | Heart Refill | Use refill twice, fail again | 3rd refill unavailable; −120 coins each | Not run |
| QA-HRT-04 | Refill coins < 120 | Open Second Chance with 100 coins | Refill disabled/opens coin sheet | Not run |
| QA-HRT-05 | Timeout | Let countdown end | Level Failed; Retry gives 3 hearts, board reset | Not run |
| QA-HRT-06 | Revive keeps board | Revive | Board not reset, hearts = 1 | Not run |
| QA-STR-01 | Stars | Clear with 0/1/2 hearts lost; with revive | ★★★ / ★★ / ★ / ★ | Not run |
| QA-STR-02 | Shield & stars | Clear with only shield-absorbed bumps | ★★★ | Not run |
| QA-BST-01 | Hint | Use Green Signal Hint on solution prefix and off-prefix | Correct next Move glows; cap 3/attempt | Not run |
| QA-BST-02 | Hint fail | Force solver over budget | "Try Reverse Gear" toast, Hint not consumed | Not run |
| QA-BST-03 | Undo | Exit, bump, lever, then Undo ×3 | Board + counters revert; hearts not restored; no cap | Not run |
| QA-BST-04 | Undo limits | Undo after booster use / revive | Booster use and revive not undone | Not run |
| QA-BST-05 | Shield | Activate, bump ×3 | First 2 absorbed, 3rd −1 heart; cap 1; lapses at attempt end | Not run |
| QA-BST-06 | Crane on train | Crane a ticket-train | Train removed as exit; barrier opens | Not run |
| QA-BST-07 | Crane restrictions | Crane on Guardian, Ticket barrier, Table Edge Fence, gates, intact trestle, interactive cells | Not selectable; cap 2/attempt; selectable only M001, M002, M016, M025, one M027 cell, broken M042 | Not run |
| QA-BST-10 | Undo after Crane | Exit, Crane a train, press Undo | Undo history cleared at Crane use ⇒ Undo disabled until next Move; Crane never undone / re-applied (§16.23) | Not run |
| QA-BST-11 | Crane exit triggers | Crane a ticket train whose lane crosses a Mail Sack and Rock Pile; try Crane on last train with sacks remaining | Barrier opens (non-lane); sack not collected, Rock HP unchanged (lane); Crane disabled on last train (§16.31) | Not run |
| QA-BST-08 | Booster unlocks | Reach L3, L8, L15, L25 | Tutorials + 3/3/1/1 free granted once | Not run |
| QA-BST-09 | Zero inventory | Tap booster with 0 | Mini shop sheet | Not run |
| QA-COI-01 | Clear coins | First clear easy/normal/hard/finale | 15/20/30/50; replay 0 | Not run |
| QA-COI-02 | 3-star bonus | First ★★★ then repeat | +20 once | Not run |
| QA-COI-03 | 2X Win | Watch 2X ad | Base clear coins doubled, star bonus not | Not run |
| QA-GFT-01 | Gift Crate | Clear L10, L20, L110, L410 | 150+Hint, 150+Crane, 180+Shield, 300+Hint | Not run |
| QA-GFT-02 | Phase Chest | Clear L500 | 1,000 + 2 each booster + badge | Not run |
| QA-RSH-01 | Coin Rush trigger | Clear L25, L50 | Rush after L25; at L50 Gift Crate then Rush; no interstitial | Not run |
| QA-RSH-02 | Coin Rush payout + count | Rush after L250 (T3 ⇒ 25 trains): exit 22; clear all in another run; also check L25 ⇒ 20, L125 ⇒ 22, L325 ⇒ 28, L425 ⇒ 30 trains; replay L25 | 220; 250+100; counts per tier table; replay ⇒ no Rush (first clear only); bump in Rush ⇒ wobble, no heart | Not run |
| QA-RSH-03 | Rush timer | Background app mid-rush | Timer pauses, resumes | Not run |
| QA-DLY-01 | Daily unlock | Before/after L15 clear | Locked / available | Not run |
| QA-DLY-02 | Daily seed | Two devices, same date & tier | Identical board | Not run |
| QA-DLY-03 | Modifiers | Force each weekday | Mon–Sun behaviour per 05 §2 incl. fallbacks | Not run |
| QA-DLY-04 | Daily reward once | Clear twice | +100 once | Not run |
| QA-DLY-05 | Daily ad rules | Clear Daily; fail Daily twice | No 2X Win offer; ad revive once per `dayKey` (`adReviveUsed["daily:<dayKey>"]`) | Not run |
| QA-STK-01 | Streak ladder | Clear 7 consecutive days | Rewards per 05 §4; trophy +1; cycle restarts | Not run |
| QA-STK-02 | Saver | Miss 1 day, use saver (ad / 200) | Streak continues, missed reward not granted; 2nd miss same cycle ⇒ reset | Not run |
| QA-STK-03 | 2-day miss | Miss 2 days | Day 1, no saver offer | Not run |
| QA-STK-04 | Saver timing | Miss 1 day, clear that day's Daily before accepting Saver | Saver offer gone; streak resets (Saver must be accepted before the day's clear) | Not run |
| QA-STK-05 | Trophy tiers | Complete 6 cycles (debug clock) | Bronze → Silver → Gold → Platinum → Diamond → Diamond (counter keeps rising) | Not run |
| QA-ACH-01 | Time travel | Move clock back 3 h | Daily claim, streak, spin locked | Not run |
| QA-ACH-02 | 20 h rule | Change timezone to get new dayKey | Second claim blocked | Not run |
| QA-ACH-03 | Offline verify | Claim offline with clock +2 days, go online | Streak freeze, coins kept | Not run |
| QA-SPN-00 | Spin unlock | Fresh install: clear L5, L9, then L10 | Lucky Turntable hidden until L10 clear, then visible (§16.32) | Not run |
| QA-SPN-01 | Spin limits | Free + ad + try third | Third blocked; odds visible in Settings | Not run |
| QA-SPN-02 | Spin determinism | Same installId/dayKey/index | Same prize | Not run |
| QA-SHP-01 | Booster purchase | Buy singles and 3-packs | Prices 60/150, 40/100, 80/200, 100/250 | Not run |
| QA-SHP-02 | Coin IAP | Buy S/M/L/XL (test accounts) | 350/1,000/2,200/5,500 after verification | Not run |
| QA-SHP-03 | Starter Pack | Clear L15, wait 48 h | Offer visible 48 h, one-time | Not run |
| QA-SHP-04 | VIP | Subscribe, then let test sub expire | Interstitial+banner off while active; ads return after expiry | Not run |
| QA-SHP-05 | Restore | Reinstall, Restore purchases | VIP + Starter flag restored | Not run |
| QA-SHP-06 | Free coins | Watch 6 shop ads | +50 ×5, sixth blocked | Not run |
| QA-ADS-01 | Interstitial cadence | Win L11–L20 | First interstitial at L15 win; the 5-win mark at L20 has a Gift Crate ⇒ deferred; shown after L21 win (if ≥ 120 s since last full-screen ad) | Not run |
| QA-ADS-02 | Never cases | Fail, Daily clear, Coin Rush, L1–10 wins | No interstitial | Not run |
| QA-ADS-03 | Banner placement | Home, Map, Gameplay L10 vs L11 | Banner on Home/Map; gameplay only from L11 with ≥8 dp gap | Not run |
| QA-ADS-04 | Cooldown | Rewarded ad then win eligible interstitial within 120 s | Interstitial deferred | Not run |
| QA-CNS-01 | Age gate | Enter under-13 year | Child-directed, non-personalized, rating G | Not run |
| QA-CNS-02 | UMP | EEA test device | Consent form before any ad request | Not run |
| QA-PER-01 | Persistence | Kill app mid-level, relaunch | Progress, wallet, settings intact; resume offered | Not run |
| QA-PER-02 | Counters persist | Restart app | `winsSinceInterstitial`, `adReviveUsed` persisted | Not run |
| QA-OFF-01 | Offline | Airplane mode play L1–30, Daily | Fully playable; ad buttons disabled | Not run |
| QA-PRF-01 | Low-tier | Redmi 9A class, L480 (30 trains) | ≥ 60 fps exits; no jank > 2 frames | Not run |
| QA-PRF-02 | High refresh | ProMotion iPhone / 120 Hz Android | 120 fps | Not run |
| QA-PRF-03 | Mid-tier raster | Pixel 6a class profile mode | p95 raster < 8 ms | Not run |
| QA-PRF-04 | Device matrix | 360×640 Android, 412×915, iPhone SE, iPhone 15 Pro Max, iPad 10.2 (4:3), 21:9 Android | Board fits, cell ≥ 29 dp at 11×11, safe areas | Not run |
| QA-A11Y-01 | Colour-blind | Deuteranopia/protanopia simulation | Trains distinguishable by pattern/icon | Not run |
| QA-A11Y-02 | Text scale 1.3 | System font 130% | No clipped text, buttons ≥ 48 dp | Not run |
| QA-A11Y-03 | Reduce motion | Enable setting | Short animations, no shake/confetti | Not run |
| QA-A11Y-04 | Screen reader | TalkBack / VoiceOver on HUD | All buttons labelled | Not run |
| QA-LOC-01 | Localization | Switch EN / ગુજરાતી / हिन्दी | All strings translated, no overflow | Not run |
| QA-CI-01 | Level validator | Run `tools/levelgen validate` on phase_1.json.gz | 500/500 pass all checks in §12 | Not run |
| QA-CI-02 | FTUE moves | Validator on L1–10 | L1–3 ≤ 4 Moves, L4–10 ≤ 8 | Not run |
| QA-M001 | Mechanic unit test `m001_test.dart` (Buffer Stop) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: 1 cell; lane blocks. hammerable; hammerable flag per 03 | Not run |
| QA-M002 | Mechanic unit test `m002_test.dart` (Cargo Crate Row) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: 2–4 straight cells; lane blocks. hammerable (આખી wall); hammerable flag per 03 | Not run |
| QA-M003 | Mechanic unit test `m003_test.dart` (Snowed-In Train) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Path locked until K (1–3) adjacent (orthogonal) paths exit; badge shows K; hammerable flag per 03 | Not run |
| QA-M004 | Mechanic unit test `m004_test.dart` (Ticket & Barrier) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Key icon on a path; matching-color Lock cell blocks until key-path exits, then opens permanently. Lock not hammerable; hammerable flag per 03 | Not run |
| QA-M005 | Mechanic unit test `m005_test.dart` (Colour Platform Gate) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Cell passable only by same-color path; others bump; hammerable flag per 03 | Not run |
| QA-M006 | Mechanic unit test `m006_test.dart` (One-Way Rail) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Passable only in arrow direction; else bump; hammerable flag per 03 | Not run |
| QA-M007 | Mechanic unit test `m007_test.dart` (Level Crossing) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Closed gate opens permanently after N Moves (badge N); hammerable flag per 03 | Not run |
| QA-M008 | Mechanic unit test `m008_test.dart` (Tunnel Pair) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Lane entering portal A continues from portal B same dir. Path occupying B ⇒ blocked; hammerable flag per 03 | Not run |
| QA-M009 | Mechanic unit test `m009_test.dart` (Signal Lever & Semaphores) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Tap lever (1 Move) ⇒ all linked gates flip open/closed. Non-monotone; hammerable flag per 03 | Not run |
| QA-M010 | Mechanic unit test `m010_test.dart` (Steam Cloud) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Paths under fog hidden & locked; a fog area clears when any path whose body touches it exits; hammerable flag per 03 | Not run |
| QA-M011 | Mechanic unit test `m011_test.dart` (Coupled Engines) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: 2 paths linked; tap either ⇒ both try; both lanes must be clear else both bump (−1 heart total); hammerable flag per 03 | Not run |
| QA-M012 | Mechanic unit test `m012_test.dart` (Cold Engine) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: 1st tap wakes (1 Move), 2nd tap exits; hammerable flag per 03 | Not run |
| QA-M013 | Mechanic unit test `m013_test.dart` (Turntable) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Path head on turntable; tap turntable ⇒ rotates that path 90° CW (1 Move); engine facing own carriage ⇒ "tangled" locked tap (§17.39), not bump; hammerable flag per 03 | Not run |
| QA-M014 | Mechanic unit test `m014_test.dart` (Curve Rail) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: `/` or `\` cell; lane turns 90°; hammerable flag per 03 | Not run |
| QA-M015 | Mechanic unit test `m015_test.dart` (Wooden Overpass) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Path cells lying on bridge do not block perpendicular lanes passing under; hammerable flag per 03 | Not run |
| QA-M016 | Mechanic unit test `m016_test.dart` (Rock Pile) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: HP 1–3; −1 HP whenever an exiting lane passes an orthogonally adjacent cell; HP 0 ⇒ removed. hammerable; hammerable flag per 03 | Not run |
| QA-M017 | Mechanic unit test `m017_test.dart` (Steam Pressure Train) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Must exit within N Moves; at 0 ⇒ −1 heart, counter resets to N; hammerable flag per 03 | Not run |
| QA-M018 | Mechanic unit test `m018_test.dart` (Track Switch) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Cell turns lane L or R per state; tap switch toggles (1 Move); hammerable flag per 03 | Not run |
| QA-M019 | Mechanic unit test `m019_test.dart` (Weighbridge Plate) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Linked gate open while some path body covers plate; plate-path exits ⇒ gate closes; hammerable flag per 03 | Not run |
| QA-M020 | Mechanic unit test `m020_test.dart` (Engine Shed) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Internal cell acting as exit; lane reaching it ⇒ path exits into it; hammerable flag per 03 | Not run |
| QA-M021 | Mechanic unit test `m021_test.dart` (Phantom Express) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Solid on even Move count, ghost (non-blocking, not tappable) on odd; hammerable flag per 03 | Not run |
| QA-M022 | Mechanic unit test `m022_test.dart` (Shunting Train) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Exits tail-first (moves backward); arrow cue on tail; hammerable flag per 03 | Not run |
| QA-M023 | Mechanic unit test `m023_test.dart` (Push-Pull Train) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Head both ends; tap near an end ⇒ exits that way (tap nearest-end rule); hammerable flag per 03 | Not run |
| QA-M024 | Mechanic unit test `m024_test.dart` (Wide Load Freight) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: 2-cell-wide body; needs 2-wide clear lane; hammerable flag per 03 | Not run |
| QA-M025 | Mechanic unit test `m025_test.dart` (Handcar Patrol) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Moves 1 cell along fixed loop each Move; blocks where it stands; hammerable flag per 03 | Not run |
| QA-M026 | Mechanic unit test `m026_test.dart` (Mail Sack Pickup) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Win also requires every gem collected (lane passing gem collects it); hammerable flag per 03 | Not run |
| QA-M027 | Mechanic unit test `m027_test.dart` (Creeping Ivy) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Every N Moves grows 1 cell into first free neighbour (fixed order U,R,D,L); Track Crane removes one ivy cell only; hammerable flag per 03 | Not run |
| QA-M028 | Mechanic unit test `m028_test.dart` (Timetable Order) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Must exit in ascending number order; wrong = locked tap; hammerable flag per 03 | Not run |
| QA-M029 | Mechanic unit test `m029_test.dart` (Table Edge Fence) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Board edge segments walled; lanes hitting edge wall bump. not hammerable; hammerable flag per 03 | Not run |
| QA-M030 | Mechanic unit test `m030_test.dart` (Colour Station Exit) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Edge opening only for one color; hammerable flag per 03 | Not run |
| QA-M031 | Mechanic unit test `m031_test.dart` (Last Call Exit) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Open edge segment closes permanently after N Moves; hammerable flag per 03 | Not run |
| QA-M032 | Mechanic unit test `m032_test.dart` (Viaduct Deck) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Upper-layer paths drawn above; lower path locked while any upper path covers its body; lanes interact only within own layer; hammerable flag per 03 | Not run |
| QA-M033 | Mechanic unit test `m033_test.dart` (Locked Siding) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Caged path locked until all paths of cage color exit; hammerable flag per 03 | Not run |
| QA-M034 | Mechanic unit test `m034_test.dart` (Rotating Yard 2×2) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Tap rotor ⇒ 2×2 contents rotate 90° CW (paths fully inside only); hub tap over a train car ⇒ yard wins (§16.19); partial train ⇒ locked tap; hammerable flag per 03 | Not run |
| QA-M035 | Mechanic unit test `m035_test.dart` (Depot Dispatcher) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: On exit spawns a short child path at marked cells (if free, else waits); hammerable flag per 03 | Not run |
| QA-M036 | Mechanic unit test `m036_test.dart` (Coal Tender) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Can exit only if lane passes a food cell (food consumed); clear lane without coal ⇒ bump −1 heart (§16.6); hammerable flag per 03 | Not run |
| QA-M037 | Mechanic unit test `m037_test.dart` (Sand Drift) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Lane reaching mud stops path there (relocates, 1 Move); next tap continues from mud; hammerable flag per 03 | Not run |
| QA-M038 | Mechanic unit test `m038_test.dart` (Jump Ramp) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Lane over pad leaps the next 1 cell (can jump a 1-cell blocker, not a path); hammerable flag per 03 | Not run |
| QA-M039 | Mechanic unit test `m039_test.dart` (Twin Expresses) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Tap one ⇒ twin moves mirrored; both must be clear; hammerable flag per 03 | Not run |
| QA-M040 | Mechanic unit test `m040_test.dart` (Night Run) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Visual: only area near last moved path + long-press preview lit. Rules unchanged; hammerable flag per 03 | Not run |
| QA-M041 | Mechanic unit test `m041_test.dart` (Rainbow Engine) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Color cycles (R→G→B) each Move; interacts with M005/M030/M033; hammerable flag per 03 | Not run |
| QA-M042 | Mechanic unit test `m042_test.dart` (Rickety Trestle) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Bridge allows 1 crossing then becomes Single Blocker; intact not hammerable, broken hammerable; hammerable flag per 03 | Not run |
| QA-M043 | Mechanic unit test `m043_test.dart` (Multi-Ticket Barrier) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Lock needs 2–3 keys (all key-paths exit); hammerable flag per 03 | Not run |
| QA-M044 | Mechanic unit test `m044_test.dart` (Bend Tunnel) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Portal pair that rotates lane direction 90° on exit side; hammerable flag per 03 | Not run |
| QA-M045 | Mechanic unit test `m045_test.dart` (Master Gear Lever) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: One lever rotates multiple turntables (M013) together; hammerable flag per 03 | Not run |
| QA-M046 | Mechanic unit test `m046_test.dart` (Loop Line Train) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Closed loop; locked until linked key-path exits, then opens at marked head; hammerable flag per 03 | Not run |
| QA-M047 | Mechanic unit test `m047_test.dart` (Auto-Coupler Freight) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Tail grows 1 cell every N Moves into free cell behind tail (no growth if blocked); hammerable flag per 03 | Not run |
| QA-M048 | Mechanic unit test `m048_test.dart` (Convoy Group) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Tapping a group-marked path moves all same-color group paths; any blocked ⇒ all bump (−1); hammerable flag per 03 | Not run |
| QA-M049 | Mechanic unit test `m049_test.dart` (Clock Tower Guardian) | Fixture boards: rule happy path, blocked/bump path, locked/edge cases from 03 card, Undo revert, Crane interaction, JSON round-trip | Engine matches standard rule: Multi-cell blocker, HP = linked paths count; each linked exit −1 HP; 0 ⇒ vanish. not hammerable; hammerable flag per 03 | Not run |
| QA-FIN-01 | L500 Finale | Play L500 via solution replay and manually | Solvable 0 hearts; Guardian HP 6 → 0; Grand Central Chest → Coin Rush → Phase Complete | Not run |
| QA-ERR-01 | Corrupt level JSON | Debug: corrupt / delete L42 JSON, open L42 | `E-LVL-001` non-fatal; "Level unavailable" + Retry; level **not** skipped, not marked cleared, no coins | Not run |
| QA-AUD-ALL | Sound suite | Run shared suite AUD-01…AUD-24 ([Sound doc §11](../../SOUND_EFFECTS_IMPLEMENTATION.md)) for Toy Trains | All AUD rows pass for this game | Not run |
| QA-LOG-ALL | Logging suite | Run shared suite LOG-01…LOG-22 ([Logging doc §15](../../LOGGING_AND_ERROR_TRACKING.md)) for Toy Trains | All LOG rows pass for this game | Not run |
