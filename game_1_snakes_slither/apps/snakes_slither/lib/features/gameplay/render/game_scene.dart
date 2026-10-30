import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../../app/theme/tokens.dart';
import 'board_painter.dart';

extension DirOffset on Dir {
  Offset get unit => Offset(dx.toDouble(), dy.toDouble());
}

/// What the renderer needs to draw one snake.
@immutable
class SnakeSprite {
  const SnakeSprite({
    required this.id,
    required this.body,
    required this.dir,
    required this.palette,
    this.caterpillar = false,
  });

  factory SnakeSprite.of(Snake s) =>
      SnakeSprite(id: s.id, body: s.body, dir: s.dir, palette: s.color, caterpillar: s.caterpillar);

  final String id;
  final List<Cell> body;
  final Dir dir;
  final SnakeColor palette;
  final bool caterpillar;

  Color get color => AppColors.snake(palette);
}

@immutable
class BoardLayout {
  const BoardLayout({required this.origin, required this.cell, required this.cols, required this.rows});

  final Offset origin;
  final double cell;
  final int cols;
  final int rows;

  static const double minCell = 29;

  Offset center(Cell c) => origin + Offset((c.x + 0.5) * cell, (c.y + 0.5) * cell);

  Rect get rect => origin & Size(cols * cell, rows * cell);

  Cell? cellAt(Offset local) {
    final p = local - origin;
    final x = (p.dx / cell).floor();
    final y = (p.dy / cell).floor();
    if (x < 0 || y < 0 || x >= cols || y >= rows) return null;
    return Cell(x, y);
  }

  /// 16 dp gutters, max board width 600 dp, whole-dp cells.
  static BoardLayout fit(Size area, int cols, int rows) {
    // Keeps 11×11 at ≥ 29 dp cells on a 360 dp phone; the frame fits inside it.
    const gutter = 16.0;
    final availW = math.min(area.width - 2 * gutter, 600.0);
    final cell = math.max(8.0, math.min(availW / cols, (area.height - 28) / rows).floorToDouble());
    final size = Size(cols * cell, rows * cell);
    final origin = Offset(((area.width - size.width) / 2).roundToDouble(), ((area.height - size.height) / 2).roundToDouble());
    return BoardLayout(origin: origin, cell: cell, cols: cols, rows: rows);
  }
}

/// Track = tail → … → head → lane waypoints. The visible snake is the slice
/// `[tailOffset, tailOffset + bodyLength]` of it.
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

double bodyLength(BoardLayout l, SnakeSprite s) => (s.body.length - 1) * l.cell;

enum MotionKind { exit, bump, wobble, smash }

class SnakeMotion {
  SnakeMotion._({
    required this.snake,
    required this.kind,
    required this.duration,
    this.track,
    this.bodyLen = 0,
    this.travel = 0,
    this.blocker,
  });

  /// Lane = cells to edge + body length + 1, so the tail fully leaves the board.
  factory SnakeMotion.exit(BoardLayout l, SnakeSprite s, int cellsToEdge, {bool fast = false}) {
    final laneCells = cellsToEdge + s.body.length + 1.0;
    final ms = fast ? 200 : math.min(450, 250 + 25 * cellsToEdge);
    return SnakeMotion._(
      snake: s,
      kind: MotionKind.exit,
      track: buildTrack(l, s, [l.center(s.body.first) + s.dir.unit * (laneCells * l.cell)]),
      bodyLen: bodyLength(l, s),
      travel: laneCells * l.cell,
      duration: Duration(milliseconds: ms),
    );
  }

  /// Head slides up to the cell before the blocker (0.25 cell if adjacent), bonks, slides back.
  factory SnakeMotion.bump(BoardLayout l, SnakeSprite s, int cellsToBlocker, Cell blocker) {
    final travelCells = (cellsToBlocker - 1) + 0.25;
    return SnakeMotion._(
      snake: s,
      kind: MotionKind.bump,
      track: buildTrack(l, s, [l.center(s.body.first) + s.dir.unit * (travelCells * l.cell)]),
      bodyLen: bodyLength(l, s),
      travel: travelCells * l.cell,
      duration: Motion.bonk,
      blocker: blocker,
    );
  }

  /// Nuh-uh side wobble (locked tap, blocked Rush snake).
  factory SnakeMotion.wobble(SnakeSprite s, {Duration duration = const Duration(milliseconds: 200)}) =>
      SnakeMotion._(snake: s, kind: MotionKind.wobble, duration: duration);

  /// Magic Stone Hammer: squash, sparkle, gone.
  factory SnakeMotion.smash(SnakeSprite s) =>
      SnakeMotion._(snake: s, kind: MotionKind.smash, duration: const Duration(milliseconds: 420));

  final SnakeSprite snake;
  final MotionKind kind;
  final ui.PathMetric? track;
  final double bodyLen;
  final double travel;
  final Duration duration;
  final Cell? blocker;
  double t = 0;

  static const double impact = 0.45;

  /// Tail distance along [track].
  double get tailOffset {
    switch (kind) {
      case MotionKind.exit:
        return Curves.easeInOutCubic.transform(t) * travel;
      case MotionKind.bump:
        if (t < impact) return Curves.easeOut.transform(t / impact) * travel;
        final back = (t - impact) / (1 - impact);
        return (1 - Curves.easeOutCubic.transform(back)) * travel;
      case MotionKind.wobble:
      case MotionKind.smash:
        return 0;
    }
  }

  /// Perpendicular head-bonk shake after impact (3 cycles, decaying).
  Offset shakeOffset(double cell, {required bool reduced}) {
    if (reduced) return Offset.zero;
    if (kind == MotionKind.wobble) {
      final n = snake.dir.unit;
      return Offset(-n.dy, n.dx) * (math.sin(t * math.pi * 4) * (1 - t) * cell * 0.12);
    }
    if (kind != MotionKind.bump || t < impact) return Offset.zero;
    final u = (t - impact) / (1 - impact);
    final n = snake.dir.unit;
    return Offset(-n.dy, n.dx) * (math.sin(u * math.pi * 6) * (1 - u) * cell * 0.06);
  }

  /// Head squash at the moment of impact.
  double get squash {
    if (kind != MotionKind.bump) return 1;
    final d = (t - impact).abs();
    return d < 0.12 ? 1 - (0.12 - d) * 1.6 : 1;
  }

  /// Red blocker flash for 120 ms from impact.
  double get blockerFlash {
    if (kind != MotionKind.bump) return 0;
    final ms = (t - impact) * duration.inMilliseconds;
    return (ms >= 0 && ms <= 120) ? 1 - ms / 120 : 0;
  }
}

/// Short floating text ("+10") used by the Rush.
class Floater {
  Floater(this.text, this.at, {this.color = AppColors.coinGoldDark});
  final String text;
  final Offset at;
  final Color color;
  double t = 0;
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

/// Mutable render model driven by a Ticker. The bloc pushes snapshots in;
/// the static layer is cached and rebuilt only when the board changes.
class GameScene extends ChangeNotifier {
  GameScene({this.reducedMotion = false, this.colourBlind = false, this.tint = AppColors.bgSage, this.golden = false});

  bool reducedMotion;
  bool colourBlind;
  Color tint;

  /// Rush look: golden board frame.
  bool golden;

  BoardLayout? _layout;
  int _cols = 1;
  int _rows = 1;
  List<SnakeSprite> _snakes = const [];
  Map<Cell, String> _occupancy = const {};
  int _version = 0;
  SnakeMotion? motion;
  VoidCallback? _onMotionDone;

  /// Lane preview while long-pressing.
  List<Offset>? preview;
  bool previewBlocked = false;
  String? previewSnakeId;

  String? hintSnakeId;
  bool hammerMode = false;
  String? highlightSnakeId;
  final List<Floater> floaters = [];

  /// Snakes whose exit finished but whose board commit has not arrived yet.
  final Set<String> _gone = {};

  double wigglePhase = 0;
  double clock = 0;
  final BoardPictureCache _cache = BoardPictureCache();

  BoardLayout? get layout => _layout;
  List<SnakeSprite> get snakes => _snakes;

  /// The ticker runs only while something moves (battery).
  bool get isAnimating => motion != null || hintSnakeId != null || highlightSnakeId != null || floaters.isNotEmpty;

  void setBoard({required int cols, required int rows, required List<SnakeSprite> snakes}) {
    final sizeChanged = cols != _cols || rows != _rows;
    _cols = cols;
    _rows = rows;
    _snakes = List.unmodifiable(snakes);
    _occupancy = {
      for (final s in snakes)
        for (final c in s.body) c: s.id,
    };
    _gone.clear();
    if (sizeChanged) _layout = null;
    _version++;
    notifyListeners();
  }

  /// Called from LayoutBuilder: must not notify listeners.
  void updateLayout(Size area) {
    final next = BoardLayout.fit(area, _cols, _rows);
    final prev = _layout;
    if (prev == null || prev.cell != next.cell || prev.origin != next.origin) {
      _layout = next;
      _version++;
    }
  }

  SnakeSprite? spriteById(String id) {
    for (final s in _snakes) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Bounding box of a snake in board-local coordinates (tutorial cut-outs).
  Rect? snakeRect(String id) {
    final l = _layout;
    final s = spriteById(id);
    if (l == null || s == null) return null;
    var r = Rect.fromCenter(center: l.center(s.body.first), width: l.cell, height: l.cell);
    for (final c in s.body) {
      r = r.expandToInclude(Rect.fromCenter(center: l.center(c), width: l.cell, height: l.cell));
    }
    return r;
  }

  /// Hit-test: exact cell first, then the nearest body cell within 0.5 cell of slop.
  String? snakeAt(Offset local) {
    final l = _layout;
    if (l == null) return null;
    final cell = l.cellAt(local);
    if (cell != null) {
      final id = _occupancy[cell];
      if (id != null) return id;
    }
    String? best;
    var bestD = l.cell; // centre distance ≤ 1 cell ⇒ within 0.5 cell of the edge
    for (final e in _occupancy.entries) {
      final d = (l.center(e.key) - local).distance;
      if (d < bestD) {
        bestD = d;
        best = e.value;
      }
    }
    return best;
  }

  void play(SnakeMotion m, {required VoidCallback onDone}) {
    motion = m;
    _onMotionDone = onDone;
    _version++; // the moving snake leaves the static layer
    notifyListeners();
  }

  /// Ends the current motion now (stuck-animation guard).
  void forceComplete() {
    if (motion == null) return;
    motion!.t = 1;
    tick(Duration.zero);
  }

  void tick(Duration dt) {
    final secs = dt.inMicroseconds / 1e6;
    clock += secs;
    for (final f in floaters) {
      f.t += secs / 0.8;
    }
    floaters.removeWhere((f) => f.t >= 1);
    final m = motion;
    if (m != null) {
      m.t = math.min(1.0, m.t + (m.duration.inMicroseconds == 0 ? 1 : dt.inMicroseconds / m.duration.inMicroseconds));
      wigglePhase += secs * math.pi * 6;
      if (m.t >= 1.0) {
        motion = null;
        if (m.kind == MotionKind.exit || m.kind == MotionKind.smash) _gone.add(m.snake.id);
        _version++;
        final done = _onMotionDone;
        _onMotionDone = null;
        done?.call();
      }
    }
    notifyListeners();
  }

  void setPreview(String? snakeId, List<Offset>? waypoints, {bool blocked = false}) {
    previewSnakeId = snakeId;
    preview = waypoints;
    previewBlocked = blocked;
    notifyListeners();
  }

  void setHint(String? id) {
    if (hintSnakeId == id) return;
    hintSnakeId = id;
    notifyListeners();
  }

  void setHammerMode(bool on) {
    if (hammerMode == on) return;
    hammerMode = on;
    _version++;
    notifyListeners();
  }

  void setHighlight(String? id) {
    highlightSnakeId = id;
    notifyListeners();
  }

  void addFloater(Floater f) {
    floaters.add(f);
    notifyListeners();
  }

  ui.Picture staticLayer(Size size) {
    final l = _layout!;
    final movingId = motion?.snake.id;
    bool visible(SnakeSprite s) => s.id != movingId && !_gone.contains(s.id);
    return _cache.obtain((_version, size, movingId, colourBlind, hammerMode), size, (canvas) {
      BoardBackground.draw(canvas, l, tint: tint, golden: golden);
      for (final s in _snakes) {
        if (visible(s)) SnakeRenderer.drawStatic(canvas, l, s, colourBlind: colourBlind);
      }
      if (hammerMode) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(l.rect.inflate(8), const Radius.circular(24)),
          Paint()..color = Colors.black.withValues(alpha: 0.28),
        );
        for (final s in _snakes) {
          if (visible(s)) SnakeRenderer.drawStatic(canvas, l, s, colourBlind: colourBlind, outline: AppColors.coinGold);
        }
      }
    });
  }

  @override
  void dispose() {
    _cache.dispose();
    super.dispose();
  }
}
