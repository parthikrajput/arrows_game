import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../contracts/view_models.dart';
import '../data/level_repository.dart';
import '../features/gameplay/gameplay_route.dart';
import '../features/meta/shop_route.dart';
import '../features/meta/wheel_route.dart';
import '../state/ads_cubit.dart';
import '../state/progress_cubit.dart';
import '../state/settings_cubit.dart';
import '../state/wallet_cubit.dart';
import '../state/wheel_cubit.dart';
import '../ui/popups/popups.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/level_map_screen.dart';

GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(path: '/', builder: (c, _) => const _HomeRoute()),
    GoRoute(path: '/map', builder: (c, _) => const _MapRoute()),
    GoRoute(path: '/settings', builder: (c, _) => const _SettingsRoute()),
    GoRoute(path: '/shop', builder: (c, _) => const ShopRoute()),
    GoRoute(path: '/wheel', builder: (c, _) => const WheelRoute()),
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
    return HomeScreen(
      data: HomeData(
        coins: coins,
        nextLevel: next,
        allCleared: !repo.exists(next),
        wheelUnlocked: wheel.unlocked,
        freeSpinReady: wheel.freeAvailable,
        vipActive: ads.vipActive,
      ),
      onPlay: () => context.go('/play/$next'),
      onOpenMap: () => context.go('/map'),
      onOpenSettings: () => context.go('/settings'),
      onOpenShop: () => context.go('/shop'),
      onOpenWheel: () => context.go('/wheel'),
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
            isHard: repo.load(n).tag.name == 'hard',
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(onPressed: () => context.go('/')),
      title: const Text('Settings'),
    ),
    body: SingleChildScrollView(
      child: SettingsList(
        settings: context.watch<SettingsCubit>().state,
        onToggle: context.read<SettingsCubit>().toggle,
      ),
    ),
  );
}
