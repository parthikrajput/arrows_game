import 'u32.dart';

/// xoshiro128** PRNG. Same seed gives the same sequence on every platform
/// (Dart's `Random` does not promise that).
class Xoshiro128ss {
  Xoshiro128ss(int seed) {
    // SplitMix32-style expansion so close seeds still diverge.
    var x = seed & mask32;
    int next() {
      x = (x + 0x9E3779B9) & mask32;
      var z = x;
      z = mul32(z ^ (z >> 16), 0x85EBCA6B);
      z = mul32(z ^ (z >> 13), 0xC2B2AE35);
      return (z ^ (z >> 16)) & mask32;
    }

    _s0 = next();
    _s1 = next();
    _s2 = next();
    _s3 = next();
    if ((_s0 | _s1 | _s2 | _s3) == 0) _s0 = 1;
  }

  late int _s0;
  late int _s1;
  late int _s2;
  late int _s3;

  static int _rotl(int x, int k) => ((x << k) | (x >> (32 - k))) & mask32;

  /// Next unsigned 32-bit value.
  int nextUint32() {
    final result = mul32(_rotl(mul32(_s1, 5), 7), 9);
    final t = (_s1 << 9) & mask32;
    _s2 ^= _s0;
    _s3 ^= _s1;
    _s1 ^= _s2;
    _s0 ^= _s3;
    _s2 ^= t;
    _s3 = _rotl(_s3, 11);
    return result;
  }

  /// Uniform in [0, max).
  int nextInt(int max) {
    if (max <= 0) throw ArgumentError.value(max, 'max');
    return nextUint32() % max;
  }

  /// Uniform in [0, 1).
  double nextDouble() => nextUint32() / 4294967296.0;

  bool nextBool([double p = 0.5]) => nextDouble() < p;

  T pick<T>(List<T> items) => items[nextInt(items.length)];

  void shuffle<T>(List<T> items) {
    for (var i = items.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final t = items[i];
      items[i] = items[j];
      items[j] = t;
    }
  }
}
