// OWNER: UI agent. Canvas: AgeGate.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

/// Neutral birth-year picker: nothing is pre-selected and no year is
/// suggested, so the player has no hint which answer "unlocks" more.
class AgeGateScreen extends StatefulWidget {
  const AgeGateScreen({super.key, required this.currentYear, required this.onSubmit});
  final int currentYear;
  final void Function(int birthYear) onSubmit;

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  int? _year;
  late final _years = [for (var y = widget.currentYear; y >= widget.currentYear - 100; y--) y];
  late final _scroll = FixedExtentScrollController(initialItem: 20);

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.ageGateScreen,
    body: CreamBackground(
      child: SafeArea(
        child: CenteredColumn(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                Text('When were you born?', textAlign: TextAlign.center, style: AppText.fredoka(28)),
                const SizedBox(height: 8),
                Text(
                  'This helps us keep the game right for your age.',
                  textAlign: TextAlign.center,
                  style: AppText.nunito(16, color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: CreamCard(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 52,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.leafWash,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        ListWheelScrollView.useDelegate(
                          key: AppKeys.ageGateWheel,
                          controller: _scroll,
                          itemExtent: 52,
                          diameterRatio: 1.6,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (i) => setState(() => _year = _years[i]),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: _years.length,
                            builder: (_, i) => Center(
                              child: Text(
                                '${_years[i]}',
                                style: AppText.fredoka(26, color: _year == _years[i] ? AppColors.text : AppColors.muted),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _year == null ? 'Scroll to pick your birth year' : 'Born in $_year',
                  style: AppText.nunito(14, color: AppColors.muted),
                ),
                const SizedBox(height: 16),
                GameButton(
                  key: AppKeys.ageGateContinue,
                  label: 'Continue',
                  onTap: _year == null ? null : () => widget.onSubmit(_year!),
                ),
                const SizedBox(height: 8),
                Text('Privacy Policy · Terms', style: AppText.nunito(12, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
