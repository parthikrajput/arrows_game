# 05 — Offline-First & Cloud Sync (ઓફલાઈન અને ક્લાઉડ સિંક)
Phase 2 નું offline-first architecture: Firebase Auth (anonymous → Google/Apple link), Firestore cloud save, UUID op-log (idempotent), conflict rules, retry/backoff, account deletion અને કઈ features ને internet જોઈએ.

**Related docs:** [Shared Core Standard §8.4, §13, §14](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Frontend §9 Persistence](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Principles (સિદ્ધાંતો)

1. **Offline-first:** Hive (`hive_ce`) local save હંમેશા source for UI. બધા levels (bundled L1–1000), Daily Garden Almanac, Sunflower Spin, Album, Honeycomb Bank deposits, Wardrobe equip — internet વગર ચાલે.
2. **Every state change = op:** local apply **+** `syncQueue` માં op (UUID v4). Online થાય ત્યારે batch upload.
3. **Server = authority for value:** coins/boosters/bank = **server ledger sum**; progress/stars = max-merge; streak = server-time authoritative.
4. **Idempotent:** એક op id server પર ક્યારેય બે વાર apply નહીં; business duplicates (`naturalKey`, દા.ત. `clear:510`) પણ reject.
5. Firebase backend Phase 2 prerequisite (Standard §13): Auth, Firestore, Cloud Functions, App Check.

## 2. Identity — Firebase Auth

| Step | Behaviour |
|---|---|
| First launch (Phase 2 build) | `signInAnonymously()` background માં (online હોય ત્યારે); offline ⇒ next online |
| Existing Phase 1 save | First sign-in પર full local snapshot = `migrate` op (server state empty હોય તો આખું import) |
| Link account | Settings → Account → "Save progress with Google / Apple" ⇒ `linkWithProvider` (uid એ જ રહે, data move નહીં) |
| Credential already in use | Dialog: "This Google account already has a garden (L740, 2,310 coins). **Use that garden** / **Keep this device's garden**" — **બેમાંથી એક** (merge નહીં ⇒ coin duplication exploit નહીં). Keep device ⇒ link cancel; Use that ⇒ `signInWithCredential`, local save replaced by server state (pending ops discarded with warning) |
| Under-13 ageBand | Linking hidden (anonymous cloud save only); data minimal (no email) |
| Sign out | ન હોય (anonymous model). Account switch = above dialog |

```dart
// apps/ants_bees/lib/services/account_service.dart
import 'package:firebase_auth/firebase_auth.dart';

sealed class LinkResult {
  const LinkResult();
}

final class Linked extends LinkResult {
  const Linked();
}

final class AlreadyInUse extends LinkResult {
  const AlreadyInUse(this.credential);
  final AuthCredential? credential;
}

final class LinkCancelled extends LinkResult {
  const LinkCancelled();
}

final class AccountService {
  AccountService([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  String? get uid => _auth.currentUser?.uid;
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;

  Future<User> ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return current;
    final cred = await _auth.signInAnonymously();
    return cred.user!;
  }

  Future<LinkResult> linkGoogle() => _link(GoogleAuthProvider());

  Future<LinkResult> linkApple() => _link(AppleAuthProvider());

  Future<LinkResult> _link(AuthProvider provider) async {
    final user = await ensureSignedIn();
    try {
      await user.linkWithProvider(provider);
      return const Linked();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'credential-already-in-use':
        case 'email-already-in-use':
          return AlreadyInUse(e.credential);
        case 'canceled':
        case 'web-context-canceled':
        case 'user-cancelled':
          return const LinkCancelled();
        default:
          rethrow;
      }
    }
  }

  /// "Use that garden": switch this device to the existing linked account.
  Future<User?> switchTo(AuthCredential credential) async {
    final cred = await _auth.signInWithCredential(credential);
    return cred.user;
  }
}
```

## 3. Cloud Data Model (Firestore)

```
users/{uid}/state/main          // single doc, written ONLY by Cloud Functions
  schema: 1
  progress: { highestCleared: int, starsPacked: string, adReviveUsed: [int] }
  wallet:   { coins: int, boosters: {hint, undo, shield, hammer} }
  bank:     { balance: int }
  streak:   { day, cycleSaverUsed, lastClaimDayKey, totalDays, trophyTier, frozen }
  cosmetics:{ owned: [sku], equipped: {antSkin, beeSkin, boardTheme} }
  settings: { language, sound, music, haptics, reduceMotion, updatedAt }
  naturalKeys: (subcollection keys/{key} for large sets)
  updatedAt: serverTimestamp
users/{uid}/ops/{opId}          // applied-op ledger (idempotency + audit), TTL 180 days
users/{uid}/keys/{naturalKey}   // business uniqueness: clear:510, gift:510, daily:2026-10-27 …
```

- `starsPacked`: 2 bits per level (0–3 ★) ⇒ 1,000 levels = 250 bytes; base64 ⇒ ~336 chars.
- Firestore security rules: client **read** own `state/main`; **all writes deny** (Cloud Functions only):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid}/state/{doc} {
      allow read: if request.auth != null && request.auth.uid == uid;
      allow write: if false;
    }
    match /users/{uid}/{rest=**} {
      allow read, write: if false;
    }
  }
}
```

## 4. Op-Log (syncQueue)

### 4.1 Op types

| Op | Payload | `naturalKey` (server unique) | Server check |
|---|---|---|---|
| `level_clear` | level, stars, heartsLost, moves, duration_s | `clear:<L>` (coins only first time) | coins = tag table (15/20/30/50) from server level index |
| `stars_update` | level, stars | — (max) | stars ≤ 3, level ≤ highestCleared |
| `coin_grant` | source, amount, ref | `<source>:<ref>` (gift:510, rush:525, triple:510, chest:1000, daily:2026-10-27, shopad:2026-10-27#3) | amount ≤ source cap |
| `coin_spend` | sku, price | `spend:<opId>` | price = catalog price |
| `booster_delta` | type, delta, reason | as source | caps per source |
| `bank_deposit` | level | `bank:<L>` | +10, cap 1,000 |
| `daily_claim` | dayKey, tzOffsetMin, clientUtc, monotonicMs | `daily:<dayKey>` | server-time rules §5 |
| `race_clear` | raceId, level, duration_s, moves | `race:<raceId>:<L>` | plausibility ([04 §3.5](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |
| `cosmetic_buy` | sku | `cosmetic:<sku>` | price 800–4,000 catalog |
| `settings` | fields, updatedAt | — | last-write-wins by `updatedAt` |
| `migrate` | full Phase 1 snapshot | `migrate` | only if server state empty |

### 4.2 Client op-log (Dart)

```dart
// apps/ants_bees/lib/services/sync/sync_op.dart
import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

final class SyncOp {
  SyncOp({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdUtcMs,
    required this.monotonicMs,
  });

  factory SyncOp.create(
    String type,
    Map<String, Object?> payload, {
    required int monotonicMs,
  }) =>
      SyncOp(
        id: const Uuid().v4(),
        type: type,
        payload: payload,
        createdUtcMs: DateTime.now().toUtc().millisecondsSinceEpoch,
        monotonicMs: monotonicMs,
      );

  factory SyncOp.fromJson(Map<String, Object?> json) => SyncOp(
        id: json['id']! as String,
        type: json['type']! as String,
        payload: Map<String, Object?>.from(json['payload']! as Map),
        createdUtcMs: json['createdUtcMs']! as int,
        monotonicMs: json['monotonicMs']! as int,
      );

  final String id; // UUID v4 — idempotency key
  final String type; // e.g. "level_clear"
  final Map<String, Object?> payload;
  final int createdUtcMs; // device clock (untrusted)
  final int monotonicMs; // uptime-based, for 20 h rule

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type,
        'payload': payload,
        'createdUtcMs': createdUtcMs,
        'monotonicMs': monotonicMs,
      };
}

final class OpLog {
  OpLog._(this._box);

  static const boxName = 'syncQueue';
  final Box<String> _box;

  static Future<OpLog> open() async => OpLog._(await Hive.openBox<String>(boxName));

  Future<void> add(SyncOp op) async {
    await _box.put(op.id, jsonEncode(op.toJson()));
    await _box.flush(); // ops are never debounced
  }

  List<SyncOp> pending({int limit = 100}) {
    final ops = _box.values
        .map((s) => SyncOp.fromJson(jsonDecode(s) as Map<String, Object?>))
        .toList()
      ..sort((a, b) => a.createdUtcMs.compareTo(b.createdUtcMs));
    return ops.take(limit).toList();
  }

  Iterable<SyncOp> all() =>
      _box.values.map((s) => SyncOp.fromJson(jsonDecode(s) as Map<String, Object?>));

  Future<void> ack(Iterable<String> ids) => _box.deleteAll(ids);

  int get length => _box.length;
}
```

### 4.3 Sync service — connectivity, batching, retry/backoff

`connectivity_plus` (current API): `onConnectivityChanged` ⇒ `Stream<List<ConnectivityResult>>`, `checkConnectivity()` ⇒ `Future<List<ConnectivityResult>>`. Connectivity ≠ internet ⇒ callable failure પણ backoff માં જાય.

```dart
// apps/ants_bees/lib/services/sync/sync_service.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'sync_op.dart';

final class ServerState {
  const ServerState({
    required this.highestCleared,
    required this.starsPacked,
    required this.coins,
    required this.boosters,
    required this.bankBalance,
    required this.streakDay,
    required this.streakFrozen,
    required this.ownedCosmetics,
  });

  factory ServerState.fromJson(Map<String, Object?> j) {
    final progress = Map<String, Object?>.from(j['progress']! as Map);
    final wallet = Map<String, Object?>.from(j['wallet']! as Map);
    final streak = Map<String, Object?>.from(j['streak']! as Map);
    final bank = Map<String, Object?>.from(j['bank']! as Map);
    final cosmetics = Map<String, Object?>.from(j['cosmetics']! as Map);
    return ServerState(
      highestCleared: progress['highestCleared']! as int,
      starsPacked: progress['starsPacked']! as String,
      coins: wallet['coins']! as int,
      boosters: Map<String, int>.from(wallet['boosters']! as Map),
      bankBalance: bank['balance']! as int,
      streakDay: streak['day']! as int,
      streakFrozen: streak['frozen']! as bool,
      ownedCosmetics: (cosmetics['owned']! as List).map((e) => e as String).toSet(),
    );
  }

  final int highestCleared;
  final String starsPacked;
  final int coins;
  final Map<String, int> boosters;
  final int bankBalance;
  final int streakDay;
  final bool streakFrozen;
  final Set<String> ownedCosmetics;
}

final class SyncService {
  SyncService({
    required OpLog log,
    required void Function(ServerState state) onServerState,
    FirebaseFunctions? functions,
    Connectivity? connectivity,
  })  : _log = log,
        _onServerState = onServerState,
        _functions = functions ?? FirebaseFunctions.instance,
        _connectivity = connectivity ?? Connectivity();

  final OpLog _log;
  final void Function(ServerState state) _onServerState;
  final FirebaseFunctions _functions;
  final Connectivity _connectivity;
  final math.Random _jitter = math.Random();

  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _timer;
  bool _flushing = false;
  int _failures = 0;

  static bool _online(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  Future<void> start() async {
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      if (_online(results)) {
        _failures = 0;
        unawaited(flush());
      }
    });
    if (_online(await _connectivity.checkConnectivity())) {
      unawaited(flush());
    }
  }

  /// Call after every local state change. Debounced 5 s so one win = one batch.
  Future<void> enqueue(SyncOp op) async {
    await _log.add(op);
    _schedule(const Duration(seconds: 5));
  }

  /// Call on app resume and every 60 s while foreground.
  Future<void> flush() async {
    if (_flushing || _log.length == 0) return;
    _flushing = true;
    try {
      while (true) {
        final batch = _log.pending(limit: 100);
        if (batch.isEmpty) break;
        final callable = _functions.httpsCallable(
          'applyOps',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 20)),
        );
        final result = await callable.call(<String, Object?>{
          'ops': batch.map((o) => o.toJson()).toList(),
        });
        final data = Map<String, Object?>.from(result.data as Map);
        final acked = (data['ackIds']! as List).map((e) => e as String).toList();
        await _log.ack(acked); // includes duplicates & rejected (server logged them)
        _onServerState(
          ServerState.fromJson(Map<String, Object?>.from(data['state']! as Map)),
        );
        if (acked.length < batch.length) break; // server deferred the rest
      }
      _failures = 0;
    } on FirebaseFunctionsException {
      _failures++;
      _schedule(_backoff());
    } on TimeoutException {
      _failures++;
      _schedule(_backoff());
    } finally {
      _flushing = false;
    }
  }

  /// 2^n seconds (n = failures), capped at 300 s, plus 0–1 s jitter.
  Duration _backoff() {
    final seconds = math.min(300, 1 << math.min(_failures, 9));
    return Duration(milliseconds: seconds * 1000 + _jitter.nextInt(1000));
  }

  void _schedule(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, () => unawaited(flush()));
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _sub?.cancel();
  }
}
```

### 4.4 Server `applyOps` (Cloud Functions v2, TypeScript outline)
```ts
export const applyOps = onCall({ enforceAppCheck: true }, async (req) => {
  const uid = req.auth?.uid; if (!uid) throw new HttpsError("unauthenticated", "sign in");
  const ops: Op[] = req.data.ops.slice(0, 100);
  const ackIds: string[] = [];
  const state = await db.runTransaction(async (tx) => {
    const stateRef = db.doc(`users/${uid}/state/main`);
    const opRefs = ops.map((o) => db.doc(`users/${uid}/ops/${o.id}`));
    const keyRefs = ops.map((o) => db.doc(`users/${uid}/keys/${naturalKey(o)}`));
    // Firestore: all reads before writes
    const [stateSnap, ...snaps] = await tx.getAll(stateRef, ...opRefs, ...keyRefs);
    const s = stateSnap.exists ? stateSnap.data() as State : emptyState();
    ops.forEach((op, i) => {
      ackIds.push(op.id);
      if (snaps[i].exists) return;                    // same UUID ⇒ already applied
      const keyDup = snaps[ops.length + i].exists;    // business duplicate
      const verdict = keyDup ? "duplicate" : applyOp(s, op, serverNow()); // validates & mutates s
      tx.create(opRefs[i], { type: op.type, verdict, at: FieldValue.serverTimestamp() });
      if (verdict === "applied" && hasNaturalKey(op)) tx.create(keyRefs[i], { op: op.id });
    });
    tx.set(stateRef, { ...s, updatedAt: FieldValue.serverTimestamp() });
    return s;
  });
  return { ackIds, state };
});
```
(Duplicate natural keys within one batch: `applyOp` in-memory set થી પણ check.)

## 5. Conflict Rules (binding)

| Data | Rule | Notes |
|---|---|---|
| **Progress** `highestCleared` | **max**(local, server) | Album stickers derived ⇒ union automatic |
| **Stars** per level | **max per level** | ★ ક્યારેય ઘટે નહીં |
| `adReviveUsed[level]` | OR until level cleared (then remove) | Daily key `daily:<dayKey>` same |
| **Coins** | **Server ledger sum** (applied `coin_grant` − `coin_spend`) | Client display = server coins + Σ pending local deltas |
| **Boosters** | Server ledger sum per type | Same as coins |
| Overdraft (two devices spend same coins offline) | Spend ops **always applied** (item already granted); balance **floored at 0**, deficit logged `ledger_overdraft{amount}` | No negative balance shown |
| **Honeycomb Bank** | Server sum of unique `bank:<L>` deposits since last purchase, cap 1,000 | Purchase grant = server balance |
| **Streak** | **Server-time authoritative** (below) | Device clock ignored for validity |
| Cosmetics owned | Union (ownership from applied `cosmetic_buy`) | Equipped = last-write-wins |
| Settings | Last-write-wins by `updatedAt` (device clock; low risk) | `ageBand` **not synced** (device-local, re-asked on new device) |
| In-level attempt (`sessionResume`) | Device-local only | Not synced |

**Streak (server-time authoritative):**
- `daily_claim` server પર: `serverLocalDate = (serverUtc + tzOffsetMin)` નો date. Accept if `dayKey ≤ serverLocalDate` **and** `dayKey > lastClaimDayKey` **and** (previous claim થી ≥ 20 h: server receive times, અથવા offline claims માટે `monotonicMs` deltas).
- Offline-earned claims (sync later): Phase 1 rule (Standard §8.4) — reward local grant રહે (**coins revoke નહીં**); validation fail ⇒ `streak.frozen = true` (streak advance અટકે, Day index same) અને next valid online claim પછી unfreeze.
- Two devices same dayKey ⇒ `daily:<dayKey>` natural key ⇒ second = duplicate (coins second time નહીં; client correction toast).

## 6. Local ↔ Server Reconciliation

On every `ServerState` response:
1. `progress.highestCleared = max(...)`, stars max-merge (code below), album recompute.
2. `wallet.coins = server.coins + pendingCoinDelta()` (pending ops in `syncQueue`), same for boosters, bank.
3. Streak fields ← server (frozen flag shown as "Streak paused — connect to verify").
4. Cosmetics owned ← union; equipped skin not owned (revoked purchase) ⇒ default.

```dart
// apps/ants_bees/lib/services/sync/merge.dart
import 'sync_op.dart';

/// Stars: 2 bits per level, index 0 = level 1.
List<int> unpackStars(List<int> bytes, int levels) =>
    List<int>.generate(levels, (i) => (bytes[i >> 2] >> ((i & 3) * 2)) & 3);

List<int> mergeStars(List<int> local, List<int> server) {
  final n = local.length > server.length ? local.length : server.length;
  return List<int>.generate(n, (i) {
    final a = i < local.length ? local[i] : 0;
    final b = i < server.length ? server[i] : 0;
    return a > b ? a : b;
  });
}

int pendingCoinDelta(Iterable<SyncOp> pending) {
  var delta = 0;
  for (final op in pending) {
    switch (op.type) {
      case 'coin_grant':
        delta += op.payload['amount']! as int;
      case 'coin_spend':
      case 'cosmetic_buy':
        delta -= op.payload['price']! as int;
      case 'level_clear':
        delta += (op.payload['coins'] as int?) ?? 0;
    }
  }
  return delta;
}
```

## 7. What Needs Internet (ઇન્ટરનેટ ક્યાં જોઈએ)

| Feature | Offline | Online required for |
|---|---|---|
| Levels 1–1000, boosters, hearts, revive by coins | ✅ Full | — |
| Rewarded ads (revive, 2X, spin extra, shop +50, Queen's Favor) | ❌ "Ad unavailable" | Ad load |
| Daily Garden Almanac + streak | ✅ Play + local reward | Streak verification (server time) |
| Sunflower Spin | ✅ (deterministic PRNG) | Ad extra spin |
| Golden Nectar Rush | ✅ | — |
| Flora & Fauna Compendium | ✅ | — |
| Golden Honeycomb Bank | ✅ Deposits | Purchase (IAP + `verifyPurchase`) |
| Garden Wardrobe | ✅ Buy with coins (op queued), equip | Sync |
| Weekly Star Race | ⚠️ Play counts after join (queued) | Join, others' progress, results, claim |
| IAP (coins, Starter Pack, VIP, Bank) | ❌ | Store + receipt validation |
| Cloud save / account link / deletion | ❌ (queued ops only) | All |
| Leaderboards | ⚠️ Local cache | Submit / view |
| Remote Config | Cached / bundled defaults | Fetch (`maxPhase`, tuning) |
| Phase 3+ unlock | — | Remote Config `maxPhase` + app update |

Offline banner: Home ઉપર નાનું "Offline — progress saved on device" chip (dismissible), gameplay માં કંઈ નહીં.

## 8. Account Deletion (Store policy)

- **In-app:** Settings → Account → **Delete account & cloud data** ⇒ 2-step confirm ("This deletes your cloud garden, coins and purchases history on our servers. Your device progress will reset.").
- Callable `deleteAccount`: `recursiveDelete(users/{uid})`, race member docs anonymized ("Former racer"), `admin.auth().deleteUser(uid)`. Purchase receipts required for tax/refund law ⇒ anonymized retention (no uid link) as per privacy policy.
- Client: `signOut()`, બધા Hive boxes `deleteFromDisk()` (age gate સહિત બધું reset), app restarts to Splash ⇒ new anonymous user.
- **Web deletion request URL** (Google Play account deletion requirement) — privacy page form ⇒ same function after email/uid verification.
- Offline ⇒ button disabled "Connect to delete".
- Subscriptions (Beekeeper VIP Pass) store-managed: dialog reminds "Cancel subscription in Play Store / App Store" with deep link.

## 9. Failure Handling

| Failure | Handling |
|---|---|
| `applyOps` timeout / unavailable | Exponential backoff 1 → 2 → 4 … 300 s + jitter; ops stay in Hive |
| `unauthenticated` | `ensureSignedIn()` then retry |
| App Check failure | Backoff; Crashlytics non-fatal |
| `syncQueue` > 5,000 ops (long offline) | Compact: merge `stars_update` per level (max), keep others |
| Server state schema newer than client | Read-only sync; "Update app" prompt |
| Corrupt local box | Restore `_bak`; then pull server state (server wins for ledger, max-merge progress) |
| New device, linked account | Pull `state/main` ⇒ local save built; `installId` new (Spin seed per install) |

## 10. Sync Edge Cases

| # | Case | Result |
|---|---|---|
| SY-1 | Same level first-cleared on two devices offline | `clear:<L>` natural key ⇒ coins once; stars max |
| SY-2 | Device A at L700, device B at L650 | Both converge to 700 |
| SY-3 | Gift Box L510 claimed offline on both | `gift:510` once; second device's local grant corrected on sync (toast "Already collected on another device") |
| SY-4 | Clock set forward to farm daily | Time-travel lock + server date check ⇒ streak frozen, no extra server coins beyond first valid |
| SY-5 | Op replay (network retry after server applied) | Same UUID ⇒ ack, no re-apply |
| SY-6 | Linked to existing account, chose "Use that garden" | Local pending ops discarded (warned), server state loaded |
| SY-7 | Account deleted on device A while B offline | B's next sync ⇒ `unauthenticated` (user deleted) ⇒ B resets to fresh anonymous after notice |
