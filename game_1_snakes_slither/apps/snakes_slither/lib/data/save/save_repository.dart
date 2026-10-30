import 'dart:convert';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../core/logging/app_logger.dart';

/// Raw storage for the save JSON and its backup copy.
abstract class SaveStore {
  String? read();
  String? readBackup();
  Future<void> write(String raw);
  Future<void> writeBackup(String raw);
  Future<void> flush();
}

class HiveSaveStore implements SaveStore {
  HiveSaveStore._(this._box, this._backup);

  static const _key = 'save';
  final Box<String> _box;
  final Box<String> _backup;

  static Future<HiveSaveStore> open() async {
    await Hive.initFlutter('snakes_slither');
    return HiveSaveStore._(await Hive.openBox<String>('save'), await Hive.openBox<String>('save_backup'));
  }

  @override
  String? read() => _box.get(_key);
  @override
  String? readBackup() => _backup.get(_key);
  @override
  Future<void> write(String raw) => _box.put(_key, raw);
  @override
  Future<void> writeBackup(String raw) => _backup.put(_key, raw);
  @override
  Future<void> flush() => _box.flush();
}

class MemorySaveStore implements SaveStore {
  MemorySaveStore([this.raw]);
  String? raw;
  String? backupRaw;

  @override
  String? read() => raw;
  @override
  String? readBackup() => backupRaw;
  @override
  Future<void> write(String r) async => raw = r;
  @override
  Future<void> writeBackup(String r) async => backupRaw = r;
  @override
  Future<void> flush() async {}
}

/// Versioned save (schema v1). Each cubit owns one section (`progress`,
/// `wallet`, `streak`, …) and writes it through on every change. A backup copy
/// is taken after each level win so a corrupt save can be restored.
class SaveRepository {
  SaveRepository(this._store) : _data = _load(_store);

  static const int schemaVersion = 1;

  final SaveStore _store;
  final Map<String, Object?> _data;

  /// 'backup' or 'fresh' when the main save could not be read.
  String? get recoveredFrom => _data['_recovered'] as String?;

  bool get isFirstRun => !_data.containsKey('createdUtc');

  static Map<String, Object?> _load(SaveStore store) {
    final raw = store.read();
    var data = _decode(raw);
    if (data == null && raw != null) {
      log.e('E-SAVE-002', 'Save corrupt, restoring backup');
      data = _decode(store.readBackup());
      data = {...?data, '_recovered': data == null ? 'fresh' : 'backup'};
    }
    return _migrate(data ?? <String, Object?>{});
  }

  static Map<String, Object?>? _decode(String? raw) {
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as Map).cast<String, Object?>();
    } catch (_) {
      return null;
    }
  }

  static Map<String, Object?> _migrate(Map<String, Object?> data) {
    final v = (data['schemaVersion'] as int?) ?? schemaVersion;
    if (v > schemaVersion) log.w('E-SAVE-003', 'Save from a newer app version ($v)');
    // Later schema steps go here, e.g. `if (v < 2) data = _v1to2(data);`
    return {...data, 'schemaVersion': schemaVersion};
  }

  Map<String, Object?> section(String key) => ((_data[key] as Map?) ?? const {}).cast<String, Object?>();

  Future<void> write(String key, Map<String, Object?> value) async {
    _data[key] = value;
    _data['createdUtc'] ??= DateTime.now().toUtc().toIso8601String();
    _data.remove('_recovered');
    try {
      await _store.write(jsonEncode(_data));
    } catch (e, st) {
      log.e('E-SAVE-004', 'Save write failed', e, st);
    }
  }

  Future<void> backup() async {
    try {
      await _store.writeBackup(jsonEncode(_data));
    } catch (e, st) {
      log.e('E-SAVE-004', 'Backup write failed', e, st);
    }
  }

  Future<void> flush() => _store.flush();
}
