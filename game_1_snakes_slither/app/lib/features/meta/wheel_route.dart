import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../contracts/view_models.dart';
import '../../state/rewards.dart';
import '../../state/wheel_cubit.dart';
import '../../ui/screens/wheel_screen.dart';

class WheelRoute extends StatelessWidget {
  const WheelRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final wheel = context.watch<WheelCubit>();
    final s = wheel.state;
    return WheelScreen(
      data: WheelData(
        segments: [
          for (final p in LuckyWheel.prizes)
            WheelSegmentData(label: p.label, odds: p.odds, booster: p.booster, coins: p.coins),
        ],
        freeAvailable: wheel.freeAvailable,
        adAvailable: wheel.adAvailable,
        freeUsed: wheel.freeUsedToday,
        adUsed: wheel.adUsedToday,
        timeLocked: wheel.timeLocked,
        busy: s.busy,
        prizeIndex: s.lastPrize,
        spinSeq: s.spinSeq,
      ),
      onSpinFree: wheel.spinFree,
      onSpinAd: wheel.spinWithAd,
      onBack: () => context.go('/'),
    );
  }
}
