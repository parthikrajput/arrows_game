Source docs: phases/phase_11/06_UI_AND_QA_PHASE_11.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §17.28. Depends on: specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-11-base-mechanics.md, specs/ui/phase-10-ui-additions.md.

# Spec: UI — Phase 11 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the dual-grid viewport layout, inter-board connector widgets, HUD counters, mirror pair highlight shaders, cross-board lock beams, and accessibility enhancements for Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phases/phase_11/06_UI_AND_QA_PHASE_11.md` and `SHARED_CORE_STANDARD.md` §12, not yet implemented.
- Previous UI assumed a single continuous canvas viewport.
- Phase 11 divides the screen into two stacked mini-grids (Pond 1 and Pond 2) connected by an animated physical vine suspension bridge.

## Proposed Change
Implement the Phase 11 dual-grid layout in `packages/puzzle_ui/lib/src/phase_11/`:

### 1. Dual-Grid Viewport Architecture
```
+-----------------------------------------------------------------------+
| [PAUSE]   LEVEL 5350 (Normal)        MOVES: 24       [COINS: 25,400] |
+-----------------------------------------------------------------------+
|  [POND 1: 12 REMAINING]                  [POND 2: 15 REMAINING]      |
+-----------------------------------------------------------------------+
|                                                                       |
|                       [ POND 1 (UPPER GRID) ]                         |
|                   (M501 Vine Bridge Exit linked)                      |
|                                                                       |
| ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ |
|               === [ M501 VINE BRIDGE CONNECTOR ] ===                  |
| ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ |
|                                                                       |
|                       [ POND 2 (LOWER GRID) ]                         |
|                 (M502 Target Gate & M503 Mirrors)                     |
|                                                                       |
+-----------------------------------------------------------------------+
|  [HINT (150)]       [SHIELD (200)]       [HAMMER (250)]       [RETRY] |
+-----------------------------------------------------------------------+
```
- **Unified Single-Screen View:** Both ponds fit vertically in portrait orientation without requiring user panning or viewport scrolling.
- **Divider Chasm:** A styled water river channel ($16\text{ dp}$ height) separates Upper Grid (Pond 1) and Lower Grid (Pond 2).
- **HUD Pond Counters:** Sub-header displays remaining snake counts per sub-grid: `[POND 1: 12 REMAINING]` and `[POND 2: 15 REMAINING]`.

---

### 2. Inter-Board Interactive Visuals
- **Vine Bridge Connector Widget:**
  - Placed over the divider channel aligned with source and destination exit/entry cells.
  - Braided green vines and floating water lily pads animate with soft gentle bobbing motion.
  - When a snake crosses, segments smoothly traverse across the chasm without clipping or visual seams.
- **Cross-Board Lock Flight Beam (M502):**
  - When the Messenger Snake departs Board 1, a luminous golden lotus spark traces a parabolic arc from Board 1 down to the locked gate on Board 2, accompanied by a blooming lock-open animation.
- **Mirror Twin Highlighting (M503):**
  - Tapping or touching either snake in a mirror pair instantly applies a pulsating azure glow to **both** partner snakes simultaneously across both boards.

---

### 3. Tutorial Cards & Interactive Onboarding
- **Card P11-01 (L5001 / L5011):** "Two Ponds: Vine Bridge" — Shows how snakes navigate from Pond 1 across the suspension bridge into Pond 2.
- **Card P11-02 (L5131):** "Messenger Key: Cross-Board Unlock" — Demonstrates that liberating the key snake on Pond 1 unseals the gate on Pond 2.
- **Card P11-03 (L5251):** "Mirror Twins: Dual Reflection" — Explains that mirror snakes move in synchronized tandem and both must have clear paths to proceed.
- **Card P11-04 (L5371):** "Relay Burrow: Submerged Portal" — Explains instant subterranean travel between ponds.

---

### 4. Accessibility & Multi-Modal Support
- **Mirror Pair Glyph Linking:**
  - Identical geometric glyphs ($\infty$ or $\diamondsuit$) are embossed on both mirror snakes so color perception is not required.
- **Border Differentiation:**
  - Pond 1 features a golden sunflower border frame; Pond 2 features an emerald water-lily border frame.
- **Reduce Motion Support:**
  - Replaces animated parabolic spark arcs with an immediate target lock flash.
  - Inter-board bridge transit uses a rapid 50 ms fade-out / fade-in across thresholds.

## Affected Files
- `packages/puzzle_ui/lib/src/phase_11/dual_pond_viewport.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_11/vine_bridge_connector_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_11/cross_board_beam_fx.dart` (to be created)
- `packages/puzzle_ui/lib/src/phase_11/phase_11_tutorial_dialogs.dart` (to be created)
- `test/ui/phase_11_ui_test.dart` (to be created)

## Risks and Open Questions
- **Touch Routing Accuracy:** When two grids are tightly stacked, player finger touches near the divider boundary must cleanly resolve to either the lower row of Board 1 or the upper row of Board 2 without misinterpreting taps. Hit-testing will enforce an explicit dead-zone across the central $16\text{ dp}$ chasm.
