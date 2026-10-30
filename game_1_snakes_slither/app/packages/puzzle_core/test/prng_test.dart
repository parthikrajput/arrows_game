import 'package:puzzle_core/puzzle_core.dart';
import 'package:test/test.dart';

void main() {
  test('same seed gives the same sequence', () {
    final a = Xoshiro128(42), b = Xoshiro128(42);
    for (var i = 0; i < 100; i++) {
      expect(a.nextUint32(), b.nextUint32());
    }
  });

  test('pinned values never change (devices must agree)', () {
    final r = Xoshiro128(stableHash(['install-1', '2026-10-30', 0]));
    final first = [for (var i = 0; i < 3; i++) r.nextUint32()];
    // If this fails, every player's wheel and Daily results would change.
    expect(first, _pinned);
  });

  test('outputs are 32-bit and roughly uniform', () {
    final r = Xoshiro128(7);
    final buckets = List.filled(10, 0);
    for (var i = 0; i < 100000; i++) {
      final v = r.nextUint32();
      expect(v, inInclusiveRange(0, 0xFFFFFFFF));
      buckets[(v / 4294967296.0 * 10).floor()]++;
    }
    for (final c in buckets) {
      expect(c, inInclusiveRange(9500, 10500));
    }
  });

  test('stableHash differs by input and is stable', () {
    expect(stableHash(['a', 1]), stableHash(['a', 1]));
    expect(stableHash(['a', 1]), isNot(stableHash(['a', 2])));
  });
}

// Checked identical on native and web (dart2js) builds.
const _pinned = <int>[1139476878, 3243555370, 4131933564];
