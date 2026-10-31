// OWNER: UI agent. Canvas: Home.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

/// Phase 1 has 500 levels; the Levels card shows progress against it.
const _phaseLevels = 500;
const _dailyUnlockLevel = 15;

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.data,
    required this.onPlay,
    required this.onOpenMap,
    required this.onOpenSettings,
    required this.onOpenShop,
    required this.onOpenWheel,
  });

  final HomeData data;
  final VoidCallback onPlay;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenShop;

  /// Only shown when data.wheelUnlocked.
  final VoidCallback onOpenWheel;

  @override
  Widget build(BuildContext context) {
    final cleared = data.allCleared ? _phaseLevels : (data.nextLevel - 1).clamp(0, _phaseLevels);
    return Scaffold(
      key: AppKeys.homeScreen,
      body: CreamBackground(
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: CenteredColumn(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                            child: Row(
                              children: [
                                RoundButton(
                                  key: AppKeys.homeSettings,
                                  label: 'Settings',
                                  onTap: onOpenSettings,
                                  child: const LineIconView(LineIcon.gear, size: 24, color: AppColors.emerald),
                                ),
                                const Spacer(),
                                CoinPill(coins: data.coins, onTap: onOpenShop),
                              ],
                            ),
                          ),
                          const Expanded(child: _Mascot()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                            child: _GlowPulse(
                              enabled: !data.allCleared,
                              child: GameButton(
                                key: AppKeys.homePlay,
                                height: 64,
                                fontSize: 26,
                                leading: data.allCleared
                                    ? null
                                    : const LineIconView(LineIcon.play, color: Colors.white),
                                label: data.allCleared ? 'More levels soon' : 'Level ${data.nextLevel}',
                                onTap: data.allCleared ? null : onPlay,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Pressable(
                                    key: AppKeys.homeMap,
                                    onTap: onOpenMap,
                                    semanticLabel: 'Levels, $cleared of $_phaseLevels cleared',
                                    child: _HomeCard(
                                      icon: const LineIconView(LineIcon.map, color: AppColors.emerald),
                                      iconBg: AppColors.leafWash,
                                      title: 'Levels',
                                      left: '$cleared / $_phaseLevels',
                                      right: '${(cleared * 100 / _phaseLevels).floor()}%',
                                      progress: cleared / _phaseLevels,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _HomeCard(
                                    icon: const LineIconView(LineIcon.lock, size: 20, color: Color(0xFFD9822B)),
                                    iconBg: AppColors.goldWash,
                                    title: 'Daily Puzzle',
                                    left: data.nextLevel <= _dailyUnlockLevel
                                        ? 'Unlocks at L$_dailyUnlockLevel'
                                        : 'Coming soon',
                                    right: '',
                                    progress: 0,
                                    gold: true,
                                    dim: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (data.wheelUnlocked)
                        Positioned(
                          right: 16,
                          top: 64,
                          child: _WheelButton(ready: data.freeSpinReady, onTap: onOpenWheel),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _BottomNav(onShop: onOpenShop, onMap: onOpenMap, onSettings: onOpenSettings),
          ],
        ),
      ),
    );
  }
}

class _Mascot extends StatelessWidget {
  const _Mascot();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, box) {
      final w = (box.maxHeight * .88).clamp(120.0, 292.0);
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 20,
            child: Container(
              width: w * 1.03,
              height: w * 1.03,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Color(0xF2FFFFFF), Color(0x00FFFFFF)], stops: [0, .68]),
              ),
            ),
          ),
          Bob(
            child: Image.asset(
              'assets/images/pip_platform.png',
              width: w,
              semanticLabel: 'Pip the snake on a platform',
            ),
          ),
        ],
      );
    },
  );
}

class _GlowPulse extends StatefulWidget {
  const _GlowPulse({required this.child, required this.enabled});
  final Widget child;
  final bool enabled;
  @override
  State<_GlowPulse> createState() => _GlowPulseState();
}

class _GlowPulseState extends State<_GlowPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context) || !widget.enabled) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (_, child) {
      final t = (_c.value / .6).clamp(0.0, 1.0);
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _c.isAnimating
              ? [
                  BoxShadow(
                    color: AppColors.leaf.withValues(alpha: .55 * (1 - t)),
                    spreadRadius: 14 * t,
                  ),
                ]
              : null,
        ),
        child: child,
      );
    },
  );
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.left,
    required this.right,
    required this.progress,
    this.gold = false,
    this.dim = false,
  });
  final Widget icon;
  final Color iconBg;
  final String title;
  final String left;
  final String right;
  final double progress;
  final bool gold;
  final bool dim;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: dim ? .78 : 1,
    child: CreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: icon,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppText.fredoka(16, height: 1.1))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.nunito(13, color: AppColors.muted),
                ),
              ),
              Text(right, style: AppText.nunito(13, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 6),
          ProgressBar(value: progress, gold: gold),
        ],
      ),
    ),
  );
}

class _WheelButton extends StatelessWidget {
  const _WheelButton({required this.ready, required this.onTap});
  final bool ready;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Bob(
    period: const Duration(milliseconds: 2600),
    child: Pressable(
      key: AppKeys.homeWheel,
      onTap: onTap,
      semanticLabel: ready ? 'Lucky Lily Wheel, 1 free spin' : 'Lucky Lily Wheel',
      child: SizedBox(
        width: 64,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: const [BoxShadow(color: Color(0x24163B28), offset: Offset(0, 8), blurRadius: 18)],
                  ),
                  child: const ArtIcon(Art.flower, size: 44),
                ),
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: ready ? AppColors.red : AppColors.emerald,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: ready ? AppColors.redLip : AppColors.lip, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      ready ? 'FREE SPIN' : 'SPIN',
                      style: AppText.nunito(10, color: Colors.white, spacing: .4),
                    ),
                  ),
                ),
              ],
            ),
            if (ready)
              Positioned(
                right: -2,
                top: -4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.onShop, required this.onMap, required this.onSettings});
  final VoidCallback onShop;
  final VoidCallback onMap;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    Widget item(LineIcon icon, String label, VoidCallback? onTap, {bool active = false, Key? key}) => Expanded(
      child: Pressable(
        key: key,
        onTap: onTap ?? () {},
        semanticLabel: label,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppColors.leafWash : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LineIconView(icon, color: active ? AppColors.emerald : AppColors.navIdle),
              ),
              const SizedBox(height: 3),
              Text(label, style: AppText.nunito(11, color: active ? AppColors.emerald : AppColors.navIdle)),
            ],
          ),
        ),
      ),
    );
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [BoxShadow(color: Color(0x14163B28), offset: Offset(0, -8), blurRadius: 24)],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 66,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                item(LineIcon.home, 'Home', null, active: true),
                item(LineIcon.shop, 'Shop', onShop, key: AppKeys.homeShop),
                item(LineIcon.map, 'Map', onMap),
                item(LineIcon.settings, 'Settings', onSettings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
