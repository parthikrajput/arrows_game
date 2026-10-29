# 07 — Frontend Implementation & QA
> Flutter implementation rules (architecture, BLoCs, renderer, input, audio, ads/IAP/consent, persistence, analytics, performance, errors) અને Phase 1 નો QA checklist.

**Related docs:** [Phase 1 index](./README.md) · [Shared Core Standard §12–§15](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [06 Screens](./06_UI_UX_SCREENS.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Architecture
| Area | Decision (standard §13) |
|---|---|
| Framework | Flutter 3.x stable, Dart 3, Impeller (iOS default, Android enabled) |
| Rendering | `CustomPainter` + `Ticker` game loop — **Flame નહીં** |
| State | `flutter_bloc` (Bloc/Cubit) — **Riverpod નહીં** |
| Engine | `packages/puzzle_core` (pure Dart, no Flutter import): model, rules, 49 mechanics, solver, generator, PRNG — 4 games share |
| Persistence | `hive_ce` typed adapters, versioned save |
| Ads / Consent | `google_mobile_ads` (UMP included) |
| IAP | `in_app_purchase` + Firebase Cloud Function `verifyPurchase` (`cloud_functions` callable) |
| Firebase | `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` |
| Leaderboards | `games_services` |
| Audio / Haptics | `audioplayers` (`AudioService` + `AudioPool`) — [Sound standard](../../SOUND_EFFECTS_IMPLEMENTATION.md) / Flutter `HapticFeedback` |
| Logging / errors | `AppLogger` + Crashlytics + `firebase_performance`, `TapLoggerScope` — [Logging standard](../../LOGGING_AND_ERROR_TRACKING.md) |
| L10n | `flutter_localizations` + ARB (en, gu, hi) |

**Layering rule:** UI widgets ⇒ Blocs ⇒ services/repositories ⇒ `puzzle_core`. Engine pure & synchronous: `MoveResult apply(BoardState s, Move m)`. Animation માત્ર presentation — engine state animation પહેલાં જ compute થાય.

```
Tap ─► BoardView (hit-test) ─► GameBloc.add(SnakeTapped)
        GameBloc ─► puzzle_core.Engine.apply() ─► MoveResult{next, animations, events}
        GameBloc emit(animating) ─► GameScene.play(motion) ─► Ticker frames ─► BoardPainter
        motion done ─► GameBloc.add(AnimationCompleted) ─► commit next ─► queued tap?
```

## 2. Folder Tree
```
repo/
├── apps/
│   └── snakes_slither/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── app/                 app.dart, router.dart, theme/tokens.dart, theme/text_styles.dart
│       │   ├── bootstrap/           firebase_init.dart, consent_flow.dart, age_gate.dart
│       │   ├── features/
│       │   │   ├── gameplay/        bloc/ (game_bloc.dart, game_event.dart, game_state.dart)
│       │   │   │                    render/ (board_painter.dart, snake_renderer.dart, game_scene.dart, obstacle_renderer.dart)
│       │   │   │                    input/ (board_view.dart) · view/ (gameplay_page.dart, hud.dart, booster_bar.dart)
│       │   │   ├── home/  level_map/  daily/  streak/  rush/  rewards/  spin/
│       │   │   ├── shop/  vip/  leaderboards/  settings/  tutorial/
│       │   ├── services/            ads_service.dart, iap_service.dart, audio_service.dart, haptics.dart,
│       │   │                        analytics.dart, remote_config.dart, time_service.dart, games_services.dart
│       │   ├── data/                save/ (save_data.dart, adapters.g.dart, migrations.dart), repositories/
│       │   └── l10n/                app_en.arb, app_gu.arb, app_hi.arb
│       ├── assets/                  levels/phase_1.json.gz, levels/daily_seed_overrides.json, audio/, images/, fonts/
│       ├── test/                    widget + bloc tests
│       ├── integration_test/        flows (FTUE, revive, purchase sandbox)
│       └── pubspec.yaml
├── packages/
│   └── puzzle_core/
│       ├── lib/src/                 model/, rules/engine.dart, mechanics/m001_single_blocker.dart … m049_guardian.dart,
│       │                            solver/, generator/, prng/xoshiro128ss.dart, difficulty.dart, level_codec.dart
│       └── test/                    rules/, mechanics/m001_test.dart … m049_test.dart, solver/, generator/
├── tools/
│   ├── levelgen/                    Dart CLI (generator + designer overrides)
│   └── validator/                   CI level validator
└── functions/                       Firebase Cloud Functions (verifyPurchase)
```

## 3. BLoCs, States & Events
| Bloc / Cubit | Owns | Key events / methods |
|---|---|---|
| `BootstrapCubit` | Init, age gate, consent, save load | `start()`, `ageSubmitted(year)`, `consentDone()` |
| `ProgressCubit` | `highestCleared`, best stars, `adReviveUsed` | `levelWon(level, stars)`, `markAdRevive(level)` |
| `WalletCubit` | Coins, booster inventory | `earn(source, n)`, `spend(sink, n) → bool`, `grantBooster(type, n)` |
| `GameBloc` | One attempt (per level / daily) | see table below |
| `RushBloc` | Golden Slither Rush round | `RushStarted`, `RushTapped`, `RushTick`, `RushFinished` |
| `DailyBloc` | Today's board, claim | `DailyOpened`, `DailyWon`, `DayKeyChanged` |
| `StreakCubit` | Ladder, saver, trophy | `onDailyClear()`, `useSaver(via)` |
| `SpinCubit` | Lucky Lily Wheel | `spinFree()`, `spinAd()` |
| `ShopBloc` | IAP products, purchases, restore | `ProductsRequested`, `BuyRequested(sku)`, `PurchaseUpdated`, `RestoreRequested` |
| `AdsCubit` | Load flags, counters, cooldown, VIP | `onWin(ctx)`, `showRewarded(placement)` |
| `SettingsCubit` | Toggles, language, colour-blind, reduced motion | `toggle(key)` |
| `LeaderboardCubit` | Sign-in, submit queue | `submit(board, value)` |

### 3.1 GameBloc Events
| Event | Effect |
|---|---|
| `LevelStarted(level, mode)` | Load JSON ⇒ `BoardState`, hearts 3 (Wed daily 1), boosters caps reset |
| `SnakeTapped(cellIndex)` | Busy ⇒ store as queued (queue 1, overwrite). Idle ⇒ `Engine.apply` |
| `ObstacleTapped(id)` | Interactive mechanic Move |
| `AnimationCompleted` | Commit pending state, run win/hearts checks, process queued tap |
| `PreviewStarted(cell)` / `PreviewEnded` | Lane trace (no Move) |
| `HintRequested` | Solution prefix / isolate solver (50 ms, 50k nodes) |
| `UndoRequested` | Pop last Move snapshot (stack empty ⇒ button disabled) |
| `ShieldActivated` | `shieldCharges = 2` |
| `HammerModeToggled` / `HammerTargetSelected(target)` | Remove target (non-lane exit triggers only, standard §16.31) ⇒ **`undoStack.clear()`** (§16.23) |
| `ReviveWithAd` / `ReviveWithCoins` / `ReviveDeclined` | +1 heart or ⇒ failed |
| `Paused` / `Resumed` / `Restarted` | Restart ⇒ new attempt (`adReviveUsed` unchanged) |

### 3.2 GameState
```dart
enum GameStatus { intro, playing, animating, hammerTarget, secondChance, won, failed }
```
Fields: `status`, `board` (`BoardState`), `hearts`, `shieldCharges`, `moves`, `heartsLost`, `usedRevive`, `refillsUsed`, `boosterUses{hint,undo,shield,hammer}`, `hintTarget`, `undoStack`, `pendingResult`, `queuedTap`, `preview`. `Equatable` props ⇒ widget rebuild minimal (`BlocSelector` per HUD part).

## 4. Game Loop & Renderer
Rules: static board (grid, obstacles, **non-moving snakes**) ⇒ `PictureRecorder` cache, state change (Move commit / motion start) પર જ rebuild. Per-frame માત્ર moving snake + preview paint. Shadows picture માં pre-baked (cache build વખતે એક વાર blur; per-frame `MaskFilter.blur` નહીં). `Color.withValues(alpha:)` (deprecated `withOpacity` નહીં).

### 4.1 Geometry, Motion & Scene
```dart
// lib/features/gameplay/render/game_scene.dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'board_painter.dart'; // BoardBackground, SnakeRenderer (circular import is fine in Dart)

enum Dir { up, down, left, right }

extension DirX on Dir {
  Offset get unit => switch (this) {
        Dir.up => const Offset(0, -1),
        Dir.down => const Offset(0, 1),
        Dir.left => const Offset(-1, 0),
        Dir.right => const Offset(1, 0),
      };
}

@immutable
class Cell {
  const Cell(this.x, this.y);
  final int x;
  final int y;

  @override
  bool operator ==(Object other) => other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

@immutable
class SnakeSprite {
  const SnakeSprite({
    required this.id,
    required this.body, // body[0] = head
    required this.dir,
    required this.color,
    this.caterpillar = false,
  });

  final String id;
  final List<Cell> body;
  final Dir dir;
  final Color color;
  final bool caterpillar;
}

@immutable
class BoardLayout {
  const BoardLayout({required this.origin, required this.cell, required this.cols, required this.rows});

  final Offset origin;
  final double cell;
  final int cols;
  final int rows;

  Offset center(Cell c) => origin + Offset((c.x + 0.5) * cell, (c.y + 0.5) * cell);

  Rect get rect => origin & Size(cols * cell, rows * cell);

  Cell? cellAt(Offset local) {
    final p = local - origin;
    final x = (p.dx / cell).floor();
    final y = (p.dy / cell).floor();
    if (x < 0 || y < 0 || x >= cols || y >= rows) return null;
    return Cell(x, y);
  }

  /// Phase 1 fit rule (06 §4): 16 dp gutters, min cell 29 dp checked by caller.
  static BoardLayout fit(Size area, int cols, int rows) {
    const gutter = 16.0;
    final cell = math.min((area.width - 2 * gutter) / cols, area.height / rows).floorToDouble();
    final size = Size(cols * cell, rows * cell);
    final origin = Offset((area.width - size.width) / 2, (area.height - size.height) / 2);
    return BoardLayout(origin: origin, cell: cell, cols: cols, rows: rows);
  }
}

/// Track = tail → … → head → lane waypoints (canvas coords). The snake is the
/// sub-path [tailOffset, tailOffset + bodyLength] of this track.
ui.PathMetric buildTrack(BoardLayout l, SnakeSprite s, List<Offset> laneWaypoints) {
  final path = ui.Path();
  final tail = l.center(s.body.last);
  path.moveTo(tail.dx, tail.dy);
  for (var i = s.body.length - 2; i >= 0; i--) {
    final p = l.center(s.body[i]);
    path.lineTo(p.dx, p.dy);
  }
  for (final w in laneWaypoints) {
    path.lineTo(w.dx, w.dy);
  }
  return path.computeMetrics().first;
}

/// Straight lane of [cells] cells in front of the head (no mirrors/burrows).
List<Offset> straightLane(BoardLayout l, SnakeSprite s, double cells) =>
    [l.center(s.body.first) + s.dir.unit * (cells * l.cell)];

double bodyLength(BoardLayout l, SnakeSprite s) => (s.body.length - 1) * l.cell;

enum MotionKind { exit, bump }

class SnakeMotion {
  SnakeMotion({
    required this.snake,
    required this.kind,
    required this.track,
    required this.bodyLen,
    required this.travel,
    required this.duration,
  });

  /// Exit: lane = cells to edge + body length + 1, travel = lane length.
  factory SnakeMotion.exit(BoardLayout l, SnakeSprite s, int cellsToEdge) {
    final laneCells = cellsToEdge + s.body.length + 1.0;
    final ms = math.min(450, 250 + 25 * cellsToEdge);
    return SnakeMotion(
      snake: s,
      kind: MotionKind.exit,
      track: buildTrack(l, s, straightLane(l, s, laneCells)),
      bodyLen: bodyLength(l, s),
      travel: laneCells * l.cell,
      duration: Duration(milliseconds: ms),
    );
  }

  /// Bump: blocker is [cellsToBlocker] cells ahead (1 = adjacent).
  factory SnakeMotion.bump(BoardLayout l, SnakeSprite s, int cellsToBlocker) {
    final travelCells = (cellsToBlocker - 1) + 0.25;
    return SnakeMotion(
      snake: s,
      kind: MotionKind.bump,
      track: buildTrack(l, s, straightLane(l, s, travelCells)),
      bodyLen: bodyLength(l, s),
      travel: travelCells * l.cell,
      duration: const Duration(milliseconds: 380),
    );
  }

  final SnakeSprite snake;
  final MotionKind kind;
  final ui.PathMetric track;
  final double bodyLen;
  final double travel;
  final Duration duration;
  double t = 0; // 0..1

  static const double _impact = 0.45;

  /// Distance of the tail along [track].
  double get tailOffset {
    switch (kind) {
      case MotionKind.exit:
        return Curves.easeInOutCubic.transform(t) * travel;
      case MotionKind.bump:
        if (t < _impact) return Curves.easeOut.transform(t / _impact) * travel;
        final back = (t - _impact) / (1 - _impact);
        return (1 - Curves.easeOutCubic.transform(back)) * travel;
    }
  }

  /// Perpendicular head-bonk shake after impact.
  Offset shakeOffset(double cell) {
    if (kind != MotionKind.bump || t < _impact) return Offset.zero;
    final u = (t - _impact) / (1 - _impact);
    final tan = track.getTangentForOffset(math.min(track.length, bodyLen + travel));
    final v = tan?.vector ?? const Offset(1, 0);
    final n = Offset(-v.dy, v.dx);
    return n * (math.sin(u * math.pi * 6) * (1 - u) * cell * 0.06);
  }
}

class BoardPictureCache {
  ui.Picture? _picture;
  Object? _key;

  ui.Picture obtain(Object key, Size size, void Function(Canvas canvas) draw) {
    final cached = _picture;
    if (cached != null && key == _key) return cached;
    cached?.dispose();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Offset.zero & size);
    draw(canvas);
    final picture = recorder.endRecording();
    _picture = picture;
    _key = key;
    return picture;
  }

  void dispose() {
    _picture?.dispose();
    _picture = null;
    _key = null;
  }
}

/// Mutable render model driven by the Ticker. GameBloc pushes snapshots in.
class GameScene extends ChangeNotifier {
  GameScene({this.reducedMotion = false});

  bool reducedMotion;
  BoardLayout? _layout;
  int _cols = 1;
  int _rows = 1;
  List<SnakeSprite> _snakes = const [];
  int _version = 0;
  SnakeMotion? motion;
  List<Offset>? preview; // lane waypoints while long-pressing
  bool previewBlocked = false;
  double wigglePhase = 0;
  final BoardPictureCache _cache = BoardPictureCache();
  VoidCallback? _onMotionDone;

  BoardLayout? get layout => _layout;
  bool get isAnimating => motion != null;

  void setBoard({required int cols, required int rows, required List<SnakeSprite> snakes}) {
    _cols = cols;
    _rows = rows;
    _snakes = List.unmodifiable(snakes);
    _layout = null; // re-fit on next layout pass
    _version++;
    notifyListeners();
  }

  /// Called from LayoutBuilder: must NOT notify listeners.
  void updateLayout(Size area) {
    final next = BoardLayout.fit(area, _cols, _rows);
    final prev = _layout;
    if (prev == null || prev.cell != next.cell || prev.origin != next.origin) {
      _layout = next;
      _version++;
    }
  }

  void play(SnakeMotion m, {required VoidCallback onDone}) {
    motion = m;
    _onMotionDone = onDone;
    _version++; // moving snake leaves the static layer
    notifyListeners();
  }

  void tick(Duration dt) {
    final m = motion;
    if (m == null) return;
    m.t = math.min(1.0, m.t + dt.inMicroseconds / m.duration.inMicroseconds);
    wigglePhase += dt.inMicroseconds / 1e6 * math.pi * 4;
    if (m.t >= 1.0) {
      motion = null;
      _version++;
      final done = _onMotionDone;
      _onMotionDone = null;
      done?.call();
    }
    notifyListeners();
  }

  void setPreview(List<Offset>? waypoints, {bool blocked = false}) {
    preview = waypoints;
    previewBlocked = blocked;
    notifyListeners();
  }

  ui.Picture staticLayer(Size size) {
    final l = _layout!;
    final movingId = motion?.snake.id;
    return _cache.obtain((_version, size, movingId), size, (canvas) {
      BoardBackground.draw(canvas, l);
      for (final s in _snakes) {
        if (s.id != movingId) SnakeRenderer.drawStatic(canvas, l, s);
      }
    });
  }

  @override
  void dispose() {
    _cache.dispose();
    super.dispose();
  }
}
```

### 4.2 Painters (snake body via PathMetrics, slither wiggle, bump)
```dart
// lib/features/gameplay/render/board_painter.dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'game_scene.dart';

class BoardPainter extends CustomPainter {
  BoardPainter({required this.scene}) : super(repaint: scene);

  final GameScene scene;

  @override
  void paint(Canvas canvas, Size size) {
    final l = scene.layout;
    if (l == null) return;
    canvas.drawPicture(scene.staticLayer(size));
    final m = scene.motion;
    if (m != null) {
      SnakeRenderer.drawMoving(canvas, l, m, scene.wigglePhase, scene.reducedMotion);
    }
    final p = scene.preview;
    if (p != null) PreviewRenderer.draw(canvas, l, p, blocked: scene.previewBlocked);
  }

  // Repaints are driven by `repaint: scene`; rebuild only when the scene object changes.
  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => oldDelegate.scene != scene;
}

class BoardBackground {
  static void draw(Canvas canvas, BoardLayout l) {
    final r = RRect.fromRectAndRadius(l.rect.inflate(8), const Radius.circular(24));
    // Soft shadow baked once into the cached picture (not per frame).
    canvas.drawRRect(
      r.shift(const Offset(0, 6)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawRRect(r, Paint()..color = const Color(0xFFDCEFD8));
    final dot = Paint()..color = const Color(0xFF9CCC9C).withValues(alpha: 0.6);
    for (var y = 0; y < l.rows; y++) {
      for (var x = 0; x < l.cols; x++) {
        canvas.drawCircle(l.center(Cell(x, y)), l.cell * 0.05, dot);
      }
    }
    // ObstacleRenderer.drawAll(canvas, l, obstacles) is called here in the full build.
  }
}

class SnakeRenderer {
  static void drawStatic(Canvas canvas, BoardLayout l, SnakeSprite s) {
    final path = ui.Path();
    final head = l.center(s.body.first);
    path.moveTo(head.dx, head.dy);
    for (final c in s.body.skip(1)) {
      final p = l.center(c);
      path.lineTo(p.dx, p.dy);
    }
    _drawBody(canvas, path, s, l.cell);
    _drawHead(canvas, head, s.dir.unit, s, l.cell);
  }

  static void drawMoving(Canvas canvas, BoardLayout l, SnakeMotion m, double phase, bool reducedMotion) {
    final start = math.max(0.0, m.tailOffset);
    final end = math.min(m.track.length, start + m.bodyLen);
    final amp = (reducedMotion || m.kind == MotionKind.bump) ? 0.0 : l.cell * 0.08;
    final body = wigglePath(m.track, start, end, amp, phase, l.cell);
    final shake = m.shakeOffset(l.cell);
    canvas.save();
    canvas.translate(shake.dx, shake.dy);
    _drawBody(canvas, body, m.snake, l.cell);
    final tan = m.track.getTangentForOffset(end);
    if (tan != null) _drawHead(canvas, tan.position, tan.vector, m.snake, l.cell);
    canvas.restore();
  }

  /// Samples the track between [start] and [end] and offsets each point along
  /// the normal by a sine wave (slither wiggle). Envelope keeps head/tail on the lane.
  static ui.Path wigglePath(ui.PathMetric track, double start, double end, double amp, double phase, double cell) {
    final out = ui.Path();
    final span = math.max(1.0, end - start);
    const step = 4.0;
    var first = true;
    for (var d = start; d <= end + 0.001; d += step) {
      final at = math.min(d, end);
      final tan = track.getTangentForOffset(at);
      if (tan == null) continue;
      final v = tan.vector;
      final len = v.distance;
      final normal = len == 0 ? Offset.zero : Offset(-v.dy / len, v.dx / len);
      final u = (at - start) / span;
      final w = math.sin((at / cell) * math.pi * 2 + phase) * amp * math.sin(u * math.pi);
      final p = tan.position + normal * w;
      if (first) {
        out.moveTo(p.dx, p.dy);
        first = false;
      } else {
        out.lineTo(p.dx, p.dy);
      }
    }
    return out;
  }

  static Paint _stroke(Color c, double width) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static void _drawBody(Canvas canvas, ui.Path path, SnakeSprite s, double cell) {
    final w = cell * 0.62;
    canvas.save();
    canvas.translate(0, cell * 0.05);
    canvas.drawPath(path, _stroke(Color.lerp(s.color, Colors.black, 0.18)!, w)); // bevel lip
    canvas.restore();
    canvas.drawPath(path, _stroke(s.color, w));
    canvas.save();
    canvas.translate(-cell * 0.05, -cell * 0.07);
    canvas.drawPath(path, _stroke(Colors.white.withValues(alpha: 0.35), cell * 0.16)); // highlight
    canvas.restore();
    _drawPattern(canvas, path, s, cell);
  }

  /// Colour-blind pattern (dots shown; full build switches on SnakePattern per colour).
  static void _drawPattern(Canvas canvas, ui.Path path, SnakeSprite s, double cell) {
    final paint = Paint()..color = Color.lerp(s.color, Colors.white, 0.45)!;
    final gap = s.caterpillar ? cell * 0.35 : cell * 0.5;
    final radius = s.caterpillar ? cell * 0.11 : cell * 0.07;
    for (final metric in path.computeMetrics()) {
      for (var d = gap; d < metric.length - cell * 0.3; d += gap) {
        final tan = metric.getTangentForOffset(d);
        if (tan != null) canvas.drawCircle(tan.position, radius, paint);
      }
    }
  }

  static void _drawHead(Canvas canvas, Offset c, Offset dirVec, SnakeSprite s, double cell) {
    final len = dirVec.distance;
    final f = len == 0 ? const Offset(1, 0) : dirVec / len;
    final side = Offset(-f.dy, f.dx);
    canvas.drawCircle(c, cell * 0.38, Paint()..color = s.color);
    final white = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1B2B1F);
    final eyeBase = c + f * (cell * 0.12);
    for (final sign in const [-1.0, 1.0]) {
      final e = eyeBase + side * (cell * 0.15 * sign);
      canvas.drawCircle(e, cell * 0.10, white);
      canvas.drawCircle(e + f * (cell * 0.03), cell * 0.05, pupil);
    }
  }
}

class PreviewRenderer {
  static void draw(Canvas canvas, BoardLayout l, List<Offset> points, {required bool blocked}) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = blocked ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    final path = ui.Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += l.cell * 0.3) {
        final tan = metric.getTangentForOffset(d);
        if (tan != null) canvas.drawCircle(tan.position, l.cell * 0.06, paint);
      }
    }
    if (blocked) {
      final x = points.last;
      final k = l.cell * 0.18;
      final cross = Paint()
        ..color = const Color(0xFFD32F2F)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(x + Offset(-k, -k), x + Offset(k, k), cross);
      canvas.drawLine(x + Offset(-k, k), x + Offset(k, -k), cross);
    }
  }
}
```
- Mirror/burrow routes: engine `MoveResult` route cells ⇒ `laneWaypoints` (burrow ⇒ two clipped segments; mushroom corners). Caterpillar skin = beads pattern (`caterpillar: true`).
- Board 30 snakes: static picture rebuild ≤ 2 ms (mid-tier); per-frame paint = 1 snake.

## 5. Input Handling
```dart
// lib/features/gameplay/input/board_view.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../render/board_painter.dart';
import '../render/game_scene.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key,
    required this.scene,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  });

  final GameScene scene;
  final void Function(Offset local) onTap;
  final void Function(Offset local) onLongPressStart;
  final VoidCallback onLongPressEnd;

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    widget.scene.addListener(_syncTicker);
  }

  // Run the ticker only while something animates (battery).
  void _syncTicker() {
    if (widget.scene.isAnimating && !_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    } else if (!widget.scene.isAnimating && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _last;
    _last = elapsed;
    widget.scene.tick(dt);
  }

  @override
  void dispose() {
    widget.scene.removeListener(_syncTicker);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        widget.scene.updateLayout(constraints.biggest);
        return RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (r) => r.onTapUp = (d) => widget.onTap(d.localPosition),
            ),
            LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(duration: const Duration(milliseconds: 350)),
              (r) {
                r.onLongPressStart = (d) => widget.onLongPressStart(d.localPosition);
                r.onLongPressEnd = (_) => widget.onLongPressEnd();
              },
            ),
          },
          child: RepaintBoundary(
            child: CustomPaint(size: constraints.biggest, painter: BoardPainter(scene: widget.scene)),
          ),
        );
      },
    );
  }
}
```
Hit-test (GameBloc side, [01 §5.7](./01_GAME_CONCEPT_AND_RULES.md#57-tap-priority--hit-test)): `layout.cellAt` ⇒ interactive obstacle cell (lever, lilypad, fern fork, whirl stump, root gear — standard §16.19: interactive cell > snake cell) ⇒ upper layer snake ⇒ empty cell ⇒ nearest snake segment within 0.5 cell ⇒ ignore. Long-press release ⇒ no tap (gesture arena: long-press wins after 350 ms). Input queue 1 (last tap wins). Multi-touch: first pointer only.

## 6. Audio & Haptics
Audio નો પૂરો spec shared standard માં છે: **[SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md)** (architecture, mixer/ducking, settings, Dart `AudioService`, CI `tools/audio_check`, QA AUD-01…AUD-24). આ game માત્ર `assets/audio/theme.json` (eventId ⇒ themed files) આપે છે.

- **Engine:** `AudioService` singleton (app layer) + `SfxBank` of `AudioPool`s (low-latency, pre-loaded) + 2 × `AudioPlayer` music crossfade. `puzzle_core` માત્ર `GameEvent` emit કરે; `GameBloc` તેને `SoundCue(eventId)` માં map કરે (bump sound = contact frame પર).
- **Assets:** SFX `.wav` PCM 16-bit **mono** 44.1 kHz (`sfx/<event_id>_v<N>.wav`); music/stingers `.m4a` AAC 128 kbps (`music/<track_id>.m4a`). **OGG નહીં.** Budget ≤ 10 MB (Phase 1).
- **Voices:** max **8** concurrent SFX voices total; same event ⇒ min 50 ms gap; pre-rendered variants (no runtime pitch shift).
- **Haptics:** Flutter `HapticFeedback` only (sound standard §5 haptic column); Settings → Haptics off ⇒ no calls. Third-party vibrate package નહીં.
- Errors: `E-AUD-001` asset missing / `E-AUD-002` pool create fail / `E-AUD-003` playback error ⇒ log + continue silently (game never blocks).

**Snakes Slither theme mapping** (sound standard §9; બાકીના event IDs §5 catalog મુજબ):

| Standard event ID | Snakes Slither sound |
|---|---|
| `path_tap` | Soft scale rustle |
| `path_exit` (3 variants) | Slithery "swish" + cute pop |
| `bump` | Soft "boink" on snout (+ `blocker_hit_hard` rock / `blocker_hit_soft` log material layer) |
| `locked_tap` | Sleepy "hmm-mm" (nuh-uh wobble) |
| `heart_lost` | Leaf heart-berry flutter-pop |
| `shield_absorb` | Safety Shell "clink" |
| `preview_start` | Tongue flick |
| `booster_hint` | Firefly sparkle |
| `booster_undo` | Reverse coil whoosh |
| `booster_hammer` | Cartoon stone smash |
| `gate_open` | Flower / lotus bud bloom |
| `lock_open` | Bamboo cage creak |
| `portal_whoosh` | Rabbit burrow "fwump" |
| `rotate` | Lilypad water swirl / stump creak |
| `eat` | Hungry Caterpillar chomp |
| `guardian_defeat` | Mongoose "poof" + cheer |
| `win_stinger` | Jungle marimba flourish |
| `coins_fly` | Soft gold-leaf coin tinkle |
| Music (`music_home`, `music_map`, `music_gameplay_t1…t5`, `music_rush`, `music_finale`, `music_daily`) | Marimba, kalimba, soft jungle ambience (tier biome mood) |

## 7. Ads, IAP & Consent Integration
### 7.1 Startup Order
1. Hive open + save load/migrate. 2. Firebase init (Crashlytics, Remote Config fetch with 3 s timeout ⇒ cached/defaults). 3. Age gate (first run). 4. UMP: `ConsentInformation.instance.requestConsentInfoUpdate(...)` ⇒ `ConsentForm.loadAndShowConsentFormIfRequired(...)`. 5. `MobileAds.instance.updateRequestConfiguration(RequestConfiguration(...))` — under-13: `tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes`, `maxAdContentRating: MaxAdContentRating.g`. 6. `MobileAds.instance.initialize()` (only if `canRequestAds`). 7. Preload rewarded + interstitial. 8. IAP `purchaseStream` listen + pending replay.

### 7.2 AdsService
- Interstitial decision: [04 §9.1](./04_BOOSTERS_COINS_SHOP.md#91-interstitial). Counters persisted in `ads` box after every change.
- Rewarded: reward only in `onUserEarnedReward`; `fullScreenContentCallback.onAdDismissedFullScreenContent` ⇒ reload; `lastFullscreenUtc` = dismiss time.
- Banner: `AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width)`; reserve height before load (no layout jump); hide on popups; VIP ⇒ never create.
- Backoff: 2 s / 8 s / 32 s, max 3 retries/session per format.

### 7.3 IAP
- `InAppPurchase.instance.queryProductDetails({'coins_s','coins_m','coins_l','coins_xl','starter_pack','vip_monthly'})`.
- Consumables `buyConsumable(autoConsume: true)` (Android); Starter Pack `buyNonConsumable`; VIP subscription via `buyNonConsumable` with subscription product.
- Every `PurchaseDetails` ⇒ `verifyPurchase` callable (platform, productId, verificationData) ⇒ grant ⇒ `completePurchase`. Idempotent by `purchaseID` (`iap.grantedIds` set).
- Restore: `restorePurchases()` ⇒ VIP expiry + Starter ownership.

## 8. Persistence (Hive, schema v1)
Box `save` (single `SaveData`, typed adapters) + box `save_backup` (copy after each level win). Write-through on every economy change; `flush()` on `AppLifecycleState.paused`.

| Key (standard §14) | Fields |
|---|---|
| `progress` | `highestCleared`, `stars[level]`, `adReviveUsed[level]` |
| `wallet` | `coins`, `boosters{hint, undo, shield, hammer}` |
| `streak` | `day`, `cycleSaverUsed`, `lastClaimDayKey`, `totalDays`, `trophyTier` |
| `time` | `lastTrustedUtc`, `lastServerUtc` |
| `ads` | `winsSinceInterstitial`, `lastFullscreenUtc`, `dailyShopAds`, `dailySpinAds`, `dayKey` |
| `iap` | `vipActiveUntil`, `starterPackShown` |
| `settings` | `sound`, `music`, `haptics`, `language`, `ageBand` |

**Game-specific additions (`ext`, same schema v1):** `ext.tutorialSteps` (done FTUE/booster/intro ids), `ext.rushPendingLevel`, `ext.daily{cachedBoard, paramsLevel, adReviveUsedDayKey, pendingVerify, frozen, starsByDay}`, `ext.spin{lastFreeDayKey}`, `ext.iap{starterWindowEndUtc, starterPurchased, grantedIds}`, `ext.interstitialsToday`, `ext.settings{colourBlind, reducedMotion, brighterNights}`, `ext.giftClaimed[level]`.
- Migrations: `schemaVersion` int; `migrations.dart` step functions; unknown future version ⇒ read-only + "Update app".
- Attempt state persist **નથી** (process kill ⇒ level restart).

## 9. Level Data & Remote Config
- `phase_1.json.gz` decode isolate માં app start પછી (lazy, ~500 levels), `LevelRepository.get(level)` cached `LevelDef`.
- `LevelDef` validation on load (schema 3, ids unique, `slot` + `tag` present); fail ⇒ `E-LVL-001/002` + "Level unavailable" dialog (§12).
- Remote Config keys: [04 §13](./04_BOOSTERS_COINS_SHOP.md#13-remote-config-keys-launch-defaults) + `maxPhase` (1), `levelOverrides` (bundled alternates), `featureFlags{spin, rush, daily}`.

## 10. Analytics Events
Standard minimum (§15): `level_start{level, attempt}`, `level_win{level, moves, hearts_lost, stars, duration_s}`, `level_fail{level, moves}`, `booster_use{type, level}`, `revive{type: ad|coins, level}`, `ad_show{format, placement}`, `iap_purchase{sku}`, `daily_clear{dayKey, modifier}`, `streak_update{day}`, `ftue_step{step}`.

Game additions: `coins_earn{source, amount}`, `coins_spend{sink, amount}`, `gift_open{level}`, `chest_open{phase}`, `rush_end{level, snakes, coins, full_clear}`, `spin_result{segment, via}`, `streak_saver{via}`, `daily_start{dayKey, modifier, paramsLevel}`, `time_lock{deltaH}`, `hint_fail{level}`, `ad_fail{format, code}`, `consent_result{status}`.
- Under-13: ad personalization signals off; no user-id. Event params ≤ 25, names snake_case.

## 11. Performance Budget
| Metric | Budget |
|---|---|
| Frame rate | **60 fps** low-tier Android (2 GB RAM, Redmi 9A class) with 30 snakes; **120 fps** ProMotion iOS / 120 Hz Android flagships |
| Raster p95 | **< 8 ms** (mid-tier) |
| Static layer rebuild | ≤ 2 ms mid-tier (once per Move) |
| Per-frame paint | 1 moving snake + preview; no `MaskFilter.blur` per frame |
| Hint solver | Isolate, 50 ms, 50k nodes |
| Cold start | ≤ 3 s to Home (mid-tier) |
| Memory | ≤ 250 MB peak low-tier |
| App size | ≤ 60 MB download (audio compressed, fonts subset) |

**Device matrix (performance + layout):**
| Tier | Devices | Screen |
|---|---|---|
| Low | Redmi 9A (2 GB, Android 10), Samsung Galaxy A03 Core | 720×1600 (20:9) |
| Mid | Redmi Note 12, Samsung Galaxy A34 | 1080×2400 (20:9) |
| High | Pixel 8 (120 Hz), Samsung Galaxy S23 | 1080×2400 |
| iOS | iPhone SE 2nd gen (16:9), iPhone 13, iPhone 15 Pro (ProMotion, Dynamic Island) | — |
| Tablet | iPad 9th gen (4:3), Samsung Galaxy Tab A8 | — |
| Ultra-wide | Sony Xperia 10 (21:9) | 1080×2520 |

## 12. Error Handling
Logging, error codes, tap trace, replay અને "Report a problem" નો પૂરો spec: **[LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md)**. બધું `AppLogger` (ring buffer 300 + rotating file + Crashlytics breadcrumbs/non-fatals) દ્વારા; app root પર `TapLoggerScope` દરેક tap (`board:cell(x,y):p7`, `btn:shop.buy.hint3`) record કરે; tappable widgets `LoggedTap` / `LoggedButton`.

| Case | Code | Handling |
|---|---|---|
| Level JSON corrupt / parse fail | `E-LVL-001` | Non-fatal + **"Level unavailable"** dialog: Retry / Home. Level ક્યારેય skip કે cleared mark **નહીં** |
| Level schema mismatch / missing level | `E-LVL-002` | Same as above ("Level unavailable" + Retry) |
| Daily generator 64 attempts fail | `E-LVL-003` | Classic fallback board `daily_fallback.json` ([05 §11 D13](./05_DAILY_CHALLENGE_AND_STREAK.md#11-edge-cases)) |
| Hint solver timeout | `E-LVL-004` | "Try Coil-Back Undo" toast, Hint consume નહીં |
| Soft-lock (solver: no winning sequence) | `E-GAME-004` | "Stuck" sheet: Undo / Restart, no heart loss, no fail screen |
| Invariant violated (hearts < 0 વગેરે) | `E-GAME-001` | Clamp + non-fatal with replay |
| Stuck animation > 2 s | `E-GAME-003` | Force-complete animation, commit state |
| Save open fail / corrupt / migration / write | `E-SAVE-001` / `E-SAVE-002` / `E-SAVE-003` / `E-SAVE-004` | Corrupt ⇒ restore `save_backup` (`E-SAVE-002`); both bad ⇒ new save + "Restore purchases" prompt |
| Ad load / show fail | `W-ADS-001` / `W-ADS-002` | Button disabled + "Ad unavailable"; backoff; flow never blocks |
| Rewarded completed but reward missing | `E-ADS-003` | No grant; log |
| IAP error / verify fail / pending > 24 h / restore fail | `E-IAP-001…004` | Purchase un-completed ⇒ retry next start; no grant; toast |
| Server time / Remote Config fetch fail | `W-NET-001` / `W-NET-002` | Cached/defaults |
| Clock tamper | `W-TIME-001` | Time-travel lock UI ([05 §8](./05_DAILY_CHALLENGE_AND_STREAK.md#8-day-key--anti-cheat)) |
| Audio asset / pool / playback | `E-AUD-001…003` | Continue silently |
| Layout / build exception | `E-UI-001` | Non-fatal |
| Offline | — | Everything playable except IAP ("Store unavailable"), leaderboards (queued), consent refresh |
| games_services unavailable | — | Hide sign-in errors; local stats shown |
| Uncaught | fatal | `FlutterError.onError` + `PlatformDispatcher.instance.onError` ⇒ `AppLogger` ⇒ Crashlytics |

Settings → Privacy → "Share diagnostics" off ⇒ Crashlytics/analytics collection + replay upload off (local log only). Help → "Report a problem" ⇒ `submitBugReport` ([06 §5.6](./06_UI_UX_SCREENS.md#56-pause--settings)).

## 13. CI & Test Strategy
- `puzzle_core`: unit tests (rules, 49 mechanics, solver, PRNG golden vectors, generator determinism), coverage ≥ 90% lines.
- **Level validator CI** (`tools/validator`): runs on every PR touching levels/engine — all L1–500: 0-heart/0-booster solvable, D in band ±3, no forever-locked snake, min cell ≥ 29 dp, intro rule, FTUE Moves rule, combo bans ([03 §4](./03_OBSTACLE_CATALOG_PHASE_1.md#4-combo-rules-validator)), Rush seeds L25…L500 clearable, Daily seeds 3-year window. Fail ⇒ PR blocked.
- App: bloc tests (`bloc_test`), widget/golden tests for HUD and popups (3 locales × text scale 1.0/2.0), integration tests (FTUE L1–10, revive, purchase sandbox, daily claim with mocked clock).
- `flutter analyze` zero warnings; `dart format` check.

## 14. QA Checklist
Priority: P0 = launch blocker, P1 = must fix before 1.0.1. **Status: બધા "Not run"** (run થયા પછી જ Pass/Fail લખવું).

| ID | Area | Steps | Expected | Pri | Status |
|---|---|---|---|---|---|
| QA-RULE-01 | Rules engine | Tap snake with clear lane | Slithers out ≤ 450 ms, Moves +1, hearts same | P0 | Not run |
| QA-RULE-02 | Rules engine | Tap blocked snake | Bonk, back to place, hearts −1, Moves +1, board unchanged | P0 | Not run |
| QA-RULE-03 | Rules engine | Tap body middle / tail | Same as head tap | P0 | Not run |
| QA-RULE-04 | Rules engine | Locked tap (Frost Coil) | Wobble, no heart, no Move | P0 | Not run |
| QA-RULE-05 | Rules engine | Tap 3 times quickly during animation | Only last queued tap resolves after animation | P0 | Not run |
| QA-RULE-06 | Rules engine | Long-press 350 ms, release | Preview green/red; no Move; release not a tap | P0 | Not run |
| QA-RULE-07 | Rules engine | Canopy overlap cell tap | Upper snake receives tap | P1 | Not run |
| QA-RULE-08 | Rules engine | Last snake exits | Win; gems goal respected | P0 | Not run |
| QA-RULE-09 | Rules engine | Same state + same move replay ×100 | Identical result (determinism) | P0 | Not run |
| QA-HEART-01 | Hearts | Lose 3 hearts | Second Chance with 10-s ring | P0 | Not run |
| QA-HEART-02 | Revive | Watch ad revive, fail again, restart level, fail | Ad option disabled ("Used for this level") after restart | P0 | Not run |
| QA-HEART-03 | Revive | Clear level after ad revive, replay, fail | Ad revive available again | P0 | Not run |
| QA-HEART-04 | Heart Refill | Refill twice in one attempt | 3rd refill option hidden/disabled; coins −240 | P0 | Not run |
| QA-HEART-05 | Heart Refill | Refill with < 120 coins | Mini shop opens, countdown paused | P1 | Not run |
| QA-HEART-06 | Revive | Revive then continue | Board not reset | P0 | Not run |
| QA-HEART-07 | Revive | Kill app during rewarded ad | No revive granted, `adReviveUsed` not set | P1 | Not run |
| QA-STAR-01 | Stars | Win with 0 / 1 / 2 hearts lost | ★★★ / ★★ / ★ | P0 | Not run |
| QA-STAR-02 | Stars | Win after revive with 0 bumps after | ★ | P0 | Not run |
| QA-STAR-03 | Stars | Shield absorbs 2 bumps, win | ★★★ | P0 | Not run |
| QA-STAR-04 | Stars | Replay improves ★ → ★★★ | Stars updated, +20 bonus once, clear coins 0 | P0 | Not run |
| QA-BOOST-HINT-01 | Hint | Use Hint on prefix state | Glows `solution[next]`; Move count unchanged | P0 | Not run |
| QA-BOOST-HINT-02 | Hint | Use 3 Hints, try 4th | Disabled "3/3" | P0 | Not run |
| QA-BOOST-HINT-03 | Hint | Off-solution state with no solution | Toast "Try Coil-Back Undo", not consumed | P0 | Not run |
| QA-BOOST-UNDO-01 | Undo | Exit then Undo | Snake returns, Moves −1, counters restored | P0 | Not run |
| QA-BOOST-UNDO-02 | Undo | Bump then Undo | Moves restored, heart NOT returned | P0 | Not run |
| QA-BOOST-UNDO-03 | Undo | Make 2 Moves, Hammer, then Undo | Undo history cleared by Hammer ⇒ Undo disabled; Hammer not undone; after 1 new Move, Undo reverts only that Move | P0 | Not run |
| QA-BOOST-UNDO-04 | Undo | 0 Moves | Button disabled | P1 | Not run |
| QA-BOOST-SHLD-01 | Shield | Activate, bump ×3 | First 2 absorbed, 3rd −1 heart | P0 | Not run |
| QA-BOOST-SHLD-02 | Shield | Activate twice in attempt | Second blocked (cap 1) | P0 | Not run |
| QA-BOOST-SHLD-03 | Shield | Restart with 1 charge left | Charge lapses | P1 | Not run |
| QA-BOOST-HAMR-01 | Hammer | Hammer key snake | Removed, cage opens (exit trigger) | P0 | Not run |
| QA-BOOST-HAMR-02 | Hammer | Target Mongoose / Hedge / cage | Not selectable | P0 | Not run |
| QA-BOOST-HAMR-03 | Hammer | Use 2, try 3rd | Disabled "2/2" | P0 | Not run |
| QA-BOOST-HAMR-04 | Hammer | Last snake with gems remaining | Blocked with toast | P1 | Not run |
| QA-BOOST-05 | Booster bar | Count 0 tap | Mini shop sheet with single/3-pack/ad coins | P0 | Not run |
| QA-BOOST-06 | Tutorials | L3, L8, L15, L25 first play | Grants 3/3/1/1, guided steps per 02 §5 | P0 | Not run |
| QA-COIN-01 | Coins | First clear Easy/Normal/Hard/Finale | +15/+20/+30/+50 | P0 | Not run |
| QA-COIN-02 | Coins | Replay cleared level | 0 clear coins, no 2X button | P0 | Not run |
| QA-COIN-03 | Coins | 2X Win | Base doubled, star bonus not doubled | P0 | Not run |
| QA-COIN-04 | Coins | Fresh install | 200 coins | P0 | Not run |
| QA-GIFT-01 | Gift Basket | Clear L10, L20, L30, L40 | 150 + Hint / Hammer / Shield / Undo | P0 | Not run |
| QA-GIFT-02 | Gift Basket | Clear L110, L210, L310, L410 | 180 / 210 / 250 / 300 coins | P0 | Not run |
| QA-GIFT-03 | Treasure Chest | Clear L500 | 1,000 + 2 each booster + badge, then Rush, then Phase Complete | P0 | Not run |
| QA-RUSH-01 | Golden Slither Rush | Clear L25, L125, L225, L325, L425 (first clear) | Rush intro after Level Complete; 30 s; 10/snake; snakes 20 / 22 / 25 / 28 / 30 | P0 | Not run |
| QA-RUSH-06 | Golden Slither Rush | Tap blocked golden snake; replay L25 | Wobble only, no heart, no coins; replay ⇒ no Rush | P0 | Not run |
| QA-RUSH-02 | Golden Slither Rush | Full clear before 0 s | +100 bonus | P0 | Not run |
| QA-RUSH-03 | Gift + Rush | Clear L50 / L100 | Gift Basket first, then Rush, no interstitial between or after | P0 | Not run |
| QA-RUSH-04 | Rush | Background app mid-round | Timer pauses, 3-2-1 on resume | P1 | Not run |
| QA-RUSH-05 | Rush | Kill app before Rush starts | Map banner resumes pending Rush | P1 | Not run |
| QA-DAILY-01 | Daily | Before L15 | Card locked "Unlocks at L15" | P0 | Not run |
| QA-DAILY-02 | Daily | Clear daily | +100 + streak day reward once; replay no reward | P0 | Not run |
| QA-DAILY-03 | Daily | Each weekday (mock dayKey) | Correct modifier & silhouette; fallbacks Thu/Fri/Sun | P0 | Not run |
| QA-DAILY-04 | Daily | Two devices same dayKey & progress tier | Identical board | P1 | Not run |
| QA-STRK-01 | Streak | Clear 7 consecutive days | Ladder rewards exact; Day 7 trophy; cycle restarts Day 1 | P0 | Not run |
| QA-STRK-02 | Streak | Miss exactly 1 day | Saver offer (ad / 200 coins); accept ⇒ continue, missed reward not given | P0 | Not run |
| QA-STRK-03 | Streak | Use Saver twice in one cycle | Second offer not shown ⇒ Day 1 | P0 | Not run |
| QA-STRK-04 | Streak | Miss 2 days | Day 1 reset, no offer | P0 | Not run |
| QA-ANTI-01 | Anti-cheat | Set clock back 3 h after claim | Time-travel lock on Daily/Streak/Spin | P0 | Not run |
| QA-ANTI-02 | Anti-cheat | Clock +1 day, claim, online | Streak freeze, coins kept | P0 | Not run |
| QA-ANTI-03 | Anti-cheat | Timezone jump back | No double claim | P0 | Not run |
| QA-SPIN-01 | Lucky Lily Wheel | Free spin, ad spin, 3rd | 2/day max; deterministic result per seed | P0 | Not run |
| QA-SPIN-02 | Lucky Lily Wheel | 100k simulated seeds | Distribution within ±0.3% of odds | P1 | Not run |
| QA-SPIN-03 | Lucky Lily Wheel | Settings → Spin odds | Odds table visible | P0 | Not run |
| QA-SHOP-01 | Shop | Buy each booster single/3-pack | Prices 60/150, 40/100, 80/200, 100/250; inventory updated | P0 | Not run |
| QA-SHOP-02 | Shop | Free coins ad ×6 | +50 ×5, 6th disabled | P0 | Not run |
| QA-IAP-01 | IAP | Sandbox buy each coin pack | 350/1,000/2,200/5,500 granted once after verify | P0 | Not run |
| QA-IAP-02 | IAP | Starter Pack after L15 | Offered 48 h, once; content exact | P0 | Not run |
| QA-IAP-03 | IAP | Kill app mid-purchase | Grant on next start, no duplicate | P0 | Not run |
| QA-VIP-01 | VIP | Subscribe | Interstitial + banners off; rewarded still offered | P0 | Not run |
| QA-VIP-02 | VIP | Let sandbox subscription expire | Ads return | P0 | Not run |
| QA-VIP-03 | Restore | Reinstall, Restore purchases | VIP + Starter ownership restored | P0 | Not run |
| QA-ADS-01 | Interstitial | Win L1–L14 | No interstitial; first at L15 win | P0 | Not run |
| QA-ADS-02 | Interstitial | 5 wins within 120 s of rewarded ad | Deferred until cooldown passes | P0 | Not run |
| QA-ADS-03 | Interstitial | 5th win lands on L20 (Gift) / L25 (Rush) | Deferred to next eligible win | P0 | Not run |
| QA-ADS-04 | Interstitial | After fail / Daily / Rush | Never | P0 | Not run |
| QA-ADS-05 | Interstitial | Restart app mid-count | `winsSinceInterstitial` persisted | P1 | Not run |
| QA-ADS-06 | Banner | Gameplay L11+ | Below booster bar with ≥ 8 dp gap + divider; never overlaps | P0 | Not run |
| QA-ADS-07 | Ads | Airplane mode | Ad buttons "Ad unavailable"; flows continue | P0 | Not run |
| QA-CONS-01 | Age gate | Birth year → under 13 | Child-directed, non-personalized, rating G | P0 | Not run |
| QA-CONS-02 | UMP | EEA VPN/debug geography | Consent form before any ad request | P0 | Not run |
| QA-CONS-03 | Privacy | Settings → Privacy choices | UMP form reopens | P1 | Not run |
| QA-SAVE-01 | Persistence | Kill app after win | Progress, coins, stars saved | P0 | Not run |
| QA-SAVE-02 | Persistence | Corrupt `save` box | Restored from backup | P1 | Not run |
| QA-SAVE-03 | Persistence | Upgrade from older build | Migration runs, no data loss | P0 | Not run |
| QA-OFF-01 | Offline | Play L1–30 offline | Fully playable; IAP disabled; leaderboard queued | P0 | Not run |
| QA-OFF-02 | Offline | Daily offline then online | Local grant, verify on reconnect | P0 | Not run |
| QA-PERF-01 | Performance | 30-snake T5 level on Redmi 9A | ≥ 60 fps steady (DevTools/`FrameTiming`) | P0 | Not run |
| QA-PERF-02 | Performance | Mid-tier raster p95 | < 8 ms | P0 | Not run |
| QA-PERF-03 | Performance | iPhone 15 Pro / Pixel 8 | 120 fps during slither | P1 | Not run |
| QA-PERF-04 | Performance | Cold start mid-tier | ≤ 3 s to Home | P1 | Not run |
| QA-LAYOUT-01 | Responsive | 11×11 board on 360×640 and 21:9 | Cell ≥ 29 dp, no overlap with notch/banner | P0 | Not run |
| QA-LAYOUT-02 | Responsive | iPad portrait/landscape | Board centered ≤ 600 dp, booster bar side in landscape | P1 | Not run |
| QA-A11Y-01 | Accessibility | Colour-blind mode on M005/M033/M041 levels | Patterns + icons distinguish every colour | P0 | Not run |
| QA-A11Y-02 | Accessibility | Text scale 200% | Menus readable, no clipped buttons | P0 | Not run |
| QA-A11Y-03 | Accessibility | Reduced motion | No wiggle/confetti/shake; flows intact | P1 | Not run |
| QA-A11Y-04 | Accessibility | TalkBack / VoiceOver on Home/Shop | All buttons labelled | P1 | Not run |
| QA-L10N-01 | Localization | Switch en / gu / hi | All strings translated, Gujarati/Hindi fonts render | P0 | Not run |
| QA-LB-01 | Leaderboards | New highest level, stars, streak | Submitted to Play Games / Game Center | P1 | Not run |
| QA-CI-01 | Level validator CI | Run validator on L1–500 | 100% pass; report D per level | P0 | Not run |
| QA-CI-02 | Level validator CI | Inject unsolvable level in PR | CI fails, PR blocked | P0 | Not run |
| QA-CI-03 | Generator | Same seed on Android/iOS/CLI | Identical level hash | P0 | Not run |
| QA-FIN-01 | Finale | Play L500 | Mongoose King HP 6, 10 instances, solvable per solution | P0 | Not run |
| QA-RULE-10 | Rules engine | M036 Hungry Caterpillar: clear lane without food | Bonk, −1 heart, Moves +1 (not locked tap) | P0 | Not run |
| QA-RULE-11 | Rules engine | M013 rotate head into own neck, tap snake | "Tangled" locked tap: wobble, no heart, no Move; tap lilypad head cell ⇒ rotates | P0 | Not run |
| QA-RULE-12 | Rules engine | Level with M007 + M017 + M031 on same Move | Ticks in order M007 → M017 → M031 (standard §16.17) | P0 | Not run |
| QA-RULE-13 | Rules engine | Solver detects soft-lock | "Stuck" sheet Undo / Restart, no heart, `E-GAME-004` logged | P1 | Not run |
| QA-SPIN-04 | Lucky Lily Wheel | Fresh install, before / after L10 clear | Locked before L10 clear; unlocks after | P0 | Not run |
| QA-STRK-05 | Streak | Complete 6 cycles (mock) | Trophy Bronze → Silver → Gold → Platinum → Diamond → Diamond | P1 | Not run |
| QA-ADS-08 | Interstitial | Replay cleared L11+ levels 5 times | Replays count toward `winsSinceInterstitial` | P0 | Not run |
| QA-LVL-01 | Level data | Corrupt L42 JSON in debug build, open L42 | `E-LVL-001` + "Level unavailable" Retry/Home; level not skipped, not marked cleared | P0 | Not run |
| QA-SET-01 | Settings | Toggle Sound / Music / Haptics / Share diagnostics; Help → Report a problem | Applied instantly, persisted; diagnostics off ⇒ no Crashlytics upload; report returns Report ID | P0 | Not run |
| QA-AUD-ALL | Audio | Run shared suite AUD-01…AUD-24 for this game ([Sound §11](../../SOUND_EFFECTS_IMPLEMENTATION.md#11-qa-checklist-status-not-run)) | All AUD rows meet expected | P0 | Not run |
| QA-LOG-ALL | Logging | Run shared suite LOG-01…LOG-22 for this game ([Logging §15](../../LOGGING_AND_ERROR_TRACKING.md#15-qa-checklist-status-not-run)) | All LOG rows meet expected | P0 | Not run |
| QA-MECH-M001 | Mechanic | `m001_test.dart` (6 cases, catalog §5) + play intro L11 on device | Garden Rock: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M002 | Mechanic | `m002_test.dart` (6 cases, catalog §5) + play intro L21 on device | Fallen Log: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M003 | Mechanic | `m003_test.dart` (6 cases, catalog §5) + play intro L31 on device | Frost Coil: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M004 | Mechanic | `m004_test.dart` (6 cases, catalog §5) + play intro L41 on device | Bamboo Cage & Key: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M005 | Mechanic | `m005_test.dart` (6 cases, catalog §5) + play intro L51 on device | Flower Gate: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M006 | Mechanic | `m006_test.dart` (6 cases, catalog §5) + play intro L61 on device | Bamboo One-Way: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M007 | Mechanic | `m007_test.dart` (6 cases, catalog §5) + play intro L71 on device | Lotus Bud Gate: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M008 | Mechanic | `m008_test.dart` (6 cases, catalog §5) + play intro L81 on device | Rabbit Burrows: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M009 | Mechanic | `m009_test.dart` (6 cases, catalog §5) + play intro L91 on device | Branch Lever & Twig Gates: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M010 | Mechanic | `m010_test.dart` (6 cases, catalog §5) + play intro L101 on device | Jungle Mist: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M011 | Mechanic | `m011_test.dart` (6 cases, catalog §5) + play intro L111 on device | Vine-Tied Twins: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M012 | Mechanic | `m012_test.dart` (6 cases, catalog §5) + play intro L121 on device | Sleepy Python: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M013 | Mechanic | `m013_test.dart` (6 cases, catalog §5) + play intro L131 on device | Spinning Lilypad: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M014 | Mechanic | `m014_test.dart` (6 cases, catalog §5) + play intro L141 on device | Mushroom Bumper: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M015 | Mechanic | `m015_test.dart` (6 cases, catalog §5) + play intro L151 on device | Root Bridge: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M016 | Mechanic | `m016_test.dart` (6 cases, catalog §5) + play intro L161 on device | Termite Mound: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M017 | Mechanic | `m017_test.dart` (6 cases, catalog §5) + play intro L171 on device | Restless Caterpillar: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M018 | Mechanic | `m018_test.dart` (6 cases, catalog §5) + play intro L181 on device | Fern Fork Switch: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M019 | Mechanic | `m019_test.dart` (6 cases, catalog §5) + play intro L191 on device | Mossy Pressure Stone: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M020 | Mechanic | `m020_test.dart` (6 cases, catalog §5) + play intro L201 on device | Home Burrow: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M021 | Mechanic | `m021_test.dart` (6 cases, catalog §5) + play intro L211 on device | Phantom Snake: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M022 | Mechanic | `m022_test.dart` (6 cases, catalog §5) + play intro L221 on device | Reverse Slither: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M023 | Mechanic | `m023_test.dart` (6 cases, catalog §5) + play intro L231 on device | Two-Headed Hydra: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M024 | Mechanic | `m024_test.dart` (6 cases, catalog §5) + play intro L241 on device | Giant Anaconda: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M025 | Mechanic | `m025_test.dart` (6 cases, catalog §5) + play intro L251 on device | Patrolling Beetle: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M026 | Mechanic | `m026_test.dart` (6 cases, catalog §5) + play intro L261 on device | Jungle Gems: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M027 | Mechanic | `m027_test.dart` (6 cases, catalog §5) + play intro L271 on device | Creeping Vine: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M028 | Mechanic | `m028_test.dart` (6 cases, catalog §5) + play intro L281 on device | Hatch Order Snakes: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M029 | Mechanic | `m029_test.dart` (6 cases, catalog §5) + play intro L291 on device | Hedge Border: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M030 | Mechanic | `m030_test.dart` (6 cases, catalog §5) + play intro L301 on device | Flower Arch Exit: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M031 | Mechanic | `m031_test.dart` (6 cases, catalog §5) + play intro L311 on device | Closing Hedge Gap: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M032 | Mechanic | `m032_test.dart` (6 cases, catalog §5) + play intro L321 on device | Canopy & Ground: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M033 | Mechanic | `m033_test.dart` (6 cases, catalog §5) + play intro L331 on device | Petal Cage: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M034 | Mechanic | `m034_test.dart` (6 cases, catalog §5) + play intro L341 on device | Whirl Stump: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M035 | Mechanic | `m035_test.dart` (6 cases, catalog §5) + play intro L351 on device | Mama Snake: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M036 | Mechanic | `m036_test.dart` (6 cases, catalog §5) + play intro L361 on device | Hungry Caterpillar: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M037 | Mechanic | `m037_test.dart` (6 cases, catalog §5) + play intro L371 on device | Sticky Swamp Mud: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M038 | Mechanic | `m038_test.dart` (6 cases, catalog §5) + play intro L381 on device | Bouncy Fern Pad: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M039 | Mechanic | `m039_test.dart` (6 cases, catalog §5) + play intro L391 on device | Pond Twins: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M040 | Mechanic | `m040_test.dart` (6 cases, catalog §5) + play intro L401 on device | Jungle Night: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M041 | Mechanic | `m041_test.dart` (6 cases, catalog §5) + play intro L411 on device | Chameleon Snake: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M042 | Mechanic | `m042_test.dart` (6 cases, catalog §5) + play intro L421 on device | Dry Twig Bridge: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M043 | Mechanic | `m043_test.dart` (6 cases, catalog §5) + play intro L431 on device | Big Knot Cage: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M044 | Mechanic | `m044_test.dart` (6 cases, catalog §5) + play intro L441 on device | Twisty Burrow: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M045 | Mechanic | `m045_test.dart` (6 cases, catalog §5) + play intro L451 on device | Root Gear Lever: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M046 | Mechanic | `m046_test.dart` (6 cases, catalog §5) + play intro L461 on device | Tail-Biter Loop: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M047 | Mechanic | `m047_test.dart` (6 cases, catalog §5) + play intro L471 on device | Growing Caterpillar: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M048 | Mechanic | `m048_test.dart` (6 cases, catalog §5) + play intro L481 on device | Snake Parade: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M049 | Mechanic | `m049_test.dart` (6 cases, catalog §5) + play intro L491 on device | Grumpy Mongoose: rule, bump, locked, Hammer, Undo, solver encode match catalog card; intro card shows | P0 | Not run |

Per-mechanic test cases: [03 §5](./03_OBSTACLE_CATALOG_PHASE_1.md#5-per-mechanic-unit-tests-puzzle_core). Release sign-off = બધા P0 rows Pass (device matrix §11 પર), Phase 1 exit criteria [README §6](./README.md#6-launch-exit-criteria).
