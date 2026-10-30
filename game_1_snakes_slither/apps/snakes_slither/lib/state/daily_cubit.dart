import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../app/services.dart';
import '../services/remote_config.dart';

/// Weekday modifiers. Thu/Fri/Sun need mechanics that are not unlocked yet,
/// so they fall back to Classic (standard §16.2).
enum DailyModifier { classic, parMoves, oneHeart, bigBoard }

extension DailyModifierText on DailyModifier {
  String get title => switch (this) {
        DailyModifier.classic => 'Classic',
        DailyModifier.parMoves => 'Par Moves',
        DailyModifier.oneHeart => 'One Heart',
        DailyModifier.bigBoard => 'Big Board',
      };

  String get rule => switch (this) {
        DailyModifier.classic => 'No twist today. Just untangle the jungle!',
        DailyModifier.parMoves => 'Finish within par moves to keep all your stars.',
        DailyModifier.oneHeart => 'Only one heart berry today. Think before you tap!',
        DailyModifier.bigBoard => 'The biggest garden patch for your tier.',
      };
}

class DailyPuzzle {
  const DailyPuzzle({required this.dayKey, required this.def, required this.modifier, required this.silhouette, required this.paramsLevel});

  final String dayKey;
  final LevelDef def;
  final DailyModifier modifier;
  final Silhouette silhouette;
  final int paramsLevel;

  int get hearts => modifier == DailyModifier.oneHeart ? 1 : 3;
}

class DailyReward {
  const DailyReward({required this.coins, required this.firstClear});
  final int coins;
  final bool firstClear;
}

class DailyState extends Equatable {
  const DailyState({this.claimedDays = const {}, this.starsByDay = const {}, this.cachedParams = const {}});

  final Set<String> claimedDays;
  final Map<String, int> starsByDay;

  /// dayKey → params level, so today's board stays the same all day.
  final Map<String, int> cachedParams;

  bool claimed(String dayKey) => claimedDays.contains(dayKey);

  Map<String, Object?> toJson() => {
        'claimedDays': claimedDays.toList(),
        'starsByDay': starsByDay,
        'cachedParams': cachedParams,
      };

  static DailyState fromJson(Map<String, Object?> j) => DailyState(
        claimedDays: {for (final d in (j['claimedDays'] as List?) ?? const []) d as String},
        starsByDay: ((j['starsByDay'] as Map?) ?? const {}).map((k, v) => MapEntry(k as String, v as int)),
        cachedParams: ((j['cachedParams'] as Map?) ?? const {}).map((k, v) => MapEntry(k as String, v as int)),
      );

  @override
  List<Object?> get props => [claimedDays, starsByDay, cachedParams];
}

class DailyCubit extends Cubit<DailyState> {
  DailyCubit(this._s) : super(DailyState.fromJson(_s.save.section('daily'))) {
    _params.addAll(state.cachedParams);
  }

  final AppServices _s;

  /// Written without emitting: boards are read during build.
  final Map<String, int> _params = {};
  final Map<String, DailyPuzzle> _boards = {};

  bool unlocked(int highestCleared) => highestCleared >= _s.config.dailyUnlockLevel;

  DailyPuzzle today(int highestCleared) => puzzleFor(_s.time.dayKey(), highestCleared);

  DailyPuzzle puzzleFor(String dayKey, int highestCleared) {
    final cachedBoard = _boards[dayKey];
    if (cachedBoard != null) return cachedBoard;
    var params = _params[dayKey];
    if (params == null) {
      params = (highestCleared - 10).clamp(15, 500);
      _params[dayKey] = params;
      // Keep only the last week of cached keys.
      while (_params.length > 7) {
        _params.remove(_params.keys.first);
      }
      _s.save.write('daily', {...state.toJson(), 'cachedParams': {..._params}});
    }
    final weekday = DateTime.parse(dayKey).weekday;
    final modifier = switch (weekday) {
      DateTime.tuesday => DailyModifier.parMoves,
      DateTime.wednesday => DailyModifier.oneHeart,
      DateTime.saturday => DailyModifier.bigBoard,
      _ => DailyModifier.classic,
    };
    final silhouette = SilhouetteMask.forWeekday(weekday);
    final tierMax = 7 + _s.config.tierOf(params);
    final size = modifier == DailyModifier.bigBoard ? (tierMax + 1).clamp(7, 11) : tierMax.clamp(7, 10);
    final mask = silhouette.mask(size, size);
    final hash = Hash64.of([EconomyConfig.gameId, dayKey]);
    LevelDef? def;
    for (var k = 0; k < 64 && def == null; k++) {
      final candidate = BoardGenerator.generate(
        'daily:$dayKey',
        GeneratorParams(width: size, height: size, snakeCount: (mask.length / 4.2).round(), tangle: 0.8, mask: mask),
        hash.seed(k),
      );
      if (candidate.snakes.length >= 6) def = candidate;
    }
    def ??= BoardGenerator.generate('daily:$dayKey', GeneratorParams(width: 7, height: 7, snakeCount: 10), hash.seed());
    if (modifier == DailyModifier.parMoves) {
      def = LevelDef(
        id: def.id,
        width: def.width,
        height: def.height,
        snakes: def.snakes,
        solution: def.solution,
        parMoves: def.snakes.length + 2,
      );
    }
    return _boards[dayKey] =
        DailyPuzzle(dayKey: dayKey, def: def, modifier: modifier, silhouette: silhouette, paramsLevel: params);
  }

  /// Records a Daily win on the day the board started (edge case D1).
  DailyReward won(String dayKey, int stars) {
    final first = !state.claimed(dayKey);
    final best = stars > (state.starsByDay[dayKey] ?? 0) ? stars : state.starsByDay[dayKey]!;
    _set(DailyState(
      claimedDays: {...state.claimedDays, dayKey},
      starsByDay: {...state.starsByDay, dayKey: best},
      cachedParams: {..._params},
    ));
    if (first) _s.analytics.event('daily_clear', {'dayKey': dayKey});
    return DailyReward(coins: first ? _s.config.dailyClearCoins : 0, firstClear: first);
  }

  void _set(DailyState next) {
    emit(next);
    _s.save.write('daily', next.toJson());
  }
}
