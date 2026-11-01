// OWNER: UI agent. Canvas: Tutorial.dc.html (FTUE tip), Intro.dc.html
// (mechanic intro card), Tortoise.dc.html (Grandpa Tortoise).
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

/// Grandpa Tortoise bubble at the bottom of the board. It never covers the
/// board, so the player can do the step it describes.
class TutorialTip extends StatelessWidget {
  const TutorialTip({super.key, required this.data, required this.onGotIt});
  final TutorialTipData data;
  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 136),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: PopIn(
            child: Container(
              key: AppKeys.tutorialTip,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Color(0x5996825A), offset: Offset(0, 4)),
                  BoxShadow(color: Color(0x590A1E0A), offset: Offset(0, 24), blurRadius: 48),
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ArtIcon(Art.tortoise, size: 56),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'GRANDPA TORTOISE · LEVEL ${data.level}',
                            style: AppText.nunito(11, color: AppColors.emerald, spacing: .5),
                          ),
                          const SizedBox(height: 2),
                          Text(data.title, style: AppText.fredoka(19, height: 1.15)),
                          const SizedBox(height: 4),
                          Text(data.body, style: AppText.nunito(14, color: const Color(0xFF3B5240))),
                          if (data.showGotIt) ...[
                            const SizedBox(height: 10),
                            GameButton(key: AppKeys.tutorialGotIt, label: 'Got it', height: 44, onTap: onGotIt),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// "NEW!" card before the level that introduces a mechanic.
class MechanicIntroCard extends StatelessWidget {
  const MechanicIntroCard({super.key, required this.data, required this.onGotIt, this.fromGuide = false});
  final MechanicIntroData data;
  final VoidCallback onGotIt;

  /// Opened again from Settings › Jungle Guide.
  final bool fromGuide;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: PopIn(
          child: Container(
            key: AppKeys.introCard,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF2),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(0, -1)),
                BoxShadow(color: Color(0x5996825A), offset: Offset(0, 4)),
                BoxShadow(color: Color(0x590A1E0A), offset: Offset(0, 24), blurRadius: 48),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const ArtIcon(Art.tortoise, size: 64),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 22,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(
                                fromGuide ? 'JUNGLE GUIDE · LEVEL ${data.level}' : 'NEW! · LEVEL ${data.level}',
                                style: AppText.nunito(11, color: Colors.white, spacing: .5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(data.name, style: AppText.fredoka(26, height: 1.1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('"${data.rule}"', style: AppText.nunito(16, color: const Color(0xFF3B5240), height: 1.45)),
                  const SizedBox(height: 12),
                  _IntroLoop(type: data.type),
                  if (data.heartNote != null) ...[
                    const SizedBox(height: 8),
                    Text(data.heartNote!, style: AppText.nunito(14, color: const Color(0xFF5B6B5F))),
                  ],
                  const SizedBox(height: 14),
                  GameButton(key: AppKeys.introGotIt, label: 'Got it', onTap: onGotIt),
                  if (!fromGuide) ...[
                    const SizedBox(height: 8),
                    Text(
                      'See it again in Settings › Jungle Guide',
                      style: AppText.nunito(12, color: const Color(0xFF5B6B5F)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Three-frame loop: snake waits, meets the mechanic, slithers out. Frozen
/// on the middle frame when the player asks for less motion.
class _IntroLoop extends StatefulWidget {
  const _IntroLoop({required this.type});
  final String type;
  @override
  State<_IntroLoop> createState() => _IntroLoopState();
}

class _IntroLoopState extends State<_IntroLoop> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _c.value = .5;
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(18)),
    child: Column(
      children: [
        SizedBox(
          height: 96,
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, _) => CustomPaint(size: const Size(double.infinity, 96), painter: _LoopPainter(_c.value)),
          ),
        ),
        AnimatedBuilder(
          animation: _c,
          builder: (_, _) {
            final frame = (_c.value * 3).floor().clamp(0, 2);
            return Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == frame ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == frame ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

class _LoopPainter extends CustomPainter {
  _LoopPainter(this.t);
  final double t;
  @override
  void paint(Canvas canvas, Size size) {
    final cell = math.min(size.height / 2.2, size.width / 7);
    final origin = Offset((size.width - cell * 6) / 2, (size.height - cell) / 2);
    final tile = Paint()..color = const Color(0xFFFDFBF5);
    for (var x = 0; x < 6; x++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(origin.dx + x * cell + 2, origin.dy + 2, cell - 4, cell - 4),
          const Radius.circular(6),
        ),
        tile,
      );
    }
    // Mechanic stand-in on cell 3, snake slides out to the right.
    final m = origin + Offset(3.5 * cell, cell / 2);
    canvas.drawCircle(m, cell * .32, Paint()..color = const Color(0xFF8D6E63).withValues(alpha: t < 2 / 3 ? 1 : .25));
    final travel = t < 1 / 3 ? 0.0 : (t < 2 / 3 ? 1.6 : 1.6 + (t - 2 / 3) * 3 * 4);
    final body = Paint()
      ..color = const Color(0xFF7CB342)
      ..strokeWidth = cell * .55
      ..strokeCap = StrokeCap.round;
    final head = origin + Offset((1.5 + travel) * cell, cell / 2);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(origin.dx, origin.dy - cell, cell * 6, cell * 3));
    canvas.drawLine(head - Offset(cell, 0), head, body);
    canvas.drawCircle(head, cell * .32, Paint()..color = const Color(0xFF558B2F));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LoopPainter o) => o.t != t;
}
