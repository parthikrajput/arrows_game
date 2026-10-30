import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/garden_background.dart';
import '../../core/widgets/pip.dart';
import '../../state/settings_cubit.dart';

/// Neutral age gate: a birth-year wheel with no pre-selected age.
class AgeGatePage extends StatefulWidget {
  const AgeGatePage({super.key});

  @override
  State<AgeGatePage> createState() => _AgeGatePageState();
}

class _AgeGatePageState extends State<AgeGatePage> {
  final int _now = DateTime.now().year;
  int? _year;
  late final FixedExtentScrollController _wheel = FixedExtentScrollController(initialItem: 50);
  bool _moved = false;

  List<int> get _years => [for (var y = _now; y >= _now - 100; y--) y];

  @override
  void dispose() {
    _wheel.dispose();
    super.dispose();
  }

  void _continue() {
    final year = _year;
    if (year == null) return;
    context.read<SettingsCubit>().ageSubmitted(year);
    // The Google UMP consent form shows here (EEA/UK) once ads are enabled.
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GardenBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Space.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: CreamCard(
                  padding: const EdgeInsets.all(Space.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Pip(pose: PipPose.wave, size: 110),
                      Text('When were you born?', style: AppText.h1, textAlign: TextAlign.center),
                      const SizedBox(height: Space.sm),
                      Text('Scroll to pick your birth year.', style: AppText.caption),
                      const SizedBox(height: Space.lg),
                      SizedBox(
                        height: 170,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(Radii.sm),
                              ),
                            ),
                            NotificationListener<ScrollStartNotification>(
                              onNotification: (_) {
                                if (!_moved) setState(() => _moved = true);
                                return false;
                              },
                              child: ListWheelScrollView.useDelegate(
                                controller: _wheel,
                                itemExtent: 48,
                                diameterRatio: 1.6,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (i) => setState(() => _year = _years[i]),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: _years.length,
                                  builder: (_, i) => Center(
                                    child: Text(
                                      // Nothing is pre-selected: the wheel shows "—" until the player moves it.
                                      _moved ? '${_years[i]}' : (i == 50 ? '— — — —' : '${_years[i]}'),
                                      style: AppText.h1.copyWith(
                                        color: _year == _years[i] ? AppColors.primaryDark : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Space.lg),
                      BevelButton.text('Continue', expand: true, logId: 'age.continue', onPressed: _year == null ? null : _continue),
                      const SizedBox(height: Space.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: () {}, child: const Text('Privacy Policy')),
                          Text('·', style: AppText.caption),
                          TextButton(onPressed: () {}, child: const Text('Terms')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
