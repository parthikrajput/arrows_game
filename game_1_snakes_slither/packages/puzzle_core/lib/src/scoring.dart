/// Stars for a win (standard §4).
///
/// Shield-absorbed events are not hearts lost. Any revive or Heart Refill caps the result at 1.
int starsFor({required int heartsLost, required bool usedRevive, int? parMoves, int moves = 0}) {
  var stars = usedRevive || heartsLost >= 2 ? 1 : (heartsLost == 1 ? 2 : 3);
  if (parMoves != null && moves > parMoves) stars -= 1;
  return stars < 1 ? 1 : stars;
}
