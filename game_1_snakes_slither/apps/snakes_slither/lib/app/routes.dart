import 'package:flutter/material.dart';

import '../features/daily/daily_page.dart';
import '../features/gameplay/view/gameplay_page.dart';
import '../features/home/home_page.dart';
import '../features/leaderboards/leaderboards_page.dart';
import '../features/level_map/level_map_page.dart';
import '../features/onboarding/age_gate_page.dart';
import '../features/rewards/phase_complete_page.dart';
import '../features/settings/settings_page.dart';
import '../features/shop/shop_page.dart';
import '../features/spin/spin_page.dart';
import '../features/vip/vip_page.dart';

abstract final class Routes {
  static const home = '/';
  static const ageGate = '/age';
  static const map = '/map';
  static const play = '/play';
  static const daily = '/daily';
  static const spin = '/spin';
  static const shop = '/shop';
  static const vip = '/vip';
  static const leaderboards = '/leaderboards';
  static const settings = '/settings';
  static const phaseComplete = '/phase-complete';

  static Route<dynamic> generate(RouteSettings s) {
    return switch (s.name) {
      ageGate => _fade(s, const AgeGatePage()),
      map => _slide(s, LevelMapPage(focusLevel: s.arguments as int?)),
      play => _fade(s, GameplayPage(args: s.arguments! as GameArgs)),
      daily => _slide(s, const DailyPage()),
      spin => _slide(s, const SpinPage()),
      shop => _slide(s, ShopPage(initialTab: (s.arguments as int?) ?? 0)),
      vip => _slide(s, const VipPage()),
      leaderboards => _slide(s, const LeaderboardsPage()),
      settings => _slide(s, const SettingsPage()),
      phaseComplete => _fade(s, const PhaseCompletePage()),
      _ => _fade(s, const HomePage()),
    };
  }

  static Route<T> _fade<T>(RouteSettings s, Widget page) => PageRouteBuilder<T>(
        settings: s,
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, a, _, child) {
          final c = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: c,
            child: ScaleTransition(scale: Tween(begin: 1.04, end: 1.0).animate(c), child: child),
          );
        },
      );

  static Route<T> _slide<T>(RouteSettings s, Widget page) => PageRouteBuilder<T>(
        settings: s,
        transitionDuration: const Duration(milliseconds: 340),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, _, _) => page,
        transitionsBuilder: (_, a, sa, child) {
          final c = CurvedAnimation(parent: a, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
          return FadeTransition(
            opacity: c,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(c),
              child: child,
            ),
          );
        },
      );
}
