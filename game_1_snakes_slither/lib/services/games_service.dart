import 'package:games_services/games_services.dart' as gs;

import '../logging/app_logger.dart';

/// The three Phase 1 leaderboards.
enum Board { highestLevel, totalStars, streakDays }

/// Google Play Games / Game Center.
abstract class GamesService {
  bool get available;
  Future<bool> signIn();
  Future<void> submit(Board board, int score);
  Future<void> show(Board board);
}

/// Real leaderboards. Board ids come from Play Console / App Store Connect
/// at build time (`--dart-define=LB_LEVEL=… LB_STARS=… LB_STREAK=…`).
class PlatformGamesService implements GamesService {
  static const _ids = {
    Board.highestLevel: String.fromEnvironment('LB_LEVEL'),
    Board.totalStars: String.fromEnvironment('LB_STARS'),
    Board.streakDays: String.fromEnvironment('LB_STREAK'),
  };

  /// True when the store ids were set for this build.
  static bool get configured => _ids.values.every((v) => v.isNotEmpty);

  bool _signedIn = false;

  @override
  bool get available => configured;

  @override
  Future<bool> signIn() async {
    if (!configured) return false;
    try {
      await gs.GameAuth.signIn();
      _signedIn = await gs.GameAuth.isSignedIn;
    } catch (e) {
      AppLogger.instance.warn('games', 'W-GAMES-001', 'sign-in failed', {'error': '$e'});
      _signedIn = false;
    }
    return _signedIn;
  }

  @override
  Future<void> submit(Board board, int score) async {
    if (!_signedIn) return;
    try {
      final id = _ids[board]!;
      await gs.Leaderboards.submitScore(score: gs.Score(androidLeaderboardID: id, iOSLeaderboardID: id, value: score));
    } catch (e) {
      AppLogger.instance.warn('games', 'W-GAMES-002', 'submit failed', {'board': board.name, 'error': '$e'});
    }
  }

  @override
  Future<void> show(Board board) async {
    if (!_signedIn && !await signIn()) return;
    final id = _ids[board]!;
    await gs.Leaderboards.showLeaderboards(androidLeaderboardID: id, iOSLeaderboardID: id);
  }
}

/// Builds without leaderboard ids (and tests): only local stats show.
class LocalGamesService implements GamesService {
  final submitted = <Board, int>{};
  @override
  bool get available => false;
  @override
  Future<bool> signIn() async => false;
  @override
  Future<void> submit(Board board, int score) async => submitted[board] = score;
  @override
  Future<void> show(Board board) async {}
}
