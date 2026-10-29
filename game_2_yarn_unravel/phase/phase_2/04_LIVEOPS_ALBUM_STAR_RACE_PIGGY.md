# 04 — LiveOps: Scrapbook Album, Weekly Star Race, Knitted Piggy Bank & Wardrobe
> Purpose: Phase 2 LiveOps features ના exact rules — Scrapbook (Sticker Album), Weekly Star Race (5-player async race, Firebase backend + server validation), Knitted Piggy Bank (₹49) અને Wardrobe (Cosmetic Shop, 800–4,000 Coins).

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§6.2, §7.2, §7.3, §8.4, §13, §14) · [./README.md](./README.md) · [./01_PHASE_2_SCOPE_AND_RULES.md](./01_PHASE_2_SCOPE_AND_RULES.md) · [./05_OFFLINE_AND_CLOUD_SYNC.md](./05_OFFLINE_AND_CLOUD_SYNC.md) · [./06_FRONTEND_AND_QA_PHASE_2.md](./06_FRONTEND_AND_QA_PHASE_2.md) · [../phase_1/04_BOOSTERS_COINS_SHOP.md](../phase_1/04_BOOSTERS_COINS_SHOP.md)

> Standard માં ન હોય એવા values (album rewards, cosmetic prices ની વહેંચણી, race validation thresholds) અહીં **launch defaults** તરીકે આપ્યા છે અને Remote Config થી tune થાય (§6). Retention/ARPU ની કોઈ અંદાજિત ટકાવારી આ doc માં આપી નથી — impact analytics (§7) થી માપવો.

---

## 1. Overview & Unlocks

| Feature | Themed name | Unlock | Needs internet? |
|---|---|---|---|
| Sticker Album | **Scrapbook** | Phase 2 build install (retroactive) | No (offline grant; cloud backup online) |
| Weekly Star Race | **Weekly Star Race** ("Cozy Cup") | `highestCleared ≥ 60` | **Yes** (join + reports); levels themselves offline-playable |
| Piggy Bank | **Knitted Piggy Bank** | shown after **L30** clear | Break = IAP ⇒ yes |
| Cosmetic shop | **Wardrobe** | Phase 2 build, Shop tab | No for coin purchases (sync later) |

## 2. Scrapbook (Sticker Album)

### 2.1 Structure
**1 sticker per milestone level** (દર 10મો level: L10, 20 … 1000) ⇒ 100 stickers, 5 volumes.

| Volume | Theme | Levels | Stickers | Completion reward (default) |
|---|---|---|---|---|
| Vol 1 | Purl's First Basket (knitting tools: needles, skein, thimble…) | L10–100 | **10** | 300 Coins + "Purl Paw" needle charm |
| Vol 2 | Cozy Cottage (mittens, teacup cozy, quilts…) | L110–250 | **15** | 400 Coins + "Cottage Lace" profile frame |
| Vol 3 | The Grand Quilt Fair (patchwork blocks, ribbons…) | L260–500 | **25** | 600 Coins + "Fair Rosette" needle charm |
| Vol 4 | Bias & Lamplight Studio (bias tape, lamps, crates…) | L510–750 | **25** | 800 Coins + "Starlight Bead" profile frame |
| Vol 5 | The Heirloom Chest (lace, jewels, tapestry…) | L760–1000 | **25** | 1,000 Coins + "Heirloom Gold" needle charm |

Check: 10 + 15 + 25 + 25 + 25 = **100** = number of x0 levels in L10–1000. Album coins total = 3,100 (one-time). દરેક volume = Coins + **બરાબર 1 cosmetic** (standard §17.26). Volumes milestone-based જ રહે; Daily silhouettes અલગ page પર (§2.5, §17.25).

### 2.2 Grant rules
| Rule | Value |
|---|---|
| Trigger | x0 level **first clear** (stars irrelevant; replays never re-grant) |
| Order on win screen | Level Complete ⇒ Craft Basket / Grand Sewing Chest ⇒ **sticker reveal** ⇒ Golden Bobbin Rush |
| Duplicate | Impossible (1 per level, idempotent key `sticker:<level>`) |
| Volume complete | Last sticker of a volume ⇒ completion popup ⇒ Coins + cosmetic (idempotent key `album_vol:<n>`) |
| Interstitial | Sticker reveal = reward screen ⇒ interstitial deferred (same as Craft Basket) |
| Offline | Granted locally; op-log syncs later ([05](./05_OFFLINE_AND_CLOUD_SYNC.md)) |

### 2.3 Presentation
Sticker = knitted patch illustration; reveal: patch outline ⇒ stitches fill (600 ms) ⇒ "thump" stamp into the Scrapbook page. Scrapbook screen: book with 5 tabs (volumes), page grid, locked stickers show level number silhouette. Completed volume gets a ribbon bookmark.

### 2.4 Retroactive grant (existing Phase 1 players)
1. Phase 2 build first launch (or save migration v1 → v2): for every x0 level `≤ highestCleared` grant its sticker **once**.
2. Any volume thus completed ⇒ its completion reward granted once (e.g. a player at L500 receives Vol 1–3 = 300 + 400 + 600 = 1,300 Coins + 3 cosmetics).
3. Shown as one "Your Scrapbook is ready!" screen before L501 (not one popup per sticker).
4. Ops use the same idempotent keys (§2.2) ⇒ re-migration or a second device never double-grants.

### 2.5 Daily Patches page (standard §8.1 note)
Daily Stitch silhouettes (Mitten, Teacup, Sock, Scarf, Heart Locket, Sweater, Purl) are shown on a separate **Daily Patches** page in the Scrapbook: each silhouette is marked once cleared at least once. Collection only — **no coins, no completion reward** (Daily reward stays +100 per standard).

### 2.6 Edge cases
| Case | Rule |
|---|---|
| Level cleared on another device | Cloud progress `max` ⇒ sticker granted on merge |
| Save restore from backup with lower progress | Stickers are union-merged (never removed) |
| Remote Config changes reward | Applies only to volumes not yet completed |

## 3. Weekly Star Race ("Cozy Cup")

### 3.1 Schedule & eligibility
| Rule | Value |
|---|---|
| Window | Every **Saturday 08:00 → Sunday 23:59 local time** (≈ 40 h) |
| Join window | Sat 08:00 → **Sun 12:00** local (late joiners would have < 12 h) |
| Unlock | `highestCleared ≥ 60` |
| Extra eligibility | At least **15 numbered levels remaining** before `maxLevel` (= `maxPhase × 500`). Else "Race needs 15 new levels — check back after the next update" |
| Goal | **First to clear 15 numbered levels** (first clears only, in normal level order, after joining) |
| What doesn't count | Replays, Daily Stitch, Golden Bobbin Rush, levels cleared before joining |
| Boosters / revive | Allowed (normal rules; race doesn't change economy) |
| Child band (under-13) | Allowed; generated nicknames only (§3.4) |

Timezone: the player's UTC offset is **locked at join** (bounded −12:00…+14:00). Cohorts group players whose offsets are within ±3 h so windows overlap. Device timezone change mid-race doesn't move the window.

### 3.2 Cohort formation (async, 5 players)
1. Client calls `joinStarRace({weekKey, tzOffsetMin, levelBand})` — `weekKey` = ISO week of the Saturday (e.g. `2026-W44`), `levelBand = highestCleared ~/ 100`.
2. Server puts the player into an **open cohort** with same `weekKey`, same `levelBand` (±1 if needed) and compatible offset. Cohort closes at **5 real players** or **2 h after creation**.
3. On close, empty seats are filled by **ghosts** (§3.3). Player's own race starts at join (not at close).

### 3.3 Ghost fill (historical times)
| Rule | Value |
|---|---|
| Source | `ghostTraces` = anonymised past race traces: list of `secondsSinceJoin` for clears 1–15 from real players of the same `levelBand` (no uid, no name) |
| Selection | PRNG(seed = hash(cohortId, seat)) picks a trace; replayed relative to the cohort's creation time |
| Display | Ghost rows show a generated name + small "Ghost" tag (honest disclosure) |
| Rewards | Ghosts never receive rewards; real players' ranks include ghosts (a ghost can take 1st) |
| No traces yet (launch week) | Designer seed traces derived from internal playtests; replaced as real data accumulates |

### 3.4 Display & privacy
- Name = generated nickname (adjective + yarn noun + 3 digits, e.g. "Cozy Bobbin 482"); **no free-text names, no chat** (Families policy, standard §7.3). Avatar = an owned Scrapbook sticker or profile frame.
- Race screen: 5 yarn balls rolling along a knitted scarf track (0–15 stitches); own row highlighted; live updates via Firestore snapshot listener on the cohort's `progress` sub-collection (online only).

### 3.5 Ranking & rewards
Ranking at window end: finishers (15 clears) by **server-received time** of their 15th validated clear; then non-finishers by clears (desc), tie ⇒ earlier server time of last clear.

| Rank | Reward |
|---|---|
| 1st | **1,000 Coins** + "Golden Rosette" profile frame + **3 of each booster** (3 Needle Glow Hint, 3 Thimble Shield, 3 Golden Scissors) |
| 2nd | **500 Coins** + 2 Golden Scissors + 1 Needle Glow Hint |
| 3rd | **250 Coins** + 1 Thimble Shield |
| 4th–5th | **50 Coins** |

- Minimum 1 validated clear to receive any reward.
- Rewards are written by `finalizeStarRaces` into the server ledger as ops with id `race:<cohortId>:<uid>` (idempotent) and appear on next app open ("Race results" popup). Frame duplicates ⇒ already owned, no extra.
- Rewards granted for rank, not for leaderboard position on Play Games / Game Center (those stay fun-only, standard §8.3).

### 3.6 Backend (Firebase)
**Firestore model**
```
races/{weekKey}                         {startsSatLocal: "08:00", endsSunLocal: "23:59", status}
cohorts/{cohortId}                      {weekKey, levelBand, tzBucket, createdAt, closedAt?, seats: 5,
                                         members: [uid…], ghosts: [{seat, traceId, name}], finalized: bool}
cohorts/{cohortId}/progress/{uid}       {name, avatar, clears: 0..15, lastLevel, lastAt, finishedAt?,
                                         joinLevel, tzOffsetMin, flagged: bool}
users/{uid}/race/{weekKey}              {cohortId, joinedAt, reportedLevels: [..]}
ghostTraces/{traceId}                   {levelBand, secs: [s1..s15]}
```
Security rules: clients may **read** their own cohort + its `progress`; **no client writes** (all via callable Functions with App Check).

**Cloud Functions**
| Function | Type | Job |
|---|---|---|
| `joinStarRace` | callable | eligibility (server `highestCleared` from cloud save ≥ 60, window open in player's offset, 15 levels remaining), cohort assignment |
| `reportRaceClear` | callable | validate + record one clear (§3.7) |
| `closeCohorts` | scheduled every 10 min | close cohorts older than 2 h, fill ghosts |
| `finalizeStarRaces` | scheduled hourly (Sun–Mon) | after each tz bucket's window + grace ⇒ rank, write reward ops, mark `finalized` |

### 3.7 Server-side validation
`reportRaceClear({cohortId, level, moves: [ids…], movesCount, heartsLost, durationMs, clientUtc, opId})`

| Check | Rule (defaults, Remote Config) |
|---|---|
| Auth + App Check | required; else reject |
| Idempotency | `opId` already processed ⇒ return previous result |
| Sequence | `level == previousReportedLevel + 1` (or `joinLevel + 1` for first); level `≤ maxLevel` |
| Window | server time within the player's window (+ **60 min grace** for offline-queued reports); `clientUtc` within window |
| Rate limit | ≥ **15 s** between accepted reports per user; ≤ 15 clears per race; ≤ 60 calls/hour |
| Plausibility: moves | `movesCount ≥ par_moves[level]` (bundled level data known to server) and `movesCount == moves.length` |
| Plausibility: time | `durationMs ≥ movesCount × 250 ms` (animation lower bound) |
| Consistency | `level ≤ server highestCleared + 1` after sync of the same clear (clear op arrives via `applyOps` too) |
| Podium replay | For ranks 1–3 at finalize: replay `moves` with `puzzle_core` verifier (Dart compiled to JS, bundled in Functions) ⇒ must reach Win with `heartsLost` matching. Fail ⇒ `flagged`, excluded from rewards, rank recomputed |
| Failure response | Rejected reports are **not** counted; client shows "Couldn't verify this clear" (level progress itself is unaffected) |

### 3.8 Offline behaviour
| Situation | Behaviour |
|---|---|
| Offline at window start | Race banner "Connect to join"; levels play normally |
| Joined, then offline | Clears queued in `syncQueue` as `race_clear` ops with `clientUtc`; sent on reconnect in order |
| Reconnect after window end + 60 min grace | Queued race clears discarded (level progress kept); results show last server state |
| Rank ordering with offline clears | Uses **server-received** time ⇒ backdating offline clears doesn't improve rank |
| Time-travel lock active (standard §8.4) | Join disabled until clock trusted |

### 3.9 Edge cases
| Case | Rule |
|---|---|
| Player reaches L1000 / maxLevel mid-race | Keeps current clears; can't progress further |
| Reinstall mid-race (same uid via cloud) | Rejoins same cohort (`users/{uid}/race/{weekKey}`) |
| Two devices same account | Server sequence check ⇒ each level counted once |
| Cohort member deletes account | Row shown as "Left the race"; seat not refilled |
| All 4 other seats ghosts | Allowed; ghost disclosure visible |

## 4. Knitted Piggy Bank (₹49)

### 4.1 Rules
| Rule | Value |
|---|---|
| Visibility | After **L30** clear (Home icon + Shop "Offers" + small piggy on Level Complete) |
| Accrual | **+10 Coins** into the bank per **numbered-level first clear** after unlock (L31 onward). Replays, Daily, Rush ⇒ 0 |
| Spendable? | **No** — bank coins are not in the wallet until bought |
| Cap | **1,000** Coins; at cap ⇒ "Full!" badge, further accrual lost (shown "+0 (full)") |
| Break | IAP consumable **`yarn_piggy_bank` ₹49** ⇒ all stored coins move to wallet; bank resets to 0 |
| Break threshold | Button enabled from **350** stored Coins (never worse than Coins S) |
| Repeat | Unlimited (consumable); refills from 0 |
| VIP | No effect on piggy |
| Existing players at Phase 2 release | Bank starts at 0 (no retroactive accrual) |

### 4.2 Value comparison (correct arithmetic)
| Offer | Price | Coins | Coins per ₹ |
|---|---|---|---|
| Coins S | ₹49 | 350 | 7.1 |
| Coins M (Popular) | ₹149 | 1,000 | 6.7 |
| **Knitted Piggy Bank (full)** | ₹49 | 1,000 | 20.4 |
| Knitted Piggy Bank (at threshold) | ₹49 | 350 | 7.1 |

- Full piggy = **same 1,000 Coins as Coins M for ₹100 less**, ≈ 2.9× the Coins of Coins S at the same ₹49.
- UI copy may say "1,000 Coins for ₹49 (Coins M is ₹149)". Copy must **not** claim "% off the standard rate" beyond this computed comparison, and must show the actual stored amount.
- Fill time: 1,000 / 10 = **100 first clears** from empty.

### 4.3 Flow & backend
1. Accrual op `piggy:+10` with idempotent id `piggy:<level>` (op-log, [05](./05_OFFLINE_AND_CLOUD_SYNC.md)); server keeps `piggy.stored = min(1000, Σ accruals since last break)`.
2. Break: `InAppPurchase.buyConsumable(yarn_piggy_bank)` ⇒ `verifyPurchase` (Cloud Function) reads **server** `piggy.stored`, writes ledger op `piggy_break:<purchaseToken>` (+stored Coins), resets bank ⇒ client grants after response.
3. Offline accruals not yet synced at purchase time: client flushes `syncQueue` **before** launching the purchase; if flush fails ⇒ purchase button disabled "Connect to break".
4. Purchase pending / failed ⇒ bank unchanged.

### 4.4 Edge cases
| Case | Rule |
|---|---|
| Refund (store) | Server receives RTDN / App Store notification ⇒ ledger op −coins (balance may go negative ⇒ [05 §6](./05_OFFLINE_AND_CLOUD_SYNC.md)) |
| Bank shows 980, server says 1,000 (other device) | Server value wins at break |
| Under-13 band | Piggy visible, purchase uses store parental controls; no auto-popup (Shop only) |

## 5. Wardrobe (Cosmetic Shop)

### 5.1 Rules
- **Cosmetics are visual only** — no gameplay effect. Thread skins change **material/texture** (ply, sheen, fuzz, sparkle), never the thread's **hue or colour-blind pattern/icon** (colour is gameplay: M005, M030, M059 …).
- Price range **800–4,000 Coins** (standard §6.2). Owned forever (non-consumable, stored in `cosmetics.owned`, cloud-synced).
- Slots: `threadSkin`, `boardTheme`, `needleCharm`, `profileFrame`. One equipped per slot.

### 5.2 Catalog (launch defaults)
| ID | Type | Name | Price (Coins) |
|---|---|---|---|
| `skin_mohair` | Thread skin | Mohair Fuzz (soft halo fibres) | 800 |
| `skin_silk` | Thread skin | Silk Sheen (glossy highlight) | 1,200 |
| `skin_tweed` | Thread skin | Tweed Fleck (tiny same-hue flecks) | 1,600 |
| `skin_velvet` | Thread skin | Velvet Pile (matte, deep shadow) | 2,000 |
| `skin_lurex` | Thread skin | Sparkle Lurex (metallic glints) | 2,500 |
| `skin_speckle` | Thread skin | Hand-Dyed Speckle (tonal speckles) | 3,000 |
| `board_oak` | Board theme | Grandma's Oak Table | 1,500 |
| `board_moon` | Board theme | Moonlit Window Seat (dark board) | 2,500 |
| `board_fair` | Board theme | Quilt Fair Tent | 4,000 |
| `skin_vip_gold` | Thread skin (VIP) | Golden Lurex | **VIP only** — not sold for Coins |

Full catalog cost (Coins items) = 800 + 1,200 + 1,600 + 2,000 + 2,500 + 3,000 + 1,500 + 2,500 + 4,000 = **19,100 Coins**.

### 5.3 VIP skin
- `skin_vip_gold` is **equippable only while VIP No-Ads Pass is active** (`iap.vipActiveUntil > now`). On expiry the game reverts to the previously equipped skin; re-subscribing restores access. Wording: "Included while your VIP pass is active" (never "permanent").

### 5.4 Exclusive (not sold)
Album needle charms / profile frames (§2.1) and Star Race "Golden Rosette" frame are earned only. Board themes must keep contrast: every theme passes the [../phase_1/06 §3](../phase_1/06_UI_UX_SCREENS.md) contrast rules (thread vs board ≥ 3:1).

### 5.5 Purchase flow
Preview (live board sample with try-on) ⇒ Buy ⇒ spend op `cos:<itemId>` (idempotent — buying twice impossible) ⇒ owned ⇒ Equip. Not enough Coins ⇒ mini shop sheet (Coin packs).

## 6. Remote Config Keys (Phase 2 LiveOps)
`album_vol_rewards`, `star_race_enabled`, `star_race_min_level` (60), `star_race_target` (15), `star_race_rewards`, `star_race_join_cutoff_local` ("Sun 12:00"), `star_race_grace_min` (60), `star_race_min_report_gap_s` (15), `star_race_min_ms_per_move` (250), `piggy_enabled`, `piggy_per_clear` (10), `piggy_cap` (1000), `piggy_break_min` (350), `cosmetic_prices`, `maxPhase`.

## 7. Analytics (Phase 2 additions)
`album_sticker{level, volume}`, `album_volume_complete{volume}`, `race_join{weekKey, levelBand}`, `race_clear{weekKey, n}`, `race_result{weekKey, rank, ghosts}`, `race_report_rejected{reason}`, `piggy_accrue{stored}`, `piggy_offer_view{stored}`, `piggy_break{stored}`, `cosmetic_buy{itemId, price}`, `cosmetic_equip{itemId}`. Feature impact (retention, revenue) measured by A/B via Remote Config — no pre-launch percentage claims.
