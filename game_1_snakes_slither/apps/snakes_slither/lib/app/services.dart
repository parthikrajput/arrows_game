import 'package:flutter/widgets.dart';

import '../data/levels/level_repository.dart';
import '../data/save/save_repository.dart';
import '../services/ads_service.dart';
import '../services/analytics.dart';
import '../services/audio_service.dart';
import '../services/haptics.dart';
import '../services/remote_config.dart';
import '../services/store_service.dart';
import '../services/time_service.dart';

/// Everything below the blocs, created once at startup and provided at the root.
class AppServices {
  AppServices({
    required this.navigatorKey,
    required this.save,
    required this.time,
    required this.audio,
    required this.haptics,
    required this.analytics,
    required this.ads,
    required this.store,
    required this.levels,
    this.config = const EconomyConfig(),
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final SaveRepository save;
  final TimeService time;
  final AudioService audio;
  final Haptics haptics;
  final Analytics analytics;
  final AdsService ads;
  final StoreService store;
  final LevelRepository levels;
  final EconomyConfig config;
}
