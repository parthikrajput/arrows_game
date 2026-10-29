# 04 — LiveOps: Album, Star Race, Honeycomb Bank & Cosmetics (લાઈવ-ઓપ્સ)
Phase 2 ના ચાર LiveOps features — Flora & Fauna Compendium (Sticker Album), Weekly Star Race, Golden Honeycomb Bank (Piggy Bank) અને Cosmetic Shop — ના rules, rewards, backend, offline behaviour અને edge cases.

**Related docs:** [Shared Core Standard §6–§7, §13–§14](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [01 Phase 2 Rules §11](./01_PHASE_2_SCOPE_AND_RULES.md) · [05 Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Boosters, Coins & Shop](../phase_1/04_BOOSTERS_COINS_SHOP.md)

---

## 1. Overview & Unlocks (સારાંશ)

| Feature | Themed name | Unlock | Needs internet? | Economy effect |
|---|---|---|---|---|
| Sticker Album | **Flora & Fauna Compendium** (વનસ્પતિ અને જીવજંતુ સંગ્રહ) | Always (retroactive) | No | Volume complete: 300/400/600/800/1,000 coins + 1 cosmetic (§2.2) |
| Weekly Star Race | **Weekly Star Race** — "Garden Dash" track | `highestCleared ≥ 60` | Yes (join, results) | Coins + boosters (§3.6) |
| Piggy Bank | **Golden Honeycomb Bank** (સોનેરી મધપૂડા બેંક) | L30 clear | Purchase only | IAP ₹49, max 1,000 coins |
| Cosmetic Shop | **Garden Wardrobe** (Shop tab) | L501 (Phase 2 release) | Purchase sync later | Coin sink 800–4,000 |

Level Map પર "honey jar" marker Golden Nectar Rush માટે reserved છે (Phase 1) ⇒ Piggy Bank નો icon **honeycomb** છે, jar નહીં.

## 2. Flora & Fauna Compendium (Sticker Album)

### 2.1 Rules
- **1 sticker per milestone level** (દરેક 10 મો level: L10, L20, …, L1000) — first clear પર, Gift Box / Royal Honey Chest screen સાથે reveal.
- Sticker id = `s<level>` (દા.ત. `s510`). કુલ **100 stickers**, 5 volumes.
- **Retroactive grant:** Phase 2 update પછી પહેલી app open પર `highestCleared` સુધીના બધા milestone stickers (L500 player ⇒ Vol 1–3 = 50 stickers) "Welcome back" album animation સાથે ગ્રાન્ટ; પૂરા થયેલા volumes ના rewards પણ.
- Album = **derived** from progress (`highestCleared`) ⇒ cloud merge પર union (અલગ conflict નહીં). Stored `album.seen[]` માત્ર "new" badge માટે.
- Replay / Daily / Rush volume stickers આપતા નથી (Daily silhouettes અલગ Daily page પર, §2.2a). Stickers વેચાતા નથી, trade નથી.

### 2.2 Volumes

| Vol | Theme | Milestones | Stickers | Sticker examples | Completion reward (coins + 1 cosmetic) |
|---|---|---|---|---|---|
| 1 | **Seedlings & Sprouts** | L10–L100 | **10** | Clover sprout, acorn, dewdrop, seed pod | **300 coins** + "Clover" profile frame |
| 2 | **Meadow Blossoms** | L110–L250 | **15** | Daisy, tulip, sunflower, morning glory | **400 coins** + "Tulip" profile frame |
| 3 | **Busy Bugs** | L260–L500 | **25** | Worker ant, honeybee, ladybug, orb spider (L500 = Queen's Garden Gala) | **600 coins** + "Honeycomb" profile frame |
| 4 | **Pond & Brook** | L510–L750 | **25** | Lily pad, dragonfly, water strider, pond snail | **800 coins** + **Pressed-Flower Ant** skin (album-exclusive) |
| 5 | **Midsummer Royals** | L760–L1000 | **25** | Stag beetle, monarch butterfly, queen bee (L1000 = Jubilee) | **1,000 coins** + **Stained-Glass Bee** skin (album-exclusive) |

- Total 10 + 15 + 25 + 25 + 25 = **100** (= L10…L1000 ના 100 milestones).
- બધા 5 volumes ⇒ title **"Master Naturalist"** (profile + leaderboard nameplate cosmetic).
- Completion rewards = **300 / 400 / 600 / 800 / 1,000 coins + 1 cosmetic** (Standard §6.1, §17.26; Remote Config defaults). Retroactive grant માં coins પણ મળે (server ledger `grant`, idempotent `album:<vol>`).
- Sticker art style: garden illustration cards (milestone stickers volumes 1–5 માં જ; Daily ની સાથે mix નહીં).

### 2.2a Daily page (silhouettes)
- Daily Garden Almanac clear ⇒ એ દિવસનું silhouette ([phase_1/05 §5](../phase_1/05_DAILY_CHALLENGE_AND_STREAK.md): Leaf, Tulip, Honeycomb, Mushroom, Ladybug, Sunflower, Beehive) Compendium ના **અલગ "Daily" page** પર stamp થાય (Standard §17.25).
- **Collection only** — coins/cosmetic reward નહીં, volumes ના 100 stickers માં ગણાતું નથી; volumes milestone-based જ.

### 2.3 UX
- Home → 📖 Compendium button; badge = new stickers count.
- Volume page: 5×5 grid (Vol 1: 2×5, Vol 2: 3×5) silhouette slots; locked slot પર level number ("Clear L370"); tap unlocked ⇒ zoom card + 1-line nature fact (en/gu/hi).
- Reveal: color-fill animation 1.2 s + "stamp" SFX; Reduce Motion ⇒ fade.

### 2.4 Edge cases
| # | Case | Result |
|---|---|---|
| AL-1 | Player skips Gift Box screen (back) | Sticker already granted at win commit; reveal shown in album with "new" |
| AL-2 | Cloud progress merge raises `highestCleared` | Missing stickers + volume rewards granted silently, "new" badges |
| AL-3 | Album-exclusive skin while not owned in shop | Equip-able from Wardrobe "Album" section; never purchasable |
| AL-4 | Phase 3 later | Vol 6+ follow same "1 per milestone" rule (25 per 250 levels) |

## 3. Weekly Star Race

### 3.1 Format
| Rule | Value |
|---|---|
| Cohort | **5 players** (async), real players + ghost fill (§3.3) |
| Window | **Saturday 08:00 → Sunday 23:59 device local time** (≈ 40 h) |
| Goal | **First to clear 15 numbered levels** (first clears only) during window |
| Unlock | `highestCleared ≥ 60` |
| Eligibility | Content remaining: `maxPhaseLastLevel − highestCleared ≥ 15` (નહીં તો "New gardens coming — race paused" card) |
| Join | Home "Star Race" card → Join (needs internet). Join allowed until Sunday 12:00 local |
| Ranking | Levels cleared (desc), then server-accepted time of reaching that count (asc) |
| Counting | Numbered-level **first clears** only (boosters allowed). Daily Garden Almanac, Golden Nectar Rush અને replays ગણાતા નથી |

### 3.2 Time zones
- Join વખતે client `tzOffsetMin` (device) + local window મોકલે; server **server UTC** થી window validate કરે (`startUtc = Sat 08:00 local − offset`, `endUtc = Sun 23:59:59 local − offset`). Join પછી timezone change ignore.
- Cohort matching: same ISO week, `tzOffset` band ±3 h, progress bracket `floor(highestCleared / 100)` ±1.
- Device clock time-travel lock ([phase_1/05](../phase_1/05_DAILY_CHALLENGE_AND_STREAK.md)) active ⇒ race join disabled.

### 3.3 Ghost fill
- Cohort પહેલા join થી **2 h** પછી close થાય (Standard §17.26); ત્યારે 5 ન થયા હોય ⇒ server બાકી slots ghosts થી ભરે.
- Ghost progress = deterministic schedule `PRNG(seed = hash(cohortId, ghostIndex))` sampled from **anonymized historical race completion curves** of the same bracket (no real user data shown).
- Ghosts generated garden names + preset avatars, પણ દરેક ghost row પર **"Practice racer" label** (Standard §17.26) + race info sheet ("i") માં disclosure.
- Ghost rank occupy કરી શકે (player ને 2nd મળે); ghosts rewards લેતા નથી.

### 3.4 Names & child safety
- બધા players **generated names** ("Brave Ladybug 42") + 12 preset avatars — free-text names નથી, chat નથી ⇒ moderation જરૂરી નથી; under-13 માટે પણ safe.
- Under-13 ageBand: race allowed (anonymous Firebase Auth), analytics personalization off.

### 3.5 Backend (Firebase) & plausibility
```
races/{raceId}                          // raceId = "2026-W44"
  rewards, rulesVersion
races/{raceId}/cohorts/{cohortId}
  bracket, tzBand, createdAt, status: open|full|final
races/{raceId}/cohorts/{cohortId}/members/{memberId}
  displayName, avatar, isGhost, count, reachedAt, windowStartUtc, windowEndUtc, claimed
```
| Function | Type | Purpose |
|---|---|---|
| `raceJoin` | callable | eligibility, cohort match/create, returns cohort snapshot |
| `raceSubmit` | via `applyOps` op `race_clear` ([05](./05_OFFLINE_AND_CLOUD_SYNC.md)) | idempotent per `opId`; plausibility checks; increments `count` |
| `raceGhostTick` | scheduled 5 min | advances ghost counts per schedule |
| `raceFinalize` | scheduled 30 min | cohort final when all members' `windowEndUtc + 2 h` passed |
| `raceClaim` | callable | idempotent reward grant via server ledger |

**Plausibility checks** (server, per `race_clear`, Standard §17.26): level = previous race max + 1 (no skipping) · level is a first clear (not in user's cleared set) · `duration_s × 1000 ≥ 250 × moves` (≥ 250 ms per Move) · ≥ **15 s** between race reports · `moves ≥ par_moves` · ≤ 40 race clears per hour · client time within `[windowStartUtc, windowEndUtc]` ± 5 min skew · Firebase App Check token valid. Failed ⇒ clear race માટે ignore (game progress unaffected), `race_reject{reason}` log; 3+ rejects ⇒ member hidden from others ("shadow"). **Top-3 replay check:** finalize પહેલાં top-3 members ના race clears ના uploaded session replays server-side `puzzle_core` replay થી verify; fail ⇒ rank removed.

Firestore rules: members documents readable only by same-cohort members; **all writes via Cloud Functions** (client write deny).

### 3.6 Rewards (claimed after finalize)

| Rank | Reward |
|---|---|
| 1st | **1,000 coins + "Race Champion" profile frame + 3 of each booster** (3 Hint, 3 Undo, 3 Shield, 3 Leaf Blower) |
| 2nd | **500 coins + 2 Leaf Blower + 1 Nectar Glow Hint** |
| 3rd | **250 coins + 1 Queen's Royal Shield** |
| 4th–5th | **50 coins** |

- Reward requires ≥ 1 race clear (0 clears ⇒ no reward). Ghosts ને rewards નથી; ghost rank occupy કરે તો પણ નીચેના real players નો rank બદલાતો નથી સિવાય ranking order.
- Claim: next app open after finalize ⇒ results podium screen → Claim. Unclaimed rewards 14 days રહે.
- Rewards server ledger ops (`grant`) ⇒ double-claim impossible (idempotent `raceClaim:{raceId}:{uid}`).
- "Race Champion" frame એક જ item; ફરી 1st ⇒ counter (×2, ×3…) frame પર.

### 3.7 Offline behaviour
| Situation | Behaviour |
|---|---|
| Offline at join time | Join button disabled "Connect to join" |
| Joined, then offline | Levels રમાય; `race_clear` ops local op-log માં queue; HUD chip "Race: 7 (syncing)" |
| Reconnect during window | Ops flush; server timestamps = receive time ⇒ ranking time = sync time (offline clears count, but rank time is when synced) |
| Reconnect after window end but before finalize (+2 h) | Clears completed **within** window (client time, plausibility ± skew) accepted |
| Reconnect after finalize | Late ops ignored for race; podium shows final result |
| Others' progress offline | Last cached snapshot, "Updated 12 min ago" |

## 4. Golden Honeycomb Bank (Piggy Bank)

| Rule | Value |
|---|---|
| Unlock | **L30 clear** (intro popup on Home) |
| Deposit | **+10 coins per first-clear numbered level** after unlock (Daily, Rush, replays નહીં). Deposit animation Level Complete પર |
| Spendable? | **ના** — bank coins wallet માં નથી; ખરીદો ત્યારે જ wallet માં |
| Cap | **1,000 coins**; full ⇒ deposits stop ("Bank full" honeycomb glow), overflow lost |
| Price | IAP consumable `piggy_bank` **₹49** (Standard §7.2) |
| Purchasable when | Balance ≥ **350** (Remote Config `piggy_min_break`, default 350 = Coins S amount) ⇒ purchase ક્યારેય Coins S કરતાં ઓછું નથી |
| Value (correct comparison) | Full bank 1,000 coins @ ₹49 vs **Coins S 350 @ ₹49** ⇒ same price, ≈ 2.9× coins; vs **Coins M 1,000 @ ₹149** ⇒ same coins, ⅓ price |
| After purchase | Balance → 0, deposits restart |
| Offer surfacing | Bank full ⇒ 1 popup per 72 h max (Remote Config); otherwise Home honeycomb icon only. Never during gameplay/Second Chance |
| Grant amount | **Server-side bank balance** (ledger of deposit ops) at `verifyPurchase` time, not client value |

- Purchase flow: `in_app_purchase` buy → receipt → Cloud Function `verifyPurchase(sku: piggy_bank)` ⇒ ledger `grant` (amount = server bank balance) + `bank_reset` ⇒ client `completePurchase`.
- Offline: deposits local op-log માં (idempotent `bank:<level>`); purchase button offline disabled.
- Pending purchase (store pending) ⇒ bank locked "Purchase pending" until resolved; cancelled ⇒ unlocked.
- Kids (under-13 ageBand): IAP standard store parental controls; offer popup **નહીં** (Home icon only).

## 5. Garden Wardrobe (Cosmetic Shop — coin sink)

### 5.1 Catalog

| SKU | Item | Applies to | Price (coins) |
|---|---|---|---|
| `skin_ant_leafcutter` | **Leafcutter Ant** (પાંદડું ઊંચકતી કીડી) | Ant lines | 800 |
| `skin_bee_bumble` | **Fuzzy Bumblebee** | Bee + canopy lines | 800 |
| `skin_ant_firefly` | **Glowtail Ant** (soft lantern abdomen) | Ant lines | 1,500 |
| `skin_bee_carpenter` | **Violet Carpenter Bee** | Bee + canopy lines | 1,500 |
| `skin_ant_golden` | **Golden Honeypot Ant** | Ant lines | 2,500 |
| `skin_bee_orchid` | **Emerald Orchid Bee** | Bee + canopy lines | 2,500 |
| `theme_autumn` | **Autumn Orchard** board theme | Board, rim, obstacles art | 2,000 |
| `theme_blossom` | **Cherry Blossom Garden** board theme | Board | 3,000 |
| `theme_moonlit` | **Moonlit Meadow** board theme (deep-blue lawn, high-contrast lines) | Board | 4,000 |
| `skin_bee_vip` | **Beekeeper's Royal Bee** | Bee + canopy lines | **VIP-only**: equip-able while Beekeeper VIP Pass active; expire ⇒ previous skin auto-restored |

- બધા prices 800–4,000 (Standard §6.2). Cosmetics **coins થી જ** (IAP direct નહીં).
- Ownership permanent, ledger `spend` op (`cosmetic:<sku>` idempotent) ⇒ cloud synced. Album-exclusive skins (§2.2) Wardrobe ના "Album" section માં.
- Slots: `antSkin`, `beeSkin` (air + canopy બંને), `boardTheme`. Default = "Garden Classic".

### 5.2 Fairness & accessibility rules
- Cosmetics gameplay ને **ક્યારેય** અસર નથી કરતા: hitbox, timing, colors, glyphs યથાવત્. Line `color` હંમેશા abdomen (ant) / band (bee) માં + color-blind glyph.
- Board theme: line colors vs lawn contrast ≥ 3:1 (CI screenshot check), tall-obstacle wing marker દરેક theme માં. Twilight Garden (M040) overlay દરેક theme માં સમાન darkness.
- Preview: 5-s live preview on sample board before buy; "Try on" free.
- Insufficient coins ⇒ "Get coins" mini sheet (Shop coins tab).

## 6. Remote Config Keys (launch defaults)
`race_enabled=true`, `race_unlock_level=60`, `race_target=15`, `race_cohort_size=5`, `race_cohort_close_h=2`, `race_min_ms_per_move=250`, `race_min_report_gap_s=15`, `race_join_cutoff_local="Sun 12:00"`, `race_max_clears_per_hour=40`, `piggy_unlock_level=30`, `piggy_deposit=10`, `piggy_cap=1000`, `piggy_min_break=350`, `piggy_popup_cooldown_h=72`, `album_enabled=true`, `album_vol_coins=[300,400,600,800,1000]`, `wardrobe_enabled=true`. Economy numbers બદલવા હોય તો પહેલાં Standard.

## 7. Analytics Events (Phase 2 additions)
`album_sticker{level, volume}`, `album_volume_complete{volume}`, `race_join{raceId, bracket}`, `race_clear{raceId, count, offline}`, `race_reject{reason}`, `race_result{rank, ghosts}`, `race_claim{rank}`, `piggy_deposit{balance}`, `piggy_offer{balance, trigger}`, `piggy_purchase{balance}`, `cosmetic_preview{sku}`, `cosmetic_purchase{sku, price}`, `cosmetic_equip{sku, slot}`. Child ageBand ⇒ personalization off (Phase 1 rule).

## 8. LiveOps Edge Cases

| # | Case | Result |
|---|---|---|
| LO-1 | Race 15th clear on L1000 (Finale) | Counts; reward screens order unchanged, race chip after Phase Complete |
| LO-2 | Two devices same account during race | Server op idempotency; count = unique first-clear levels |
| LO-3 | Player reaches 15 but plausibility rejects one | Count stays 14 until another valid clear |
| LO-4 | Bank full and player clears more levels | No deposit, Level Complete chip "Bank full" |
| LO-5 | Bank purchase while cloud has higher balance (other device) | Server balance granted (source of truth) |
| LO-6 | VIP expires while Royal Bee equipped | Previous bee skin restored at next app start / expiry check |
| LO-7 | Cosmetic bought offline on two devices (same coins) | Server ledger ops both applied; balance floor 0 rule ([05 §5](./05_OFFLINE_AND_CLOUD_SYNC.md)) |
