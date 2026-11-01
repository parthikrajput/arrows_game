// OWNER: UI agent. Board effects: exit sparkle, shield pop, hammer debris,
// heart-break petals. One pre-allocated pool, one drawRawAtlas per frame.
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum VfxKind { exitSparkle, shieldPop, hammerDebris, heartBreak }

/// Fixed-size particle pool. [cap] is the tier limit (30 / 80 / 150); a
/// burst that doesn't fit is trimmed, never grown.
class ParticlePool {
  ParticlePool(this.cap)
    : _x = Float32List(cap),
      _y = Float32List(cap),
      _vx = Float32List(cap),
      _vy = Float32List(cap),
      _life = Float32List(cap),
      _age = Float32List(cap),
      _size = Float32List(cap),
      _color = Int32List(cap);

  final int cap;
  final Float32List _x, _y, _vx, _vy, _life, _age, _size;
  final Int32List _color;
  int _live = 0;
  final _rnd = math.Random(3);

  int get live => _live;

  void burst(Offset at, int count, List<Color> colors, {double speed = 120, double size = 6, double life = .45}) {
    final n = math.min(count, cap - _live);
    for (var i = 0; i < n; i++) {
      final k = _live++;
      final a = _rnd.nextDouble() * math.pi * 2;
      final v = speed * (.4 + _rnd.nextDouble() * .6);
      _x[k] = at.dx;
      _y[k] = at.dy;
      _vx[k] = math.cos(a) * v;
      _vy[k] = math.sin(a) * v - speed * .3;
      _life[k] = life * (.7 + _rnd.nextDouble() * .5);
      _age[k] = 0;
      _size[k] = size * (.6 + _rnd.nextDouble() * .6);
      _color[k] = colors[i % colors.length].toARGB32();
    }
  }

  /// Advances [dt] seconds; dead particles are swapped out of the live range.
  void step(double dt) {
    var i = 0;
    while (i < _live) {
      _age[i] += dt;
      if (_age[i] >= _life[i]) {
        final last = --_live;
        _x[i] = _x[last];
        _y[i] = _y[last];
        _vx[i] = _vx[last];
        _vy[i] = _vy[last];
        _life[i] = _life[last];
        _age[i] = _age[last];
        _size[i] = _size[last];
        _color[i] = _color[last];
        continue;
      }
      _vy[i] += 260 * dt;
      _x[i] += _vx[i] * dt;
      _y[i] += _vy[i] * dt;
      i++;
    }
  }

  void clear() => _live = 0;

  /// Draws every live particle in one call.
  void paint(Canvas canvas, ui.Image sprite) {
    if (_live == 0) return;
    final xf = Float32List(_live * 4);
    final rects = Float32List(_live * 4);
    final colors = Int32List(_live);
    final w = sprite.width.toDouble();
    for (var i = 0; i < _live; i++) {
      final t = _age[i] / _life[i];
      final scale = _size[i] / w * (1 - t * .5);
      xf[i * 4] = scale;
      xf[i * 4 + 1] = 0;
      xf[i * 4 + 2] = _x[i] - w * scale / 2;
      xf[i * 4 + 3] = _y[i] - w * scale / 2;
      rects[i * 4 + 2] = w;
      rects[i * 4 + 3] = w;
      final c = Color(_color[i]);
      colors[i] = c.withValues(alpha: c.a * (1 - t)).toARGB32();
    }
    canvas.drawRawAtlas(sprite, xf, rects, colors, BlendMode.modulate, null, Paint());
  }
}

/// Plays board effects on top of the board and shakes it on a bump. Paints
/// nothing and runs no ticker while no effect is alive.
class VfxLayer extends StatefulWidget {
  const VfxLayer({super.key, required this.controller, required this.child});
  final VfxController controller;
  final Widget child;
  @override
  State<VfxLayer> createState() => _VfxLayerState();
}

/// Effects to play, fed by the gameplay route.
class VfxController extends ChangeNotifier {
  VfxController({required this.cap, required this.shakeDp});

  /// Tier limits; reduced motion passes 0 for both.
  int cap;
  double shakeDp;
  final _queue = <(VfxKind, Offset)>[];
  int _shakes = 0;

  void play(VfxKind k, Offset at) {
    if (cap == 0) return;
    _queue.add((k, at));
    notifyListeners();
  }

  void shake() {
    if (shakeDp <= 0) return;
    _shakes++;
    notifyListeners();
  }
}

class _VfxLayerState extends State<VfxLayer> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  late ParticlePool _pool = ParticlePool(widget.controller.cap);
  static ui.Image? _sprite;
  Duration _last = Duration.zero;
  double _shakeT = 1;
  int _seenShakes = 0;

  @override
  void initState() {
    super.initState();
    _sprite ??= _makeSprite();
    widget.controller.addListener(_onEvents);
  }

  @override
  void didUpdateWidget(VfxLayer old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onEvents);
      widget.controller.addListener(_onEvents);
    }
    if (_pool.cap != widget.controller.cap) _pool = ParticlePool(widget.controller.cap);
  }

  /// White soft dot; particles tint it with their colour.
  static ui.Image _makeSprite() {
    final rec = ui.PictureRecorder();
    final c = Canvas(rec);
    c.drawCircle(
      const Offset(16, 16),
      14,
      Paint()
        ..shader = ui.Gradient.radial(
          const Offset(16, 16),
          14,
          [Colors.white, Colors.white.withValues(alpha: 0)],
          [.55, 1],
        ),
    );
    return rec.endRecording().toImageSync(32, 32);
  }

  void _onEvents() {
    final c = widget.controller;
    for (final (k, at) in c._queue) {
      switch (k) {
        case VfxKind.exitSparkle:
          _pool.burst(at, 10, const [Color(0xFFFFF59D), Color(0xFFFFD54F), Colors.white], speed: 90, size: 7);
        case VfxKind.shieldPop:
          _pool.burst(at, 12, const [Color(0xFFFFB98A), Color(0xFFFFF3D6)], speed: 140, size: 8);
        case VfxKind.hammerDebris:
          _pool.burst(
            at,
            14,
            const [Color(0xFF9DA6A0), Color(0xFF66706A), Color(0xFF6FAE3E)],
            speed: 160,
            size: 7,
            life: .6,
          );
        case VfxKind.heartBreak:
          _pool.burst(at, 8, const [Color(0xFFFF4D5E), Color(0xFFA8102A)], speed: 110, size: 6);
      }
    }
    c._queue.clear();
    if (c._shakes != _seenShakes) {
      _seenShakes = c._shakes;
      _shakeT = 0;
    }
    if (!_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  void _tick(Duration now) {
    final dt = _last == Duration.zero ? 1 / 60 : (now - _last).inMicroseconds / 1e6;
    _last = now;
    _pool.step(dt.clamp(0, 1 / 20));
    if (_shakeT < 1) _shakeT = math.min(1, _shakeT + dt / .3);
    if (_pool.live == 0 && _shakeT >= 1) _ticker.stop();
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onEvents);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Three decaying cycles, horizontal only.
    final dx = _shakeT >= 1 ? 0.0 : math.sin(_shakeT * math.pi * 6) * widget.controller.shakeDp * (1 - _shakeT);
    return Transform.translate(
      offset: Offset(dx, 0),
      child: CustomPaint(foregroundPainter: _pool.live == 0 ? null : _VfxPainter(_pool, _sprite!), child: widget.child),
    );
  }
}

class _VfxPainter extends CustomPainter {
  _VfxPainter(this.pool, this.sprite);
  final ParticlePool pool;
  final ui.Image sprite;
  @override
  void paint(Canvas canvas, Size size) => pool.paint(canvas, sprite);
  @override
  bool shouldRepaint(_VfxPainter o) => true;
}
