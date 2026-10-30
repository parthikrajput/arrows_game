import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/logging/app_logger.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/popup.dart';
import '../../services/remote_config.dart';
import '../../state/settings_cubit.dart';
import '../../state/shop_cubit.dart';
import 'dev_tools.dart';
import 'jungle_guide_page.dart';

/// Every setting row. Used by the Settings screen and the in-game Pause sheet.
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    Widget toggle(IconData icon, String label, SettingKey k, {String? hint}) => _Row(
          icon: icon,
          label: label,
          hint: hint,
          trailing: Switch(value: st.value(k), onChanged: (_) => cubit.toggle(k)),
          onTap: () => cubit.toggle(k),
          semantics: '$label, ${st.value(k) ? 'on' : 'off'}',
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Group(children: [
          toggle(Icons.volume_up_rounded, 'Sound', SettingKey.sound),
          toggle(Icons.music_note_rounded, 'Music', SettingKey.music),
          toggle(Icons.vibration_rounded, 'Haptics', SettingKey.haptics),
        ]),
        _Group(children: [
          toggle(Icons.palette_rounded, 'Colour-blind mode', SettingKey.colourBlind, hint: 'Bolder patterns + head icons'),
          toggle(Icons.motion_photos_off_rounded, 'Reduced motion', SettingKey.reducedMotion, hint: 'No wiggle, confetti or shake'),
          toggle(Icons.nightlight_round, 'Brighter nights', SettingKey.brighterNights),
          _Row(
            icon: Icons.language_rounded,
            label: 'Language',
            trailing: Text(_languageName(st.language), style: AppText.bodyBold.copyWith(color: AppColors.primary)),
            onTap: () => _pickLanguage(context),
          ),
        ]),
        _Group(children: [
          _Row(
            icon: Icons.menu_book_rounded,
            label: 'Jungle Guide',
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const JungleGuidePage())),
          ),
          _Row(icon: Icons.casino_rounded, label: 'Spin odds', onTap: () => showSpinOdds(context)),
        ]),
        _Group(children: [
          _Row(icon: Icons.privacy_tip_rounded, label: 'Privacy choices', onTap: () => _privacy(context)),
          toggle(Icons.insights_rounded, 'Share diagnostics', SettingKey.shareDiagnostics, hint: 'Off keeps crash logs on this device'),
          _Row(icon: Icons.restore_rounded, label: 'Restore purchases', onTap: () => _restore(context)),
          _Row(icon: Icons.bug_report_rounded, label: 'Help · Report a problem', onTap: () => showReportProblem(context)),
        ]),
        if (kDevTools) const DevToolsPanel(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.md),
          child: Column(
            children: [
              Text('Progress is saved on this device only.', style: AppText.caption, textAlign: TextAlign.center),
              Text('Uninstalling the app removes it. Purchases come back with Restore.', style: AppText.caption, textAlign: TextAlign.center),
              const SizedBox(height: Space.sm),
              Text('Terms · Privacy · v1.0.0', style: AppText.caption.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }

  static String _languageName(String code) => switch (code) {
        'gu' => 'ગુજરાતી',
        'hi' => 'हिन्दी',
        _ => 'English',
      };

  Future<void> _pickLanguage(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    await showGamePopup<void>(
      context,
      dismissible: true,
      builder: (ctx) => PopupCard(
        title: 'Language',
        onClose: () => Navigator.pop(ctx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (code, name, ready) in const [('en', 'English', true), ('gu', 'ગુજરાતી', false), ('hi', 'हिन्दी', false)])
              ListTile(
                title: Text(name, style: AppText.bodyBold),
                subtitle: ready ? null : Text('Translation coming soon', style: AppText.caption),
                enabled: ready,
                trailing: cubit.state.language == code ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                onTap: ready
                    ? () {
                        cubit.setLanguage(code);
                        Navigator.pop(ctx);
                      }
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _privacy(BuildContext context) async {
    final st = context.read<SettingsCubit>().state;
    final child = st.isChild(DateTime.now().year);
    await showGamePopup<void>(
      context,
      dismissible: true,
      builder: (ctx) => PopupCard(
        title: 'Privacy choices',
        onClose: () => Navigator.pop(ctx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              child
                  ? 'Ads are child-directed and never personalised on this device.'
                  : 'Ads may be personalised where the law allows. In the EEA and UK the Google consent form decides this.',
              style: AppText.body,
            ),
            const SizedBox(height: Space.md),
            Text('The consent form opens here once ads are switched on in this build.', style: AppText.caption),
          ],
        ),
      ),
    );
  }

  Future<void> _restore(BuildContext context) async {
    showToast(context, 'Restoring purchases…');
    final restored = await context.read<ShopCubit>().restore();
    if (context.mounted) showToast(context, restored ? 'Purchases restored' : 'Nothing to restore');
  }
}

Future<void> showSpinOdds(BuildContext context) {
  return showGamePopup<void>(
    context,
    dismissible: true,
    builder: (ctx) => PopupCard(
      title: 'Lucky Lily Wheel odds',
      onClose: () => Navigator.pop(ctx),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final p in spinPrizes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: p.booster != null ? BoosterIcon(p.booster!, size: 24) : const CoinIcon(size: 22),
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(child: Text(p.booster != null ? '1 ${boosterName(p.booster!)}' : '${p.coins} coins${p.coins == 500 ? ' (Jackpot)' : ''}', style: AppText.body)),
                  Text('${(p.weight / 10).toStringAsFixed(p.weight % 10 == 0 ? 0 : 1)}%', style: AppText.bodyBold),
                ],
              ),
            ),
          const SizedBox(height: Space.sm),
          Text('Spins are free (1 per day) or via an optional ad. Spins are never sold.', style: AppText.caption, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

Future<void> showReportProblem(BuildContext context) async {
  final child = context.read<SettingsCubit>().state.isChild(DateTime.now().year);
  final analytics = context.read<AppServices>().analytics;
  final text = TextEditingController();
  var category = 'Gameplay';
  final id = await showGamePopup<String>(
    context,
    dismissible: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => PopupCard(
        title: 'Report a problem',
        onClose: () => Navigator.pop(ctx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final c in const ['Gameplay', 'Shop / coins', 'Ads', 'Sound', 'Other'])
                  ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)),
              ],
            ),
            // Free text only for 13+ (no personal data from children).
            if (!child) ...[
              const SizedBox(height: Space.md),
              TextField(
                controller: text,
                maxLines: 3,
                maxLength: 300,
                decoration: const InputDecoration(hintText: 'What happened?', border: OutlineInputBorder()),
              ),
            ],
            const SizedBox(height: Space.md),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, log.submitBugReport(category: category, text: child ? null : text.text)),
              child: const Text('Send report'),
            ),
          ],
        ),
      ),
    ),
  );
  if (id != null && context.mounted) {
    await showGamePopup<void>(
      context,
      dismissible: true,
      builder: (ctx) => PopupCard(
        title: 'Thank you!',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your Report ID', style: AppText.caption),
            SelectableText(id, style: AppText.h1),
            const SizedBox(height: Space.md),
            FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      ),
    );
  }
  if (id != null) analytics.event('bug_report', {'category': category});
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          boxShadow: Shadows.elev1,
        ),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 52),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, this.trailing, this.onTap, this.hint, this.semantics});
  final IconData icon;
  final String label;
  final String? hint;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semantics;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semantics,
      button: onTap != null,
      excludeSemantics: semantics != null,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: AppText.bodyBold),
                      if (hint != null) Text(hint!, style: AppText.caption),
                    ],
                  ),
                ),
                trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
