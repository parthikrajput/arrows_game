import 'package:flutter/material.dart';

import '../../../../app/theme/text_styles.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/widgets/bevel_button.dart';
import '../../../settings/settings_panel.dart';

enum PauseAction { resume, restart, map, home }

Future<PauseAction> showPauseSheet(BuildContext context, {required bool showMap}) async {
  final r = await showModalBottomSheet<PauseAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgCream,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg))),
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, Space.xl),
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: Space.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.pause_circle_rounded, color: AppColors.primary, size: 30), const SizedBox(width: Space.sm), Text('Paused', style: AppText.h1)],
          ),
          const SizedBox(height: Space.lg),
          BevelButton.text('Resume', expand: true, icon: Icons.play_arrow_rounded, logId: 'pause.resume', onPressed: () => Navigator.pop(ctx, PauseAction.resume)),
          const SizedBox(height: Space.md),
          BevelButton.text('Restart', expand: true, style: BevelStyle.cream, icon: Icons.refresh_rounded, logId: 'pause.restart', onPressed: () => Navigator.pop(ctx, PauseAction.restart)),
          const SizedBox(height: Space.md),
          Row(
            children: [
              if (showMap) ...[
                Expanded(child: BevelButton.text('Map', style: BevelStyle.cream, icon: Icons.map_rounded, logId: 'pause.map', onPressed: () => Navigator.pop(ctx, PauseAction.map))),
                const SizedBox(width: Space.md),
              ],
              Expanded(child: BevelButton.text('Home', style: BevelStyle.cream, icon: Icons.home_rounded, logId: 'pause.home', onPressed: () => Navigator.pop(ctx, PauseAction.home))),
            ],
          ),
          const SizedBox(height: Space.xl),
          const SettingsPanel(),
        ],
      ),
    ),
  );
  return r ?? PauseAction.resume;
}
