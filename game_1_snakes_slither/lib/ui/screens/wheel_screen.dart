// OWNER: UI agent. Redesigned Lucky Lily Wheel screen per Phase 1 doc 06 §5.14 & 04 §10.
// Preserves constructor, contracts, and AppKeys intact.
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/bevel_button.dart';
import '../widgets/popup_card.dart';

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
  late final AnimationController _spinController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  );

  int? _lastSeq;
  double _baseAngle = 0.0;
  double _targetAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _lastSeq = widget.data.spinSeq;
    _checkSpin();
  }

  @override
  void didUpdateWidget(WheelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkSpin();
  }

  void _checkSpin() {
    if (widget.data.spinSeq != _lastSeq && widget.data.prizeIndex != null) {
      _lastSeq = widget.data.spinSeq;

      // 8 equal segments. Pointer is at the top (-pi/2).
      final segmentAngle = (2 * math.pi) / widget.data.segments.length;
      final targetIndex = widget.data.prizeIndex!;

      // Calculate angle so targetIndex lands under the top pointer
      // Full extra rotations (4 to 5 full spins) + segment offset
      final targetLanding = (2 * math.pi * 4) + (widget.data.segments.length - targetIndex) * segmentAngle;

      final isReduced = MediaQuery.of(context).disableAnimations;

      if (isReduced) {
        setState(() {
          _baseAngle = targetLanding;
          _targetAngle = targetLanding;
        });
      } else {
        setState(() {
          _baseAngle = _targetAngle % (2 * math.pi);
          _targetAngle = _baseAngle + targetLanding;
        });
        _spinController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _showOddsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => PopupCard(
        title: 'Wheel Odds & Rules',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Space.sm),
            for (final s in widget.data.segments)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.label,
                      style: AppText.body.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${(s.odds * 100).toStringAsFixed(1)}%',
                      style: AppText.body.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: Space.md),
            BevelButton.text(
              'Close',
              onPressed: () => Navigator.of(context).pop(),
              variant: BevelVariant.secondary,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final prize = d.prizeIndex == null ? null : d.segments[d.prizeIndex!];

    return Scaffold(
      key: AppKeys.wheelScreen,
      backgroundColor: AppColors.bgSage,
      appBar: AppBar(
        backgroundColor: AppColors.bgSage,
        elevation: 0,
        leading: BackButton(
          onPressed: widget.onBack,
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Lucky Lily Wheel',
          style: AppText.h1.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: AppColors.textPrimary),
            tooltip: 'Odds & Store Policy',
            onPressed: () => _showOddsSheet(context),
          ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          child: Column(
            children: [
              // Time locked warning (clock tamper protection)
              if (d.timeLocked)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: Space.sm),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(Radii.sm),
                    border: Border.all(color: AppColors.danger, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text('⏳', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: Space.sm),
                      Expanded(
                        child: Text(
                          'Your clock seems off — jungle time will return soon',
                          style: AppText.caption.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Wheel & Pointer Canvas
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Wheel
                      AnimatedBuilder(
                        animation: _spinController,
                        builder: (context, child) {
                          final currentAngle = _spinController.isAnimating
                              ? Tween<double>(begin: _baseAngle, end: _targetAngle)
                                  .chain(CurveTween(curve: Curves.decelerate))
                                  .evaluate(_spinController)
                              : _targetAngle;

                          return Transform.rotate(
                            angle: currentAngle,
                            child: CustomPaint(
                              size: const Size(280, 280),
                              painter: _WheelPainter(d.segments),
                            ),
                          );
                        },
                      ),

                      // Top Pointer (facing downward into the wheel)
                      Positioned(
                        top: 0,
                        child: _buildPointer(),
                      ),

                      // Center Hub Badge
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgCream,
                          border: Border.all(color: AppColors.coinGold, width: 3),
                          boxShadow: Shadows.elev1,
                        ),
                        child: const Center(
                          child: Text('🌸', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Prize Reveal Card
              if (prize != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E8),
                    borderRadius: BorderRadius.circular(Radii.md),
                    border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
                    boxShadow: Shadows.elev1,
                  ),
                  child: Text(
                    'You won: ${prize.label} 🎉',
                    style: AppText.h2.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Space.md),
              ],

              // Spin Buttons
              BevelButton.text(
                d.freeUsed ? 'Free spin used' : 'Spin free',
                key: AppKeys.wheelSpinFree,
                onPressed: d.freeAvailable && !d.busy && !d.timeLocked ? widget.onSpinFree : null,
                variant: BevelVariant.primary,
                expand: true,
                height: 52,
              ),
              const SizedBox(height: Space.md),

              BevelButton.text(
                d.adUsed ? 'Come back tomorrow' : '🎬 Spin again (1 left)',
                key: AppKeys.wheelSpinAd,
                onPressed: d.adAvailable && !d.busy && !d.timeLocked ? widget.onSpinAd : null,
                variant: BevelVariant.gold,
                expand: true,
                height: 52,
              ),
              const SizedBox(height: Space.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointer() {
    return Container(
      width: 28,
      height: 34,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _PointerPainter(),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter(this.segments);
  final List<WheelSegmentData> segments;

  static const _colors = [
    Color(0xFFE8F5E9),
    Color(0xFFFFF9C4),
    Color(0xFFE1F5FE),
    Color(0xFFFFECB3),
    Color(0xFFEDE7F6),
    Color(0xFFDCEDC8),
    Color(0xFFFFE0B2),
    Color(0xFFFCE4EC),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final count = segments.length;
    if (count == 0) return;

    final sweep = (2 * math.pi) / count;

    // Outer wheel border & shadow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.coinGoldDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    for (int i = 0; i < count; i++) {
      final startAngle = i * sweep - math.pi / 2;
      final segColor = _colors[i % _colors.length];

      // Draw segment slice
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          false,
        )
        ..close();

      canvas.drawPath(path, Paint()..color = segColor);

      // Draw dividing ray
      final edgeAngle = startAngle + sweep;
      final rayEnd = center + Offset(math.cos(edgeAngle), math.sin(edgeAngle)) * radius;
      canvas.drawLine(
        center,
        rayEnd,
        Paint()
          ..color = AppColors.coinGold
          ..strokeWidth = 2,
      );

      // Draw text label along segment axis
      final textAngle = startAngle + sweep / 2;
      final labelRadius = radius * 0.65;
      final labelPos = center + Offset(math.cos(textAngle), math.sin(textAngle)) * labelRadius;

      canvas.save();
      canvas.translate(labelPos.dx, labelPos.dy);
      canvas.rotate(textAngle + math.pi / 2);

      final textSpan = TextSpan(
        text: segments[i].label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1B2B1F),
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius * 0.5);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_WheelPainter oldDelegate) => oldDelegate.segments != segments;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.danger
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter oldDelegate) => false;
}
