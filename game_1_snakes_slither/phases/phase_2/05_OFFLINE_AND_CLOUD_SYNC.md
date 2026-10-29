# 05 — Offline-First & Cloud Sync
> Phase 2 નું offline-first architecture: Firebase Auth (anonymous → Google/Apple link), Firestore cloud save, UUID-idempotent op-log, conflict rules, server time authority, compile-correct Dart sync service, retry/backoff, account deletion અને શું internet વગર ચાલે / નથી ચાલતું.

**Related docs:** [Phase 2 index](./README.md) · [Shared Core Standard §8.4, §13–§14](../../SHARED_CORE_STANDARD.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Frontend (persistence)](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Principles (સિદ્ધાંતો)
1. **Local first:** દરેક game action પહેલાં Hive save માં લખાય (Phase 1 જેવું) ⇒ UI તરત update. Network ક્યારેય gameplay block નથી કરતું.
2. **Op-log, not state upload:** દરેક economy/progress change = એક **immutable op** (UUID v4 `opId`). Server ops ને idempotent રીતે apply કરે ⇒ retry safe.
3. **Server snapshot wins for ledger fields:** coins, boosters, piggy = server ledger sum; client display = server snapshot + pending (unacked) local ops.
4. **Deterministic merges:** progress = max, stars = max per level, collections = union, preferences = last-write-wins (server time).
5. **One account, many devices:** Firebase uid = account. Anonymous શરૂઆત, Google/Apple link ⇒ reinstall/new device પર restore.

## 2. What Needs Internet
| Feature | Offline | Online required |
|---|---|---|
| L1–1000 gameplay, boosters, Second Chance (Heart Berry Refill) | ✅ | — |
| Rewarded ads (revive, 2X, shop coins, extra spin, saver) | ❌ (button "Ad unavailable") | ✅ |
| Daily Jungle Puzzle + Jungle Streak | ✅ (local grant, verify later — standard §8.4) | Verification |
| Lucky Lily Wheel | ✅ (seeded PRNG) | — |
| Sticker Album grant | ✅ | Volume claim credit sync |
| Cosmetics buy/equip (coins) | ✅ | Ownership sync |
| Piggy deposits | ✅ | **Break (IAP)** |
| Coin packs / Starter Pack / VIP purchase, Restore | ❌ | ✅ |
| Weekly Star Race | Play queued clears ✅ | **Join**, results |
| Cloud save push/pull, account link, account deletion | ❌ | ✅ |
| Leaderboards (`games_services`) | Queue | ✅ |
| Remote Config refresh | Cached values | Fetch |

## 3. Identity (Firebase Auth)
### 3.1 Anonymous by Default
- Phase 2 build ની **પહેલી online launch** પર `FirebaseAuth.instance.signInAnonymously()` (silent, UI વગર). Offline ⇒ next connectivity પર.
- Existing Phase 1 save ⇒ "bootstrap ops" (§6.4) થી server પર upload.

### 3.2 Link Google / Apple
- Settings → Account → "Save progress with Google" / "Sign in with Apple" (iOS પર Apple ફરજિયાત option જો Google offer કરીએ).
- `currentUser.linkWithProvider(GoogleAuthProvider())` / `linkWithProvider(AppleAuthProvider())` ⇒ **uid same રહે**, data move નથી કરવો પડતો.
- Under-13 (`ageBand` child) ⇒ link button hidden; anonymous only (no personal data from children, Families policy). Reinstall ⇒ progress restore નહીં — Settings માં સ્પષ્ટ text.

### 3.3 `credential-already-in-use` (account already exists)
Device 2 પર નવું anonymous account (uid B) અને Google account પહેલેથી uid A સાથે linked:
1. Dialog: "This Google account already has a saved garden (L734). Load it on this device?" — **Load saved garden** / Cancel.
2. Load ⇒ client B નો current **ID token** રાખે ⇒ `signInWithCredential(e.credential)` (uid A) ⇒ callable `mergeAnonymous({anonIdToken})`.
3. Server verifies token (uid B), B ના op docs ને A પર **replay** કરે (semantic keys dedupe ⇒ one-time rewards double નહીં), પછી B delete.
4. Local: B ના pending ops (queue) uid A સાથે push ⇒ A snapshot pull ⇒ Hive overwrite from snapshot (merge rules §7 પછી).

## 4. Local Save (Hive) — Phase 2 Fields
Standard §14 (schema v1 fields) + Phase 2: `album`, `piggy`, `cosmetics`, `syncQueue`. Migration step `schemaVersion` 1 → 2 (defaults below).

| Key | Fields | Default |
|---|---|---|
| `album` | `stickers: List<int>` (levels), `claimedVols: List<int>`, `silhouettes: List<int>` (weekday 1–7) | retroactive (§04 2.4) |
| `piggy` | `balance`, `fullShownCycle`, `purchasePending: bool` | 0 / 0 / false |
| `cosmetics` | `owned: List<String>`, `equipped{skin, theme, frame}`, `equippedAtUtc` | `[]`, defaults |
| `syncQueue` | Separate Hive box `sync_queue` (`Box<Map>`, key = `opId`) | empty |
| `ext.account` | `uid`, `providers`, `lastPullUtc`, `snapshotVersion` | — |
| `ext.race` | `weekKey`, `cohortId`, `startLevel`, `cachedCohort` | — |
| `time` (existing) | + `monoAtServerSync`, `bootId` | — |

`syncQueue` અલગ box ⇒ main save write અને queue write independent; queue corrupt ⇒ drop queue + full pull (server snapshot) + Crashlytics non-fatal.

## 5. Firestore Data Model
```
users/{uid}
  schema: 2, createdUtc, lastSyncUtc, linkedProviders: [..]
  snapshot: {
    version, highestCleared, coins, boosters{hint, shield, hammer},
    piggy, streak{day, cycleSaverUsed, lastClaimDayKey, totalDays, trophyTier, frozen},
    stickers[], albumClaimed[], silhouettes[], cosmeticsOwned[], equipped{skin, theme, frame, atUtc},
    settings{sound, music, haptics, language, ageBand, atUtc}, tutorialSteps[]
  }
users/{uid}/stars/{chunk}      chunk "p1" = L1–500, "p2" = L501–1000 → { "<level>": 1..3 }
users/{uid}/ops/{opId}         { type, semanticKey, payload, clientUtcMs, estUtc, serverUtc, status: applied|duplicate|rejected }
users/{uid}/keys/{semanticKey} { opId, serverUtc }
races/…, raceEntries/…, ghostPool/…   (04 §3.9)
```
- Client **ક્યારેય સીધું write નથી કરતો** — બધા writes Cloud Functions (`syncPush`, `mergeAnonymous`, `deleteAccount`, race functions, `verifyPurchase`).
- `ops` docs retention 90 days (scheduled cleanup); `keys` docs કાયમ (small, dedupe માટે).

### 5.1 Security Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read: if request.auth != null && request.auth.uid == uid;
      allow write: if false;
      match /{sub=**} {
        allow read: if request.auth != null && request.auth.uid == uid;
        allow write: if false;
      }
    }
    match /races/{weekKey}/cohorts/{cohortId} {
      allow read: if request.auth != null && request.auth.uid in resource.data.memberUids;
      allow write: if false;
    }
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## 6. Op-Log (Idempotent Operations)
### 6.1 Op Schema
```json
{
  "opId": "8f14e45f-ceea-4e7a-9c1b-2f6d1f0e5a77",
  "type": "coins_earn",
  "semanticKey": "clear:734",
  "payload": {"source": "level_clear", "amount": 20, "level": 734},
  "clientUtcMs": 1793000000000,
  "monoMs": 5234001,
  "bootId": "b-7c1e",
  "deviceId": "d-3f9a"
}
```
- **`opId`** (UUID v4): network retry dedupe — same op બે વાર પહોંચે ⇒ server પહેલાનું result પાછું આપે.
- **`semanticKey`**: business dedupe — એક જ reward બે devices પરથી (દા.ત. `clear:734` first-clear coins) ⇒ પહેલું `applied`, બીજું `duplicate` (no effect).

### 6.2 Op Types & Server Validation
| Type | Semantic key | Server validation (cap) |
|---|---|---|
| `level_clear` | `lvl:{level}` | `level ≤ server.highestCleared + 1`, `level ≤ maxPhase × 500` |
| `stars` | — (max merge) | 1–3 |
| `coins_earn` level_clear | `clear:{level}` | ≤ 50 (tag) |
| `coins_earn` first ★★★ | `star3:{level}` | = 20 |
| `coins_earn` 2X Win | `x2:{level}` | ≤ base clear |
| `coins_earn` gift / chest | `gift:{level}` / `chest:{phase}` | ≤ 300 / = 1,000 |
| `coins_earn` rush | `rush:{level}` | ≤ 400 |
| `coins_earn` daily / streak | `daily:{dayKey}` / `streak:{cycle}:{day}` | = 100 / ladder value |
| `coins_earn` spin / shop ad | `spin:{dayKey}:{i}` (i ≤ 1) / `shopad:{dayKey}:{i}` (i ≤ 4) | ≤ 500 / = 50 |
| `coins_earn` album | `album:vol{n}` | table value |
| `coins_spend` | — (UUID only) | amount > 0 |
| `booster_grant` / `booster_use` | grant: source key (gift, streak, spin, tutorial `tut:{type}`) | caps per source |
| `piggy_deposit` | `piggy:{level}` | = 10, cap 1,000 |
| `sticker` / `silhouette` | `stk:{level}` / `sil:{weekday}` | level % 10 == 0 ≤ highestCleared |
| `cosmetic_buy` | `cos:{sku}` | price table |
| `cosmetic_equip` / `settings` | — (LWW) | owned / valid enum |
| `daily_claim` | `dclaim:{dayKey}` | §8 rules |
| `race_clear` | `race:{weekKey}:{level}` | 04 §3.7 |

- Invalid / over-cap ⇒ `rejected` (acked, retry નહીં) ⇒ client snapshot થી correct (anti-tamper-lite). Rejection analytics `sync_reject{type}`.
- IAP grants **op નથી** — `verifyPurchase` server-side ledger entry `iap:{orderId}` લખે.

### 6.3 Ordering
Queue `seq` order માં push (batch 100). Server એક batch ને **એક transaction** માં apply (≤ 100 ops × ≤ 3 writes < 500 write limit).

### 6.4 Bootstrap (Phase 1 save → first sync)
પહેલી sync પર client એક `bootstrap` op (semantic key `boot`) મોકલે: `highestCleared`, stars map, wallet coins/boosters, streak, stickers. Server: uid નવું હોય ⇒ snapshot = bootstrap (caps: coins ≤ 1,000,000 sanity); પહેલેથી data ⇒ `duplicate`. Bootstrap પછી નવા ops normal.

## 7. Conflict Rules
| Field | Rule |
|---|---|
| `highestCleared` | **max** |
| `stars[level]` | **max per level** |
| Coins | **Server ledger sum** (Σ applied earn − Σ applied spend + IAP + race/album grants) |
| Boosters (each type) | Server ledger sum (grants − uses) |
| Piggy | Ledger: Σ deposits (unique levels, cap 1,000) − breaks |
| Streak | **Server-time authoritative** (§8): server recomputes from `daily_claim` ops; client value display only |
| Daily reward | One per `dayKey` per account (`daily:{dayKey}`) |
| Stickers, silhouettes, album claims, tutorial steps, cosmetics owned | **Union** |
| Equipped cosmetics, settings | **Last-write-wins** by `serverUtc` (ties ⇒ larger `opId`) |
| `ageBand` | Most restrictive (youngest) band across devices |
| `adReviveUsed`, ad counters, `winsSinceInterstitial`, cooldown | **Device-local** (not synced) |
| VIP | Store-authoritative (`verifyPurchase`, expiry) |
| Race | Server-authoritative (cohort docs) |

**Negative ledger (rare):** બે devices offline એ જ coins ખર્ચે ⇒ server spends accept કરે (gameplay પહેલેથી થયું) ⇒ coins < 0 શક્ય. Client `max(0, coins)` બતાવે; negative = hidden debt, future earnings પહેલાં debt ભરે; coin purchases (boosters, cosmetics) balance ≥ price હોય ત્યારે જ.

## 8. Time & Server Authority
- Standard §8.4 rules યથાવત (`lastTrustedUtc`, time-travel lock, 20 h min spacing).
- Server time: દરેક `syncPush` response `serverNowUtc` ⇒ `time.lastServerUtc`, `time.monoAtServerSync = monoNow`, `bootId`.
- **Estimated UTC** (offline ops): `estUtc = lastServerUtc + (monoNow − monoAtServerSync)` જો `bootId` same; reboot ⇒ `estUtc = null` ⇒ server receive time વાપરે.
- **Streak verification:** online claim ⇒ server time થી dayKey check (`dayKey` ∈ server UTC ± 14 h). Offline claim ⇒ `estUtc` થી; null ⇒ receive time. Mismatch (દા.ત. 20 h spacing fail) ⇒ `streak.frozen = true` (coins revoke **નહીં**, standard §8.4); freeze next valid claim પર unfreeze.
- `MonotonicClock`: Android `SystemClock.elapsedRealtime()`, iOS `clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW)` (MethodChannel `snakes/monotonic`); `bootId` = Android `Settings.Global.BOOT_COUNT`, iOS boot time (`sysctl kern.boottime`).

## 9. Sync Engine
### 9.1 Triggers
App start (after auth) · connectivity regained · `AppLifecycleState.resumed` · each level win / purchase / claim (debounced 2 s) · before Piggy break (forced).

### 9.2 Retry / Backoff
- Retryable codes: `unavailable`, `deadline-exceeded`, `internal`, `aborted`, `resource-exhausted`, `unknown`.
- Delay = `min(300 s, 2^attempt s) × jitter(0.8–1.2)`, attempt reset on success or connectivity regain.
- `unauthenticated` ⇒ re-sign-in (anonymous or current provider) ⇒ retry once.
- `permission-denied` / `failed-precondition` ⇒ stop, Crashlytics non-fatal, retry next app start.

### 9.3 Dart (Flutter 3.x / Dart 3)
`pubspec.yaml`: `firebase_auth`, `cloud_functions`, `connectivity_plus` (≥ 6.0: `onConnectivityChanged` emits `List<ConnectivityResult>`), `hive_ce`, `uuid`.

```dart
// lib/services/sync/sync_service.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

/// Platform-backed monotonic clock (MethodChannel `snakes/monotonic`).
abstract class MonotonicClock {
  int nowMs();
  String bootId();
}

@immutable
class SyncOp {
  const SyncOp({
    required this.opId,
    required this.type,
    required this.payload,
    required this.clientUtcMs,
    required this.monoMs,
    required this.bootId,
    required this.deviceId,
    this.semanticKey,
  });

  final String opId;
  final String type;
  final String? semanticKey;
  final Map<String, Object?> payload;
  final int clientUtcMs;
  final int monoMs;
  final String bootId;
  final String deviceId;

  Map<String, Object?> toJson() => <String, Object?>{
        'opId': opId,
        'type': type,
        'semanticKey': semanticKey,
        'payload': payload,
        'clientUtcMs': clientUtcMs,
        'monoMs': monoMs,
        'bootId': bootId,
        'deviceId': deviceId,
      };

  static SyncOp fromJson(Map<dynamic, dynamic> m) => SyncOp(
        opId: m['opId'] as String,
        type: m['type'] as String,
        semanticKey: m['semanticKey'] as String?,
        payload: Map<String, Object?>.from(m['payload'] as Map),
        clientUtcMs: m['clientUtcMs'] as int,
        monoMs: m['monoMs'] as int,
        bootId: m['bootId'] as String,
        deviceId: m['deviceId'] as String,
      );
}

/// Durable FIFO of unacknowledged ops (Hive box `sync_queue`).
class OpLog {
  OpLog._(this._box, this._seq);

  final Box<Map> _box;
  int _seq;

  static Future<OpLog> open() async {
    final box = await Hive.openBox<Map>('sync_queue');
    var maxSeq = 0;
    for (final m in box.values) {
      final s = m['seq'] as int? ?? 0;
      if (s > maxSeq) maxSeq = s;
    }
    return OpLog._(box, maxSeq);
  }

  int get length => _box.length;

  Future<void> append(SyncOp op) async {
    _seq += 1;
    await _box.put(op.opId, <String, Object?>{...op.toJson(), 'seq': _seq});
  }

  List<SyncOp> pending({int limit = 100}) {
    final rows = _box.values.toList()
      ..sort((a, b) => (a['seq'] as int).compareTo(b['seq'] as int));
    return rows.take(limit).map(SyncOp.fromJson).toList(growable: false);
  }

  Future<void> ack(Iterable<String> opIds) => _box.deleteAll(opIds);

  Future<void> clear() async {
    await _box.clear();
  }
}

@immutable
class ServerSnapshot {
  const ServerSnapshot({required this.version, required this.serverNowUtcMs, required this.data});

  final int version;
  final int serverNowUtcMs;
  final Map<String, Object?> data;

  static ServerSnapshot fromJson(Map<dynamic, dynamic> m) => ServerSnapshot(
        version: m['version'] as int,
        serverNowUtcMs: m['serverNowUtcMs'] as int,
        data: Map<String, Object?>.from(m['snapshot'] as Map),
      );
}

class SyncService with WidgetsBindingObserver {
  SyncService({
    required OpLog log,
    required MonotonicClock clock,
    required String deviceId,
    required void Function(ServerSnapshot snapshot) onSnapshot,
    FirebaseAuth? auth,
    FirebaseFunctions? functions,
    Connectivity? connectivity,
  })  : _log = log,
        _clock = clock,
        _deviceId = deviceId,
        _onSnapshot = onSnapshot,
        _auth = auth ?? FirebaseAuth.instance,
        _functions = functions ?? FirebaseFunctions.instance,
        _connectivity = connectivity ?? Connectivity();

  static const int _batchSize = 100;
  static const int _maxBackoffSeconds = 300;
  static const Set<String> _retryable = {
    'unavailable',
    'deadline-exceeded',
    'internal',
    'aborted',
    'resource-exhausted',
    'unknown',
  };

  final OpLog _log;
  final MonotonicClock _clock;
  final String _deviceId;
  final void Function(ServerSnapshot snapshot) _onSnapshot;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;
  final Connectivity _connectivity;
  final Uuid _uuid = const Uuid();
  final math.Random _rng = math.Random();

  StreamSubscription<List<ConnectivityResult>>? _connSub;
  Timer? _retryTimer;
  Timer? _debounce;
  int _attempt = 0;
  bool _online = false;
  bool _flushing = false;

  Future<void> start() async {
    WidgetsBinding.instance.addObserver(this);
    _online = _hasNetwork(await _connectivity.checkConnectivity());
    _connSub = _connectivity.onConnectivityChanged.listen((results) {
      final wasOnline = _online;
      _online = _hasNetwork(results);
      if (_online && !wasOnline) {
        _attempt = 0;
        unawaited(flush());
      }
    });
    unawaited(flush());
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _connSub?.cancel();
    _retryTimer?.cancel();
    _debounce?.cancel();
  }

  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(flush());
  }

  /// Records an op locally (always succeeds offline) and schedules a push.
  Future<void> record(String type, Map<String, Object?> payload, {String? semanticKey}) async {
    final op = SyncOp(
      opId: _uuid.v4(),
      type: type,
      semanticKey: semanticKey,
      payload: payload,
      clientUtcMs: DateTime.now().toUtc().millisecondsSinceEpoch,
      monoMs: _clock.nowMs(),
      bootId: _clock.bootId(),
      deviceId: _deviceId,
    );
    await _log.append(op);
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () => unawaited(flush()));
  }

  /// Pushes pending ops in batches and applies the returned server snapshot.
  /// An empty batch acts as a pull.
  Future<void> flush() async {
    if (_flushing || !_online) return;
    _flushing = true;
    _retryTimer?.cancel();
    try {
      final user = _auth.currentUser ?? (await _auth.signInAnonymously()).user;
      if (user == null) return;
      final callable = _functions.httpsCallable(
        'syncPush',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 20)),
      );
      while (true) {
        final batch = _log.pending(limit: _batchSize);
        final result = await callable.call(<String, Object?>{
          'ops': batch.map((o) => o.toJson()).toList(),
          'deviceId': _deviceId,
        });
        final data = Map<String, Object?>.from(result.data as Map);
        final acked = (data['acked'] as List).cast<String>();
        await _log.ack(acked);
        _onSnapshot(ServerSnapshot.fromJson(data));
        if (batch.length < _batchSize) break;
      }
      _attempt = 0;
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'unauthenticated') {
        await _auth.currentUser?.getIdToken(true);
        _scheduleRetry();
      } else if (_retryable.contains(e.code)) {
        _scheduleRetry();
      } else {
        debugPrint('syncPush stopped: ${e.code} ${e.message}');
      }
    } on FirebaseAuthException {
      _scheduleRetry();
    } finally {
      _flushing = false;
    }
  }

  void _scheduleRetry() {
    final base = math.min(_maxBackoffSeconds, 1 << math.min(_attempt, 9));
    final jitter = 0.8 + _rng.nextDouble() * 0.4;
    _attempt += 1;
    _retryTimer?.cancel();
    _retryTimer = Timer(
      Duration(milliseconds: (base * 1000 * jitter).round()),
      () => unawaited(flush()),
    );
  }
}
```
- `_onSnapshot` ⇒ `SaveRepository.applyServerSnapshot(s)`: ledger fields = `snapshot + Σ pending local ops` (display), max/union/LWW rules §7, Hive write.
- `ServerSnapshot.version` < local `snapshotVersion` ⇒ ignore (stale response).
- Non-fatal: `permission-denied` stops queue; Crashlytics `recordError` app layer પર.

### 9.4 Server `syncPush` (TypeScript sketch, Functions v2)
```ts
export const syncPush = onCall({ enforceAppCheck: true }, async (req) => {
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "sign in");
  const ops: Op[] = req.data.ops ?? [];
  if (ops.length > 100) throw new HttpsError("invalid-argument", "batch too large");
  return db.runTransaction(async (tx) => {
    const userRef = db.doc(`users/${uid}`);
    const user = (await tx.get(userRef)).data() ?? newUser();
    const acked: string[] = [];
    for (const op of ops) {
      const opRef = userRef.collection("ops").doc(op.opId);
      if ((await tx.get(opRef)).exists) { acked.push(op.opId); continue; }      // network retry
      let status = "applied";
      if (op.semanticKey) {
        const keyRef = userRef.collection("keys").doc(op.semanticKey);
        if ((await tx.get(keyRef)).exists) status = "duplicate";               // second device
        else if (validate(op, user)) tx.set(keyRef, { opId: op.opId, serverUtc: Date.now() });
        else status = "rejected";
      } else if (!validate(op, user)) status = "rejected";
      if (status === "applied") apply(op, user);                               // max / sum / union / LWW
      tx.set(opRef, { ...op, status, serverUtc: Date.now() });
      acked.push(op.opId);
    }
    user.snapshot.version += 1;
    tx.set(userRef, user);
    return { acked, version: user.snapshot.version, serverNowUtcMs: Date.now(), snapshot: user.snapshot };
  });
});
```
(Firestore transactions માં બધા reads writes પહેલાં હોવા જોઈએ — production code ops ના `opRef`/`keyRef` reads પહેલાં batch માં કરે, પછી writes; sketch readability માટે inline.)

## 10. Account Deletion
Store requirement (Google Play account deletion policy, Apple 5.1.1(v)): **in-app** delete.
1. Settings → Account → **Delete account & cloud save** (online only).
2. Confirm sheet: શું delete થશે (cloud save, album, cosmetics, race history), purchases store account સાથે રહે (VIP restore શક્ય), 2-step confirm ("Delete" પછી "Yes, delete").
3. Apple-linked ⇒ fresh Sign in with Apple ⇒ `FirebaseAuth.instance.revokeTokenWithAuthorizationCode(code)` (Apple token revoke).
4. Callable `deleteAccount()` ⇒ server: `recursiveDelete(users/{uid})`, race cohorts માં member `displayName = "Racer"`, uid remove (results anonymized), `auth.deleteUser(uid)`.
5. Client: `OpLog.clear()`, sign out, **local reset** (Hive save delete ⇒ fresh install state + age gate). Option "Keep progress on this device only" **નથી** (confusion ટાળવા; deletion = clean slate).
6. Offline ⇒ button disabled + "Connect to delete your account". Web form link (Privacy Policy) પણ (Play requirement).

## 11. Edge Cases
| # | Case | Behaviour |
|---|---|---|
| SY-1 | Same level cleared on 2 devices offline | `clear:{level}` coins once; stars max; highest max |
| SY-2 | Offline spend + server rejects earn that funded it | Ledger may go negative ⇒ hidden debt (§7) |
| SY-3 | Op batch partially rejected | Rejected ops acked (no retry), snapshot corrects |
| SY-4 | App killed mid-push | Ops still in queue ⇒ re-sent ⇒ `opId` dedupe |
| SY-5 | Clock set forward 2 days offline, daily claims | Local grants (standard §8.4) ⇒ server `estUtc` mismatch ⇒ streak frozen, coins kept |
| SY-6 | Reinstall, anonymous (not linked) | New account; old progress lost (Settings warning shown before) |
| SY-7 | Reinstall, Google-linked | Sign in ⇒ snapshot pull ⇒ restore; Album/cosmetics too |
| SY-8 | Queue > 5,000 ops (long offline) | Batches of 100 sequentially; UI "Syncing…" chip only |
| SY-9 | Server snapshot older than local display (race) | `version` check ⇒ ignore stale |
| SY-10 | User under 13 | Anonymous sync ON (no personal data), link hidden |
| SY-11 | Firestore outage | Backoff up to 300 s; gameplay unaffected |
| SY-12 | Merge (§3.3) with both accounts having VIP | VIP store-side; restore purchases after switch |

## 12. Testing
- Unit: `OpLog` order/ack/dedupe, `ServerSnapshot` parsing, backoff schedule (fake timers), merge rules (property tests: commutative for max/union).
- Emulator suite (Firebase Local Emulator): `syncPush` idempotency (same opId ×3), semantic duplicate across 2 uids-devices, rejection caps, security rules (client write denied).
- Device matrix: 2 phones same account — offline/online combos (QA-SYNC rows, [06 §10](./06_FRONTEND_AND_QA_PHASE_2.md#10-qa-checklist)).
