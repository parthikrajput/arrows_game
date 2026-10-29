# Technical Specification: Phase 17 UI Additions (Mongoose Clan)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical UI Specification  
**Source Cross-Reference:** [phases/phase_17/06_UI_AND_QA_PHASE_17.md](../../phases/phase_17/06_UI_AND_QA_PHASE_17.md), [SHARED_CORE_STANDARD.md §9.3, §17.23](../../SHARED_CORE_STANDARD.md)

---

## 1. Top HUD Additions & Boss Health Overlays

```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 8350 (Normal)        MOVES: 17       [COINS: 48,300] |
+-----------------------------------------------------------------------+
|  [GUARDIAN CLAN: [======    ] 6/10 HP]       [SHIELD: LOWERED (2)]     |
+-----------------------------------------------------------------------+
|                                                                       |
|                       [ MONGOOSE DEN GRID ]                           |
|           (M801 Twins Active & M803 Spawner Nest Guarded)             |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```

### 1.1 Boss HP Bar Widget (`BossHealthBarWidget`)
- Positioned prominently below the header status bar.
- Features segmented health pips or a continuous fill bar:
  - Green gradient fill when HP $> 50\%$.
  - Amber fill when HP between $25\%$ and $50\%$.
  - Pulsing red with warning flash when HP $\le 25\%$.
  - Displays remaining health numerical counter (e.g. `6/10 HP`).

### 1.2 Shield Status Pill Widget (`ShieldStatusWidget`)
- Displays current active state of Armadillo / Guardian shields:
  - Cyan border + icon: `[SHIELD: ACTIVE]` (invulnerable).
  - Amber border + icon: `[SHIELD: LOWERED (N MOVES)]` with countdown timer.

---

## 2. In-Grid Visual Indicators & Accessibility

### 2.1 Guardian Stagger & Vulnerability Rings
- When a guardian takes damage, its entity sprite flashes white and displays a 1-turn spinning star halo (`stagger_ring`).
- Ground projector circle underneath guardian displays colored health segments.

### 2.2 Directional Vulnerability Arrows (M804 Core)
- Holographic glowing arrows point inward on the tiles adjacent to M804 Den Core, highlighting which directional exit lane will register damage.
- Colorblind accessibility: Arrows display high-contrast geometric chevrons and letter badges (N, S, E, W).

---

## 3. Touch Hitboxes & Input Handling
- Shield levers have standard $48 \times 48\text{ dp}$ hitboxes with highlight on touch-down.
- Tapping a guardian entity directly does NOT consume a move; instead displays an informational tooltip banner showing remaining HP and defense mechanics.

---

## 4. References & Cross-Links
- [Phase 17 Signature System](../gameplay/phase-17-signature-system.md)
- [Phase 17 VFX and Audio](phase-17-vfx.md)
- [Phase 17 QA and Rollout](../tech/phase-17-qa-and-rollout.md)
