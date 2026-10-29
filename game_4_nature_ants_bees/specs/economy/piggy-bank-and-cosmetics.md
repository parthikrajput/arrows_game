Source docs: phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, SHARED_CORE_STANDARD.md. Depends on: specs/economy/boosters-coins-shop.md

# Spec: LiveOps Golden Honeycomb Bank and Garden Wardrobe Cosmetics

## Status
Draft

## Type
New Feature

## Goal
Implement the Golden Honeycomb Bank (Piggy Bank mechanic) with IAP unlocking, and the Garden Wardrobe cosmetic shop providing long-term coin sinks (insect skins and board themes) for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md and SHARED_CORE_STANDARD.md.
- Extends `specs/economy/boosters-coins-shop.md`.
- In Phase 1, coins were spent primarily on boosters and heart refills.
- Phase 2 introduces a dedicated IAP piggy bank product (`piggy_bank` at ₹49) and a cosmetic wardrobe sink (800–4,000 coins).

## Proposed Change
Implement the piggy bank and cosmetic shop in `apps/ants_bees/lib/features/economy/`:

### 1. Golden Honeycomb Bank (Piggy Bank)
- **Visual Identity:** Honeycomb icon (distinct from the honey jar icon reserved for Golden Nectar Rush).
- **Unlock Condition:** Cleared Level 30 (`highestCleared >= 30`).
- **Deposit Rate:** Automatically deposits **+10 coins per first-clear numbered level**. Replays, Daily challenges, and Rush rounds do not contribute.
- **Spendability:** Banked coins are segregated from the player's active wallet balance until unlocked via IAP.
- **Capacity Cap:** Capped at **1,000 coins**. Once full, deposits halt with a glowing "Bank Full" indicator.
- **IAP Purchase:**
  - SKU: `piggy_bank` (Consumable IAP, **₹49**).
  - Can be cracked open once balance reaches $\ge 350$ coins (Remote Config `piggy_min_break`).
  - When purchased, server verifies receipt and transfers the exact server-side bank balance to player's wallet, resetting bank balance to 0.
- **Offer Surfacing:** Max 1 popup dialog every 72 hours when the bank is full. Never shown during gameplay or fail screens. Children (under-13) receive zero popups (Home icon only).

### 2. Garden Wardrobe (Cosmetics Shop)
A dedicated Shop tab ("Wardrobe") allowing players to customize characters and boards using earned coins:

| SKU | Cosmetic Item | Type / Target | Price (Coins) |
|---|---|---|---|
| `skin_ant_leafcutter` | **Leafcutter Ant** (carrying green leaf) | Ant lines | 800 |
| `skin_bee_bumble` | **Fuzzy Bumblebee** | Bee + Canopy lines | 800 |
| `skin_ant_firefly` | **Glowtail Ant** (bioluminescent abdomen) | Ant lines | 1,500 |
| `skin_bee_carpenter`| **Violet Carpenter Bee** | Bee + Canopy lines | 1,500 |
| `skin_ant_golden` | **Golden Honeypot Ant** | Ant lines | 2,500 |
| `skin_bee_orchid` | **Emerald Orchid Bee** | Bee + Canopy lines | 2,500 |
| `theme_autumn` | **Autumn Orchard** board theme | Full board palette | 2,000 |
| `theme_blossom` | **Cherry Blossom Garden** board theme | Board tiles | 3,000 |
| `theme_moonlit` | **Moonlit Meadow** board theme | Deep blue night lawn | 4,000 |
| `skin_bee_vip` | **Beekeeper's Royal Bee** | Bee + Canopy lines | **VIP Exclusive** (Equip-able while VIP is active) |

- **Album-Exclusive Skins:** "Pressed-Flower Ant" (Vol 4) and "Stained-Glass Bee" (Vol 5) appear in the Wardrobe once unlocked from the Compendium, but cannot be bought with coins.

### 3. Visual Fairness & Accessibility Invariants
- Cosmetics are strictly cosmetic: hitboxes, move speeds, bonk timings, and path mechanics remain 100% identical.
- Line colors remain visible on abdomen (ants) or bands (bees) alongside accessibility glyphs.
- All board themes maintain a minimum 3:1 contrast ratio against insect sprites.
- Interactive 5-second live preview enables players to test skins on an interactive sample board before purchase.

## Affected Files
- `apps/ants_bees/lib/features/economy/models/honeycomb_bank.dart` (to be created)
- `apps/ants_bees/lib/features/economy/models/cosmetic_item.dart` (to be created)
- `apps/ants_bees/lib/features/economy/bloc/wardrobe_bloc.dart` (to be created)
- `apps/ants_bees/lib/features/economy/ui/wardrobe_screen.dart` (to be created)
- `apps/ants_bees/lib/features/economy/ui/honeycomb_bank_dialog.dart` (to be created)

## Risks
- Store receipt validation failures could cause coin delivery drops; handled via idempotent Cloud Function `verifyPurchase`.

## Open Questions
- None. Prices, caps, and cosmetic SKUs correspond directly to phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md §4 and §5.
