import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../contracts/view_models.dart';
import '../data/daily_level_factory.dart';
import '../data/level_repository.dart';
import '../features/gameplay/gameplay_route.dart';
import '../features/gameplay/tutorials.dart';
import '../features/meta/daily_route.dart';
import '../features/meta/shop_route.dart';
import '../features/meta/wheel_route.dart';
import '../features/rush/rush_route.dart';
import '../logging/app_logger.dart';
import '../services/games_service.dart';
import '../services/time_guard.dart';
import '../state/ads_cubit.dart';
import '../state/compliance_cubit.dart';
import '../state/daily_cubit.dart';
import '../state/iap_cubit.dart';
import '../state/progress_cubit.dart';
import '../state/rewards.dart';
import '../state/settings_cubit.dart';
import '../state/streak_cubit.dart';
import '../state/tutorial_cubit.dart';
import '../state/wallet_cubit.dart';
import '../state/wheel_cubit.dart';
import '../ui/screens/age_gate_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/leaderboards_screen.dart';
import '../ui/screens/level_map_screen.dart';
import '../ui/screens/phase_complete_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/vip_screen.dart';
import '../ui/theme/tokens.dart';

GoRouter buildRouter() => GoRouter(
  // First launch answers the neutral age question before anything else.
  redirect: (c, st) {
    final done = c.read<ComplianceCubit>().state.ageGateDone;
    if (!done && st.matchedLocation != '/age') return '/age';
    if (done && st.matchedLocation == '/age') return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/age',
      builder: (c, _) => AgeGateScreen(
        currentYear: c.read<TimeGuard>().clock.now().year,
        onSubmit: (y) {
          c.read<ComplianceCubit>().submitBirthYear(y, currentYear: c.read<TimeGuard>().clock.now().year);
          c.go('/');
        },
      ),
    ),
    GoRoute(path: '/', builder: (c, _) => const _HomeRoute()),
    GoRoute(path: '/map', builder: (c, _) => const _MapRoute()),
    GoRoute(path: '/settings', builder: (c, _) => const _SettingsRoute()),
    GoRoute(path: '/shop', builder: (c, _) => const ShopRoute()),
    GoRoute(path: '/vip', builder: (c, _) => const VipRoute()),
    GoRoute(path: '/ranks', builder: (c, _) => const _RanksRoute()),
    GoRoute(path: '/wheel', builder: (c, _) => const WheelRoute()),
    GoRoute(path: '/daily', builder: (c, _) => const DailyRoute()),
    GoRoute(
      path: '/rush/:n',
      builder: (c, st) => RushRoute(afterLevel: int.tryParse(st.pathParameters['n']!) ?? 25),
    ),
    GoRoute(path: '/phase-complete', builder: (c, _) => const _PhaseCompleteRoute()),
    GoRoute(
      path: '/daily/play',
      builder: (c, _) {
        final daily = c.read<DailyCubit>();
        final time = c.read<TimeGuard>();
        final progress = c.read<ProgressCubit>();
        final date = time.clock.now();
        final level = DailyLevelFactory.buildDailyLevel(
          dayKey: daily.state.dayKey,
          date: date,
          modifier: daily.state.modifier,
          highestCleared: progress.state.highestCleared,
        );
        return GameplayRoute(
          levelNumber: 0,
          customLevel: level,
          isDaily: true,
        );
      },
    ),
    GoRoute(
      path: '/play/:n',
      builder: (c, st) => GameplayRoute(levelNumber: int.tryParse(st.pathParameters['n']!) ?? 0),
    ),
  ],
);

class _HomeRoute extends StatelessWidget {
  const _HomeRoute();
  @override
  Widget build(BuildContext context) {
    final coins = context.watch<WalletCubit>().state.coins;
    final progress = context.watch<ProgressCubit>().state;
    final repo = context.read<LevelRepository>();
    final next = progress.nextLevel;
    context.watch<WheelCubit>(); // rebuild on spins
    final wheel = context.read<WheelCubit>();
    final ads = context.watch<AdsCubit>();
    final daily = context.watch<DailyCubit>().state;
    final streak = context.watch<StreakCubit>().state;
    final iap = context.watch<IapCubit>();
    final tutorial = context.watch<TutorialCubit>();
    final starter = tutorial.state.has('starter_popup') ? null : starterOffer(iap);

    final home = HomeScreen(
      data: HomeData(
        coins: coins,
        nextLevel: next,
        allCleared: !repo.exists(next),
        wheelUnlocked: wheel.unlocked,
        freeSpinReady: wheel.freeAvailable,
        vipActive: ads.vipActive,
        dailyUnlocked: daily.unlocked,
        dailyTitle: daily.dayKey,
        dailyModifier: daily.modifier.label,
        dailyStreak: streak.totalStreakDays,
        dailyCompleted: daily.completed,
      ),
      onPlay: () => context.go('/play/$next'),
      onOpenMap: () => context.go('/map'),
      onOpenSettings: () => context.go('/settings'),
      onOpenShop: () => context.go('/shop'),
      onOpenWheel: () => context.go('/wheel'),
      onOpenDaily: () => context.go('/daily'),
      onOpenLeaderboards: () => context.go('/ranks'),
      banner: ads.bannerFor(next) ? ads.service.banner() : null,
      bannerHeight: ads.bannerFor(next) ? AdsCubit.bannerReserve : 0,
    );
    if (starter == null) return home;
    // Shown once after L15; the offer stays in Shop › Offers until it ends.
    return Stack(
      children: [
        home,
        const ModalBarrier(color: AppColors.scrim, dismissible: false),
        StarterPackPopup(
          data: starter,
          onBuy: () {
            tutorial.markSeen('starter_popup');
            iap.buy(starter.productId);
          },
          onClose: () => tutorial.markSeen('starter_popup'),
        ),
      ],
    );
  }
}

class _MapRoute extends StatelessWidget {
  const _MapRoute();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressCubit>().state;
    final repo = context.read<LevelRepository>();
    return LevelMapScreen(
      nodes: [
        for (var n = 1; n <= repo.count; n++)
          LevelNodeData(
            number: n,
            state: !p.isUnlocked(n)
                ? NodeState.locked
                : p.isCleared(n)
                ? NodeState.cleared
                : NodeState.current,
            stars: p.starsFor(n),
            isHard: repo.tagOf(n).name == 'hard',
            isIntro: repo.introducesMechanic(n) != null,
          ),
      ],
      onLevelTap: (n) {
        if (p.isUnlocked(n)) context.go('/play/$n');
      },
      onBack: () => context.go('/'),
    );
  }
}

/// Home settings: same list as Pause, without Resume/Restart.
class _SettingsRoute extends StatelessWidget {
  const _SettingsRoute();
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>();
    final progress = context.watch<ProgressCubit>().state;
    final repo = context.read<LevelRepository>();
    return SettingsScreen(
      settings: settings.state,
      onToggle: settings.toggle,
      onBack: () => context.go('/'),
      onLanguage: settings.setLanguage,
      guide: [
        for (var n = 1; n <= math.min(progress.nextLevel, repo.count); n++)
          if (repo.introducesMechanic(n) case final type?) ?Tutorials.card(type, n),
      ],
      odds: [
        for (final p in LuckyWheel.prizes)
          WheelSegmentData(label: p.booster == null ? '${p.label} coins' : '1 ${p.label}', odds: p.odds),
      ],
      onPrivacyChoices: () => context.read<AdsCubit>().service.showPrivacyOptions(),
      onRestorePurchases: () => context.read<IapCubit>().restore(),
      onReportProblem: () => reportProblem(context),
    );
  }
}

/// Copies a short report for support. The log is added only when the
/// player turned on "Share diagnostics".
Future<void> reportProblem(BuildContext context) async {
  final settings = context.read<SettingsCubit>().state;
  final progress = context.read<ProgressCubit>().state;
  final b = StringBuffer()
    ..writeln('Snakes Slither problem report')
    ..writeln('Version: 1.0.0')
    ..writeln('Platform: ${defaultTargetPlatform.name}')
    ..writeln('Highest level: ${progress.highestCleared}')
    ..writeln('Language: ${settings.language}');
  if (settings.shareDiagnostics) {
    b.writeln('--- recent log ---');
    for (final e in AppLogger.instance.getRecentLogs(80)) {
      b.writeln(e);
    }
  }
  await Clipboard.setData(ClipboardData(text: b.toString()));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        settings.shareDiagnostics
            ? 'Report and log copied. Paste them in a message from the store page.'
            : 'Report copied. Turn on Share diagnostics to add the log.',
      ),
    ),
  );
}

class _PhaseCompleteRoute extends StatelessWidget {
  const _PhaseCompleteRoute();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressCubit>().state;
    final repo = context.read<LevelRepository>();
    var stars = 0;
    for (var n = 1; n <= repo.count; n++) {
      stars += p.starsFor(n);
    }
    return PhaseCompleteScreen(
      stars: stars,
      maxStars: repo.count * 3,
      onReplay: () => context.go('/map'),
      onHome: () => context.go('/'),
    );
  }
}

class _RanksRoute extends StatelessWidget {
  const _RanksRoute();
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressCubit>().state;
    final streak = context.watch<StreakCubit>().state;
    final games = context.read<GamesService>();
    var stars = 0;
    for (final e in p.bestStars.entries) {
      if (e.key <= 500) stars += e.value;
    }
    return LeaderboardsScreen(
      highestLevel: p.highestCleared,
      totalStars: stars,
      streakDays: streak.totalStreakDays,
      online: games.available,
      onOpenBoard: (i) => games.show(Board.values[i]),
      onBack: () => context.go('/'),
    );
  }
}
