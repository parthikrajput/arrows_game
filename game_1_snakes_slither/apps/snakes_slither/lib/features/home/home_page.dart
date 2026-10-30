import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../core/widgets/pip.dart';
import '../../core/widgets/popup.dart';
import '../../state/ads_cubit.dart';
import '../../state/daily_cubit.dart';
import '../../state/progress_cubit.dart';
import '../../state/settings_cubit.dart';
import '../../state/shop_cubit.dart';
import '../../state/spin_cubit.dart';
import '../../state/streak_cubit.dart';
import '../daily/daily_modifier_chip.dart';
import '../daily/streak_saver.dart';
import '../gameplay/view/gameplay_page.dart';
import '../rush/rush_page.dart';
import '../shop/starter_pack.dart';
import 'jungle_dawn_intro.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IntroMode? _intro;

  @override
  void initState() {
    super.initState();
    final s = context.read<AppServices>();
    final ext = s.save.section('ext');
    final today = s.time.dayKey();
    // Full intro on the first cold start of the day, short otherwise.
    _intro = ext['introDay'] == today ? IntroMode.short : IntroMode.full;
    s.save.write('ext', {...ext, 'introDay': today});
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterIntroChecks());
  }

  Future<void> _afterIntroChecks() async {
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    final s = context.read<AppServices>();
    final save = s.save;
    if (save.section('ext')['recoveryNoticeShown'] != true && save.recoveredFrom != null) {
      showToast(context, save.recoveredFrom == 'backup' ? 'Your save was repaired from a backup.' : 'Your save could not be read. Use Restore purchases in Settings.');
      save.write('ext', {...save.section('ext'), 'recoveryNoticeShown': true});
    }
    final today = s.time.dayKey();
    final streak = context.read<StreakCubit>().state;
    final ext = save.section('ext');
    if (!s.time.timeTravelLocked &&
        streak.saverOffered(today) &&
        !context.read<DailyCubit>().state.claimed(today) &&
        ext['saverOfferDay'] != today) {
      save.write('ext', {...ext, 'saverOfferDay': today});
      await showStreakSaverOffer(context, today);
      if (!mounted) return;
    }
    final shop = context.read<ShopCubit>();
    final child = context.read<SettingsCubit>().state.isChild(DateTime.now().year);
    // Under-13: the Starter Pack never pops up by itself (Shop only).
    if (!child && shop.state.starterAvailable(s.time.now()) && !shop.state.starterPopupShown) {
      shop.markStarterPopupShown();
      await showStarterPackPopup(context);
    }
  }

  Future<bool> _confirmExit() =>
      confirmPopup(context, title: 'Leave the jungle?', message: 'Pip will miss you! Close the game?', yes: 'Exit', no: 'Stay');

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final progress = context.watch<ProgressCubit>().state;
    final ftue = progress.highestCleared < 3;
    final vip = context.select((AdsCubit a) => a.vipActive);
    final shop = context.watch<ShopCubit>().state;
    final spin = context.watch<SpinCubit>();
    final today = s.time.dayKey();
    final spinUnlocked = spin.unlocked(progress.highestCleared);
    final spinFree = spinUnlocked && !spin.state.freeUsed(today) && !s.time.timeTravelLocked;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && await _confirmExit()) SystemNavigator.pop();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GardenBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, 0),
                      child: Row(
                        children: [
                          const CoinPill(),
                          const Spacer(),
                          RoundIconButton(icon: Icons.settings_rounded, label: 'Settings', onPressed: () => Navigator.of(context).pushNamed(Routes.settings)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, c) => SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: c.maxHeight),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: Space.md),
                                      if (progress.rushPendingLevel != null) _RushBanner(level: progress.rushPendingLevel!),
                                      if (!ftue) const _DailyCard(),
                                    ],
                                  ),
                                  const _PipStage(),
                                  Column(
                                    children: [
                                      _PlayButton(level: progress.nextLevel),
                                      const SizedBox(height: Space.lg),
                                      if (!ftue)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _HubButton(
                                              icon: Icons.local_florist_rounded,
                                              label: 'Spin',
                                              badge: spinFree ? '1' : null,
                                              locked: !spinUnlocked,
                                              onTap: () => spinUnlocked
                                                  ? Navigator.of(context).pushNamed(Routes.spin)
                                                  : showToast(context, 'Lucky Lily Wheel unlocks after level ${s.config.spinUnlockLevel}'),
                                            ),
                                            _HubButton(icon: Icons.map_rounded, label: 'Map', onTap: () => Navigator.of(context).pushNamed(Routes.map)),
                                            _HubButton(icon: Icons.storefront_rounded, label: 'Shop', onTap: () => Navigator.of(context).pushNamed(Routes.shop)),
                                            _HubButton(icon: Icons.emoji_events_rounded, label: 'Ranks', onTap: () => Navigator.of(context).pushNamed(Routes.leaderboards)),
                                          ],
                                        ),
                                      const SizedBox(height: Space.md),
                                      if (!ftue && shop.starterAvailable(s.time.now())) const StarterPackBubble(),
                                      if (!ftue && !vip)
                                        Padding(
                                          padding: const EdgeInsets.only(top: Space.sm),
                                          child: BevelButton(
                                            style: BevelStyle.vip,
                                            height: 44,
                                            logId: 'home.vip',
                                            onPressed: () => Navigator.of(context).pushNamed(Routes.vip),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.workspace_premium_rounded, color: Colors.white),
                                                const SizedBox(width: Space.sm),
                                                Text('VIP · No ads', style: AppText.button.copyWith(fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: Space.md),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const BannerSlot(),
                  ],
                ),
              ),
            ),
            if (_intro != null) JungleDawnIntro(mode: _intro!, onDone: () => setState(() => _intro = null)),
          ],
        ),
      ),
    );
  }
}

class _PipStage extends StatelessWidget {
  const _PipStage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Snakes Slither', style: AppText.display.copyWith(color: AppColors.primaryDark, shadows: const [Shadow(color: Colors.white, blurRadius: 8)])),
        const Pip(pose: PipPose.wave, size: 170),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(Routes.map),
          icon: const Icon(Icons.map_rounded, size: 18),
          label: Text('Level $level · open map', style: AppText.bodyBold.copyWith(color: AppColors.primaryDark)),
        ),
        SizedBox(
          width: 260,
          child: BevelButton(
            height: 68,
            radius: Radii.lg,
            semanticLabel: 'Play level $level',
            logId: 'home.play',
            onPressed: () => Navigator.of(context).pushNamed(Routes.play, arguments: GameArgs.level(level)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded, size: 36, color: Colors.white),
                const SizedBox(width: Space.sm),
                Text('LEVEL $level', style: AppText.h1.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HubButton extends StatelessWidget {
  const _HubButton({required this.icon, required this.label, required this.onTap, this.badge, this.locked = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundIconButton(icon: locked ? Icons.lock_rounded : icon, label: label, size: 58, badge: badge, onPressed: onTap),
        const SizedBox(height: 6),
        Text(label, style: AppText.bodyBold.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}

class _DailyCard extends StatelessWidget {
  const _DailyCard();

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final highest = context.select((ProgressCubit p) => p.state.highestCleared);
    final daily = context.watch<DailyCubit>();
    final streak = context.watch<StreakCubit>().state;
    final today = s.time.dayKey();
    final unlocked = daily.unlocked(highest);
    final claimed = daily.state.claimed(today);
    final locked = s.time.timeTravelLocked;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(Routes.daily),
      child: CreamCard(
        padding: const EdgeInsets.all(Space.md),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(Radii.sm)),
              child: Icon(unlocked ? Icons.calendar_today_rounded : Icons.lock_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Jungle Puzzle', style: AppText.h2.copyWith(fontSize: 18)),
                  if (!unlocked)
                    Text('Unlocks at level ${s.config.dailyUnlockLevel}', style: AppText.caption)
                  else if (locked)
                    Text('Check your clock', style: AppText.caption.copyWith(color: AppColors.danger))
                  else
                    Row(
                      children: [
                        DailyModifierChip(modifier: daily.today(highest).modifier),
                        const SizedBox(width: Space.sm),
                        const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF7043), size: 18),
                        Text('${streak.displayDay(today)}', style: AppText.bodyBold),
                      ],
                    ),
                ],
              ),
            ),
            if (unlocked && !locked)
              claimed
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 32)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [const CoinIcon(size: 20), Text(' +${s.config.dailyClearCoins}', style: AppText.bodyBold)],
                    ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _RushBanner extends StatelessWidget {
  const _RushBanner({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: BevelButton(
        expand: true,
        style: BevelStyle.gold,
        logId: 'home.rush_pending',
        onPressed: () => Navigator.of(context).push(rushRoute(level)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded, color: Color(0xFF4E3500)),
            const SizedBox(width: Space.sm),
            Text('Your Rush is waiting!', style: AppText.button.copyWith(color: const Color(0xFF4E3500))),
          ],
        ),
      ),
    );
  }
}

/// Starter Pack countdown bubble on Home.
class StarterPackBubble extends StatefulWidget {
  const StarterPackBubble({super.key});

  @override
  State<StarterPackBubble> createState() => _StarterPackBubbleState();
}

class _StarterPackBubbleState extends State<StarterPackBubble> {
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppServices>();
    final end = context.select((ShopCubit c) => c.state.starterWindowEndUtc);
    if (end == null) return const SizedBox.shrink();
    final left = end.difference(s.time.now().toUtc());
    if (left.isNegative) return const SizedBox.shrink();
    String two(int v) => v.toString().padLeft(2, '0');
    return GestureDetector(
      onTap: () => showStarterPackPopup(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: AppColors.coinGold, width: 2),
          boxShadow: Shadows.elev1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard_rounded, color: AppColors.coinGoldDark),
            const SizedBox(width: 6),
            Text('Starter Pack · ${left.inHours}:${two(left.inMinutes % 60)}:${two(left.inSeconds % 60)}', style: AppText.bodyBold),
          ],
        ),
      ),
    );
  }
}
