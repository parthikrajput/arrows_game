import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/services.dart';
import '../core/logging/app_logger.dart';

enum SettingKey { sound, music, haptics, colourBlind, reducedMotion, brighterNights, shareDiagnostics }

class SettingsState extends Equatable {
  const SettingsState({
    this.sound = true,
    this.music = true,
    this.haptics = true,
    this.colourBlind = false,
    this.reducedMotion = false,
    this.brighterNights = false,
    this.shareDiagnostics = true,
    this.language = 'en',
    this.birthYear,
    this.installId = '',
  });

  final bool sound;
  final bool music;
  final bool haptics;
  final bool colourBlind;
  final bool reducedMotion;
  final bool brighterNights;
  final bool shareDiagnostics;
  final String language;
  final int? birthYear;
  final String installId;

  bool get ageAnswered => birthYear != null;

  /// Under-13 ⇒ child-directed ads, no personalisation, no free text in reports.
  bool isChild(int currentYear) => birthYear != null && currentYear - birthYear! < 13;

  bool value(SettingKey k) => switch (k) {
        SettingKey.sound => sound,
        SettingKey.music => music,
        SettingKey.haptics => haptics,
        SettingKey.colourBlind => colourBlind,
        SettingKey.reducedMotion => reducedMotion,
        SettingKey.brighterNights => brighterNights,
        SettingKey.shareDiagnostics => shareDiagnostics,
      };

  SettingsState copyWith({
    bool? sound,
    bool? music,
    bool? haptics,
    bool? colourBlind,
    bool? reducedMotion,
    bool? brighterNights,
    bool? shareDiagnostics,
    String? language,
    int? birthYear,
    String? installId,
  }) =>
      SettingsState(
        sound: sound ?? this.sound,
        music: music ?? this.music,
        haptics: haptics ?? this.haptics,
        colourBlind: colourBlind ?? this.colourBlind,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        brighterNights: brighterNights ?? this.brighterNights,
        shareDiagnostics: shareDiagnostics ?? this.shareDiagnostics,
        language: language ?? this.language,
        birthYear: birthYear ?? this.birthYear,
        installId: installId ?? this.installId,
      );

  Map<String, Object?> toJson() => {
        'sound': sound,
        'music': music,
        'haptics': haptics,
        'colourBlind': colourBlind,
        'reducedMotion': reducedMotion,
        'brighterNights': brighterNights,
        'shareDiagnostics': shareDiagnostics,
        'language': language,
        'birthYear': birthYear,
        'installId': installId,
      };

  static SettingsState fromJson(Map<String, Object?> j) => SettingsState(
        sound: (j['sound'] as bool?) ?? true,
        music: (j['music'] as bool?) ?? true,
        haptics: (j['haptics'] as bool?) ?? true,
        colourBlind: (j['colourBlind'] as bool?) ?? false,
        reducedMotion: (j['reducedMotion'] as bool?) ?? false,
        brighterNights: (j['brighterNights'] as bool?) ?? false,
        shareDiagnostics: (j['shareDiagnostics'] as bool?) ?? true,
        language: (j['language'] as String?) ?? 'en',
        birthYear: j['birthYear'] as int?,
        installId: (j['installId'] as String?) ?? '',
      );

  @override
  List<Object?> get props =>
      [sound, music, haptics, colourBlind, reducedMotion, brighterNights, shareDiagnostics, language, birthYear, installId];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._s) : super(SettingsState.fromJson(_s.save.section('settings'))) {
    if (state.installId.isEmpty) {
      _set(state.copyWith(installId: '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}-${identityHashCode(this)}'));
    }
    _apply(state);
  }

  final AppServices _s;

  void toggle(SettingKey k) {
    final v = !state.value(k);
    _set(switch (k) {
      SettingKey.sound => state.copyWith(sound: v),
      SettingKey.music => state.copyWith(music: v),
      SettingKey.haptics => state.copyWith(haptics: v),
      SettingKey.colourBlind => state.copyWith(colourBlind: v),
      SettingKey.reducedMotion => state.copyWith(reducedMotion: v),
      SettingKey.brighterNights => state.copyWith(brighterNights: v),
      SettingKey.shareDiagnostics => state.copyWith(shareDiagnostics: v),
    });
  }

  void setLanguage(String code) => _set(state.copyWith(language: code));

  void ageSubmitted(int year) {
    _set(state.copyWith(birthYear: year));
    _s.analytics.event('consent_result', {'status': 'age_set'});
  }

  void _set(SettingsState next) {
    emit(next);
    _apply(next);
    _s.save.write('settings', next.toJson());
  }

  void _apply(SettingsState st) {
    _s.audio.soundOn = st.sound;
    _s.audio.musicOn = st.music;
    _s.haptics.enabled = st.haptics;
    _s.analytics.enabled = st.shareDiagnostics;
    log.shareDiagnostics = st.shareDiagnostics;
  }
}
