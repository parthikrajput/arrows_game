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
    this.guardJank = true,
  });
  final IntroMode mode;
  final Widget child;
  final Key playKey;
  final int particles;

  /// Called with the slow frame's span when the jank guard aborts.
  final void Function(int ms)? onJank;
  final VoidCallback? onDone;

  /// Skip the intro when one of the first frames is slow (off for screenshots).
  final bool guardJank;

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
    if (widget.guardJank) {
      SchedulerBinding.instance.addTimingsCallback(_jankGuard);
      _guarding = true;
    }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Decode the logo before the first intro frame needs it.
    precacheImage(const AssetImage(kIntroLogo), context);
  }

  @override
  Widget build(BuildContext context) => Stack(
    textDirection: TextDirection.ltr,
    children: [
      widget.child,
      // The layers are gone once the intro ends, so idle Home costs 0 frames.
      if (!_done)
        Positioned.fill(
          child: _TapCatcher(
            passThrough: _playRect,
            onTap: skip,
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, _) {
                final ms = _c.value * widget.mode.length.inMilliseconds;
                final tl = _Timeline(ms, widget.mode);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(painter: _BackPainter(tl, widget.particles)),
                    if (tl.logoOpacity > 0) _Logo(tl: tl),
                    CustomPaint(painter: _FrontPainter(tl, widget.particles)),
                  ],
                );
              },
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

const kIntroLogo = 'assets/images/logo.webp';

double _seg(double t, double a, double b) => ((t - a) / (b - a)).clamp(0.0, 1.0);
double _ease(double t) => Curves.easeInOutCubic.transform(t);

/// Every track of the intro at one moment. Full mode times are in ms of the
/// 1,200 ms timeline; short mode runs the same tracks squeezed into 450 ms
/// without rays, fireflies or bursts.
class _Timeline {
  _Timeline(double ms, this.mode) : t = ms * (mode == IntroMode.short ? 1200 / 450 : 1), ms = ms;
  final IntroMode mode;
  final double ms;
  final double t;

  bool get full => mode == IntroMode.full;
  bool get fade => mode == IntroMode.fade;

  /// Canopy dark → Home.
  double get dawn => fade ? (ms / 150).clamp(0.0, 1.0) : _ease(_seg(t, 480, 1100));
  double get canopyFront => _ease(_seg(t, 380, 950));
  double get canopyBack => _ease(_seg(t, 440, 1010));
  double get rays => full ? _seg(t, 300, 1050) : 0;
  double get sparkles => full ? _seg(t, 260, 820) : 0;
  double get leafBurst => full ? _seg(t, 650, 950) : 0;

  /// Logo lands (scale .72 → 1 with a small overshoot), shines, then lifts away.
  double get logoIn => Curves.easeOutBack.transform(_seg(t, 0, 420));
  double get logoOut => Curves.easeInCubic.transform(_seg(t, 660, 920));
  double get logoOpacity => fade ? 0 : (_seg(t, 0, 160) * (1 - logoOut)).clamp(0.0, 1.0);
  double get logoScale => (.72 + .28 * logoIn) * (1 + .12 * logoOut);
  double get shine => _seg(t, 200, 660);
  double get tagline => _seg(t, 340, 560) * (1 - logoOut);

  /// Gentle 0..1 loop for halos and fireflies.
  double get pulse => .5 + .5 * math.sin(ms / 1200 * math.pi * 2 * 1.5);
}

const _canopy = Color(0xFF12301F);

Offset _logoCenter(Size s) => Offset(s.width / 2, s.height * .4);
double _logoWidth(Size s) => math.min(320, s.width * .7);

class _Logo extends StatelessWidget {
  const _Logo({required this.tl});
  final _Timeline tl;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, box) {
      final size = box.biggest;
      final w = _logoWidth(size);
      final c = _logoCenter(size);
      final h = w * 1.133; // logo aspect (900 × 1020)
      final band = -0.4 + 1.8 * tl.shine;
      return Stack(
        children: [
          Positioned(
            left: c.dx - w / 2,
            top: c.dy - h / 2 - 48 * tl.logoOut,
            width: w,
            height: h,
            child: Opacity(
              opacity: tl.logoOpacity,
              child: Transform.scale(
                scale: tl.logoScale,
                child: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (r) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [Color(0x00FFFFFF), Color(0x8CFFF6D6), Color(0x00FFFFFF)],
                    stops: [(band - .12).clamp(0.0, 1.0), band.clamp(0.0, 1.0), (band + .12).clamp(0.0, 1.0)],
                  ).createShader(r),
                  child: Image.asset(
                    kIntroLogo,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    semanticLabel: 'Snake Slither',
                  ),
                ),
              ),
            ),
          ),
          if (tl.tagline > 0)
            Positioned(
              left: 24,
              right: 24,
              top: c.dy + h / 2 + 4 + 10 * (1 - tl.tagline),
              child: Opacity(
                opacity: tl.tagline,
                child: Text(
                  'Untangle the jungle, one snake at a time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontVariations: const [FontVariation.weight(800)],
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: .4,
                    color: const Color(0xFFF6E2A6),
                    shadows: const [Shadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 6)],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

/// Night canopy, gold halo, sun rays, both foliage layers and fireflies.
class _BackPainter extends CustomPainter {
  _BackPainter(this.tl, this.particles);
  final _Timeline tl;
  final int particles;

  @override
  void paint(Canvas canvas, Size size) {
    final dark = 1 - tl.dawn;
    if (dark <= 0) return;
    final rect = Offset.zero & size;
    if (tl.fade) {
      canvas.drawRect(rect, Paint()..color = _canopy.withValues(alpha: dark));
      return;
    }
    // Deep emerald night with a lighter heart behind the logo.
    canvas.saveLayer(rect, Paint()..color = Color.fromRGBO(0, 0, 0, dark));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -.2),
          radius: 1.05,
          colors: const [Color(0xFF2A6B43), Color(0xFF15402A), _canopy, Color(0xFF06160D)],
          stops: const [0, .35, .7, 1],
        ).createShader(rect),
    );
    // Gold halo behind the logo.
    final c = _logoCenter(size);
    final hr = _logoWidth(size) * (.75 + .06 * tl.pulse);
    canvas.drawCircle(
      c,
      hr,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE39A).withValues(alpha: .42 * tl.logoOpacity),
            const Color(0xFFD6A83F).withValues(alpha: .12 * tl.logoOpacity),
            const Color(0x00D6A83F),
          ],
          stops: const [0, .55, 1],
        ).createShader(Rect.fromCircle(center: c, radius: hr)),
    );
    _rays(canvas, size);
    _foliage(canvas, size, tl.canopyBack, back: true);
    _fireflies(canvas, size);
    // Front leaves stay below the logo so the wordmark is never covered.
    _foliage(canvas, size, tl.canopyFront, back: false);
    canvas.restore();
  }

  void _rays(Canvas canvas, Size size) {
    final r = tl.rays;
    if (r <= 0 || r >= 1) return;
    final a = math.sin(r * math.pi) * .35;
    final origin = Offset(size.width * .78, -size.height * .08);
    for (var i = 0; i < 4; i++) {
      final ang = math.pi / 2 + .28 + i * .16 + (-.1 + .17 * r);
      final len = size.height * 1.3;
      final dir = Offset(math.cos(ang), math.sin(ang));
      final perp = Offset(-dir.dy, dir.dx);
      final w = 26.0 + i * 14;
      final end = origin + dir * len;
      final path = Path()
        ..moveTo(origin.dx + perp.dx * 4, origin.dy + perp.dy * 4)
        ..lineTo(origin.dx - perp.dx * 4, origin.dy - perp.dy * 4)
        ..lineTo(end.dx - perp.dx * w * 2, end.dy - perp.dy * w * 2)
        ..lineTo(end.dx + perp.dx * w * 2, end.dy + perp.dy * w * 2)
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..blendMode = BlendMode.plus
          ..shader = ui.Gradient.linear(origin, end, [
            const Color(0xFFFFF3C4).withValues(alpha: a * (i.isEven ? 1 : .7)),
            const Color(0x00FFF3C4),
          ]),
      );
    }
  }

  void _fireflies(Canvas canvas, Size size) {
    if (!tl.full) return;
    final rnd = math.Random(5);
    final n = (particles * .75).round().clamp(8, 30);
    final glow = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    final core = Paint();
    for (var i = 0; i < n; i++) {
      final bx = rnd.nextDouble() * size.width;
      final by = size.height * (.08 + rnd.nextDouble() * .86);
      final ph = rnd.nextDouble() * math.pi * 2;
      final drift = tl.ms / 1200;
      final p = Offset(bx + math.sin(ph + drift * 5) * 14, by - drift * (24 + rnd.nextDouble() * 30));
      final tw = .45 + .55 * (.5 + .5 * math.sin(ph * 3 + tl.ms / 90));
      final a = tw * _seg(tl.ms, 0, 250);
      canvas.drawCircle(p, 9, glow..color = const Color(0xFFFFE680).withValues(alpha: .55 * a));
      canvas.drawCircle(p, 2.2, core..color = const Color(0xFFFFFBE0).withValues(alpha: a));
    }
  }

  @override
  bool shouldRepaint(_BackPainter o) => o.tl.ms != tl.ms;
}

/// Gold sparkle burst and the leaf burst at Play, above the logo.
class _FrontPainter extends CustomPainter {
  _FrontPainter(this.tl, this.particles);
  final _Timeline tl;
  final int particles;

  @override
  void paint(Canvas canvas, Size size) {
    if (tl.full) {
      _sparkles(canvas, size);
      _leafBurst(canvas, size);
    }
  }

  void _sparkles(Canvas canvas, Size size) {
    final s = tl.sparkles;
    if (s <= 0 || s >= 1) return;
    final c = _logoCenter(size);
    final rnd = math.Random(3);
    final n = (particles * .6).round().clamp(8, 24);
    final r0 = _logoWidth(size) * .42;
    for (var i = 0; i < n; i++) {
      final ang = i / n * math.pi * 2 + rnd.nextDouble() * .4;
      final dist = r0 + (40 + rnd.nextDouble() * 90) * Curves.easeOutCubic.transform(s);
      final p = c + Offset(math.cos(ang), math.sin(ang) * .9) * dist;
      final a = math.sin(s * math.pi) * (.6 + .4 * rnd.nextDouble());
      final k = 4 + rnd.nextDouble() * 6;
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(s * 2 + i);
      final star = Path()
        ..moveTo(0, -k)
        ..quadraticBezierTo(k * .14, -k * .14, k, 0)
        ..quadraticBezierTo(k * .14, k * .14, 0, k)
        ..quadraticBezierTo(-k * .14, k * .14, -k, 0)
        ..quadraticBezierTo(-k * .14, -k * .14, 0, -k)
        ..close();
      canvas.drawCircle(
        Offset.zero,
        k * 1.3,
        Paint()
          ..color = const Color(0xFFFFD86B).withValues(alpha: .35 * a)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawPath(star, Paint()..color = const Color(0xFFFFF4C8).withValues(alpha: a));
      canvas.restore();
    }
  }

  void _leafBurst(Canvas canvas, Size size) {
    final burst = tl.leafBurst;
    if (burst <= 0 || burst >= 1) return;
    final origin = Offset(size.width / 2, size.height * .72);
    final rnd = math.Random(11);
    for (var i = 0; i < particles; i++) {
      final a = rnd.nextDouble() * math.pi * 2;
      final d = (60 + rnd.nextDouble() * 90) * Curves.easeOutCubic.transform(burst);
      final p = origin + Offset(math.cos(a), math.sin(a)) * d;
      final gold = i % 4 == 0;
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(a + burst * 4);
      canvas.drawPath(
        _leafPath(11),
        Paint()..color = (gold ? const Color(0xFFF2C14E) : const Color(0xFF7CB342)).withValues(alpha: 1 - burst),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FrontPainter o) => o.tl.ms != tl.ms;
}

/// A leaf pointing along +x, [len] long.
Path _leafPath(double len) => Path()
  ..moveTo(-len / 2, 0)
  ..cubicTo(-len / 4, -len * .32, len / 4, -len * .32, len / 2, 0)
  ..cubicTo(len / 4, len * .32, -len / 4, len * .32, -len / 2, 0)
  ..close();

/// Clusters of big jungle leaves on both edges that slide apart as [open]
/// goes 0 → 1. Back leaves are lighter and move slower (parallax).
void _foliage(Canvas canvas, Size size, double open, {required bool back}) {
  if (open >= 1) return;
  final rnd = math.Random(back ? 21 : 42);
  final count = back ? 9 : 11;
  final reach = size.width * (back ? .7 : 1.15);
  final colors = back ? const [Color(0xFF2E6B3F), Color(0xFF1B4A2B)] : const [Color(0xFF1F5A33), Color(0xFF0B2516)];
  for (final left in [true, false]) {
    final side = left ? -1.0 : 1.0;
    canvas.save();
    canvas.translate(side * open * reach, 0);
    for (var i = 0; i < count; i++) {
      final y = size.height * (i + rnd.nextDouble() * .6) / count;
      final len = (back ? 130 : 150) + rnd.nextDouble() * (back ? 90 : 70);
      // Leaves reach about a third of the width, so the logo stays clear.
      final inset = size.width * (back ? .3 : .26) - len * .85;
      final x = left ? inset : size.width - inset;
      final ang = (left ? 0 : math.pi) + (rnd.nextDouble() - .5) * 1.2;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(ang);
      canvas.translate(len * .35, 0);
      final leaf = _leafPath(len);
      final r = Rect.fromCenter(center: Offset.zero, width: len, height: len * .64);
      canvas.drawPath(
        leaf.shift(const Offset(4, 8)),
        Paint()
          ..color = const Color(0x66020C06)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      canvas.drawPath(
        leaf,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ).createShader(r),
      );
      // Midrib and a soft rim light from the dawn side.
      canvas.drawLine(
        Offset(-len / 2 + 6, 0),
        Offset(len / 2 - 8, 0),
        Paint()
          ..color = const Color(0x59A8D97A)
          ..strokeWidth = 2,
      );
      canvas.drawPath(
        leaf,
        Paint()
          ..color = const Color(0x2EFFF3C4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      canvas.restore();
    }
    canvas.restore();
  }
}
