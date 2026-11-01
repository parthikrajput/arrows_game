// OWNER: UI agent. Canvas: Vip.dc.html, Starter.dc.html.
import 'package:flutter/material.dart';

import '../../contracts/app_keys.dart';
import '../../contracts/view_models.dart';
import '../theme/tokens.dart';
import '../widgets/art.dart';
import '../widgets/common.dart';

const _vip = Color(0xFF7E57C2);

class VipScreen extends StatelessWidget {
  const VipScreen({
    super.key,
    required this.price,
    required this.active,
    required this.busy,
    required this.onSubscribe,
    required this.onRestore,
    required this.onBack,
    this.message,
  });

  /// Localised price ("₹20"); null while the store is unavailable.
  final String? price;
  final bool active;
  final bool busy;
  final VoidCallback onSubscribe;
  final VoidCallback onRestore;
  final VoidCallback onBack;
  final String? message;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: AppKeys.vipScreen,
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
                      RoundButton(size: 40, label: 'Back', onTap: onBack, child: const LineIconView(LineIcon.back, size: 18)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: _vip,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: const [BoxShadow(color: Color(0x557E57C2), offset: Offset(0, 8), blurRadius: 18)],
                        ),
                        child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 48),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('VIP No-Ads Pass', textAlign: TextAlign.center, style: AppText.fredoka(28)),
                    Text(
                      'Play the garden without interruptions',
                      textAlign: TextAlign.center,
                      style: AppText.nunito(15, color: AppColors.muted),
                    ),
                    const SizedBox(height: 16),
                    CreamCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Column(
                        children: [
                          for (final p in const [
                            'No banner ads',
                            'No interstitial ads between levels',
                            'Rewarded ads stay optional (revive, 2X, free coins)',
                          ])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 22),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(p, style: AppText.nunito(15))),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (price != null)
                      Text('$price / month', textAlign: TextAlign.center, style: AppText.fredoka(26, color: _vip)),
                    const SizedBox(height: 6),
                    Text(
                      'Auto-renews every month until you cancel. Cancel anytime in your store\'s subscriptions. '
                      'If it ends, ads come back.',
                      textAlign: TextAlign.center,
                      style: AppText.nunito(13, color: AppColors.muted),
                    ),
                    const SizedBox(height: 16),
                    GameButton(
                      key: AppKeys.vipSubscribe,
                      label: active ? 'VIP active' : (price == null ? 'Store unavailable' : 'Subscribe'),
                      onTap: active || price == null || busy ? null : onSubscribe,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 8),
                      Text(message!, textAlign: TextAlign.center, style: AppText.nunito(13, color: AppColors.muted)),
                    ],
                    TextButton(
                      onPressed: onRestore,
                      child: Text('Restore · Terms · Privacy', style: AppText.nunito(13, color: AppColors.muted)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// One-time Starter Pack offer, shown once after Level 15.
class StarterPackPopup extends StatelessWidget {
  const StarterPackPopup({super.key, required this.data, required this.onBuy, required this.onClose});
  final StarterOfferData data;
  final VoidCallback onBuy;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => PopupCard(
    key: AppKeys.starterPopup,
    badge: '${data.timeLeft} left · one time only',
    children: [
      Text('Starter Pack', style: AppText.fredoka(28)),
      Text('A head start for your jungle adventure', textAlign: TextAlign.center, style: AppText.nunito(15, color: AppColors.muted)),
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ArtIcon(Art.coin, size: 34),
          const SizedBox(width: 6),
          Text('${fmt(data.coins)} coins', style: AppText.fredoka(24)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final e in data.boosters.entries) ...[
            ArtIcon(ArtIcon.booster(e.key), size: 32),
            Text(' ×${e.value}', style: AppText.fredoka(18)),
            const SizedBox(width: 12),
          ],
        ],
      ),
      const SizedBox(height: 16),
      GameButton(key: AppKeys.starterPopupBuy, label: data.price, onTap: onBuy),
      TextButton(
        key: AppKeys.starterPopupNo,
        onPressed: onClose,
        child: Text('No thanks', style: AppText.nunito(14, color: AppColors.muted)),
      ),
      Text(
        'Also in Shop → Offers until the timer ends.',
        textAlign: TextAlign.center,
        style: AppText.nunito(12, color: AppColors.muted),
      ),
    ],
  );
}
