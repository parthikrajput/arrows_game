# Technical Specification: Phase 16 UI Additions (Treasure Keys)

**Status:** Draft  
**Phase:** 16 (Levels 7501–8000)  
**Theme:** Treasure Keys (Keys Deluxe)  
**Document Type:** Technical UI Specification  
**Source Cross-Reference:** [phases/phase_16/06_UI_AND_QA_PHASE_16.md](../../phases/phase_16/06_UI_AND_QA_PHASE_16.md), [SHARED_CORE_STANDARD.md §9.3, §17.23](../../SHARED_CORE_STANDARD.md)

---

## 1. Top HUD Additions & Key Dependency Displays

```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 7850 (Normal)        MOVES: 19       [COINS: 44,100] |
+-----------------------------------------------------------------------+
|  [KEY CRAFT: ?? HALF-A OK | HALF-B PENDING]    [SKELETON KEYS: 1]     |
+-----------------------------------------------------------------------+
|                                                                       |
|                       [ VAULT GAME GRID ]                             |
|          (M751 Key Vine & M754 Key Swap Pedestal active)              |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```

### 1.1 Key Crafting Ribbon Widget (`KeyCraftingRibbon`)
- Upper HUD ribbon tracking multi-part key progress:
  - Half-A slot: Displays golden key head with checkmark once collected.
  - Half-B slot: Displays glowing outline with pulsating "PENDING" status until retrieved.
  - Fusion flash animation plays across ribbon when both components merge into a Master Key.

### 1.2 Skeleton Key Inventory Badge (`SkeletonKeyBadge`)
- Dedicated gold-embossed badge with counter `[SKELETON KEYS: N]`.
- Glowing aura indicates an active Skeleton Key ready for universal gate bypass.

---

## 2. In-Grid Visual Indicators & Accessibility

### 2.1 Golden Vine Dynamic Connection Lines
- Rendered bezier curve connecting vine lock to target reward cell.
- Leafy golden vine texture gently sways in ambient wind.
- Dissolves with petal-burst particle system when lock is broken.

### 2.2 Key Swap Pedestal Aura
- Elevated stone altar with glowing circular pedestal runes.
- Color aura matches the currently seated key (Blue, Red, Yellow, or Master Gold).
- Holographic floating key slowly revolves above the pedestal.

---

## 3. Touch Hitboxes & Input Handling
- Swap pedestals automatically trigger when snake head path intersects cell coordinate; requires 0 separate clicks.
- Zoom & pan gestures remain responsive without intercepting key pickup detection.

---

## 4. References & Cross-Links
- [Phase 16 Signature System](../gameplay/phase-16-signature-system.md)
- [Phase 16 VFX and Audio](phase-16-vfx.md)
- [Phase 16 QA and Rollout](../tech/phase-16-qa-and-rollout.md)

