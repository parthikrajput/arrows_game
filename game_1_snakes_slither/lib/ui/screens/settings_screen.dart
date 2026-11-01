// OWNER: UI agent. Canvas: Settings.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../popups/popups.dart';
import '../popups/tutorial_popups.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onToggle,
    required this.onBack,
    this.onLanguage,
    this.guide = const [],
    this.odds = const [],
    this.onPrivacyChoices,
    this.onReportProblem,
    this.onRestorePurchases,
  });
  final SettingsData settings;
  final void Function(SettingKey) onToggle;
  final VoidCallback onBack;

  /// 'en', 'gu' or 'hi'.
  final void Function(String code)? onLanguage;

  /// Jungle Guide: intro cards of mechanics the player has reached.
  final List<MechanicIntroData> guide;

  /// Lucky Lily Wheel odds (store policy: also shown here).
  final List<WheelSegmentData> odds;
  final VoidCallback? onPrivacyChoices;
  final VoidCallback? onReportProblem;
  final VoidCallback? onRestorePurchases;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MechanicIntroData? _card;
  bool _odds = false;

  static const languages = {'en': 'English', 'gu': 'ગુજરાતી', 'hi': 'हिन्दी'};

  Widget _link(String label, IconData icon, VoidCallback? onTap, {Key? key, String? trailing}) => Pressable(
    key: key,
    onTap: onTap,
    semanticLabel: label,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.leafWash, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, size: 20, color: AppColors.emerald),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppText.nunito(16))),
          if (trailing != null) Text(trailing, style: AppText.nunito(14, color: AppColors.muted)),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final w = widget;
    return Stack(
      children: [
        _page(context, w),
        if (_card != null) ...[
          const ModalBarrier(color: AppColors.scrim, dismissible: false),
          MechanicIntroCard(data: _card!, fromGuide: true, onGotIt: () => setState(() => _card = null)),
        ],
        if (_odds) ...[
          ModalBarrier(color: AppColors.scrim, onDismiss: () => setState(() => _odds = false)),
          PopupCard(
            key: AppKeys.settingsOddsSheet,
            badge: 'LUCKY LILY WHEEL ODDS',
            children: [
              for (final s in w.odds)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(s.label, style: AppText.nunito(15))),
                      Text('${(s.odds * 100).toStringAsFixed(s.odds < .01 ? 1 : 0)}%', style: AppText.fredoka(16)),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              GameButton(label: 'Close', height: 44, onTap: () => setState(() => _odds = false)),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final code = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.card,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in _SettingsScreenState.languages.entries)
              ListTile(
                key: AppKeys.settingsLanguageOption(e.key),
                title: Text(e.value, style: AppText.nunito(17)),
                trailing: e.key == widget.settings.language
                    ? const Icon(Icons.check_rounded, color: AppColors.emerald)
                    : null,
                onTap: () => Navigator.pop(c, e.key),
              ),
          ],
        ),
      ),
    );
    if (code != null) widget.onLanguage?.call(code);
  }

  Future<void> _pickGuide(BuildContext context) async {
    final card = await showModalBottomSheet<MechanicIntroData>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      builder: (c) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .6,
        builder: (_, scroll) => ListView(
          controller: scroll,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Jungle Guide', style: AppText.fredoka(22)),
            ),
            for (final g in widget.guide)
              ListTile(
                title: Text(g.name, style: AppText.nunito(16)),
                subtitle: Text('Level ${g.level}', style: AppText.nunito(13, color: AppColors.muted)),
                onTap: () => Navigator.pop(c, g),
              ),
          ],
        ),
      ),
    );
    if (card != null) setState(() => _card = card);
  }

  Widget _page(BuildContext context, SettingsScreen w) => Scaffold(
    body: CreamBackground(
      leaves: false,
      child: SafeArea(
        child: CenteredColumn(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      RoundButton(
                        size: 40,
                        label: 'Back',
                        onTap: w.onBack,
                        child: const LineIconView(LineIcon.back, size: 18),
                      ),
                      Expanded(
                        child: Text('Settings', textAlign: TextAlign.center, style: AppText.fredoka(22)),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    SettingsList(settings: w.settings, onToggle: w.onToggle),
                    const SizedBox(height: 14),
                    const SectionLabel('MORE'),
                    CreamCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: Column(
                        children: [
                          _link(
                            'Language',
                            Icons.translate_rounded,
                            w.onLanguage == null ? null : () => _pickLanguage(context),
                            key: AppKeys.settingsLanguage,
                            trailing: languages[w.settings.language],
                          ),
                          _link(
                            'Jungle Guide',
                            Icons.menu_book_rounded,
                            w.guide.isEmpty ? null : () => _pickGuide(context),
                            key: AppKeys.settingsGuide,
                            trailing: '${w.guide.length}',
                          ),
                          if (w.odds.isNotEmpty)
                            _link(
                              'Lucky Lily Wheel odds',
                              Icons.casino_outlined,
                              () => setState(() => _odds = true),
                              key: AppKeys.settingsOdds,
                            ),
                          _link(
                            'Privacy choices',
                            Icons.privacy_tip_outlined,
                            w.onPrivacyChoices,
                            key: AppKeys.settingsPrivacy,
                          ),
                          _link(
                            'Restore purchases',
                            Icons.restore_rounded,
                            w.onRestorePurchases,
                            key: AppKeys.settingsRestore,
                          ),
                          _link(
                            'Report a problem',
                            Icons.flag_outlined,
                            w.onReportProblem,
                            key: AppKeys.settingsReport,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Snake Slither · v1.0.0',
                      textAlign: TextAlign.center,
                      style: AppText.nunito(12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Canvas toggle: 50 × 30 track, white 24 px knob.
class GameSwitch extends StatelessWidget {
  const GameSwitch({super.key, required this.value, required this.onChanged, required this.label});
  final bool value;
  final VoidCallback onChanged;
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    label: label,
    child: Pressable(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          color: value ? AppColors.emerald : const Color(0xFFD9D2BC),
          borderRadius: BorderRadius.circular(15),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x33000000), offset: Offset(0, 2), blurRadius: 4)],
            ),
          ),
        ),
      ),
    ),
  );
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.first = false,
  });
  final Widget icon;
  final String label;
  final bool value;
  final VoidCallback onChanged;
  final bool first;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
    decoration: BoxDecoration(
      border: first ? null : const Border(top: BorderSide(color: Color(0xFFEFE8D2))),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.leafWash, borderRadius: BorderRadius.circular(11)),
          child: icon,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppText.nunito(16))),
        GameSwitch(value: value, onChanged: onChanged, label: label),
      ],
    ),
  );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
    child: Text(text, style: AppText.nunito(12, color: AppColors.muted, spacing: .6)),
  );
}

Widget settingsIcon(SettingKey k) => switch (k) {
  SettingKey.sound => const LineIconView(LineIcon.sound, size: 20, color: AppColors.emerald),
  SettingKey.music => const LineIconView(LineIcon.music, size: 20, color: AppColors.emerald),
  SettingKey.haptics => const LineIconView(LineIcon.haptics, size: 20, color: AppColors.emerald),
  SettingKey.colourBlind => const LineIconView(LineIcon.contrast, size: 20, color: AppColors.emerald),
  SettingKey.reducedMotion => const LineIconView(LineIcon.motion, size: 20, color: AppColors.emerald),
  SettingKey.brightNights => const Icon(Icons.nightlight_round, size: 20, color: AppColors.emerald),
  SettingKey.batterySaver => const Icon(Icons.battery_saver_rounded, size: 20, color: AppColors.emerald),
  SettingKey.shareDiagnostics => const Icon(Icons.bug_report_outlined, size: 20, color: AppColors.emerald),
};
