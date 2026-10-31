import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';

enum LogLevel {
  trace,
  debug,
  info,
  warn,
  error,
  fatal,
}

class LogEntry {
  LogEntry({
    required this.level,
    required this.category,
    required this.code,
    required this.message,
    DateTime? timestamp,
    this.data,
  }) : timestamp = timestamp ?? DateTime.now();

  final DateTime timestamp;
  final LogLevel level;
  final String category;
  final String code;
  final String message;
  final Map<String, dynamic>? data;

  Map<String, dynamic> toJson() => {
        'ts': timestamp.toIso8601String(),
        'lvl': level.name,
        'cat': category,
        'code': code,
        'msg': message,
        if (data != null && data!.isNotEmpty) 'data': data,
      };

  @override
  String toString() => jsonEncode(toJson());
}

abstract class LogSink {
  void write(LogEntry entry);
  Future<void> flush();
}

/// Structured logger with in-memory ring buffer (capacity 300) and pluggable file sink.
class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  static const int _ringBufferCapacity = 300;
  final DoubleLinkedQueue<LogEntry> _ringBuffer = DoubleLinkedQueue<LogEntry>();
  LogSink? _sink;
  LogLevel minLevel = kReleaseMode ? LogLevel.info : LogLevel.debug;

  void attachSink(LogSink sink) {
    _sink = sink;
  }

  void log({
    required LogLevel level,
    required String category,
    required String code,
    required String message,
    Map<String, dynamic>? data,
  }) {
    if (level.index < minLevel.index) return;

    final entry = LogEntry(
      level: level,
      category: category,
      code: code,
      message: message,
      data: data,
    );

    // Maintain in-memory ring buffer
    _ringBuffer.addLast(entry);
    if (_ringBuffer.length > _ringBufferCapacity) {
      _ringBuffer.removeFirst();
    }

    if (kDebugMode) {
      debugPrint('[${entry.level.name.toUpperCase()}][${entry.code}] ${entry.message}');
    }

    _sink?.write(entry);
  }

  void trace(String category, String code, String message, [Map<String, dynamic>? data]) {
    log(level: LogLevel.trace, category: category, code: code, message: message, data: data);
  }

  void debug(String category, String code, String message, [Map<String, dynamic>? data]) {
    log(level: LogLevel.debug, category: category, code: code, message: message, data: data);
  }

  void info(String category, String code, String message, [Map<String, dynamic>? data]) {
    log(level: LogLevel.info, category: category, code: code, message: message, data: data);
  }

  void warn(String category, String code, String message, [Map<String, dynamic>? data]) {
    log(level: LogLevel.warn, category: category, code: code, message: message, data: data);
  }

  void error(String category, String code, String message, [Map<String, dynamic>? data]) {
    log(level: LogLevel.error, category: category, code: code, message: message, data: data);
  }

  void fatal(String category, String code, String message, [Map<String, dynamic>? data]) {
    log(level: LogLevel.fatal, category: category, code: code, message: message, data: data);
  }

  List<LogEntry> getRecentLogs([int count = 50]) {
    final list = _ringBuffer.toList();
    if (list.length <= count) return list;
    return list.sublist(list.length - count);
  }

  void clear() {
    _ringBuffer.clear();
  }
}
