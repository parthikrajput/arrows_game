import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../../contracts/view_models.dart';
import '../../data/level_repository.dart';
import '../../services/audio_service.dart';
import '../../services/time_guard.dart';
import '../../state/ads_cubit.dart';
import '../../state/daily_cubit.dart';
import '../../state/economy.dart';
import '../../state/progress_cubit.dart';
import '../../state/settings_cubit.dart';
import '../../state/streak_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../../ui/popups/popups.dart';
import '../../ui/screens/gameplay_screen.dart';
import '../../ui/theme/tokens.dart';
import 'board_input.dart';
import 'game_bloc.dart';

/// Loads a level and connects GameBloc to the gameplay screen and popups.
class GameplayRoute extends StatelessWidget {
  const GameplayRoute({
    super.key,
    required this.levelNumber,
    this.customLevel,
    this.isDaily = false,
  });

  final int levelNumber;
  final Level? customLevel;
  final bool isDaily;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<LevelRepository>();
    final Level level;
    if (customLevel != null) {
      level = customLevel!;
    } else {
      try {
        level = repo.load(levelNumber);
      } catch (_) {
        // Never skip or auto-clear a broken level; offer a way out instead.
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Level unavailable'),
                TextButton(onPressed: () => context.go('/'), child: const Text('Home')),
              ],
            ),
          ),
        );
      }
    }
    return BlocProvider(
      key: ValueKey(isDaily ? 'daily' : levelNumber),
      create: (c) => GameBloc(
        level: level,
        wallet: c.read<WalletCubit>(),
        progress: c.read<ProgressCubit>(),
        ads: c.read<AdsCubit>(),
        hasNextLevel: isDaily ? false : repo.exists(levelNumber + 1),
      ),
      child: _GameplayView(isDaily: isDaily),
    );
  }
}

class _GameplayView extends StatefulWidget {
  const _GameplayView({this.isDaily = false});
  final bool isDaily;

  @override
  State<_GameplayView> createState() => _GameplayViewState();
}

class _GameplayViewState extends State<_GameplayView> {
  late final AppLifecycleListener _life = AppLifecycleListener(
    onHide: () => context.read<GameBloc>().add(const Paused()),
  );

  @override
  void initState() {
    super.initState();
    _life; // start listening
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  bool _showGift = false;
  bool _winRecorded = false;

  WinContext _winContext(LevelCompleteData r) => WinContext(
    level: r.level,
    hasGiftBasket: r.gift != null && !r.gift!.isChest,
    hasChest: r.gift?.isChest ?? false,
  );

  Future<void> _afterRewards(BuildContext context, LevelCompleteData r) async {
    final router = GoRouter.of(context);
    await context.read<AdsCubit>().maybeShowInterstitial(_winContext(r));
    if (!mounted) return;
    router.go(r.hasNext ? '/play/${r.level + 1}' : '/map');
  }

  int _lastCueSeq = 0;
  GameStatus? _lastStatus;

  /// Sound, haptics and toasts for what just happened. Runs once per cue.
  void _onCue(BuildContext context, GameState s) {
    final audio = context.read<AudioService>();
    if (s.status != _lastStatus) {
      _lastStatus = s.status;
      if (s.status == GameStatus.won) audio.play(Sfx.winStinger);
      if (s.status == GameStatus.failed) audio.play(Sfx.fail);
    }
    if (s.cueSeq == _lastCueSeq) return;
    _lastCueSeq = s.cueSeq;
    if (s.cue != null) {
      try {
        audio.playCue(s.cue!);
      } catch (_) {}
    }
    final msg = switch (s.cue) {
      GameCue.hintNoSolution => 'No way out from here. Try Restart.',
      GameCue.notEnoughCoins => 'Not enough coins',
      _ => null,
    };
    if (msg != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _restart(BuildContext context, GameState s) async {
    final bloc = context.read<GameBloc>();
    if (s.attempt.moves > 0) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          content: const Text('Restart this level?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Restart')),
          ],
        ),
      );
      if (ok != true) return;
    }
    _winRecorded = false;
    _showGift = false;
    bloc.add(const Restarted());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final wallet = context.watch<WalletCubit>().state;
    final settings = context.watch<SettingsCubit>().state;
    final progress = context.watch<ProgressCubit>().state;
    final ads = context.read<AdsCubit>();

    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (a, b) => a.cueSeq != b.cueSeq || a.status != b.status,
      listener: (context, s) {
        if (s.status == GameStatus.won && s.result != null && !_winRecorded) {
          _winRecorded = true;
          if (widget.isDaily) {
            context.read<DailyCubit>().completeDaily();
          } else {
            context.read<AdsCubit>().recordWin(_winContext(s.result!));
          }
        }
        _onCue(context, s);
      },
      builder: (context, s) {
        final lv = s.level.number;
        final a = s.attempt;
        final popup = _popup(context, s, wallet, settings, progress, ads);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (s.status == GameStatus.secondChance) {
              bloc.add(const ReviveDeclined());
            } else if (s.status == GameStatus.paused) {
              bloc.add(const Resumed());
            } else {
              bloc.add(const Paused());
            }
          },
          child: Stack(
            children: [
              GameplayScreen(
                hud: HudData(
                  level: lv,
                  isHard: s.level.tag == LevelTag.hard,
                  hearts: a.hearts,
                  maxHearts: AttemptRules.maxHearts,
                  shieldCharges: a.shieldCharges,
                  moves: a.moves,
                  coins: wallet.coins,
                ),
                boosters: [
                  for (final b in Booster.values)
                    BoosterButtonData(
                      booster: b,
                      count: wallet.count(b),
                      locked: !Economy.isUnlocked(b, lv),
                      unlockLevel: Economy.unlockLevel[b]!,
                      used: a.usesOf(b),
                      cap: AttemptRules.boosterCap[b]!,
                      enabled:
                          s.acceptsBoosters &&
                          !a.capReached(b) &&
                          !(b == Booster.shield && a.shieldActive),
                      active:
                          (b == Booster.shield && a.shieldActive) ||
                          (b == Booster.hammer && s.status == GameStatus.hammerTarget),
                    ),
                ],
                board: const BoardInput(),
                hammerMode: s.status == GameStatus.hammerTarget,
                onPause: () => bloc.add(const Paused()),
                onBooster: (b) => bloc.add(BoosterPressed(b)),
                onCancelHammer: () => bloc.add(const HammerCancelled()),
              ),
              if (popup != null) ...[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: const ModalBarrier(color: AppColors.scrim, dismissible: false),
                ),
                popup,
              ],
            ],
          ),
        );
      },
    );
  }

  Widget? _popup(
    BuildContext context,
    GameState s,
    WalletState wallet,
    SettingsData settings,
    ProgressState progress,
    AdsCubit ads,
  ) {
    final bloc = context.read<GameBloc>();
    final lv = s.level.number;
    final shop = s.miniShopFor;
    if (shop != null) {
      return MiniShopSheet(
        data: MiniShopData(
          booster: shop,
          singlePrice: Economy.singlePrice[shop]!,
          packPrice: Economy.packPrice[shop]!,
          coins: wallet.coins,
        ),
        onBuySingle: () {
          if (context.read<WalletCubit>().buyBooster(shop, pack: false)) bloc.closeMiniShop();
        },
        onBuyPack: () {
          if (context.read<WalletCubit>().buyBooster(shop, pack: true)) bloc.closeMiniShop();
        },
        onClose: bloc.closeMiniShop,
      );
    }
    switch (s.status) {
      case GameStatus.paused:
        return PausePopup(
          settings: settings,
          onResume: () => bloc.add(const Resumed()),
          onRestart: () => _restart(context, s),
          onMap: () => context.go(widget.isDaily ? '/daily' : '/map'),
          onHome: () => context.go('/'),
          onToggle: context.read<SettingsCubit>().toggle,
        );
      case GameStatus.secondChance:
        return SecondChancePopup(
          key: ValueKey('sc-${s.attempt.adRevives}-${s.attempt.refills}'),
          data: SecondChanceData(
            adAvailable: ads.rewardedReady,
            adUsedForLevel: progress.adReviveUsed.contains(lv),
            refillsLeft: s.attempt.refillsLeft,
            refillCost: AttemptRules.refillCost,
            coins: wallet.coins,
          ),
          paused: s.adBusy,
          onWatchAd: () => bloc.add(const ReviveWithAd()),
          onRefill: () => bloc.add(const ReviveWithCoins()),
          onDecline: () => bloc.add(const ReviveDeclined()),
        );
      case GameStatus.failed:
        return LevelFailedPopup(
          onRetry: () => bloc.add(const Restarted()),
          onHome: () => context.go(widget.isDaily ? '/daily' : '/'),
        );
      case GameStatus.won:
        if (widget.isDaily) {
          final time = context.read<TimeGuard>();
          final now = time.clock.now();
          final dailyState = context.read<DailyCubit>().state;
          final streakState = context.read<StreakCubit>().state;
          const months = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          final stamped = '${now.day} ${months[now.month - 1]}';
          final reward = streakState.todayReward;
          final r = s.result!;

          final tomorrow = DateTime(now.year, now.month, now.day + 1);
          final diff = tomorrow.difference(now);
          final nextTime = '${diff.inHours} h ${diff.inMinutes % 60} m';

          final nextDay = streakState.currentDay >= 7 ? 1 : streakState.currentDay + 1;
          final nextReward = StreakState.ladder[(nextDay - 1).clamp(0, 6)];
          final nextBooster = nextReward.booster != null ? ' + 1 ${boosterName(nextReward.booster!)}' : '';
          final tomorrowRewardText = 'Tomorrow: Day $nextDay · ${nextReward.coins} coins$nextBooster';

          return DailyResultPopup(
            data: DailyResultData(
              dayTitle: '${dailyState.dayKey} · ${dailyState.modifier.label}',
              stampedDate: stamped,
              stars: r.stars,
              moves: s.attempt.moves,
              parMoves: s.level.parMoves,
              clearCoins: 100,
              streakDay: streakState.currentDay,
              streakCoins: reward.coins,
              tomorrowRewardText: tomorrowRewardText,
              nextDailyTimeLeft: nextTime,
            ),
            onCollect: () => context.go('/daily'),
          );
        }
        final r = s.result!;
        if (_showGift && r.gift != null) {
          return GiftBasketPopup(data: r.gift!, onCollect: () => _afterRewards(context, r));
        }
        return LevelCompletePopup(
          data: r,
          adBusy: s.adBusy,
          onDouble: () => bloc.add(const DoubleCoinsRequested()),
          // Win sequence: Gift Basket (if any) ⇒ interstitial check ⇒ next level.
          onNext: () =>
              r.gift != null ? setState(() => _showGift = true) : _afterRewards(context, r),
          onMap: () => context.go('/map'),
        );
      default:
        return null;
    }
  }
}
