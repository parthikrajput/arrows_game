import 'package:flutter/widgets.dart';
import 'package:puzzle_core/puzzle_core.dart';
import 'app_logger.dart';

/// Wraps interactive widgets with semantic ID logging.
class LoggedTap extends StatelessWidget {
  const LoggedTap({
    super.key,
    required this.id,
    required this.child,
    this.onTap,
  });

  final String id;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        AppLogger.instance.debug(
          'input',
          LogCodes.inputTap,
          'Tap down on $id',
          {'target': id},
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          AppLogger.instance.info(
            'input',
            LogCodes.inputTap,
            'Tap handled on $id',
            {'target': id},
          );
          onTap?.call();
        },
        child: child,
      ),
    );
  }
}
