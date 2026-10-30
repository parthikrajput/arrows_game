import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../app/services.dart';

/// What a win is worth, decided once when the level is won.
class WinReward {
  const WinReward({
    required this.level,
    required this.stars,
    required this.firstClear,
    required this.clearCoins,
    required this.starBonus,
    required this.giftDue,
    required this.chestDue,
    required this.rushDue,
  });

  final int level;
  final int stars;
  final bool firstClear;
  final int clearCoins;
  final int starBonus;
  final bool giftDue;
  final bool chestDue;
  final bool rushDue;

  int get total => clearCoins + starBonus;
}

class ProgressState extends Equatable {
  const ProgressState({
    this.highestCleared = 0,
    this.stars = const {},
    this.adReviveUsed = const {},
    this.threeStarClaimed = const {},
    this.tutorialSteps = const {},
    this.rushPendingLevel,
    this.gardenHero = false,
  });

  final int highestCleared;
  final Map<int, int> stars;

  /// Keys: level number as string, or `daily:<dayKey>`.
  final Set<String> adReviveUsed;
  final Set<int> threeStarClaimed;
  final Set<String> tutorialSteps;
  final int? rushPendingLevel;
  final bool gardenHero;

  int get nextLevel => (highestCleared + 1).clamp(1, 500);
  int get totalStars => stars.values.fold(0, (a, b) => a + b);
  int starsOf(int level) => stars[level] ?? 0;
  bool isUnlocked(int level) => level <= highestCleared + 1;

  ProgressState copyWith({
    int? highestCleared,
    Map<int, int>? stars,
    Set<String>? adReviveUsed,
    Set<int>? threeStarClaimed,
    Set<String>? tutorialSteps,
    int? Function()? rushPendingLevel,
    bool? gardenHero,
  }) =>
      ProgressState(
        highestCleared: highestCleared ?? this.highestCleared,
        stars: stars ?? this.stars,
        adReviveUsed: adReviveUsed ?? this.adReviveUsed,
        threeStarClaimed: threeStarClaimed ?? this.threeStarClaimed,
        tutorialSteps: tutorialSteps ?? this.tutorialSteps,
        rushPendingLevel: rushPendingLevel != null ? rushPendingLevel() : this.rushPendingLevel,
        gardenHero: gardenHero ?? this.gardenHero,
      );

  Map<String, Object?> toJson() => {
        'highestCleared': highestCleared,
        'stars': {for (final e in stars.entries) '${e.key}': e.value},
        'adReviveUsed': adReviveUsed.toList(),
        'threeStarClaimed': threeStarClaimed.toList(),
        'tutorialSteps': tutorialSteps.toList(),
        'rushPendingLevel': rushPendingLevel,
        'gardenHero': gardenHero,
      };

  static ProgressState fromJson(Map<String, Object?> j) => ProgressState(
        highestCleared: (j['highestCleared'] as int?) ?? 0,
        stars: {
          for (final e in ((j['stars'] as Map?) ?? const {}).entries) int.parse(e.key as String): e.value as int,
        },
        adReviveUsed: {for (final v in (j['adReviveUsed'] as List?) ?? const []) v as String},
        threeStarClaimed: {for (final v in (j['threeStarClaimed'] as List?) ?? const []) v as int},
        tutorialSteps: {for (final v in (j['tutorialSteps'] as List?) ?? const []) v as String},
        rushPendingLevel: j['rushPendingLevel'] as int?,
        gardenHero: (j['gardenHero'] as bool?) ?? false,
      );

  @override
  List<Object?> get props => [highestCleared, stars, adReviveUsed, threeStarClaimed, tutorialSteps, rushPendingLevel, gardenHero];
}

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._s) : super(ProgressState.fromJson(_s.save.section('progress')));

  final AppServices _s;

  /// Records a numbered-level win and returns its rewards (coins are granted by the caller).
  WinReward levelWon(int level, int stars, LevelTag tag) {
    final firstClear = !state.stars.containsKey(level);
    final firstThree = stars == 3 && !state.threeStarClaimed.contains(level);
    final cfg = _s.config;
    final reward = WinReward(
      level: level,
      stars: stars,
      firstClear: firstClear,
      clearCoins: firstClear ? cfg.clearCoins(tag) : 0,
      starBonus: firstThree ? cfg.firstThreeStarBonus : 0,
      giftDue: firstClear && level % 10 == 0 && level < cfg.phaseLastLevel,
      chestDue: firstClear && level == cfg.phaseLastLevel,
      rushDue: firstClear && level % 25 == 0,
    );
    final best = stars > state.starsOf(level) ? stars : state.starsOf(level);
    _set(state.copyWith(
      highestCleared: level > state.highestCleared ? level : state.highestCleared,
      stars: {...state.stars, level: best},
      threeStarClaimed: firstThree ? {...state.threeStarClaimed, level} : null,
      // A clear resets the once-per-level ad revive.
      adReviveUsed: {...state.adReviveUsed}..remove('$level'),
      rushPendingLevel: reward.rushDue ? () => level : null,
      gardenHero: reward.chestDue ? true : null,
    ));
    _s.save.backup();
    return reward;
  }

  bool adReviveUsed(String key) => state.adReviveUsed.contains(key);

  void markAdRevive(String key) => _set(state.copyWith(adReviveUsed: {...state.adReviveUsed, key}));

  bool tutorialDone(String id) => state.tutorialSteps.contains(id);

  void completeTutorial(String id) {
    if (tutorialDone(id)) return;
    _set(state.copyWith(tutorialSteps: {...state.tutorialSteps, id}));
    _s.analytics.event('ftue_step', {'step': id});
  }

  void clearRushPending() => _set(state.copyWith(rushPendingLevel: () => null));

  /// QA shortcut (developer builds only): marks levels 1..[level] cleared with 3 stars.
  void debugClearUpTo(int level) => _set(state.copyWith(
        highestCleared: level,
        stars: {for (var l = 1; l <= level; l++) l: state.stars[l] ?? 3},
        threeStarClaimed: {for (var l = 1; l <= level; l++) l},
        tutorialSteps: {...state.tutorialSteps, 'ftue_tap', 'ftue_bonk', 'tut_hint', 'ftue_preview'},
      ));

  void _set(ProgressState next) {
    emit(next);
    _s.save.write('progress', next.toJson());
  }
}
