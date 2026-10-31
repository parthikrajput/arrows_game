// OWNER: UI agent. Canvas: LevelMap.dc.html (+ the level card at the bottom).
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

String biomeFor(int level) => switch (level) {
  <= 10 => "Pip's Backyard",
  <= 100 => 'Garden Meadow',
  <= 200 => 'Bamboo Grove',
  <= 300 => 'Mango Orchard',
  <= 400 => 'Misty Swamp',
  _ => 'Moonlit Jungle',
};

const _rowH = 96.0;

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key, required this.nodes, required this.onLevelTap, required this.onBack});

  /// Level 1 first.
  final List<LevelNodeData> nodes;

  /// Only called for unlocked nodes.
  final void Function(int level) onLevelTap;
  final VoidCallback onBack;

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  late final ScrollController _scroll;
  int? _selected;

  int get _currentIndex {
    final i = widget.nodes.indexWhere((n) => n.state == NodeState.current);
    return i >= 0 ? i : math.max(0, widget.nodes.length - 1);
  }

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController(initialScrollOffset: math.max(0, (_currentIndex - 2) * _rowH));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodes = widget.nodes;
    final stars = nodes.fold<int>(0, (a, n) => a + n.stars);
    final focus = nodes.isEmpty ? null : nodes[(_selected ?? _currentIndex).clamp(0, nodes.length - 1)];
    return Scaffold(
      key: AppKeys.mapScreen,
      backgroundColor: AppColors.grass,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_bg.jpg',
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeatY,
              excludeFromSemantics: true,
            ),
          ),
          Positioned.fill(
            child: CenteredColumn(
              child: ListView.builder(
                controller: _scroll,
                reverse: true,
                padding: const EdgeInsets.only(top: 140, bottom: 230),
                itemCount: nodes.length,
                itemExtent: _rowH,
                itemBuilder: (_, i) => _MapRow(
                  index: i,
                  node: nodes[i],
                  last: i == nodes.length - 1,
                  selected: focus?.number == nodes[i].number,
                  onTap: nodes[i].state == NodeState.locked ? null : () => setState(() => _selected = i),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 140,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x8C042816), Color(0x00042816)],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: CenteredColumn(
              child: SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      RoundButton(
                        size: 40,
                        label: 'Back',
                        onTap: widget.onBack,
                        child: const LineIconView(LineIcon.back, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          focus == null ? 'Level Map' : biomeFor(focus.number),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.fredoka(22, color: Colors.white).copyWith(
                            shadows: const [Shadow(color: Color(0x59000000), offset: Offset(0, 2), blurRadius: 6)],
                          ),
                        ),
                      ),
                      Container(
                        height: 36,
                        padding: const EdgeInsets.only(left: 7, right: 10),
                        decoration: BoxDecoration(
                          color: const Color(0x8C04341E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0x2EFFFFFF)),
                        ),
                        child: Row(
                          children: [
                            const ArtIcon(Art.star, size: 20),
                            const SizedBox(width: 6),
                            Text('$stars', style: AppText.fredoka(16, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (focus != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 14),
                child: CenteredColumn(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _LevelCard(node: focus, onPlay: () => widget.onLevelTap(focus.number)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Node x position along the winding path, as a fraction of the width.
double _xAt(double i) => .5 + .2 * math.sin(i * 1.15);

class _MapRow extends StatelessWidget {
  const _MapRow({
    required this.index,
    required this.node,
    required this.last,
    required this.selected,
    required this.onTap,
  });
  final int index;
  final LevelNodeData node;
  final bool last;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, box) {
      final w = box.maxWidth;
      final cx = _xAt(index.toDouble()) * w;
      final current = node.state == NodeState.current;
      final r = current
          ? 27.0
          : node.state == NodeState.cleared
          ? 22.0
          : 20.0;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: CustomPaint(painter: _PathPainter(index, last, node.state != NodeState.locked))),
          Positioned(
            left: cx - 40,
            top: _rowH / 2 - 40,
            width: 80,
            height: 80,
            child: Pressable(
              key: AppKeys.mapNode(node.number),
              onTap: onTap,
              semanticLabel:
                  'Level ${node.number}${node.isHard ? ', hard' : ''}, ${switch (node.state) {
                    NodeState.locked => 'locked',
                    NodeState.current => 'current',
                    NodeState.cleared => '${node.stars} stars',
                  }}',
              child: CustomPaint(painter: _NodePainter(node, r, selected)),
            ),
          ),
          if (current)
            Positioned(
              left: cx - 14,
              top: _rowH / 2 - r - 40,
              child: const Bob(period: Duration(milliseconds: 1400), distance: 8, child: _Pin()),
            ),
          if (node.number % 10 == 0 && node.state != NodeState.cleared)
            Positioned(
              left: cx + (cx > w / 2 ? -r - 44 : r + 10),
              top: _rowH / 2 - 18,
              child: const ArtIcon(Art.gift, size: 34),
            ),
        ],
      );
    },
  );
}

class _PathPainter extends CustomPainter {
  _PathPainter(this.i, this.last, this.reached);
  final int i;
  final bool last;
  final bool reached;

  @override
  void paint(Canvas canvas, Size size) {
    // Row i's node sits at the centre; the list is reversed, so the next level is above.
    final path = Path();
    final from = i == 0 ? 0.0 : -0.5;
    final to = last ? 0.0 : 0.5;
    var first = true;
    for (var t = from; t <= to + 1e-6; t += .05) {
      final p = Offset(_xAt(i + t) * size.width, size.height / 2 - t * size.height);
      if (first) {
        path.moveTo(p.dx, p.dy);
        first = false;
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    Paint s(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.butt;
    canvas.drawPath(path, s(const Color(0x593E5F22), 44)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    canvas.drawPath(path, s(const Color(0xFFB8915A), 34));
    canvas.drawPath(path, s(const Color(0xFFD9BC85), 26));
    for (final m in path.computeMetrics()) {
      for (var d = 4.0; d < m.length; d += 20) {
        final p = m.getTangentForOffset(d)!.position;
        canvas.drawCircle(
          p,
          reached ? 2.6 : 2,
          Paint()..color = reached ? const Color(0xE6F4B72F) : const Color(0xE6E9D3A2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_PathPainter o) => o.i != i || o.last != last || o.reached != reached;
}

class _NodePainter extends CustomPainter {
  _NodePainter(this.n, this.r, this.selected);
  final LevelNodeData n;
  final double r;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final (Color lip, List<Color> grad, Color text) = switch (n.state) {
      NodeState.cleared => (
        const Color(0xFFB97A08),
        const [Color(0xFFFFF2A8), Color(0xFFF9C93A), Color(0xFFD98E10)],
        const Color(0xFF7A4A00),
      ),
      NodeState.current => (
        AppColors.lip,
        const [Color(0xFF4FD08A), AppColors.emerald, AppColors.forest],
        Colors.white,
      ),
      NodeState.locked => (
        const Color(0xFF6E746C),
        const [Color(0xFFF4F2EA), Color(0xFFC9C8BE), Color(0xFF9DA197)],
        const Color(0xFF4E554E),
      ),
    };
    if (selected && n.state != NodeState.current) {
      canvas.drawCircle(c, r + 8, Paint()..color = const Color(0x73A8D94F));
    }
    canvas.drawOval(
      Rect.fromCenter(center: c + Offset(0, r * .5), width: r * 2.2, height: r * .7),
      Paint()..color = const Color(0x40000000),
    );
    canvas.drawCircle(
      c + const Offset(0, 4),
      r,
      Paint()..color = n.isHard && n.state != NodeState.current ? const Color(0xFF8E1B16) : lip,
    );
    final rect = Rect.fromCircle(center: c, radius: r);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.24, -.4),
          radius: .8,
          colors: grad,
          stops: const [0, .5, 1],
        ).createShader(rect),
    );
    if (n.isHard) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = AppColors.hardRed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    } else if (n.state == NodeState.current) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    } else if (n.state == NodeState.cleared) {
      canvas.drawCircle(
        c,
        r - 6,
        Paint()
          ..color = const Color(0xCCFFF3B8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    final tp = TextPainter(
      text: TextSpan(
        text: '${n.number}',
        style: AppText.fredoka(n.number > 99 ? r * .62 : r * .86, weight: 700, color: text),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    if (n.state == NodeState.cleared) {
      for (var k = 0; k < 3; k++) {
        _star(canvas, c + Offset((k - 1) * 16.0, -r - 9 + (k == 1 ? -3 : 0)), k < n.stars);
      }
    }
    if (n.isHard) {
      final label = TextPainter(
        text: TextSpan(
          text: 'HARD',
          style: AppText.nunito(9, color: Colors.white, spacing: .5),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final b = Rect.fromCenter(center: c + Offset(0, r + 4), width: label.width + 10, height: 14);
      canvas.drawRRect(RRect.fromRectAndRadius(b, const Radius.circular(7)), Paint()..color = AppColors.hardRed);
      label.paint(canvas, b.center - Offset(label.width / 2, label.height / 2));
    }
  }

  void _star(Canvas canvas, Offset c, bool on) {
    final p = Path();
    for (var k = 0; k < 10; k++) {
      final a = -math.pi / 2 + k * math.pi / 5;
      final rr = k.isEven ? 6.5 : 3.0;
      final o = c + Offset(math.cos(a) * rr, math.sin(a) * rr);
      k == 0 ? p.moveTo(o.dx, o.dy) : p.lineTo(o.dx, o.dy);
    }
    p.close();
    canvas.drawPath(p, Paint()..color = on ? const Color(0xFFFFD84A) : const Color(0xFFD8D2BE));
    canvas.drawPath(
      p,
      Paint()
        ..color = const Color(0xFFB97A08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = .9
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_NodePainter o) => o.n != n || o.selected != selected;
}

class _Pin extends StatelessWidget {
  const _Pin();
  @override
  Widget build(BuildContext context) => SizedBox(width: 28, height: 34, child: CustomPaint(painter: _PinPainter()));
}

class _PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(14, 17);
    final p = Path()
      ..moveTo(0, 14)
      ..cubicTo(-14, 0, -14, -16, 0, -16)
      ..cubicTo(14, -16, 14, 0, 0, 14)
      ..close();
    canvas.drawPath(p, Paint()..color = AppColors.red);
    canvas.drawPath(
      p,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(const Offset(0, -4), 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PinPainter o) => false;
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.node, required this.onPlay});
  final LevelNodeData node;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final best = node.state == NodeState.cleared ? 'best ${node.stars} of 3 stars' : 'new level';
    return CreamCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${node.number}', style: AppText.fredoka(24, weight: 700)),
                    const SizedBox(height: 2),
                    Text(
                      '${biomeFor(node.number)} · $best',
                      style: AppText.nunito(14, weight: 700, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (node.isHard)
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.hardRed, borderRadius: BorderRadius.circular(15)),
                  child: Text('HARD', style: AppText.nunito(13, color: Colors.white, spacing: .5)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text('3 hearts · no timer · tap snakes out', style: AppText.nunito(13, color: AppColors.muted)),
          const SizedBox(height: 14),
          GameButton(label: node.state == NodeState.cleared ? 'Replay' : 'Play', onTap: onPlay, fontSize: 22),
        ],
      ),
    );
  }
}
