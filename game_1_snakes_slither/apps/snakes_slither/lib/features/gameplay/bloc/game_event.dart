sealed class GameEvent {
  const GameEvent();
}

class SnakeTapped extends GameEvent {
  const SnakeTapped(this.snakeId);
  final String snakeId;
}

class AnimationCompleted extends GameEvent {
  const AnimationCompleted(this.seq);
  final int seq;
}

class HintRequested extends GameEvent {
  const HintRequested();
}

class ShieldActivated extends GameEvent {
  const ShieldActivated();
}

class HammerModeToggled extends GameEvent {
  const HammerModeToggled();
}

class ReviveGranted extends GameEvent {
  const ReviveGranted({required this.viaAd});
  final bool viaAd;
}

class ReviveDeclined extends GameEvent {
  const ReviveDeclined();
}

class Restarted extends GameEvent {
  const Restarted();
}
