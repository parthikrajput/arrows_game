// OWNER: Antigravity (UI). PLACEHOLDER. Keep the constructor; redesign the rest.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';

class LevelMapScreen extends StatelessWidget {
  const LevelMapScreen({
    super.key,
    required this.nodes,
    required this.onLevelTap,
    required this.onBack,
  });

  /// Level 1 first.
  final List<LevelNodeData> nodes;

  /// Only called for unlocked nodes.
  final void Function(int level) onLevelTap;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.mapScreen,
    appBar: AppBar(
      leading: BackButton(onPressed: onBack),
      title: const Text('Map'),
    ),
    body: ListView(
      children: [
        for (final n in nodes)
          ListTile(
            key: AppKeys.mapNode(n.number),
            enabled: n.state != NodeState.locked,
            title: Text('Level ${n.number}${n.isHard ? '  🐾 Hard' : ''}'),
            subtitle: Text(switch (n.state) {
              NodeState.locked => '🔒',
              NodeState.current => '◉ You are here',
              NodeState.cleared => '★' * n.stars,
            }),
            onTap: n.state == NodeState.locked ? null : () => onLevelTap(n.number),
          ),
      ],
    ),
  );
}
