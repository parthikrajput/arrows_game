import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../services/audio_service.dart';

/// Shows a game popup: scrim + card that scales in with `popupIn` (easeOutBack).
Future<T?> showGamePopup<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool dismissible = false,
}) {
  context.read<AppServices>().audio.play(Sfx.popupOpen);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: 'Close',
    barrierColor: AppColors.scrim,
    transitionDuration: Motion.popupIn,
    pageBuilder: (ctx, _, _) => builder(ctx),
    transitionBuilder: (_, a, _, child) {
      final scale = CurvedAnimation(parent: a, curve: Motion.popupCurve, reverseCurve: Curves.easeIn);
      return FadeTransition(
        opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
        child: ScaleTransition(scale: Tween(begin: 0.85, end: 1.0).animate(scale), child: child),
      );
    },
  );
}

/// Cream popup body with an optional floating header ribbon.
class PopupCard extends StatelessWidget {
  const PopupCard({super.key, required this.child, this.title, this.maxWidth = 380, this.onClose});
  final Widget child;
  final String? title;
  final double maxWidth;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(Space.xl, title == null ? Space.xl : Space.xxl, Space.xl, Space.xl),
                    decoration: BoxDecoration(
                      color: AppColors.bgCream,
                      borderRadius: BorderRadius.circular(Radii.lg),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: Shadows.elev2,
                    ),
                    child: SingleChildScrollView(child: child),
                  ),
                  if (title != null)
                    Positioned(
                      top: -20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.sm),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF7BD27E), AppColors.primary]),
                            borderRadius: BorderRadius.circular(Radii.pill),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: Shadows.bevel(AppColors.primaryDark),
                          ),
                          child: Text(title!, style: AppText.h2.copyWith(color: Colors.white), textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  if (onClose != null)
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Semantics(
                        button: true,
                        label: 'Close',
                        child: GestureDetector(
                          onTap: onClose,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.danger,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: Shadows.elev1,
                            ),
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple yes/no confirm built on the game popup.
Future<bool> confirmPopup(BuildContext context, {required String title, required String message, String yes = 'Yes', String no = 'Cancel'}) async {
  final r = await showGamePopup<bool>(
    context,
    dismissible: true,
    builder: (ctx) => PopupCard(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppText.body, textAlign: TextAlign.center),
          const SizedBox(height: Space.xl),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: Text(no))),
              const SizedBox(width: Space.md),
              Expanded(child: FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(yes))),
            ],
          ),
        ],
      ),
    ),
  );
  return r ?? false;
}
