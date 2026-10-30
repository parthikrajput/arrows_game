import 'dart:convert';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Device-only save (no cloud in Phase 1). Each cubit owns one JSON section.
/// Stored as JSON strings so the schema can migrate without generated adapters.
class SaveStore {
  SaveStore._(this._box);
  final Box<String> _box;

  static const schemaVersion = 1;

  static Future<SaveStore> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>('save_v$schemaVersion');
    return SaveStore._(box);
  }

  /// Throwaway store in [dir] for tests.
  static Future<SaveStore> at(String dir) async {
    Hive.init(dir);
    final box = await Hive.openBox<String>('test_${DateTime.now().microsecondsSinceEpoch}');
    return SaveStore._(box);
  }

  Map<String, dynamic>? read(String section) {
    final raw = _box.get(section);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      // A corrupt section must not block launch; the cubit falls back to defaults.
      return null;
    }
  }

  Future<void> write(String section, Map<String, dynamic> value) =>
      _box.put(section, jsonEncode(value));
}
