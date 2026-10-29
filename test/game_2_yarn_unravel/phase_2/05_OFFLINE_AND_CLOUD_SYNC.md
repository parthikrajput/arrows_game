# 05 — Offline-First & Cloud Sync
> Purpose: Phase 2 નું offline-first architecture — Firebase Auth (anonymous → Google/Apple link), Firestore cloud save, idempotent op-log (UUID operations), conflict rules, compile-correct Dart sync code, retry/backoff, account/data-deletion flows અને કઈ features ને internet જોઈએ.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§8.4 Day Key & Anti-Cheat, §13 Tech, §14 Save) · [./README.md](./README.md) · [./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [./06_FRONTEND_AND_QA_PHASE_2.md](./06_FRONTEND_AND_QA_PHASE_2.md) · [../phase_1/05_DAILY_CHALLENGE_AND_STREAK.md](../phase_1/05_DAILY_CHALLENGE_AND_STREAK.md) · [../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Principles

1. **All gameplay works offline:** levels 1–1000 (bundled JSON), Daily Stitch (seeded), Spinning Wheel (seeded PRNG), boosters, Craft Basket, Scrapbook, Wardrobe coin purchases. Local Hive save is the **runtime source**; cloud is backup + sync between devices of the **same account** (op-log merge, §6). Two different accounts are never merged (§3).
2. **Every economy change is an operation** (op) appended to `syncQueue` at the moment it happens; the local wallet is updated immediately (optimistic).
3. **Server is authoritative for value:** Coins and boosters = server ledger sum; IAP grants are written **only** by the server (`verifyPurchase`), never by the client.
4. **Idempotent:** every op has a UUID; resending never double-applies.
5. **Deterministic merge rules** (§6) — no "last device wins" for progress or wallet.

## 2. What needs internet

| Feature | Internet | Offline behaviour |
|---|---|---|
| Levels, Daily Stitch, Spin, boosters, Craft Basket, Scrapbook, Wardrobe (coins) | No | Fully playable; ops queued |
| Rewarded / interstitial / banner ads | **Yes** | Ad buttons disabled "Ad unavailable"; coin options stay (standard §3) |
| IAP (coin packs, Starter Pack, VIP, Piggy break) | **Yes** | Buttons disabled "Connect to purchase"; VIP cached until `vipActiveUntil` + 3-day grace (Phase 1 rule) |
| Weekly Star Race | **Yes** (join, reports, live track) | Clears queued; see [04 §3.8](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) |
| Leaderboards (`games_services`) | **Yes** | Score submit retried on next online start |
| Cloud sync / account link / delete account | **Yes** | Queue persists; "Last synced …" shown |
| Remote Config fetch, server time | Yes | Bundled defaults; anti-cheat offline rules (standard §8.4) |

## 3. Auth Flow (Firebase Auth)

| Step | Behaviour |
|---|---|
| First Phase 2 launch (online) | `signInAnonymously()` silently ⇒ `uid`. Offline ⇒ retry on next connectivity; gameplay unaffected |
| First upload | Full local snapshot uploaded once via `applyOps` op `bootstrap` (server accepts it only when `users/{uid}` doesn't exist) |
| Link account (Settings → "Save progress") | `currentUser.linkWithProvider(GoogleAuthProvider())` / `AppleAuthProvider()` ⇒ same `uid`, data kept |
| Link conflict (`credential-already-in-use` — the sign-in already has a cloud save) | **Player chooses which save to keep** (standard §17.36). Dialog shows both side by side (level, ★, Coins, last played): **"Keep this device's save"** ⇒ flush queue, sign in with the returned credential, server replaces that account's cloud save with this device's snapshot (`applyOps` op `replace_with_device`, old cloud save archived 30 days) · **"Keep cloud save (Level X)"** ⇒ flush queue, sign in, download cloud save, replace local save · **Cancel** ⇒ nothing changes. 2-step confirm on the discarded side. **No automatic merge** of two accounts (prevents wallet duplication) |
| New device (local save has progress) | Sign in with Google/Apple ⇒ same choice dialog: keep device save **or** cloud save (no merge). Fresh install with no progress ⇒ cloud save downloaded directly |
| Sign out | Allowed only after queue flushed; local save cleared; new anonymous user |
| Under-13 band (standard §7.3) | Anonymous cloud save only; **no Google/Apple link prompt** (no account data from children). Families policy review item |

## 4. Local Save Additions (Hive, save schema v2)

Standard §14 + §17.37 Phase 2 boxes (`album`, `piggy`, `cosmetics`, `syncQueue`, `race`, `account`). `settings.ageBand` is **device-local and never synced** (not in any op, not in `users/{uid}`):

| Box | Fields |
|---|---|
| `album` | `stickers: List<int>` (levels), `volumesClaimed: List<int>`, `dailyPatches: List<String>` |
| `piggy` | `stored: int`, `unlocked: bool` |
| `cosmetics` | `owned: List<String>`, `equipped: {threadSkin, boardTheme, needleCharm, profileFrame}`, `equippedAtUtc` |
| `syncQueue` | key = op id, value = op map (§5) |
| `race` | `weekKey`, `cohortId`, `joinedAt`, `clears`, `tzOffsetMin` (standard §17.37) |
| `account` | `uid`, `provider` (anonymous / google / apple), `lastSyncUtc`, `serverCoins`, `serverBoosters`, `bootstrapDone` (standard §17.37) |

Migration v1 → v2: create boxes, retroactive Scrapbook grant ([04 §2.4](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) as ops, `piggy.unlocked = highestCleared ≥ 30`.

## 5. Op-Log

### 5.1 Op shape
```json
{"id": "5f0c…", "type": "coins", "delta": 20, "reason": "clear", "ref": "L612",
 "clientUtcMs": 1793083200000, "seq": 418, "v": 1}
```

### 5.2 Op ids
- **Once-only rewards** use **UUID v5** (name-based) from a fixed namespace + `uid` + key ⇒ the same reward produces the same id on every device ⇒ server dedupes across devices.
- **Repeatable actions** (buy booster, use booster, Heart Refill, Darning Patch, cosmetic equip) use **UUID v4**.

| Op type | Key / id | Server validation bound |
|---|---|---|
| `coins` reason `clear` | v5 `clear:<level>` | 15 / 20 / 30 / 50 by level `tag` (server has level tags) |
| `coins` reason `star3` | v5 `star3:<level>` | +20; requires `stars[level] = 3` in same batch or state |
| `coins` reason `x2win` | v5 `x2:<level>` | = clear amount |
| `coins` reason `gift` / `chest` | v5 `gift:<level>` | 150–300 per range / 1,000 at L500, L1000 |
| `coins` reason `rush` | v5 `rush:<level>` | ≤ 400 (≤ 10 × threads + 100) |
| `coins` reason `daily` / `streak` | v5 `daily:<dayKey>` / `streak:<dayKey>` | 100 / ladder value; server-time check §6.3 |
| `coins` reason `spin` | v5 `spin:<dayKey>:<index>` | must equal PRNG result for `(installId, dayKey, index)` |
| `coins` reason `shop_ad` | v4 | +50, ≤ 5 per dayKey |
| `coins` reason `album_vol` | v5 `album_vol:<n>` | Vol default table |
| `coins` negative (spend) | v4 | price table (booster 40–250, refill 120, saver 200, cosmetic price) |
| `booster` (+/−) | v5 for grants (`gift`, `chest`, `streak`, `tutorial`), v4 for buy/use | grant table / ≤ caps per attempt |
| `progress` | v5 `win:<level>` (first clear) · v5 `stars:<level>:<n>` (replay improves stars to n) | `level ≤ highestCleared + 1`; stars 1–3; merge = max |
| `album_sticker` | v5 `sticker:<level>` | level is x0 and ≤ highestCleared |
| `cosmetic_buy` | v5 `cos:<itemId>` | price matches catalog |
| `piggy_accrue` | v5 `piggy:<level>` | +10, cap 1,000 |
| `race_clear` | v4 | forwarded to `reportRaceClear` |
| IAP grants | **server-only** | written by `verifyPurchase` |

Ops failing validation are **rejected individually** (not the batch); response lists `rejected[{id, reason}]`; client removes them from the queue and re-applies the server snapshot (the local optimistic value is corrected). Rejections are logged (`sync_op_rejected{type, reason}`).

## 6. Conflict Rules

### 6.1 Merge table
| Field | Rule |
|---|---|
| `progress.highestCleared` | **max** |
| `progress.stars[level]` | **max per level** |
| `progress.adReviveUsed[level]` | OR for levels > merged `highestCleared`; cleared levels dropped (reset on clear — standard §3) |
| Coins | **server ledger sum** (Σ accepted coin ops); local display = server balance + pending local deltas |
| Boosters | server ledger sum per booster |
| Streak (`day`, `totalDays`, `cycleSaverUsed`, `trophyTier`) | **server-time authoritative** (§6.3) |
| Album stickers / volumes | union |
| Cosmetics owned | union · equipped = last-write-wins by `equippedAtUtc` |
| Piggy `stored` | server value |
| VIP / Starter Pack | server (receipt-verified) |
| `ads.*`, `settings` (incl. **`ageBand` — never synced**, §17.37), `time.*` | device-local, not synced |

### 6.2 Negative balance (multi-device spend)
Two offline devices can each spend the same Coins. Spend ops are **accepted** (the item was already consumed) and the ledger may go below 0. Client shows **0** with a small "Coins owed: N" note in the Wallet sheet; later earnings repay first; shop coin purchases disabled until balance ≥ price. Logged as `sync_negative_balance{amount}`.

### 6.3 Streak (server-time authoritative)
- Server receives `daily:<dayKey>` with `clientUtcMs` and tz offset. Accept if `dayKey` = local date of `serverNow + offset`, or (queued offline) `dayKey ≤ that date` and `clientUtcMs ≥ lastTrustedUtc` of the last accepted claim + 20 h (standard §8.4).
- Server rebuilds the streak from accepted dayKeys (Day 1–7 ladder, 1-day miss ⇒ Darning Patch allowed once per cycle, 2+ days ⇒ reset).
- Mismatch (e.g. clock manipulation) ⇒ **streak frozen** until next valid claim; **coins already granted are not revoked** (standard §8.4).
- Two devices claiming the same `dayKey` ⇒ same v5 id ⇒ counted once.

## 7. Firestore Model & Functions

```
users/{uid}            {schema: 2, progress: {highestCleared, stars: {"612": 3, …}},
                        ledger: {coins, hint, undo, shield, hammer, owed},
                        streak: {…}, album: {…}, cosmetics: {…}, piggy: {stored},
                        iap: {vipActiveUntil, starterPack}, updatedAt}
users/{uid}/ops/{opId} {type, delta, reason, ref, clientUtcMs, serverUtc, status}
```
- Security rules: `allow read: if request.auth.uid == uid;` · `allow write: if false;` (all writes via Functions).
- TTL policy: v4 ops deleted after 30 days; v5 (once-only) ops kept (dedupe forever). Doc size: `stars` map ≤ 1,000 entries (Phase 2) — well below the 1 MiB document limit; Phase 3+ moves stars to `users/{uid}/stars/{phase}` docs.

`applyOps` (callable, App Check enforced) — TypeScript sketch:
```ts
export const applyOps = onCall({ enforceAppCheck: true }, async (req) => {
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "sign in");
  const ops = (req.data.ops ?? []) as Op[];
  if (ops.length > 100) throw new HttpsError("invalid-argument", "batch too large");
  const userRef = db.doc(`users/${uid}`);
  const accepted: string[] = [];
  const rejected: { id: string; reason: string }[] = [];
  await db.runTransaction(async (tx) => {
    const user = (await tx.get(userRef)).data() ?? emptyUser();
    const opRefs = ops.map((o) => userRef.collection("ops").doc(o.id));
    const existing = await tx.getAll(...opRefs);
    ops.forEach((op, i) => {
      if (existing[i].exists) { accepted.push(op.id); return; }        // idempotent
      const reason = validateOp(op, user);                             // §5.2 bounds
      if (reason) { rejected.push({ id: op.id, reason }); return; }
      applyToUser(user, op);                                           // ledger / max / union
      tx.set(opRefs[i], { ...op, serverUtc: Date.now(), status: "ok" });
      accepted.push(op.id);
    });
    tx.set(userRef, { ...user, updatedAt: Date.now() });
  });
  return { accepted, rejected, snapshot: await publicSnapshot(uid) };
});
```
(Batch of 100 ⇒ ≤ 101 reads + 101 writes, under Firestore's 500-write transaction limit.)

Other functions: `getCloudSave` (snapshot), `verifyPurchase` (Phase 1 + piggy/cosmetic-free ledger writes), `deleteUserData` (§9), Star Race functions ([04 §3.6](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)).

## 8. Client Sync Code (Dart 3, compile-correct)

Packages: `connectivity_plus` (current API: `onConnectivityChanged` emits `List<ConnectivityResult>`), `cloud_functions`, `firebase_auth`, `hive_ce`, `uuid`.

```dart
import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

/// Fixed namespace for name-based (v5) once-only op ids. Never change.
const String kYarnOpNamespace = '3b1f7a52-6c0e-4d7b-9a51-2f8e4c6d9b10';
const Uuid _uuid = Uuid();

class OpIds {
  const OpIds._();

  /// Same reward on any device => same id => server dedupes.
  static String onceOnly(String uid, String key) =>
      _uuid.v5(kYarnOpNamespace, '$uid|$key');

  /// Repeatable actions (buy/use booster, refill, saver, equip).
  static String repeatable() => _uuid.v4();
}

class SyncOp {
  SyncOp({
    required this.id,
    required this.type,
    required this.payload,
    required this.clientUtcMs,
    required this.seq,
  });

  final String id;
  final String type;
  final Map<String, Object?> payload;
  final int clientUtcMs;
  final int seq;

  Map<String, Object?> toMap() => <String, Object?>{
        'id': id,
        'type': type,
        ...payload,
        'clientUtcMs': clientUtcMs,
        'seq': seq,
        'v': 1,
      };

  static SyncOp fromMap(Map<dynamic, dynamic> m) {
    final copy = Map<String, Object?>.from(m);
    final id = copy.remove('id')! as String;
    final type = copy.remove('type')! as String;
    final clientUtcMs = copy.remove('clientUtcMs')! as int;
    final seq = copy.remove('seq')! as int;
    copy.remove('v');
    return SyncOp(
      id: id,
      type: type,
      payload: copy,
      clientUtcMs: clientUtcMs,
      seq: seq,
    );
  }
}

/// Persistent queue in the Hive box `syncQueue` (key = op id).
class SyncQueue {
  SyncQueue(this._box);

  final Box<dynamic> _box;
  int _seq = 0;

  Future<void> enqueue(String id, String type, Map<String, Object?> payload) {
    _seq = math.max(_seq, _box.length) + 1;
    final op = SyncOp(
      id: id,
      type: type,
      payload: payload,
      clientUtcMs: DateTime.now().toUtc().millisecondsSinceEpoch,
      seq: _seq,
    );
    return _box.put(id, op.toMap()); // re-enqueue of same id overwrites: idempotent
  }

  List<SyncOp> pending({int limit = 100}) {
    final ops = _box.values
        .whereType<Map<dynamic, dynamic>>()
        .map(SyncOp.fromMap)
        .toList()
      ..sort((a, b) => a.seq.compareTo(b.seq));
    return ops.take(limit).toList();
  }

  Future<void> removeAll(Iterable<String> ids) => _box.deleteAll(ids);

  bool get isEmpty => _box.isEmpty;
}

typedef SnapshotApplier = Future<void> Function(Map<String, Object?> snapshot);

class SyncService {
  SyncService({
    required this.queue,
    required this.applySnapshot,
    Connectivity? connectivity,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  })  : _connectivity = connectivity ?? Connectivity(),
        _functions = functions ?? FirebaseFunctions.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final SyncQueue queue;
  final SnapshotApplier applySnapshot;
  final Connectivity _connectivity;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _retryTimer;
  bool _flushing = false;
  int _attempt = 0;
  final math.Random _jitter = math.Random();

  static const Duration _base = Duration(seconds: 2);
  static const Duration _max = Duration(minutes: 5);

  void start() {
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      if (_isOnline(results)) {
        _attempt = 0;
        unawaited(flush());
      }
    });
    unawaited(flush());
  }

  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _sub?.cancel();
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  /// Call on app resume, after each level win (debounced by caller), and on start.
  Future<void> flush() async {
    if (_flushing || queue.isEmpty) return;
    final results = await _connectivity.checkConnectivity();
    if (!_isOnline(results)) return;
    _flushing = true;
    try {
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
      }
      final batch = queue.pending();
      final callable = _functions.httpsCallable('applyOps');
      final result = await callable.call<Object?>(<String, Object?>{
        'ops': batch.map((o) => o.toMap()).toList(),
      });
      final data = Map<String, Object?>.from(result.data! as Map);
      final accepted = (data['accepted'] as List? ?? const []).cast<String>();
      final rejected = (data['rejected'] as List? ?? const [])
          .map((e) => Map<String, Object?>.from(e as Map)['id'] as String);
      await queue.removeAll(<String>[...accepted, ...rejected]);
      final snapshot = data['snapshot'];
      if (snapshot is Map) {
        await applySnapshot(Map<String, Object?>.from(snapshot));
      }
      _attempt = 0;
      if (!queue.isEmpty) {
        _flushing = false;
        await flush(); // drain remaining batches
        return;
      }
    } on FirebaseFunctionsException catch (e) {
      if (e.code != 'invalid-argument') _scheduleRetry();
    } on FirebaseAuthException {
      _scheduleRetry();
    } finally {
      _flushing = false;
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _attempt = math.min(_attempt + 1, 10);
    final expMs = _base.inMilliseconds * math.pow(2, _attempt - 1).toInt();
    final cappedMs = math.min(expMs, _max.inMilliseconds);
    final jitter = 0.8 + _jitter.nextDouble() * 0.4; // ±20 %
    _retryTimer = Timer(
      Duration(milliseconds: (cappedMs * jitter).round()),
      () => unawaited(flush()),
    );
  }
}
```

Usage example (first clear of L612, Normal):
```dart
Future<void> onFirstClear(
  SyncQueue q,
  String uid,
  int level,
  int stars,
  int coins,
) async {
  await q.enqueue(OpIds.onceOnly(uid, 'win:$level'), 'progress',
      <String, Object?>{'level': level, 'stars': stars});
  await q.enqueue(OpIds.onceOnly(uid, 'clear:$level'), 'coins',
      <String, Object?>{'delta': coins, 'reason': 'clear', 'ref': 'L$level'});
  await q.enqueue(OpIds.onceOnly(uid, 'piggy:$level'), 'piggy_accrue',
      <String, Object?>{'delta': 10});
}
```
(Before the first sign-in `uid` is unknown: ops are enqueued with key `pending:<key>` and their v5 ids are computed at first flush, after `signInAnonymously()`.)

## 9. Retry, Backoff & Triggers

| Item | Value |
|---|---|
| Triggers | app start, app resume, connectivity regained, level win (debounce 5 s), every 15 min foreground if queue non-empty, before any IAP (Piggy break flush is mandatory) |
| Batch | ≤ 100 ops, ordered by `seq` |
| Backoff | 2 s × 2^(n−1), cap 5 min, jitter ±20 %, reset on success / connectivity regained |
| Non-retryable | `invalid-argument` (malformed batch) ⇒ Crashlytics non-fatal, ops kept for next app version |
| Queue size guard | > 5,000 ops ⇒ compact: sum consecutive v4 `coins` ops with the same reason into one op (new v4 id) |
| UI | Settings → Account: "Last synced 5 min ago" / "Waiting for internet (12 changes)" |

## 10. Account & Data-Deletion Flows

| Flow | Steps |
|---|---|
| Delete account (in-app, required by App Store & Play) | Settings → Account → "Delete account & cloud data" ⇒ explain what's deleted ⇒ 2-step confirm ⇒ callable `deleteUserData` ⇒ Admin SDK recursive delete `users/{uid}` (+ `ops`, `race`) ⇒ Star Race rows replaced by "Left the race" ⇒ `auth.deleteUser(uid)` ⇒ client wipes local save (option "Keep progress on this device only" re-creates a fresh anonymous account and re-uploads) |
| Web deletion request | Play Data-safety "delete data" URL ⇒ support form ⇒ same function by operator |
| Subscriptions | Deleting the account does **not** cancel VIP — screen links to store subscription management |
| Data export | Settings → "Download my data" ⇒ `getCloudSave` JSON shared via OS share sheet |
| Reinstall without link | Anonymous uid lost ⇒ cloud data orphaned; copy in Settings warns: "Link Google/Apple to keep progress across reinstalls" |

## 11. Edge Cases

| # | Case | Rule |
|---|---|---|
| S1 | Same level cleared on two devices offline | v5 ids identical ⇒ coins counted once; stars = max |
| S2 | Booster used offline on two devices beyond inventory | Use ops accepted; booster ledger may go negative ⇒ shown 0, repaid by next grants |
| S3 | Op rejected (e.g. impossible coin amount) | Removed from queue; server snapshot overwrites wallet; non-fatal log |
| S4 | Clock moved back offline | Time-travel lock (standard §8.4) still local; server streak check §6.3 |
| S5 | App killed during flush | Ops remain in queue (deleted only after ack); resend is idempotent |
| S6 | Cloud save newer schema than app | Read-only mode: gameplay ok, sync paused, "Update the app to sync" |
| S7 | Firestore unavailable | Retry/backoff; gameplay unaffected |
