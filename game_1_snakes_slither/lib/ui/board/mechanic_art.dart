// OWNER: UI agent. Board art for every Phase 1 mechanic (M002–M049) and the
// snake badges, in board units (one cell = 10 units, cell x spans
// x*10 .. x*10+10, the same grid BoardPainter uses).
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';
import '../theme/tokens.dart';

const _u = 10.0;

Offset _c(Cell c) => Offset(c.x * _u + _u / 2, c.y * _u + _u / 2);
Rect _r(Cell c, [double inset = .8]) => Rect.fromLTWH(c.x * _u + inset, c.y * _u + inset, _u - 2 * inset, _u - 2 * inset);

Paint _fill(Color c) => Paint()..color = c;
Paint _line(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

Color mechColor(String name) {
  if (name.isEmpty || name == 'loop') return const Color(0xFFB8860B);
  final c = SnakeColor.values.asNameMap()[name];
  return c == null ? const Color(0xFFB8860B) : AppColors.snakePalette(c).body;
}

void _label(Canvas canvas, Offset at, String text, {Color color = Colors.white, Color bg = const Color(0xFF163B28), double size = 3.6}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontFamily: 'Fredoka', fontSize: size, fontWeight: FontWeight.w700, color: color, height: 1),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final w = math.max(tp.width + 1.6, size + 1.2);
  final box = RRect.fromRectAndRadius(Rect.fromCenter(center: at, width: w, height: size + 1.2), Radius.circular(size));
  canvas.drawRRect(box, _fill(bg));
  canvas.drawRRect(box, _line(Colors.white, .35));
  tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
}

Offset _dv(Dir? d) => d == null ? Offset.zero : Offset(d.dx.toDouble(), d.dy.toDouble());

void _arrow(Canvas canvas, Offset c, Dir d, Color col, {double len = 3}) {
  final v = _dv(d), p = Offset(-v.dy, v.dx);
  final tip = c + v * len, tail = c - v * len;
  canvas.drawLine(tail, tip, _line(col, .9));
  canvas.drawPath(
    Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((tip - v * 1.8 + p * 1.4).dx, (tip - v * 1.8 + p * 1.4).dy)
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((tip - v * 1.8 - p * 1.4).dx, (tip - v * 1.8 - p * 1.4).dy),
    _line(col, .9),
  );
}

/// Draws [o] under the snakes ("floor" art) or above them ([top] = true:
/// bridges, cages, mist, the Mongoose). [idle] runs 0..1 for gentle loops.
void paintObstacle(Canvas canvas, Obstacle o, {required bool top, required double idle, bool hammerMode = false, bool hint = false}) {
  final isTop = const {'M010', 'M015', 'M033', 'M034', 'M042', 'M049', 'M029', 'M030', 'M031'}.contains(o.type);
  if (isTop != top) return;
  if ((hammerMode && o.hammerable) || hint) {
    final a = .7 + .25 * math.sin(idle * 2 * math.pi);
    for (final c in o.cells) {
      canvas.drawCircle(
        _c(c),
        6.2,
        Paint()
          ..color = (hint ? const Color(0xFFFFE066) : Colors.white).withValues(alpha: a)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.7),
      );
    }
  }
  switch (o.type) {
    case 'M002':
      _log(canvas, o);
    case 'M004':
      _cage(canvas, o.cells.first, mechColor(o.color), o.open, null);
    case 'M043':
      _cage(canvas, o.cells.first, mechColor(o.color), o.open, o.open ? null : o.value);
    case 'M005':
      _flowerGate(canvas, o.cells.first, mechColor(o.color));
    case 'M006':
      _oneWay(canvas, o.cells.first, o.arrow ?? Dir.up);
    case 'M007':
      _lotus(canvas, o.cells.first, o.value, o.open);
    case 'M008' || 'M044':
      for (final c in o.cells) {
        _burrow(canvas, c, o.id, twisty: o.type == 'M044');
      }
    case 'M009':
      _lever(canvas, o.cells.first, o.done.isNotEmpty && o.done.first);
      for (var g = 0; g < o.links.length; g++) {
        _twigGate(canvas, o.links[g], g < o.done.length && o.done[g]);
      }
    case 'M010':
      _mist(canvas, o, idle);
    case 'M013':
      _lilypad(canvas, o.cells.first, o.interactive);
    case 'M014':
      _mushroom(canvas, o.cells.first, o.orient);
    case 'M015':
      _bridge(canvas, o.cells.first, o.horizontal, broken: false);
    case 'M016':
      _mound(canvas, o.cells.first, o.value);
    case 'M018':
      _fernSwitch(canvas, o.cells.first, o.open);
    case 'M019':
      _plate(canvas, o.cells.first, o.open);
      for (final g in o.links) {
        _stoneGate(canvas, g, o.open);
      }
    case 'M020':
      _homeBurrow(canvas, o.cells.first);
    case 'M025':
      _beetle(canvas, o, idle);
    case 'M026':
      for (var i = 0; i < o.cells.length; i++) {
        if (i >= o.done.length || !o.done[i]) _gem(canvas, o.cells[i], idle);
      }
    case 'M027':
      _vine(canvas, o);
    case 'M029':
      _edge(canvas, o, const Color(0xFF2E6B2A), solid: true);
    case 'M030':
      _edge(canvas, o, mechColor(o.color), solid: false);
    case 'M031':
      _edge(canvas, o, const Color(0xFF2E6B2A), solid: !o.open, countdown: o.open ? o.value : null);
    case 'M033':
      _petalCage(canvas, o, mechColor(o.color));
    case 'M034':
      _stump(canvas, o);
    case 'M035':
      for (final c in o.cells) {
        _egg(canvas, c, o.open, idle);
      }
    case 'M036':
      for (var i = 0; i < o.cells.length; i++) {
        if (i >= o.done.length || !o.done[i]) _berry(canvas, o.cells[i]);
      }
    case 'M037':
      _mud(canvas, o.cells.first);
    case 'M038':
      _fernPad(canvas, o.cells.first, idle);
    case 'M042':
      _bridge(canvas, o.cells.first, o.horizontal, broken: o.open);
    case 'M045':
      _gear(canvas, o.cells.first, idle);
    case 'M049':
      _mongoose(canvas, o, idle);
    default:
      _label(canvas, _c(o.cells.isEmpty ? const Cell(0, 0) : o.cells.first), '?');
  }
}

// ── floor mechanics ──

void _log(Canvas canvas, Obstacle o) {
  final xs = o.cells.map((c) => c.x), ys = o.cells.map((c) => c.y);
  final r = Rect.fromLTRB(xs.reduce(math.min) * _u + 1.2, ys.reduce(math.min) * _u + 1.6,
      (xs.reduce(math.max) + 1) * _u - 1.2, (ys.reduce(math.max) + 1) * _u - 1.6);
  final rr = RRect.fromRectAndRadius(r, const Radius.circular(3.2));
  canvas.drawRRect(rr.shift(const Offset(.6, 1.2)), _fill(const Color(0x55301A0C)));
  canvas.drawRRect(
    rr,
    Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB07A48), Color(0xFF8A5A30), Color(0xFF5E3A1C)],
      ).createShader(r),
  );
  canvas.drawRRect(rr, _line(const Color(0xFF4A2C17), .5));
  final horiz = r.width >= r.height;
  final grain = _line(const Color(0x664A2C17), .35);
  for (var i = 1; i < 3; i++) {
    if (horiz) {
      final y = r.top + r.height * i / 3;
      canvas.drawLine(Offset(r.left + 2, y), Offset(r.right - 2, y), grain);
    } else {
      final x = r.left + r.width * i / 3;
      canvas.drawLine(Offset(x, r.top + 2), Offset(x, r.bottom - 2), grain);
    }
  }
  final end = horiz ? Offset(r.right - 2.2, r.center.dy) : Offset(r.center.dx, r.bottom - 2.2);
  canvas.drawCircle(end, 1.9, _fill(const Color(0xFFD9B27C)));
  canvas.drawCircle(end, 1.9, _line(const Color(0xFF6B4024), .3));
  canvas.drawCircle(end, .9, _line(const Color(0xFF8A5A30), .25));
}

void _cage(Canvas canvas, Cell cell, Color col, bool open, int? count) {
  final r = _r(cell, 1.1);
  if (open) {
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1.6)), _line(col.withValues(alpha: .35), .5));
    return;
  }
  canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1.6)), _fill(col.withValues(alpha: .25)));
  final bar = _line(const Color(0xFF7C9A3A), 1.1);
  for (var i = 0; i < 4; i++) {
    final x = r.left + 1 + i * (r.width - 2) / 3;
    canvas.drawLine(Offset(x, r.top), Offset(x, r.bottom), bar);
  }
  canvas.drawLine(r.topLeft, r.topRight, _line(const Color(0xFF5E7A2A), 1));
  canvas.drawLine(r.bottomLeft, r.bottomRight, _line(const Color(0xFF5E7A2A), 1));
  final c = r.center;
  canvas.drawCircle(c, 2.1, _fill(col));
  canvas.drawCircle(c, 2.1, _line(Colors.white, .4));
  canvas.drawCircle(c - const Offset(0, .4), .55, _fill(const Color(0xFF163B28)));
  canvas.drawLine(c, c + const Offset(0, 1.2), _line(const Color(0xFF163B28), .45));
  if (count != null) _label(canvas, r.topRight, '$count', bg: col);
}

void _flowerGate(Canvas canvas, Cell cell, Color col) {
  final c = _c(cell);
  for (var i = 0; i < 6; i++) {
    final a = i * math.pi / 3;
    canvas.drawOval(
      Rect.fromCenter(center: c + Offset(math.cos(a), math.sin(a)) * 2.6, width: 2.8, height: 2.8),
      _fill(col.withValues(alpha: .9)),
    );
  }
  canvas.drawCircle(c, 3.6, _line(col, .6));
  canvas.drawCircle(c, 1.4, _fill(const Color(0xFFFFE082)));
}

void _oneWay(Canvas canvas, Cell cell, Dir d) {
  final r = _r(cell, 1);
  canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1.6)), _fill(const Color(0xFFD7E3A4)));
  final slat = _line(const Color(0xFF9DB45A), .45);
  for (var i = 1; i < 4; i++) {
    final x = r.left + i * r.width / 4;
    canvas.drawLine(Offset(x, r.top + .5), Offset(x, r.bottom - .5), slat);
  }
  _arrow(canvas, r.center, d, const Color(0xFF3E6B1A));
}

void _lotus(Canvas canvas, Cell cell, int left, bool open) {
  final c = _c(cell);
  canvas.drawCircle(c, 4, _fill(const Color(0xFF7CB342).withValues(alpha: open ? .3 : .9)));
  if (open) {
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + (i - 2) * .5;
      canvas.drawOval(
        Rect.fromCenter(center: c + Offset(math.cos(a), math.sin(a)) * 1.8, width: 1.6, height: 3.2),
        _fill(const Color(0x88F48FB1)),
      );
    }
    return;
  }
  canvas.drawPath(
    Path()
      ..moveTo(c.dx, c.dy - 3.4)
      ..quadraticBezierTo(c.dx + 3, c.dy, c.dx, c.dy + 2.4)
      ..quadraticBezierTo(c.dx - 3, c.dy, c.dx, c.dy - 3.4),
    _fill(const Color(0xFFF48FB1)),
  );
  _label(canvas, c + const Offset(3, -3), '$left', bg: const Color(0xFFC2185B));
}

void _burrow(Canvas canvas, Cell cell, int pair, {required bool twisty}) {
  final c = _c(cell);
  const rings = [Color(0xFF8D6E63), Color(0xFF5C6BC0), Color(0xFFFF8F00), Color(0xFF00897B)];
  final ring = rings[pair % rings.length];
  canvas.drawOval(Rect.fromCenter(center: c, width: 8, height: 6.4), _fill(const Color(0xFF6D4C41)));
  canvas.drawOval(Rect.fromCenter(center: c + const Offset(0, .5), width: 6, height: 4.4), _fill(const Color(0xFF1B120C)));
  canvas.drawOval(Rect.fromCenter(center: c, width: 8, height: 6.4), _line(ring, .7));
  if (twisty) {
    canvas.drawArc(Rect.fromCircle(center: c, radius: 2), -math.pi / 2, math.pi * 1.4, false, _line(Colors.white, .5));
  }
}

void _lever(Canvas canvas, Cell cell, bool on) {
  final c = _c(cell);
  canvas.drawOval(Rect.fromCenter(center: c + const Offset(0, 2), width: 6, height: 2.6), _fill(const Color(0xFF6B4024)));
  final tip = c + Offset(on ? 2.6 : -2.6, -3);
  canvas.drawLine(c + const Offset(0, 1.6), tip, _line(const Color(0xFF8A5A30), 1));
  canvas.drawCircle(tip, 1.1, _fill(const Color(0xFF7CB342)));
}

void _twigGate(Canvas canvas, Cell cell, bool open) {
  final r = _r(cell, 1.4);
  final col = const Color(0xFF8A5A30).withValues(alpha: open ? .25 : 1);
  if (open) {
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1)), _line(col, .5));
    return;
  }
  for (var i = 0; i < 3; i++) {
    final y = r.top + 1 + i * (r.height - 2) / 2;
    canvas.drawLine(Offset(r.left, y), Offset(r.right, y + (i.isEven ? .4 : -.4)), _line(col, .9));
  }
  canvas.drawLine(r.topLeft, r.bottomRight, _line(col, .6));
}

void _lilypad(Canvas canvas, Cell cell, bool tappable) {
  final c = _c(cell);
  final pad = Path()
    ..moveTo(c.dx, c.dy)
    ..arcTo(Rect.fromCircle(center: c, radius: 4.8), -math.pi / 2 + .25, math.pi * 2 - .5, false)
    ..close();
  canvas.drawPath(pad, _fill(const Color(0xFF43A047)));
  canvas.drawPath(pad, _line(const Color(0xFF1B5E20), .45));
  if (tappable) {
    canvas.drawArc(Rect.fromCircle(center: c, radius: 4.1), 0, math.pi * 1.2, false, _line(const Color(0xCCFFFFFF), .45));
  }
}

void _mushroom(Canvas canvas, Cell cell, String orient) {
  final r = _r(cell, 1.2);
  final a = orient == '/' ? r.bottomLeft : r.topLeft;
  final b = orient == '/' ? r.topRight : r.bottomRight;
  canvas.drawLine(a, b, _line(const Color(0xFFF5F5F5), 2.2));
  canvas.drawLine(a, b, _line(const Color(0xFFD32F2F), 1.5));
  final mid = Offset.lerp(a, b, .5)!;
  for (final t in [.25, .75]) {
    canvas.drawCircle(Offset.lerp(a, b, t)!, .5, _fill(Colors.white));
  }
  canvas.drawCircle(mid, .6, _fill(Colors.white));
}

void _bridge(Canvas canvas, Cell cell, bool horizontal, {required bool broken}) {
  final r = _r(cell, .2);
  if (broken) {
    final c = r.center;
    canvas.drawCircle(c, 3.6, _fill(const Color(0xFF8A5A30)));
    canvas.drawLine(c - const Offset(2, 2), c + const Offset(2, 2), _line(const Color(0xFF4A2C17), .6));
    canvas.drawLine(c + const Offset(-2, 2), c + const Offset(2, -2), _line(const Color(0xFF4A2C17), .6));
    return;
  }
  final deck = horizontal ? Rect.fromLTRB(r.left, r.center.dy - 2.4, r.right, r.center.dy + 2.4) : Rect.fromLTRB(r.center.dx - 2.4, r.top, r.center.dx + 2.4, r.bottom);
  canvas.drawRect(deck, _fill(const Color(0xCCA1887F)));
  final plank = _line(const Color(0xFF5D4037), .4);
  for (var i = 0; i <= 4; i++) {
    if (horizontal) {
      final x = deck.left + i * deck.width / 4;
      canvas.drawLine(Offset(x, deck.top), Offset(x, deck.bottom), plank);
    } else {
      final y = deck.top + i * deck.height / 4;
      canvas.drawLine(Offset(deck.left, y), Offset(deck.right, y), plank);
    }
  }
  canvas.drawRect(deck, _line(const Color(0xFF4E342E), .5));
}

void _mound(Canvas canvas, Cell cell, int hp) {
  final c = _c(cell);
  final p = Path()
    ..moveTo(c.dx - 4.2, c.dy + 3.6)
    ..quadraticBezierTo(c.dx - 2.4, c.dy - 4.6, c.dx, c.dy - 4.2)
    ..quadraticBezierTo(c.dx + 2.4, c.dy - 4.6, c.dx + 4.2, c.dy + 3.6)
    ..close();
  canvas.drawPath(p, _fill(const Color(0xFFB0753F)));
  canvas.drawPath(p, _line(const Color(0xFF6B4024), .5));
  for (final h in [const Offset(-1.2, 0), const Offset(1, -1.6), const Offset(.6, 1.6)]) {
    canvas.drawCircle(c + h, .45, _fill(const Color(0xFF4A2C17)));
  }
  _label(canvas, c + const Offset(3.2, -3.4), '$hp', bg: const Color(0xFF6B4024));
}

void _fernSwitch(Canvas canvas, Cell cell, bool right) {
  final c = _c(cell);
  canvas.drawCircle(c, 4.2, _fill(const Color(0xFFDCEDC8)));
  canvas.drawCircle(c, 4.2, _line(const Color(0xFF558B2F), .5));
  final sweep = right ? 1.0 : -1.0;
  canvas.drawArc(Rect.fromCircle(center: c, radius: 2.6), -math.pi / 2, sweep * math.pi / 2, false, _line(const Color(0xFF33691E), .9));
  final tip = c + Offset(sweep * 2.6, 0);
  canvas.drawCircle(tip, .8, _fill(const Color(0xFF33691E)));
  _label(canvas, c + const Offset(0, 3.6), right ? 'R' : 'L', bg: const Color(0xFF558B2F), size: 2.6);
}

void _plate(Canvas canvas, Cell cell, bool pressed) {
  final r = _r(cell, 1.3);
  canvas.drawOval(r, _fill(pressed ? const Color(0xFF8BC34A) : const Color(0xFF9E9E9E)));
  canvas.drawOval(r, _line(const Color(0xFF616161), .5));
  canvas.drawOval(r.deflate(1.6), _line(const Color(0x66FFFFFF), .4));
}

void _stoneGate(Canvas canvas, Cell cell, bool open) {
  final r = _r(cell, 1.2);
  if (open) {
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1)), _line(const Color(0x669E9E9E), .5));
    return;
  }
  canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1)), _fill(const Color(0xFF9E9E9E)));
  canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(1)), _line(const Color(0xFF616161), .5));
  canvas.drawLine(Offset(r.left, r.center.dy), Offset(r.right, r.center.dy), _line(const Color(0xFF757575), .4));
}

void _homeBurrow(Canvas canvas, Cell cell) {
  final c = _c(cell);
  canvas.drawCircle(c, 4.4, _fill(const Color(0xFF795548)));
  canvas.drawCircle(c + const Offset(0, .4), 3.2, _fill(const Color(0xFF1B120C)));
  canvas.drawPath(
    Path()
      ..moveTo(c.dx + 2, c.dy - 4.6)
      ..quadraticBezierTo(c.dx + 5, c.dy - 5, c.dx + 4.6, c.dy - 2)
      ..quadraticBezierTo(c.dx + 3, c.dy - 3, c.dx + 2, c.dy - 4.6),
    _fill(const Color(0xFF7CB342)),
  );
}

void _beetle(Canvas canvas, Obstacle o, double idle) {
  final dot = _fill(const Color(0x553E2723));
  for (final w in o.links) {
    canvas.drawCircle(_c(w), .6, dot);
  }
  final c = _c(o.cells.first) + Offset(0, .3 * math.sin(idle * 2 * math.pi));
  canvas.drawOval(Rect.fromCenter(center: c, width: 6, height: 7), _fill(const Color(0xFF1565C0)));
  canvas.drawLine(c - const Offset(0, 3.4), c + const Offset(0, 3.4), _line(const Color(0xFF0D47A1), .5));
  canvas.drawCircle(c - const Offset(0, 3.6), 1.4, _fill(const Color(0xFF0D47A1)));
  for (final s in [-1.0, 1.0]) {
    canvas.drawCircle(c + Offset(s * 1.3, -.6), .55, _fill(const Color(0xFF90CAF9)));
  }
}

void _gem(Canvas canvas, Cell cell, double idle) {
  final c = _c(cell);
  final p = Path()
    ..moveTo(c.dx, c.dy - 3.4)
    ..lineTo(c.dx + 3, c.dy - .8)
    ..lineTo(c.dx, c.dy + 3.4)
    ..lineTo(c.dx - 3, c.dy - .8)
    ..close();
  canvas.drawPath(p, _fill(const Color(0xFF26C6DA)));
  canvas.drawPath(p, _line(const Color(0xFF00838F), .5));
  canvas.drawLine(Offset(c.dx - 3, c.dy - .8), Offset(c.dx + 3, c.dy - .8), _line(const Color(0x99FFFFFF), .4));
  final a = .5 + .5 * math.sin(idle * 2 * math.pi);
  canvas.drawCircle(c + const Offset(-1, -1.6), .6, _fill(Colors.white.withValues(alpha: a)));
}

void _vine(Canvas canvas, Obstacle o) {
  for (final cell in o.cells) {
    final r = _r(cell, .9);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(2)), _fill(const Color(0xFF558B2F)));
    for (var i = 0; i < 3; i++) {
      final at = Offset(r.left + 2 + i * 2.6, r.top + 2 + (i.isEven ? 0 : 3));
      canvas.drawOval(Rect.fromCenter(center: at, width: 2.6, height: 1.6), _fill(const Color(0xFF9CCC65)));
    }
  }
  if (o.cells.isNotEmpty) {
    _label(canvas, _c(o.cells.last) + const Offset(3, -3), '${o.value}', bg: const Color(0xFF33691E));
  }
}

void _egg(Canvas canvas, Cell cell, bool hatching, double idle) {
  final c = _c(cell) + Offset(hatching ? .5 * math.sin(idle * 6 * math.pi) : 0, 0);
  canvas.drawOval(Rect.fromCenter(center: c, width: 4.4, height: 5.4), _fill(const Color(0xFFFFF8E1)));
  canvas.drawOval(Rect.fromCenter(center: c, width: 4.4, height: 5.4), _line(const Color(0xFFBCAAA4), .45));
  canvas.drawCircle(c + const Offset(-.8, -1), .5, _fill(const Color(0xFFA5D6A7)));
}

void _berry(Canvas canvas, Cell cell) {
  final c = _c(cell);
  canvas.drawCircle(c + const Offset(-1.2, .6), 2, _fill(const Color(0xFFE53935)));
  canvas.drawCircle(c + const Offset(1.2, .6), 2, _fill(const Color(0xFFC62828)));
  canvas.drawLine(c - const Offset(0, 1.2), c - const Offset(-1, 3.4), _line(const Color(0xFF33691E), .5));
  canvas.drawCircle(c + const Offset(-1.8, 0), .5, _fill(const Color(0x99FFFFFF)));
}

void _mud(Canvas canvas, Cell cell) {
  final c = _c(cell);
  canvas.drawOval(Rect.fromCenter(center: c, width: 8.6, height: 7), _fill(const Color(0xFF6D4C41)));
  canvas.drawOval(Rect.fromCenter(center: c + const Offset(-1, -.8), width: 3, height: 1.6), _fill(const Color(0x668D6E63)));
  canvas.drawCircle(c + const Offset(2, 1.2), .7, _line(const Color(0xFF8D6E63), .35));
}

void _fernPad(Canvas canvas, Cell cell, double idle) {
  final c = _c(cell);
  final bounce = .4 * math.sin(idle * 2 * math.pi);
  for (var i = -2; i <= 2; i++) {
    final a = -math.pi / 2 + i * .45;
    canvas.drawLine(c + const Offset(0, 2.6), c + Offset(math.cos(a), math.sin(a)) * (4.2 + bounce) + const Offset(0, 1), _line(const Color(0xFF66BB6A), .9));
  }
  canvas.drawCircle(c + const Offset(0, 2.6), 1, _fill(const Color(0xFF2E7D32)));
}

void _gear(Canvas canvas, Cell cell, double idle) {
  final c = _c(cell);
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.rotate(idle * math.pi / 4);
  for (var i = 0; i < 8; i++) {
    final a = i * math.pi / 4;
    canvas.drawRect(Rect.fromCenter(center: Offset(math.cos(a), math.sin(a)) * 3.6, width: 1.6, height: 1.6), _fill(const Color(0xFF8D6E63)));
  }
  canvas.drawCircle(Offset.zero, 3.2, _fill(const Color(0xFFA1887F)));
  canvas.drawCircle(Offset.zero, 1.1, _fill(const Color(0xFF5D4037)));
  canvas.restore();
}

void _stump(Canvas canvas, Obstacle o) {
  final xs = o.cells.map((c) => c.x), ys = o.cells.map((c) => c.y);
  final r = Rect.fromLTRB(xs.reduce(math.min) * _u + .6, ys.reduce(math.min) * _u + .6, (xs.reduce(math.max) + 1) * _u - .6, (ys.reduce(math.max) + 1) * _u - .6);
  canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), _line(const Color(0xFF8A5A30), .9));
  final c = r.center;
  canvas.drawCircle(c, 3.6, _fill(const Color(0xFFD7B98A)));
  for (final rad in [2.6, 1.6, .7]) {
    canvas.drawCircle(c, rad, _line(const Color(0xFF8A5A30), .3));
  }
  canvas.drawArc(Rect.fromCircle(center: c, radius: 4.6), -math.pi / 2, math.pi, false, _line(const Color(0xFF4A2C17), .6));
  final tip = c + const Offset(0, 4.6);
  canvas.drawPath(
    Path()
      ..moveTo(tip.dx, tip.dy)
      ..relativeLineTo(1.2, -.8)
      ..moveTo(tip.dx, tip.dy)
      ..relativeLineTo(1.2, .8),
    _line(const Color(0xFF4A2C17), .6),
  );
}

// ── top mechanics ──

void _mist(Canvas canvas, Obstacle o, double idle) {
  final drift = 1.2 * math.sin(idle * 2 * math.pi);
  for (final cell in o.cells) {
    final c = _c(cell);
    canvas.drawRect(_r(cell, -.2), _fill(const Color(0xF2ECEFF1)));
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(c + Offset(-3 + i * 3 + drift, (i.isEven ? -1.5 : 1.5)), 2.6, _fill(const Color(0xCCFFFFFF)));
    }
  }
  if (o.cells.isNotEmpty) _label(canvas, _c(o.cells.first), '?', color: const Color(0xFF78909C), bg: Colors.white);
}

void _edge(Canvas canvas, Obstacle o, Color col, {required bool solid, int? countdown}) {
  final side = o.side ?? Dir.up;
  for (final cell in o.cells) {
    final r = Rect.fromLTWH(cell.x * _u, cell.y * _u, _u, _u);
    final Rect strip = switch (side) {
      Dir.up => Rect.fromLTRB(r.left, r.top - 1.4, r.right, r.top + .6),
      Dir.down => Rect.fromLTRB(r.left, r.bottom - .6, r.right, r.bottom + 1.4),
      Dir.left => Rect.fromLTRB(r.left - 1.4, r.top, r.left + .6, r.bottom),
      Dir.right => Rect.fromLTRB(r.right - .6, r.top, r.right + 1.4, r.bottom),
    };
    if (solid) {
      canvas.drawRRect(RRect.fromRectAndRadius(strip, const Radius.circular(1)), _fill(col));
      canvas.drawRRect(RRect.fromRectAndRadius(strip, const Radius.circular(1)), _line(const Color(0xFF1B5E20), .3));
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(strip, const Radius.circular(1)), _line(col, .9));
      final mid = strip.center;
      canvas.drawCircle(mid, 1.1, _fill(col));
    }
  }
  if (countdown != null && o.cells.isNotEmpty) {
    _label(canvas, _c(o.cells.first) + _dv(side) * 3.4, '$countdown', bg: const Color(0xFF2E6B2A));
  }
}

void _petalCage(Canvas canvas, Obstacle o, Color col) {
  for (final cell in o.cells) {
    final c = _c(cell);
    for (var i = 0; i < 4; i++) {
      final a = i * math.pi / 2 + math.pi / 4;
      canvas.drawOval(Rect.fromCenter(center: c + Offset(math.cos(a), math.sin(a)) * 3.8, width: 2.4, height: 2.4), _fill(col.withValues(alpha: .85)));
    }
    canvas.drawRect(_r(cell, 1.4), _line(col, .5));
  }
}

void _mongoose(Canvas canvas, Obstacle o, double idle) {
  final xs = o.cells.map((c) => c.x), ys = o.cells.map((c) => c.y);
  final r = Rect.fromLTRB(xs.reduce(math.min) * _u + .8, ys.reduce(math.min) * _u + .8, (xs.reduce(math.max) + 1) * _u - .8, (ys.reduce(math.max) + 1) * _u - .8);
  final bob = .4 * math.sin(idle * 2 * math.pi);
  final body = r.shift(Offset(0, bob));
  canvas.drawRRect(RRect.fromRectAndRadius(body, Radius.circular(body.shortestSide / 3)), _fill(const Color(0xFFA1887F)));
  canvas.drawRRect(RRect.fromRectAndRadius(body, Radius.circular(body.shortestSide / 3)), _line(const Color(0xFF5D4037), .7));
  final c = body.center;
  final s = body.shortestSide / 20;
  for (final e in [-1.0, 1.0]) {
    canvas.drawCircle(c + Offset(e * 3.2 * s, -1.6 * s), 1.4 * s, _fill(Colors.white));
    canvas.drawCircle(c + Offset(e * 3.2 * s, -1.4 * s), .7 * s, _fill(const Color(0xFF3E2723)));
    canvas.drawLine(c + Offset(e * 4.6 * s, -3.6 * s), c + Offset(e * 1.8 * s, -2.8 * s), _line(const Color(0xFF3E2723), .5 * s));
  }
  canvas.drawOval(Rect.fromCenter(center: c + Offset(0, 1.6 * s), width: 3 * s, height: 2 * s), _fill(const Color(0xFF3E2723)));
  canvas.drawArc(Rect.fromCenter(center: c + Offset(0, 4.2 * s), width: 5 * s, height: 2.4 * s), math.pi, math.pi, false, _line(const Color(0xFF3E2723), .45 * s));
  _label(canvas, body.topCenter + const Offset(0, -.6), 'HP ${o.value}', bg: const Color(0xFFC62828), size: 3.2);
}

// ── snake badges ──

/// Badges on top of a snake: lock reasons, counts and variants.
void paintSnakeMarks(Canvas canvas, Snake s, List<Offset> pts, Offset dir, {required double idle}) {
  final m = s.marks;
  if (pts.isEmpty) return;
  final head = pts.first, tail = pts.last;
  if (m.frozen > 0) {
    for (final p in pts) {
      canvas.drawCircle(p, 4.6, _fill(const Color(0x6681D4FA)));
    }
    canvas.drawPath(_poly(pts), _line(const Color(0xAAE1F5FE), 1.2));
    _label(canvas, head + const Offset(0, -5.2), '${m.frozen}', bg: const Color(0xFF0288D1), size: 3);
  }
  if (m.sleeping) _label(canvas, head + const Offset(3.6, -4.6), 'Zz', bg: const Color(0xFF5C6BC0), size: 2.8);
  if (m.hatch > 0) _label(canvas, head + const Offset(-3.8, -4.6), '${m.hatch}', bg: const Color(0xFFF9A825));
  if (m.restless > 0) _label(canvas, head + const Offset(3.8, 4.2), '${m.restless}', bg: const Color(0xFFE65100), size: 2.8);
  if (m.keyColor != null) {
    final at = pts.length > 1 ? pts[1] : head;
    _label(canvas, at, 'K', bg: mechColor(m.keyColor!), size: 2.8);
  }
  if (m.hungry) _label(canvas, head + const Offset(-3.6, 4.2), '●', color: const Color(0xFFE53935), bg: Colors.white, size: 2.6);
  if (m.growing) {
    canvas.drawCircle(tail, 1.4, _fill(const Color(0xFF9CCC65)));
    canvas.drawLine(tail, tail + const Offset(0, -2.4), _line(const Color(0xFF558B2F), .5));
  }
  if (m.group > 0 && pts.length > 1) {
    final mid = pts[pts.length ~/ 2];
    canvas.drawCircle(mid, 1.6, _fill(Colors.white));
    canvas.drawCircle(mid, 1.6, _line(const Color(0xFF6A1B9A), .45));
    _label(canvas, mid, '${m.group}', bg: const Color(0xFF6A1B9A), size: 2.4);
  }
  if (m.chameleon) {
    canvas.drawCircle(head, 5.4, _line(const Color(0xFFE91E63), .4));
    canvas.drawCircle(head, 5.9, _line(const Color(0xFF29B6F6), .4));
  }
  if (m.reverse && pts.length > 1) {
    final dv = tail - pts[pts.length - 2];
    final n = dv.distance < 1e-6 ? Offset.zero : dv / dv.distance;
    final d = n.dx.abs() > n.dy.abs() ? (n.dx > 0 ? Dir.right : Dir.left) : (n.dy > 0 ? Dir.down : Dir.up);
    _arrow(canvas, tail + n * 3.6, d, Colors.white, len: 1.6);
  }
  if (m.loop || m.lock == 'M046') _padlock(canvas, head + const Offset(0, -5.2), 1);
}

/// Lock icon shown for 600 ms after a locked tap, with a letter for the
/// reason so it never relies on colour alone.
void paintLockIcon(Canvas canvas, Offset at, String? reason, double alpha) {
  if (alpha <= 0) return;
  final hint = switch (reason) {
    'M003' => 'ice',
    'M010' => '?',
    'M012' => 'Zz',
    'M013' || 'M034' => 'turn',
    'M021' => 'ghost',
    'M028' => 'order',
    'M032' => 'under',
    'M033' => 'cage',
    _ => '',
  };
  canvas.saveLayer(null, Paint()..color = Colors.white.withValues(alpha: alpha));
  _padlock(canvas, at, 1.4);
  if (hint.isNotEmpty) _label(canvas, at + const Offset(0, 4.6), hint, bg: const Color(0xFF455A64), size: 2.6);
  canvas.restore();
}

void _padlock(Canvas canvas, Offset at, double k) {
  final body = Rect.fromCenter(center: at + Offset(0, 1 * k), width: 4.2 * k, height: 3.4 * k);
  canvas.drawArc(Rect.fromCenter(center: at - Offset(0, .6 * k), width: 2.8 * k, height: 3.4 * k), math.pi, math.pi, false, _line(const Color(0xFF455A64), .7 * k));
  canvas.drawRRect(RRect.fromRectAndRadius(body, Radius.circular(.8 * k)), _fill(const Color(0xFFFFCA28)));
  canvas.drawRRect(RRect.fromRectAndRadius(body, Radius.circular(.8 * k)), _line(const Color(0xFF455A64), .4 * k));
  canvas.drawCircle(body.center, .5 * k, _fill(const Color(0xFF455A64)));
}

Path _poly(List<Offset> pts) {
  final p = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (final q in pts.skip(1)) {
    p.lineTo(q.dx, q.dy);
  }
  return p;
}
