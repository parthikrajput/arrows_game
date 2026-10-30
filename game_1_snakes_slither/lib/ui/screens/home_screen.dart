// OWNER: UI agent. PLACEHOLDER. Keep the constructor; redesign the rest.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.data,
    required this.onPlay,
    required this.onOpenMap,
    required this.onOpenSettings,
    required this.onOpenShop,
    required this.onOpenWheel,
  });

  final HomeData data;
  final VoidCallback onPlay;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenShop;

  /// Only shown when data.wheelUnlocked.
  final VoidCallback onOpenWheel;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.homeScreen,
    appBar: AppBar(
      title: Text('🪙 ${data.coins}'),
      actions: [
        IconButton(
          key: AppKeys.homeSettings,
          onPressed: onOpenSettings,
          icon: const Icon(Icons.settings),
        ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            key: AppKeys.homePlay,
            onPressed: data.allCleared ? null : onPlay,
            child: Text(data.allCleared ? 'More levels soon' : '▶  LEVEL ${data.nextLevel}'),
          ),
          TextButton(key: AppKeys.homeMap, onPressed: onOpenMap, child: const Text('Map')),
          TextButton(key: AppKeys.homeShop, onPressed: onOpenShop, child: const Text('🛒 Shop')),
          if (data.wheelUnlocked)
            TextButton(
              key: AppKeys.homeWheel,
              onPressed: onOpenWheel,
              child: Text('🌸 Spin${data.freeSpinReady ? ' (1)' : ''}'),
            ),
        ],
      ),
    ),
  );
}
