Source docs: phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/economy/boosters-coins-shop.md, specs/tech/offline-and-cloud-sync.md.

# Spec: Economy — Knitted Piggy Bank & Wardrobe Cosmetics

## Status
Draft

## Type
New Feature

## Goal
Implement the Knitted Piggy Bank monetization mechanic (₹49 IAP, 1,000 Coin capacity) and the Wardrobe cosmetic shop (800–4,000 Coin sinks across thread skins, board themes, needle charms, and profile frames) for Yarn Unravel Phase 2.

## Current State
Design documented in `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 economy in `specs/economy/boosters-coins-shop.md` focused on booster purchases, coin packs, rewarded ads, and VIP subscriptions.
- Phase 2 introduces a mid-core coin accumulation bank (Knitted Piggy Bank) and aesthetic coin sinks (Wardrobe) to balance coin inflation.

## Proposed Change
Extend the game economy and shop systems:

### 1. Knitted Piggy Bank
- **Unlock:** Feature card shown upon clearing Level 30.
- **Mechanics:**
  - On every level clear, an extra **15%** of base clear coins is minted and deposited into the Knitted Piggy Bank. This does NOT deduct from the player's normal clear earnings.
  - **Threshold to Break:** Minimum **300 Coins** stored before the "Break" button becomes active.
  - **Capacity Cap:** Maximum **1,000 Coins**. Once full, further coin deposits pause until broken.
- **IAP Purchase:**
  - SKU: `yarn_piggy_bank` (₹49 consumable).
  - Handled exclusively via server-side receipt validation Cloud Function `verifyPurchase`.
  - Upon verified purchase: stored coins are credited directly to the player's active Coin balance, Piggy Bank balance resets to 0, and accumulation resumes.
- **Visuals:** Hand-knitted wool piggy with button eyes; visually expands from slim to plump as it nears the 1,000 coin cap.

### 2. Wardrobe (Cosmetic Shop)
- Accessible via a dedicated "Wardrobe" tab in the Shop screen.
- **Categories & Pricing Tiers (800–4,000 Coins):**

| Category | Item Name | Coin Cost | Visual / Aesthetic Description |
|---|---|---|---|
| **Thread Skins** | Pastel Cotton | Free (Default) | Standard twisted matte wool yarn |
| | Silk Floss | 1,200 | Sheen highlight shader with lustrous smooth texture |
| | Heather Tweed | 2,000 | Multi-tonal flecked wool with rustic yarn fibers |
| | Golden Lamé | 4,000 | Metallic gold thread weave with glittering highlight sparkles |
| **Board Themes** | Birch Loom | Free (Default) | Light natural wood frame with cream linen fabric |
| | Dark Walnut | 1,500 | Rich dark timber frame with warm beige burlap backing |
| | Rosewood Craft Table | 2,500 | Polished mahogany frame with soft lavender fabric |
| | Vintage Atelier | 3,500 | Antique distressed oak frame with parchment grid |
| **Needle Charms** | Silver Eyelet | Free (Default) | Classic polished silver needle eye |
| | Silver Thimble Charm | 800 | Miniature engraved silver thimble dangling from needle |
| | Brass Scissors Charm | 1,800 | Tiny antique brass shears charm |
| | Pearl Button Charm | 2,800 | Iridescent mother-of-pearl button accessory |
| **Profile Frames** | Plain Wooden Hoop | Free (Default) | Minimalist embroidery circle frame |
| | Cross-Stitch Border | 1,000 | Hand-stitched colorful cross-stitch avatar border |
| | Golden Thread Filigree| 3,000 | Intricate gold filigree lace surrounding avatar |

- **Album Exclusives:** Cosmetics unlocked via Scrapbook volume completion ("Purl Paw", "Cottage Lace", etc.) display an "Album Exclusive" badge and cannot be purchased with coins.
- **Equip System:** Equipped cosmetics are stored locally in Hive box `cosmetics` and applied across all gameplay and menu views.

### 3. Local & Server Schema
- **Local Hive Box (`piggy`):** `stored: int`, `unlocked: bool`.
- **Local Hive Box (`cosmetics`):**
  - `owned: List<String>` (unique item IDs).
  - `equipped: Map<String, String>` (keys: `threadSkin`, `boardTheme`, `needleCharm`, `profileFrame`).
  - `equippedAtUtc: int`.
- **Server Sync:** Purchases generate ops in `syncQueue` (`type: "cosmetic_buy"`, `type: "piggy_smash"`).

## Affected Files
- `lib/features/shop/data/piggy_repository.dart` (to be created: coin accumulation and state)
- `lib/features/shop/view/knitted_piggy_bank_widget.dart` (to be created: animated piggy view)
- `lib/features/shop/view/wardrobe_tab.dart` (to be created: cosmetics preview and purchase grid)
- `functions/src/billing/verify_purchase.ts` (changed: handle `yarn_piggy_bank` consumable SKU)

## Risks
- Client tampering with local piggy bank balance to trigger premature breaks or inflated claims. Mitigated by server authoritative ledger: `verifyPurchase` credits only the server-tracked piggy bank value.

## Open Questions
None. Pricing bands (800–4,000 coins) and ₹49 IAP price point match `SHARED_CORE_STANDARD.md`.
