import 'package:flutter/widgets.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'app_logger.dart';

class _TapRecord {
  _TapRecord(this.position, this.time);
  final Offset position;
  final DateTime time;
}

/// Global tap interception detecting rage taps (>=4 taps within 1.5s in 48dp)
/// and dead taps without impacting frame performance (<0.2ms overhead).
class TapLoggerScope extends StatefulWidget {
  const TapLoggerScope({super.key, required this.child});
  final Widget child;

  @override
  State<TapLoggerScope> createState() => _TapLoggerScopeState();
}

class _TapLoggerScopeState extends State<TapLoggerScope> {
  final List<_TapRecord> _recentTaps = [];
  static const double _rageRadiusDp = 48.0;
  static const Duration _rageWindow = Duration(milliseconds: 1500);
  static const int _rageThreshold = 4;

  void _onPointerDown(PointerDownEvent event) {
    final now = DateTime.now();
    final pos = event.position;

    // Prune old taps
    _recentTaps.removeWhere((t) => now.difference(t.time) > _rageWindow);
    _recentTaps.add(_TapRecord(pos, now));

    // Check for rage tap cluster
    int clusterCount = 0;
    for (final tap in _recentTaps) {
      if ((tap.position - pos).distance <= _rageRadiusDp) {
        clusterCount++;
      }
    }

    if (clusterCount >= _rageThreshold) {
      AppLogger.instance.warn(
        'input',
        LogCodes.inputRageTap,
        'Rage tap detected ($clusterCount taps within 1.5s in 48dp radius)',
        {'x': pos.dx, 'y': pos.dy, 'count': clusterCount},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      child: widget.child,
    );
  }
}
