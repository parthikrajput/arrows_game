// OWNER: Antigravity (UI). PLACEHOLDER. Keep the constructor; redesign the rest.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';

class WheelScreen extends StatelessWidget {
  const WheelScreen({
    super.key,
    required this.data,
    required this.onSpinFree,
    required this.onSpinAd,
    required this.onBack,
  });

  final WheelData data;
  final VoidCallback onSpinFree;
  final VoidCallback onSpinAd;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final prize = data.prizeIndex == null ? null : data.segments[data.prizeIndex!];
    return Scaffold(
      key: AppKeys.wheelScreen,
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: const Text('Lucky Lily Wheel'),
      ),
      body: ListView(
        children: [
          for (final s in data.segments)
            ListTile(dense: true, title: Text(s.label), trailing: Text('${s.odds * 100}%')),
          if (data.timeLocked) const Text('Your clock seems off — jungle time will return soon'),
          if (prize != null) Text('You won: ${prize.label}'),
          FilledButton(
            key: AppKeys.wheelSpinFree,
            onPressed: data.freeAvailable && !data.busy ? onSpinFree : null,
            child: Text(data.freeUsed ? 'Free spin used' : 'Spin free'),
          ),
          TextButton(
            key: AppKeys.wheelSpinAd,
            onPressed: data.adAvailable && !data.busy ? onSpinAd : null,
            child: Text(data.adUsed ? 'Come back tomorrow' : '🎬 Spin again (1 left)'),
          ),
        ],
      ),
    );
  }
}
