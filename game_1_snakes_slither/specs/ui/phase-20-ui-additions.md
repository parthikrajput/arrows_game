# Technical Specification: Phase 20 UI Additions (Grand Jungle Master)

**Status:** Draft  
**Phase:** 20 (Levels 9501–10,000)  
**Theme:** Grand Jungle Master (All Systems Culmination & Level 10,000 Grand Finale)  
**Document Type:** Technical UI Specification  
**Source Cross-Reference:** [phases/phase_20/06_UI_AND_QA_PHASE_20.md](../../phases/phase_20/06_UI_AND_QA_PHASE_20.md), [SHARED_CORE_STANDARD.md §9.3, §17.23](../../SHARED_CORE_STANDARD.md)

---

## 1. Top HUD Additions & Master Boss Overlays

```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 10,000 (Grand Finale)  MOVES: 34     [COINS: 62,500] |
+-----------------------------------------------------------------------+
|  [EMPEROR: TELEGRAPH (STRIKE IN 1)]   [OMNI KEY: READY]   [CROWN: OPEN]|
+-----------------------------------------------------------------------+
|                                                                       |
|                    [ JUNGLE KINGDOM CROWN ARENA ]                     |
|           (Apex Boss Telegraph & Convergence Vortex Active)           |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```

### 1.1 Apex Boss Threat Indicator Widget (`BossThreatWidget`)
- Dynamic threat warning pill on header status bar:
  - Cyan: `[EMPEROR: PATROL]` (normal movement).
  - Flashing Crimson: `[EMPEROR: TELEGRAPH (STRIKE IN 1)]` with exclamation icon.
  - Pulsing Gold: `[EMPEROR: STUNNED (2 TURNS)]` with stars icon.

### 1.2 Omni Key & Crown Pedestal Widgets
- **Omni Key Status:** Illuminated rainbow gem indicating whether all doors on board are unlocked.
- **Crown Pedestal Status:** Golden throne icon showing whether path to dais is clear.

---

## 2. In-Grid Visual Indicators & Accessibility

### 2.1 Boss Threat Corridor Projections
- When Apex Boss enters telegraph state, bright crimson ground runic tiles project 3 tiles along the rush vector.
- High-contrast accessibility: Displays clear diagonal warning stripes and crosshair icons.

### 2.2 Convergence Vortex Shimmer Rings
- Swirling multi-dimensional portal tiles emit glowing cosmic dust particles.
- Colorblind accessibility: Paired vortexes share unique geometric matching rune shapes (Star, Moon, Sun, Diamond).

### 2.3 Crown Pedestal Radiant Aura
- Elevated golden dais projects a vertical light shaft reaching to the ceiling, indicating the ultimate win goal.

---

## 3. Touch Hitboxes & Input Handling
- Boss entities are non-interactive to touch; tapping them displays an informational status banner showing stun resistance and threat corridor details.
- Minimum $48 \times 48\text{ dp}$ hitboxes on all interactable board levers and switches.

---

## 4. References & Cross-Links
- [Phase 20 Signature System](../gameplay/phase-20-signature-system.md)
- [Phase 20 VFX and Audio](phase-20-vfx.md)
- [Phase 20 QA and Rollout](../tech/phase-20-qa-and-rollout.md)

