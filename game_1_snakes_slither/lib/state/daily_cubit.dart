import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/save_store.dart';
import '../services/time_guard.dart';
import 'progress_cubit.dart';
import 'streak_cubit.dart';
import 'wallet_cubit.dart';

enum DailyModifier {
  classic('Classic', 'Standard rules; clear all snakes.'),
  parMoves('Par Moves', 'Finish within par moves for 3 stars!'),
  oneHeart('One Heart', 'Only 1 heart! Tread carefully.'),
  fogDay('Fog Day', 'Jungle mist covers parts of the board.'),
  keyHunt('Key Hunt', 'Collect keys to open bamboo cages.'),
  bigBoard('Big Board', 'An expanded garden grid.'),
  miniBoss('Mini Boss', 'Grumpy Mongoose blocks the paths.');

  const DailyModifier(this.label, this.description);
  final String label;
  final String description;
}

class DailyState extends Equatable {
  const DailyState({
    required this.dayKey,
    required this.modifier,
    this.completed = false,
    this.unlocked = false,
    this.initialHearts = 3,
  });

  final String dayKey;
  final DailyModifier modifier;
  final bool completed;
  final bool unlocked;
  final int initialHearts;

  DailyState copyWith({
    String? dayKey,
    DailyModifier? modifier,
    bool? completed,
    bool? unlocked,
    int? initialHearts,
  }) =>
      DailyState(
        dayKey: dayKey ?? this.dayKey,
        modifier: modifier ?? this.modifier,
        completed: completed ?? this.completed,
        unlocked: unlocked ?? this.unlocked,
        initialHearts: initialHearts ?? this.initialHearts,
      );

  @override
  List<Object?> get props => [dayKey, modifier, completed, unlocked, initialHearts];
}

/// Manages Daily Jungle Challenge state, modifiers, and daily completion.
class DailyCubit extends Cubit<DailyState> {
  DailyCubit(this._store, this._time, this._progress, this._wallet, this._streak)
      : super(_load(_store, _time, _progress));

  static const _key = 'daily';
  final SaveStore _store;
  final TimeGuard _time;
  final ProgressCubit _progress;
  final WalletCubit _wallet;
  final StreakCubit _streak;

  static DailyState _load(SaveStore s, TimeGuard t, ProgressCubit p) {
    final j = s.read(_key) ?? const {};
    final dayKey = t.dayKey();
    final completed = (j['completedDayKey'] as String? ?? '') == dayKey;
    final unlocked = p.state.highestCleared >= 15;

    final modifier = _determineModifier(t.clock.now(), p.state.highestCleared);
    final hearts = modifier == DailyModifier.oneHeart ? 1 : 3;

    return DailyState(
      dayKey: dayKey,
      modifier: modifier,
      completed: completed,
      unlocked: unlocked,
      initialHearts: hearts,
    );
  }

  static DailyModifier _determineModifier(DateTime date, int highestCleared) {
    switch (date.weekday) {
      case DateTime.monday:
        return DailyModifier.classic;
      case DateTime.tuesday:
        return DailyModifier.parMoves;
      case DateTime.wednesday:
        return DailyModifier.oneHeart;
      case DateTime.thursday:
        return highestCleared >= 101 ? DailyModifier.fogDay : DailyModifier.classic;
      case DateTime.friday:
        return highestCleared >= 41 ? DailyModifier.keyHunt : DailyModifier.classic;
      case DateTime.saturday:
        return DailyModifier.bigBoard;
      case DateTime.sunday:
        return highestCleared >= 491 ? DailyModifier.miniBoss : DailyModifier.classic;
      default:
        return DailyModifier.classic;
    }
  }

  void _persist(DailyState s) {
    _store.write(_key, {
      'completedDayKey': s.completed ? s.dayKey : '',
    });
  }

  /// Mark daily puzzle completed, award 100 coins (first time only) and advance streak.
  void completeDaily() {
    final todayKey = _time.dayKey();
    if (state.completed && state.dayKey == todayKey) return;

    _wallet.earn(100);
    _streak.onDailyCompleted();

    final next = state.copyWith(dayKey: todayKey, completed: true);
    emit(next);
    _persist(next);
  }

  /// Refresh unlock state on progress updates
  void checkUnlock() {
    final unlocked = _progress.state.highestCleared >= 15;
    if (unlocked != state.unlocked) {
      emit(state.copyWith(unlocked: unlocked));
    }
  }
}
