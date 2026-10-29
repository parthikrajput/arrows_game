Source docs: phase_1/04_BOOSTERS_COINS_SHOP.md, ../../SHARED_CORE_STANDARD.md

# Spec: Boosters, Coins Economy, Shop and Monetization

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 1 economy, power-ups, coin sources and sinks, Craft Basket milestone rewards, Golden Bobbin Rush bonus round, Spinning Wheel, in-app shop, AdMob integration, and compliance gates for Yarn Unravel.

## Current State
Design documented in phase_1/04_BOOSTERS_COINS_SHOP.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 3 standard boosters: Needle Glow Hint, Thimble Shield, Golden Scissors, plus free Thread Peek tool.
- Single soft currency: Coins (represented with wool-ball coin art). Starting balance is 200 coins.
- Heart Refill available exclusively inside Second Chance popup for 120 coins (max 2/attempt).
- Interstitial ads shown once every 5 numbered-level wins (never in L1–10; first eligible at L15 win; min 120s cooldown; daily cap 20).
- VIP No-Ads Pass at ₹20/month auto-renewing subscription removes banner and interstitial ads.

## Proposed Change
Implement the wallet, shop, boosters, ads, and IAP services:

### 1. Boosters & In-Game Tools
| Booster | Unlock Level | Per-Attempt Cap | Single Price | 3-Pack Price | In-Game Effect |
|---|---|---|---|---|---|
| **Needle Glow Hint** | L3 (3 free granted) | 3 | 60 coins | **150 coins** | Highlights the next optimal move from solver prefix or on-device solver (isolate, 50 ms / 50k nodes cap). Does not count as a Move. If solver fails, displays "Try Restart" toast and does not consume booster. |
| **Thimble Shield** | L15 (1 free granted) | 1 | 80 coins | **200 coins** | Absorbs the next 2 heart-loss events in the current attempt. Charges lapse when attempt finishes. Only 1 active per attempt. Absorbed hits do not degrade star ratings. |
| **Golden Scissors** | L25 (1 free granted) | 2 | 100 coins | **250 coins** | Target mode allows player to tap 1 thread (counts as exit) or 1 hammerable obstacle to destroy it. Irreversible action. Cannot target Guardian, clasps, or hem walls. Disabled on last thread if Sequins remain. |
| **Thread Peek** | L4 (tutorial) | Unlimited | Free | — | Free path preview tool. Long-press >= 350 ms shows green (clear) or red (blocked) chain-stitch dotted lane. Not a booster; does not count as a Move. |

- **Heart Refill:** Costs 120 coins for +1 Heart. Maximum 2 per attempt. Sold only within "Tangled Up!" Second Chance popup (not in booster bar, not in shop).
- **Booster Bar:** 3 buttons (Hint, Shield, Hammer) with inventory badges; tapping at count 0 opens mini shop sheet. At attempt cap, button displays grey disabled state (e.g. "3/3 used").

### 2. Coins Economy
#### Inflow (Sources)
- **Level First Clear:** Easy **15**, Normal **20**, Hard **30**, Phase Finale **50** coins. Replays award 0 coins.
- **First ★★★ on a Level:** **+20 coins** (one-time bonus per level).
- **2X Win:** Rewarded ad doubles base clear coins (star bonus is not doubled). Replay has no 2X button.
- **Craft Basket (Gift Box, x0 milestones L10, L20... L490):**
  - Levels 10–100: **150 coins**
  - Levels 110–200: **180 coins**
  - Levels 210–300: **210 coins**
  - Levels 310–400: **250 coins**
  - Levels 410–490: **300 coins**
  - Plus 1 rotating booster via formula `(Level / 10) mod 3`: `1 = Hint, 2 = Hammer, 0 = Shield`.
- **Grand Sewing Chest (Level 500):** **1,000 coins** + 2 Hints + 2 Shields + 2 Hammers + Phase 1 Master Badge.
- **Golden Bobbin Rush (Bonus Rounds):** Inserted after first clear of L25, 50, 75... 500. Awards 10 coins per unraveled thread + 100 full clear bonus (max 300–400 coins).
- **Daily Stitch Clear:** **+100 coins** (once per local day).
- **7-Day Stitch Streak:** Weekly ladder awarding 1,150 coins + boosters.
- **Spinning Wheel (Lucky Spin):** Unlocks after L10 clear; 1 free daily spin + 1 rewarded ad spin.
- **Shop Free Coins:** Rewarded ad granting **+50 coins**, max 5 times per day.
- **Starting Wallet:** **200 coins** + 3 Hints + 1 Shield + 1 Hammer (granted during respective tutorials).

#### Outflow (Sinks)
- Booster purchases: singles (60 / 80 / 100 coins), 3-packs (150 / 200 / 250 coins).
- Heart Refill in Second Chance: 120 coins.
- Darning Patch (Streak Saver): 200 coins.

### 3. Golden Bobbin Rush (Coin Rush Mode)
- **Trigger:** First clear of Levels 25, 50, 75, 100 ... 500. Replays do not trigger it.
- **Gameplay:** 30-second rapid unspooling bonus round. Purl appears cheering.
- **Rules:** Infinite hearts (no fail state). Threads unspool instantly on tap.
- **Thread Counts:** T1: 20 threads, T2: 22, T3: 25, T4: 28, T5: 30 threads.
- **Rewards:** 10 coins per thread pulled + 100 coin bonus if all threads are unspooled within 30 seconds.
- Interstitial ads are NEVER shown after Coin Rush.

### 4. Spinning Wheel (Lucky Spin)
- **Unlock:** Automatically unlocks on Home screen after Level 10 clear.
- **Cadence:** 1 free spin every 24 hours (tracked via `lastSpinUtc`). 1 extra spin available by watching a rewarded ad.
- **Odds Disclosure (Visible via Info Icon):**
  - 100 Coins: 35%
  - 1 Needle Glow Hint: 25%
  - 150 Coins: 18%
  - 1 Thimble Shield: 12%
  - 1 Golden Scissors: 8%
  - Jackpot (300 Coins + 1 of each booster): 2%
- Deterministic PRNG using server time or trusted monotonic clock.

### 5. Shop & In-App Purchases
- **Coin Bundles:**
  - Small Spool: 500 Coins — ₹49 ($0.99)
  - Craft Basket: 1,200 Coins — ₹99 ($1.99)
  - Sewing Trunk: 3,500 Coins — ₹249 ($4.99)
- **Starter Pack (Special Offer):**
  - Unlocks at Level 15 clear; available for 48 hours.
  - Contains: 800 Coins + 3 Hints + 2 Shields + 2 Hammers — ₹49 ($0.99). One-time purchase.
- **VIP No-Ads Pass:**
  - ₹20/month auto-renewing subscription ($0.99/mo).
  - Benefits: Permanent removal of banner and interstitial ads while active; exclusive purple VIP profile frame; 1 free daily booster claim.
  - Restored via standard StoreKit / Google Play Billing restore flows.
  - Cloud Function `verifyPurchase` verifies receipts before unlocking items.

### 6. Ad Integration & Policy Compliance
- **Interstitial Ads:**
  - Cadence: Shown on every 5th numbered-level win (`winsSinceInterstitial % 5 == 0`).
  - Restrictions: NEVER shown in Levels 1–10. First eligible win is Level 15.
  - Cooldown: Minimum 120 seconds between impressions.
  - Daily cap: Maximum 20 interstitials per day.
  - Deferral: Defer to next eligible win if completed level features a Craft Basket, Coin Rush, or Daily Challenge.
- **Banner Ads:** Displayed at bottom of Home, Map, and Gameplay screens (from Level 11 onward). Suppressed during tutorials and for active VIP subscribers.
- **Compliance Rules:**
  - Neutral Age Gate displayed on fresh install; players under 13 receive non-personalized ads via Google UMP without behavioral tracking.
  - Google Play Families policy compliant.

## Affected Files
- `apps/yarn_unravel/lib/features/game/bloc/wallet_cubit.dart` (to be created)
- `apps/yarn_unravel/lib/features/shop/bloc/shop_bloc.dart` (to be created)
- `apps/yarn_unravel/lib/features/shop/view/shop_view.dart` (to be created)
- `apps/yarn_unravel/lib/features/spin/view/spinning_wheel_dialog.dart` (to be created)
- `apps/yarn_unravel/lib/features/rewards/view/craft_basket_dialog.dart` (to be created)
- `apps/yarn_unravel/lib/features/rewards/view/coin_rush_view.dart` (to be created)
- `apps/yarn_unravel/lib/services/ads_service.dart` (to be created)
- `apps/yarn_unravel/lib/services/iap_service.dart` (to be created)

## Risks
- Interstitial ad timers must persist across app pause/resume cycles to enforce the 120-second cooldown strictly.
- Purchase receipt validation must fail gracefully offline with local pending transaction queues.

## Open Questions
- None. Pricing, booster caps, and ad limits strictly follow SHARED_CORE_STANDARD.md §5–§7.

