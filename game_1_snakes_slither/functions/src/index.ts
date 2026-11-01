// verifyPurchase: server-side receipt validation for Snakes Slither store
// purchases. The app grants nothing until this answers {valid: true}.
//
// Config (Firebase secrets / env):
//   PLAY_PACKAGE_NAME   Android application id
//   APPLE_SHARED_SECRET App Store Connect app-specific shared secret
// The function's service account needs the "View financial data" permission
// in Play Console for the Android Publisher API.
import { initializeApp } from 'firebase-admin/app';
import { onRequest } from 'firebase-functions/v2/https';
import { google } from 'googleapis';

initializeApp();

const PRODUCTS = new Set(['coins_s', 'coins_m', 'coins_l', 'coins_xl', 'starter_pack', 'vip_monthly']);
const SUBSCRIPTIONS = new Set(['vip_monthly']);

type Body = { productId?: string; source?: string; receipt?: string; purchaseId?: string };
type Result = { valid: boolean; expiresUtc?: string; reason?: string };

async function verifyGoogle(productId: string, token: string): Promise<Result> {
  const packageName = process.env.PLAY_PACKAGE_NAME;
  if (!packageName) throw new Error('PLAY_PACKAGE_NAME not set');
  const auth = new google.auth.GoogleAuth({ scopes: ['https://www.googleapis.com/auth/androidpublisher'] });
  const publisher = google.androidpublisher({ version: 'v3', auth });
  if (SUBSCRIPTIONS.has(productId)) {
    const r = await publisher.purchases.subscriptionsv2.get({ packageName, token });
    const state = r.data.subscriptionState;
    const expiry = r.data.lineItems?.[0]?.expiryTime ?? undefined;
    const active = state === 'SUBSCRIPTION_STATE_ACTIVE' || state === 'SUBSCRIPTION_STATE_IN_GRACE_PERIOD';
    return { valid: active, expiresUtc: expiry, reason: active ? undefined : state ?? 'unknown' };
  }
  const r = await publisher.purchases.products.get({ packageName, productId, token });
  // 0 = purchased, 1 = canceled, 2 = pending.
  const ok = r.data.purchaseState === 0;
  return { valid: ok, reason: ok ? undefined : `purchaseState ${r.data.purchaseState}` };
}

async function verifyApple(productId: string, receipt: string): Promise<Result> {
  const secret = process.env.APPLE_SHARED_SECRET;
  const body = JSON.stringify({ 'receipt-data': receipt, password: secret, 'exclude-old-transactions': true });
  const post = (url: string) =>
    fetch(url, { method: 'POST', body, headers: { 'Content-Type': 'application/json' } }).then((r) => r.json());
  let j = await post('https://buy.itunes.apple.com/verifyReceipt');
  if (j.status === 21007) j = await post('https://sandbox.itunes.apple.com/verifyReceipt'); // sandbox receipt
  if (j.status !== 0) return { valid: false, reason: `apple status ${j.status}` };
  const items: Array<{ product_id: string; expires_date_ms?: string }> = [
    ...(j.latest_receipt_info ?? []),
    ...(j.receipt?.in_app ?? []),
  ].filter((i: { product_id: string }) => i.product_id === productId);
  if (items.length === 0) return { valid: false, reason: 'product not in receipt' };
  if (SUBSCRIPTIONS.has(productId)) {
    const latest = Math.max(...items.map((i) => Number(i.expires_date_ms ?? 0)));
    return { valid: latest > Date.now(), expiresUtc: new Date(latest).toISOString() };
  }
  return { valid: true };
}

export const verifyPurchase = onRequest({ cors: false, region: 'asia-south1' }, async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ valid: false, reason: 'POST only' });
    return;
  }
  const b = (req.body ?? {}) as Body;
  if (!b.productId || !PRODUCTS.has(b.productId) || !b.receipt || typeof b.receipt !== 'string' || b.receipt.length > 100000) {
    res.status(400).json({ valid: false, reason: 'bad request' });
    return;
  }
  try {
    const result =
      b.source === 'google_play'
        ? await verifyGoogle(b.productId, b.receipt)
        : b.source === 'app_store'
          ? await verifyApple(b.productId, b.receipt)
          : { valid: false, reason: 'unknown store' };
    // Idempotent: a retry of the same purchase gets the same answer. The app
    // remembers which purchase ids it already paid out (no accounts in Phase 1).
    res.json(result);
  } catch (e) {
    console.error('verifyPurchase failed', e);
    // 5xx tells the app to keep the purchase and retry later.
    res.status(503).json({ valid: false, reason: 'try later' });
  }
});
