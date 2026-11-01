import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_core/puzzle_core.dart' show LogCodes;

import '../../data/save_store.dart';
import '../../logging/app_logger.dart';

/// Device performance tier. Gameplay rules never change by tier; only
/// visuals scale.
enum DeviceTier { low, mid, high }

/// Visual budget for one tier.
class QualityProfile {
  const QualityProfile._(this.tier, this.maxParticles, this.shakeDp, this.ambient, this.idleAll, this.imageCacheMb);
  final DeviceTier tier;
  final int maxParticles;

  /// 0 = no shake (haptic + red flash only).
  final double shakeDp;
  final bool ambient;

  /// Idle breathing / blinking on every snake (else only the tapped one).
  final bool idleAll;
  final int imageCacheMb;

  static const low = QualityProfile._(DeviceTier.low, 30, 0, false, false, 48);
  static const mid = QualityProfile._(DeviceTier.mid, 80, 4, true, false, 96);
  static const high = QualityProfile._(DeviceTier.high, 150, 6, true, true, 160);

  static QualityProfile of(DeviceTier t) => switch (t) {
    DeviceTier.low => low,
    DeviceTier.mid => mid,
    DeviceTier.high => high,
  };

  /// Leaf burst size in the Jungle Dawn intro.
  int get introParticles => switch (tier) {
    DeviceTier.low => 12,
    DeviceTier.mid => 24,
    DeviceTier.high => 40,
  };
}

/// Startup values the Android host passes to Dart (`key=value` args).
class LaunchInfo {
  const LaunchInfo({this.tier, this.processStartEpochMs});
  final DeviceTier? tier;
  final int? processStartEpochMs;

  factory LaunchInfo.parse(List<String> args) {
    final m = {
      for (final a in args)
        if (a.contains('=')) a.substring(0, a.indexOf('=')): a.substring(a.indexOf('=') + 1),
    };
    return LaunchInfo(
      tier: DeviceTier.values.asNameMap()[m['tier']],
      processStartEpochMs: int.tryParse(m['processStartEpochMs'] ?? ''),
    );
  }

  static const channel = MethodChannel('snakes_slither/launch');

  /// Lets the system splash go and marks the app fully drawn.
  static Future<void> reportFirstFrame() async {
    try {
      await channel.invokeMethod<void>('firstFrame');
    } on MissingPluginException {
      // iOS and tests have no launch channel.
    } on PlatformException {
      // Same: nothing waits for it there.
    }
  }

  /// Cold start budget per tier (TTID alarm thresholds).
  static int alarmMs(DeviceTier t) => switch (t) {
    DeviceTier.low => 1500,
    DeviceTier.mid => 1000,
    DeviceTier.high => 800,
  };

  /// Logs W-PERF-004 when Home took too long to appear.
  void checkColdStart(DeviceTier t) {
    final start = processStartEpochMs;
    if (start == null) return;
    final ttid = DateTime.now().millisecondsSinceEpoch - start;
    AppLogger.instance.info('perf', 'P-TTID', 'cold start', {'ms': ttid, 'tier': t.name});
    if (ttid > alarmMs(t)) {
      AppLogger.instance.warn('perf', LogCodes.perfSlowColdStart, 'slow cold start', {'ms': ttid, 'tier': t.name});
    }
  }
}

/// Saved tier, runtime demotion and the Battery Saver override.
class PerfSettings {
  PerfSettings(this._store, {DeviceTier? detected}) {
    final j = _store.read(_key) ?? const {};
    _tier = DeviceTier.values.asNameMap()[j['tier']] ?? detected ?? DeviceTier.mid;
    _jankyLevels = j['jankyLevels'] as int? ?? 0;
    if (j['tier'] == null) _save();
  }

  static const _key = 'perf';

  /// Levels with > 5% janky frames before the tier drops one step.
  static const demoteAfter = 3;
  static const jankLimit = .05;

  final SaveStore _store;
  late DeviceTier _tier;
  int _jankyLevels = 0;

  DeviceTier get tier => _tier;

  QualityProfile profile({required bool batterySaver}) =>
      batterySaver ? QualityProfile.low : QualityProfile.of(_tier);

  /// Called with each finished level's frame report.
  void levelFinished(FrameReport r) {
    if (r.frames < 30) return;
    if (r.jankRatio > jankLimit) {
      AppLogger.instance.warn('perf', LogCodes.perfFrameJank, 'janky level', {
        'tier': _tier.name,
        'jank': r.jankRatio,
        'p95RasterUs': r.p95RasterUs,
      });
      _jankyLevels++;
      if (_jankyLevels >= demoteAfter && _tier != DeviceTier.low) {
        _tier = DeviceTier.values[_tier.index - 1];
        _jankyLevels = 0;
        AppLogger.instance.warn('perf', LogCodes.perfFrameJank, 'tier_demoted', {'tier': _tier.name});
      }
      _save();
    }
  }

  void _save() => _store.write(_key, {'tier': _tier.name, 'jankyLevels': _jankyLevels});
}

class FrameReport {
  const FrameReport({required this.frames, required this.janky, required this.p95RasterUs});
  final int frames;
  final int janky;
  final int p95RasterUs;
  double get jankRatio => frames == 0 ? 0 : janky / frames;
}

/// Watches frame timings during gameplay. A frame is janky when build or
/// raster takes longer than the display's frame budget.
class FrameMonitor {
  FrameMonitor({this.budgetUs = 16667});

  /// 16.7 ms at 60 Hz, 8.3 ms at 120 Hz.
  final int budgetUs;
  final _raster = <int>[];
  int _frames = 0, _janky = 0;
  bool _on = false;

  void start() {
    if (_on) return;
    _on = true;
    _frames = _janky = 0;
    _raster.clear();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      _frames++;
      final r = t.rasterDuration.inMicroseconds, b = t.buildDuration.inMicroseconds;
      _raster.add(r);
      if (r > budgetUs || b > budgetUs) _janky++;
    }
  }

  FrameReport stop() {
    if (_on) SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _on = false;
    final sorted = [..._raster]..sort();
    final p95 = sorted.isEmpty ? 0 : sorted[math.min(sorted.length - 1, (sorted.length * .95).floor())];
    return FrameReport(frames: _frames, janky: _janky, p95RasterUs: p95);
  }

  /// Feeds timings directly (tests).
  void addForTest(List<FrameTiming> t) => _onTimings(t);
}
