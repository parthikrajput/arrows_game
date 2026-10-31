import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../data/save_store.dart';
import '../services/time_guard.dart';
import 'ads_cubit.dart';
import 'wallet_cubit.dart';

enum TrophyTier { bronze, silver, gold, platinum, diamond }

class StreakReward {
  const StreakReward({
    required this.day,
    required this.coins,
    this.booster,
    this.hasTrophy = false,
  });

  final int day;
  final int coins;
  final Booster? booster;
  final bool hasTrophy;
}

class StreakState extends Equatable {
  const StreakState({
    this.currentDay = 1,
    this.totalStreakDays = 0,
    this.trophyTier = TrophyTier.bronze,
    this.lastClearedDayKey = '',
    this.cycleSaverUsed = false,
    this.hasSaverOffer = false,
  });

  /// Day index in current 7-day cycle (1..7)
  final int currentDay;
  final int totalStreakDays;
  final TrophyTier trophyTier;
  final String lastClearedDayKey;
  final bool cycleSaverUsed;
  final bool hasSaverOffer;

  static const List<StreakReward> ladder = [
    StreakReward(day: 1, coins: 50),
    StreakReward(day: 2, coins: 75),
    StreakReward(day: 3, coins: 100, booster: Booster.hint),
    StreakReward(day: 4, coins: 150),
    StreakReward(day: 5, coins: 150, booster: Booster.shield),
    StreakReward(day: 6, coins: 200, booster: Booster.hammer),
    StreakReward(
      day: 7,
      coins: 450,
      booster: Booster.hint,
      hasTrophy: true,
    ),
  ];

  StreakReward get todayReward => ladder[(currentDay - 1).clamp(0, 6)];

  StreakState copyWith({
    int? currentDay,
    int? totalStreakDays,
    TrophyTier? trophyTier,
    String? lastClearedDayKey,
    bool? cycleSaverUsed,
    bool? hasSaverOffer,
  }) =>
      StreakState(
        currentDay: currentDay ?? this.currentDay,
        totalStreakDays: totalStreakDays ?? this.totalStreakDays,
        trophyTier: trophyTier ?? this.trophyTier,
        lastClearedDayKey: lastClearedDayKey ?? this.lastClearedDayKey,
        cycleSaverUsed: cycleSaverUsed ?? this.cycleSaverUsed,
        hasSaverOffer: hasSaverOffer ?? this.hasSaverOffer,
      );

  @override
  List<Object?> get props => [
        currentDay,
        totalStreakDays,
        trophyTier,
        lastClearedDayKey,
        cycleSaverUsed,
        hasSaverOffer,
      ];
}

/// Tracks the 7-Day Jungle Streak and Streak Saver Leaf.
class StreakCubit extends Cubit<StreakState> {
  StreakCubit(this._store, this._time, this._wallet, this._ads)
      : super(_load(_store, _time));

  static const _key = 'streak';
  final SaveStore _store;
  final TimeGuard _time;
  final WalletCubit _wallet;
  final AdsCubit _ads;

  static StreakState _load(SaveStore s, TimeGuard t) {
    final j = s.read(_key) ?? const {};
    final dayKey = t.dayKey();
    final lastKey = j['lastClearedDayKey'] as String? ?? '';
    int currentDay = (j['currentDay'] as num?)?.toInt() ?? 1;
    final totalDays = (j['totalStreakDays'] as num?)?.toInt() ?? 0;
    final tierIdx = (j['trophyTier'] as num?)?.toInt() ?? 0;
    bool cycleSaverUsed = j['cycleSaverUsed'] as bool? ?? false;
    bool hasSaverOffer = false;

    if (lastKey.isNotEmpty && lastKey != dayKey) {
      final lastDate = DateTime.tryParse(lastKey);
      final todayDate = DateTime.tryParse(dayKey);
      if (lastDate != null && todayDate != null) {
        final diffDays = todayDate.difference(lastDate).inDays;
        if (diffDays == 2 && !cycleSaverUsed) {
          // Missed exactly 1 day -> offer Streak Saver
          hasSaverOffer = true;
        } else if (diffDays > 1) {
          // Missed 2+ days or saver already used -> reset to Day 1
          currentDay = 1;
          cycleSaverUsed = false;
        }
      }
    }

    return StreakState(
      currentDay: currentDay,
      totalStreakDays: totalDays,
      trophyTier: TrophyTier.values[tierIdx.clamp(0, TrophyTier.values.length - 1)],
      lastClearedDayKey: lastKey,
      cycleSaverUsed: cycleSaverUsed,
      hasSaverOffer: hasSaverOffer,
    );
  }

  void _persist(StreakState s) {
    _store.write(_key, {
      'currentDay': s.currentDay,
      'totalStreakDays': s.totalStreakDays,
      'trophyTier': s.trophyTier.index,
      'lastClearedDayKey': s.lastClearedDayKey,
      'cycleSaverUsed': s.cycleSaverUsed,
    });
  }

  /// Use Streak Saver Leaf via Rewarded Ad
  Future<bool> saveStreakWithAd() async {
    if (!state.hasSaverOffer) return false;
    final ok = await _ads.showRewarded('streak_saver');
    if (!ok) return false;

    final next = state.copyWith(
      hasSaverOffer: false,
      cycleSaverUsed: true,
    );
    emit(next);
    _persist(next);
    return true;
  }

  /// Use Streak Saver Leaf via 200 coins
  bool saveStreakWithCoins() {
    if (!state.hasSaverOffer) return false;
    if (_wallet.state.coins < 200) return false;
    if (!_wallet.spend(200)) return false;

    final next = state.copyWith(
      hasSaverOffer: false,
      cycleSaverUsed: true,
    );
    emit(next);
    _persist(next);
    return true;
  }

  /// Decline the Streak Saver offer, resetting the cycle to Day 1.
  void declineSaver() {
    if (!state.hasSaverOffer) return;
    final next = state.copyWith(
      currentDay: 1,
      hasSaverOffer: false,
      cycleSaverUsed: false,
    );
    emit(next);
    _persist(next);
  }

  /// Called upon completing today's Daily Jungle Challenge
  StreakReward? onDailyCompleted() {
    final todayKey = _time.dayKey();
    if (state.lastClearedDayKey == todayKey) {
      // Already completed today
      return null;
    }

    final reward = state.todayReward;

    // Grant coins & boosters
    _wallet.earn(reward.coins);
    if (reward.booster != null) {
      _wallet.grantBooster(reward.booster!, 1);
    }
    if (state.currentDay == 7) {
      // Day 7 bonus package: 1 Hint + 1 Shield + 1 Hammer
      _wallet.grantBooster(Booster.shield, 1);
      _wallet.grantBooster(Booster.hammer, 1);
    }

    // Advance trophy if completing Day 7
    TrophyTier nextTier = state.trophyTier;
    if (state.currentDay == 7) {
      final nextIdx = (state.trophyTier.index + 1).clamp(0, TrophyTier.values.length - 1);
      nextTier = TrophyTier.values[nextIdx];
    }

    final nextDay = state.currentDay >= 7 ? 1 : state.currentDay + 1;
    final nextState = state.copyWith(
      currentDay: nextDay,
      totalStreakDays: state.totalStreakDays + 1,
      trophyTier: nextTier,
      lastClearedDayKey: todayKey,
      hasSaverOffer: false,
      cycleSaverUsed: state.currentDay >= 7 ? false : state.cycleSaverUsed,
    );

    emit(nextState);
    _persist(nextState);
    return reward;
  }
}
