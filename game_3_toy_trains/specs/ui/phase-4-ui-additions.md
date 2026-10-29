Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/ui/phase-3-ui-additions.md, specs/gameplay/phase-4-signature-system.md.

# Spec: UI — Phase 4 UI & Multi-Floor Navigation Additions

## Status
Draft

## Type
New Feature

## Goal
Specify the multi-floor navigation controls, floor selector tabs, camera vertical transitions, transparent glass deck rendering, and tutorial dialogs for Phase 4 (Station Floors) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases rendered a single unified tabletop board viewport.
- Phase 4 requires seamless UI switching between up to three vertically stacked station floors.

## Proposed Change
Extend the Flutter UI presentation layer:

### 1. Vertical Floor Selector Tabs (`FloorTabBar`)
- **Placement:** Docked along the right screen edge, vertically centered.
- **Visual Design:** Antique brass plate with carved wooden floor pill buttons:
  - Button `F3`: High Line Viaduct
  - Button `F2`: Mezzanine Platform
  - Button `F1`: Ground Yard
- **Badging:** Each floor button displays a miniature notification counter pill indicating remaining active trains on that level (e.g. `F1 (4)`). When all trains on a floor are cleared, a green checkmark appears.
- **Interaction:**
  - Tapping a button initiates a 250 ms vertical camera slide transition (`Curves.easeOutCubic`) to the selected floor plane.
  - Tapping does NOT count as a Move and causes 0 heart loss.

### 2. Glass Platform Translucency & Hit-Testing
- Glass Platform (M152) rendered with translucent glass material:
  - Specular highlight diagonal streaks and brass perimeter bracket screws.
  - Underneath floor tracks and trains are rendered with 0.85 opacity and subtle ambient shadow.
  - Gesture hit-tester allows direct tapping of trains located on the lower floor through the glass platform without requiring floor switching.

### 3. Tutorial Cards (`ftue_cards`)
- **L1501 (Station Floors Intro):** "Welcome to the Grand Multi-Tier Station! Tap the F1 and F2 tabs on the right to navigate between platform floors!"
- **L1511 (Station Stairs):** "Station Stairs carry trains directly between floors! Ensure the arrival track is clear before departing!"
- **L1631 (Glass Platform):** "Glass Platforms let you view and tap trains on lower floors directly through the glass deck!"
- **L1751 (Goods Chute):** "Goods Chutes drop trains down to the lower floor. Tap them again on the lower floor to resume their journey!"
- **L1871 (Goods Lift):** "Move a train onto the Goods Lift and tap the lever to transport it between floors!"

### 4. Accessibility & Visual Clarity
- Incline arrows painted on stairs indicate direction of travel (`▲ Up` or `▼ Down`).
- Floor levels feature distinct wallpaper trims: F1 dark mahogany wainscoting, F2 cream passenger tiles, F3 steel viaduct trusses.

## Affected Files
- `lib/features/gameplay/presentation/widgets/floor_tab_bar.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/floor_transition_controller.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/tutorial_card_dialog.dart` (changed: add Phase 4 tutorial cards)

## Design
- Screen: Gameplay screen layout with right-docked vertical floor tabs.
- Tokens: Consistent with Phase 1–3 toy railway brass and wood aesthetic.

## Risks
- Occlusion of right-hand grid cells on landscape tablets. Mitigation: Right HUD inset automatically pads board viewport horizontally.

## Open Questions
- None. Multi-floor UI controls and tutorial triggers match `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `SHARED_CORE_STANDARD.md`.

