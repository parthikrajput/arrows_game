import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snakes_slither/ui/board/vfx.dart';

void main() {
  test('the pool never exceeds its tier cap', () {
    for (final cap in [30, 80, 150]) {
      final p = ParticlePool(cap);
      for (var i = 0; i < 40; i++) {
        p.burst(Offset.zero, 14, const [Colors.white]);
      }
      expect(p.live, cap);
    }
  });

  test('particles expire, so a still board ends with nothing to draw', () {
    final p = ParticlePool(30)..burst(Offset.zero, 10, const [Colors.white], life: .4);
    expect(p.live, 10);
    for (var i = 0; i < 40; i++) {
      p.step(1 / 60);
    }
    expect(p.live, 0);
  });

  test('a zero cap (Reduce Motion) plays nothing', () {
    final c = VfxController(cap: 0, shakeDp: 0);
    var notified = 0;
    c.addListener(() => notified++);
    c.play(VfxKind.exitSparkle, Offset.zero);
    c.shake();
    expect(notified, 0);
  });
}
