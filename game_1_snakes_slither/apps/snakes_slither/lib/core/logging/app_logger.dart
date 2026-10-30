import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warn, error }

class LogEntry {
  LogEntry(this.time, this.level, this.message, {this.code});
  final DateTime time;
  final LogLevel level;
  final String message;
  final String? code;

  @override
  String toString() => '${time.toIso8601String()} ${level.name.toUpperCase()} ${code ?? ''} $message';
}

/// Ring-buffer logger. Crashlytics breadcrumbs / non-fatals attach here once
/// Firebase is configured; until then everything stays on the device.
class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  static const int _capacity = 300;
  final Queue<LogEntry> _ring = Queue();

  /// Settings → Share diagnostics. Off keeps logs local only.
  bool shareDiagnostics = true;

  List<LogEntry> get entries => List.unmodifiable(_ring);

  void _add(LogEntry e) {
    if (_ring.length >= _capacity) _ring.removeFirst();
    _ring.add(e);
    if (kDebugMode) debugPrint(e.toString());
  }

  void d(String msg) => _add(LogEntry(DateTime.now(), LogLevel.debug, msg));
  void i(String msg) => _add(LogEntry(DateTime.now(), LogLevel.info, msg));
  void w(String code, String msg) => _add(LogEntry(DateTime.now(), LogLevel.warn, msg, code: code));
  void e(String code, String msg, [Object? error, StackTrace? st]) =>
      _add(LogEntry(DateTime.now(), LogLevel.error, '$msg${error == null ? '' : ' · $error'}', code: code));

  /// Records a tap for the tap trace (`board:cell(3,4)`, `btn:shop.buy.hint3`).
  void tap(String id) => d('tap $id');

  /// "Report a problem": keeps the report locally and returns its Report ID.
  String submitBugReport({required String category, String? text}) {
    final id = 'BR-${(math.Random().nextInt(900000) + 100000)}';
    i('bug_report $id category=$category text=${text ?? '-'} logs=${_ring.length}');
    return id;
  }
}

final log = AppLogger.instance;
