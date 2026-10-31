// OWNER: UI agent. Small pictures from the UI canvas, drawn from the same
// SVG source so they match the design exactly.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../contracts/view_models.dart';
import 'booster_svgs.dart';

const _coin =
    '<svg viewBox="0 0 24 24"><defs><radialGradient id="c" cx="0.35" cy="0.3" r="0.8"><stop offset="0" stop-color="#FFF2A8"/><stop offset="0.45" stop-color="#F9C93A"/><stop offset="1" stop-color="#D98E10"/></radialGradient></defs><circle cx="12" cy="12.6" r="10.4" fill="#B8730A"/><circle cx="12" cy="11.6" r="10.4" fill="url(#c)"/><circle cx="12" cy="11.6" r="7" fill="none" stroke="#C98200" stroke-width="1.4" opacity="0.7"/><path d="M12 7.2 l1.3 2.7 3 .4 -2.2 2.1 .5 3 -2.6-1.4 -2.6 1.4 .5-3 -2.2-2.1 3-.4z" fill="#FFE27A" stroke="#C98200" stroke-width="0.6"/></svg>';
const _star =
    '<svg viewBox="0 0 24 24"><defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFE98A"/><stop offset="0.5" stop-color="#F9C93A"/><stop offset="1" stop-color="#E39A12"/></linearGradient></defs><path d="M12 2.2l2.95 6.1 6.7.85-4.95 4.6 1.3 6.65L12 17.1l-6 3.3 1.3-6.65L2.35 9.15l6.7-.85z" fill="url(#s)" stroke="#C98200" stroke-width="1.1" stroke-linejoin="round"/><path d="M8.6 8.9 L11 8.6" stroke="#FFFBE0" stroke-width="1.4" stroke-linecap="round"/></svg>';
const _starEmpty =
    '<svg viewBox="0 0 24 24"><path d="M12 2.2l2.95 6.1 6.7.85-4.95 4.6 1.3 6.65L12 17.1l-6 3.3 1.3-6.65L2.35 9.15l6.7-.85z" fill="#E2D9BE" stroke="#C9BE9C" stroke-width="1.1" stroke-linejoin="round"/></svg>';
const _heart =
    '<svg viewBox="0 0 24 24"><path d="M12 21 C5 15.5 2 12.4 2 8.6 C2 5.6 4.4 3.4 7.2 3.4 C9.1 3.4 10.9 4.5 12 6.1 C13.1 4.5 14.9 3.4 16.8 3.4 C19.6 3.4 22 5.6 22 8.6 C22 12.4 19 15.5 12 21 Z" fill="#FF4D5E" stroke="#A8102A" stroke-width="1.4"/><ellipse cx="7.6" cy="7.6" rx="2.2" ry="1.4" fill="#FFFFFF" opacity="0.6"/></svg>';
const _heartEmpty =
    '<svg viewBox="0 0 24 24"><path d="M12 21 C5 15.5 2 12.4 2 8.6 C2 5.6 4.4 3.4 7.2 3.4 C9.1 3.4 10.9 4.5 12 6.1 C13.1 4.5 14.9 3.4 16.8 3.4 C19.6 3.4 22 5.6 22 8.6 C22 12.4 19 15.5 12 21 Z" fill="#0E2A18" stroke="#FFFFFF" stroke-opacity="0.45" stroke-width="1.4"/></svg>';
const _gift =
    '<svg viewBox="0 0 48 48"><ellipse cx="24" cy="44" rx="16" ry="2.6" fill="#000" opacity="0.12"/><rect x="7" y="20" width="34" height="23" rx="3" fill="#E84B3C"/><rect x="7" y="20" width="34" height="5" fill="#000" opacity="0.12"/><rect x="5" y="14" width="38" height="9" rx="2.5" fill="#E84B3C"/><rect x="5" y="14" width="38" height="3" rx="1.5" fill="#FFF" opacity="0.25"/><rect x="21" y="14" width="6" height="29" fill="#F4B72F"/><rect x="21" y="14" width="2" height="29" fill="#FFF" opacity="0.35"/><path d="M24 14 C 16 4, 8 10, 14 14 Z M24 14 C 32 4, 40 10, 34 14 Z" fill="#F4B72F" stroke="#C98200" stroke-width="1"/></svg>';
const _flower =
    '<svg viewBox="0 0 48 48"><g transform="translate(24 24)"><g fill="#F48FB1" stroke="#C2457E" stroke-width="1"><ellipse rx="7" ry="13" cy="-10"/><ellipse rx="7" ry="13" cy="-10" transform="rotate(60)"/><ellipse rx="7" ry="13" cy="-10" transform="rotate(120)"/><ellipse rx="7" ry="13" cy="-10" transform="rotate(180)"/><ellipse rx="7" ry="13" cy="-10" transform="rotate(240)"/><ellipse rx="7" ry="13" cy="-10" transform="rotate(300)"/></g><circle r="7" fill="#FFD84A" stroke="#C98200" stroke-width="1.2"/></g></svg>';
const _shell =
    '<svg viewBox="0 0 24 24"><path d="M12 21 L3 9.5 C 3 3.5 21 3.5 21 9.5 Z" fill="#FFB98A" stroke="#B4441E" stroke-width="1.2" stroke-linejoin="round"/><path d="M12 21 V5 M12 21 L8 5.6 M12 21 L16 5.6 M12 21 L5 7.5 M12 21 L19 7.5" stroke="#C8532A" stroke-width="0.9" fill="none"/></svg>';

enum Art { coin, star, starEmpty, heart, heartEmpty, gift, flower, shell, hint, shield, hammer }

class ArtIcon extends StatelessWidget {
  const ArtIcon(this.art, {super.key, this.size = 24, this.dim = false});
  final Art art;
  final double size;
  final bool dim;

  static Art booster(Booster b) => switch (b) {
    Booster.hint => Art.hint,
    Booster.shield => Art.shield,
    Booster.hammer => Art.hammer,
  };

  @override
  Widget build(BuildContext context) {
    final src = switch (art) {
      Art.coin => _coin,
      Art.star => _star,
      Art.starEmpty => _starEmpty,
      Art.heart => _heart,
      Art.heartEmpty => _heartEmpty,
      Art.gift => _gift,
      Art.flower => _flower,
      Art.shell => _shell,
      Art.hint => kHintSvg,
      Art.shield => kShieldSvg,
      Art.hammer => kHammerSvg,
    };
    Widget pic = SvgPicture.string(src, width: size, height: size);
    if (dim) {
      pic = Opacity(
        opacity: .55,
        child: ColorFiltered(colorFilter: const ColorFilter.matrix(_grey), child: pic),
      );
    }
    return ExcludeSemantics(child: pic);
  }

  static const _grey = <double>[
    .33, .59, .11, 0, 0, //
    .33, .59, .11, 0, 0,
    .33, .59, .11, 0, 0,
    0, 0, 0, 1, 0,
  ];
}

/// Simple line icons from the canvas (24 × 24 grid, stroke 2).
enum LineIcon {
  home,
  shop,
  ranks,
  map,
  settings,
  gear,
  back,
  pause,
  play,
  lock,
  sound,
  music,
  haptics,
  close,
  video,
  contrast,
  motion,
  star,
}

class LineIconView extends StatelessWidget {
  const LineIconView(this.icon, {super.key, this.size = 22, this.color = const Color(0xFF163B28)});
  final LineIcon icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _LinePainter(icon, color)),
  );
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.icon, this.color);
  final LineIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = color;
    switch (icon) {
      case LineIcon.home:
        final p = Path()
          ..moveTo(4, 11)
          ..lineTo(12, 4)
          ..lineTo(20, 11)
          ..lineTo(20, 20)
          ..lineTo(14, 20)
          ..lineTo(14, 14)
          ..lineTo(10, 14)
          ..lineTo(10, 20)
          ..lineTo(4, 20)
          ..close();
        canvas.drawPath(p, fill);
        canvas.drawPath(p, stroke);
      case LineIcon.shop:
        canvas.drawPath(
          Path()
            ..moveTo(5, 8)
            ..lineTo(19, 8)
            ..lineTo(18, 20)
            ..lineTo(6, 20)
            ..close(),
          stroke,
        );
        canvas.drawArc(const Rect.fromLTWH(9, 3, 6, 6), math.pi, math.pi, false, stroke);
        canvas.drawLine(const Offset(9, 6), const Offset(9, 8), stroke);
        canvas.drawLine(const Offset(15, 6), const Offset(15, 8), stroke);
      case LineIcon.ranks:
        for (final r in const [
          Rect.fromLTRB(4, 13, 9, 20),
          Rect.fromLTRB(9.5, 8, 14.5, 20),
          Rect.fromLTRB(15, 11, 20, 20),
        ]) {
          canvas.drawRect(r, stroke);
        }
      case LineIcon.map:
        canvas.drawPath(
          Path()
            ..moveTo(3, 6.5)
            ..lineTo(9, 4)
            ..lineTo(15, 6.5)
            ..lineTo(21, 4)
            ..lineTo(21, 17.5)
            ..lineTo(15, 20)
            ..lineTo(9, 17.5)
            ..lineTo(3, 20)
            ..close(),
          stroke,
        );
        canvas.drawLine(const Offset(9, 4), const Offset(9, 17.5), stroke);
        canvas.drawLine(const Offset(15, 6.5), const Offset(15, 20), stroke);
      case LineIcon.settings:
        canvas.drawCircle(const Offset(12, 12), 3.2, stroke);
        for (var i = 0; i < 8; i++) {
          final a = i * math.pi / 4;
          final d = Offset(math.cos(a), math.sin(a));
          canvas.drawLine(const Offset(12, 12) + d * 7.2, const Offset(12, 12) + d * 9.2, stroke);
        }
      case LineIcon.gear:
        final teeth = Path();
        for (var i = 0; i < 8; i++) {
          final a = i * math.pi / 4;
          teeth.addRect(
            Rect.fromCenter(center: Offset(12 + math.cos(a) * 8.2, 12 + math.sin(a) * 8.2), width: 3.4, height: 3.4),
          );
        }
        canvas.drawPath(teeth, fill);
        canvas.drawCircle(const Offset(12, 12), 7, fill);
        canvas.drawCircle(const Offset(12, 12), 3, Paint()..color = const Color(0xFFFFFEF8));
      case LineIcon.back:
        canvas.drawPath(
          Path()
            ..moveTo(15, 5)
            ..lineTo(8, 12)
            ..lineTo(15, 19),
          stroke..strokeWidth = 3,
        );
      case LineIcon.pause:
        canvas.drawRRect(RRect.fromLTRBR(5, 4, 10, 20, const Radius.circular(1.5)), fill);
        canvas.drawRRect(RRect.fromLTRBR(14, 4, 19, 20, const Radius.circular(1.5)), fill);
      case LineIcon.play:
        final p = Path()
          ..moveTo(7, 4.5)
          ..lineTo(19.5, 12)
          ..lineTo(7, 19.5)
          ..close();
        canvas.drawPath(p, fill);
        canvas.drawPath(p, stroke);
      case LineIcon.lock:
        canvas.drawRRect(RRect.fromLTRBR(5, 10, 19, 21, const Radius.circular(3)), fill);
        canvas.drawArc(const Rect.fromLTWH(8, 3.5, 8, 8), math.pi, math.pi, false, stroke..strokeWidth = 2.4);
        canvas.drawLine(const Offset(8, 7.5), const Offset(8, 10), stroke);
        canvas.drawLine(const Offset(16, 7.5), const Offset(16, 10), stroke);
      case LineIcon.sound:
        canvas.drawPath(
          Path()
            ..moveTo(4, 9.5)
            ..lineTo(8, 9.5)
            ..lineTo(13, 5)
            ..lineTo(13, 19)
            ..lineTo(8, 14.5)
            ..lineTo(4, 14.5)
            ..close(),
          fill,
        );
        canvas.drawArc(const Rect.fromLTWH(11, 8, 8, 8), -math.pi / 3, 2 * math.pi / 3, false, stroke);
      case LineIcon.music:
        canvas.drawLine(const Offset(9, 17), const Offset(9, 5), stroke);
        canvas.drawLine(const Offset(9, 5), const Offset(19, 3), stroke);
        canvas.drawLine(const Offset(19, 3), const Offset(19, 15), stroke);
        canvas.drawCircle(const Offset(6.5, 17.5), 2.6, fill);
        canvas.drawCircle(const Offset(16.5, 15.5), 2.6, fill);
      case LineIcon.haptics:
        canvas.drawRRect(RRect.fromLTRBR(8, 3, 16, 21, const Radius.circular(2.4)), stroke);
        canvas.drawLine(const Offset(4, 8), const Offset(4, 16), stroke);
        canvas.drawLine(const Offset(20, 8), const Offset(20, 16), stroke);
      case LineIcon.video:
        canvas.drawRRect(RRect.fromLTRBR(2.5, 6, 16.5, 18, const Radius.circular(3)), fill);
        canvas.drawPath(
          Path()
            ..moveTo(17.5, 10.5)
            ..lineTo(21.5, 7.5)
            ..lineTo(21.5, 16.5)
            ..lineTo(17.5, 13.5)
            ..close(),
          fill,
        );
      case LineIcon.contrast:
        canvas.drawCircle(const Offset(12, 12), 8.5, stroke);
        canvas.drawArc(const Rect.fromLTWH(3.5, 3.5, 17, 17), -math.pi / 2, math.pi, true, fill);
      case LineIcon.motion:
        for (final y in const [8.0, 12.0, 16.0]) {
          canvas.drawPath(
            Path()
              ..moveTo(3, y)
              ..cubicTo(7, y - 3, 9, y + 3, 13, y)
              ..cubicTo(17, y - 3, 19, y + 3, 21, y),
            stroke,
          );
        }
      case LineIcon.star:
        final p = Path();
        for (var k = 0; k < 10; k++) {
          final a = -math.pi / 2 + k * math.pi / 5;
          final r = k.isEven ? 10.0 : 4.4;
          final o = Offset(12 + math.cos(a) * r, 12.6 + math.sin(a) * r);
          k == 0 ? p.moveTo(o.dx, o.dy) : p.lineTo(o.dx, o.dy);
        }
        canvas.drawPath(p..close(), fill);
      case LineIcon.close:
        canvas.drawLine(const Offset(6, 6), const Offset(18, 18), stroke..strokeWidth = 2.6);
        canvas.drawLine(const Offset(18, 6), const Offset(6, 18), stroke);
    }
  }

  @override
  bool shouldRepaint(_LinePainter o) => o.icon != icon || o.color != color;
}

/// The leaf decoration from the canvas backgrounds.
class LeafDecor extends StatelessWidget {
  const LeafDecor({
    super.key,
    required this.size,
    required this.angle,
    this.from = const Color(0xFF9BD25A),
    this.to = const Color(0xFF3E9B3A),
  });
  final double size;
  final double angle;
  final Color from;
  final Color to;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: angle * math.pi / 180,
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _LeafPainter(from, to)),
    ),
  );
}

class _LeafPainter extends CustomPainter {
  _LeafPainter(this.a, this.b);
  final Color a;
  final Color b;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final p = Path()
      ..moveTo(12, 1.5)
      ..cubicTo(19.5, 6.5, 19.5, 16.5, 12, 22.5)
      ..cubicTo(4.5, 16.5, 4.5, 6.5, 12, 1.5)
      ..close();
    canvas.drawPath(
      p,
      Paint()
        ..shader = LinearGradient(
          colors: [a, b],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(const Rect.fromLTWH(0, 0, 24, 24)),
    );
    canvas.drawLine(
      const Offset(12, 3.5),
      const Offset(12, 21),
      Paint()
        ..color = const Color(0xBFE4F7C8)
        ..strokeWidth = .9,
    );
  }

  @override
  bool shouldRepaint(_LeafPainter o) => false;
}
