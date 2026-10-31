// OWNER: UI agent. Canvas: Shop.dc.html (Boosters · Coins · Offers).
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../popups/popups.dart' show boosterName;
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

class ShopScreen extends StatefulWidget {
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
  State<ShopScreen> createState() => _ShopScreenState();
}

enum _Tab { boosters, coins, offers }

class _ShopScreenState extends State<ShopScreen> {
  _Tab _tab = _Tab.boosters;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Scaffold(
      key: AppKeys.shopScreen,
      body: CreamBackground(
        leaves: false,
        child: SafeArea(
          child: CenteredColumn(
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        RoundButton(
                          size: 40,
                          label: 'Back',
                          onTap: widget.onBack,
                          child: const LineIconView(LineIcon.back, size: 18),
                        ),
                        Expanded(
                          child: Text('Shop', textAlign: TextAlign.center, style: AppText.fredoka(22)),
                        ),
                        CoinPill(coins: d.coins),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: _Tabs(value: _tab, onPick: (t) => setState(() => _tab = t)),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: switch (_tab) {
                      _Tab.boosters => _boosters(d),
                      _Tab.coins => [_unavailable('Coin packs')],
                      _Tab.offers => [_unavailable('Starter Pack and VIP No-Ads Pass')],
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _boosters(ShopData d) {
    final freeOk = d.freeCoinsLeft > 0 && d.adAvailable && !d.busy;
    return [
      LayoutBuilder(
        builder: (_, box) {
          final w = (box.maxWidth - 20) / 3;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final t in d.tiles)
                SizedBox(
                  width: w,
                  child: _Tile(tile: t, onTap: () => widget.onBuy(t)),
                ),
            ],
          );
        },
      ),
      const SizedBox(height: 14),
      CreamCard(
        key: AppKeys.shopFreeCoins,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFFFFF3D6), borderRadius: BorderRadius.circular(14)),
              child: const LineIconView(LineIcon.video, size: 24, color: Color(0xFFD9822B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Free +${d.freeCoinsAmount} coins', style: AppText.fredoka(17)),
                  Text(
                    !d.adAvailable ? 'Ad unavailable' : 'Watch an ad · ${d.freeCoinsLeft} left today',
                    style: AppText.nunito(12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 86,
              child: GameButton(
                label: 'Watch',
                height: 36,
                fontSize: 15,
                shine: false,
                onTap: freeOk ? widget.onFreeCoins : null,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'Restore purchases · Terms · Privacy',
        textAlign: TextAlign.center,
        style: AppText.nunito(12, color: AppColors.muted),
      ),
    ];
  }

  Widget _unavailable(String what) => CreamCard(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        const ArtIcon(Art.coin, size: 48),
        const SizedBox(height: 10),
        Text('Store unavailable', style: AppText.fredoka(20)),
        const SizedBox(height: 4),
        Text(
          '$what will appear here when the store is ready.',
          textAlign: TextAlign.center,
          style: AppText.nunito(14, weight: 700, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.value, required this.onPick});
  final _Tab value;
  final void Function(_Tab) onPick;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: AppColors.track, borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        for (final t in _Tab.values)
          Expanded(
            child: Semantics(
              selected: t == value,
              child: Pressable(
                onTap: () => onPick(t),
                semanticLabel: switch (t) {
                  _Tab.boosters => 'Boosters',
                  _Tab.coins => 'Coins',
                  _Tab.offers => 'Offers',
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: t == value
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF1E9C5C), Color(0xFF0B6B3E)],
                          )
                        : null,
                    boxShadow: t == value
                        ? const [BoxShadow(color: Color(0x4D075B35), offset: Offset(0, 3), blurRadius: 8)]
                        : null,
                  ),
                  child: Text(switch (t) {
                    _Tab.boosters => 'Boosters',
                    _Tab.coins => 'Coins',
                    _Tab.offers => 'Offers',
                  }, style: AppText.fredoka(15, color: t == value ? Colors.white : const Color(0xFF4C6152))),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.tile, required this.onTap});
  final ShopTileData tile;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final t = tile;
    final can = !t.locked && t.affordable;
    return Pressable(
      key: AppKeys.shopTile(t.booster.name, t.quantity),
      onTap: can ? onTap : null,
      semanticLabel: t.locked
          ? '${boosterName(t.booster)}, unlocks at level ${t.unlockLevel}'
          : '${t.quantity} ${boosterName(t.booster)} for ${t.price} coins',
      child: Opacity(
        opacity: t.locked ? .7 : 1,
        child: CreamCard(
          radius: 18,
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
          child: Column(
            children: [
              ArtIcon(ArtIcon.booster(t.booster), size: 52, dim: t.locked),
              const SizedBox(height: 4),
              Text(
                boosterName(t.booster),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppText.fredoka(14, height: 1.1),
              ),
              Text('× ${t.quantity}', style: AppText.nunito(12, color: AppColors.muted)),
              const SizedBox(height: 6),
              if (t.locked)
                Container(
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.track, borderRadius: BorderRadius.circular(12)),
                  child: Text('Unlocks at L${t.unlockLevel}', style: AppText.nunito(11, color: AppColors.muted)),
                )
              else
                Container(
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: t.affordable ? kGreenButton : null,
                    color: t.affordable ? null : const Color(0xFFD9D2BC),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: t.affordable ? AppColors.lip : const Color(0xFFC2B996),
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ArtIcon(Art.coin, size: 16),
                      const SizedBox(width: 5),
                      Text('${t.price}', style: AppText.fredoka(15, color: Colors.white)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
