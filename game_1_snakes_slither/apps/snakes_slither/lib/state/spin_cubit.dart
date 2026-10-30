import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../app/services.dart';
import '../services/remote_config.dart';

class SpinState extends Equatable {
  const SpinState({this.lastFreeDayKey});
  final String? lastFreeDayKey;

  bool freeUsed(String today) => lastFreeDayKey == today;

  @override
  List<Object?> get props => [lastFreeDayKey];
}

/// Lucky Lily Wheel: 1 free + 1 rewarded spin per day, server-free results.
class SpinCubit extends Cubit<SpinState> {
  SpinCubit(this._s) : super(SpinState(lastFreeDayKey: _s.save.section('spin')['lastFreeDayKey'] as String?));

  final AppServices _s;

  bool unlocked(int highestCleared) => highestCleared >= _s.config.spinUnlockLevel;

  /// Same install + day + spin index ⇒ same segment.
  static int resultIndex(String installId, String dayKey, int spinIndex) {
    final rng = Xoshiro128ss(Hash64.of([installId, dayKey, '$spinIndex']).seed());
    var roll = rng.nextInt(1000);
    for (var i = 0; i < spinPrizes.length; i++) {
      roll -= spinPrizes[i].weight;
      if (roll < 0) return i;
    }
    return 0;
  }

  /// Marks the free spin used and returns the winning segment.
  int spinFree(String installId) {
    final today = _s.time.dayKey();
    emit(SpinState(lastFreeDayKey: today));
    _s.save.write('spin', {'lastFreeDayKey': today});
    final i = resultIndex(installId, today, 0);
    _s.analytics.event('spin_result', {'segment': i + 1, 'via': 'free'});
    return i;
  }

  int spinAd(String installId) {
    final i = resultIndex(installId, _s.time.dayKey(), 1);
    _s.analytics.event('spin_result', {'segment': i + 1, 'via': 'ad'});
    return i;
  }
}
