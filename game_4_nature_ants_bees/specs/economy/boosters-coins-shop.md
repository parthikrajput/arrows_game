Source docs: phase_1/04_BOOSTERS_COINS_SHOP.md, SHARED_CORE_STANDARD.md

# Spec: Boosters, Economy, Shop, and Advertising

## Status
Draft

## Type
New Feature

## Goal
Specify the economic systems, boosters, coin balance, shop catalog, IAP products, and ad policies for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in phase_1/04_BOOSTERS_COINS_SHOP.md and SHARED_CORE_STANDARD.md, not yet implemented.
- Starting player wallet is 200 coins.
- 3 active boosters with hard inventory caps: Nectar Glow Hint (cap 3), Queen's Royal Shield (cap 1), Leaf Blower (cap 2).
- Free Scent Trail Preview on 350 ms long-press.
- Coins awarded for first-time level clears; zero coins on replay.
- Queen's Gift Box at every 10th level; Royal Honey Chest at Level 500.
- Interstitial ad cooldown of 120s, triggered every 5 wins, strictly never in L1–10.
- Beekeeper VIP Pass subscription at ₹20/month.

## Proposed Change
Implement the economy and monetization modules in `apps/ants_bees/lib/features/economy/`:

### 1. Boosters Catalog & Rules
| Booster Name (Generic) | Unlock | Single Price | 3-Pack Price | Inventory Cap | Effect & Gameplay Rules |
|---|---|---|---|---|---|
| **Nectar Glow Hint** (Hint) | L3 | 60 coins | 150 coins | 3 | Golden nectar aura highlights the next optimal line or interactive control in solver solution. |
| **Queen's Royal Shield** (Shield) | L15 | 80 coins | 200 coins | 1 | Royal honeycomb bubble protects against the next 2 bonks/bumps. Absorbed bonks do not deduct hearts. |
| **Leaf Blower** (Hammer) | L25 | 100 coins | 250 coins | 2 | Powerful wind gust blows away any 1 visible unhidden line (counts as clear) OR removes 1 hammerable obstacle. |
| **Scent Trail Preview** (Preview) | L4 | Free | Free | N/A | Dotted lane trajectory preview on >= 350 ms long-press (straight for ants, wavy for bees). |

- **Booster Purchasing:** Boosters can be bought in the booster bar or shop. If inventory is at cap, purchase button is disabled.
- **Tutorial Grants:** L3 grants 3 Hints; L15 grants 1 Shield; L25 grants 1 Leaf Blower.

### 2. Coin Economy & Inflow
- **Starting Balance:** 200 coins.
- **Level First Clear:**
  - Easy (Breather x5): 15 coins.
  - Normal (x1–x4, x6–x8, x0): 20 coins.
  - Hard (x9): 30 coins.
  - Phase Finale (L500): 50 coins.
- **First ★★★ Clear Bonus:** +20 bonus coins.
- **Level Replay:** 0 coins (stars improve, but no coin reward).
- **Queen's Gift Box (Every x0 Level):**
  - L10: 150 coins + 1 Hint.
  - L20: 180 coins + 1 Leaf Blower.
  - L30: 200 coins + 1 Shield.
  - L40: 200 coins + 1 Hint.
  - L50: 220 coins + 1 Leaf Blower.
  - L60–L490: 200–300 coins + rotating booster.
- **Royal Honey Chest (L500 Finale):** 1,000 coins + 2 Hints + 2 Shields + 2 Leaf Blowers + "Garden Guardian" cosmetic badge.
- **Golden Nectar Rush (Every 25 Levels Cleared):** 30-second bonus frenzy. 10 coins per line cleared + 100 coins board-clear completion bonus.
- **Sunflower Spin (Lucky Wheel):** 1 free spin every 24 hours. Odds:
  - 50 coins (25%), 100 coins (20%), 200 coins (10%), 1 Hint (15%), 1 Shield (10%), 1 Leaf Blower (10%), 1 Heart Refill (8%), Jackpot 500 coins (2%).
  - +1 extra spin available daily via rewarded ad.
- **Daily Challenge:** +100 coins per daily clear; 7-day streak ladder yields 1,150 coins/week.
- **Free Shop Ad:** +50 coins, capped at 5 rewarded ads per calendar day.

### 3. Coin Outflow & Sinks
- **Honey Heart Refill:** 120 coins (yields +1 Heart in Second Chance popup; max 2 per attempt).
- **In-Game Booster Restock:** Hint (60 / 150 for 3), Shield (80 / 200 for 3), Leaf Blower (100 / 250 for 3).
- **Streak Saver (Queen's Favor):** 200 coins (or 1 rewarded ad) to restore a missed streak day.

### 4. Shop Catalog & In-App Purchases (IAP)
- **Starter Pack (₹49):** 500 coins + 2 Hints + 1 Shield + 1 Leaf Blower. Unlocks at L15 for 48 hours; one-time purchase.
- **Handful of Honey:** 500 coins — ₹49.
- **Pouch of Pollen:** 1,200 coins — ₹99.
- **Sack of Nectar:** 3,000 coins — ₹199.
- **Queen's Treasure Chest:** 8,000 coins — ₹499.
- **Beekeeper VIP Pass:** ₹20/month auto-renewing subscription.
  - Interstitial and banner ads removed while subscription is active.
  - +1 bonus Sunflower Spin every day.
  - Golden avatar frame and royal UI theme accents.
  - Wording clearly specifies: "Benefits active while subscription is maintained."

### 5. Advertising Architecture & Compliance
- **AdMob SDK:** Managed via `AdService`.
- **Interstitial Ads:**
  - Triggered strictly every 5 level wins.
  - Never shown during Levels 1–10 (FTUE protection).
  - Minimum 120 seconds cooldown between any two interstitials.
  - Deferred away from reward screens (Gift Box, Golden Nectar Rush, Spin).
- **Rewarded Video Ads:**
  - Second Chance Revive: +1 Heart (strictly 1 per level number; not reset on restart).
  - Sunflower Spin: +1 additional spin per day.
  - Daily Streak Saver (Queen's Favor): 1 save per streak cycle.
  - Shop Daily Coins: +50 coins (max 5/day).
- **Banner Ads:** Displayed at bottom of Home, Level Map, and Gameplay (starting Level 11).
- **Compliance:**
  - Google UMP (User Messaging Platform) for GDPR/CPRA consent prior to non-essential ad tracking.
  - Google Play Families Policy: Neutral age gate (ages 10–50). Players under digital consent age receive strictly non-personalized contextual ads.

## Affected Files
- `apps/ants_bees/lib/features/economy/bloc/economy_bloc.dart` (to be created)
- `apps/ants_bees/lib/features/economy/services/ad_service.dart` (to be created)
- `apps/ants_bees/lib/features/economy/services/iap_service.dart` (to be created)
- `apps/ants_bees/lib/features/economy/models/wallet.dart` (to be created)
- `apps/ants_bees/lib/features/economy/ui/shop_screen.dart` (to be created)
- `apps/ants_bees/lib/features/economy/ui/sunflower_spin_dialog.dart` (to be created)

## Risks
- Ad revive exploitation if level state is not stored persistently across app restarts.
- Cooldown timer for interstitials must persist in memory and respect app lifecycle.

## Open Questions
- None. Pricing, caps, inflow/outflow, and ad rules conform precisely to SHARED_CORE_STANDARD.md §6 and §7.
