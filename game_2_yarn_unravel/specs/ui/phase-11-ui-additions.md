Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-11-signature-system.md.

# Spec: UI — Phase 11 UI Additions & Twin Hoops Art

## Status
Draft

## Type
New Feature

## Goal
Specify the dual-canvas layout, smart camera auto-framing, zig-zag seam stitch rendering, fluffy pompom portals, onboarding tutorial cards, and accessibility enhancements for Yarn Unravel Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md`, not yet implemented.

## Proposed Change
Implement Phase 11 visual styling and UI components in `lib/features/gameplay`:

### 1. Dual-Board Styling & Canvas Rendering
Rendered via `CustomPainter` on the board fabric surface:
- **Twin Hoops Smart Framing:**
  - Screen displays dual circular embroidery hoops (Hoop A in upper-left quadrant, Hoop B in lower-right quadrant).
  - Intelligent camera controller smoothly pans and focuses when a player taps an active needle on either board, while retaining a 20% peripheral preview of the sister hoop.
- **Seam Edge (Zig-zag Stitch):**
  - Rendered as an embroidered golden metallic zig-zag seam joining the adjacent rim boundaries of both hoops.
  - Shimmers with an undulating traveling wave when traversed by a thread.
- **Relay Pompom Portals:**
  - Rendered as soft, spherical woolen pompoms with fluffy yarn tufts and matching color-coded center beads.
- **Cross Charm Linkage:**
  - Subtle semi-transparent golden guide filament indicates connection between Cross Charm on Hoop A and target Clasp on Hoop B when Thread Peek booster is active.

### 2. Onboarding Tutorial Cards
Modal tutorial cards presented on first turns of intro levels:
- **Card P11-1 (Level 5001):** "Twin Hoops!" — Explains the dual mini board layout, showing you can tap threads on either hoop at any time.
- **Card P11-2 (Level 5011):** "Seam Edges!" — Demonstrates a thread exiting Hoop A through the stitched seam and continuing across onto Hoop B.
- **Card P11-3 (Level 5131):** "Cross Charms!" — Shows how unravelling a key thread on Hoop A unlocks an obstruction clasp on Hoop B.
- **Card P11-4 (Level 5251):** "Mirror Hoops!" — Illustrates twin threads that must unravel simultaneously across both hoops.
- **Card P11-5 (Level 5371):** "Relay Pompoms!" — Demonstrates entering a pompom on one hoop and instantly emerging from the paired pompom on the other.

### 3. Accessibility & Responsive Adjustments
- **Board Differentiation:** Hoop A features an oak hoop rim; Hoop B features a dark walnut hoop rim with distinct label tags (`A` and `B`).
- **Reduced Motion Support:** Seam transitions and pompom jumps snap instantly (0 ms) when "Reduce Motion" is enabled.

## Affected Files
- `lib/features/gameplay/presentation/painters/dual_hoop_painter.dart` (to be created: dual canvas renderer)
- `lib/features/gameplay/presentation/widgets/tutorial_card_phase_11.dart` (to be created: tutorial dialogs)
- `assets/images/twin_hoops/` (to be created: seam stitch textures and pompom SVGs)

## Risks
- Canvas scale factor degradation causing low-resolution texturing. Mitigated by vector SVG rendering for all hoop boundaries and embroidery details.

## Open Questions
None. UI and tutorial requirements match Phase 11 documentation.
