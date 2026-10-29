Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-5-signature-system.md.

# Spec: UI — Phase 5 UI Additions & Crate Workshop Art

## Status
Draft

## Type
New Feature

## Goal
Specify the visual rendering, crate entity styles, HUD indicators, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 5 (Levels 2001–2500).

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md`, not yet implemented.

## Proposed Change
Implement Phase 5 visual styling and UI components in `lib/features/gameplay`:

### 1. Crate Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Standard Notions Crate:**
  - Light pine wood texture matching linen palette with rounded corners (4 dp radius).
  - Center metallic handle pin in burnished silver.
  - Subtle drop shadow (`offset: (1, 2)`, `blurRadius: 3`) to establish tactile depth above fabric.
- **M201 Crate Pit:**
  - Recessed dark woven linen hole with cross-stitched hem border.
  - When filled by a crate: flat embroidered patch smoothly animates over cell in 200 ms.
- **M202 Satin Crate:**
  - Shimmering pink/silver satin fabric wrapping with glossy directional specular highlights.
  - Soft ambient outer glow while in motion.
- **M203 Charm Crate:**
  - Ornate wooden box with an embossed metallic charm key on its upper face.
  - Charm color matches target clasp (Gold, Sapphire, Emerald, Amethyst).
  - High-contrast unique shape icon overlay (Star, Key, Diamond, Moon) for color-blind accessibility.
- **M204 Iron Crate:**
  - Industrial cast-iron dark graphite body with riveted edge plates and an engraved weight symbol (`anvil / 50kg`).
  - Distinctly heavier drop shadow (`offset: (2, 3)`, `blurRadius: 4`).

### 2. Onboarding Tutorial Cards
Presented modally at the start of respective intro levels:
- **Card P5-1 (Level 2001):** "Notions Crates!" — Animated diagram showing an unraveling thread bumping a crate and displacing it 1 cell into an empty space.
- **Card P5-2 (Level 2011):** "Crate Pits!" — Shows a crate pushed into a pit hole, transforming the gap into a traversable fabric bridge.
- **Card P5-3 (Level 2131):** "Satin Crates!" — Demonstrates a slippery satin crate sliding across multiple cells until hitting an obstacle.
- **Card P5-4 (Level 2251):** "Charm Crates!" — Shows pushing a charm-emblazoned crate into its matching clasp lock to permanently unlock it.
- **Card P5-5 (Level 2371):** "Heavy Iron Crates!" — Illustrates normal threads bouncing off iron crates, highlighting that Chunky Chenille or Ribbon Pairs are required to push them.

### 3. Accessibility & Responsive Adjustments
- **Color-Blind Glyph Overlays:** All charm crates (M203) feature dual encoding (color + shape geometry).
- **Reduced Motion Support:** When "Reduce Motion" setting is enabled, crate displacement snaps instantaneously (0 ms slide) rather than playing the 150 ms linear tween.
- **Touch Target Fidelity:** Crates do not absorb direct taps (taps always pass through to threads or scissors booster).

## Affected Files
- `lib/features/gameplay/presentation/painters/crate_painter.dart` (to be created: crate rendering)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_5.dart` (to be created: tutorial dialogs)
- `assets/images/crates/` (to be created: crate asset textures and charm SVGs)

## Risks
- Cluttered visual appearance on 14×14 grids. Mitigated by maintaining crisp vector rendering and clean fabric contrast.

## Open Questions
None. UI and tutorial requirements match Phase 5 documentation.
