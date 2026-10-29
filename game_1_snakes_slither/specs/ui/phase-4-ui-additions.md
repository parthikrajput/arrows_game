Source docs: phase_4/06_UI_AND_QA_PHASE_4.md, phase_4/01_PHASE_4_SCOPE_AND_RULES.md. Depends on: specs/ui/ui-ux-screens.md, specs/ui/phase-3-ui-additions.md, specs/gameplay/phase-4-signature-system.md.

# Spec: UI — Phase 4 UI Additions & Accessibility

## Status
Draft

## Type
New Feature

## Goal
Specify the UI components, vertical multi-floor tabs HUD, inter-floor camera transition animations, tutorial cards for M151–M154 and variants, and accessibility adaptations for Phase 4.

## Current State
Design documented in `phase_4/06_UI_AND_QA_PHASE_4.md` and `phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 1 & 2 HUD provided Moves, Hearts, Settings, and the 🔍 Fit button.
- Phase 3 added the top-bar Sun/Moon cycle dial HUD.
- There is currently no UI interface for navigating between stacked multi-floor levels or viewing vertical board hierarchies.

## Proposed Change
Implement the Multi-Floor Tabs HUD, camera transitions, and tutorial card presentation in `lib/features/gameplay/presentation/`:

### 1. Multi-Floor Navigation Tabs HUD
- **Location:** Docked vertically along the right screen margin, positioned below the top status bar.
- **Component Design:**
  - Stacked circular or pill tabs ordered top-to-bottom: `[F3]`, `[F2]`, `[F1]` corresponding to Canopy, Trunk, and Roots.
  - Number of visible tabs dynamically matches the active level's floor count (2 or 3 tabs).
  - **Active State:** The currently viewed floor tab is highlighted with an emerald border glow and scale bump ($1.1\times$).
  - **Inactive State:** Semi-transparent wooden bark texture with subtle white typography.
  - **Off-Screen Activity Badge:** When a snake begins slithering or an interactive obstacle triggers on a floor not currently in view, that floor tab emits a gentle pulsating leaf glow (green ripple badge) to notify the player.

### 2. Camera Transitions & Inter-Floor Navigation
- **Manual Tab Switch:**
  - Tapping an inactive floor tab switches view to that floor.
  - Transition: Smooth 200 ms vertical slide (`Curves.easeOutCubic`) accompanied by a subtle parallax shift in background foliage.
  - Free inspection: Move counter, hearts, and game state remain completely unaffected.
- **Auto-Tracking Camera:**
  - When a snake slithers through an inter-floor connector (M151 Root Stairs, M153 Knot Hole, M154 Vine Lift), the camera automatically initiates the vertical transition, tracking the snake head as it lands on the destination floor.
- **Pinch-Zoom & "Fit" Integration:**
  - Each floor retains independent pan offsets and zoom scales, or scales uniformly when standard "Fit" button is tapped.

### 3. Tutorial Cards & Guide Integration
- Dedicated full-screen modal tutorial cards triggered on first encounter:
  - **L1501:** Great Tree Floors (Intro to Floor Tabs, viewing = no move).
  - **L1511:** M151 Root Stairs (Inter-floor slither, directional continuation).
  - **L1631:** M152 Dewglass Floor (Transparent floor, non-blocking upper/lower interaction).
  - **L1751:** M153 Knot Hole (One-way downward drop, blocked landing bump).
  - **L1871:** M154 Vine Lift (Interactive platform tap, locked tap rule for partial snakes).
- All cards feature Grandpa Tortoise dialogue, looped visual demonstration, and a "Got it!" dismissal button.
- Cards permanently cataloged under `Settings -> Jungle Guide -> Great Tree Floors`.

### 4. Accessibility & Safe Play
- **Reduce Motion:**
  - Disables the 200 ms vertical slide animation entirely.
  - Floor switches perform an instant visual cut or short 100 ms alpha cross-fade.
- **Non-Color Dependent Indicators:**
  - In addition to color differences, floor tabs are explicitly labeled with text and iconography:
    - F1: Leafy Root icon + "F1"
    - F2: Tree Bark icon + "F2"
    - F3: Canopy Cloud icon + "F3"
- **Screen Reader (Semantics):**
  - Floor tabs declare accessibility labels: `"Floor 1 of 3: Roots, currently viewed"`, `"Floor 2 of 3: Trunk, tap to view"`.

## Affected Files
- `lib/features/gameplay/presentation/widgets/hud_floor_tabs.dart` (to be created)
- `lib/features/gameplay/presentation/controllers/floor_camera_controller.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/mechanic_tutorial_card.dart` (extended for Phase 4)
- `lib/features/settings/presentation/screens/jungle_guide_screen.dart` (Phase 4 guide entries added)

## Risks
- Vertical tab bar obstructing board tiles on narrow screens (< 360 dp width). Addressed by auto-docking tabs slightly into the margin and reducing tab radius from 24 dp to 20 dp on compact screens.

## Open Questions
- **OD-P4-01:** Final verification that 200 ms vertical slide with instant cut under Reduce Motion meets performance and accessibility comfort benchmarks.
