// OWNER: UI agent. Canvas: Wheel.dc.html (Lucky Lily Wheel).
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/ui_feedback.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({
    super.key,
    required this.data,
    required this.onSpinFree,
    required this.onSpinAd,
    required this.onBack,
  });

  final WheelData data;
  final VoidCallback onSpinFree;
  final VoidCallback onSpinAd;
  final VoidCallback onBack;

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));
  double _from = 0;
  double _to = 0;
  bool _showOdds = false;
  bool _revealed = true;
  int _lastTick = 0;

  @override
  void initState() {
    super.initState();
    final i = widget.data.prizeIndex;
    if (i != null) _from = _to = _restAngle(i);
    _spin.addListener(_tick);
    _spin.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) setState(() => _revealed = true);
    });
  }

  /// Wheel turned so segment [i] sits under the pointer at the top.
  double _restAngle(int i) => -i * 2 * math.pi / widget.data.segments.length;

  @override
  void didUpdateWidget(WheelScreen old) {
    super.didUpdateWidget(old);
    final i = widget.data.prizeIndex;
    if (widget.data.spinSeq != old.data.spinSeq && i != null) {
      _from = _angle;
      final rest = _restAngle(i);
      final base = _from - (_from % (2 * math.pi));
      _to = base + 4 * 2 * math.pi + (rest % (2 * math.pi));
      _revealed = false;
      if (AppMotion.reduced(context)) {
        _spin.value = 1;
        _revealed = true;
      } else {
        _spin.forward(from: 0);
      }
    }
  }

  double get _angle => _from + (_to - _from) * Curves.decelerate.transform(_spin.value);

  void _tick() {
    final seg = (_angle / (2 * math.pi / 8)).floor();
    if (seg != _lastTick) {
      _lastTick = seg;
      UiFeedback.of(context).sound(UiSound.spinTick);
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final prize = d.prizeIndex == null || !_revealed ? null : d.segments[d.prizeIndex!];
    return Scaffold(
      key: AppKeys.wheelScreen,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -.1),
            radius: 1,
            colors: [Color(0xFFF3FBEF), Color(0xFFDCEFDC), Color(0xFFC2E2C2)],
            stops: [0, .55, 1],
          ),
        ),
        child: SafeArea(
          child: CenteredColumn(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          RoundButton(
                            size: 46,
                            label: 'Back',
                            onTap: widget.onBack,
                            child: const LineIconView(LineIcon.back, size: 18, color: Color(0xFF4A3A25)),
                          ),
                          Expanded(
                            child: Text(
                              'Lucky Lily Wheel',
                              textAlign: TextAlign.center,
                              style: AppText.fredoka(22, weight: 700),
                            ),
                          ),
                          RoundButton(
                            size: 46,
                            label: 'Show prize odds',
                            onTap: () => setState(() => _showOdds = true),
                            child: Text('i', style: AppText.fredoka(22, weight: 700, color: const Color(0xFF4A3A25))),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, box) {
                          final size = math.min(330.0, math.min(box.maxWidth - 40, box.maxHeight - 40));
                          return Center(
                            child: SizedBox.square(
                              dimension: size,
                              child: AnimatedBuilder(
                                animation: _spin,
                                builder: (_, _) => CustomPaint(painter: _WheelPainter(d.segments, _angle)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        d.timeLocked
                            ? 'Your clock seems off — jungle time will return soon'
                            : prize != null
                            ? 'You won ${prize.label}!'
                            : '',
                        textAlign: TextAlign.center,
                        style: AppText.fredoka(
                          d.timeLocked ? 15 : 20,
                          weight: 700,
                          color: d.timeLocked ? AppColors.danger : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 6, 28, 18),
                      child: Column(
                        children: [
                          _SpinButton(
                            label: d.freeUsed ? 'Free spin used today' : 'SPIN FREE',
                            onTap: d.freeAvailable && !d.busy && _revealed ? widget.onSpinFree : null,
                          ),
                          const SizedBox(height: 12),
                          Pressable(
                            key: AppKeys.wheelSpinAd,
                            onTap: d.adAvailable && !d.busy && _revealed ? widget.onSpinAd : null,
                            semanticLabel: 'Watch an ad to spin again',
                            child: Opacity(
                              opacity: d.adAvailable ? 1 : .55,
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xD9FFFFFF),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(color: Colors.white),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x1F1E3C1E), offset: Offset(0, 6), blurRadius: 16),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!d.adUsed) ...[
                                      const LineIconView(LineIcon.video, size: 20),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      d.adUsed ? 'Come back tomorrow' : 'Watch ad · spin again (1 left)',
                                      style: AppText.fredoka(16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '1 free spin a day · spins can\'t be bought',
                            style: AppText.nunito(12, weight: 700, color: const Color(0xFF5B6B5F)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_showOdds) _OddsSheet(segments: d.segments, onClose: () => setState(() => _showOdds = false)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinButton extends StatelessWidget {
  const _SpinButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final on = onTap != null;
    return Pressable(
      key: AppKeys.wheelSpinFree,
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: on ? null : const Color(0xFFDDE5DE),
          border: on ? Border.all(color: const Color(0xFFFFF3C4), width: 2) : null,
          gradient: on
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE082), Color(0xFFFFB300), Color(0xFFE08A00)],
                )
              : null,
          boxShadow: on
              ? const [
                  BoxShadow(color: Color(0xFFA86300), offset: Offset(0, 5)),
                  BoxShadow(color: Color(0x59A86300), offset: Offset(0, 14), blurRadius: 24),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppText.fredoka(
            22,
            weight: 700,
            color: on ? AppColors.goldText : const Color(0xFF5B6B5F),
          ).copyWith(letterSpacing: on ? 1 : 0),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter(this.segments, this.angle);
  final List<WheelSegmentData> segments;
  final double angle;

  static const _fills = [
    Color(0xFFFFF3D6),
    Color(0xFF43A047),
    Color(0xFFFFF3D6),
    Color(0xFFD81B60),
    Color(0xFFFFF3D6),
    Color(0xFF039BE5),
    Color(0xFFFFF3D6),
    Color(0xFFFFB300),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final R = size.width / 2;
    final r = R * 130 / 165;
    // Rim with bulbs.
    canvas.drawCircle(c + const Offset(0, 6), R, Paint()..color = const Color(0x40000000));
    canvas.drawCircle(
      c,
      R,
      Paint()
        ..shader = const RadialGradient(colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)])
            .createShader(Rect.fromCircle(center: c, radius: R)),
    );
    canvas.drawCircle(
      c,
      R - 3,
      Paint()
        ..color = const Color(0xFFFFD54F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    for (var k = 0; k < 16; k++) {
      final a = k * math.pi / 8 - math.pi / 2;
      final p = c + Offset(math.cos(a), math.sin(a)) * (R * 146 / 165);
      canvas.drawCircle(p, R * .028, Paint()..color = k.isEven ? const Color(0xFFFFF8D6) : const Color(0xFFFFCA28));
    }
    final n = segments.length;
    final sweep = 2 * math.pi / n;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    for (var i = 0; i < n; i++) {
      final start = -math.pi / 2 - sweep / 2 + i * sweep;
      final fill = _fills[i % _fills.length];
      canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: r), start, sweep, true, Paint()..color = fill);
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r),
        start,
        sweep,
        true,
        Paint()
          ..color = const Color(0x33000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      canvas.save();
      canvas.rotate(i * sweep);
      final light = fill == _fills[0];
      final label = segments[i].label;
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: AppText.fredoka(
            label.length > 6 ? r * .1 : r * .14,
            weight: 700,
            color: light ? const Color(0xFF3E2A00) : Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: r * .6);
      tp.paint(canvas, Offset(-tp.width / 2, -r * .62 - tp.height / 2));
      canvas.restore();
    }
    canvas.restore();
    // Hub.
    final hub = R * 32 / 165;
    canvas.drawCircle(c + const Offset(0, 4), hub + 2, Paint()..color = const Color(0x59000000));
    canvas.drawCircle(c, hub + 2, Paint()..color = const Color(0xFF8A5A00));
    canvas.drawCircle(c, hub, Paint()..color = Colors.white);
    canvas.drawCircle(
      c,
      hub - 3,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-.3, -.44),
          colors: [Color(0xFFFFF8D6), Color(0xFFFFCA28), Color(0xFFB07800)],
          stops: [0, .45, 1],
        ).createShader(Rect.fromCircle(center: c, radius: hub)),
    );
    // Pointer at the top.
    final top = c - Offset(0, R - 4);
    final ptr = Path()
      ..moveTo(top.dx - 14, top.dy - 10)
      ..lineTo(top.dx + 14, top.dy - 10)
      ..lineTo(top.dx, top.dy + 18)
      ..close();
    canvas.drawPath(ptr.shift(const Offset(0, 3)), Paint()..color = const Color(0x59000000));
    canvas.drawPath(ptr, Paint()..color = AppColors.red);
    canvas.drawPath(
      ptr,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_WheelPainter o) => o.angle != angle || o.segments != segments;
}

class _OddsSheet extends StatelessWidget {
  const _OddsSheet({required this.segments, required this.onClose});
  final List<WheelSegmentData> segments;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: ColoredBox(
      color: const Color(0x8C03261A),
      child: PopupCard(
        children: [
          Text('Prize odds', style: AppText.fredoka(24, weight: 700)),
          const SizedBox(height: 12),
          for (final s in segments)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text(s.label, style: AppText.nunito(15))),
                  Text('${(s.odds * 100).toStringAsFixed(s.odds * 100 % 1 == 0 ? 0 : 1)}%', style: AppText.fredoka(15)),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Text(
            "Slices look the same size, but these chances are the real ones. Spins can't be bought.",
            textAlign: TextAlign.center,
            style: AppText.nunito(12, weight: 700, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          GameButton(label: 'Close', tone: ButtonTone.cream, height: 48, onTap: onClose),
        ],
      ),
    ),
  );
}
