import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../state/ads_cubit.dart';
import '../../state/wallet_cubit.dart';
import 'bevel_button.dart';
import 'game_icons.dart';

final _number = NumberFormat.decimalPattern();
String fmt(int n) => _number.format(n);

/// Counts smoothly to the new value whenever it changes.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount(this.value, {super.key, this.style});
  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.toDouble()),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Text(fmt(v.round()), style: style ?? AppText.hudNumber),
    );
  }
}

/// Cream pill with the coin balance; "+" opens the Shop on the Coins tab.
class CoinPill extends StatelessWidget {
  const CoinPill({super.key, this.showPlus = true});
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    final coins = context.select((WalletCubit w) => w.state.coins);
    return Semantics(
      button: showPlus,
      label: '${fmt(coins)} coins${showPlus ? ', open shop' : ''}',
      child: GestureDetector(
        onTap: showPlus ? () => Navigator.of(context).pushNamed(Routes.shop, arguments: 1) : null,
        child: Container(
          height: 42,
          padding: const EdgeInsets.only(left: 4, right: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, AppColors.creamEdge]),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: Shadows.bevel(AppColors.creamLip),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoinIcon(size: 30),
              const SizedBox(width: 6),
              ExcludeSemantics(child: AnimatedCount(coins, style: AppText.hudNumber.copyWith(fontSize: 18))),
              const SizedBox(width: 6),
              if (showPlus)
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF6CC46F), AppColors.primary]),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                )
              else
                const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

/// Top bar for hub screens: back, title, coin pill.
class HubHeader extends StatelessWidget {
  const HubHeader({super.key, required this.title, this.trailing, this.showCoins = true});
  final String title;
  final Widget? trailing;
  final bool showCoins;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.sm),
      child: Row(
        children: [
          RoundIconButton(icon: Icons.arrow_back_rounded, label: 'Back', onPressed: () => Navigator.of(context).maybePop()),
          const SizedBox(width: Space.md),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(title, style: AppText.h1, maxLines: 1),
            ),
          ),
          ?trailing,
          if (showCoins) ...[const SizedBox(width: Space.sm), const CoinPill()],
        ],
      ),
    );
  }
}

/// Cream rounded card.
class CreamCard extends StatelessWidget {
  const CreamCard({super.key, required this.child, this.padding = const EdgeInsets.all(Space.lg), this.color = AppColors.bgCream});
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: Shadows.elev1,
      ),
      child: child,
    );
  }
}

class Chip2 extends StatelessWidget {
  const Chip2(this.label, {super.key, this.color = AppColors.primary, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(Radii.sm)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Text(label, style: AppText.caption.copyWith(color: color, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

/// Space reserved for the adaptive banner so nothing jumps when it loads.
/// Shows a labelled placeholder until the AdMob banner is wired in.
class BannerSlot extends StatelessWidget {
  const BannerSlot({super.key, this.level});
  final int? level;

  static const double height = 50;

  @override
  Widget build(BuildContext context) {
    final allowed = context.select((AdsCubit a) => a.bannerAllowed(level: level));
    if (!allowed) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: Container(
        height: height,
        width: double.infinity,
        margin: const EdgeInsets.only(top: Space.sm),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F1),
          border: Border(top: BorderSide(color: Color(0x22000000))),
        ),
        alignment: Alignment.center,
        child: Text('Banner ad', style: AppText.caption),
      ),
    );
  }
}

void showToast(BuildContext context, String message) {
  final m = ScaffoldMessenger.maybeOf(context);
  if (m == null) return;
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(content: Text(message), duration: const Duration(milliseconds: 1800)));
}

/// "coins + booster" reward chips.
class RewardChip extends StatelessWidget {
  const RewardChip({super.key, this.coins, this.booster, this.count = 1});
  final int? coins;
  final dynamic booster;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Radii.pill),
        boxShadow: Shadows.elev1,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (coins != null) ...[const CoinIcon(size: 22), const SizedBox(width: 6), Text('+${fmt(coins!)}', style: AppText.h2.copyWith(fontSize: 18))],
          if (booster != null) ...[BoosterIcon(booster, size: 24), const SizedBox(width: 6), Text('×$count', style: AppText.h2.copyWith(fontSize: 18))],
        ],
      ),
    );
  }
}
