import 'package:audioplayers/audioplayers.dart';

import '../core/logging/app_logger.dart';

/// Standard sound event ids, mapped to `assets/audio/sfx/<id>_v1.wav`.
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
}

/// Low-latency SFX via pre-loaded pools. Failures are logged and swallowed:
/// sound must never block the game.
class AudioService {
  AudioService();

  static const int _maxVoices = 8;
  static const Duration _minGap = Duration(milliseconds: 50);

  bool soundOn = true;
  bool musicOn = true;

  final Map<Sfx, AudioPool> _pools = {};
  final Map<Sfx, DateTime> _lastPlayed = {};
  int _voices = 0;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    _ready = true;
    for (final s in Sfx.values) {
      try {
        _pools[s] = await AudioPool.createFromAsset(path: 'audio/sfx/${s.id}_v1.wav', maxPlayers: 2);
      } catch (e) {
        log.w('E-AUD-002', 'Pool create failed for ${s.id}: $e');
      }
    }
  }

  Future<void> play(Sfx s) async {
    if (!soundOn || !_ready) return;
    final now = DateTime.now();
    final last = _lastPlayed[s];
    if (last != null && now.difference(last) < _minGap) return;
    if (_voices >= _maxVoices) return;
    final pool = _pools[s];
    if (pool == null) return;
    _lastPlayed[s] = now;
    _voices++;
    try {
      final stop = await pool.start(volume: 0.8);
      Future.delayed(const Duration(milliseconds: 900), () {
        _voices--;
        stop();
      });
    } catch (e) {
      _voices--;
      log.w('E-AUD-003', 'Playback failed for ${s.id}: $e');
    }
  }
}
