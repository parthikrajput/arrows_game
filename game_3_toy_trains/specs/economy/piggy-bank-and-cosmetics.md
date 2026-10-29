Source docs: phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/economy/boosters-coins-shop.md, specs/tech/backend-cloud-functions-and-release-prerequisites.md.

# Spec: Piggy Bank & Cosmetics Economy Expansion (Toy Trains)

## Status
Draft

## Type
Improvement (expands shop offerings, coin sinks, and monetization from `specs/economy/boosters-coins-shop.md`)

## Goal
Specify the Phase 2 economy expansions for Toy Trains: Wooden Railway Puzzle, establishing the Ticket Piggy Bank consumable IAP (₹49, max 1,000 coins) and the Train Shed Cosmetics catalog (800–4,000 coins sinks for train liveries and table themes).

## Current State
Design documented in `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 shop (`specs/economy/boosters-coins-shop.md`) offered coin packs, boosters, Starter Pack, and the ₹20/month VIP Conductor Pass.
- Players with large coin balances lacked persistent non-gameplay coin sinks.
- Phase 2 introduces a conversion-friendly IAP ("Ticket Piggy Bank") and decorative cosmetic customization.

## Proposed Change
Extend the shop module and monetization pipeline in Flutter:

### 1. Ticket Piggy Bank (IAP Consumable)
- **Unlock Condition:** Reaching and clearing Level 30.
- **Deposit Mechanism:**
  - On the **first clear** of any main campaign level, **+10 coins** are automatically routed into the Piggy Bank.
  - Level replays, Coin Rush, and Daily Timetable runs do not deposit coins into the bank.
  - Deposits operate seamlessly offline without requiring network calls.
- **Capacity & States:**
  - Minimum Break Threshold: **300 coins**. Below 300, the bank is in "Filling" state and cannot be opened.
  - Maximum Capacity: **1,000 coins**. Once full (1,000 coins), further clears do not add coins.
- **Breaking & Purchase Flow:**
  - SKU: `piggy_bank_49` (Google Play & Apple App Store).
  - Price: **₹49** (Tier 1 consumable, approx. $0.99 USD).
  - Purchase requires active internet. Client calls `in_app_purchase` -> receives receipt -> submits to `verifyPurchase` Cloud Function -> server verifies receipt -> logs transaction in ledger -> adds stored coins to user's wallet -> resets Piggy Bank balance to 0.
  - Visual/Audio: Ceramic shattering animation, coin cascade particle burst, and sound `sfx_piggy_smash`.

### 2. Train Shed Cosmetics Shop ("Liveries & Tables")
- **Unlock Condition:** Level 10 clear (accessible immediately after FTUE).
- **Payment Method:** Purchased exclusively with earned in-game **coins** (no direct real-money IAPs for cosmetics).
- **Gameplay Neutrality:** Cosmetics never modify hitbox sizes, collision rays, train lengths, or puzzle difficulty. Color-blind patterns are preserved across all liveries.

#### A. Train Liveries (Skins)
| Livery Name | Coin Price | Visual Description |
|---|---|---|
| **Vintage Brass Shunter** | 800 coins | Polished antique brass plating with golden boiler rivets |
| **Midnight Express** | 1,200 coins | Deep navy blue enamel with matte gold carriage trim |
| **Cherry Blossom Steamer** | 1,500 coins | Soft pastel pink satin lacquer with floral tender accents |
| **Royal Sovereign Emerald** | 2,500 coins | British racing green body with gold crown detailing on cab |

#### B. Tabletop Playmat Themes
| Theme Name | Coin Price | Visual Description |
|---|---|---|
| **Oak Study Desk** | 1,000 coins | Light honey oak wood grain background with ruler grid marks |
| **Alpine Pine Table** | 1,800 coins | Rustic knotted pine planks with subtle painted mountain contours |
| **Mahogany Velvet Mat** | 3,000 coins | Deep dark mahogany wooden frame surrounding green baize billiard felt |
| **Celestial Night Concourse** | 4,000 coins | Dark indigo stained wood inlaid with constellations and brass stars |

### 3. Shop UI Integration
- Shop gains a dedicated **"Train Shed"** tab alongside "Supplies" (Boosters & Coins) and "VIP Conductor".
- 3D interactive preview car: Player can spin the locomotive model and preview liveries before purchasing.
- Equipped livery and table theme IDs are saved to local Hive `settings_box` and synced to Firestore `users/{uid}.cosmetics`.

## Affected Files
- `lib/features/economy/domain/models/piggy_bank.dart` (to be created)
- `lib/features/economy/domain/models/cosmetic_item.dart` (to be created)
- `lib/features/economy/presentation/screens/cosmetics_shop_tab.dart` (to be created)
- `lib/features/economy/presentation/widgets/piggy_bank_break_dialog.dart` (to be created)
- `functions/src/billing/verify_purchase.ts` (changed: handle `piggy_bank_49` SKU and reset logic)

## Design
- Shop Tab: Wooden carousel display with brass plaque showing "Train Shed".
- Piggy Bank: Miniature ceramic locomotive piggy bank with a slot in the smokestack; fills visually as coins accumulate (empty, half, full).

## Risks
- Double-crediting or lost coins if network drops during Piggy Bank break. Mitigation: Receipt verification in Cloud Functions is strictly idempotent; transaction recorded in Firestore ledger before local coin delivery.

## Open Questions
- None. SKU pricing, coin thresholds, and catalog pricing match `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `SHARED_CORE_STANDARD.md`.
