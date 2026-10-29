# Technical Specification: Phase 15 UI Additions (River Delta)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical UI Specification  
**Source Cross-Reference:** [phases/phase_15/06_UI_AND_QA_PHASE_15.md](../../phases/phase_15/06_UI_AND_QA_PHASE_15.md), [SHARED_CORE_STANDARD.md §9.3, §17.23](../../SHARED_CORE_STANDARD.md)

---

## 1. Top HUD Additions & Overlay Widgets

```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 7350 (Normal)        MOVES: 14       [COINS: 40,200] |
+-----------------------------------------------------------------------+
|  [TIDE: -> EAST (FLIP IN 2 MOVES)]           [SLUICE GATE: OPEN]       |
+-----------------------------------------------------------------------+
|                                                                       |
|                      [ DELTA GAME GRID ]                              |
|           (M701 Fork Switch & M704 Whirlpool active)                  |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```

### 1.1 Tide Countdown Pill Widget (`TidePillWidget`)
- Positioned pinned below the main status bar on the upper-left.
- Dynamic states:
  - Cyan background with right-pointing arrow: Eastward flood.
  - Amber background with left-pointing arrow: Westward ebb.
  - Ticker text: `[TIDE: -> EAST (FLIP IN 2 MOVES)]`.
  - Pulses rapidly when countdown reaches 1 move (`critical_pulse` animation).

### 1.2 Sluice Gate Status Widget (`SluicePillWidget`)
- Upper-right pill displaying current active hydraulic canal status:
  - Green border + text: `[SLUICE GATE: OPEN]` with animated water ripples.
  - Dark brown border + text: `[SLUICE GATE: CLOSED]` with dried mud icon.

---

## 2. In-Grid Visual Indicators & Accessibility

### 2.1 Animated Conveyor Chevrons
- Each conveyor tile renders a directional animated chevron texture moving along the flow vector at 1.5 cycles/sec.
- High-contrast toggle in Settings enables bold outline chevrons for colorblind accessibility.

### 2.2 Whirlpool Tangent Exit Pips
- Whirlpool loop tiles display subtle glowing exit arrows at viable release tangent points when a snake's head approaches.
- Flashing green indicator illuminates on legal tap windows.

### 2.3 Switch State Toggle Indicator
- M701 River Fork displays an illuminated brass arrow highlighting the active exit branch, with a semi-transparent grayed indicator on the closed branch.

---

## 3. Touch Hitboxes & Input Handling
- Sluice levers and fork switch toggles feature enlarged $48 \times 48\text{ dp}$ minimum touch targets to eliminate mis-taps on dense grids.
- Multi-touch gesture filtering prevents camera pinch/pan conflicts when tapping switches.

---

## 4. References & Cross-Links
- [Phase 15 Signature System](../gameplay/phase-15-signature-system.md)
- [Phase 15 VFX and Audio](phase-15-vfx.md)
- [Phase 15 QA and Rollout](../tech/phase-15-qa-and-rollout.md)

