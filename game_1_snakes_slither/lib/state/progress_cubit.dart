import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/save_store.dart';

class ProgressState extends Equatable {
  const ProgressState({
    this.highestCleared = 0,
    this.bestStars = const {},
    this.threeStarBonusClaimed = const {},
    this.adReviveUsed = const {},
  });

  final int highestCleared;
  final Map<int, int> bestStars;
  final Set<int> threeStarBonusClaimed;

  /// One ad revive per level number; not reset by restart, reset on clear.
  final Set<int> adReviveUsed;

  int get nextLevel => highestCleared + 1;
  bool isCleared(int level) => bestStars.containsKey(level);
  int starsFor(int level) => bestStars[level] ?? 0;
  bool isUnlocked(int level) => level <= nextLevel;

  Map<String, dynamic> toJson() => {
    'highestCleared': highestCleared,
    'bestStars': {for (final e in bestStars.entries) '${e.key}': e.value},
    'threeStarBonusClaimed': threeStarBonusClaimed.toList(),
    'adReviveUsed': adReviveUsed.toList(),
  };

  factory ProgressState.fromJson(Map<String, dynamic> j) => ProgressState(
    highestCleared: j['highestCleared'] as int? ?? 0,
    bestStars: {
      for (final e in ((j['bestStars'] as Map?) ?? {}).entries)
        int.parse(e.key as String): e.value as int,
    },
    threeStarBonusClaimed: {...((j['threeStarBonusClaimed'] as List?) ?? []).cast<int>()},
    adReviveUsed: {...((j['adReviveUsed'] as List?) ?? []).cast<int>()},
  );

  ProgressState copyWith({
    int? highestCleared,
    Map<int, int>? bestStars,
    Set<int>? threeStarBonusClaimed,
    Set<int>? adReviveUsed,
  }) => ProgressState(
    highestCleared: highestCleared ?? this.highestCleared,
    bestStars: bestStars ?? this.bestStars,
    threeStarBonusClaimed: threeStarBonusClaimed ?? this.threeStarBonusClaimed,
    adReviveUsed: adReviveUsed ?? this.adReviveUsed,
  );

  @override
  List<Object?> get props => [highestCleared, bestStars, threeStarBonusClaimed, adReviveUsed];
}

/// What a win changed, so the reward screen knows what to show.
class ClearRecord {
  const ClearRecord({required this.firstClear, required this.firstThreeStar});
  final bool firstClear;
  final bool firstThreeStar;
}

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._store) : super(_load(_store));

  static const _key = 'progress';
  final SaveStore _store;

  static ProgressState _load(SaveStore s) {
    final j = s.read(_key);
    return j == null ? const ProgressState() : ProgressState.fromJson(j);
  }

  @override
  void onChange(Change<ProgressState> change) {
    super.onChange(change);
    _store.write(_key, change.nextState.toJson());
  }

  /// Stars only ever go up; the ★★★ bonus is paid once per level.
  ClearRecord levelWon(int level, int stars) {
    final firstClear = !state.isCleared(level);
    final firstThreeStar = stars == 3 && !state.threeStarBonusClaimed.contains(level);
    final best = stars > state.starsFor(level) ? stars : state.starsFor(level);
    emit(
      state.copyWith(
        highestCleared: level > state.highestCleared ? level : state.highestCleared,
        bestStars: {...state.bestStars, level: best},
        threeStarBonusClaimed: firstThreeStar ? {...state.threeStarBonusClaimed, level} : null,
        adReviveUsed: {...state.adReviveUsed}..remove(level),
      ),
    );
    return ClearRecord(firstClear: firstClear, firstThreeStar: firstThreeStar);
  }

  void markAdRevive(int level) =>
      emit(state.copyWith(adReviveUsed: {...state.adReviveUsed, level}));
}
