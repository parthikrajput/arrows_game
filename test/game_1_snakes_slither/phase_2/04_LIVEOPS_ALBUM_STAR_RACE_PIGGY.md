# 04 — LiveOps: Sticker Album, Weekly Star Race, Piggy Bank, Cosmetics
> Phase 2 ના ચાર LiveOps features ના exact rules, rewards, backend, offline behaviour અને edge cases: Jungle Sticker Album, Weekly Star Race, Piggy Bank અને Cosmetics Shop (Style tab).

**Related docs:** [Phase 2 index](./README.md) · [Shared Core Standard §6–§8, §13–§14](../../SHARED_CORE_STANDARD.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [05 Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Boosters & Shop](../phase_1/04_BOOSTERS_COINS_SHOP.md) · [Phase 1 Daily & Streak](../phase_1/05_DAILY_CHALLENGE_AND_STREAK.md)

બધા numbers launch defaults (Remote Config). Standard માં નક્કી થયેલા values (Piggy ₹49 / cap 1,000, cosmetics 800–4,000) બદલવા નહીં; standard માં ન હોય તેવા LiveOps reward values આ game ના defaults છે (§7).

---

## 1. Overview
| Feature | Unlock | Needs internet? | Server-authoritative part |
|---|---|---|---|
| Jungle Sticker Album | Update પછી તરત | ના (offline grant, sync later) | Volume reward coins (ledger, once per account) |
| Weekly Star Race | `highestCleared ≥ 60` | Join + result માટે હા; રમવા offline ચાલે (§3.8) | Cohort, ranking, rewards |
| Piggy Bank | L30 clear | Purchase માટે હા | Piggy balance + purchase grant |
| Cosmetics Shop (Style) | Update પછી તરત | ના (purchase coins થી; sync later) | Ownership (ledger) |

## 2. Jungle Sticker Album
### 2.1 Rules
1. **1 sticker per milestone level** = દરેક 10th level (L10, L20, … L1000) ની **first clear**.
2. 5 volumes, કુલ 100 stickers:

| Volume | Theme | Levels | Stickers | Completion reward |
|---|---|---|---|---|
| Vol 1 | Garden Friends | L10–100 | 10 | 250 coins + **Fern Frame** (profile frame) |
| Vol 2 | Bamboo & Orchard | L110–250 | 15 | 400 coins + **Bamboo Stripe** snake skin |
| Vol 3 | Swamp & Moonlit Jungle | L260–500 | 25 | 600 coins + **Moonlit Pond** board theme |
| Vol 4 | Waterfalls & Treetops | L510–750 | 25 | 800 coins + **Treetop Feather** snake skin |
| Vol 5 | Ruins, Crystals & Sun Temple | L760–1000 | 25 | 1,000 coins + **Sun Temple Gold** board theme + **Album Master** frame |

3. Volume-completion cosmetics **album-exclusive** (Shop માં વેચાતા નથી). Coins = server ledger (semantic key `album:vol{n}`) ⇒ એક account દીઠ એક જ વાર.
4. Sticker = collectible art only; gameplay effect નથી.

### 2.2 Sticker List
| Vol | Level → sticker (in order) |
|---|---|
| 1 | L10 Pip · L20 Ladybug · L30 Garden Snail · L40 Blue Butterfly · L50 Tree Frog · L60 Honeybee · L70 Dragonfly · L80 Burrow Bunny · L90 Hedgehog · L100 Grandpa Tortoise |
| 2 | L110 Panda Cub · L120 Bamboo Shoot · L130 Red Panda · L140 Mango · L150 Parrot · L160 Lotus · L170 Kingfisher · L180 Monkey · L190 Banana Bunch · L200 Peacock · L210 Jackfruit · L220 Sunbird · L230 Squirrel · L240 Orchid · L250 Hornbill |
| 3 | L260 Firefly · L270 Lily Frog · L280 Heron · L290 Water Lily · L300 Pond Turtle · L310 Smiling Crocodile · L320 Catfish · L330 Otter · L340 Toad · L350 Reed Warbler · L360 Swamp Mushroom · L370 Owl · L380 Fruit Bat · L390 Luna Moth · L400 Slow Loris · L410 Glow Mushroom · L420 Night Jasmine · L430 Gecko · L440 Leopard Cub · L450 Porcupine · L460 Moonflower · L470 Civet · L480 Tarsier · L490 Firefly Lantern · L500 Mongoose King |
| 4 | L510 Rainbow Falls · L520 River Stone · L530 Rolling Coconut · L540 Fern Curl · L550 Sunbeam · L560 Toucan · L570 Gibbon · L580 Flying Squirrel · L590 Orchid Mantis · L600 Tree House · L610 Rope Bridge · L620 Picnic Basket · L630 Honey Pot · L640 Sloth · L650 Hummingbird · L660 Morpho Butterfly · L670 Canopy Nest · L680 Snail Trail · L690 Treetop Lantern · L700 Dew Bubble · L710 Wind Totem · L720 Rainbow Lorikeet · L730 Golden Langur · L740 Temple Steps · L750 Treetop Village Gate |
| 5 | L760 Ancient Arch · L770 Stone Elephant · L780 Puffball · L790 Whirlwind Leaf · L800 Bamboo Cage Twins · L810 Copycat Snake · L820 River Raft · L830 Mossy Slab · L840 Sunbeam Crystal · L850 Sunflower · L860 Dewdrop Leaf · L870 Sap Drop · L880 Burr Ball · L890 Crystal Lotus · L900 Toadstool · L910 Great Stump · L920 Bead Millipede · L930 Fork-Tail Lizard · L940 Berry Bowl · L950 Rainbow Hedge · L960 Shadow Snake · L970 Bamboo Dominoes · L980 Prowling Mongoose · L990 Sun Disc · L1000 Mongoose Emperor |

Sticker id = `stk_{level}` (દા.ત. `stk_510`). Art manifest: `assets/album/stk_{level}.webp` (512×512, ~40 KB each).

### 2.3 Grant Moment (reward screen order)
- x0 level first clear ⇒ sticker stamp **Jungle Gift Basket reveal screen નો ભાગ** (basket ખૂલ્યા પછી sticker "stamp" 600 ms) — અલગ step નથી ⇒ standard order (Gift → Rush) અને interstitial defer rule યથાવત.
- L500 / L1000 ⇒ sticker **Jungle Treasure Chest reveal** માં (standard §16.20: Chest → Rush → Phase Complete).
- Replay ⇒ sticker નહીં (પહેલેથી છે).

### 2.4 Retroactive Grant (Phase 2 update)
1. Phase 2 build ની પહેલી launch પર: `for L in 10, 20, …, highestCleared (step 10)` ⇒ sticker grant (local, no animation).
2. Home પર એક summary popup: "You've already earned 37 stickers! 🦋" ⇒ "Open Album".
3. પૂરા થયેલા volumes ⇒ Album screen પર **"Claim"** button (auto-credit નહીં, જેથી player reward જુએ). Claim ⇒ coins ledger op `album:vol{n}` + cosmetic unlock.
4. Multi-device: semantic key ⇒ server પર એક જ વાર credit; બીજો device "Already claimed" (cosmetic owned sync થાય).

### 2.5 Daily Silhouettes Page (bonus page)
- Standard §8.1 ના 7 Daily silhouettes (Butterfly, Leaf, Turtle, Cloud, Snake Egg, Mango, Sun) એક અલગ page: તે weekday ની **Daily Jungle Puzzle clear** ⇒ તે silhouette sticker.
- Completion (7/7) ⇒ **Weekday Wanderer** frame (cosmetic only, coins નહીં).
- Retroactive: Phase 1 save ના `ext.daily.starsByDay` (dayKey ⇒ weekday) માંથી.

### 2.6 UX
- Home ⇒ Album book icon (badge = unclaimed volumes). Album: volume tabs, 5×5 grid (Vol 1: 2×5), locked stickers = silhouette + level number ("Clear L540").
- Tap sticker ⇒ zoom card + 1-line fun fact (localized).
- Sound: `sfx_stamp_thump` on grant.

### 2.7 Edge Cases
| # | Case | Behaviour |
|---|---|---|
| AL-1 | Milestone first clear offline | Sticker local grant; sync op `sticker:{level}` (idempotent) |
| AL-2 | Two devices clear L540 | Union ⇒ 1 sticker; Vol reward once (semantic key) |
| AL-3 | Volume complete on device A, claimed on B | A પર "Claimed" (server state pull પછી) |
| AL-4 | `maxPhase = 1` | Vol 4–5 tabs "Coming soon" દેખાય, stickers locked |
| AL-5 | Account deleted | Album local reset (deletion flow [05 §10](./05_OFFLINE_AND_CLOUD_SYNC.md#10-account-deletion)) |

## 3. Weekly Star Race
### 3.1 Rules Summary
| Rule | Value |
|---|---|
| Format | **5-player async cohort**, "First to clear **15 numbered levels**" |
| Window | **Saturday 08:00 → Sunday 23:59 local** (≈ 40 h) |
| Unlock | `highestCleared ≥ 60` |
| Counting | Join પછી થયેલી **numbered level first clears** (નવા levels) જ. Replays, Daily, Golden Slither Rush ગણાતા નથી |
| Entry requirement | Online at join; `maxLevel − highestCleared ≥ 15` (content cap પહેલાં 15 levels બાકી) |
| Fill | Real players + ghost fill (historical runs) — lobby wait **0** |
| Backend | Firebase Auth (anonymous ચાલે), Firestore, Cloud Functions |
| Boosters / hearts | Normal game rules; race માટે કોઈ ખાસ booster નહીં |

### 3.2 Schedule & Timezone
- Window player ના **join વખતના** UTC offset થી: `start = Sat 08:00 local`, `end = Sun 23:59:59 local` ⇒ server UTC માં store (`windowStartUtc`, `windowEndUtc`).
- Cohort members **same UTC offset bucket** (15-min granularity) માંથી જ ⇒ બધાની window એકસરખી.
- Mid-race timezone change ⇒ window join વખતની જ (બદલાતી નથી).
- Join cutoff: **Sunday 12:00 local** (પછી "Next race Saturday 08:00").
- `weekKey` = Saturday ની local date `YYYY-MM-DD` (join offset મુજબ).

### 3.3 Eligibility & Join Flow
1. Saturday 08:00 પછી Home પર "🏁 Star Race" banner (eligible હોય તો).
2. Tap ⇒ race intro (rules, rewards, "Join") ⇒ callable `raceJoin({weekKey, tzOffsetMin, highestCleared})`.
3. Server: eligibility check ⇒ open cohort શોધે (same `weekKey`, offset bucket, `highestCleared` band ±150, created < 30 min, members < 5) ⇒ add; ન મળે ⇒ new cohort. **Join પછી 10 min** માં real members ન ભરાય તો બાકી slots ghosts થી (§3.5); cohort UI તરત 5 racers બતાવે (pending slots = "Finding racer…" 10 min સુધી, પછી ghost).
4. Response: `cohortId`, members, `windowEndUtc`, `startLevel = highestCleared + 1`, `serverNowUtc`.
5. Player એક `weekKey` માં એક જ cohort (re-join ⇒ same cohort).

### 3.4 Progress Counting
- Race level k = join પછી first-cleared numbered level. Target = 15.
- દરેક clear ⇒ op `race_clear{weekKey, level, moves, durationMs, monoElapsedMs, attemptCount}` op-log માં ([05 §6](./05_OFFLINE_AND_CLOUD_SYNC.md#6-op-log-idempotent-operations)) ⇒ `raceProgress` callable.
- HUD (Level Map + Level Complete): mini race track `[You 9/15] [Mossy Toad 11/15] …`, cohort snapshot Firestore listener થી (online).

### 3.5 Ghost Fill (Historical Runs)
- **Ghost pool:** પાછલી races ના real finished/unfinished runs, anonymized: `{band, perLevelOffsetsMin[15], finished}` (user id, name નહીં). Collection `ghostPool/{band}/runs/{runId}`; band = `startLevel` / 100.
- Selection: `PRNG(xoshiro128**, seed = hash(cohortId, slotIndex))` ⇒ same band માંથી run pick (deterministic, server-side).
- Playback: ghost progress = run ના offsets cohort ના slot creation time થી replay (window end પછી ગણાતું નથી).
- Display: jungle display name (generated, દા.ત. "Mossy Toad", "Swift Gecko") + **"replay racer" leaf icon** — real player હોવાનો દાવો નહીં (transparent).
- Pool empty for band ⇒ nearest band; બધું empty ⇒ cohort 5 થી ઓછા racers સાથે (ranking same rules).

### 3.6 Ranking & Rewards
1. Finishers (15/15) = server-validated completion time (§3.8) ના ક્રમમાં.
2. Non-finishers = levels cleared desc, પછી last clear time asc.
3. Tie (same ms) ⇒ earlier `raceJoin` time.
4. Ghosts rank માં ગણાય; rewards **real players ને તેમના rank** મુજબ (ghost 1st ⇒ real player 2nd reward).
5. Rewards (Remote Config defaults, ledger op `race:{weekKey}`):

| Rank | Reward |
|---|---|
| 🥇 1st | **1,000 coins + Golden Crown frame + 3 of each booster** (3 Glow Firefly Hint, 3 Coil-Back Undo, 3 Safety Shell Shield, 3 Magic Stone Hammer) |
| 🥈 2nd | **500 coins + 2 Magic Stone Hammer + 1 Glow Firefly Hint** |
| 🥉 3rd | **250 coins + 1 Safety Shell Shield** |
| 4th–5th | **50 coins** |

- Golden Crown frame: permanent cosmetic (પહેલી 1st place પર unlock; પછીની wins ⇒ frame પર crown count).
- 0 levels cleared ⇒ reward નહીં (participation માટે ≥ 1 clear).
- Finalize: scheduled function `raceFinalize` (દર 15 min) ⇒ cohorts where `now > windowEndUtc + 30 min` ⇒ rank, ledger credit, `results` doc. Client next open ⇒ "Race Results" popup (podium) ⇒ "Collect" (ledger પહેલેથી credited; popup માત્ર presentation).
- Early finish: બધા 5 (ghosts સહિત) finish ⇒ finalize તરત (results popup window પહેલાં).

### 3.7 Server Plausibility Validation
`raceProgress` callable દરેક `race_clear` પર:

| Check | Rule | Fail ⇒ |
|---|---|---|
| Window | Estimated completion time ∈ [`joinUtc`, `windowEndUtc`] | Reject (not counted) |
| Sequence | `level` == previous race level + 1 (પહેલો = `startLevel`) અને server `progress.highestCleared` સાથે consistent | Reject |
| Moves | `moves ≥ par_moves(level)` (server copy of `phase_2.json.gz` par) | Flag |
| Duration | `durationMs ≥ max(5,000, par_moves × 250)` (250 ms = min exit animation) | Flag |
| Rate | બે race clears વચ્ચે estimated time diff ≥ previous `durationMs` − 2 s | Flag |
| Budget | Σ durationMs ≤ (estimated now − joinUtc) + 60 s | Flag |
| Idempotency | `opId` already processed ⇒ return previous result | — |

- **Flags:** 1–2 flags ⇒ clear counted, entry `suspicious` (analytics review). **3 flags** ⇒ entry `excluded`: ranking માં રહે નહીં, rewards નહીં; player ને neutral text "Your race results couldn't be verified."
- Full move replay verification (server-side `puzzle_core` on Cloud Run) = future option; Phase 2 plausibility only.
- Leaderboard જેમ: local progress hackable છે ⇒ rewards modest અને coins-only + cosmetics (real money value નહીં).

### 3.8 Offline Behaviour
| Situation | Behaviour |
|---|---|
| Join | **Internet જરૂરી** (cohort). Offline ⇒ banner "Connect to join the race" |
| Joined, પછી offline | Levels રમી શકાય; `race_clear` ops queue. HUD "Offline — progress will sync" + છેલ્લો cached cohort snapshot |
| Estimated time | `estUtc = lastServerUtc + (monotonicNow − monotonicAtLastServerSync)` ([05 §8](./05_OFFLINE_AND_CLOUD_SYNC.md#8-time--server-authority)). Device reboot (monotonic reset) ⇒ `estUtc` unknown ⇒ server **receive time** વાપરે |
| Upload deadline | Queued clears `windowEndUtc + 30 min` સુધીમાં પહોંચે ⇒ counted (estUtc window માં હોય તો). પછી ⇒ not counted (level progress, coins સામાન્ય રીતે ગણાય — માત્ર race નહીં) |
| Results while offline | Ledger server પર; next online sync ⇒ wallet update + results popup |
| Device clock change | Race time device clock પર આધારિત **નથી** (monotonic + server) |

### 3.9 Backend
```
races/{weekKey}/cohorts/{cohortId}
  { tzBucket, band, windowStartUtc, windowEndUtc, createdUtc, status: open|full|final,
    members: [{uid|ghostRunId, displayName, isGhost, joinUtc, cleared, finishUtc, flags, excluded}] }
raceEntries/{weekKey}_{uid}   { cohortId, startLevel, lastLevel, cleared, flags }
ghostPool/{band}/runs/{runId} { perLevelOffsetsMin: [..15], finished, createdWeek }
```
| Function | Type | Purpose |
|---|---|---|
| `raceJoin` | callable | Eligibility, cohort assign, window compute |
| `raceProgress` | callable (via `syncPush` batch) | §3.7 validation, member update |
| `raceFinalize` | scheduled 15 min | Rank, rewards ledger, ghost pool append (anonymized) |

Security rules: client `read` own cohort doc only (members list, display names, counts); writes **માત્ર** functions થી.

### 3.10 UI
- Home banner (Sat–Sun): countdown "Ends in 18 h" (UI text only, puzzle timer નહીં).
- Race screen: 5 lanes jungle track (snake avatars + frames), progress beads 0–15, rewards row.
- Level Complete: avatar 1 notch આગળ + `sfx_race_cheer` (race level હોય તો).
- Under-13: display names generated only (no free text), ghost/real બધાના names generated ⇒ no personal data.

### 3.11 Edge Cases
| # | Case | Behaviour |
|---|---|---|
| SR-1 | Player reaches L1000 / content cap mid-race | Remaining race impossible ⇒ ranks with cleared count (non-finisher rules) |
| SR-2 | Joined Sunday 11:59 | Allowed (cutoff 12:00); ~12 h |
| SR-3 | App uninstall mid-race, re-install + sign-in same account | Cohort state server પર ⇒ ચાલુ |
| SR-4 | Anonymous account, uninstall | Account lost ⇒ race entry orphan (finalize ranks it as is) |
| SR-5 | Level failed / revived | Race ને અસર નહીં (માત્ર clear ગણાય) |
| SR-6 | Hammer/boosters used | Allowed (normal game) |
| SR-7 | Two devices same account | Clears dedupe by `level` (sequence check) |
| SR-8 | VIP / ads | Race flow interstitial rules બદલતો નથી |

## 4. Piggy Bank
### 4.1 Rules
| Rule | Value |
|---|---|
| Unlock | **L30 clear** (Phase 2 update પછી `highestCleared ≥ 30` હોય તો તરત) |
| Deposit | દરેક numbered level **first clear** (unlock પછી) ⇒ **+10 coins piggy માં** (normal clear coins ઉપરાંત). Replay / Daily / Rush ⇒ નહીં |
| Spendable? | **ના** — piggy coins wallet માં નથી, ખરીદ્યા વગર વાપરી શકાય નહીં |
| Cap | **1,000** (100 first clears). Cap પછી deposits અટકે (overflow lost, UI "Piggy is full!") |
| Price | **₹49** consumable IAP `piggy_bank` (store-localized price બતાવો) |
| Buy enabled | Piggy ≥ **350** coins (Coins S value) — તેથી નીચે ખરીદી ક્યારેય Coins S કરતાં ખરાબ નથી |
| After purchase | Piggy coins ⇒ wallet (server ledger), piggy = 0, ફરી ભરાવાનું શરૂ |
| Start balance | 0 (Phase 2 update પર retroactive deposits **નહીં**) |

### 4.2 Value Comparison (accurate)
| Product | Price | Coins | Coins per ₹ |
|---|---|---|---|
| Coins S | ₹49 | 350 | ≈ 7.1 |
| Coins M | ₹149 | 1,000 | ≈ 6.7 |
| **Piggy Bank (full)** | **₹49** | **1,000** | ≈ 20.4 |
| Piggy Bank (minimum buy) | ₹49 | 350 | ≈ 7.1 |

Store copy: "1,000 coins for ₹49 — the same price as 350 coins in the Shop." (ખોટા "% off" claims નહીં; "Coins M = 1,000 for ₹149" સાથે સાચી સરખામણી.)

### 4.3 Purchase Flow
1. Piggy screen ⇒ "Break it! ₹49" (online only; offline ⇒ "Connect to break your piggy").
2. Purchase **પહેલાં** `syncPush` (pending `piggy_deposit` ops) ⇒ server piggy balance = displayed balance.
3. Store purchase ⇒ `verifyPurchase({sku: "piggy_bank", token})` ⇒ server transaction: `grant = min(serverPiggy, 1000)`, ledger `piggy_break:{orderId}` (+grant coins), `serverPiggy = 0`.
4. Client: hammer smash animation + coins fly (`sfx_piggy_smash`), wallet = server snapshot.
5. Verify fail ⇒ no grant, purchase not completed (retry on next start, Phase 1 flow).
6. Purchase pending (slow card) ⇒ piggy "locked" (deposits ચાલુ, breaking disabled) until resolved; grant = balance **at verification**.

### 4.4 UI
- Home: piggy icon with fill meter (0–1,000), glow at ≥ 350.
- Level Complete (first clear): small "+10 🐷" chip.
- Full (1,000) ⇒ Home popup **એક વાર per fill cycle**; under-13 ⇒ auto-popup નહીં (Shop/Home icon માં જ).
- Shop → Offers tab માં Piggy tile.

### 4.5 Edge Cases
| # | Case | Behaviour |
|---|---|---|
| PG-1 | Two devices deposit offline | Ops `piggy_deposit:{level}` semantic key ⇒ level દીઠ એક જ વાર (union) |
| PG-2 | Purchase on device A while B has unsynced deposits | Grant = server balance at verify; B ના deposits પછી sync ⇒ **નવા cycle** માં જમા |
| PG-3 | Refund / chargeback | Store notification ⇒ (Phase 2) analytics flag only; coins revoke નહીં |
| PG-4 | VIP active | Piggy unaffected |
| PG-5 | Restore purchases | Consumable ⇒ restore નહીં (receipt validation idempotent by orderId) |

## 5. Cosmetics Shop (Style Tab)
### 5.1 Rules
- Shop માં નવો **Style** tab (Boosters · Coins · Offers · Style). Coins-only (IAP નહીં) — standard §6.2 coin sink **800–4,000**.
- **Cosmetics gameplay બદલતા નથી:** snake skin = texture overlay + head accessory + exit trail; **colour id અને colour-blind pattern યથાવત** (Flower Gates, Rainbow Parade વગેરે readable રહે). Hit-box, size, animation timings same.
- Skin બધા `snake` paths પર; `caterpillar` skin paths caterpillar body રાખે, માત્ર accessory tint.
- Board theme = board tile art, background, border; mechanic art અને grid contrast (≥ 3:1) યથાવત. Default "Biome" (Phase 1/2 biome tint).
- Golden Slither Rush golden look રાખે (cosmetics લાગુ નહીં).
- Try-on preview (static 5×5 demo board) ખરીદી પહેલાં.

### 5.2 Catalog
| SKU | Type | Name | Price (coins) |
|---|---|---|---|
| `skin_emerald_vine` | Snake skin | Emerald Vine (leafy sleeve + vine trail) | 800 |
| `skin_sunset_stripes` | Snake skin | Sunset Stripes (warm gradient sheen) | 1,200 |
| `skin_mango_swirl` | Snake skin | Mango Swirl (fruit-swirl texture + leaf hat) | 1,600 |
| `skin_moonlight_glow` | Snake skin | Moonlight Glow (soft glow rim + star trail) | 2,000 |
| `skin_rainbow_scales` | Snake skin | Rainbow Scales (iridescent scale sheen) | 3,000 |
| `skin_golden_cobra` | Snake skin | Golden Cobra (gold hood accessory + sparkle trail) | 4,000 |
| `theme_bamboo_mat` | Board theme | Bamboo Mat | 1,500 |
| `theme_lotus_pond` | Board theme | Lotus Pond | 2,500 |
| `theme_starry_garden` | Board theme | Starry Night Garden | 3,500 |
| `skin_royal_peacock` | VIP skin | Royal Peacock (peacock-feather crest + shimmer trail) | — (VIP only) |

Album / race exclusives (Shop માં નથી): Bamboo Stripe, Treetop Feather (skins), Moonlit Pond, Sun Temple Gold (themes), Fern Frame, Album Master, Weekday Wanderer, Golden Crown (frames).

### 5.3 VIP Skin
- **VIP No-Ads Pass active** હોય ત્યાં સુધી Royal Peacock equip કરી શકાય (owned નહીં, entitlement).
- VIP expire ⇒ equipped skin આગલી app start / VIP check પર **default** (અથવા છેલ્લો owned skin) પર પાછો; toast "Royal Peacock returns with VIP".
- Offline VIP grace (Phase 1: expiry + 72 h) દરમિયાન skin ચાલુ.

### 5.4 Purchase, Ownership & Sync
1. Buy ⇒ `WalletCubit.spend("cosmetic", price)` ⇒ op `cosmetic_buy:{sku}` (semantic key ⇒ account દીઠ એક જ વાર spend).
2. Owned set = server ledger ops ની **union**; equipped = **last-write-wins** (server timestamp).
3. Multi-device race (બંને offline ખરીદે) ⇒ server એક જ spend apply કરે, બીજું op `duplicate` ⇒ server snapshot wallet (coins એક વાર કપાય).
4. Coins insufficient ⇒ mini shop sheet (Coins tab).

### 5.5 Edge Cases
| # | Case | Behaviour |
|---|---|---|
| CS-1 | Colour-blind mode + Rainbow Scales | Pattern overlay skin ની ઉપર, bold |
| CS-2 | Reduced motion | Exit trails off (skin texture રહે) |
| CS-3 | Low-tier device | Trails particle count ½ (performance) |
| CS-4 | Theme + Jungle Night (M040) | Night darkening theme ઉપર પણ લાગુ; contrast check |
| CS-5 | Account deleted | Owned cosmetics જાય (local reset) |

## 6. Analytics (LiveOps)
`sticker_grant{level, retro}`, `album_claim{vol}`, `race_join{weekKey, band}`, `race_clear{weekKey, k}`, `race_result{weekKey, rank, finished, ghosts}`, `race_flag{check}`, `piggy_deposit{level, balance}`, `piggy_full{}`, `piggy_break{amount}`, `cosmetic_buy{sku, price}`, `cosmetic_equip{sku}` + standard `iap_purchase{sku}`. Under-13: same events, no user id. KPIs dashboards માં માપવા (participation rate, finish rate, piggy conversion) — target numbers analytics data આવ્યા પછી જ નક્કી કરવા.

## 7. Remote Config Keys (LiveOps)
| Key | Default | Source |
|---|---|---|
| `piggy_cap` / `piggy_per_level` / `piggy_unlock_level` | 1000 / 10 / 30 | Standard §7.2 + brief |
| `piggy_min_buy` | 350 | Game-defined |
| `race_unlock_level` / `race_target_levels` / `race_cohort_size` | 60 / 15 / 5 | Game spec |
| `race_rewards` | `{1: {coins: 1000, frame: "golden_crown", boosters: 3}, 2: {coins: 500, hammer: 2, hint: 1}, 3: {coins: 250, shield: 1}, 4: {coins: 50}, 5: {coins: 50}}` | Game spec |
| `race_join_cutoff_local` | "Sun 12:00" | Game-defined |
| `race_upload_grace_min` / `race_flag_exclude` | 30 / 3 | Game-defined |
| `album_volume_coins` | [250, 400, 600, 800, 1000] | Game-defined |
| `cosmetic_prices` | §5.2 | Standard range 800–4,000 |
