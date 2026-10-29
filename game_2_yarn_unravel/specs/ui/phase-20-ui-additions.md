Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md. Depends on: specs/ui/ui-ux-screens.md, specs/gameplay/phase-20-base-mechanics.md.

# Spec: UI — Phase 20 UI Additions

## Status
Draft

## Type
New Feature

## Goal
Define the visual presentations, Level 10,000 Grand Finale cinematics, Grand Master Weaver ceremony montage, and accessibility adaptations for Phase 20 (Levels 9501–10,000).

## Current State
Documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md`, not yet implemented in code.

## Proposed Change
Implement UI enhancements in `packages/puzzle_ui`:

### 1. Grand Master Visual Design & Cinematics
- **Moving Guardian Boss Stature:**
  - $2\times 2$ royal velvet guardian featuring intricate gear-driven clockwork aesthetics that pulse softly as it patrols the linen board.
- **Level 10,000 Grand Finale Aesthetic:**
  - Gold-threaded $14\times 14$ canvas border with harmonized HUD displaying active cycle, multi-floor, and metronome indicators.
- **Grand Master Ceremony:**
  - Upon clearing Level 10,000, initiates a full-screen 1,800 ms cinematic camera pan-out over the complete 10,000-level tapestry artwork, presenting the glowing "Grand Master Weaver" title and Golden Purl mascot badge.

### 2. Tutorial Cards
Modal dialogue introductions triggered upon first encounter:
- **Level 9501:** "The Endless Tapestry — The pinnacle of weaving! All master disciplines converge into the grandest puzzle."
- **Level 9511:** "Moving Guardian — A living threat! This clockwork pincushion patrols the board; time your extractions carefully."
- **Level 9631:** "Omni Gate — Triad of conditions! Align the light beam, matching dye, and correct cycle to open the way."
- **Level 9751:** "Grand Loom Spool — Thread dispenser! Clear the active thread to unroll new strands from the central bobbin."
- **Level 9871:** "Master Weaver Key — The supreme charm! Unravelling this golden key unlocks every clasp across the entire board."

### 3. Accessibility & Controls
- **High Contrast / Color Blind Mode:**
  - Moving Guardian's projected patrol path displays high-contrast dashed trajectory arrows.
  - Omni Gate displays three distinct status icons (Sun/Moon, Prism Ray, and Color Gem) showing real-time fulfillment of criteria.
- **Touch & Pinch-Zoom:**
  - Minimum touch target is 29 dp on baseline 360 dp screens, supported by smooth two-finger pinch-to-zoom and pan navigation on large 14×14 grids.

## Affected Files
- `packages/puzzle_ui/lib/src/widgets/moving_guardian_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/omni_gate_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/widgets/grand_loom_spool_widget.dart` (to be created)
- `packages/puzzle_ui/lib/src/screens/grand_master_ceremony_screen.dart` (to be created)
- `packages/puzzle_ui/lib/src/tutorials/phase_20_tutorials.dart` (to be created)

## Risks and Open Questions
- None. UI controls conform to standard accessibility and responsiveness guidelines.

