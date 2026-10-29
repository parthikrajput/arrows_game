Source docs: phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md §4–§5, ../../SHARED_CORE_STANDARD.md §6, §17.26. Depends on: specs/economy/boosters-coins-shop.md.

# Spec: Economy — Piggy Bank & Cosmetics Shop

## Status
Draft

## Type
New Feature

## Goal
Implement the Piggy Bank IAP accumulation feature (unlock at Level 30, cap 1,000 coins, ₹49 smash) and the Cosmetics Shop ("Style" tab with 800–4,000 coins sinks for snake skins and board themes), alongside the VIP-exclusive Royal Peacock skin.

## Current State
Design documented in `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` §4–§5 and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 shop offered boosters, coin packs (IAP), Starter Pack, and VIP No-Ads Pass.
- There was no soft-currency cosmetic sink or accumulation bank.

## Proposed Change
Extend shop and inventory architecture to support Piggy Bank savings and cosmetic customization:

### 1. Piggy Bank Rules
- **Unlock Level:** Level 30 clear (instantly active if `highestCleared >= 30` upon updating to Phase 2). Starting balance is 0 (no retroactive deposit).
- **Accumulation:** Every numbered level **first clear** deposits **+10 coins into Piggy Bank** (in addition to normal clear rewards). Replays, Daily Challenges, and Coin Rush rounds do not deposit into the piggy.
- **Capacity Cap:** Exactly **1,000 coins** (reached after 100 first clears). Deposits stop once full with UI label "Piggy is full!".
- **Smash Purchase:**
  - SKU: `piggy_bank` (consumable IAP, priced at **₹49** / localized equivalent).
  - Purchase is enabled once Piggy reaches **>= 350 coins** (matching the value of the Coins S pack, ensuring purchase is never worse value).
  - Breaking transfers all saved piggy coins into the player's wallet via server ledger transaction, resets piggy balance to 0, and begins a new fill cycle.
  - Store copy: "1,000 coins for ₹49 — the same price as 350 coins in the Shop." (Honest value comparison, no misleading fake discounts).

### 2. Cosmetics Shop (Shop "Style" Tab)
- Adds a 4th tab to the Shop: **Boosters · Coins · Offers · Style**.
- All items in the Style tab are purchased exclusively with soft currency (Coins), priced within the standard range of **800 to 4,000 coins**:
  | SKU | Type | Name | Price (Coins) | Visual / Accessory |
  |---|---|---|---|---|
  | `skin_emerald_vine` | Snake skin | Emerald Vine | 800 | Leafy sleeve + vine particle trail |
  | `skin_sunset_stripes` | Snake skin | Sunset Stripes | 1,200 | Warm gradient sheen |
  | `skin_mango_swirl` | Snake skin | Mango Swirl | 1,600 | Fruit-swirl texture + leaf hat |
  | `skin_moonlight_glow` | Snake skin | Moonlight Glow | 2,000 | Soft glow rim + star particle trail |
  | `skin_rainbow_scales`| Snake skin | Rainbow Scales | 3,000 | Iridescent scale sheen |
  | `skin_golden_cobra` | Snake skin | Golden Cobra | 4,000 | Gold hood accessory + sparkle trail |
  | `theme_bamboo_mat` | Board theme | Bamboo Mat | 1,500 | Woven bamboo tile texture |
  | `theme_lotus_pond` | Board theme | Lotus Pond | 2,500 | Lilypad water board background |
  | `theme_starry_garden`| Board theme | Starry Night Garden | 3,500 | Dark twilight garden tiles |
  | `skin_royal_peacock` | VIP skin | Royal Peacock | VIP Entitlement | Peacock-feather crest + shimmer trail |

### 3. Gameplay Invariants & Cosmetics Rules
- **No Gameplay Advantage:** Cosmetics do not alter hitboxes, speeds, move durations, or collision rules.
- **Accessibility & Contrast:** Color-blind patterns remain rendered boldly over any equipped skin. Board themes maintain >= 3:1 contrast against all mechanic tiles.
- **VIP Skin Handling:** Royal Peacock is active only while VIP No-Ads Pass is active. If VIP expires (+ 72h grace), skin reverts to default or previously equipped skin.

## Affected Files
- `lib/features/economy/domain/models/piggy_bank.dart` (to be created)
- `lib/features/cosmetics/domain/models/cosmetic_item.dart` (to be created)
- `lib/features/cosmetics/presentation/screens/style_tab.dart` (to be created)
- `lib/features/shop/presentation/widgets/piggy_bank_tile.dart` (to be created)
- `lib/features/cosmetics/presentation/widgets/skin_preview_board.dart` (to be created)

## Design
- Screen: Style tab in Shop with interactive 5x5 "Try-on" preview board; Piggy Bank widget with animated glass belly fill meter.
- Sound: `sfx_piggy_smash` (hammer break and coins fly).

## Risks
- Double spend or offline desynchronization of cosmetic purchases. Mitigated by idempotency keys in cloud functions ledger.

## Open Questions
- None. Numbers and pricing align with `SHARED_CORE_STANDARD.md` §6 and `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` §4–§5.
