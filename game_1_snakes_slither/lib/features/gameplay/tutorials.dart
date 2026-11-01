import '../../contracts/view_models.dart';
import '../../data/mechanic_info.dart';
import '../../state/tutorial_cubit.dart';
import 'game_bloc.dart';

/// Which booster or HUD part a tip points at.
enum TipFocus { none, hint, shield, hammer, hearts, moves }

class Tip {
  const Tip(this.data, {this.focus = TipFocus.none});
  final TutorialTipData data;
  final TipFocus focus;
}

/// FTUE L1–L10 and the L15 / L25 booster tips. One tip per level, shown
/// once; a few finish by doing the step instead of tapping "Got it".
class Tutorials {
  const Tutorials._();

  /// L1: only the glowing snake can be tapped.
  static bool guidedTaps(int level, TutorialState t) => level == 1 && !t.has('1_tap_to_slither');

  /// L1–L2: the hand points at the next snake of the stored solution.
  static bool showsHand(int level, TutorialState t) =>
      (level == 1 && !t.has('1_tap_to_slither')) || (level == 2 && !t.has('2_order_matters'));

  static Tip? tipFor(GameState s, TutorialState t) {
    final lv = s.level.number;
    final a = s.attempt;
    TutorialTipData tip(String id, String title, String body, {bool gotIt = true}) =>
        TutorialTipData(id: id, level: lv, title: title, body: body, showGotIt: gotIt);
    switch (lv) {
      case 1 when !t.has('1_tap_to_slither'):
        return Tip(tip('1_tap_to_slither', 'Tap a snake to slither out!', 'Only the glowing snake can be tapped right now.', gotIt: false));
      case 2 when a.heartsLost > 0 && !t.has('2_bonk'):
        return Tip(
          tip('2_bonk', 'Ouch! A bonk costs 1 Heart Berry.', 'A snake bonks when something is in its way. Free the snake in front first.'),
          focus: TipFocus.hearts,
        );
      case 2 when !t.has('2_order_matters') && a.heartsLost == 0:
        return Tip(tip('2_order_matters', 'Order matters', 'Tap the snake with a clear path first, then the others can follow.', gotIt: false));
      case 3 when !t.has('3_hint') && a.usesOf(Booster.hint) == 0:
        return Tip(
          tip('3_hint', 'Stuck? Ask the Glow Firefly', 'Tap the Firefly and it lights up the next snake to move. Here are 3 free!', gotIt: false),
          focus: TipFocus.hint,
        );
      case 4 when !t.has('4_hearts'):
        return Tip(
          tip('4_hearts', 'Your Heart Berries', 'You have 3 per try. Run out and you get a Second Chance to keep going.'),
          focus: TipFocus.hearts,
        );
      case 5 when !t.has('5_preview'):
        return Tip(tip('5_preview', 'Peek before you tap', 'Press and hold a snake to see its path: green is clear, red is blocked. It\'s free!'));
      case 6 when !t.has('6_tap_anywhere'):
        return Tip(tip('6_tap_anywhere', 'Tap anywhere on a snake', 'Head, middle or tail, any part works. Caterpillars slither the same way!'));
      case 7 when !t.has('7_moves'):
        return Tip(
          tip('7_moves', 'Count your moves', 'Every slither and every bonk is one move. Peeking is free.'),
          focus: TipFocus.moves,
        );
      case 8 when !t.has('8_curved_path'):
        return Tip(tip('8_curved_path', 'Curvy snakes', 'A curvy snake still leaves head first, straight ahead. Plan the order!'));
      case 9 when !t.has('9_think_ahead'):
        return Tip(tip('9_think_ahead', 'Think ahead', 'Free the snake that unblocks the most others first.'));
      case 10 when !t.has('10_gift_basket'):
        return Tip(tip('10_gift_basket', 'A gift awaits!', 'Finish this level to open your first Jungle Gift Basket.'));
      case 15 when !t.has('b_shield'):
        return Tip(
          tip('b_shield', 'New: Safety Shell Shield', 'It blocks your next 2 bonks, so no heart berry is lost. Here\'s 1 free!'),
          focus: TipFocus.shield,
        );
      case 25 when !t.has('b_hammer'):
        return Tip(
          tip('b_hammer', 'New: Magic Stone Hammer', 'Tap it, then tap a snake or a rock to smash it away. Here\'s 1 free!'),
          focus: TipFocus.hammer,
        );
    }
    return null;
  }

  /// Steps that finish when the player does them.
  static List<String> doneBy(GameState s) => [
    if (s.status == GameStatus.won && s.level.number == 1) '1_tap_to_slither',
    if (s.status == GameStatus.won && s.level.number == 2) '2_order_matters',
    if (s.level.number == 3 && s.attempt.usesOf(Booster.hint) > 0) '3_hint',
    if (s.level.number == 5 && s.preview != null) '5_preview',
  ];

  /// The "NEW!" card for the mechanic this level introduces, if unseen.
  static MechanicIntroData? introFor(int level, String? type, TutorialState t) {
    if (type == null || t.has(type)) return null;
    return card(type, level);
  }

  static MechanicIntroData? card(String type, int level) {
    final info = mechanicInfo[type];
    if (info == null) return null;
    return MechanicIntroData(type: type, level: level, name: info.name, rule: info.rule, heartNote: info.heartNote);
  }
}
