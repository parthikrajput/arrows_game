import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../services/remote_config.dart';

enum RushStage { intro, countdown, playing, results }

/// Golden Slither Rush round: board, 30 s timer, coins. No hearts, no boosters.
class RushController extends ChangeNotifier {
  RushController({required this.level, required this.config}) : board = _build(level, config) {
    total = board.snakes.length;
    left = Duration(seconds: config.rushSeconds);
  }

  final int level;
  final EconomyConfig config;
  BoardState board;
  late final int total;

  RushStage stage = RushStage.intro;
  int countdown = 3;
  Duration left = Duration.zero;
  int cleared = 0;
  bool fullClear = false;
  bool busy = false;
  bool paused = false;
  String? _queued;

  Timer? _timer;
  DateTime? _lastTick;

  int get coins => cleared * config.rushCoinsPerSnake + (fullClear ? config.rushFullClearBonus : 0);
  double get timeFraction => left.inMilliseconds / (config.rushSeconds * 1000);

  /// Reverse-built golden board, so a full clear is always possible.
  static BoardState _build(int level, EconomyConfig cfg) {
    final count = cfg.rushSnakes(level);
    final size = count >= 25 ? 10 : 9;
    final def = BoardGenerator.generate(
      'rush:$level',
      GeneratorParams(
        width: size,
        height: size,
        snakeCount: count,
        minLength: 2,
        maxLength: 4,
        tangle: 0.4,
        caterpillarRatio: 0,
        palette: const [SnakeColor.gold],
      ),
      Hash64.of([EconomyConfig.gameId, 'rush', '$level']).seed(),
    );
    return def.toBoard();
  }

  void start() {
    if (stage != RushStage.intro) return;
    _countdown();
  }

  void _countdown() {
    stage = RushStage.countdown;
    countdown = 3;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      countdown--;
      if (countdown <= 0) {
        t.cancel();
        _go();
      }
      notifyListeners();
    });
  }

  void _go() {
    stage = RushStage.playing;
    _lastTick = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  void _tick() {
    final now = DateTime.now();
    left -= now.difference(_lastTick!);
    _lastTick = now;
    if (left <= Duration.zero) {
      left = Duration.zero;
      finish();
      return;
    }
    notifyListeners();
  }

  /// App backgrounded: freeze the clock; resume with a fresh 3-2-1.
  void pause() {
    if (stage != RushStage.playing && stage != RushStage.countdown) return;
    _timer?.cancel();
    paused = true;
    notifyListeners();
  }

  void resume() {
    if (!paused) return;
    paused = false;
    _countdown();
  }

  /// Resolves a tap. Returns the outcome so the view can animate it; while a
  /// snake is moving the last tap is queued.
  MoveOutcome? tap(String snakeId) {
    if (stage != RushStage.playing) return null;
    if (busy) {
      _queued = snakeId;
      return null;
    }
    final o = Engine.apply(board, snakeId);
    if (o != null) busy = true;
    return o;
  }

  /// Commits an animated outcome; returns a queued tap to resolve next.
  String? commit(MoveOutcome o) {
    busy = false;
    if (o is ExitOutcome) {
      board = o.next;
      cleared++;
      if (board.isEmpty) {
        fullClear = true;
        finish();
        return null;
      }
    }
    notifyListeners();
    final q = _queued;
    _queued = null;
    return q;
  }

  void finish() {
    _timer?.cancel();
    stage = RushStage.results;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
