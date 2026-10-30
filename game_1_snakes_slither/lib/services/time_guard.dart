import 'dart:math';

import '../data/save_store.dart';

abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}

/// Day keys and the time-travel lock for daily rewards (wheel, Daily, streak).
/// Server time is added with the backend later; for now the trusted time is
/// the latest device time ever seen.
class TimeGuard {
  TimeGuard(this._store, this.clock) {
    final j = _store.read(_key) ?? const {};
    _lastTrustedUtc = DateTime.tryParse(j['lastTrustedUtc'] as String? ?? '')?.toUtc();
    installId = j['installId'] as String? ?? _newInstallId();
    observe();
  }

  static const _key = 'time';

  /// Clocks may drift; only a jump back of more than this locks rewards.
  static const tolerance = Duration(hours: 2);

  final SaveStore _store;
  final Clock clock;
  DateTime? _lastTrustedUtc;

  /// Random, per install. Seeds the wheel so results can't be shared.
  late final String installId;

  /// Local date YYYY-MM-DD; rolls over at local midnight.
  String dayKey() {
    final n = clock.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${n.year}-${two(n.month)}-${two(n.day)}';
  }

  bool get isTimeTravel {
    final t = _lastTrustedUtc;
    return t != null && clock.now().toUtc().isBefore(t.subtract(tolerance));
  }

  /// Call on app start and before each reward claim.
  void observe() {
    final now = clock.now().toUtc();
    if (_lastTrustedUtc == null || now.isAfter(_lastTrustedUtc!)) _lastTrustedUtc = now;
    _store.write(_key, {
      'lastTrustedUtc': _lastTrustedUtc!.toIso8601String(),
      'installId': installId,
    });
  }

  static String _newInstallId() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }
}
