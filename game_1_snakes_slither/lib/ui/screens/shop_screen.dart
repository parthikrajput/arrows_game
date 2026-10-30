// OWNER: UI agent. PLACEHOLDER. Keep the constructor; redesign the rest.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({
    super.key,
    required this.data,
    required this.onBuy,
    required this.onFreeCoins,
    required this.onBack,
  });

  final ShopData data;

  /// Logic re-checks lock and coins; show a confirm step before calling if you like.
  final void Function(ShopTileData tile) onBuy;
  final VoidCallback onFreeCoins;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.shopScreen,
    appBar: AppBar(
      leading: BackButton(onPressed: onBack),
      title: Text('Shop   🪙 ${data.coins}'),
    ),
    body: ListView(
      children: [
        for (final t in data.tiles)
          ListTile(
            key: AppKeys.shopTile(t.booster.name, t.quantity),
            title: Text('${t.quantity} × ${t.booster.name}'),
            trailing: Text(t.locked ? 'Unlocks at L${t.unlockLevel}' : '${t.price} 🪙'),
            enabled: !t.locked && t.affordable,
            onTap: () => onBuy(t),
          ),
        ListTile(
          key: AppKeys.shopFreeCoins,
          enabled: data.freeCoinsLeft > 0 && data.adAvailable && !data.busy,
          title: Text('🎬 Free +${data.freeCoinsAmount} 🪙 (${data.freeCoinsLeft} left)'),
          onTap: onFreeCoins,
        ),
        if (!data.storeAvailable) const ListTile(title: Text('Coins & Offers: Store unavailable')),
      ],
    ),
  );
}
