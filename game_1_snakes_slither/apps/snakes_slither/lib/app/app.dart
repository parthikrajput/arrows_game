import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/ads_cubit.dart';
import '../state/daily_cubit.dart';
import '../state/leaderboard_cubit.dart';
import '../state/progress_cubit.dart';
import '../state/settings_cubit.dart';
import '../state/shop_cubit.dart';
import '../state/spin_cubit.dart';
import '../state/streak_cubit.dart';
import '../state/wallet_cubit.dart';
import 'routes.dart';
import 'services.dart';
import 'theme/app_theme.dart';

class SnakesSlitherApp extends StatelessWidget {
  const SnakesSlitherApp({super.key, required this.services});
  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: services,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SettingsCubit(services), lazy: false),
          BlocProvider(create: (_) => WalletCubit(services), lazy: false),
          BlocProvider(create: (_) => ProgressCubit(services), lazy: false),
          BlocProvider(create: (_) => AdsCubit(services), lazy: false),
          BlocProvider(create: (_) => StreakCubit(services)),
          BlocProvider(create: (_) => DailyCubit(services)),
          BlocProvider(create: (_) => SpinCubit(services)),
          BlocProvider(create: (_) => LeaderboardCubit(services)),
          BlocProvider(create: (c) => ShopCubit(services, c.read<WalletCubit>(), c.read<AdsCubit>())),
        ],
        child: Builder(builder: (context) {
          final askAge = !context.read<SettingsCubit>().state.ageAnswered;
          return MaterialApp(
            title: 'Snakes Slither',
            debugShowCheckedModeBanner: false,
            navigatorKey: services.navigatorKey,
            theme: buildAppTheme(),
            initialRoute: askAge ? Routes.ageGate : Routes.home,
            onGenerateRoute: Routes.generate,
            builder: (context, child) => _AppFrame(child: child ?? const SizedBox()),
          );
        }),
      ),
    );
  }
}

/// Applies Settings → Reduced motion on top of the system setting, clamps the
/// text scale for menus, and flushes the save when the app goes to the background.
class _AppFrame extends StatefulWidget {
  const _AppFrame({required this.child});
  final Widget child;

  @override
  State<_AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<_AppFrame> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused) context.read<AppServices>().save.flush();
    if (s == AppLifecycleState.resumed) context.read<AdsCubit>().rollDay();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = context.select((SettingsCubit c) => c.state.reducedMotion);
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        disableAnimations: mq.disableAnimations || reduced,
        textScaler: mq.textScaler.clamp(maxScaleFactor: 2.0),
      ),
      child: widget.child,
    );
  }
}
