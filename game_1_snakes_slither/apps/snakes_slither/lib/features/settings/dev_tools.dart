import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/common.dart';
import '../../services/remote_config.dart';
import '../../state/progress_cubit.dart';
import '../../state/wallet_cubit.dart';

/// Only compiled in with `--dart-define=DEV_TOOLS=true` (QA builds).
const bool kDevTools = bool.fromEnvironment('DEV_TOOLS');

class DevToolsPanel extends StatelessWidget {
  const DevToolsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.read<ProgressCubit>();
    final wallet = context.read<WalletCubit>();
    return CreamCard(
      color: const Color(0xFFFFEBEE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Developer tools (QA build)', style: AppText.bodyBold.copyWith(color: AppColors.danger)),
          const SizedBox(height: Space.sm),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final l in const [9, 14, 24, 49, 499])
                OutlinedButton(
                  onPressed: () {
                    progress.debugClearUpTo(l);
                    showToast(context, 'Cleared 1–$l');
                  },
                  child: Text('Clear to L$l'),
                ),
              OutlinedButton(
                onPressed: () {
                  wallet.earn('dev', 2000);
                  for (final t in BoosterType.values) {
                    wallet.grantBooster(t, 3);
                  }
                },
                child: const Text('+2000 coins, +3 boosters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
