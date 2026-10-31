import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Cream popup container with radius lg (24), elev2 shadow,
/// and optional top ribbon title and close button.
/// Follows doc 06 §2.4, §2.5 and canvas look.
class PopupCard extends StatelessWidget {
  const PopupCard({
    super.key,
    required this.child,
    this.title,
    this.maxWidth = 380,
    this.onClose,
    this.padding = const EdgeInsets.all(Space.xl),
  });

  final Widget child;
  final String? title;
  final double maxWidth;
  final VoidCallback? onClose;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).clamp(minScaleFactor: 1.0, maxScaleFactor: 2.0);

    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      padding.left,
                      title != null ? padding.top + 16 : padding.top,
                      padding.right,
                      padding.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgCream,
                      borderRadius: BorderRadius.circular(Radii.lg),
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: Shadows.elev2,
                    ),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: textScale),
                      child: child,
                    ),
                  ),

                  // Floating top title ribbon
                  if (title != null)
                    Positioned(
                      top: -18,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.sm),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.primaryLight, AppColors.primary],
                            ),
                            borderRadius: BorderRadius.circular(Radii.pill),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: Shadows.bevel(AppColors.primaryDark),
                          ),
                          child: Text(
                            title!,
                            style: AppText.h2.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                  // Close button
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
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.danger,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: Shadows.elev1,
                            ),
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
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
