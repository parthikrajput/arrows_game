Source docs: phases/phase_7/06_UI_AND_QA_PHASE_7.md, phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §14, §15. Depends on: specs/ui/ui-ux-screens.md, specs/ui/phase-6-ui-additions.md.

# Spec: UI — Phase 7 UI Additions and Rotational Overlays

## Status
Draft

## Type
New Feature

## Goal
Implement the user interface components, central rotor turntable handles, spinning snake trajectory chevrons, perimeter edge shift indicators, and tutorial cards for Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phases/phase_7/06_UI_AND_QA_PHASE_7.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Previous UI handled static orthogonal board visuals and optical beam overlays.
- Phase 7 introduces dynamic circular wheel handles, rotating sub-grid animations, and changing snake heading markers.

## Proposed Change
Implement Phase 7 UI additions in `lib/features/gameplay/presentation/widgets/rotation/`:

### 1. Rotational UI Components & Indicators

1. **Sub-Board Rotor Handle Widget (M301):**
   - Centered circular wooden flower handle positioned at the intersection of the central 4 cells $[(x_1+1, y_1+1) \dots (x_1+2, y_1+2)]$.
   - Interactive tap target with an embossed curved rotation arrow ($\circlearrowright$).
   - **Straddle Lock State:** If a snake straddles the boundary, the rotor disc outline glows soft yellow with a caution lock badge.
2. **Spinning Snake Trajectory Crest (M303):**
   - Renders a miniature dynamic golden spiral on the snake's head.
   - A subtle dotted curved chevron points toward the prospective direction of its next 90° CW turn, giving the player instant predictive awareness.
3. **Tangled Lock Warning Badge (Standard §17.39):**
   - If a rotation causes a snake's head to point into its own body, an amber `"Tangled!"` badge pulses above the head.
   - Tapping displays a brief explanatory tooltip: *"Unblock lane before rotating!"*
4. **Turning Hedges Perimeter Track (M302):**
   - Outer perimeter displays subtle directional chevrons showing the clockwise motion track of border hedge segments.

---

### 2. Tutorial Cards (FTUE Onboarding)
Modal cards displayed at the start of respective intro levels:
- **L3011 Tutorial (Island Spinner):** *"Tap the center handle to turn the 4x4 island! All snakes completely inside will turn 90° clockwise. Don't trap snakes across the boundary!"*
- **L3131 Tutorial (Turning Hedges):** *"The hedge walls on the border shift 1 space clockwise after every move! Time your slither to slip through the moving gaps."*
- **L3251 Tutorial (Spinning Snake):** *"Spinning Snakes turn 90° after every single move! Catch them when their exit path is open."*
- **L3371 Tutorial (Gear Lock):** *"Gear Gates only open when the island is turned to the matching angle! Align the wheel to clear the path."*

## Affected Files
- `lib/features/gameplay/presentation/widgets/rotation/rotor_handle_widget.dart` — to be created
- `lib/features/gameplay/presentation/widgets/rotation/spinning_snake_crest.dart` — to be created
- `lib/features/gameplay/presentation/widgets/rotation/tangled_warning_badge.dart` — to be created
- `lib/features/tutorials/data/phase_7_tutorial_cards.dart` — to be created

## Risks and Open Questions
- **Hitbox Overlap:** Ensuring the central rotor handle doesn't intercept taps intended for snakes slithering directly under the center.
  - *Mitigation:* The rotor handle occupies a distinct 40 dp circular touch target with clear elevated shadow z-index.

