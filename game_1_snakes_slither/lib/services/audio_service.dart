import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../contracts/ui_feedback.dart';

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
}

/// Low-latency sound effects from pre-loaded pools. Failures are swallowed:
/// sound must never block or crash the game.
class AudioService implements UiFeedback {
  AudioService({this.enabled = true});

  static const _maxVoices = 8;
  static const _minGap = Duration(milliseconds: 50);

  /// When false (tests), nothing loads or plays.
  final bool enabled;

  bool soundOn = true;
  bool hapticsOn = true;

  final Map<Sfx, AudioPool> _pools = {};
  final Map<Sfx, DateTime> _lastPlayed = {};
  int _voices = 0;
  bool _ready = false;

  Future<void> init() async {
    if (_ready || !enabled) return;
    _ready = true;
    for (final s in Sfx.values) {
      try {
        _pools[s] = await AudioPool.createFromAsset(
          path: 'audio/sfx/${s.id}_v1.wav',
          maxPlayers: 2,
        );
      } catch (e) {
        debugPrint('E-AUD-002 pool create failed for ${s.id}: $e');
      }
    }
  }

  Future<void> play(Sfx s) async {
    if (!soundOn || !_ready) return;
    final now = DateTime.now();
    final last = _lastPlayed[s];
    // The same sound twice within 50 ms is noise, not feedback.
    if (last != null && now.difference(last) < _minGap) return;
    if (_voices >= _maxVoices) return;
    final pool = _pools[s];
    if (pool == null) return;
    _lastPlayed[s] = now;
    _voices++;
    try {
      final stop = await pool.start(volume: 0.8);
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        _voices--;
        stop();
      });
    } catch (e) {
      _voices--;
      debugPrint('E-AUD-003 playback failed for ${s.id}: $e');
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
    if (hapticsOn && enabled) HapticFeedback.selectionClick();
  }
}
