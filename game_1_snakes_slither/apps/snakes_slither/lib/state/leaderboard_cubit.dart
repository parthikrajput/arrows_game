import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/services.dart';

enum Board { highestLevel, totalStars, streakDays }

class LeaderboardState extends Equatable {
  const LeaderboardState({this.signedIn = false, this.pending = const {}});

  final bool signedIn;

  /// Best value per board waiting to be submitted (offline queue).
  final Map<Board, int> pending;

  @override
  List<Object?> get props => [signedIn, pending];
}

/// Play Games / Game Center seam. Scores queue locally until a session exists.
class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._s) : super(const LeaderboardState());

  final AppServices _s;

  void submit(Board board, int value) {
    final prev = state.pending[board] ?? 0;
    if (value <= prev) return;
    emit(LeaderboardState(signedIn: state.signedIn, pending: {...state.pending, board: value}));
    if (state.signedIn) _flush();
  }

  Future<bool> signIn() async {
    // games_services sign-in goes here once the platform ids are configured.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return false;
  }

  void _flush() {
    _s.analytics.event('leaderboard_flush', {for (final e in state.pending.entries) e.key.name: e.value});
  }
}
