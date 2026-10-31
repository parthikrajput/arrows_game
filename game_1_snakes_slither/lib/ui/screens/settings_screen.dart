// OWNER: UI agent. Canvas: Settings.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/view_models.dart';
import '../popups/popups.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings, required this.onToggle, required this.onBack});
  final SettingsData settings;
  final void Function(SettingKey) onToggle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                        onTap: onBack,
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
                    SettingsList(settings: settings, onToggle: onToggle),
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
};
