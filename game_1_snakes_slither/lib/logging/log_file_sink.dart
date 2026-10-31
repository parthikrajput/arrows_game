import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'app_logger.dart';

/// Rotating local file sink writing JSONL to app_log_0.jsonl / app_log_1.jsonl.
class LogFileSink implements LogSink {
  LogFileSink({
    required this.directory,
    this.maxBytes = 512 * 1024, // 512 KB per file
    this.flushInterval = const Duration(seconds: 5),
  }) {
    _initFiles();
    _flushTimer = Timer.periodic(flushInterval, (_) => flush());
  }

  final Directory directory;
  final int maxBytes;
  final Duration flushInterval;

  Timer? _flushTimer;
  final List<String> _pendingBuffer = [];
  int _activeFileIndex = 0;
  IOSink? _currentSink;
  int _currentFileBytes = 0;

  void _initFiles() {
    try {
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final file0 = File('${directory.path}/app_log_0.jsonl');
      if (file0.existsSync() && file0.lengthSync() >= maxBytes) {
        _activeFileIndex = 1;
      }
      _openCurrentSink();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize LogFileSink: $e');
      }
    }
  }

  void _openCurrentSink() {
    try {
      final file = File('${directory.path}/app_log_$_activeFileIndex.jsonl');
      _currentFileBytes = file.existsSync() ? file.lengthSync() : 0;
      _currentSink = file.openWrite(mode: FileMode.append);
    } catch (_) {}
  }

  @override
  void write(LogEntry entry) {
    final line = entry.toString();
    _pendingBuffer.add(line);

    // Immediate flush for warnings, errors and fatal crashes
    if (entry.level.index >= LogLevel.warn.index) {
      flush();
    }
  }

  @override
  Future<void> flush() async {
    if (_pendingBuffer.isEmpty || _currentSink == null) return;

    final lines = List<String>.from(_pendingBuffer);
    _pendingBuffer.clear();

    try {
      for (final line in lines) {
        _currentSink?.writeln(line);
        _currentFileBytes += line.length + 1;

        if (_currentFileBytes >= maxBytes) {
          await _rotateFile();
        }
      }
      await _currentSink?.flush();
    } catch (_) {}
  }

  Future<void> _rotateFile() async {
    try {
      await _currentSink?.flush();
      await _currentSink?.close();

      _activeFileIndex = (_activeFileIndex == 0) ? 1 : 0;
      final nextFile = File('${directory.path}/app_log_$_activeFileIndex.jsonl');
      if (nextFile.existsSync()) {
        nextFile.deleteSync();
      }
      _currentFileBytes = 0;
      _currentSink = nextFile.openWrite(mode: FileMode.write);
    } catch (_) {}
  }

  Future<void> dispose() async {
    _flushTimer?.cancel();
    await flush();
    await _currentSink?.close();
  }
}
