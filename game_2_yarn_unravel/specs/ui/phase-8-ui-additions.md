Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-8-signature-system.md.

# Spec: UI — Phase 8 UI Additions & Garden Knitting Art

## Status
Draft

## Type
New Feature

## Goal
Specify the canvas rendering for growing ivy vines, snip shears icons, blooming floral gates, seed bead countdown badges, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phase/phase_8/06_UI_AND_QA_PHASE_8.md`, not yet implemented.

## Proposed Change
Implement Phase 8 visual styling and UI components in `lib/features/gameplay`:

### 1. Growth Entity Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Ivy Yarn Vines:**
  - Rendered as thick sage green twisted wool strands with decorative cross-stitched leaf buds branching into corners.
  - New segments manifest via a 200 ms spring-out scale animation (`Curves.elasticOut`).
- **Snip Tile Icons:**
  - Gilded sewing shears emblem embedded directly into the linen fabric.
  - Upon being crossed by a thread path, the shears icon executes a swift 360° spin accompanied by metallic snip feedback.
- **Blossom Gate (Bloom Gate):**
  - Closed state: Compact embroidered floral bud in dusty rose with surrounding green sepals.
  - Open state: 6 embroidered silk petals unfurl outward to the cell margins over 300 ms, leaving the center clear.
- **Seed Bead Countdown Badge:**
  - Round polished wooden bead with an overlaid canvas numeric badge (`3`, `2`, `1`) showing remaining moves before germination.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P8-1 (Level 3501):** "Garden Knitting!" — Introduces spreading ivy yarn, explaining how vines periodically creep into open board spaces.
- **Card P8-2 (Level 3511):** "Ivy Yarn Spread!" — Explains the clockwise expansion pattern ($U \to R \to D \to L$) and demonstrates that threads block vine advance.
- **Card P8-3 (Level 3631):** "Snip Tiles!" — Demonstrates pulling a thread across the shears icon to clear all 8 surrounding vine cells instantly.
- **Card P8-4 (Level 3751):** "Seed Bead Threads!" — Explains that leaving a seed behind will germinate into a wooden button after 3 moves unless crushed.
- **Card P8-5 (Level 3871):** "Blossom Gates!" — Demonstrates that pruning nearby ivy vines blooms the floral gate open.

### 3. Accessibility & Responsive Adjustments
- **High-Contrast Leaf Vein Textures:** Ivy segments feature sharp leaf silhouette contours distinguishable under monochrome and color-blind vision modes.
- **Reduced Motion Support:** Vine growth and blossom unfurling snap instantly (0 ms) when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/garden_painter.dart` (to be created: vine & blossom rendering)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_8.dart` (to be created: tutorial dialogs)
- `assets/images/garden/` (to be created: shears SVGs and floral textures)

## Risks
- Dense vine networks obscuring underlying thread paths. Mitigated by maintaining a high-contrast brightness differential between sage green vines and vibrant thread dyes.

## Open Questions
None. UI and tutorial requirements match Phase 8 documentation.
