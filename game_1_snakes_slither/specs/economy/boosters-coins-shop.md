Source docs: phase_1/04_BOOSTERS_COINS_SHOP.md, ../../SHARED_CORE_STANDARD.md

# Spec: Boosters, Coins Economy, Shop and Monetization

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 1 economy, power-ups, coin sources and sinks, milestone gift baskets, Golden Slither Rush bonus round, Lucky Lily Wheel, in-app shop, AdMob integration, and compliance gates.

## Current State
Design documented in phase_1/04_BOOSTERS_COINS_SHOP.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 3 standard boosters: Glow Firefly Hint, Safety Shell Shield, Magic Stone Hammer, plus free Tongue-Flick Preview.
- Single soft currency: gold leaf Coins. Starting balance is 200 coins.
- Heart Berry Refill available exclusively inside Second Chance popup for 120 coins (max 2/attempt).
- Interstitial ads shown once every 5 numbered-level wins (never in L1–10; first eligible at L15 win; min 120s cooldown; daily cap 20).
- VIP No-Ads Pass at ₹20/month auto-renewing subscription removes banner and interstitial ads.

## Proposed Change
Implement the wallet, shop, boosters, ads, and IAP services:

### 1. Boosters
| Booster | Unlock Level | Per-Attempt Cap | Single Price | 3-Pack Price | In-Game Effect |
|---|---|---|---|---|---|
| **Glow Firefly Hint** | L3 (3 free granted) | 3 | 60 coins | **150 coins** | Firefly flies to highlight the next optimal move from solver prefix or on-device solver (50 ms / 50k nodes cap). Does not count as a Move. Does not consume if solver fails ("Try Restart" toast). |
| **Safety Shell Shield** | L15 (1 free granted) | 1 | 80 coins | **200 coins** | Absorbs the next 2 heart-loss events in the current attempt. Charges lapse when attempt finishes. Only 1 active per attempt. Absorbed hits do not degrade ★ rating. |
| **Magic Stone Hammer** | L25 (1 free granted) | 2 | 100 coins | **250 coins** | Target mode allows player to tap 1 snake (counts as exit) or 1 hammerable obstacle to destroy it. Irreversible action. Cannot target Guardian, Hedge Border, or locks. Disabled on last snake if gems remain. |

- **Tongue-Flick Preview:** Free tool, unlocked in FTUE L5. Long-press >= 350 ms shows green/red dotted lane.
- **Heart Berry Refill:** Costs 120 coins for +1 Heart. Maximum 2 per attempt. Sold only within Second Chance popup (not in booster bar, not in shop).
- Booster bar: 3 buttons (Hint, Shield, Hammer) with inventory badges; tapping at count 0 opens mini shop sheet.

### 2. Coins Economy
#### Inflow
- Level first clear: Easy **15**, Normal **20**, Hard **30**, Phase Finale **50** coins. Replays award 0 coins.
- First ★★★ on a level: **+20 coins** (one-time bonus per level).
- 2X Win: Rewarded ad doubles base clear coins (star bonus is not doubled). Replay has no 2X button.
- Jungle Gift Basket (x0 milestones L10, L20... L490):
  - L10–100: **150 coins**
  - L110–200: **180 coins**
  - L210–300: **210 coins**
  - L310–400: **250 coins**
  - L410–490: **300 coins**
  - Plus 1 booster rotating via `(L/10) mod 3`: 1 = Hint, 2 = Hammer, 0 = Shield.
- Jungle Treasure Chest (L500): **1,000 coins** + 2 Hint + 2 Shield + 2 Hammer + "Garden Hero" badge.
- Golden Slither Rush (bonus rounds): 10 coins per snake + 100 full clear bonus (max 300–400 coins).
- Daily Jungle Puzzle clear: **+100 coins** (once per local day).
- 7-Day Jungle Streak: Weekly ladder awarding 1,150 coins + boosters.
- Lucky Lily Wheel: Free daily spin with weighted coin and booster prizes.
- Shop Free Coins: Rewarded ad granting **+50 coins**, max 5 times per day.

#### Outflow (Sinks)
- Boosters (singles 60/80/100, 3-packs 150/200/250).
- Heart Berry Refill (120 coins).
- Streak Saver Leaf (200 coins).

### 3. Golden Slither Rush (Coin Rush)
- Triggers on first clear of L25, 50, 75... 500 (20 rounds in Phase 1).
- 30-second wall-clock timer (the only real-time timer in the game).
- Golden snakes only; no obstacles, no hearts. Tapping blocked golden snakes causes a soft wobble with no heart loss.
- Snakes per tier: T1 20 snakes, T2 22 snakes, T3 25 snakes, T4 28 snakes, T5 30 snakes.
- 10 coins per snake exited; +100 bonus coins if all snakes cleared before 30s expires.
- If L50/100/etc. is cleared: Jungle Gift Basket is presented first, then Golden Slither Rush follows. No interstitial ad between or after.

### 4. Lucky Lily Wheel
- Unlocked after Level 10 clear (first Gift Basket).
- 1 free spin per day + 1 rewarded ad spin per day (max 2 spins/day).
- Deterministic result: `PRNG(hash(installId, dayKey, spinIndex))`.
- 8 Segments: 20 coins (30%), 50 coins (25%), 75 coins (12%), 100 coins (15%), 1 Hint (10%), 1 Shield (5%), 1 Hammer (2.5%), 500 coins Jackpot (0.5%).
- Odds must be explicitly viewable via "i" info icon and in Settings.

### 5. Shop & In-App Purchases
- **Boosters Tab:** Single and 3-pack purchases using in-game coins. Free +50 coins tile via rewarded ad (5/day).
- **Coins Tab (IAP Consumables via `in_app_purchase`):**
  - Coins S: ₹49 for 350 coins.
  - Coins M (Popular): ₹149 for 1,000 coins.
  - Coins L: ₹299 for 2,200 coins.
  - Coins XL (Best Value): ₹699 for 5,500 coins.
- **Offers Tab:**
  - Starter Pack (One-time): ₹79 for 800 coins + 3 Hint + 2 Hammer + 2 Shield. Offered for 48 hours after clearing L15.
  - VIP No-Ads Pass: ₹20/month auto-renewing subscription. Removes all banner and interstitial ads while active. Rewarded ads remain optional.
- Server-side receipt validation via Firebase Cloud Function `verifyPurchase`.
- "Restore purchases" button in Settings and Shop footer restores VIP and Starter Pack.

### 6. Ad Integration & Policies (AdMob)
- **Interstitial Ads:**
  - Cadence: Exactly once every 5 numbered-level wins (replays included).
  - Levels 1–10: Strictly 0 interstitials. Win counter begins at L11; first eligible win is L15.
  - Minimum 120-second cooldown since last full-screen ad (interstitial or rewarded).
  - Defer rule: Deferred if Level Complete triggers Gift Basket, Golden Slither Rush, or Treasure Chest.
  - Never shown after Level Failed, Daily Puzzle, or Golden Slither Rush.
  - Daily cap: 20 interstitials.
- **Rewarded Ads (Opt-in only):**
  - 2X Win reward.
  - Second Chance revive (+1 Heart, once per level number, save key `adReviveUsed[level]`).
  - Shop free coins (+50 coins, 5/day).
  - Lucky Lily Wheel extra spin (1/day).
  - Streak Saver Leaf (1 per 7-day cycle).
- **Adaptive Anchored Banner:**
  - Displayed on Home, Level Map, and Gameplay from Level 11 onwards.
  - Gameplay placement: Below booster bar with >= 8 dp gap and visual divider. Layout height is strictly reserved to avoid board jumps.

### 7. Compliance & Neutral Age Gate
- First launch presents neutral birth year picker.
- If under 13: `tagForChildDirectedTreatment: true`, non-personalized ads, max ad content rating G, analytics ad personalization disabled. Google Play Families policy certified.
- UMP consent form presented in EEA/UK regions prior to loading ads.

## Affected Files
- `apps/snakes_slither/lib/features/shop/bloc/shop_bloc.dart` (to be created)
- `apps/snakes_slither/lib/features/shop/view/shop_page.dart` (to be created)
- `apps/snakes_slither/lib/features/spin/cubit/spin_cubit.dart` (to be created)
- `apps/snakes_slither/lib/features/rush/bloc/rush_bloc.dart` (to be created)
- `apps/snakes_slither/lib/services/ads_service.dart` (to be created)
- `apps/snakes_slither/lib/services/iap_service.dart` (to be created)
- `functions/src/verify_purchase.ts` (to be created)

## Risks
- Handling IAP network interruptions: purchase tokens must be safely queued and verified upon next app boot without granting double currency.
- Store subscription compliance: VIP pass renewal terms, cancel links, and price per month must be explicitly stated.

## Open Questions
- In `phase_1/04 §8.2`, an older draft table and wireframe referenced an obsolete 4th booster ("Snake Charmer Flute" at 40/100 coins). SHARED_CORE_STANDARD §5 governs: exactly 3 boosters (Hint 60/150, Shield 80/200, Hammer 100/250) + free preview.
- Net revenue from ₹20/month subscription after GST and 15% Play Store cut is ~₹14; pricing will be monitored via Remote Config.
