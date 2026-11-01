import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../logging/app_logger.dart';
import 'package:puzzle_core/puzzle_core.dart' show LogCodes;

/// Store product ids. The same ids are set up in Play Console and App Store
/// Connect.
class StoreIds {
  const StoreIds._();
  static const coinsS = 'coins_s';
  static const coinsM = 'coins_m';
  static const coinsL = 'coins_l';
  static const coinsXl = 'coins_xl';
  static const starterPack = 'starter_pack';
  static const vipMonthly = 'vip_monthly';

  static const consumables = {coinsS, coinsM, coinsL, coinsXl};
  static const all = {coinsS, coinsM, coinsL, coinsXl, starterPack, vipMonthly};
}

class StoreProduct {
  const StoreProduct({required this.id, required this.price});
  final String id;

  /// Localised price from the store (₹49 …).
  final String price;
}

enum StorePurchaseStatus { pending, purchased, restored, error, canceled }

class StorePurchase {
  const StorePurchase({
    required this.productId,
    required this.purchaseId,
    required this.status,
    required this.receipt,
    required this.source,
    this.native,
  });
  final String productId;

  /// Order id; granted purchases are remembered by this id so a replayed
  /// update can never pay twice.
  final String purchaseId;
  final StorePurchaseStatus status;

  /// Server verification data (purchase token / receipt).
  final String receipt;

  /// "google_play" or "app_store".
  final String source;
  final Object? native;
}

/// The platform store.
abstract class StoreService {
  Future<bool> isAvailable();
  Future<List<StoreProduct>> products(Set<String> ids);
  Stream<List<StorePurchase>> get purchases;
  Future<void> buy(String productId, {required bool consumable});
  Future<void> restore();

  /// Tells the store the item was delivered (else it is refunded).
  Future<void> complete(StorePurchase p);
}

/// Real store through `in_app_purchase` (Google Play Billing / StoreKit).
class PlatformStoreService implements StoreService {
  PlatformStoreService([InAppPurchase? iap]) : _iap = iap ?? InAppPurchase.instance;
  final InAppPurchase _iap;
  final _details = <String, ProductDetails>{};

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<StoreProduct>> products(Set<String> ids) async {
    final r = await _iap.queryProductDetails(ids);
    for (final d in r.productDetails) {
      _details[d.id] = d;
    }
    return [for (final d in r.productDetails) StoreProduct(id: d.id, price: d.price)];
  }

  @override
  Stream<List<StorePurchase>> get purchases => _iap.purchaseStream.map(
    (list) => [
      for (final p in list)
        StorePurchase(
          productId: p.productID,
          purchaseId: p.purchaseID ?? '${p.productID}:${p.transactionDate}',
          status: switch (p.status) {
            PurchaseStatus.pending => StorePurchaseStatus.pending,
            PurchaseStatus.purchased => StorePurchaseStatus.purchased,
            PurchaseStatus.restored => StorePurchaseStatus.restored,
            PurchaseStatus.error => StorePurchaseStatus.error,
            PurchaseStatus.canceled => StorePurchaseStatus.canceled,
          },
          receipt: p.verificationData.serverVerificationData,
          source: p.verificationData.source,
          native: p,
        ),
    ],
  );

  @override
  Future<void> buy(String productId, {required bool consumable}) async {
    final d = _details[productId];
    if (d == null) throw StateError('Product $productId not loaded');
    final param = PurchaseParam(productDetails: d);
    if (consumable) {
      await _iap.buyConsumable(purchaseParam: param);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  @override
  Future<void> restore() => _iap.restorePurchases();

  @override
  Future<void> complete(StorePurchase p) async {
    final n = p.native;
    if (n is PurchaseDetails && n.pendingCompletePurchase) await _iap.completePurchase(n);
  }
}

/// Result of server receipt validation.
class Verification {
  const Verification({required this.valid, this.expiresUtc, this.retryLater = false});
  final bool valid;

  /// VIP renewal end.
  final DateTime? expiresUtc;

  /// Network or server trouble: keep the purchase and try again later.
  final bool retryLater;
}

abstract class PurchaseVerifier {
  Future<Verification> verify(StorePurchase p);
}

/// Calls the `verifyPurchase` Cloud Function. Its URL is set at build time
/// (`--dart-define=VERIFY_PURCHASE_URL=…`).
class CloudFunctionVerifier implements PurchaseVerifier {
  CloudFunctionVerifier(this.url);
  final String url;

  static const configuredUrl = String.fromEnvironment('VERIFY_PURCHASE_URL');

  @override
  Future<Verification> verify(StorePurchase p) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final req = await client.postUrl(Uri.parse(url));
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({'productId': p.productId, 'source': p.source, 'receipt': p.receipt, 'purchaseId': p.purchaseId}));
      final res = await req.close().timeout(const Duration(seconds: 15));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode >= 500) return const Verification(valid: false, retryLater: true);
      final j = jsonDecode(body) as Map<String, dynamic>;
      return Verification(
        valid: j['valid'] == true,
        expiresUtc: DateTime.tryParse(j['expiresUtc'] as String? ?? '')?.toUtc(),
      );
    } catch (e) {
      AppLogger.instance.warn('iap', LogCodes.iapVerificationFailure, 'verify failed', {'error': '$e'});
      return const Verification(valid: false, retryLater: true);
    } finally {
      client.close();
    }
  }
}

/// No server configured: nothing is granted, purchases wait. Never trusts
/// a receipt on the device.
class UnconfiguredVerifier implements PurchaseVerifier {
  @override
  Future<Verification> verify(StorePurchase p) async => const Verification(valid: false, retryLater: true);
}

PurchaseVerifier defaultVerifier() => CloudFunctionVerifier.configuredUrl.isEmpty
    ? UnconfiguredVerifier()
    : CloudFunctionVerifier(CloudFunctionVerifier.configuredUrl);

/// Test and preview store: every product exists and every purchase works.
class FakeStoreService implements StoreService {
  FakeStoreService({this.available = true});
  bool available;
  final _ctrl = StreamController<List<StorePurchase>>.broadcast();
  final completed = <String>[];
  final owned = <String>{};
  var _n = 0;

  static const prices = {
    StoreIds.coinsS: '₹49',
    StoreIds.coinsM: '₹149',
    StoreIds.coinsL: '₹299',
    StoreIds.coinsXl: '₹699',
    StoreIds.starterPack: '₹79',
    StoreIds.vipMonthly: '₹20',
  };

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<StoreProduct>> products(Set<String> ids) async => [
    for (final id in ids)
      if (prices.containsKey(id)) StoreProduct(id: id, price: prices[id]!),
  ];

  @override
  Stream<List<StorePurchase>> get purchases => _ctrl.stream;

  @override
  Future<void> buy(String productId, {required bool consumable}) async {
    if (!consumable) owned.add(productId);
    _ctrl.add([
      StorePurchase(
        productId: productId,
        purchaseId: 'fake-${++_n}',
        status: StorePurchaseStatus.purchased,
        receipt: 'fake',
        source: 'fake',
      ),
    ]);
  }

  @override
  Future<void> restore() async => _ctrl.add([
    for (final id in owned)
      StorePurchase(
        productId: id,
        purchaseId: 'restored-$id',
        status: StorePurchaseStatus.restored,
        receipt: 'fake',
        source: 'fake',
      ),
  ]);

  @override
  Future<void> complete(StorePurchase p) async => completed.add(p.purchaseId);
}

/// Accepts every receipt; only for the fake store.
class TrustingVerifier implements PurchaseVerifier {
  @override
  Future<Verification> verify(StorePurchase p) async => Verification(
    valid: true,
    expiresUtc: p.productId == StoreIds.vipMonthly ? DateTime.now().toUtc().add(const Duration(days: 30)) : null,
  );
}

/// Debug builds without a server use the fake store so the Shop can be
/// tried; release builds always use the real store.
bool get useFakeStore => kDebugMode && CloudFunctionVerifier.configuredUrl.isEmpty;
