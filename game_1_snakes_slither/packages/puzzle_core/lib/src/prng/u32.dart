const int mask32 = 0xFFFFFFFF;

/// Exact `(a * b) mod 2^32`. A plain `a * b` can pass 2^53 and lose bits on the
/// web, which would make seeded boards differ between platforms.
int mul32(int a, int b) {
  final lo = (a & 0xFFFF) * b;
  final hi = (((a >> 16) & 0xFFFF) * b) & 0xFFFF;
  return (lo + hi * 65536) & mask32;
}
