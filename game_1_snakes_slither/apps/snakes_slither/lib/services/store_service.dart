import 'package:flutter/material.dart';

import '../app/theme/text_styles.dart';
import '../app/theme/tokens.dart';
import '../core/logging/app_logger.dart';

class StoreProduct {
  const StoreProduct({required this.sku, required this.title, required this.price, this.coins = 0, this.badge});
  final String sku;
  final String title;

  /// Store-localised price string (never hard-code the currency in UI).
  final String price;
  final int coins;
  final String? badge;
}

enum PurchaseStatus { purchased, cancelled, error, pending }

/// In-app purchase seam. The `in_app_purchase` + `verifyPurchase` implementation
/// replaces [SimulatedStoreService] once store products are configured.
abstract class StoreService {
  Future<List<StoreProduct>> loadProducts();
  Future<PurchaseStatus> buy(StoreProduct product);

  /// Returns the restored non-consumable / subscription skus.
  Future<Set<String>> restore();
}

class SimulatedStoreService implements StoreService {
  SimulatedStoreService(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;
  final Set<String> _owned = {};

  static const products = [
    StoreProduct(sku: 'coins_s', title: '350 coins', price: '₹49', coins: 350),
    StoreProduct(sku: 'coins_m', title: '1,000 coins', price: '₹149', coins: 1000, badge: 'Popular'),
    StoreProduct(sku: 'coins_l', title: '2,200 coins', price: '₹299', coins: 2200),
    StoreProduct(sku: 'coins_xl', title: '5,500 coins', price: '₹699', coins: 5500, badge: 'Best Value'),
    StoreProduct(sku: 'starter_pack', title: 'Starter Pack', price: '₹79'),
    StoreProduct(sku: 'vip_monthly', title: 'VIP No-Ads Pass', price: '₹20'),
  ];

  @override
  Future<List<StoreProduct>> loadProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return products;
  }

  @override
  Future<PurchaseStatus> buy(StoreProduct product) async {
    final context = _navigatorKey.currentContext;
    if (context == null) return PurchaseStatus.error;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Test store', style: AppText.caption),
              const SizedBox(height: Space.xs),
              Text(product.title, style: AppText.h2),
              Text('${product.price} · no real money is charged in this build', style: AppText.body),
              const SizedBox(height: Space.xl),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Buy')),
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
    if (ok != true) return PurchaseStatus.cancelled;
    log.i('iap_purchase ${product.sku}');
    if (product.sku == 'starter_pack' || product.sku == 'vip_monthly') _owned.add(product.sku);
    return PurchaseStatus.purchased;
  }

  @override
  Future<Set<String>> restore() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return {..._owned};
  }
}
