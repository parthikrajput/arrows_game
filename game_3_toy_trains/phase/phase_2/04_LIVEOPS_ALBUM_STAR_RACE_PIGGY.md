# 04 · LiveOps: Depot Sticker Album, Weekly Star Race, Piggy Bank & Cosmetics — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 LiveOps features ના exact rules, rewards, backend design (Firebase Auth / Firestore / Functions), offline behaviour, edge cases અને cosmetics shop catalog.

**Related docs:** [Shared Core Standard §6–§8, §13–§14](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [02 Progression](./02_LEVEL_PROGRESSION_0501_1000.md) · [05 Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Boosters, Coins & Shop](../phase_1/04_BOOSTERS_COINS_SHOP.md)

> ⚖️ Standard માં fixed: Piggy Bank ₹49 consumable, max 1,000 stored coins; cosmetics 800–4,000 coins; backend = Firebase Auth/Firestore/Functions. બાકીના LiveOps numbers (album rewards, race rules, piggy deposit) આ game ના **launch defaults** છે, Remote Config થી tunable. આ doc માં કોઈ retention/conversion % claim નથી — impact analytics (§7) થી માપવો.

---

## 1. Overview & Unlocks

| Feature | Unlock | Core loop | Internet |
|---|---|---|---|
| Depot Sticker Album | L10 clear | દર milestone (x0) level ના first clear પર 1 sticker | No |
| Weekly Star Race | L60 clear | Sat 08:00 → Sun 23:59 local, 5-player cohort, first to 15 first-clears | **Yes** |
| Piggy Bank | L30 clear | +10 coins / first clear into the bank; break for ₹49 | Break only |
| Cosmetics ("Liveries & Tables") | L10 clear | Coins ⇒ train liveries / table themes | No (synced later) |

Win-screen reward queue (Phase 2, extends Phase 1 `RewardFlowCubit`): `Level Complete → Gift Crate (x0) → Sticker (x0) → Piggy deposit chip (inline, no popup) → Coin Rush (25s) → Star Race progress toast (inline)`. L1000: `Grand Central Chest → Coin Rush → Phase Complete` (sticker + Vol 5 reward shown **on** Phase Complete; standard §16.20 order unchanged). Interstitials deferred on any win that shows Gift Crate / Chest / Coin Rush (Phase 1 rule).

## 2. Depot Sticker Album (ડેપો સ્ટીકર આલ્બમ)

### 2.1 Rules
- **1 sticker per milestone level** (every 10th level: L10, L20 … L1000) — granted on that level's **first clear** (replay = no sticker).
- Sticker art = illustrated toy-railway scene drawn inside one of the 7 Daily Timetable Run **silhouette frames** (Steam Engine, Semaphore Signal, Arched Bridge, Station Clock, Golden Ticket, Water Tower, Roundhouse — [Phase 1 05 §3](../phase_1/05_DAILY_CHALLENGE_AND_STREAK.md)); sticker #k uses frame `(k − 1) mod 7`.
- Stickers are cosmetic collectibles; they never affect gameplay.
- **Retroactive grant:** Phase 2 update ની પહેલી launch પર (અને દરેક save-migration પર) `for L in 10, 20 … highestCleared step 10 ⇒ grant sticker if missing`; પછી પૂરાં થયેલાં volumes નો reward એક જ "Album catch-up" screen માં એક સાથે.

### 2.2 Volumes

| Vol | Theme | Milestones | Stickers | Completion reward (launch default) |
|---|---|---|---|---|
| 1 | Toy Box Town | L10–100 | **10** | 250 coins + "Toy Box" engine nameplate (cosmetic) |
| 2 | Countryside Line | L110–250 | **15** | 400 coins + "Meadow" carriage bunting (cosmetic) |
| 3 | Mountain Pass | L260–500 | **25** | 600 coins + "Snowcap" chimney trim (cosmetic) |
| 4 | Seaside Express | L510–750 | **25** | 600 coins + "Lighthouse" Route Peek line style (cosmetic) |
| 5 | Grand Terminus | L760–1000 | **25** | 800 coins + "Grand Terminus" table banner (cosmetic) |
| | **Total** | | **100** | **2,650 coins** + 5 album-exclusive cosmetics |

- Album-exclusive cosmetics shop માં વેચાતા નથી, gameplay-neutral (colour/pattern/icon બદલતા નથી).
- Volume reward granted once (`album.volumesClaimed`), when its last sticker lands.
- Economy check: 2,650 coins over 1,000 levels ≈ 2.65 coins/level — standard §6.1 balance sanity (~60–70 coins/level) પર નહિવત્ અસર.

### 2.3 UX
1. Milestone win ⇒ after Gift Crate: wireframe silhouette fills with colour (600 ms, Reduce motion ⇒ fade), wooden stamp "thump" `sfx_sticker_stamp`.
2. "View Album" / "Continue". Album screen: volume tabs, 5×5 (or 5×2/5×3) grid, empty slot shows level number ("L370").
3. Volume complete ⇒ reward card (coins + cosmetic preview, "Equip now").
4. Home: album book icon with red dot when unseen stickers exist.

### 2.4 Data
`album { stickers: Set<int> /* milestone levels */, volumesClaimed: Set<int>, lastSeen: int }` — sync = **set union** ([05 §6](./05_OFFLINE_AND_CLOUD_SYNC.md)). Volume reward coins = op `albumReward{vol}` (idempotent opId = `album-v{vol}-{uid}` ⇒ never double-granted across devices).

## 3. Weekly Star Race (સાપ્તાહિક સ્ટાર રેસ)

### 3.1 Schedule & eligibility
| Rule | Value |
|---|---|
| Window | **Saturday 08:00 → Sunday 23:59** device-local time at join (39 h 59 m ≈ 40 h) |
| Eligibility | L60 cleared, signed in (anonymous OK), online at join, and **≥ 15 unplayed numbered levels** available under current `maxPhase` (else card shows "New tracks coming soon") |
| Join | Home race card "Join the Star Race" (opt-in), any time inside the window |
| Goal | **First to clear 15 numbered levels** (first clears only) |
| Counts | First clear of a numbered level (L61+) completed **after join**. Replays, Daily Timetable Run, Coin Rush **don't count** |
| Cohort | **5 players** (async). Real players + ghosts |
| Week key | ISO week of the Saturday (`2026-W44`) |

### 3.2 Ranking
1. Players who reached 15: order by **server time** of the validated 15th clear.
2. Others: by count (desc), then server time of their last counted clear (asc).
3. Ghosts ranked the same way using their trace timestamps.
4. Ties on identical server ms (practically impossible) ⇒ lower `uid` hash first.

### 3.3 Rewards (claimed after window close)
| Rank | Reward |
|---|---|
| 1st | **1,000 coins + "Golden Whistle" profile frame + 3 Green Signal Hint + 3 Cowcatcher Shield + 3 Track Crane** |
| 2nd | **500 coins + 2 Track Crane + 1 Green Signal Hint** |
| 3rd | **250 coins + 1 Cowcatcher Shield** |
| 4th–5th | **50 coins** |

- Rewards require ≥ 1 counted clear (0 clears ⇒ no reward, "Better luck next weekend").
- Claim: Home race card "Claim" (online) ⇒ `claimRaceReward` Function writes ledger ops (opId = `race-{raceId}-{uid}`) ⇒ idempotent.
- Unclaimed rewards stay claimable for **4 weeks**, then expire.
- Frame = cosmetic shown on race HUD avatar and Home profile chip; frame earned once, re-wins add nothing more for the frame.
- Weekly max from race = 1,000 coins + 12 boosters (1st place).

### 3.4 Matchmaking & ghosts
- `joinRace` (callable) ⇒ finds an open race with same `weekKey`, same **UTC-offset bucket** (offset rounded to 1 h) and same **level band** (`highestCleared` bucket of 100 levels); `< 5` real members and created ≤ 30 min ago; else creates one.
- Seats not filled by real players **10 min** after race creation ⇒ filled with **ghosts** (immediate HUD: "Matching… " placeholders until then — gameplay never waits).
- **Ghost = historical trace:** anonymized `{band, offsets[15]}` = minutes from join to each of 15 counted clears, sampled from completed real races in the same band (`ghosts/{band}` pool, min 200 traces per band before using real data). Pool too small ⇒ synthetic trace: offset_i = Σ (par_moves of the band's typical level × 4 s + 120 s session gap), randomized ±30% by `PRNG(hash(raceId, seat))`.
- Ghost progress is computed server-side from `joinedAt + offset_i` ⇒ deterministic; clients render it.
- Ghosts are labelled with toy-railway names ("Conductor Pip") and a small "practice racer" marker in the info sheet (no pretending to be specific real people).

### 3.5 Backend (Firebase)
| Component | Detail |
|---|---|
| Auth | Firebase Auth anonymous (auto) → optional Google / Apple link ([05 §3](./05_OFFLINE_AND_CLOUD_SYNC.md)) |
| Firestore `races/{raceId}` | `weekKey, tzBucket, band, startUtc, endUtc, createdAt, seats` |
| Firestore `races/{raceId}/members/{uid}` | `displayName, frame, count, lastCountedAt, finishedAt?, isGhost, ghostTraceId?, joinedAt` |
| Rules | Clients **read** their own race doc + members; **no client writes** |
| `joinRace` | Callable; eligibility re-check server-side; returns raceId |
| `submitRaceClear` | Callable `{raceId, level, moves[], durationMs, attemptId, clientUtc}` ⇒ plausibility (§3.6) ⇒ transaction `count += 1` |
| `closeRace` | Scheduled every 15 min: races past `endUtc + 2 h` ⇒ final ranks frozen ⇒ `results` field |
| `claimRaceReward` | Callable; writes ledger ops; marks claimed |

### 3.6 Server-side plausibility validation (`submitRaceClear`)
Rejects (not counted, client shows nothing special) if any check fails:
1. Caller is a member of `raceId`; server time within `[startUtc, endUtc]` (+ offline grace §3.7).
2. `level` > member's last counted level **and** level ≤ `highestCleared` reported via sync + 1 (sequential progress — no skipping).
3. Level not already counted for this member.
4. **Replay check:** `moves[]` replayed by the `puzzle_core` replay validator (compiled `dart compile js`, bundled in the Node Function) from the shipped level JSON ⇒ must end in Win.
5. `durationMs ≥ max(3,000, moves.length × 250)` (human tap floor) and gap between consecutive counted clears ≥ that clear's `durationMs` (no parallel solving).
6. Rate: ≤ 1 accepted clear / 5 s / member; ≤ 60 per race.
7. Same `attemptId` twice ⇒ idempotent no-op.
Rejected counts are logged (`race_reject{reason}`) for tuning; repeated rejects (≥ 5 in a race) ⇒ member flagged, excluded from rewards.

### 3.7 Offline behaviour
- Join **requires** internet. After join, levels can be played offline; each counted clear is queued (`syncQueue` op `raceClear`).
- Queued clears are submitted when online. **Count time = server receive time** (device clock is never trusted for rank). Clears arriving after `endUtc + 2 h` are not counted (normal level progress unaffected).
- HUD offline: shows last known positions + "Offline — progress will sync"; ghosts' positions computed locally from their trace (same formula) so the bar still moves.
- App killed mid-race: no effect; membership is server-side.

### 3.8 Edge cases
| Case | Behaviour |
|---|---|
| Timezone change during race | Window fixed at join (`startUtc/endUtc` stored); HUD shows remaining time from server |
| Player reaches `maxPhase` end mid-race | Can't progress further; keeps count; ranked normally |
| Account linked mid-race | Membership moves with uid (link keeps uid) |
| Two devices same account | Both submit; server dedupes per level |
| Device clock wrong | Irrelevant (server time only) |
| Account deletion | Member doc anonymized (`displayName = "Retired Conductor"`, uid removed) |
| VIP | No race advantage |

### 3.9 UI
Top-of-gameplay mini track (collapsible, never overlaps board):
```
🏁 Star Race  ▸ 22 h left
[🚂You 9]──[🚃Pip 11]──[🚃Ada 7]──[🚃Rio 12]──[🚃Mo 4] ──► 15 🏆
```
Race card on Home: join / progress / claim states. Race results sheet Monday (or first open after close).

## 4. Piggy Bank (પિગી બેંક)

### 4.1 Rules
| Rule | Value |
|---|---|
| Unlock | **L30 clear** (first deposit = first clear of L31) |
| Deposit | **+10 coins per first-clear of a numbered level** into the bank (replays, Daily, Coin Rush = 0) |
| Spendable? | **No** — stored coins can't be used until the bank is bought |
| Cap | **1,000 coins** (= 100 first clears); at cap deposits stop, chip shows "Piggy full!" |
| Break price | **₹49** consumable IAP `piggy_bank_49` |
| Break available | Bank ≥ **350 coins** (game rule: never worth less than Coins S at the same price) |
| After break | Coins added to wallet (server-validated purchase), bank resets to 0 |
| Wallet coins | Unaffected — piggy deposits are **extra**, normal clear coins still go to the wallet |

### 4.2 Value comparison (correct numbers)
| Product | Price | Coins | Coins per ₹ |
|---|---|---|---|
| Coins S | ₹49 | 350 | 7.1 |
| Coins M (Popular) | ₹149 | 1,000 | 6.7 |
| **Piggy Bank (full)** | **₹49** | **1,000** | **20.4** |
| Piggy Bank (at 350 minimum) | ₹49 | 350 | 7.1 |

Full piggy = Coins S ના ભાવે **2.86×** coins, અને Coins M જેટલા coins **₹100 ઓછામાં**. UI copy: "1,000 coins for ₹49 — same coins as Coins M (₹149)". "% off standard rate" જેવા claims **નહીં**.

### 4.3 Purchase flow
1. Piggy sheet (Home piggy icon / win chip when full) ⇒ "Break for ₹49".
2. `in_app_purchase` ⇒ `verifyPurchase` Function validates receipt **and** reads the server-side piggy balance (`users/{uid}.piggy.balance`, kept by sync ops) ⇒ grant = `min(balance, 1000)` ⇒ ledger op `piggyBreak{amount}` (opId = purchase token hash) ⇒ `completePurchase`.
3. Offline: button disabled ("Connect to break the piggy"). Deposits continue offline.
4. Pending / failed purchase ⇒ bank unchanged.

### 4.4 Edge cases
| Case | Behaviour |
|---|---|
| Deposits on two devices offline | Ledger sum, clamped to 1,000 server-side (`piggyDeposit` ops beyond cap ignored) |
| Purchase while sync pending | Function first applies queued deposit ops sent with the request, then computes grant |
| Refund (store) | Coins revoked via ledger op `refund` (wallet may go negative ⇒ §05 negative balance rule) |
| VIP | No change to piggy |
| Under-13 age band | Piggy shown (purchases go through store parental controls); no "limited time" pressure copy |

## 5. Cosmetics Shop — "Liveries & Tables"

Coin sink (standard §6.2: 800–4,000 coins). Coins only, no IAP SKU. **Gameplay-neutral:** liveries keep each train's gameplay colour, pattern and engine icon (colour-blind safety, [Phase 1 06 §1.2](../phase_1/06_UI_UX_SCREENS.md)); they change material, chimney/cab shape, trim, wheels and whistle sound. Table themes keep grid contrast ≥ 3:1 and lane/beam visibility.

| # | Item | Type | Price (coins) | Description |
|---|---|---|---|---|
| 1 | Heritage Steam | Train livery | **800** | Brass domes, spoked wheels, deep-gloss paint |
| 2 | Candy Line | Train livery | **1,200** | Pastel enamel, candy-cane buffers, chime whistle |
| 3 | Bamboo Eco | Train livery | **1,600** | Bamboo-grain cars, leaf-shaped chimney |
| 4 | Midnight Pullman | Train livery | **2,000** | Navy lacquer, gold pinstripe, soft lamp glow |
| 5 | Bullet Express | Train livery | **3,000** | Streamlined nose cones, high-pitch horn |
| 6 | Royal Jubilee | Train livery | **4,000** | Gilded crests, velvet-red trim, brass-band whistle |
| 7 | Snowy Village Table | Table theme | **1,500** | Frosted wood, tiny pine trees on the margin |
| 8 | Seaside Pier Table | Table theme | **2,500** | Weathered planks, gulls, lighthouse corner |
| 9 | Lantern Night Table | Table theme | **4,000** | Dark walnut, paper lanterns (static glow, pre-baked) |
| V | **Conductor's Gold** | Train livery (VIP) | VIP only | Usable **while VIP Conductor Pass is active**; on expiry reverts to the last equipped owned livery; re-subscribing re-enables it |

- Total to buy all 9: 20,600 coins (long-term sink).
- Default (free): "Classic Wood" livery + "Honey Oak" table.
- Preview: tap item ⇒ 3 s demo board with 3 trains departing (no gameplay).
- Equip: one livery + one table at a time; applies to levels, Daily, Coin Rush (Coin Rush golden trains keep gold).
- Purchase = op `cosmeticBuy{itemId, price}` (offline OK; server ledger, [05](./05_OFFLINE_AND_CLOUD_SYNC.md)). Owned set syncs by union; equipped = last write by server timestamp.
- Assets: liveries as sprite atlas variants (WebP), lazy-loaded per equipped item; ≤ 1.5 MB each.

## 6. Economy Summary (Phase 2 additions)

| Source / sink | Amount | Frequency |
|---|---|---|
| Gift Crate (L510–990) | 300 + 1 booster | 49 per phase |
| Grand Central Chest (L1000) | 1,000 + 2 each booster | once |
| Album volume rewards | 250 / 400 / 600 / 600 / 800 | once each |
| Star Race | 50 – 1,000 + boosters | weekly |
| Piggy Bank | up to 1,000 stored | IAP |
| Cosmetics | −800 … −4,000 each (−20,600 all) | optional |

## 7. Analytics (Phase 2 additions to standard §15)
`album_sticker{level, vol}`, `album_volume_complete{vol}`, `race_join{band}`, `race_clear_submit{accepted, reason?}`, `race_reject{reason}`, `race_result{rank, count, ghosts}`, `race_reward_claim{rank}`, `piggy_deposit{balance}`, `piggy_full`, `piggy_offer_view`, `iap_purchase{sku: piggy_bank_49}`, `cosmetic_preview{item}`, `cosmetic_buy{item, price}`, `cosmetic_equip{item}`. Feature impact (D7/D30, payer conversion) measured with Remote Config A/B (feature on vs off cohorts) — no assumed uplift numbers in docs.

## 8. Remote Config Keys (defaults = this doc)
`album_vol_rewards = [250,400,600,600,800]`, `race_enabled = true`, `race_unlock_level = 60`, `race_target = 15`, `race_rewards = {...}`, `race_ghost_fill_min = 10`, `piggy_unlock_level = 30`, `piggy_deposit = 10`, `piggy_cap = 1000`, `piggy_min_break = 350`, `cosmetic_prices = {...}`. Standard-fixed values (piggy price ₹49 store-side, cap 1,000, cosmetic range 800–4,000) are clamped in code.
