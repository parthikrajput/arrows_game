Source docs: phase_1/04_BOOSTERS_COINS_SHOP.md, ../../SHARED_CORE_STANDARD.md

# Spec: Boosters, Coins Economy, Shop and Monetization (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 1 economy, power-ups, coin sources and sinks, milestone gift crates, Golden Express Coin Rush bonus rounds, Lucky Turntable, in-app shop, AdMob integration, and compliance gates for Toy Trains.

## Current State
Design documented in phase_1/04_BOOSTERS_COINS_SHOP.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 3 railway boosters: Green Signal Hint, Cowcatcher Shield, Track Crane, plus free Route Peek.
- Single soft currency: brass Coins. Starting balance is 200 coins.
- Heart Refill available exclusively inside "Back on Track?" Second Chance popup for 120 coins (max 2/attempt).
- Interstitial ads shown once every 5 numbered-level wins (never in L1–10; first eligible at L15 win; min 120 s cooldown; daily cap 20).
- VIP Conductor Pass at ₹20/month auto-renewing subscription removes banner and interstitial ads.

## Proposed Change
Implement the wallet, shop, boosters, ads, and IAP services:

### 1. Boosters
| Booster | Unlock Level | Per-Attempt Cap | Single Price | 3-Pack Price | In-Game Effect |
|---|---|---|---|---|---|
| **Green Signal Hint** | L3 (3 free granted) | 3 | 60 coins | **150 coins** | Lights green signal lamp above engine and pulses next move from solution prefix or solver (50 ms / 50k nodes cap). Does not count as Move. If solver fails, displays "Try Restart" toast and does not consume booster. |
| **Cowcatcher Shield** | L15 (1 free granted) | 1 | 80 coins | **200 coins** | Cowcatcher overlay on HUD hearts absorbs the next 2 heart-loss events in the current attempt. Charges lapse at attempt end. Absorbed hits do not degrade ★ rating. |
| **Track Crane** | L25 (1 free granted) | 2 | 100 coins | **250 coins** | Target mode: player taps 1 train (departs immediately) or 1 hammerable obstacle to lift and clear it. Irreversible. Disabled on last train if uncollected Mail Sacks remain. Cannot target Guardian (M049), Table Edge Fence (M029), or Ticket Barriers (M004). |

- **Route Peek (Path Preview):** Free tool unlocked in FTUE L2. Long-press >= 350 ms shows dotted trajectory (green = clear, red = buffer clack blocker).
- **Heart Refill:** Costs 120 coins for +1 Heart. Maximum 2 per attempt. Sold only within Second Chance popup (not in booster bar, not in shop).
- **Booster Bar:** 3 buttons (Hint, Shield, Crane) with inventory badges; tapping at count 0 opens mini shop sheet.

### 2. Coins Economy
#### Inflow
- Level first clear: Easy **15**, Normal **20**, Hard **30**, Phase Finale **50** coins. Replays award 0 coins.
- First ★★★ on a level: **+20 coins** (one-time bonus per level).
- 2X Win: Rewarded ad doubles base clear coins (star bonus is not doubled). Replay has no 2X button.
- Conductor's Gift Crate (x0 milestones L10, L20... L490):
  - L10–100: **150 coins**
  - L110–200: **180 coins**
  - L210–300: **210 coins**
  - L310–400: **250 coins**
  - L410–490: **300 coins**
  - Plus 1 booster rotating via `(L/10) mod 3`: 1 = Hint, 2 = Hammer (Track Crane), 0 = Shield.
- Grand Central Chest (L500): **1,000 coins** + 2 Hint + 2 Shield + 2 Track Crane + "Grand Central Conductor" profile badge.
- Golden Express Coin Rush (bonus rounds): 10 coins per train + 100 full clear bonus (max 300–400 coins).
- Daily Timetable Run clear: **+100 coins** (once per local day).
- Express Streak: Weekly ladder awarding 1,150 coins + boosters.
- Lucky Turntable: Free daily spin with weighted coin and booster prizes.
- Shop Free Coins: Rewarded ad granting **+50 coins**, max 5 times per day.

#### Outflow (Sinks)
- Boosters (singles 60/80/100, 3-packs 150/200/250).
- Heart Refill (120 coins).
- Express Streak Saver (200 coins).

### 3. Golden Express Coin Rush
- Unlocked after level 25, recurs every 25 levels (L25, 50, 75... 475).
- 30-second bonus round: trains continuously line up on clean tabletop tracks. Tapping trains sends them off with gold sparkles.
- Earnings: 10 coins per train. Train quotas by tier: T1 20, T2 22, T3 25, T4 28, T5 30. Full clear awards +100 bonus coins.
- Can only be played once per 25-level milestone (replaying completed levels does not trigger Coin Rush).

### 4. Lucky Turntable
- Unlocked at L10 alongside first Gift Crate. Accessible from Home.
- 1 free spin per day + 1 additional spin for watching a rewarded ad.
- Disclosed odds table (in compliance with Google Play / App Store guidelines):
  - 50 Coins: 35%
  - 100 Coins: 25%
  - 150 Coins: 15%
  - 1 Green Signal Hint: 10%
  - 1 Cowcatcher Shield: 7%
  - 1 Track Crane: 5%
  - 500 Coins Jackpot: 3%

### 5. In-App Purchases & Shop
- **Starter Pack (₹49, one-time purchase):** 500 coins + 3 Hints + 2 Shields + 2 Track Cranes (disappears after purchase).
- **Coin Bundles:**
  - Handful of Brass (500 coins): ₹49
  - Cargo Box of Brass (1,200 coins): ₹99
  - Tender of Brass (3,000 coins): ₹249
  - Vault of Brass (7,500 coins): ₹499
- **VIP Conductor Pass:** ₹20/month auto-renewing subscription.
  - Removes all banner and interstitial ads while subscription is active.
  - Rewarded ads (2X Win, Second Chance revive, extra Turntable spin) remain opt-in.
  - Displays brass VIP ticket emblem on Home and profile screens.

### 6. Advertising Strategy & Compliance
- **Interstitial Ads:**
  - Triggered strictly every 5 numbered-level wins.
  - Never shown during FTUE L1–10. First eligible after L15 win.
  - Minimum 120-second cooldown between interstitials.
  - Deferred on milestone screens, Gift Crates, and Daily Timetable Run.
  - Daily cap of 20 interstitials.
- **Rewarded Ads:**
  - Second Chance Revive (+1 Heart, once per level).
  - 2X Win coin doubler on level complete.
  - Extra Lucky Turntable spin.
  - Daily shop free coins (+50 coins, max 5/day).
- **Compliance & Privacy:**
  - Neutral age gate on first run (asks birth year).
  - If user is under 13: Google Mobile Ads `tagForChildDirectedTreatment = true`, personalized ads disabled, UMP consent tailored to children's policy.
  - UMP consent form presented before ad initialization in EEA/UK.

## Affected Files
- `apps/toy_trains/lib/features/shop/shop_screen.dart` (to be created)
- `apps/toy_trains/lib/features/rush/coin_rush_screen.dart` (to be created)
- `apps/toy_trains/lib/features/spin/lucky_turntable_dialog.dart` (to be created)
- `apps/toy_trains/lib/services/ads_service.dart` (to be created)
- `apps/toy_trains/lib/services/iap_service.dart` (to be created)
- `apps/toy_trains/lib/data/save_repository.dart` (to be created)

## Risks
- Clock manipulation to exploit Lucky Turntable or daily free coins; protected by anti-cheat monotonic time tracking.
- Network dropout during rewarded ad receipt verification.

## Open Questions
- None. Prices, caps, and flows match phase_1/04 and SHARED_CORE_STANDARD.md.
