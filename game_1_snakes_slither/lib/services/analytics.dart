import '../logging/app_logger.dart';

/// Where analytics events go besides the local log (Firebase Analytics in
/// release builds once the Firebase project is configured).
abstract class AnalyticsBackend {
  void logEvent(String name, Map<String, Object> params);
  void setChildDirected(bool on);
}

/// Product analytics. Only the agreed event names are accepted, so a typo
/// can't create a new event in the dashboard.
class Analytics {
  Analytics({this.backend});

  AnalyticsBackend? backend;

  /// Core events every game sends.
  static const core = {
    'level_start',
    'level_win',
    'level_fail',
    'booster_use',
    'revive',
    'ad_show',
    'iap_purchase',
    'daily_clear',
    'streak_update',
    'ftue_step',
  };

  /// Snakes Slither events.
  static const custom = {
    'coins_earn',
    'coins_spend',
    'gift_open',
    'chest_open',
    'rush_end',
    'spin_result',
    'streak_saver',
    'time_lock',
    'hint_fail',
    'ad_fail',
  };

  /// Last events, newest last, for tests and "Report a problem".
  final recent = <(String, Map<String, Object>)>[];

  void log(String name, [Map<String, Object> params = const {}]) {
    if (!core.contains(name) && !custom.contains(name)) {
      assert(false, 'Unknown analytics event "$name"');
      return;
    }
    recent.add((name, params));
    if (recent.length > 200) recent.removeAt(0);
    AppLogger.instance.debug('analytics', 'A-EVENT', name, params);
    backend?.logEvent(name, params);
  }

  /// Under-13 players: no ad personalisation in analytics.
  void setChildDirected(bool on) => backend?.setChildDirected(on);
}
