import 'dart:math' as math;

import '../model/cell.dart';

/// Daily Jungle Puzzle shapes, Monday first (DateTime.weekday 1..7).
enum Silhouette { butterfly, leaf, turtle, cloud, egg, mango, sun }

extension SilhouetteMask on Silhouette {
  static Silhouette forWeekday(int weekday) => Silhouette.values[(weekday - 1) % 7];

  /// Cells inside the shape on a [w]×[h] board.
  Set<Cell> mask(int w, int h) {
    final out = <Cell>{};
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        // Normalised to [-1, 1] at cell centres.
        final u = (x + 0.5) / w * 2 - 1;
        final v = (y + 0.5) / h * 2 - 1;
        if (_inside(u, v)) out.add(Cell(x, y));
      }
    }
    return out;
  }

  bool _inside(double u, double v) {
    bool ellipse(double cx, double cy, double rx, double ry) =>
        math.pow((u - cx) / rx, 2) + math.pow((v - cy) / ry, 2) <= 1;
    switch (this) {
      case Silhouette.butterfly:
        return ellipse(-0.5, -0.3, 0.55, 0.6) ||
            ellipse(0.5, -0.3, 0.55, 0.6) ||
            ellipse(-0.45, 0.5, 0.45, 0.45) ||
            ellipse(0.45, 0.5, 0.45, 0.45) ||
            u.abs() < 0.15;
      case Silhouette.leaf:
        final a = (u + v) / math.sqrt2;
        final b = (v - u) / math.sqrt2;
        return (a * a) / 1.6 + (b * b) / 0.35 <= 1 || (u > 0.55 && v > 0.55 && (u - v).abs() < 0.25);
      case Silhouette.turtle:
        return ellipse(0, 0.1, 0.85, 0.75) || ellipse(0, -0.8, 0.3, 0.25);
      case Silhouette.cloud:
        return ellipse(-0.45, 0.1, 0.55, 0.5) || ellipse(0.1, -0.25, 0.6, 0.6) || ellipse(0.55, 0.15, 0.45, 0.45) || (v > 0 && v < 0.65 && u.abs() < 0.9);
      case Silhouette.egg:
        return ellipse(0, 0.05, v < 0 ? 0.7 : 0.82, 0.98);
      case Silhouette.mango:
        return ellipse(0, 0.12, 0.95, 0.88) || ellipse(0.35, -0.85, 0.3, 0.18);
      case Silhouette.sun:
        final r = math.sqrt(u * u + v * v);
        return r <= 0.62 || ((u.abs() < 0.14 || v.abs() < 0.14) && r <= 1.0) || ((u - v).abs() < 0.2 && r <= 0.95) || ((u + v).abs() < 0.2 && r <= 0.95);
    }
  }
}
