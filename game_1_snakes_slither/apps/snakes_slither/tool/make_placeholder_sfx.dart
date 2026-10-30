// Writes short synthesised placeholder SFX (16-bit mono 44.1 kHz WAV) until the
// real themed sounds are delivered. Run: dart run tool/make_placeholder_sfx.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const _rate = 44100;

typedef Voice = double Function(double t, double dur);

double _env(double t, double dur, {double attack = 0.005}) {
  final a = t < attack ? t / attack : 1.0;
  final r = math.max(0.0, 1 - t / dur);
  return a * r * r;
}

Voice _sweep(double f0, double f1, {double noise = 0}) {
  final rnd = math.Random(1);
  var phase = 0.0;
  return (t, dur) {
    final f = f0 + (f1 - f0) * (t / dur);
    phase += 2 * math.pi * f / _rate;
    return (math.sin(phase) * (1 - noise) + (rnd.nextDouble() * 2 - 1) * noise) * _env(t, dur);
  };
}

Voice _notes(List<double> freqs, double each) {
  return (t, dur) {
    final i = math.min(freqs.length - 1, (t / each).floor());
    final local = t - i * each;
    final f = freqs[i];
    return (math.sin(2 * math.pi * f * t) * 0.7 + math.sin(4 * math.pi * f * t) * 0.2) * _env(local, each * 1.4);
  };
}

void _write(String path, double seconds, Voice v, {double gain = 0.5}) {
  final n = (seconds * _rate).round();
  final data = ByteData(44 + n * 2);
  void str(int o, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(o + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  data.setUint32(4, 36 + n * 2, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, _rate, Endian.little);
  data.setUint32(28, _rate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  str(36, 'data');
  data.setUint32(40, n * 2, Endian.little);
  for (var i = 0; i < n; i++) {
    final s = (v(i / _rate, seconds) * gain).clamp(-1.0, 1.0);
    data.setInt16(44 + i * 2, (s * 32767).round(), Endian.little);
  }
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(data.buffer.asUint8List());
}

void main() {
  const dir = 'assets/audio/sfx';
  _write('$dir/ui_tap_v1.wav', 0.06, _sweep(900, 700), gain: 0.35);
  _write('$dir/path_tap_v1.wav', 0.07, _sweep(500, 380, noise: 0.4), gain: 0.3);
  _write('$dir/path_exit_v1.wav', 0.32, _sweep(300, 1200, noise: 0.35), gain: 0.45);
  _write('$dir/bump_v1.wav', 0.22, _sweep(220, 90), gain: 0.7);
  _write('$dir/locked_tap_v1.wav', 0.2, _notes([330, 294], 0.1), gain: 0.4);
  _write('$dir/heart_lost_v1.wav', 0.3, _sweep(700, 250), gain: 0.45);
  _write('$dir/shield_absorb_v1.wav', 0.25, _notes([1400, 1800], 0.08), gain: 0.4);
  _write('$dir/preview_start_v1.wav', 0.12, _sweep(1200, 2000, noise: 0.2), gain: 0.25);
  _write('$dir/booster_hint_v1.wav', 0.45, _notes([1047, 1319, 1568, 2093], 0.1), gain: 0.35);
  _write('$dir/booster_hammer_v1.wav', 0.3, _sweep(160, 60, noise: 0.6), gain: 0.7);
  _write('$dir/win_stinger_v1.wav', 0.9, _notes([523, 659, 784, 1047, 1319], 0.16), gain: 0.45);
  _write('$dir/fail_v1.wav', 0.7, _notes([392, 330, 262], 0.22), gain: 0.4);
  _write('$dir/coins_fly_v1.wav', 0.35, _notes([1568, 2093, 2637], 0.09), gain: 0.3);
  _write('$dir/star_pop_v1.wav', 0.18, _notes([1319, 1760], 0.07), gain: 0.35);
  _write('$dir/popup_open_v1.wav', 0.14, _sweep(400, 800), gain: 0.25);
  _write('$dir/spin_tick_v1.wav', 0.03, _sweep(2000, 1800), gain: 0.25);
  _write('$dir/gift_open_v1.wav', 0.6, _notes([784, 988, 1175, 1568], 0.12), gain: 0.4);
  _write('$dir/countdown_v1.wav', 0.12, _notes([880], 0.1), gain: 0.35);
  stdout.writeln('Wrote placeholder SFX to $dir');
}
