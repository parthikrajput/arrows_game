/// xoshiro128** with 32-bit math. Dart's Random gives no cross-version
/// guarantee, and the wheel and Daily puzzle must match on every device and
/// app version, so the generator is pinned here.
class Xoshiro128 {
  Xoshiro128._(this._s);

  /// Seeds the 4 state words from one 32-bit seed via SplitMix32.
  factory Xoshiro128(int seed) {
    var x = seed & _m;
    int next() {
      x = (x + 0x9E3779B9) & _m;
      var z = x;
      z = _mul(z ^ (z >>> 16), 0x85EBCA6B);
      z = _mul(z ^ (z >>> 13), 0xC2B2AE35);
      return (z ^ (z >>> 16)) & _m;
    }

    final s = [next(), next(), next(), next()];
    if (s.every((w) => w == 0)) s[0] = 1; // all-zero state never moves
    return Xoshiro128._(s);
  }

  static const _m = 0xFFFFFFFF;
  final List<int> _s;

  static int _mul(int a, int b) {
    // Exact low 32 bits of a*b without overflowing 53-bit doubles on the web.
    final lo = (a & 0xFFFF) * b;
    final hi = ((a >>> 16) * b) & 0xFFFF;
    return (lo + (hi << 16)) & _m;
  }

  static int _rotl(int x, int k) => ((x << k) | (x >>> (32 - k))) & _m;

  /// Next unsigned 32-bit value.
  int nextUint32() {
    final s = _s;
    final result = _mul(_rotl(_mul(s[1], 5), 7), 9);
    final t = (s[1] << 9) & _m;
    s[2] ^= s[0];
    s[3] ^= s[1];
    s[1] ^= s[2];
    s[0] ^= s[3];
    s[2] ^= t;
    s[3] = _rotl(s[3], 11);
    return result;
  }

  /// Uniform double in [0, 1).
  double nextDouble() => nextUint32() / 4294967296.0;

  /// Uniform int in [0, max).
  int nextInt(int max) => (nextDouble() * max).floor();
}

/// FNV-1a 32-bit hash of the parts joined with '|'. Stable across platforms.
int stableHash(List<Object> parts) {
  var h = 0x811C9DC5;
  for (final unit in parts.join('|').codeUnits) {
    h ^= unit & 0xFF;
    h = Xoshiro128._mul(h, 0x01000193);
    h ^= unit >>> 8;
    h = Xoshiro128._mul(h, 0x01000193);
  }
  return h;
}
