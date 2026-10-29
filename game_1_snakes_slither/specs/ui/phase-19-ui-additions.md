# Technical Specification: Phase 19 UI Additions (Remix B)

**Status:** Draft  
**Phase:** 19 (Levels 9001–9500)  
**Theme:** Remix B (Phase 7 to Phase 12 Mechanics Synergy)  
**Document Type:** Technical UI Specification  
**Source Cross-Reference:** [phases/phase_19/06_UI_AND_QA_PHASE_19.md](../../phases/phase_19/06_UI_AND_QA_PHASE_19.md), [SHARED_CORE_STANDARD.md §9.3, §17.23](../../SHARED_CORE_STANDARD.md)

---

## 1. Top HUD Additions & Synergy Indicators

```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 9350 (Normal)        MOVES: 18       [COINS: 56,400] |
+-----------------------------------------------------------------------+
|  [WIND: -> EAST]    [RHYTHM: BEAT 2/3 (DOWNBEAT NEXT)]    [SIPHON: ON]  |
+-----------------------------------------------------------------------+
|                                                                       |
|                       [ TEMPEST RIVER CANOPY ]                        |
|           (M901 Gale Vine & M904 Seismic Node Active)                 |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```

### 1.1 Rhythm Metronome Pill Widget (`RhythmPillWidget`)
- Positioned in center status header.
- Displays 3 discrete drum beat pips:
  - Beats 1 and 2: Cool blue indicator with subtle pulse.
  - Beat 3 (Downbeat): Vibrant amber warning flash: `[RHYTHM: BEAT 2/3 (DOWNBEAT NEXT)]`.

### 1.2 Wind & Siphon Status Widgets
- **Wind Vector Arrow:** Displays active cardinal wind direction and velocity.
- **Siphon Status Pill:** Displays state of hydraulic river couplers (`[SIPHON: ON]` with rushing water chevron).

---

## 2. In-Grid Visual Indicators & Accessibility

### 2.1 Wind-Biased Vine Growth Ghosting
- Semi-transparent dashed vines render ahead of growing vine shoots, indicating exact path expansion on the upcoming move.

### 2.2 Seismic Shockwave Ripple Mesh
- Expanding circular ripple wave animates across grid tiles when a heavy python lands, highlighting affected Echo Bells.

### 2.3 Siphon Bridge Current Chevrons
- Dual-color animated arrows on river tiles show active current vector and flip dynamically when siphons trigger.

---

## 3. Touch Hitboxes & Input Handling
- Standard minimum $48 \times 48\text{ dp}$ hitboxes on all wind lever paddles and sluice switches.
- Multi-touch gesture filtering prevents camera pinch/pan conflicts during rapid slither turns.

---

## 4. References & Cross-Links
- [Phase 19 Signature System](../gameplay/phase-19-signature-system.md)
- [Phase 19 VFX and Audio](phase-19-vfx.md)
- [Phase 19 QA and Rollout](../tech/phase-19-qa-and-rollout.md)

