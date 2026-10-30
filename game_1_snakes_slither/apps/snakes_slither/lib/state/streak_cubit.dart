import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/services.dart';
import '../services/remote_config.dart';
import '../services/time_service.dart';

enum StreakGap { none, sameDay, consecutive, missedOne, missedMany }

class StreakState extends Equatable {
  const StreakState({
    this.day = 0,
    this.cycleSaverUsed = false,
    this.lastClaimDayKey,
    this.totalDays = 0,
    this.trophyTier = 0,
    this.saverDayKey,
  });

  /// Last completed ladder day in the current cycle (0 = none yet).
  final int day;
  final bool cycleSaverUsed;
  final String? lastClaimDayKey;
  final int totalDays;

  /// 0 none, 1 Bronze … 5 Diamond.
  final int trophyTier;

  /// Day on which the Streak Saver Leaf was accepted.
  final String? saverDayKey;

  StreakGap gapTo(String today) {
    final last = lastClaimDayKey;
    if (last == null) return StreakGap.none;
    final d = TimeService.daysBetween(last, today);
    if (d <= 0) return StreakGap.sameDay;
    if (d == 1) return StreakGap.consecutive;
    if (d == 2) return StreakGap.missedOne;
    return StreakGap.missedMany;
  }

  bool continuesOn(String today) {
    final gap = gapTo(today);
    return gap == StreakGap.consecutive || (gap == StreakGap.missedOne && saverDayKey == today);
  }

  /// Ladder day the next clear today would land on.
  int nextDayOn(String today) => continuesOn(today) ? (day % 7) + 1 : 1;

  /// Exactly one missed day, saver unused this cycle, not yet accepted today.
  bool saverOffered(String today) => gapTo(today) == StreakGap.missedOne && !cycleSaverUsed && saverDayKey != today;

  /// Current streak as shown on the Daily card (0 once it is broken).
  int displayDay(String today) {
    final gap = gapTo(today);
    if (gap == StreakGap.sameDay || gap == StreakGap.consecutive) return day;
    if (gap == StreakGap.missedOne && (saverDayKey == today || saverOffered(today))) return day;
    return 0;
  }

  StreakState copyWith({
    int? day,
    bool? cycleSaverUsed,
    String? lastClaimDayKey,
    int? totalDays,
    int? trophyTier,
    String? saverDayKey,
  }) =>
      StreakState(
        day: day ?? this.day,
        cycleSaverUsed: cycleSaverUsed ?? this.cycleSaverUsed,
        lastClaimDayKey: lastClaimDayKey ?? this.lastClaimDayKey,
        totalDays: totalDays ?? this.totalDays,
        trophyTier: trophyTier ?? this.trophyTier,
        saverDayKey: saverDayKey ?? this.saverDayKey,
      );

  Map<String, Object?> toJson() => {
        'day': day,
        'cycleSaverUsed': cycleSaverUsed,
        'lastClaimDayKey': lastClaimDayKey,
        'totalDays': totalDays,
        'trophyTier': trophyTier,
        'saverDayKey': saverDayKey,
      };

  static StreakState fromJson(Map<String, Object?> j) => StreakState(
        day: (j['day'] as int?) ?? 0,
        cycleSaverUsed: (j['cycleSaverUsed'] as bool?) ?? false,
        lastClaimDayKey: j['lastClaimDayKey'] as String?,
        totalDays: (j['totalDays'] as int?) ?? 0,
        trophyTier: (j['trophyTier'] as int?) ?? 0,
        saverDayKey: j['saverDayKey'] as String?,
      );

  @override
  List<Object?> get props => [day, cycleSaverUsed, lastClaimDayKey, totalDays, trophyTier, saverDayKey];
}

class StreakAdvance {
  const StreakAdvance(this.day, this.reward, {required this.trophyUp});
  final int day;
  final StreakReward reward;
  final bool trophyUp;
}

/// 7-day Jungle Streak: ladder, Streak Saver Leaf and Golden Coil Trophy.
class StreakCubit extends Cubit<StreakState> {
  StreakCubit(this._s) : super(StreakState.fromJson(_s.save.section('streak')));

  final AppServices _s;

  /// Advances the streak on the first Daily clear of [today]. Null if already claimed.
  StreakAdvance? onDailyClear(String today) {
    if (state.gapTo(today) == StreakGap.sameDay) return null;
    final continues = state.continuesOn(today);
    final next = state.nextDayOn(today);
    final trophyUp = next == 7;
    _set(state.copyWith(
      day: next,
      // A new cycle starts on Day 1 and gets its own saver.
      cycleSaverUsed: continues ? state.cycleSaverUsed : false,
      lastClaimDayKey: today,
      totalDays: state.totalDays + 1,
      trophyTier: trophyUp ? (state.trophyTier + 1).clamp(0, 5) : state.trophyTier,
    ));
    _s.analytics.event('streak_update', {'day': next});
    return StreakAdvance(next, streakLadder[next - 1], trophyUp: trophyUp);
  }

  void useSaver(String today, {required String via}) {
    _set(state.copyWith(saverDayKey: today, cycleSaverUsed: true));
    _s.analytics.event('streak_saver', {'via': via});
  }

  void _set(StreakState next) {
    emit(next);
    _s.save.write('streak', next.toJson());
  }
}
