// SHARED CONTRACT. How UI widgets ask for a sound or a haptic tick without
// touching services. Logic provides the real one at the app root; when none
// is provided (tests, previews) calls do nothing.
import 'package:flutter/widgets.dart';

/// UI-only sounds. Gameplay sounds (exit, bonk, shield…) are played by logic.
enum UiSound { tap, popupOpen, coinsFly, starPop, spinTick, giftOpen, countdown }

abstract class UiFeedback {
  /// Respects the player's Sound setting.
  void sound(UiSound s);

  /// Light tap; respects the player's Haptics setting.
  void haptic();

  static UiFeedback of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UiFeedbackScope>()?.feedback ?? const _Silent();
}

class UiFeedbackScope extends InheritedWidget {
  const UiFeedbackScope({super.key, required this.feedback, required super.child});
  final UiFeedback feedback;
  @override
  bool updateShouldNotify(UiFeedbackScope old) => old.feedback != feedback;
}

class _Silent implements UiFeedback {
  const _Silent();
  @override
  void sound(UiSound s) {}
  @override
  void haptic() {}
}
