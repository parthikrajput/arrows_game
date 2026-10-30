// OWNER: UI agent. PLACEHOLDER. Keep the constructor; redesign the
// HUD (64 dp) and booster bar (88 dp). [board] is a ready-made widget:
// place it in the remaining space, don't wrap it in gesture detectors.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({
    super.key,
    required this.hud,
    required this.boosters,
    required this.board,
    required this.hammerMode,
    required this.onPause,
    required this.onBooster,
    required this.onCancelHammer,
  });

  final HudData hud;

  /// Always Hint, Shield, Hammer in that order.
  final List<BoosterButtonData> boosters;
  final Widget board;

  /// Show the banner "Tap a snake or rock · Cancel".
  final bool hammerMode;
  final VoidCallback onPause;
  final void Function(Booster b) onBooster;
  final VoidCallback onCancelHammer;

  static const _icon = {Booster.hint: '🪲✨', Booster.shield: '🐚', Booster.hammer: '🔨'};

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.gameplayScreen,
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 64,
            child: Row(
              children: [
                IconButton(
                  key: AppKeys.pauseButton,
                  onPressed: onPause,
                  icon: const Icon(Icons.pause),
                ),
                Text('Lv ${hud.level}${hud.isHard ? ' 🐾' : ''}'),
                const Spacer(),
                Text(
                  '${'♥' * hud.hearts}${'♡' * (hud.maxHearts - hud.hearts)}'
                  '${hud.shieldCharges > 0 ? ' 🐚${hud.shieldCharges}' : ''}',
                ),
                const Spacer(),
                Text('Moves ${hud.moves}   🪙${hud.coins}  '),
              ],
            ),
          ),
          if (hammerMode)
            TextButton(
              key: AppKeys.hammerCancel,
              onPressed: onCancelHammer,
              child: const Text('Tap a snake or rock · Cancel'),
            ),
          Expanded(child: board),
          SizedBox(
            height: 88,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final b in boosters)
                  OutlinedButton(
                    key: AppKeys.booster(b.booster.name),
                    onPressed: b.locked || !b.enabled ? null : () => onBooster(b.booster),
                    child: Text(
                      b.locked
                          ? '🔒 L${b.unlockLevel}'
                          : b.capReached
                          ? '${_icon[b.booster]} ${b.used}/${b.cap}'
                          : '${_icon[b.booster]} ${b.count}${b.active ? ' •' : ''}',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
