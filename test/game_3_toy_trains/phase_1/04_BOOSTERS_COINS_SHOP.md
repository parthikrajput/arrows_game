# 04 · Boosters, Coins & Shop — Toy Trains: Wooden Railway Puzzle
> હેતુ: 4 themed boosters + free Route Peek, Heart Refill, coin inflow/outflow, Gift Crate schedule, Coin Rush, Lucky Turntable, Shop catalog, ads rules અને compliance — બધા numbers standard ના launch defaults (Remote Config થી tune).

**Related docs:** [Shared Core Standard §3, §5–§7](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [02 Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Boosters (4) + Free Tool

| Booster (themed) | Generic | Icon | Effect | Unlock | Per-attempt cap | Single | 3-Pack |
|---|---|---|---|---|---|---|---|
| **Green Signal Hint** | Hint | 🟢 signal lamp | Solver મુજબ આગલો સાચો Move glow કરે (train, lever, turntable, switch, yard). Move ગણાતો નથી | L3 (tutorial, 3 free) | 3 | 60 | **150** |
| **Reverse Gear Undo** | Undo | ↩️ gear | છેલ્લો 1 Move revert (board + move counters). **Heart પાછું મળતું નથી.** Booster use / revive undo ન થાય | L8 (tutorial, 3 free) | none | 40 | **100** |
| **Cowcatcher Shield** | Shield | 🛡️ cowcatcher | Activate પછી current attempt માં આગલા **2** heart-loss events absorb. Attempt end ⇒ બાકી charge lapse. એક સમયે 1 Shield | L15 (1 free) | 1 | 80 | **200** |
| **Track Crane** | Hammer | 🏗️ crane hook | કોઈપણ **1 train** (exit ગણાય) **અથવા** `hammerable: true` obstacle remove. Guardian / Ticket barrier / Table Edge Fence hammerable નથી | L25 (1 free) | 2 | 100 | **250** |
| **Route Peek** (free) | Path Preview | 👁 | Long-press ≥ 350 ms ⇒ exit lane dotted (લાલ blocked / લીલો clear). Booster નથી, Move નથી | L2 tutorial | ∞ | free | — |

### 1.1 Booster details
- **Green Signal Hint:** green signal lamp ઉપર pop + target pulse 2 s. Player state JSON `solution` prefix પર હોય ⇒ next step; નહીં તો on-device solver (isolate, 50 ms, 50k nodes). Solver fail ⇒ toast "Try Reverse Gear" — Hint **consume નથી**. Hidden (Steam Cloud) કે locked train ક્યારેય glow નથી.
- **Reverse Gear Undo:** history stack (unlimited per attempt). Revert = board, `moveCount`, all counters (Level Crossing N, Steam Pressure, ivy, handcar…), collected Mail Sacks, spawns. **Hearts, Shield charges, booster inventory, revive state revert નથી.** Undo of a bump ⇒ moveCount −1 (heart lost રહે). **Track Crane વાપર્યું ⇒ Undo history clear** (crane ક્યારેય undo / re-apply થતો નથી; crane પહેલાંના Moves પણ undo નહીં — standard §16.23).
- **Cowcatcher Shield:** HUD હૃદય પર cowcatcher overlay + "2" badge. Absorb = bump animation ચાલે, heart સુરક્ષિત, `sfx_shield_ding`. Absorbed event ⇒ stars માટે heart lost ગણાય નહીં.
- **Track Crane:** booster tap ⇒ target mode (valid targets highlight, invalid dim); tap target ⇒ crane hook lifts it off (500 ms, input locked). Train removal = exit: **non-lane** effects trigger (ticket barrier, guardian HP, cloud, thaw, depot spawn, siding colour count, timetable order); **lane** effects નહીં (Mail Sacks, coal, Rock Pile HP, trestle crossing) — standard §16.31. Mail Sacks બાકી હોય ત્યારે **છેલ્લી train** પર crane disabled. Hammerable obstacles: M001, M002, M016, M025, M027 (એક cell), broken M042 (standard §16.18). Not a Move ⇒ counters tick નથી. Use ⇒ Undo history clear. Cancel = booster ફરી tap.
- Booster bar: 4 buttons + count badge; count 0 ⇒ tap ⇒ mini shop sheet (single / 3-pack). Booster use Move animation દરમિયાન disabled.

## 2. Heart Refill & Revive (Second Chance)

| Option | Cost | Limit | Where |
|---|---|---|---|
| Rewarded ad revive | free (ad) | **1 per level** (`adReviveUsed[level]`, restart થી reset નહીં, clear પછી reset) | Second Chance popup only |
| **Heart Refill** | **120 coins** → +1 Heart | **max 2 per attempt** | Second Chance popup only (inventory માં નથી, shop માં નથી) |

Hearts ક્યારેય 3 થી વધુ નહીં. Revive / Refill વાપર્યું ⇒ max ★.

## 3. Coin Inflow (launch defaults)

| Source | Coins | Notes |
|---|---|---|
| Level first clear | Easy **15** / Normal **20** / Hard **30** / Finale **50** | `tag` (standard §16.15, `slot` થી અલગ field): `easy` (slot breather, x5)=15; `normal` (slots intro/practice/ramp/milestone)=20; `hard` (x9)=30; `finale` (L500)=50. Replay = 0 |
| First ★★★ on a level | **+20** | Level દીઠ એક વાર |
| 2X Win (rewarded ad) | base clear coins ×2 | Star bonus double નહીં |
| Conductor's Gift Crate (L10, 20 … 490) | 150 / 180 / 210 / 250 / 300 | + 1 booster (§5) |
| Grand Central Chest (L500) | **1,000** + 2 each booster + phase badge | Gift Crate ની જગ્યાએ |
| Golden Express Coin Rush | **10/train**, trains per tier (T1 20 · T2 22 · T3 25 · T4 28 · T5 30), full clear **+100** ⇒ max 300–400; first clear only | §6 |
| Daily Timetable Run clear | **+100** | દિવસ દીઠ 1 વાર |
| Express Streak | Week total **1,150** + boosters | [05 §4](./05_DAILY_CHALLENGE_AND_STREAK.md) |
| Lucky Turntable | §7 odds | 1 free + 1 ad per day |
| Shop free coins (rewarded) | **+50** | **max 5/day** |

**Starting wallet:** 200 coins + 3 Hint + 3 Undo + 1 Shield + 1 Hammer (દરેક booster એના tutorial વખતે grant).

**Balance sanity:** સરેરાશ ~60–70 coins/level (clear + star + gift/rush share) ⇒ 1 Hint ≈ 1 level, 1 Track Crane ≈ 1.5 levels.

## 4. Coin Outflow (sinks)

| Sink | Price |
|---|---|
| Green Signal Hint | 60 / 3-pack 150 |
| Reverse Gear Undo | 40 / 3-pack 100 |
| Cowcatcher Shield | 80 / 3-pack 200 |
| Track Crane | 100 / 3-pack 250 |
| Heart Refill | 120 (Second Chance only, max 2/attempt) |
| Streak Saver | 200 (or 1 rewarded ad) |
| Phase 2: train liveries / board themes | 800–4,000 (Phase 2 docs) |

## 5. Conductor's Gift Crate Schedule

| Levels | Coins | Booster rule `(L/10) mod 4` |
|---|---|---|
| L10–100 | **150** | 1 = Green Signal Hint · 2 = Track Crane · 3 = Cowcatcher Shield · 0 = Reverse Gear Undo |
| L110–200 | **180** | same |
| L210–300 | **210** | same |
| L310–400 | **250** | same |
| L410–490 | **300** | same |
| L500 | Grand Central Chest: **1,000** + 2 Hint + 2 Undo + 2 Shield + 2 Hammer + "Phase 1 Conductor" badge | — |

Examples: L10 → Hint, L20 → Crane, L30 → Shield, L40 → Undo, L50 → Hint … L490 (49 mod 4 = 1) → Hint. Per-block list: [02 §6](./02_LEVEL_PROGRESSION_0001_0500.md). Gift Crate milestone level ના first clear પર જ મળે (replay = no crate).

## 6. Golden Express Coin Rush

| Rule | Value |
|---|---|
| Trigger | Level **25, 50, 75 … 500** ના **first clear** પછી (20 rushes in Phase 1). Level number નથી, map પર node નથી |
| Order on x0 levels (L50, 100, 150 …) | Level Complete ⇒ **Gift Crate first** ⇒ then Coin Rush. L500: Grand Central Chest ⇒ Coin Rush ⇒ Phase Complete |
| Duration | **30 s** wall-clock (game નો એકમાત્ર timer) |
| Board | Golden sunset playmat, golden trains per tier table (formula નહીં, standard §16.9/§16.33): **T1 20 · T2 22 · T3 25 · T4 28 · T5 30**; no obstacles, no hearts lost on bump (blocked golden train just clacks + wobble, §16.25) |
| Reward | **10 coins per train exited**, all trains cleared ⇒ **+100** ⇒ max 300–400 |
| Boosters / Hint | Disabled |
| Pause / background | Timer pauses on app background; resumes on return |
| Skip | "Skip" button allowed; coins already collected are kept (§16.22) |
| Ads | **No interstitial** after Coin Rush; the triggering level's win interstitial is deferred to the next eligible win |
| Generation | Seeded `hash(gameId, "rush", level)`; layout has no dependency deeper than 2 (fast tapping) |

## 7. Lucky Turntable (Lucky Spin)

1 free spin/day (day key 05 §6) + 1 extra via rewarded ad (**max 2/day**). Unlocks on Home **after L10 clear** (standard §16.32). 8 segments:

| Prize | Probability |
|---|---|
| 20 coins | 30% |
| 50 coins | 25% |
| 100 coins | 15% |
| 1 Reverse Gear Undo | 12% |
| 1 Green Signal Hint | 10% |
| 1 Cowcatcher Shield | 5% |
| 1 Track Crane | 2.5% |
| 500 coins (Jackpot) | 0.5% |

- Odds Settings → "Spin odds" માં બતાવવા ફરજિયાત. No real-money gambling, spins purchasable નથી.
- Result = `PRNG(seed = hash(installId, dayKey, spinIndex))` (xoshiro128**), server-free; wheel animation result પર land થાય. Time-travel lock (05 §6) active ⇒ spin disabled.

## 8. Ads Rules (AdMob, `google_mobile_ads`)

| Format | Rule |
|---|---|
| **Interstitial** | **દર 5 numbered-level wins** પર 1 (`winsSinceInterstitial` persist; counter **L11 થી** ની બધી numbered-level wins ગણે, **replays સહિત** — standard §16.4/§16.24). Levels 1–10 દરમિયાન **ક્યારેય નહીં** (પહેલું eligible: **L15 win**). Last full-screen ad (interstitial કે rewarded) પછી **min 120 s**. Win screen પર Gift Crate / Coin Rush / Grand Central Chest ⇒ **defer** to next eligible win. Fail, Daily Timetable Run, Coin Rush પછી **ક્યારેય નહીં**. Daily cap 20. VIP active ⇒ off |
| **Rewarded** (opt-in) | 2X Win · Revive (1/level) · Shop +50 coins (5/day) · Lucky Turntable extra (1/day) · Streak Saver |
| **Banner** | Adaptive anchored — **Home, Level Map**, અને gameplay bottom **L11 થી**. Booster bar ની નીચે ≥ 8 dp gap + divider. Board/buttons overlap ક્યારેય નહીં. VIP ⇒ off |
| **Preload** | App start પર rewarded + interstitial preload (consent પછી); show પછી તરત reload. Load fail ⇒ exponential backoff, max 3 retries/session |

Interstitial show timing: Level Complete screen close થઈ "Next" tap પછી, next level load પહેલાં — ક્યારેય gameplay વચ્ચે નહીં.

## 9. Shop Layout & Catalog

```
┌──────────────────────────────┐
│ ← Shop            🪙 1,240   │
├──────────────────────────────┤
│ [ STARTER PACK  ₹79  48:00 ] │  (L15+ only, one-time)
│ [ VIP CONDUCTOR PASS ₹20/mo ]│
├─ Boosters ───────────────────┤
│ 🟢 Hint   60 | x3 150        │
│ ↩️ Undo   40 | x3 100        │
│ 🛡️ Shield 80 | x3 200        │
│ 🏗️ Crane 100 | x3 250        │
├─ Coins ──────────────────────┤
│ S 350 ₹49 · M 1,000 ₹149 ★   │
│ L 2,200 ₹299 · XL 5,500 ₹699 │
├─ Free ───────────────────────┤
│ 🎬 +50 coins (3/5 left today)│
├──────────────────────────────┤
│ Restore purchases (iOS)      │
└──────────────────────────────┘
```

| Section | Item | Price | Content |
|---|---|---|---|
| Boosters (coins) | Green Signal Hint | 60 / 3-pack 150 | 1 / 3 Hint |
| | Reverse Gear Undo | 40 / 3-pack 100 | 1 / 3 Undo |
| | Cowcatcher Shield | 80 / 3-pack 200 | 1 / 3 Shield |
| | Track Crane | 100 / 3-pack 250 | 1 / 3 Hammer |
| Coins (IAP consumable) | Coins S | ₹49 | 350 coins |
| | Coins M (Popular) | ₹149 | 1,000 coins |
| | Coins L | ₹299 | 2,200 coins |
| | Coins XL (Best Value) | ₹699 | 5,500 coins |
| Offer (one-time) | **Starter Pack** | ₹79 | 800 coins + 3 Hint + 2 Hammer + 2 Shield. Shown after L15 for 48 h |
| Subscription | **VIP Conductor Pass** (VIP No-Ads Pass) | **₹20/month auto-renewing** | Active હોય ત્યાં સુધી interstitial + banner off; rewarded ads optional રહે. Expire ⇒ ads પાછી ("કાયમી" નહીં) |
| Free | Rewarded +50 coins | ad | max 5/day |
| Phase 2 | Piggy Bank | ₹49 | Phase 2 docs |

- Insufficient coins ⇒ booster button shows coin packs sheet.
- Purchase flow: `in_app_purchase` ⇒ Firebase Function `verifyPurchase` ⇒ grant ⇒ `completePurchase`. Pending ⇒ spinner + "Processing"; failure ⇒ no grant, error toast.
- **Restore purchases** in Settings (and Shop footer on iOS) — restores VIP subscription & Starter Pack flag.
- ⚠️ Business note: ₹20 subscription net ≈ ₹14 (GST + store fee); Remote Config price test.

## 10. Compliance (target age 10–50 ⇒ mixed audience)

- First launch: **neutral age gate** (birth year picker, no default year). Under-13 ⇒ `tagForChildDirectedTreatment`, non-personalized ads, max ad content rating **G**, analytics personalization off.
- Google Play **Families policy**: Families Self-Certified Ads SDK only (AdMob OK); no personal data from children.
- **UMP consent** form (EEA/UK) app start પર, **ads load પહેલાં**.
- Lucky Turntable odds disclosure; no real-money gambling; no loot boxes for money.
- Subscription screen: price, period, auto-renew, cancel instructions, Terms + Privacy links.
