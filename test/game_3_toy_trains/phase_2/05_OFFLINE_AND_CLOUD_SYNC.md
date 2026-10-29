# 05 · Offline-First & Cloud Sync — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 નું offline-first architecture — Firebase Auth (anonymous → Google/Apple link), Firestore cloud save, UUID op-log (idempotent coin/booster/purchase ops), conflict rules, compile-correct Dart sync service (connectivity_plus current API), retry/backoff, account deletion, અને શું internet માંગે છે.

**Related docs:** [Shared Core Standard §8.4, §13, §14](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Frontend §9 (save schema)](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Principles (સિદ્ધાંતો)

1. **Offline-first:** Hive local save હંમેશા source of play. Levels 1–1000 bundled; કોઈ level રમવા internet નથી જોઈતું.
2. **Server-authoritative values via ops:** coins, boosters, piggy, cosmetics owned, first-clear rewards, streak — દરેક ફેરફાર એક **op** (UUID v4) તરીકે local queue (`syncQueue`) માં લખાય અને server ledger પર apply થાય.
3. **Local wallet = projection:** `displayed = lastServerSnapshot + Σ pending ops` — op લખ્યા પછી crash થાય તો પણ double-count નહીં.
4. **Idempotent:** server `users/{uid}/ops/{opId}` exists ⇒ એ op ફરી apply નહીં (retry safe).
5. **Device clock never trusted** for ranking or streak decisions (standard §8.4).
6. **Client writes denied** in Firestore rules; બધા writes Cloud Functions (Admin SDK) થી.

## 2. What Works Offline vs Needs Internet

| Feature | Offline | Notes |
|---|---|---|
| Levels 1–1000, boosters, Hint solver, Undo | ✅ | Bundled `phase_1.json.gz`, `phase_2.json.gz` |
| Coins earn/spend, booster buy with coins | ✅ | Queued ops; server reconciles |
| Daily Timetable Run + Express Streak | ✅ | Local grant; server verifies later (mismatch ⇒ streak freeze, coins not revoked — standard §8.4) |
| Lucky Turntable free spin | ✅ | Server-free PRNG (standard §6.3) |
| Depot Sticker Album, Piggy deposits, cosmetics buy/equip | ✅ | Queued ops |
| Golden Express Coin Rush, Gift Crates, Grand Central Chest | ✅ | Queued ops |
| Cloud Sync, account link, restore on new device | ❌ | Needs internet |
| Weekly Star Race join / submit / claim | ❌ | Join + claim need internet; clears queue offline ([04 §3.7](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |
| IAP (coin packs, VIP, Starter Pack, Piggy break) | ❌ | Store + `verifyPurchase` |
| Ads (rewarded, interstitial, banner) | ❌ | Ad buttons disabled + "Ad unavailable" |
| Leaderboards, Remote Config fetch | ❌ | Bundled RC defaults used offline |
| Account deletion | ❌ | Needs server |

## 3. Firebase Auth

| Step | Behaviour |
|---|---|
| First online launch | `FirebaseAuth.instance.currentUser == null` ⇒ `signInAnonymously()` ⇒ uid stored in Hive `auth.uid` |
| Offline first launch | Play normally; ops queue under `pendingUid = null`; anonymous sign-in on first connectivity, then flush |
| Link (Settings → "Save progress to Google / Apple") | `currentUser.linkWithProvider(GoogleAuthProvider())` (Android/iOS) or `AppleAuthProvider()` (iOS). **uid unchanged** ⇒ no data move |
| Restore on new device | Sign in with Google/Apple ⇒ existing uid ⇒ pull snapshot ⇒ merge with local (§6) |
| `credential-already-in-use` | Provider already belongs to account **B**. Dialog: "This Google account already has a save (L{n}, ★{s})." Options: **[Use that save]** ⇒ sign in as B; local progress (highestCleared, stars, album, cosmetics owned) merged into B by §6 rules; local **wallet is not merged** (B's ledger wins; prevents farming starter wallets); anonymous A deleted. **[Cancel]** ⇒ stay on A |
| Under-13 age band | Linking allowed (store accounts are parent-managed); no display name entry (race uses generated toy-railway names) |

## 4. Firestore Data Model

```
users/{uid}
  schema: 1
  progress: { highestCleared: int, stars: string }        // stars[i] = '0'..'3' for level i+1 (1,000 chars in Phase 2)
  wallet:   { coins: int, boosters: { hint, undo, shield, hammer } }
  piggy:    { balance: int }                               // clamped 0..1000
  album:    { stickers: int[], volumesClaimed: int[] }
  cosmetics:{ owned: string[], equipped: { livery, table }, equippedAt: Timestamp }
  streak:   { day, cycleSaverUsed, lastClaimDayKey, totalDays, trophyTier, lastClaimServerUtc, frozen: bool }
  gifts:    { claimed: int[] }                             // Gift Crate / Chest levels credited
  vip:      { activeUntil: Timestamp? }                    // from verified receipt only
  updatedAt: Timestamp
users/{uid}/ops/{opId}
  type, payload, seq, deviceId, createdAtUtc (client, informational)
  result: 'accepted' | 'rejected', reason?, credit: { coins, boosters }, appliedAt (server), expireAt (TTL 90 d)
races/{raceId}, races/{raceId}/members/{uid}, ghosts/{band}    // see 04 §3.5
```

Size check (computed from this schema): `stars` string 1,000 B (Phase 2) → 10,000 B at L10,000; album ≤ 100 ints; cosmetics ≤ 20 strings ⇒ user doc ≪ Firestore's 1 MiB document limit even at Phase 20.

## 5. Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read: if request.auth != null && request.auth.uid == uid;
      allow write: if false;
      match /ops/{opId} {
        allow read, write: if false;
      }
    }
    match /races/{raceId} {
      allow read: if request.auth != null &&
        exists(/databases/$(database)/documents/races/$(raceId)/members/$(request.auth.uid));
      allow write: if false;
      match /members/{memberId} {
        allow read: if request.auth != null &&
          exists(/databases/$(database)/documents/races/$(raceId)/members/$(request.auth.uid));
        allow write: if false;
      }
    }
    match /ghosts/{doc=**} {
      allow read, write: if false;
    }
  }
}
```
Functions use App Check (`enforceAppCheck: true`) + Auth.

## 6. Conflict Rules (binding)

| Data | Rule | Where |
|---|---|---|
| `progress.highestCleared` | **max**(local, server) | server on `levelClear` op; client on restore |
| `stars[level]` | **max per level** | same |
| `coins` | **server ledger sum** (Σ accepted op credits; aggregate kept transactionally) | server only |
| `boosters` | ledger sum per type | server only |
| First-clear coins / Gift Crate / Chest / album volume reward | credited **once per account** (`gifts.claimed`, deterministic opIds like `gift-{level}`, `album-v{vol}`) — second device's duplicate ⇒ accepted with credit 0 | server |
| `streak` | **server-time authoritative**: server recomputes from `dailyClaim` ops (§7.4); local streak is a projection | server |
| `piggy.balance` | ledger sum, clamped 0–1,000 | server |
| `album.stickers`, `cosmetics.owned` | **set union** | server |
| `cosmetics.equipped` | last write wins by **server** `appliedAt` | server |
| `vip.activeUntil` | verified receipt only | `verifyPurchase` |
| `adReviveUsed`, `settings`, `ads` counters, `session` | **device-local**, never synced | — |
| Race membership/counts | server only | Functions |

**Negative balance (game definition):** spend ops (booster buy, Heart Refill, Streak Saver, cosmetic) are always accepted if the price is valid, because the item was already used offline. If two offline devices spent the same coins, the ledger can go negative. Client shows `max(0, coins)`, blocks new coin spends until balance ≥ price; future earnings repay. No item is revoked.

## 7. Op-Log

### 7.1 Op types
| Type | Payload (client) | Server validation |
|---|---|---|
| `levelClear` | `{level, stars, firstClear, coins}` | level ≤ highestCleared + 1 (ops processed in `seq` order); coins **recomputed** from level `tag` (+20 first ★★★); client `coins` is only a projection hint |
| `coinDelta` | `{coins, source}` (rush, daily, spin, shop-ad, 2x) | per-source caps (rush ≤ 400, daily 100/dayKey, spin per prize table, shop-ad ≤ 5×50/dayKey) |
| `boosterDelta` | `{boosters:{k:n}, coins, sink}` | price table (Phase 1 04 §1) |
| `giftClaim` | `{level, coins, boosters}` | x0 schedule / Chest; once per level |
| `piggyDeposit` | `{amount: 10, level}` | first clear exists; clamp 1,000 |
| `cosmeticBuy` | `{itemId, coins: -price}` | catalog price; not already owned |
| `cosmeticEquip` | `{slot, itemId}` | owned (or VIP item with active VIP) |
| `albumSticker` | `{level}` | level cleared, multiple of 10 |
| `dailyClaim` | `{dayKey, monoElapsedMs, lastTrustedUtc}` | §7.4 |
| `raceClear` | `{raceId, level, moves, durationMs, attemptId}` | forwarded to race validation ([04 §3.6](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |
| `purchaseGrant` | — | **server-generated** by `verifyPurchase` (opId = SHA-256 of purchase token) |

### 7.2 Server `applyOps` (TypeScript sketch, Node 20, Admin SDK)
```ts
export const applyOps = onCall({ enforceAppCheck: true }, async (req) => {
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign-in required');
  const ops = req.data?.ops as ClientOp[];
  if (!Array.isArray(ops) || ops.length === 0 || ops.length > 50) {
    throw new HttpsError('invalid-argument', 'Batch must hold 1–50 ops');
  }
  const acked: string[] = [];
  const rejected: string[] = [];
  let snapshot: PublicSnapshot | undefined;
  await db.runTransaction(async (tx) => {
    const userRef = db.doc(`users/${uid}`);
    const user = ((await tx.get(userRef)).data() as UserDoc | undefined) ?? newUserDoc();
    const sorted = [...ops].sort((a, b) => a.seq - b.seq);
    const refs = sorted.map((o) => db.doc(`users/${uid}/ops/${o.opId}`));
    const existing = await tx.getAll(...refs);          // all reads before any write
    sorted.forEach((op, i) => {
      if (existing[i].exists) { acked.push(op.opId); return; }     // idempotent replay
      const verdict = validateAndPrice(op, user);                  // recompute credit server-side
      tx.set(refs[i], { ...op, result: verdict.ok ? 'accepted' : 'rejected',
        reason: verdict.reason ?? null, credit: verdict.credit,
        appliedAt: FieldValue.serverTimestamp(), expireAt: daysFromNow(90) });
      if (verdict.ok) { applyCredit(user, verdict.credit, op); acked.push(op.opId); }
      else { rejected.push(op.opId); }
    });
    user.updatedAt = Timestamp.now();
    tx.set(userRef, user);
    snapshot = toPublicSnapshot(user);
  });
  return { acked, rejected, snapshot };
});
```
`validateAndPrice`, `applyCredit`, `toPublicSnapshot` = pure functions with unit tests in `functions/test/`.

### 7.3 Client Dart (Flutter 3.x / Dart 3)
Packages: `connectivity_plus` (≥ 6.0 — `onConnectivityChanged` emits `List<ConnectivityResult>`, `checkConnectivity()` returns `Future<List<ConnectivityResult>>`), `cloud_functions`, `hive_ce`, `uuid` (4.x).

```dart
import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

enum OpType {
  levelClear,
  coinDelta,
  boosterDelta,
  giftClaim,
  piggyDeposit,
  cosmeticBuy,
  cosmeticEquip,
  albumSticker,
  dailyClaim,
  raceClear,
}

class SyncOp {
  const SyncOp({
    required this.opId,
    required this.seq,
    required this.type,
    required this.payload,
    required this.createdAtUtc,
  });

  factory SyncOp.fromJson(Map<dynamic, dynamic> json) => SyncOp(
        opId: json['opId'] as String,
        seq: json['seq'] as int,
        type: OpType.values.byName(json['type'] as String),
        payload: Map<String, Object?>.from(json['payload'] as Map),
        createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      );

  final String opId;
  final int seq;
  final OpType type;

  /// Signed `coins` and `boosters` deltas (if any) are always under these keys,
  /// so the wallet projection stays generic.
  final Map<String, Object?> payload;
  final DateTime createdAtUtc;

  Map<String, Object?> toJson() => <String, Object?>{
        'opId': opId,
        'seq': seq,
        'type': type.name,
        'payload': payload,
        'createdAtUtc': createdAtUtc.toIso8601String(),
      };
}

/// Durable FIFO of unacknowledged ops (Hive boxes 'syncQueue' + 'syncMeta').
class OpLog {
  OpLog(this._ops, this._meta);

  final Box<Map> _ops;
  final Box<int> _meta;
  static const Uuid _uuid = Uuid();

  /// Write the op FIRST; UI state is a projection, so a crash right after
  /// this call can never lose or double-count a reward.
  Future<SyncOp> append(OpType type, Map<String, Object?> payload,
      {String? fixedId}) async {
    final seq = _meta.get('nextSeq') ?? 1;
    final op = SyncOp(
      opId: fixedId ?? _uuid.v4(),
      seq: seq,
      type: type,
      payload: payload,
      createdAtUtc: DateTime.now().toUtc(),
    );
    await _meta.put('nextSeq', seq + 1);
    await _ops.put(op.opId, op.toJson());
    return op;
  }

  List<SyncOp> pending() =>
      _ops.values.map(SyncOp.fromJson).toList()
        ..sort((a, b) => a.seq.compareTo(b.seq));

  Future<void> remove(Iterable<String> opIds) => _ops.deleteAll(opIds);
}

typedef WalletView = ({int coins, Map<String, int> boosters});

/// displayed wallet = last server snapshot + all pending deltas.
WalletView projectWallet(Map<String, Object?> snapshot, List<SyncOp> pending) {
  var coins = (snapshot['coins'] as num?)?.toInt() ?? 0;
  final boosters = <String, int>{
    for (final e in ((snapshot['boosters'] as Map?) ?? const {}).entries)
      e.key as String: (e.value as num).toInt(),
  };
  for (final op in pending) {
    coins += (op.payload['coins'] as num?)?.toInt() ?? 0;
    final delta = op.payload['boosters'];
    if (delta is Map) {
      delta.forEach((k, v) {
        final key = k as String;
        boosters[key] = (boosters[key] ?? 0) + (v as num).toInt();
      });
    }
  }
  return (coins: coins, boosters: boosters);
}

abstract interface class SnapshotStore {
  Future<void> saveSnapshot(Map<String, Object?> snapshot);
}

class SyncService {
  SyncService({
    required OpLog log,
    required SnapshotStore store,
    FirebaseFunctions? functions,
    Connectivity? connectivity,
  })  : _log = log,
        _store = store,
        _functions = functions ?? FirebaseFunctions.instance,
        _connectivity = connectivity ?? Connectivity();

  static const int _batchSize = 50;
  static const int _maxBackoffMs = 5 * 60 * 1000;
  static const Set<String> _retryableCodes = <String>{
    'unavailable',
    'deadline-exceeded',
    'internal',
    'resource-exhausted',
    'unauthenticated',
    'aborted',
    'unknown',
  };

  final OpLog _log;
  final SnapshotStore _store;
  final FirebaseFunctions _functions;
  final Connectivity _connectivity;
  final math.Random _random = math.Random();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;
  int _attempt = 0;
  bool _flushing = false;
  bool _online = false;

  Future<void> start() async {
    _subscription = _connectivity.onConnectivityChanged.listen(_onConnectivity);
    _onConnectivity(await _connectivity.checkConnectivity());
  }

  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _subscription?.cancel();
  }

  void _onConnectivity(List<ConnectivityResult> results) {
    _online = results.any((r) => r != ConnectivityResult.none);
    if (_online) {
      unawaited(flush());
    }
  }

  /// Call after every append, on app resume and after sign-in.
  Future<void> flush() async {
    if (_flushing || !_online) return;
    _flushing = true;
    try {
      var pending = _log.pending();
      while (pending.isNotEmpty) {
        final batch = pending.take(_batchSize).toList();
        final callable = _functions.httpsCallable(
          'applyOps',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 20)),
        );
        final result = await callable.call<Object?>(<String, Object?>{
          'ops': batch.map((o) => o.toJson()).toList(),
        });
        final data = Map<String, Object?>.from(result.data! as Map);
        final acked = List<String>.from(data['acked']! as List);
        final rejected =
            List<String>.from((data['rejected'] as List?) ?? const <Object?>[]);
        await _log.remove(<String>[...acked, ...rejected]);
        await _store.saveSnapshot(
            Map<String, Object?>.from(data['snapshot']! as Map));
        if (acked.isEmpty && rejected.isEmpty) {
          _scheduleRetry(); // server made no progress; try later
          return;
        }
        pending = _log.pending();
      }
      _attempt = 0;
    } on FirebaseFunctionsException catch (e) {
      if (_retryableCodes.contains(e.code)) {
        _scheduleRetry();
      }
      // Non-retryable (e.g. invalid-argument): ops stay queued; Crashlytics
      // non-fatal is logged by the caller's zone handler.
    } on TimeoutException {
      _scheduleRetry();
    } finally {
      _flushing = false;
    }
  }

  /// Exponential backoff 2 s, 4 s, 8 s … capped at 5 min, with jitter in
  /// [50 %, 100 %] of the step so many devices don't retry in lock-step.
  void _scheduleRetry() {
    _retryTimer?.cancel();
    final stepMs =
        math.min(_maxBackoffMs, 2000 * (1 << math.min(_attempt, 10)));
    final delayMs = stepMs ~/ 2 + _random.nextInt(stepMs ~/ 2 + 1);
    _attempt++;
    _retryTimer = Timer(Duration(milliseconds: delayMs), () {
      unawaited(flush());
    });
  }
}
```

Usage (WalletCubit): `await opLog.append(OpType.boosterDelta, {'coins': -150, 'boosters': {'hint': 3}, 'sink': 'shop'}); emit(projectWallet(snapshot, opLog.pending())); unawaited(sync.flush());`

### 7.4 Streak & Daily (server-time authoritative)
`dailyClaim` accepted if: `dayKey` > last accepted dayKey; `dayKey` is a valid local date for server-now within UTC−12…UTC+14 **or** (offline claim) `lastTrustedUtc + monoElapsedMs` maps to that dayKey within the same window; ≥ 20 h since previous accepted claim by server time or by the monotonic evidence. Server recomputes `streak.day` and Saver use. Verification fail ⇒ `streak.frozen = true` (no further streak advance until the next valid claim), **coins not revoked** (standard §8.4).

### 7.5 Retry & batching policy
| Trigger | Action |
|---|---|
| Op appended | `flush()` (debounced 2 s while gameplay animates) |
| Connectivity → online | `flush()` |
| App resume / sign-in | `flush()` |
| Retryable error | Backoff 2 s → 4 s → … → 5 min cap, jitter 50–100% |
| Non-retryable error | Keep ops, Crashlytics non-fatal, retry on next app start |
| Queue > 500 ops | Batches of 50 sequentially; UI unaffected |

## 8. Merge on Restore / New Device
1. Sign in ⇒ read `users/{uid}` snapshot.
2. Local pending ops (if any, from anonymous offline play on this device) are **re-tagged** to the signed-in uid only if this device's anonymous uid == the uid (normal link). For the `credential-already-in-use` path, only progress/stars/album/cosmetics-owned are sent as merge ops (`progressMerge`), wallet ops are discarded (§3).
3. Local Hive progress = §6 merge (max / union); wallet = projection.
4. Save schema: local `schemaVersion` < app ⇒ migrate (adds `album`, `piggy`, `cosmetics`, `syncQueue`, `auth`, `race` boxes — [06 §7](./06_FRONTEND_AND_QA_PHASE_2.md)).

## 9. Account Deletion Flow (Apple 5.1.1(v), Google Play account deletion)

| Step | Behaviour |
|---|---|
| Entry | Settings → Account → **Delete account & cloud data** (also web form linked from Play listing) |
| Requirements | Online; if pending ops exist, they are flushed first (or user may skip) |
| Confirm | 2-step dialog: what is deleted (cloud save, race history, linked sign-in) + what is not (store purchases/subscriptions — "Cancel VIP Conductor Pass in Google Play / App Store to stop billing") |
| Server | `deleteAccount` callable: recursive delete `users/{uid}` + `ops`; race member docs anonymized ("Retired Conductor", uid removed); if Apple linked ⇒ revoke Apple token (Sign in with Apple REST revoke, refresh token stored server-side at link); Admin SDK `deleteUser(uid)` |
| Client | On success: close & delete Hive boxes (local save), sign out, restart app at age gate/FTUE with a fresh install id |
| Failure | Nothing deleted locally; error toast "Couldn't reach the station — try again" |
| Audit | `account_delete{result}` analytics (no PII) |

## 10. Edge Cases

| Case | Behaviour |
|---|---|
| Op appended, app killed before flush | Op persisted in Hive; sent next launch |
| Ack lost (timeout after server commit) | Client resends ⇒ server sees existing opId ⇒ acked, no double credit |
| Same level first-cleared on two devices offline | Both `levelClear` accepted; second credit 0 coins; stars = max |
| Device clock moved forward to farm Daily | Server rejects mismatched dayKey ⇒ streak frozen; local time-travel lock (Phase 1) also applies |
| Remote Config price change while ops queued | Server validates against the price version in the op (`priceVer`); accepts last 2 versions |
| Firestore outage | Game fully playable; queue grows; backoff |
| Sign-out | Not offered while queue non-empty ("Syncing… 12 changes left") |
