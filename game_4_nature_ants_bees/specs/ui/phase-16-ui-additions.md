# Spec: Phase 16 UI Additions — Royal Keyring HUD & Tutorial Cards

Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, SHARED_CORE_STANDARD.md §12. Depends on: specs/gameplay/phase-16-signature-system.md, specs/gameplay/phase-16-base-mechanics.md, specs/ui/vfx-and-juice.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 UI Additions — Royal Keyring HUD & Tutorial Cards |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | ui |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define all new keyring inventory HUD indicators, key crafting fusion petal lights, skeleton crown shimmer icons, swap pad link arcs, tutorial cards, and accessibility enhancements required for Royal Keyring (Dew Key Chain, Key-Crafting Flower, Skeleton Dew Key, and Key Swap Pad).

---

## Current State

Design documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md`, not yet implemented.

---

## Proposed Change

### 1. Keyring Inventory HUD Bar
- Displays at the top of the board when key/lock mechanics are present.
- Displays currently collected keys, active color categories (Red, Blue, Yellow, Purple), and half-key fractions (1/2, 2/2).
- Key slot turns bright gold with a soft pulse when unlocked.

### 2. Key Crafting Fusion Indicator (M752)
- Central Key-Crafting Flower petal ring illuminates progressively as required half-key insects exit the grid.
- Left petal glows when Half-Key A is collected; right petal glows when Half-Key B is collected.
- Upon 2/2 collection, the flower center synthesizes the combined master key with an outward petal flare.

### 3. Skeleton Crown Shimmer (M753)
- Skeleton Dew Key insects display a radiant golden crown icon above their sprite.
- Hovering/tapping lightly highlights their entire orthogonal row and column with a subtle gold crosshair guide to show coverage.

### 4. Key Swap Link Arcs (M754)
- When two insects are linked across a Key Swap Pad, an animated golden curved arc connects their heads.
- Swap button on the pad displays dual rotating arrows with color-matched key badges showing pending swap states.

### 5. Tutorial Overlay Cards
Presented once per player profile at designated intro levels:

| Trigger Level | Card Title | Body Text |
|---|---|---|
| L7501 | Royal Keyring | "Unlock chains of keys, craft combined colors, and swap keys between insects!" |
| L7511 | Dew Key Chain | "Opening one lock grants a new key to another waiting insect." |
| L7631 | Key-Crafting Flower | "Exit both half-key insects to craft a combined-color master key!" |
| L7751 | Skeleton Dew Key | "Master insect! Exiting shatters all locks in its starting row and column." |
| L7871 | Key Swap Pad | "Tap to swap key possession between two linked insects to clear tricky paths." |

### 6. Phase 16 World Map Entry
- Map node: **Royal Keyring Pavilion** (L7501–8000).
- Visual theme: Gilded garden gates, jeweled key filigree arches, and sparkling dew crystals.
- Map progression line turns into polished golden vine with brass padlock markers every 10 levels.

### 7. Accessibility Support
- **Colorblind Palettes:** Unique geometric symbols embedded within each key color (e.g. Red = Diamond, Blue = Circle, Yellow = Star, Purple = Triangle).
- **Reduced Motion:** Swap arcs and skeleton crosshairs render as static solid lines rather than sweeping particle pulses.

---

## Verification Plan

### Automated Tests
1. Verify tutorial cards trigger exactly on L7501, L7511, L7631, L7751, and L7871.
2. Verify Keyring HUD correctly reflects key possession counts and color states.

### Manual Verification
1. Inspect Skeleton crosshair overlay on high-density boards for visual clarity and no frame drop.
2. Verify colorblind symbols clearly distinguish half-keys and combined keys.
