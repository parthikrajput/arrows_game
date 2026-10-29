# Technical Specification: Phase 18 UI Additions (Remix A)

**Status:** Draft  
**Phase:** 18 (Levels 8501–9000)  
**Theme:** Remix A (Early Eras Synergy / Data-Driven)  
**Document Type:** Technical UI Specification  
**Source Cross-Reference:** [phases/phase_18/06_UI_AND_QA_PHASE_18.md](../../phases/phase_18/06_UI_AND_QA_PHASE_18.md), [SHARED_CORE_STANDARD.md §9.3, §17.23](../../SHARED_CORE_STANDARD.md)

---

## 1. Top HUD Additions & Multi-System Overlays

```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 8850 (Normal)        MOVES: 15       [COINS: 52,100] |
+-----------------------------------------------------------------------+
|  [CYCLE: DAWN (SHIFT IN 3)]   [BEAM: PRISM ACTIVE]   [WEIGHT: 2/2W OK] |
+-----------------------------------------------------------------------+
|                                                                       |
|                       [ SANCTUARY GAME GRID ]                         |
|           (M851 Seasonal Lift & M853 Sun Portal active)               |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```

### 1.1 Seasonal Cycle Dial Widget (`CycleDialWidget`)
- Pinned to upper-left header.
- Miniature 4-phase circular ring rotating with every move.
- Text pill displays current period name and moves until height transition: `[CYCLE: DAWN (SHIFT IN 3)]`.

### 1.2 Solar Beam & Weight Status Pills
- **Beam Status:** Displays whether light beam is unobstructed and reflecting off active prisms.
- **Weight Balance Indicator:** Shows current weight vs required activation threshold on active balance plates (`[WEIGHT: 2/2W OK]`).

---

## 2. In-Grid Visual Indicators & Accessibility

### 2.1 Dynamic Floor Height Chevrons
- Sub-floor and elevated tiles render glowing border lines with vertical elevation glyphs ($\uparrow$ / $\downarrow$) so players can immediately distinguish terrace heights without depth ambiguity.

### 2.2 Portal Runic Rings & Swirls
- Paired burrow portal mouths pulse with color-synchronized runic rings.
- Inactive (unpowered) portals display darkened stone rims.

### 2.3 Coconut Weight Badges
- Each rolling coconut displays an etched numerical weight badge (`1W`, `2W`) on its surface.

---

## 3. Touch Hitboxes & Input Handling
- Standard minimum $48 \times 48\text{ dp}$ hitboxes on all interactive levers and turntable prism reflectors.
- Touch gesture smoothing ensures pushing a coconut boulder registers crisply without camera zoom interference.

---

## 4. References & Cross-Links
- [Phase 18 Signature System](../gameplay/phase-18-signature-system.md)
- [Phase 18 VFX and Audio](phase-18-vfx.md)
- [Phase 18 QA and Rollout](../tech/phase-18-qa-and-rollout.md)
