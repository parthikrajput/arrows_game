import '../core/logging/app_logger.dart';

/// Analytics events (standard §15 + game additions). Forwards to Firebase
/// Analytics once configured; logs locally until then.
class Analytics {
  bool enabled = true;

  void event(String name, [Map<String, Object?> params = const {}]) {
    if (!enabled) return;
    log.d('analytics $name $params');
  }
}
