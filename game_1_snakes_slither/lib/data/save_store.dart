import 'dart:convert';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:puzzle_core/puzzle_core.dart' show LogCodes;

import '../logging/app_logger.dart';

/// Device-only save (no cloud in Phase 1). Each cubit owns one JSON section.
/// Stored as JSON strings so the schema can migrate without generated adapters.
/// A mirror box is written after every level win; a section that can't be
/// read falls back to that copy.
class SaveStore {
  SaveStore._(this._box, this._backup);
  final Box<String> _box;
  final Box<String>? _backup;

  static const schemaVersion = 1;

  /// A section was rebuilt from the backup during this launch (the UI tells
  /// the player once the intro is over).
  bool restoredFromBackup = false;

  static Future<SaveStore> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>('save_v$schemaVersion');
    final backup = await Hive.openBox<String>('save_backup_v$schemaVersion');
    return SaveStore._(box, backup)..migrate();
  }

  /// Throwaway store in [dir] for tests.
  static Future<SaveStore> at(String dir) async {
    Hive.init(dir);
    final id = DateTime.now().microsecondsSinceEpoch;
    final box = await Hive.openBox<String>('test_$id');
    final backup = await Hive.openBox<String>('test_backup_$id');
    return SaveStore._(box, backup);
  }

  /// Schema migrations run in order on open. v1 is the first schema, so
  /// there is nothing to move yet; the stored version is recorded for later.
  void migrate() {
    final v = int.tryParse(_box.get('_schema') ?? '') ?? 0;
    if (v < schemaVersion) _box.put('_schema', '$schemaVersion');
  }

  Map<String, dynamic>? read(String section) {
    final raw = _box.get(section);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      // A corrupt section must not block launch: use the last good copy, or
      // let the cubit fall back to defaults.
      final copy = _backup?.get(section);
      if (copy != null) {
        try {
          final j = jsonDecode(copy) as Map<String, dynamic>;
          _box.put(section, copy);
          restoredFromBackup = true;
          AppLogger.instance.warn('save', LogCodes.saveCorruptRestored, 'restored $section from backup');
          return j;
        } catch (_) {}
      }
      AppLogger.instance.error('save', LogCodes.saveCorruptRestored, '$section unreadable, using defaults');
      return null;
    }
  }

  Future<void> write(String section, Map<String, dynamic> value) async {
    try {
      await _box.put(section, jsonEncode(value));
    } catch (e) {
      AppLogger.instance.error('save', LogCodes.saveDiskWriteFailure, 'write $section failed', {'error': '$e'});
    }
  }

  /// Mirrors every section into the backup box (after each level win).
  Future<void> backup() async {
    final b = _backup;
    if (b == null) return;
    await b.putAll({for (final k in _box.keys) '$k': _box.get(k)!});
  }

  /// Forces pending writes to disk (app going to the background).
  Future<void> flush() async {
    await _box.flush();
    await _backup?.flush();
  }

  /// Test hook: break a section on purpose.
  Future<void> corruptForTest(String section) => _box.put(section, '{not json');
}
