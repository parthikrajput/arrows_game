import 'package:flutter_bloc/flutter_bloc.dart';

import '../contracts/view_models.dart';
import '../data/save_store.dart';

class SettingsCubit extends Cubit<SettingsData> {
  SettingsCubit(this._store) : super(_load(_store));

  static const _key = 'settings';
  final SaveStore _store;

  static SettingsData _load(SaveStore s) {
    final j = s.read(_key) ?? const {};
    bool b(String k, bool d) => j[k] as bool? ?? d;
    return SettingsData(
      sound: b('sound', true),
      music: b('music', true),
      haptics: b('haptics', true),
      colourBlind: b('colourBlind', false),
      reducedMotion: b('reducedMotion', false),
    );
  }

  @override
  void onChange(Change<SettingsData> change) {
    super.onChange(change);
    final s = change.nextState;
    _store.write(_key, {
      'sound': s.sound,
      'music': s.music,
      'haptics': s.haptics,
      'colourBlind': s.colourBlind,
      'reducedMotion': s.reducedMotion,
    });
  }

  void toggle(SettingKey k) {
    final s = state;
    emit(
      SettingsData(
        sound: k == SettingKey.sound ? !s.sound : s.sound,
        music: k == SettingKey.music ? !s.music : s.music,
        haptics: k == SettingKey.haptics ? !s.haptics : s.haptics,
        colourBlind: k == SettingKey.colourBlind ? !s.colourBlind : s.colourBlind,
        reducedMotion: k == SettingKey.reducedMotion ? !s.reducedMotion : s.reducedMotion,
      ),
    );
  }
}
