# 04 — Boosters, Coins, Rewards & Shop
> Purpose: 3 themed boosters (+ free Thread Peek), Heart Refill, Coins inflow/outflow, Craft Basket (Gift Box), Golden Bobbin Rush (Coin Rush), Spinning Wheel (Lucky Spin), Shop catalog, IAP/VIP, ads rules અને compliance — બધું standard §5–§7 ના exact numbers સાથે.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§5 Boosters, §6 Coins, §7 Monetization) · [./README.md](./README.md) · [./01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) · [./02_LEVEL_PROGRESSION_0001_0500.md](./02_LEVEL_PROGRESSION_0001_0500.md) · [./06_UI_UX_SCREENS.md](./06_UI_UX_SCREENS.md) · [./07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

> બધા economy values launch defaults છે અને Firebase Remote Config થી tune થઈ શકે (keys §11). Currency નું નામ હંમેશા **Coins** (art: નાનું wool-ball coin).

---

## 1. Boosters (3) + Free Tool

| Themed name (generic) | Icon art | Effect (standard §5) | Unlock | Per-attempt cap | Single | 3-Pack |
|---|---|---|---|---|---|---|
| **Needle Glow Hint** (Hint) | Glowing silver needle 💡 | Solver મુજબ **આગલો સાચો Move** glow કરે (thread અથવા lever/spinner/switch/rotor). Move ગણાતો નથી | L3 (tutorial, 3 free) | **3** | 60 | **150** |
| **Thimble Shield** (Shield) | Brass thimble 🛡️ | Activate કરો ત્યારથી current attempt માં આગલા **2** heart-loss events absorb. Attempt પૂરો ⇒ બાકી charge lapse. એક સમયે 1 Shield | L15 (1 free) | **1** | 80 | **200** |
| **Golden Scissors** (Hammer) | Gold stork scissors 🔨 | કોઈપણ **1 thread** (exit ગણાય) **અથવા** `hammerable: true` obstacle snip કરી remove. Guardian / Clasps / Hem Walls snip ન થાય | L25 (1 free) | **2** | 100 | **250** |
| **Thread Peek** (Path Preview) | Eye-of-needle | Long-press ≥ 350 ms ⇒ lane preview (green/red). **મફત, booster નથી, Move નથી** | L4 tutorial | ∞ | — | — |

### 1.1 Booster detailed rules
- **Needle Glow Hint:** player state solution prefix પર ⇒ next step glow (2 s pulse, પછી subtle glow રહે જ્યાં સુધી Move ન થાય). Prefix પર નથી ⇒ on-device solver (isolate, 50 ms budget, node limit 50k). Solver fail ⇒ toast "Try Restart" અને **Hint consume નહીં**. Glow active હોય ત્યારે ફરી Hint tap ⇒ no-op (consume નહીં).
- **Thimble Shield:** 2 charges; HUD hearts પર thimble icon + "2". Absorbed event = bump અથવા Fraying Thread 0. Absorbed event heart lost **ગણાતું નથી** (stars માં).
- **Golden Scissors:** tap button ⇒ targeting mode (hammerable obstacles + visible threads highlight, rest dim). Cancel = tap button again (consume નહીં). Snip = Move **નહીં** (booster). Thread snip ⇒ non-lane exit effects (key/clasp unlock, Knotted adjacency, Guardian HP, spawns, cage colour count) લાગે; lane effects નહીં (Sequins, Loose Bead food, Tailor's Chalk HP, bridge crossing) — §16.31. Sequins બાકી હોય ત્યારે **છેલ્લા thread** પર Golden Scissors disabled. Wool Fluff નીચેના / upper layer થી ઢંકાયેલા threads target નહીં (§16.8). Snip irreversible છે — ક્યારેય revert કે re-apply થતો નથી (§16.23).
- Booster bar: 3 buttons + count badge; count 0 ⇒ tap ⇒ **mini shop sheet** (single + 3-pack + rewarded "+50 Coins"). Cap reached ⇒ button grey "3/3 used".
- L20 Craft Basket Golden Scissors આપે (L25 unlock પહેલાં) ⇒ inventory માં, button locked "Unlocks at 25".

## 2. Heart Refill (Second Chance only)

| Item | Value |
|---|---|
| Price | **120 Coins** ⇒ +1 Heart |
| Cap | **2 per attempt** |
| Where | માત્ર "Tangled Up!" Second Chance popup માં (booster inventory માં નથી) |
| Ad revive | Rewarded ad ⇒ +1 Heart, **level દીઠ 1 વાર** (`adReviveUsed[level]`, restart થી reset નહીં, clear પછી reset) |
| Stars | કોઈપણ revive / Heart Refill ⇒ ★ |

## 3. Coins Inflow

| Source | Coins | Notes |
|---|---|---|
| Level first clear | Easy **15** / Normal **20** / Hard **30** / Finale **50** | `tag` પ્રમાણે. Replay = 0 |
| First ★★★ on a level | **+20** | level દીઠ એક વાર |
| 2X Win (rewarded ad) | base clear coins ×2 | star bonus double નહીં; first clear પર જ |
| Craft Basket (Gift Box), L10…L490 | L10–100 **150** · L110–200 **180** · L210–300 **210** · L310–400 **250** · L410–490 **300** | + 1 booster: `(L/10) mod 3` ⇒ 1 Hint, 2 Hammer, 0 Shield |
| Grand Sewing Chest (Phase Chest), L500 | **1,000** + 2 each booster + Phase 1 badge | Gift Box ની જગ્યાએ |
| Golden Bobbin Rush (after L25, 50, 75 … first clear only) | **10/thread**; threads per tier T1 20 · T2 22 · T3 25 · T4 28 · T5 30 (§16.9); full clear **+100** ⇒ max 300–400 | bonus round |
| Daily Challenge clear | **+100** | દિવસ દીઠ 1 વાર |
| 7-Day Streak | Day 1–7 ladder (week total 1,150 + boosters) | [05](./05_DAILY_CHALLENGE_AND_STREAK.md) |
| Spinning Wheel (Lucky Spin) | §6 | |
| Shop free Coins (rewarded) | **+50** | **max 5/day** |
| Starting wallet | **200** + 3 Hint + 1 Shield + 1 Hammer | boosters tutorial વખતે |

**Balance sanity (standard):** સરેરાશ ~60–70 Coins/level (clear + star + gift/rush share) ⇒ 1 Hint ≈ 1 level, 1 Golden Scissors ≈ 1.5 levels.

## 4. Coins Outflow (sinks)

| Sink | Coins |
|---|---|
| Needle Glow Hint | 60 / 3-pack 150 |
| Thimble Shield | 80 / 3-pack 200 |
| Golden Scissors | 100 / 3-pack 250 |
| Heart Refill | 120 (max 2/attempt) |
| Darning Patch (Streak Saver) | 200 (or 1 rewarded ad) |
| Phase 2: cosmetic thread skins / board themes | 800–4,000 (Phase 2 only — [../phase_2/README.md](../phase_2/README.md)) |

## 5. Craft Basket (Gift Box) & Golden Bobbin Rush (Coin Rush)

### 5.1 Craft Basket schedule
| Levels | Coins | Booster sequence |
|---|---|---|
| L10, 20 … 100 | 150 | L10 Hint, L20 Hammer, L30 Shield, L40 Hint, L50 Hammer … (repeats every 30) |
| L110 … 200 | 180 | same formula |
| L210 … 300 | 210 | " |
| L310 … 400 | 250 | " |
| L410 … 490 | 300 | " |
| L500 | Grand Sewing Chest 1,000 + 2 each | — |

Presentation: wicker basket bounce ⇒ lid opens ⇒ Coins fly to counter ⇒ booster card. Claim button only (ad multiplier નથી Gift Box પર — standard માં નથી). Purl sticker preview (Phase 2 Album teaser, Phase 1 માં decoration only).

### 5.2 Golden Bobbin Rush rules
| Rule | Value |
|---|---|
| Trigger | L25, 50, 75 … 500 ના **first-clear win** પછી (replay પર નહીં) |
| Order | Win ⇒ Level Complete ⇒ (x0 હોય તો) Craft Basket / Grand Sewing Chest **first** ⇒ Golden Bobbin Rush |
| Board | Golden threads, single-direction lanes, **20–30 threads**: L25–100 = 20 · L125–200 = 22 · L225–300 = 25 · L325–400 = 28 · L425–500 = 30 |
| Timer | **30 s** wall-clock (game નો એકમાત્ર timer) |
| Reward | **10 Coins/thread** pulled + **+100** full clear ⇒ max 300–400 |
| Hearts / boosters | Hearts નથી, boosters disabled. Snag ⇒ માત્ર wobble (heart loss નહીં, §16.25) |
| Generation | Always-solvable simple layout (reverse construction, no obstacles) |
| Skip | "Skip" button allowed — અત્યાર સુધી collected Coins રહે (§16.22); full-clear bonus નહીં. Not a numbered level |
| Ads | Coin Rush પછી interstitial **ક્યારેય નહીં**; win screen પર Rush/Basket હોય ⇒ interstitial defer |
| Background | App background ⇒ timer pause (fairness), resume on return |

## 6. Spinning Wheel (Lucky Spin)

- **Unlock: L10 clear પછી** (§16.32 — FTUE દરમિયાન Home પર button દેખાતું નથી).
- **1 free spin/day** (day key [05 §6](./05_DAILY_CHALLENGE_AND_STREAK.md)) + **1 extra via rewarded ad** (max 2/day).
- Result = `PRNG(seed = hash(installId, dayKey, spinIndex))` (server-free, xoshiro128\*\*).
- Odds Settings → "Spin odds" માં ફરજિયાત બતાવવા.

| Segment | Prize | Probability |
|---|---|---|
| 1 | 20 Coins | 30% |
| 2 | 50 Coins | 25% |
| 3 | 100 Coins | 15% |
| 4 | 75 Coins | 12% |
| 5 | 1 Needle Glow Hint | 10% |
| 6 | 1 Thimble Shield | 5% |
| 7 | 1 Golden Scissors | 2.5% |
| 8 | 500 Coins (Jackpot — golden spool) | 0.5% |

Visual: antique wooden spinning wheel with 8 coloured skeins. Time-travel lock ([05 §7](./05_DAILY_CHALLENGE_AND_STREAK.md)) ⇒ spin disabled.

## 7. Shop

### 7.1 Layout (tabs)
```
┌──────────────────────────────────┐
│ ← Shop                 🪙 1,240  │
│ [Boosters] [Coins] [Offers]      │
├──────────────────────────────────┤
│ ▶ Free 50 Coins (ad)   3/5 left  │
│ ┌────────┐ ┌────────┐            │
│ │ Needle │ │Thimble │  single /  │
│ │ Glow   │ │ Shield │  3-pack    │
│ └────────┘ └────────┘            │
│ ┌────────┐                       │
│ │ Golden │                       │
│ │Scissors│                       │
│ └────────┘                       │
│ VIP No-Ads Pass ₹20/month  [→]   │
│ Restore purchases (iOS)          │
└──────────────────────────────────┘
```
Full screen spec: [06 §20](./06_UI_UX_SCREENS.md).

### 7.2 Catalog — Boosters (Coins)
| Item | Single | 3-Pack | Saving |
|---|---|---|---|
| Needle Glow Hint | 60 | 150 | 30 |
| Thimble Shield | 80 | 200 | 40 |
| Golden Scissors | 100 | 250 | 50 |

### 7.3 Catalog — IAP (`in_app_purchase`)
| SKU | Product | Type | Price (India) | Content |
|---|---|---|---|---|
| `yarn_vip_monthly` | **VIP No-Ads Pass** | Auto-renewing subscription, 1 month | **₹20/month** | Active હોય ત્યાં સુધી interstitial + banner બંધ. Rewarded optional. Expire ⇒ ads પાછી (કાયમી **નથી**) |
| `yarn_coins_s` | Coins S | Consumable | ₹49 | 350 Coins |
| `yarn_coins_m` | Coins M (Popular) | Consumable | ₹149 | 1,000 Coins |
| `yarn_coins_l` | Coins L | Consumable | ₹299 | 2,200 Coins |
| `yarn_coins_xl` | Coins XL (Best Value) | Consumable | ₹699 | 5,500 Coins |
| `yarn_starter_pack` | Starter Pack "Cozy Starter Basket" | One-time (non-consumable flag in save), L15 પછી 48 h | ₹79 | 800 Coins + 3 Hint + 2 Golden Scissors + 2 Thimble Shield |
| — | Piggy Bank | Phase 2 | ₹49 | Phase 2 doc |

- Prices store-localised; ઉપર India launch defaults.
- Receipt: server-side validation via Firebase Cloud Function `verifyPurchase` ⇒ success પછી જ grant. Pending purchase ⇒ "Processing…" + grant on completion.
- **Restore purchases** button Settings (અને iOS Shop) માં — VIP subscription status + Starter Pack flag restore.
- Business note (standard): ₹20 subscription net ≈ ₹14 after GST + store fee; price Remote Config A/B થી test.

### 7.4 VIP paywall copy rules
- "Remove interstitial & banner ads while your pass is active. Renews monthly at ₹20. Cancel anytime in Play Store / App Store." — "forever / permanent" શબ્દો **વાપરવા નહીં**.
- Rewarded ads VIP માં પણ optional રહે (2X Win, revive વગેરે).

## 8. Ads Rules (AdMob, `google_mobile_ads`)

| Format | Rule |
|---|---|
| **Interstitial** | **દર 5 numbered-level wins** પર 1. L1–10 દરમિયાન **ક્યારેય નહીં** (પહેલું eligible: L15 win). Last full-screen ad (interstitial કે rewarded) પછી **min 120 s**. Win પર Craft Basket / Golden Bobbin Rush / Grand Sewing Chest હોય ⇒ **defer** ⇒ આગલી eligible win. Fail, Daily Challenge, Coin Rush પછી ક્યારેય નહીં. `winsSinceInterstitial` persist. Daily cap **20**. VIP active ⇒ none |
| **Rewarded** (opt-in) | 2X Win · Revive (level દીઠ 1) · Shop +50 Coins (5/day) · Spinning Wheel extra (1/day) · Darning Patch (Streak Saver) |
| **Banner** | Adaptive anchored, **માત્ર Home અને Level Map** + gameplay bottom **L11 થી**. Booster bar નીચે ≥ 8 dp gap + divider. Board / buttons ને ક્યારેય overlap નહીં. VIP ⇒ hidden |
| **Preload** | App start પર rewarded + interstitial preload (consent પછી); show પછી તરત reload. Load fail ⇒ exponential backoff, max 3 retries/session |
| Unavailable | Rewarded button disabled + "Ad unavailable" text |

Interstitial counter pseudo-logic:
```
onNumberedLevelWin(level):
  if level <= 10: return
  winsSinceInterstitial++                      // all L11+ wins incl. replays (§16.24)
  if vipActive: return
  if winsSinceInterstitial < 5: return
  if rewardScreenOnThisWin: return            // deferred → next eligible win
  if now - lastFullscreenUtc < 120 s: return  // deferred
  if dailyInterstitials >= 20: return
  show(); winsSinceInterstitial = 0; lastFullscreenUtc = now
```

## 9. Remote Config keys (economy)
`hint_price, hint_pack_price, shield_price, shield_pack_price, hammer_price, hammer_pack_price, heart_refill_price, heart_refill_cap, gift_coins_table, coin_rush_per_thread, coin_rush_clear_bonus, coin_rush_seconds, daily_reward, streak_ladder, spin_odds, shop_free_coins, shop_free_daily_cap, interstitial_every_wins, interstitial_cooldown_s, interstitial_daily_cap, vip_price_test_group`.

## 10. Compliance (target age 10–50 ⇒ mixed audience)
- First launch: **neutral age gate** (birth year picker, no default "adult" value). Under-13 ⇒ `tagForChildDirectedTreatment`, non-personalized ads, max ad content rating **G**, analytics personalization off.
- Google Play **Families policy**: Families Self-Certified Ads SDK only (AdMob OK); બાળકોનો personal data collect નહીં.
- **UMP consent** (EEA/UK) app start પર, ads load પહેલાં.
- Spinning Wheel odds disclosure (Settings → Spin odds); real-money gambling નહીં, Coins cash-out નહીં.
- IAP prices tax-inclusive દેખાડવા; subscription terms + cancel instructions paywall પર.
- Under-13 band: IAP purchase confirmation માં store parental controls પર આધાર; Starter Pack popup auto-show નહીં (Shop માં જ).
