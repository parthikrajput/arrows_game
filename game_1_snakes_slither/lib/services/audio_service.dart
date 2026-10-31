import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../contracts/ui_feedback.dart';
import '../features/gameplay/game_bloc.dart';
import 'haptics.dart';

/// Sound event ids, mapped to `assets/audio/sfx/<id>_v1.wav`.
enum Sfx {
  uiTap('ui_tap'),
  pathTap('path_tap'),
  pathExit('path_exit'),
  bump('bump'),
  lockedTap('locked_tap'),
  heartLost('heart_lost'),
  shieldAbsorb('shield_absorb'),
  previewStart('preview_start'),
  boosterHint('booster_hint'),
  boosterHammer('booster_hammer'),
  winStinger('win_stinger'),
  fail('fail'),
  coinsFly('coins_fly'),
  starPop('star_pop'),
  popupOpen('popup_open'),
  spinTick('spin_tick'),
  giftOpen('gift_open'),
  countdown('countdown');

  const Sfx(this.id);
  final String id;

  static Sfx? fromId(String id) {
    for (final s in Sfx.values) {
      if (s.id == id) return s;
    }
    return null;
  }
}

/// Audio manager supporting low-latency sound effects via pre-loaded pools,
/// background music with ducking, event throttling, and settings-driven muting.
class AudioService implements UiFeedback {
  AudioService({
    this.enabled = true,
    HapticsService? haptics,
    bool soundEnabled = true,
    bool musicEnabled = true,
  })  : _haptics = haptics ?? HapticsService(),
        _soundEnabled = soundEnabled,
        _musicEnabled = musicEnabled {
    if (enabled) {
      _initPlayers();
    }
  }

  /// When false (tests), nothing loads or plays.
  final bool enabled;

  final HapticsService _haptics;
  bool _soundEnabled;
  bool _musicEnabled;

  // Audio players
  AudioPlayer? _musicPlayer;
  final List<AudioPlayer> _sfxPool = [];
  int _nextPoolIndex = 0;
  static const int _maxConcurrentVoices = 8;
  static const int _minEventIntervalMs = 50;

  // Preloaded AudioPools for ultra-low latency Sfx
  final Map<Sfx, AudioPool> _pools = {};
  final Map<String, int> _lastPlayedEpochMs = {};
  int _voices = 0;
  bool _ready = false;

  // Active theme asset mappings
  Map<String, String> _eventMap = {};
  Map<String, String> _musicMap = {};

  // Standard volume levels
  static const double _masterVol = 1.0;
  static const double _musicBaseVol = 0.55;
  static const double _sfxBaseVol = 1.0;
  double _currentMusicVol = _musicBaseVol;

  bool get soundEnabled => _soundEnabled;
  set soundEnabled(bool value) {
    _soundEnabled = value;
    if (!value) {
      _stopAllSfx();
    }
  }

  bool get soundOn => _soundEnabled;
  set soundOn(bool value) => soundEnabled = value;

  bool get musicEnabled => _musicEnabled;
  set musicEnabled(bool value) {
    _musicEnabled = value;
    if (!value) {
      _musicPlayer?.pause();
    } else {
      _musicPlayer?.resume();
    }
  }

  bool get musicOn => _musicEnabled;
  set musicOn(bool value) => musicEnabled = value;

  HapticsService get haptics => _haptics;

  bool get hapticsOn => _haptics.enabled;
  set hapticsOn(bool value) => _haptics.enabled = value;

  void _initPlayers() {
    try {
      _musicPlayer = AudioPlayer();
      _musicPlayer?.setReleaseMode(ReleaseMode.loop);
      _musicPlayer?.setVolume(_musicBaseVol * _masterVol);

      for (int i = 0; i < _maxConcurrentVoices; i++) {
        final p = AudioPlayer();
        p.setVolume(_sfxBaseVol * _masterVol);
        _sfxPool.add(p);
      }
    } catch (_) {
      // Platform audio not available (e.g. headless unit tests or unsupported environment)
    }
  }

  String _resolveSfxPath(String eventId) {
    var path = _eventMap[eventId];
    if (path != null) {
      if (!path.endsWith('_v1.wav') && path.endsWith('.wav')) {
        return path.replaceFirst('.wav', '_v1.wav');
      }
      return path;
    }
    return 'audio/sfx/${eventId}_v1.wav';
  }

  /// Preload pools and load theme mappings
  Future<void> init() async {
    if (_ready || !enabled) return;
    _ready = true;
    await loadTheme();
    for (final s in Sfx.values) {
      try {
        final path = _resolveSfxPath(s.id);
        _pools[s] = await AudioPool.createFromAsset(
          path: path,
          maxPlayers: 2,
        );
      } catch (e) {
        debugPrint('E-AUD-002 pool create failed for ${s.id}: $e');
      }
    }
  }

  /// Load theme mappings from assets/audio/theme.json
  Future<void> loadTheme([String themePath = 'assets/audio/theme.json']) async {
    try {
      final jsonStr = await rootBundle.loadString(themePath);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final events = data['events'] as Map<String, dynamic>?;
      if (events != null) {
        _eventMap = events.map((k, v) => MapEntry(k, v.toString()));
      }
      final music = data['music'] as Map<String, dynamic>?;
      if (music != null) {
        _musicMap = music.map((k, v) => MapEntry(k, v.toString()));
      }
    } catch (_) {
      // If asset load fails, fallback to defaults
    }
  }

  /// Play an [Sfx] enum value
  Future<void> play(Sfx s) => playSfx(s.id);

  /// Play a raw SFX event ID mapped via theme.json
  Future<void> playSfx(String eventId) async {
    if (!_soundEnabled || !enabled) return;

    // Rate-limiting check
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _lastPlayedEpochMs[eventId] ?? 0;
    if (now - last < _minEventIntervalMs) {
      return;
    }
    _lastPlayedEpochMs[eventId] = now;

    // Check preloaded pool first
    final sfx = Sfx.fromId(eventId);
    if (sfx != null && _pools.containsKey(sfx)) {
      try {
        if (_voices >= _maxConcurrentVoices) return;
        _voices++;
        final stop = await _pools[sfx]!.start(volume: _sfxBaseVol * _masterVol);
        Future<void>.delayed(const Duration(milliseconds: 900), () {
          _voices--;
          stop();
        });
        return;
      } catch (e) {
        _voices--;
        debugPrint('E-AUD-003 playback failed for $eventId: $e');
      }
    }

    // Fallback to _sfxPool AudioPlayer
    if (_sfxPool.isEmpty) return;
    final path = _resolveSfxPath(eventId);
    try {
      final player = _sfxPool[_nextPoolIndex];
      _nextPoolIndex = (_nextPoolIndex + 1) % _sfxPool.length;

      await player.stop();
      await player.play(AssetSource(path));
    } catch (_) {
      // Missing audio asset or engine playback error
    }
  }

  /// Play a high-level GameCue from gameplay
  Future<void> playCue(GameCue cue) async {
    switch (cue) {
      case GameCue.exit:
        await play(Sfx.pathExit);
        await _haptics.lightImpact();
      case GameCue.bump:
        await play(Sfx.bump);
        await play(Sfx.heartLost);
        await _haptics.mediumImpact();
      case GameCue.locked:
        await play(Sfx.lockedTap);
        await _haptics.selectionClick();
      case GameCue.shieldCrack:
        await play(Sfx.shieldAbsorb);
        await _haptics.mediumImpact();
      case GameCue.hammerHit:
        await play(Sfx.boosterHammer);
        await _haptics.heavyImpact();
      case GameCue.hintNoSolution || GameCue.notEnoughCoins:
        await play(Sfx.lockedTap);
        await _haptics.selectionClick();
    }
  }

  @override
  void sound(UiSound s) => play(switch (s) {
    UiSound.tap => Sfx.uiTap,
    UiSound.popupOpen => Sfx.popupOpen,
    UiSound.coinsFly => Sfx.coinsFly,
    UiSound.starPop => Sfx.starPop,
    UiSound.spinTick => Sfx.spinTick,
    UiSound.giftOpen => Sfx.giftOpen,
    UiSound.countdown => Sfx.countdown,
  });

  @override
  void haptic() {
    if (hapticsOn && enabled) {
      _haptics.selectionClick();
    }
  }

  /// Play background music by track ID ('home', 'gameplay', 'rush')
  Future<void> playMusic(String trackId) async {
    if (_musicPlayer == null || !enabled) return;
    final path = _musicMap[trackId] ?? 'audio/music/music_$trackId.m4a';

    try {
      await _musicPlayer?.stop();
      await _musicPlayer?.setVolume(_currentMusicVol * _masterVol);
      if (_musicEnabled) {
        await _musicPlayer?.play(AssetSource(path));
      }
    } catch (_) {}
  }

  /// Duck background music by [factor] during stingers or modals
  Future<void> duckMusic({double factor = 0.3, Duration duration = const Duration(milliseconds: 1500)}) async {
    if (_musicPlayer == null || !_musicEnabled || !enabled) return;
    try {
      _currentMusicVol = _musicBaseVol * factor;
      await _musicPlayer?.setVolume(_currentMusicVol * _masterVol);

      Future.delayed(duration, () async {
        _currentMusicVol = _musicBaseVol;
        if (_musicEnabled) {
          await _musicPlayer?.setVolume(_currentMusicVol * _masterVol);
        }
      });
    } catch (_) {}
  }

  /// Pause music for ads or background lifecycle
  Future<void> pauseMusic() async {
    try {
      await _musicPlayer?.pause();
    } catch (_) {}
  }

  /// Resume music after ads or foreground lifecycle
  Future<void> resumeMusic() async {
    if (_musicEnabled && enabled) {
      try {
        await _musicPlayer?.resume();
      } catch (_) {}
    }
  }

  void _stopAllSfx() {
    for (final p in _sfxPool) {
      try {
        p.stop();
      } catch (_) {}
    }
  }

  void dispose() {
    try {
      _musicPlayer?.dispose();
      for (final p in _sfxPool) {
        p.dispose();
      }
      _sfxPool.clear();
      for (final pool in _pools.values) {
        pool.dispose();
      }
      _pools.clear();
    } catch (_) {}
  }
}
