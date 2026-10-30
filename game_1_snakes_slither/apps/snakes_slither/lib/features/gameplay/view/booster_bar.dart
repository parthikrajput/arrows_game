import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/services.dart';
import '../../../app/theme/text_styles.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/widgets/game_icons.dart';
import '../../../services/remote_config.dart';
import '../../../state/wallet_cubit.dart';
import '../bloc/game_bloc.dart';

/// Hint · Shield · Hammer, with count badges, locks and per-attempt caps.
class BoosterBar extends StatelessWidget {
  const BoosterBar({super.key, required this.unlockedUpTo, required this.onTap, this.vertical = false, this.keys = const {}});

  /// Highest level reached (booster unlock check).
  final int unlockedUpTo;
  final void Function(BoosterType type) onTap;
  final bool vertical;
  final Map<BoosterType, GlobalKey> keys;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<GameBloc>().state;
    final wallet = context.watch<WalletCubit>().state;
    final cfg = context.read<AppServices>().config;
    final buttons = [
      for (final t in BoosterType.values)
        BoosterButton(
          key: keys[t],
          type: t,
          count: wallet.count(t),
          used: s.usesOf(t),
          cap: cfg.boosterCap(t),
          unlockLevel: cfg.boosterUnlockLevel(t),
          locked: unlockedUpTo < cfg.boosterUnlockLevel(t),
          active: (t == BoosterType.hammer && s.status == GameStatus.hammerTarget) ||
              (t == BoosterType.shield && s.shieldCharges > 0) ||
              (t == BoosterType.hint && s.hintTarget != null),
          busy: s.isBusy || (s.status != GameStatus.playing && s.status != GameStatus.hammerTarget),
          onTap: () => onTap(t),
        ),
    ];
    return SizedBox(
      height: vertical ? null : 88,
      width: vertical ? 96 : null,
      child: Flex(
        direction: vertical ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}

class BoosterButton extends StatelessWidget {
  const BoosterButton({
    super.key,
    required this.type,
    required this.count,
    required this.used,
    required this.cap,
    required this.unlockLevel,
    required this.locked,
    required this.active,
    required this.busy,
    required this.onTap,
  });

  final BoosterType type;
  final int count;
  final int used;
  final int cap;
  final int unlockLevel;
  final bool locked;
  final bool active;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final capped = used >= cap;
    final dim = locked || capped || busy;
    final label = locked
        ? '${boosterName(type)}, locked until level $unlockLevel'
        : '${boosterName(type)}, $count left${capped ? ', limit reached for this try' : ''}';
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: busy ? null : onTap,
        child: AnimatedOpacity(
          duration: Motion.fast,
          opacity: dim && !active ? 0.5 : 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: Motion.base,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: const Alignment(-0.3, -0.5),
                        colors: locked ? const [Color(0xFFEEEEEE), Color(0xFFBDBDBD)] : const [Colors.white, Color(0xFFF5EFDF), Color(0xFFE3D7B9)],
                      ),
                      border: Border.all(color: active ? AppColors.coinGold : Colors.white, width: active ? 4 : 2),
                      boxShadow: [
                        BoxShadow(color: active ? AppColors.coinGold.withValues(alpha: 0.6) : AppColors.creamLip, blurRadius: active ? 14 : 0, offset: Offset(0, active ? 0 : 4)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: locked
                        ? const Icon(Icons.lock_rounded, color: Color(0xFF757575), size: 28)
                        : BoosterIcon(type, size: 38),
                  ),
                  Positioned(right: -6, bottom: -2, child: _badge()),
                ],
              ),
              const SizedBox(height: 4),
              ExcludeSemantics(
                child: Text(
                  locked ? 'L$unlockLevel' : (capped ? '$used/$cap' : boosterShort(type)),
                  style: AppText.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge() {
    if (locked) return const SizedBox.shrink();
    final empty = count <= 0;
    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: empty ? AppColors.coinGold : AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: empty
          ? const Icon(Icons.add_rounded, size: 14, color: Color(0xFF4E3500))
          : Text('$count', style: AppText.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w900, height: 1)),
    );
  }
}
