import 'dart:math' as math;
import 'dart:ui';

import 'package:puzzle_core/puzzle_core.dart';

/// Single source of truth for where cells are on screen. Painting (UI side)
/// and hit-testing (logic side) must both use this, or taps won't match art.
class BoardGeometry {
  BoardGeometry._(this.columns, this.rows, this.cell);

  /// Fits the board into [avail] (already excluding HUD, booster bar, banner).
  /// Side gutter 16 is applied here.
  factory BoardGeometry.fit({required int columns, required int rows, required Size avail}) {
    const gutter = 16.0;
    final cell = math
        .min((avail.width - 2 * gutter) / columns, avail.height / rows)
        .floorToDouble();
    return BoardGeometry._(columns, rows, math.max(cell, 1));
  }

  static const minCell = 29.0;
  static const maxBoardWidth = 600.0;

  final int columns;
  final int rows;
  final double cell;

  Size get size => Size(columns * cell, rows * cell);
  double get cornerRadius => 0.18 * cell;
  bool get meetsMinCell => cell >= minCell;

  Rect rectOf(Cell c) => Rect.fromLTWH(c.x * cell, c.y * cell, cell, cell);
  Offset centerOf(Cell c) => Offset((c.x + 0.5) * cell, (c.y + 0.5) * cell);

  Cell? cellAt(Offset local) {
    final x = (local.dx / cell).floor(), y = (local.dy / cell).floor();
    if (x < 0 || y < 0 || x >= columns || y >= rows) return null;
    return Cell(x, y);
  }

  /// Interactive obstacle under the finger (lever, switch, gear, lilypad,
  /// stump). These win over a snake on the same cell. A Whirl Stump is
  /// tapped on its centre seam, so the snakes inside stay tappable.
  int? interactiveAt(BoardState b, Offset local) {
    final c = cellAt(local);
    for (final o in b.obstacles) {
      if (!o.interactive || o.cells.isEmpty) continue;
      if (o.type == 'M034') {
        final xs = o.cells.map((c) => c.x), ys = o.cells.map((c) => c.y);
        final seam = Offset((xs.reduce(math.min) + 1) * cell, (ys.reduce(math.min) + 1) * cell);
        if ((seam - local).distance <= cell * .35) return o.id;
      } else if (c != null && o.cells.contains(c)) {
        return o.id;
      }
    }
    return null;
  }

  /// Snake under the finger. The Canopy layer wins over the ground. On an
  /// empty cell, the nearest body segment within half a cell wins, which
  /// keeps small (29 dp) cells tappable.
  int? snakeAt(BoardState b, Offset local) {
    final c = cellAt(local);
    if (c != null) {
      Snake? hit;
      for (final s in b.snakes.values) {
        final wide = s.marks.wideSide;
        final cells = [...s.body, if (wide != null) for (final x in s.body) x.step(wide)];
        if (!cells.contains(c)) continue;
        if (hit == null || s.marks.layer > hit.marks.layer) hit = s;
      }
      if (hit != null) return hit.id;
    }
    int? best;
    var bestD = cell; // centre-to-point distance limit = 0.5 cell slop + 0.5 cell half-size
    for (final s in b.snakes.values) {
      for (final seg in s.body) {
        final d = (centerOf(seg) - local).distance;
        if (d < bestD) {
          bestD = d;
          best = s.id;
        }
      }
    }
    return best;
  }

  int? rockAt(BoardState b, Offset local) {
    final c = cellAt(local);
    return c == null ? null : b.rockAt(c)?.id;
  }

  /// Hammerable obstacle (not a rock) under the finger.
  int? hammerObstacleAt(BoardState b, Offset local) {
    final c = cellAt(local);
    if (c == null) return null;
    for (final o in b.obstacles) {
      if (o.hammerable && o.cells.contains(c)) return o.id;
    }
    return null;
  }
}
