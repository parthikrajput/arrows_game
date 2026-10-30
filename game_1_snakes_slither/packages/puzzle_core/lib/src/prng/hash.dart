import 'dart:convert';

import 'u32.dart';

/// 32-bit FNV-1a.
int fnv1a32(String input, [int basis = 0x811C9DC5]) {
  var h = basis;
  for (final b in utf8.encode(input)) {
    h = mul32(h ^ b, 0x01000193);
  }
  return h;
}

/// Two independent FNV-1a lanes, kept as a pair so the value is identical on
/// the web (no 64-bit ints) and on native.
class Hash64 {
  const Hash64(this.hi, this.lo);

  final int hi;
  final int lo;

  factory Hash64.of(List<String> parts) {
    final s = parts.join('\u001F');
    return Hash64(fnv1a32(s), fnv1a32(s, 0x050C5D1F));
  }

  /// 32-bit seed for [Xoshiro128ss], offset by a retry attempt [k].
  int seed([int k = 0]) => (hi ^ ((lo + k * 0x9E3779B9) & 0xFFFFFFFF)) & 0xFFFFFFFF;
}
