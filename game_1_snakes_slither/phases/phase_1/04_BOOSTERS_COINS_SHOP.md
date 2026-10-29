# 04 — Boosters, Coins & Shop
> 4 themed boosters + free preview, Heart Berry Refill, coins inflow/outflow, Jungle Gift Basket, Golden Slither Rush, Lucky Lily Wheel, Shop catalog, ads rules અને compliance.

**Related docs:** [Phase 1 index](./README.md) · [Shared Core Standard §3–§7](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [02 Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [06 Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

બધા numbers = launch defaults (Firebase Remote Config, §13). Standard થી અલગ number લખવો નહીં.

---

## 1. Overview
| Item | Summary |
|---|---|
| Boosters | 3: Glow Firefly Hint, Safety Shell Shield, Magic Stone Hammer |
| Free tool | Tongue-Flick Preview (long-press) |
| Not a booster | Heart Berry Refill (માત્ર Second Chance) |
| Currency | 1 soft currency: Coins (gold leaf coins). Premium currency નથી |
| Sinks | Boosters, Heart Berry Refill, Streak Saver; Phase 2 cosmetics |
| IAP | Coin packs, Starter Pack, VIP No-Ads Pass (subscription) |

## 2. Boosters
| Themed booster | Generic | Icon | Effect | Unlock | Cap / attempt | Single | 3-Pack |
|---|---|---|---|---|---|---|---|
| **Glow Firefly Hint** | Hint | 🪲✨ | Solver મુજબ આગલો સાચો Move (snake અથવા lever/lilypad વગેરે) glow. Move નથી | L3 (tutorial, 3 free) | 3 | 60 | **150** |
| **Safety Shell Shield** | Shield | 🐚 | Activate થી current attempt માં આગલા **2** heart-loss events absorb. Attempt પૂરો ⇒ બાકી charge lapse. એક સમયે 1 | L15 (1 free) | 1 | 80 | **200** |
| **Magic Stone Hammer** | Hammer | 🔨 | 1 snake (exit ગણાય) **અથવા** 1 `hammerable: true` obstacle remove. Grumpy Mongoose / Hedge Border / cages-locks hammerable નથી | L25 (1 free) | 2 | 100 | **250** |

Booster use = Move નથી ⇒ move-based counters tick નથી થતા. Boosters stars ને અસર નથી કરતા.

### 2.1 Glow Firefly Hint (Hint)
- Tap ⇒ firefly booster button થી ઉડીને target પર બેસે; target snake (અથવા interactive obstacle) gold glow + pulsing ring. Two-Headed Hydra ⇒ સાચો half glow.
- Glow આગલા Move સુધી રહે (આગલા Move સુધી). Player બીજો Move કરે તો પણ Hint consume થયેલો ગણાય.
- **Source:** player state level `solution` ના prefix પર ⇒ `solution[next]`. નહીં તો on-device solver (isolate, 50 ms budget, node limit 50k).
- Solver fail/timeout ⇒ toast "Try Restart" — **Hint consume નહીં**.
- Glow active હોય ત્યારે ફરી Hint tap ⇒ ignore (double spend નહીં).
- Cap 3/attempt; cap પછી button grey + "3/3".

### 2.3 Safety Shell Shield (Shield)
- Tap ⇒ shell HUD hearts પર ગોઠવાય, badge "2". Heart-loss event (bump, Restless Caterpillar timeout) ⇒ charge −1, heart બચે, `sfx_shell_clink`.
- 0 charges ⇒ shell fades. Attempt end (win/fail/restart) ⇒ lapse.
- Cap 1/attempt ⇒ એક attempt માં વધુમાં વધુ 1 Shield (2 events). Absorbed events ★ ગણતરીમાં "heart lost" નથી.

### 2.4 Magic Stone Hammer (Hammer)
- Tap ⇒ **target mode:** board dim, valid targets (visible snakes + `hammerable: true` obstacles) outline glow. Target tap ⇒ smash animation (`sfx_hammer_smash`, stone sparkles) ⇒ remove. Cancel (Hammer button ફરી / back) ⇒ consume નહીં.
- Snake hammer ⇒ exit ગણાય (keys, frost, mongoose HP, spawn વગેરે triggers); lane-based triggers (gems, food, termite HP, bridge) નહીં — [03 §2.3](./03_OBSTACLE_CATALOG_PHASE_1.md#23-hammer-rules-all-mechanics).
- Jungle Gems બાકી હોય ત્યારે છેલ્લો snake hammer નહીં (toast).
- Hammer use irreversible છે (standard §16.23).
- Cap 2/attempt.

### 2.5 Tongue-Flick Preview (free Path Preview)
Long-press ≥ 350 ms ⇒ dotted lane (green clear / red blocked). Free, unlimited, Move નથી. Booster bar માં નથી; FTUE L5 tutorial. વિગત: [01 §5.8](./01_GAME_CONCEPT_AND_RULES.md#58-tongue-flick-preview-free-path-preview).

## 3. Booster Bar & Mini Shop Sheet
- Gameplay bottom: 3 round buttons (Hint · Shield · Hammer), inventory count badge. Locked ⇒ grey + lock + "L15"/"L25".
- Count 0 ⇒ tap ⇒ **mini shop sheet** (bottom sheet, game pause): Single price, 3-Pack price, coins balance, "Get coins" (⇒ Shop Coins tab), "Watch ad +50 coins" (5/day બાકી હોય તો).
- Cap reached ⇒ button dim + "3/3" / "1/1" / "2/2"; tap ⇒ tooltip "Limit for this try".
- Animation દરમિયાન buttons disabled.

## 4. Heart Berry Refill (Heart Refill)
| Rule | Value |
|---|---|
| Where | **માત્ર Second Chance popup** (booster inventory માં નથી, Shop માં વેચાતું નથી) |
| Price | **120 coins** ⇒ +1 Heart |
| Limit | **Attempt દીઠ max 2** |
| Coins < 120 | Button ⇒ mini shop (coins tab), popup countdown pause |
| Stars | વાપર્યું ⇒ ★ |
| Rewarded alternative | Ad revive +1 Heart, level number દીઠ 1 (`adReviveUsed[level]`) |

## 5. Coins Economy
### 5.1 Inflow
| Source | Coins | Notes |
|---|---|---|
| Level first clear | Easy **15** / Normal **20** / Hard **30** / Finale **50** | `tag` પ્રમાણે. Replay = 0 |
| First ★★★ on a level | **+20** | Level દીઠ એક વાર (replay થી પહેલી વાર ★★★ પણ ચાલે) |
| 2X Win (rewarded ad) | base clear coins ×2 | Star bonus double નહીં. Replay પર 2X button નથી (base 0) |
| Jungle Gift Basket (L10, L20 … L490) | 150 / 180 / 210 / 250 / 300 + 1 booster | §6 |
| Jungle Treasure Chest (L500) | **1,000** + 2 of each booster + badge | Gift Basket ની જગ્યાએ |
| Golden Slither Rush (after L25, 50, 75 …, first clear only) | **10/snake**, 20–30 snakes (tier table §7), full clear **+100** ⇒ max 300–400 | §7 |
| Daily Jungle Puzzle clear | **+100** | દિવસ દીઠ 1 |
| 7-Day Jungle Streak | Ladder (week 1,150 coins + boosters) | [05 §6](./05_DAILY_CHALLENGE_AND_STREAK.md#6-7-day-jungle-streak-ladder) |
| Lucky Lily Wheel | §10 | 1 free + 1 ad / day |
| Shop free coins (rewarded) | **+50** | **max 5/day** |

### 5.2 Outflow (Sinks)
| Sink | Coins |
|---|---|
| Boosters | §2 table (singles 40–100, 3-packs 100–250) |
| Heart Berry Refill | 120 |
| Streak Saver Leaf | 200 (અથવા rewarded ad) |
| Cosmetic skins / board themes | Phase 2 (800–4,000) |

### 5.3 Starting Wallet & Free Grants
| When | Grant |
|---|---|
| First launch | 200 coins |
| L3 tutorial | 3 Glow Firefly Hint |
| L15 tutorial | 1 Safety Shell Shield |
| L25 tutorial | 1 Magic Stone Hammer |

### 5.4 Balance Sanity
સરેરાશ ~60–70 coins/level (clear + star + Gift Basket/Rush share) ⇒ 1 Hint ≈ 1 level, 1 Hammer ≈ 1.5 levels. Boosters "earnable but valuable".

Example (T1 block, first clears, ★★★ દરેક): 8×20 + 15 + 30 (clear) + 10×20 (star) + 150 (basket) = 555 ⇒ ≈ 55/level; Rush share (+~30/level when present) ⇒ ≈ 60–70.

## 6. Jungle Gift Basket (Milestone Gift Box) & Treasure Chest
| Levels (x0) | Coins | Booster |
|---|---|---|
| L10–100 | 150 | `(L/10) mod 3` → 1 = Hint, 2 = Hammer, 0 = Shield |
| L110–200 | 180 | same rotation |
| L210–300 | 210 | same rotation |
| L310–400 | 250 | same rotation |
| L410–490 | 300 | same rotation |
| L500 | **Jungle Treasure Chest:** 1,000 + 2 Hint + 2 Shield + 2 Hammer + Phase 1 "Garden Hero" badge | — |

- Rotation: L10 Hint, L20 Hammer, L30 Shield, L40 Hint, L50 Hammer, L60 Shield, … (full list [02 §7](./02_LEVEL_PROGRESSION_0001_0500.md#7-block-table--levels-1500-all-50-blocks)).
- Locked booster (દા.ત. L20 Hammer, Hammer unlock L25) ⇒ inventory માં જમા થાય, button unlock પછી વાપરી શકાય.
- Show: Level Complete પછી basket shake ⇒ tap ⇒ coins fly to wallet. First clear only. Interstitial defer.

## 7. Golden Slither Rush (Coin Rush)
| Rule | Value |
|---|---|
| Trigger | L25, 50, 75, … 500 **first clear** પછી (20 rounds in Phase 1) |
| Type | Bonus round, **level number નથી**, puzzle નથી |
| Timer | **30 s** wall-clock (game નો એકમાત્ર timer). 3-2-1 "Go!" પછી શરૂ |
| Board | Golden snakes only, no obstacles, no hearts. Snakes per tier (standard §16.9/§16.33, formula નહીં): **T1 (L25–100) 20 · T2 (L125–200) 22 · T3 (L225–300) 25 · T4 (L325–400) 28 · T5 (L425–500) / Phase 2 30** |
| Generation | `seed = hash(gameId, "rush", L)`, reverse construction ⇒ હંમેશા પૂરું clear શક્ય |
| Tap | Clear ⇒ exit (fast 200 ms slither), **+10 coins**. Blocked ⇒ soft wobble only (no heart, no coins; animation ~300 ms સમય જાય) — standard §16.25 |
| Full clear bonus | 30 s પહેલાં બધા snakes ⇒ **+100** |
| Max | 20 snakes ⇒ 300 · 30 snakes ⇒ 400 |
| Boosters | Disabled |
| Pause | App background ⇒ timer pause, resume પર 3-2-1. "Skip" button ⇒ collected coins રહે (standard §16.22) |
| Ads | Rush પછી interstitial **ક્યારેય નહીં**; તે win નું interstitial defer |

**Insertion order:**
```
Level Complete (L%25==0, first clear)
  └─ x0 level? (L50, L100, …) ─► Jungle Gift Basket first
  └─► Golden Slither Rush intro card [Start] (small "Skip" ⇒ confirm "Skip the coins?")
       └─► 30 s round ─► Rush Results (coins, +100 badge) ─► Next level / Map
(no interstitial anywhere in this chain; `winsSinceInterstitial` counter keeps the win, ad deferred to next eligible win)
```
- App kill/crash Rush પહેલાં ⇒ `rushPendingLevel` save ⇒ Level Map પર golden banner "Your Rush is waiting!" ⇒ resume.

## 8. Shop
### 8.1 Layout
3 tabs: **Boosters · Coins · Offers**. Header: coins balance + VIP badge. Footer: "Restore purchases" link (iOS required), terms/privacy. Wireframe: [06 Shop](./06_UI_UX_SCREENS.md#515-shop).

### 8.2 Boosters Tab (coins)
| Item | Price |
|---|---|
| 1 × Glow Firefly Hint | 60 |
| 3 × Glow Firefly Hint | 150 |
| 1 × Safety Shell Shield | 80 |
| 3 × Safety Shell Shield | 200 |
| 1 × Magic Stone Hammer | 100 |
| 3 × Magic Stone Hammer | 250 |
| **Free coins** (rewarded ad) | +50 coins, 5/day (counter "3 left today") |

Locked boosters (unlock level પહેલાં) Shop માં "Unlocks at L15/L25" — ખરીદી disabled.

### 8.3 Coins Tab (IAP, `in_app_purchase`, consumable)
| SKU | Price (India) | Coins | Badge |
|---|---|---|---|
| `coins_s` | ₹49 | 350 | — |
| `coins_m` | ₹149 | 1,000 | Popular |
| `coins_l` | ₹299 | 2,200 | — |
| `coins_xl` | ₹699 | 5,500 | Best Value |

Prices store-localized (`ProductDetails.price` બતાવો; hard-coded ₹ નહીં).

### 8.4 Offers Tab
| SKU | Type | Price | Content | Rule |
|---|---|---|---|---|
| `starter_pack` | One-time (non-consumable flagged consumed once) | ₹79 | 800 coins + 3 Hint + 2 Hammer + 2 Shield | L15 clear પછી **48 h** window; Home popup એક વાર; ખરીદી અથવા window પૂરો ⇒ hide |
| `vip_monthly` | Auto-renewing subscription, 1 month | **₹20/month** | Active હોય ત્યાં સુધી interstitial + banner બંધ. Rewarded ads optional રહે | Expire ⇒ ads પાછી ("કાયમી" નહીં). Manage subscription link (store) |

### 8.5 Purchase Flow
1. Tap ⇒ store sheet. 2. Purchase stream ⇒ `verifyPurchase` (Firebase Cloud Function, server-side receipt validation). 3. Valid ⇒ grant + `completePurchase`. 4. Invalid ⇒ no grant, error toast. 5. Offline/pending ⇒ "Purchase pending" + retry on next app start (purchase stream replay).
- VIP: `vipActiveUntil` = validated expiry; app start પર re-validate (offline ⇒ cached until expiry + 72 h grace).
- Restore purchases (Settings + Shop footer): VIP + Starter Pack ownership restore.

## 9. Ads Rules
### 9.1 Interstitial
| Rule | Value |
|---|---|
| Cadence | દર **5 numbered-level wins** પર 1 (replays સહિત) |
| L1–10 | **ક્યારેય નહીં**. Counter `winsSinceInterstitial` માત્ર L ≥ 11 ના wins ગણે ⇒ પહેલું eligible = **L15 win** |
| Cooldown | છેલ્લા full-screen ad (interstitial કે rewarded) પછી **min 120 s** |
| Defer | Win screen પર Gift Basket / Golden Slither Rush / Treasure Chest ⇒ defer ⇒ આગલી eligible win |
| Never after | Fail, Daily Jungle Puzzle, Golden Slither Rush |
| Daily cap | 20 |
| Persist | `ads.winsSinceInterstitial`, `ads.lastFullscreenUtc` |
| VIP | Active ⇒ ક્યારેય નહીં |
| Placement | Level Complete ⇒ "Next" tap પછી, next level load પહેલાં |

```dart
class AdsState {
  const AdsState({
    required this.vipActive,
    required this.winsSinceInterstitial,
    required this.lastFullscreenUtc,
    required this.interstitialsToday,
    required this.interstitialLoaded,
  });
  final bool vipActive;
  final int winsSinceInterstitial;
  final DateTime lastFullscreenUtc;
  final int interstitialsToday;
  final bool interstitialLoaded;
}

class WinContext {
  const WinContext({
    required this.level,
    this.isDaily = false,
    this.isRush = false,
    this.hasGiftBasket = false,
    this.hasRush = false,
    this.hasChest = false,
  });
  final int level;
  final bool isDaily;
  final bool isRush;
  final bool hasGiftBasket;
  final bool hasRush;
  final bool hasChest;
}

bool shouldShowInterstitial(AdsState s, WinContext w, DateTime now) {
  if (s.vipActive) return false;
  if (w.level <= 10 || w.isDaily || w.isRush) return false;
  if (w.hasGiftBasket || w.hasRush || w.hasChest) return false; // defer; counter kept
  if (s.winsSinceInterstitial < 5) return false;
  if (now.difference(s.lastFullscreenUtc).inSeconds < 120) return false;
  if (s.interstitialsToday >= 20) return false;
  return s.interstitialLoaded;
}
```
Counter increment: દરેક numbered win (L ≥ 11) પર +1; show થાય ત્યારે 0. Deferred win counter માં રહે.

### 9.2 Rewarded (opt-in only)
| Placement | Reward | Limit |
|---|---|---|
| 2X Win | base clear coins ×2 | First clear wins |
| Second Chance revive | +1 Heart | Level number દીઠ 1 |
| Shop free coins | +50 | 5/day |
| Lucky Lily Wheel extra spin | 1 spin | 1/day |
| Streak Saver Leaf | Streak બચાવે | 7-day cycle દીઠ 1 |

Reward માત્ર `onUserEarnedReward` callback પર. Ad unavailable ⇒ button disabled + "Ad unavailable".

### 9.3 Banner
- Adaptive anchored banner: **Home, Level Map**, અને gameplay bottom **L11 થી**.
- Gameplay: booster bar નીચે ≥ 8 dp gap + divider (accidental-click policy). Board/buttons ને ક્યારેય overlap નહીં; banner height layout માં reserve (board fit તેની ઉપર).
- Popups, Shop, Rush, Daily result પર banner hide.

### 9.4 Preload & Failures
App start (consent પછી) rewarded + interstitial preload; show પછી તરત reload. Load fail ⇒ exponential backoff (2 s, 8 s, 32 s) max 3 retries/session.

## 10. Lucky Lily Wheel (Lucky Spin)
- **Unlock:** L10 clear પછી (પહેલા Gift Basket પછી; standard §16.32 — first launch નહીં). Home પર lily wheel icon.
- 1 free spin/day (`dayKey`) + 1 extra via rewarded ad (max 2/day). Time-travel lock ⇒ disabled ([05 §8](./05_DAILY_CHALLENGE_AND_STREAK.md#8-day-key--anti-cheat)).
- Result = `PRNG(seed = hash(installId, dayKey, spinIndex))` (xoshiro128**), server-free.

| Segment | Prize | Probability |
|---|---|---|
| 1 | 20 coins | 30% |
| 2 | 50 coins | 25% |
| 3 | 100 coins | 15% |
| 4 | 75 coins | 12% |
| 5 | 1 Glow Firefly Hint | 10% |
| 6 | 1 Safety Shell Shield | 5% |
| 7 | 1 Magic Stone Hammer | 2.5% |
| 8 | 500 coins (Golden Lily Jackpot) | 0.5% |

- Odds wheel પર "i" button અને Settings → "Spin odds" માં ફરજિયાત (store policy). Visual segment size equal; text odds સ્પષ્ટ.
- No purchase of spins (no real-money gambling).

## 11. Compliance (target age 10–50 ⇒ mixed audience)
| Rule | Implementation |
|---|---|
| Neutral age gate | First launch: birth year picker (no default suggesting age). Saved `settings.ageBand` |
| Under-13 | `tagForChildDirectedTreatment: true`, non-personalized ads, `maxAdContentRating: G`, analytics personalization off (`setAnalyticsCollectionEnabled` on, ad personalization signals off) |
| Families policy | Families Self-Certified Ads SDK only (AdMob); no personal data from children |
| UMP consent (EEA/UK) | App start, ads load પહેલાં; Settings → "Privacy choices" થી ફરી |
| Spin odds | §10 disclosure |
| Purchases | Platform parental controls; under-13 ⇒ Starter Pack popup auto-show નહીં (Shop માં જ દેખાય) |
| Subscription | Clear price/period/renewal text, manage/cancel link, Restore |

## 12. Economy Analytics
`booster_use{type, level}`, `revive{type: ad|coins, level}`, `ad_show{format, placement}`, `iap_purchase{sku}` (standard §15) + game events `coins_earn{source, amount}`, `coins_spend{sink, amount}`, `gift_open{level}`, `rush_end{level, snakes, coins, full_clear}`, `spin_result{segment, via}` ([07 §10](./07_FRONTEND_IMPLEMENTATION_AND_QA.md#10-analytics-events)).

## 13. Remote Config Keys (launch defaults)
| Key | Default |
|---|---|
| `price_hint_1` / `price_hint_3` | 60 / 150 |
| `price_shield_1` / `price_shield_3` | 80 / 200 |
| `price_hammer_1` / `price_hammer_3` | 100 / 250 |
| `heart_refill_price` / `heart_refill_max_per_attempt` | 120 / 2 |
| `coins_clear_easy/normal/hard/finale` | 15 / 20 / 30 / 50 |
| `coins_first_3star` | 20 |
| `gift_coins_tiers` | [150, 180, 210, 250, 300] |
| `chest_coins` | 1000 |
| `rush_seconds` / `rush_coins_per_snake` / `rush_full_clear_bonus` | 30 / 10 / 100 |
| `rush_snakes_by_tier` (T1…T5/Phase 2) | [20, 22, 25, 28, 30] |
| `daily_clear_coins` | 100 |
| `shop_ad_coins` / `shop_ad_daily_max` | 50 / 5 |
| `interstitial_every_wins` / `interstitial_cooldown_s` / `interstitial_daily_cap` / `interstitial_min_level` | 5 / 120 / 20 / 11 |
| `streak_saver_coins` | 200 |
| `vip_sku` / `starter_window_h` | `vip_monthly` / 48 |
