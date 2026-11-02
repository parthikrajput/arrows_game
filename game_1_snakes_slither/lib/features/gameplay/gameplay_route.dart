import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_core/puzzle_core.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../../data/level_repository.dart';
import '../../data/save_store.dart';
import '../../services/analytics.dart';
import '../../services/audio_service.dart';
import '../../services/perf/perf.dart';
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
import '../../state/tutorial_cubit.dart';
import '../../ui/popups/tutorial_popups.dart';
import 'board_input.dart';
import 'bot_player.dart';
import 'game_bloc.dart';
import 'tutorials.dart';

/// Rotating tips on the Level Failed popup.
const failTips = [
  'Tip: hold a snake to preview its path',
  'Tip: free the snake that blocks the most others first',
  'Tip: the Glow Firefly shows the next safe move',
  'Tip: the Safety Shell Shield blocks your next 2 bonks',
  'Tip: a curvy snake still leaves straight from its head',
  'Tip: Retry is always free',
];

/// Loads a level and connects GameBloc to the gameplay screen and popups.
class GameplayRoute extends StatelessWidget {
  const GameplayRoute({
    super.key,
    required this.levelNumber,
    this.customLevel,
    this.isDaily = false,
    this.botMode = false,
  });

  final int levelNumber;
  final Level? customLevel;
  final bool isDaily;
  final bool botMode;

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
        guidedTaps: !isDaily && !botMode && Tutorials.guidedTaps(level.number, c.read<TutorialCubit>().state),
        onTrack: isDaily || botMode ? null : c.read<Analytics>().log,
        savesProgress: !botMode,
      ),
      child: _GameplayView(
        isDaily: isDaily,
        introType: isDaily ? null : repo.introducesMechanic(level.number),
        botMode: botMode,
      ),
    );
  }
}

class _GameplayView extends StatefulWidget {
  const _GameplayView({this.isDaily = false, this.introType, this.botMode = false});
  final bool isDaily;

  /// Mechanic this level introduces (its "NEW!" card shows first).
  final String? introType;
  final bool botMode;

  @override
  State<_GameplayView> createState() => _GameplayViewState();
}

class _GameplayViewState extends State<_GameplayView> {
  late final AppLifecycleListener _life = AppLifecycleListener(
    onHide: () => context.read<GameBloc>().add(const Paused()),
  );

  final _frames = FrameMonitor();
  late bool _botAutoPlay = widget.botMode;
  bool _botScheduled = false;

  /// Moves made when the bot last tapped; the same count on its next turn
  /// means that tap was refused.
  int _botTappedAt = -1;

  /// Why the bot stopped on its own, shown on its chip.
  String? _botStuck;

  /// Pause between bot taps, so each slide can be watched.
  static const botDelay = Duration(milliseconds: 320);

  @override
  void initState() {
    super.initState();
    _life; // start listening
    _frames.start();
    if (_botAutoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final bloc = context.read<GameBloc>();
          _checkBotStep(bloc.state, bloc);
        }
      });
    }
  }

  /// After a bot win the next level starts with the bot still on.
  Future<void> _botNextLevel(LevelCompleteData r) async {
    final router = GoRouter.of(context);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted || !_botAutoPlay) return;
    router.go(r.hasNext ? '/play/${r.level + 1}?bot=true' : '/map');
  }

  void _stopBot(String why) => setState(() {
    _botAutoPlay = false;
    _botStuck = why;
  });

  void _checkBotStep(GameState s, GameBloc bloc) {
    if (!_botAutoPlay || _botScheduled) return;
    if (s.status != GameStatus.playing || s.miniShopFor != null) return;
    _botScheduled = true;
    Future.delayed(botDelay, () async {
      if (!mounted) return;
      final asked = bloc.state;
      final next = await botMove(asked);
      _botScheduled = false;
      if (!mounted || !_botAutoPlay) return;
      final now = bloc.state;
      if (now.status != GameStatus.playing) return;
      final made = now.attempt.history.length;
      // The player moved while the bot was thinking: think again.
      if (made != asked.attempt.history.length) return _checkBotStep(now, bloc);
      if (made == _botTappedAt) return _stopBot('move ${made + 1} was refused');
      _botTappedAt = made;
      // A refused tap changes nothing the listener sees, so look again.
      Future.delayed(botDelay * 3, () {
        if (mounted) _checkBotStep(bloc.state, bloc);
      });
      switch (next) {
        case (snake: final int id, obstacle: _):
          bloc.add(SnakeTapped(id));
        case (snake: _, obstacle: final int id):
          bloc.add(ObstacleTapped(id));
        default:
          _stopBot('no way out from here');
      }
    });
  }

  @override
  void dispose() {
    _life.dispose();
    _frames.stop();
    super.dispose();
  }

  bool _showGift = false;
  bool _winRecorded = false;

  WinContext _winContext(LevelCompleteData r) => WinContext(
    level: r.level,
    hasGiftBasket: r.gift != null && !r.gift!.isChest,
    hasChest: r.gift?.isChest ?? false,
    hasRush: r.rushNext,
  );

  /// Win sequence: Gift Basket / Chest ⇒ Golden Slither Rush (no ads around
  /// it) ⇒ next level, or after L500 the Phase Complete screen.
  Future<void> _afterRewards(BuildContext context, LevelCompleteData r) async {
    final router = GoRouter.of(context);
    if (r.rushNext) {
      router.go('/rush/${r.level}');
      return;
    }
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
    _botTappedAt = -1;
    _frames.start();
    bloc.add(const Restarted());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final tutorial = context.watch<TutorialCubit>().state;
    final wallet = context.watch<WalletCubit>().state;
    final settings = context.watch<SettingsCubit>().state;
    final progress = context.watch<ProgressCubit>().state;
    final ads = context.read<AdsCubit>();

    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (a, b) => a.cueSeq != b.cueSeq || a.status != b.status,
      listener: (context, s) {
        final tc = context.read<TutorialCubit>();
        if (!widget.isDaily && !widget.botMode) Tutorials.doneBy(s).forEach(tc.markSeen);
        if (s.status == GameStatus.won || s.status == GameStatus.failed) {
          context.read<PerfSettings>().levelFinished(_frames.stop());
        }
        if (s.status == GameStatus.won && s.result != null && !_winRecorded && widget.botMode) {
          _winRecorded = true;
          if (_botAutoPlay) _botNextLevel(s.result!);
        } else if (s.status == GameStatus.won && s.result != null && !_winRecorded) {
          _winRecorded = true;
          // Every win refreshes the backup copy of the save.
          context.read<SaveStore>().backup();
          if (widget.isDaily) {
            context.read<DailyCubit>().completeDaily();
          } else {
            context.read<AdsCubit>().recordWin(_winContext(s.result!));
          }
        }
        if (_botAutoPlay && s.status == GameStatus.playing) {
          _checkBotStep(s, bloc);
        }
        if (_botAutoPlay && (s.status == GameStatus.secondChance || s.status == GameStatus.failed)) {
          _stopBot('out of hearts');
        }
        _onCue(context, s);
      },
      builder: (context, s) {
        final lv = s.level.number;
        final a = s.attempt;
        final popup = _popup(context, s, wallet, settings, progress, ads);
        final playing = s.status == GameStatus.playing || s.status == GameStatus.animating;
        final tip = widget.isDaily || widget.botMode || popup != null || !playing
            ? null
            : Tutorials.tipFor(s, tutorial);
        final intro = widget.isDaily || widget.botMode ? null : Tutorials.introFor(lv, widget.introType, tutorial);
        final focus = tip?.focus ?? TipFocus.none;
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
                  gemsLeft: s.level.mechanicTypes.contains('M026') ? a.board.gemsLeft : null,
                  mongooseHp: a.board.mongooseHp ?? (s.level.mechanicTypes.contains('M049') ? 0 : null),
                  showHearts: lv != 1,
                  highlightHearts: focus == TipFocus.hearts,
                  highlightMoves: focus == TipFocus.moves,
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
                      enabled: s.acceptsBoosters && !a.capReached(b) && !(b == Booster.shield && a.shieldActive),
                      active:
                          (b == Booster.shield && a.shieldActive) ||
                          (b == Booster.hammer && s.status == GameStatus.hammerTarget),
                      highlight: switch (b) {
                        Booster.hint => focus == TipFocus.hint,
                        Booster.shield => focus == TipFocus.shield,
                        Booster.hammer => focus == TipFocus.hammer,
                      },
                    ),
                ],
                board: const BoardInput(),
                hammerMode: s.status == GameStatus.hammerTarget,
                onPause: () => bloc.add(const Paused()),
                onBooster: (b) => bloc.add(BoosterPressed(b)),
                onCancelHammer: () => bloc.add(const HammerCancelled()),
                banner: !widget.isDaily && ads.bannerFor(lv) ? ads.service.banner() : null,
                bannerHeight: !widget.isDaily && ads.bannerFor(lv) ? AdsCubit.bannerReserve : 0,
              ),
              if (widget.botMode)
                Positioned(
                  key: AppKeys.botChip,
                  top: MediaQuery.paddingOf(context).top + 54,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _botAutoPlay = !_botAutoPlay;
                          _botStuck = null;
                          _botTappedAt = -1;
                        });
                        if (_botAutoPlay && s.status == GameStatus.won) _botNextLevel(s.result!);
                        if (_botAutoPlay) _checkBotStep(s, bloc);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _botAutoPlay ? const Color(0xFF00838F) : const Color(0xCC263238),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _botAutoPlay ? const Color(0xFF80DEEA) : Colors.white24,
                            width: 1.5,
                          ),
                          boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _botAutoPlay ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _botAutoPlay
                                  ? '🤖 Step ${s.attempt.history.length}/${s.level.solution.length}'
                                  : _botStuck != null
                                  ? '🤖 Stopped: $_botStuck'
                                  : '🤖 Resume Bot',
                              style: AppText.nunito(11, weight: 800, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (tip != null)
                TutorialTip(data: tip.data, onGotIt: () => context.read<TutorialCubit>().markSeen(tip.data.id)),
              if (intro != null && popup == null) ...[
                const ModalBarrier(color: AppColors.scrim, dismissible: false),
                MechanicIntroCard(data: intro, onGotIt: () => context.read<TutorialCubit>().markSeen(intro.type)),
              ],
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
          level: widget.isDaily ? null : lv,
          moves: s.attempt.moves,
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
          level: widget.isDaily ? null : lv,
          moves: s.attempt.moves,
          tip: failTips[(lv + s.attempt.moves) % failTips.length],
          onRetry: () => bloc.add(const Restarted()),
          onHome: () => context.go(widget.isDaily ? '/daily' : '/'),
        );
      case GameStatus.won:
        if (widget.isDaily) {
          final time = context.read<TimeGuard>();
          final now = time.clock.now();
          final dailyState = context.read<DailyCubit>().state;
          final streakState = context.read<StreakCubit>().state;
          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
          onNext: () => r.gift != null ? setState(() => _showGift = true) : _afterRewards(context, r),
          onMap: () => context.go('/map'),
        );
      default:
        return null;
    }
  }
}
