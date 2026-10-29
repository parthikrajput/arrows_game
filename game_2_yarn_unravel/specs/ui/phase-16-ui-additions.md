Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-16-base-mechanics.md.

# Spec: UI — Phase 16 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, tutorial overlays, jeweled charm rendering, key forging animations, and accessibility adaptations for Phase 16 (Levels 7501–8000).

## Current State
Documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Jeweled Charms & Key Forging Design
- **Jeweled Charm Aesthetics:**
  - Golden filigree lockets and gem-studded buttons mounted on needle heads.
  - Numbered chain badges ($1, 2, 3$) display embossed Roman/Arabic numerals with a warm outer glow for active links.
- **Key Forging Animation:**
  - Upon collecting both half-charms, a 220 ms central screen montage flies both halves together, culminating in a golden burst that forges the Grand Master Key.
- **Skeleton Key Styling:**
  - Intricate antique golden skeleton key rendering on the needle tip, glowing with a soft iridescent halo.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 7501:** "Jewel Box Charms — Ancient locks and golden keys! Follow the chain and collect keys in order."
- **Level 7511:** "Charm Chain — Order of stitching! Pull Charm 1 first before Charm 2 can be unlocked."
- **Level 7631:** "Charm Crafting — Two halves unite! Unravel both key carriers to forge the Grand Master Key."
- **Level 7751:** "Skeleton Charm — The master key! This golden charm unlocks any colored clasp on the board."
- **Level 7871:** "Charm Swap Hoop — Shift your shades! Tap the hoop to trade key colors between threads."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Charm Chain badges include distinct tactile borders (Circle for 1, Triangle for 2, Square for 3).
  - Skeleton charms feature a distinct skull/cross-key silhouette to avoid confusion with single-color keys.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/jeweled_charm_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/key_forging_overlay.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/charm_swap_hoop_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_16_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.
