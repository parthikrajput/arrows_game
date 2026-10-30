import '../data/save/save_repository.dart';

/// Local day keys and the clock-tamper ("time-travel") lock.
class TimeService {
  TimeService(this._save, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now {
    final t = _save.section('time');
    _lastTrustedUtc = DateTime.tryParse((t['lastTrustedUtc'] as String?) ?? '');
  }

  final SaveRepository _save;
  final DateTime Function() _clock;
  DateTime? _lastTrustedUtc;

  DateTime now() => _clock();

  /// Device local date `YYYY-MM-DD` (local midnight reset).
  String dayKey([DateTime? at]) {
    final d = at ?? now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  /// Days between two day keys (calendar days, not 24 h blocks).
  static int daysBetween(String from, String to) {
    final a = DateTime.parse(from);
    final b = DateTime.parse(to);
    return DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
  }

  Duration untilMidnight() {
    final n = now();
    return DateTime(n.year, n.month, n.day + 1).difference(n);
  }

  /// Clock more than 2 h behind the latest trusted time ⇒ Daily, Streak and Spin are locked.
  bool get timeTravelLocked {
    final trusted = _lastTrustedUtc;
    if (trusted == null) return false;
    return now().toUtc().isBefore(trusted.subtract(const Duration(hours: 2)));
  }

  /// Advances the trusted time; called on app start and after every claim.
  /// A server `Date` header plugs in here once online verification is wired.
  Future<void> touch() async {
    final n = now().toUtc();
    final prev = _lastTrustedUtc;
    if (prev == null || n.isAfter(prev)) {
      _lastTrustedUtc = n;
      await _save.write('time', {'lastTrustedUtc': n.toIso8601String()});
    }
  }
}
