// OWNER: UI agent. "Jungle Dawn" launch intro (canvas: Main.dc.html splash):
// the dark canopy parts, dawn light washes in and the live Home appears.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

enum IntroMode {
  /// 1,200 ms: first install and first cold start of each day.
  full,

  /// 450 ms: later cold starts the same day (no rays, burst or letters).
  short,

  /// 150 ms cross-fade when the player asks for less motion.
  fade,
}

extension on IntroMode {
  Duration get length => switch (this) {
    IntroMode.full => const Duration(milliseconds: 1200),
    IntroMode.short => const Duration(milliseconds: 450),
    IntroMode.fade => const Duration(milliseconds: 150),
  };
}

const splashCanopy = Color(0xFF12301F);

/// Plays the intro over [child] (the live app). Home is interactive from
/// frame one: a tap on the Play button (found by [playKey]) goes straight
/// through, any other tap or Back skips to the end within 120 ms.
class JungleDawnIntro extends StatefulWidget {
  const JungleDawnIntro({
    super.key,
    required this.mode,
    required this.child,
    required this.playKey,
    this.particles = 24,
    this.onJank,
    this.onDone,
  });
  final IntroMode mode;
  final Widget child;
  final Key playKey;
  final int particles;

  /// Called with the slow frame's span when the jank guard aborts.
  final void Function(int ms)? onJank;
  final VoidCallback? onDone;

  @override
  State<JungleDawnIntro> createState() => _JungleDawnIntroState();
}

class _JungleDawnIntroState extends State<JungleDawnIntro> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.mode.length);
  late final AppLifecycleListener _life = AppLifecycleListener(onHide: skip);
  bool _done = false;
  bool _guarding = false;
  bool _observing = false;
  int _framesSeen = 0;

  @override
  void initState() {
    super.initState();
    _life;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // A skip restarts the animation, so completion is watched, not awaited.
    _c.addStatusListener((st) {
      if (st == AnimationStatus.completed) _finish();
    });
    _c.forward();
    SchedulerBinding.instance.addTimingsCallback(_jankGuard);
    _guarding = true;
    // Registered after the router's own back handler, so Back reaches the
    // intro first and skips it instead of leaving the app.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_done || !mounted) return;
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    });
  }

  @override
  Future<bool> didPopRoute() async {
    if (_done) return false;
    skip();
    return true;
  }

  void _stopGuard() {
    if (_guarding) SchedulerBinding.instance.removeTimingsCallback(_jankGuard);
    _guarding = false;
  }

  void _stopObserving() {
    if (_observing) WidgetsBinding.instance.removeObserver(this);
    _observing = false;
  }

  /// First 5 frames: one slower than 50 ms aborts into skip mode.
  void _jankGuard(List<ui.FrameTiming> timings) {
    for (final t in timings) {
      if (++_framesSeen > 5) {
        _stopGuard();
        return;
      }
      final ms = t.totalSpan.inMilliseconds;
      if (ms > 50) {
        widget.onJank?.call(ms);
        skip();
        return;
      }
    }
  }

  /// Runs the rest of the timeline in 120 ms.
  void skip() {
    if (_done || !_c.isAnimating) return;
    final left = 1 - _c.value;
    _c.animateTo(1, duration: Duration(milliseconds: (120 * left).ceil().clamp(1, 120)));
  }

  void _finish() {
    if (_done || !mounted) return;
    _stopGuard();
    _stopObserving();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    setState(() => _done = true);
    widget.onDone?.call();
  }

  @override
  void dispose() {
    _stopGuard();
    _stopObserving();
    _life.dispose();
    _c.dispose();
    super.dispose();
  }

  /// Screen rect of the Play button, if Home shows one.
  Rect? _playRect() {
    Rect? found;
    void visit(Element e) {
      if (found != null) return;
      if (e.widget.key == widget.playKey) {
        final box = e.renderObject;
        if (box is RenderBox && box.hasSize) found = box.localToGlobal(Offset.zero) & box.size;
        return;
      }
      e.visitChildren(visit);
    }

    (context as Element).visitChildren(visit);
    return found;
  }

  @override
  Widget build(BuildContext context) => Stack(
    textDirection: TextDirection.ltr,
    children: [
      widget.child,
      // The painter is gone once the intro ends, so idle Home costs 0 frames.
      if (!_done)
        Positioned.fill(
          child: _TapCatcher(
            passThrough: _playRect,
            onTap: skip,
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, _) => CustomPaint(
                painter: _DawnPainter(_c.value * widget.mode.length.inMilliseconds, widget.mode, widget.particles),
              ),
            ),
          ),
        ),
    ],
  );
}

/// Absorbs taps (skipping the intro) except inside [passThrough], where the
/// tap reaches the live Play button underneath.
class _TapCatcher extends SingleChildRenderObjectWidget {
  const _TapCatcher({required this.passThrough, required this.onTap, super.child});
  final Rect? Function() passThrough;
  final VoidCallback onTap;
  @override
  RenderObject createRenderObject(BuildContext context) => _RenderTapCatcher(passThrough, onTap);
  @override
  void updateRenderObject(BuildContext context, _RenderTapCatcher r) => r
    ..passThrough = passThrough
    ..onTap = onTap;
}

class _RenderTapCatcher extends RenderProxyBox {
  _RenderTapCatcher(this.passThrough, this.onTap);
  Rect? Function() passThrough;
  VoidCallback onTap;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) return false;
    final play = passThrough();
    if (play != null && play.contains(localToGlobal(position))) {
      onTap();
      return false; // the Play button gets this tap
    }
    result.add(BoxHitTestEntry(this, position));
    return true;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) onTap();
  }
}

double _seg(double ms, double a, double b) => ((ms - a) / (b - a)).clamp(0.0, 1.0);
double _ease(double t) => Curves.easeInOutCubic.transform(t);

class _DawnPainter extends CustomPainter {
  _DawnPainter(this.ms, this.mode, this.particles);
  final double ms;
  final IntroMode mode;
  final int particles;

  @override
  void paint(Canvas canvas, Size size) {
    if (mode == IntroMode.fade) {
      canvas.drawRect(Offset.zero & size, Paint()..color = splashCanopy.withValues(alpha: 1 - ms / 150));
      return;
    }
    final full = mode == IntroMode.full;
    // Short mode squeezes the same tracks into 450 ms.
    final k = full ? 1.0 : 1200 / 450;
    final t = ms * k;
    // dawn: canopy green washes away to reveal Home (sage).
    final dawn = _ease(_seg(t, 200, 900));
    canvas.drawRect(Offset.zero & size, Paint()..color = splashCanopy.withValues(alpha: 1 - dawn));
    // canopy front / mid: foliage slides off left and right.
    _canopy(canvas, size, _ease(_seg(t, 160, 760)), const Color(0xFF1E4A2C), .58);
    _canopy(canvas, size, _ease(_seg(t, 120, 700)), const Color(0xFF0F2A1A), .42);
    if (!full) return;
    // rays: three sunbeams, additive, max alpha 0.35.
    final rays = _seg(t, 350, 1000);
    if (rays > 0 && rays < 1) {
      final a = math.sin(rays * math.pi) * .35;
      final p = Paint()
        ..blendMode = BlendMode.plus
        ..color = const Color(0xFFFFF3B0).withValues(alpha: a);
      for (var i = 0; i < 3; i++) {
        final x = size.width * (.15 + .3 * i + .2 * rays);
        canvas.drawPath(
          Path()
            ..moveTo(x, 0)
            ..lineTo(x + 40, 0)
            ..lineTo(x - size.height * .4 + 90, size.height)
            ..lineTo(x - size.height * .4, size.height)
            ..close(),
          p,
        );
      }
    }
    // wordmark: letters pop with a 30 ms stagger, then the tagline.
    const word = 'SNAKES SLITHER';
    final y = size.height * .2;
    final style = TextStyle(
      fontFamily: 'Fredoka',
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: Colors.white.withValues(alpha: 1 - dawn * .9),
    );
    var x = size.width / 2 - word.length * 10.5;
    for (var i = 0; i < word.length; i++) {
      final s = Curves.easeOutBack.transform(_seg(t, 420 + i * 30.0, 620 + i * 30.0));
      if (s > 0) {
        final tp = TextPainter(
          text: TextSpan(text: word[i], style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        canvas.save();
        canvas.translate(x + tp.width / 2, y);
        canvas.scale(s);
        tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
        canvas.restore();
      }
      x += 21;
    }
    final sub = _seg(t, 700, 1000);
    if (sub > 0) {
      final tp = TextPainter(
        text: TextSpan(
          text: 'Untangle the jungle, one snake at a time',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            color: Colors.white.withValues(alpha: sub * (1 - dawn)),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width - 32);
      tp.paint(canvas, Offset((size.width - tp.width) / 2, y + 30));
    }
    // leafBurst: leaves fly out of where the Play button lands.
    final burst = _seg(t, 600, 900);
    if (burst > 0 && burst < 1) {
      final origin = Offset(size.width / 2, size.height * .72);
      final rnd = math.Random(11);
      final leaf = Paint()..color = const Color(0xFF7CB342).withValues(alpha: 1 - burst);
      for (var i = 0; i < particles; i++) {
        final a = rnd.nextDouble() * math.pi * 2;
        final d = (60 + rnd.nextDouble() * 80) * Curves.easeOut.transform(burst);
        final p = origin + Offset(math.cos(a), math.sin(a)) * d;
        canvas.save();
        canvas.translate(p.dx, p.dy);
        canvas.rotate(a + burst * 3);
        canvas.drawOval(const Rect.fromLTWH(-5, -2.5, 10, 5), leaf);
        canvas.restore();
      }
    }
  }

  void _canopy(Canvas canvas, Size size, double open, Color c, double reach) {
    if (open >= 1) return;
    final p = Paint()..color = c;
    final w = size.width * reach;
    for (final left in [true, false]) {
      final dx = (left ? -1 : 1) * open * (w + 40);
      final base = left ? 0.0 : size.width;
      final dir = left ? 1 : -1;
      final path = Path()..moveTo(base, 0);
      for (var i = 0; i <= 8; i++) {
        final y = size.height * i / 8;
        path.quadraticBezierTo(base + dir * w * 1.1, y - size.height / 16, base + dir * w * (.8 + .2 * (i % 2)), y);
      }
      path
        ..lineTo(base, size.height)
        ..close();
      canvas.save();
      canvas.translate(dx, 0);
      canvas.drawPath(path, p);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_DawnPainter o) => o.ms != ms;
}
