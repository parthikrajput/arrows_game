import 'package:flutter/services.dart';

/// Flutter `HapticFeedback` only; Settings → Haptics off means no calls at all.
class Haptics {
  bool enabled = true;

  void light() {
    if (enabled) HapticFeedback.lightImpact();
  }

  void medium() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  void heavy() {
    if (enabled) HapticFeedback.heavyImpact();
  }

  void selection() {
    if (enabled) HapticFeedback.selectionClick();
  }
}
