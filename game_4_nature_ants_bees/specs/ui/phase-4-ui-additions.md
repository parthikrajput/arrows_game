Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, specs/ui/ui-ux-screens.md, SHARED_CORE_STANDARD.md §13, §14. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-4-base-mechanics.md.

# Spec: UI — Phase 4 UI Additions (Floor Switcher & Camera Transitions)

## Status
Draft

## Type
New Feature

## Goal
Design and integrate UI elements for Phase 4: the vertical Floor Switcher HUD, smooth inter-floor camera glide transitions, and tutorial notification cards for multi-floor navigation.

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Current UI assumes a single 2D board viewport.
- No floor navigation tabs, vertical camera panning, or multi-floor indicator badges exist.

## Proposed Change
Extend Flutter UI widgets in `lib/features/gameplay/widgets/`:

### 1. Vertical Floor Switcher HUD Widget
- **Location:** Anchored to the right edge of the gameplay screen.
- **Visual Design:** Stack of pill-shaped floor tabs matching the level's floor count (2 or 3 tabs):
  - `[T3] Upper Canopy` (green ivy accent, L1751+)
  - `[T2] Main Garden` (golden sun accent)
  - `[T1] Lower Terrace` (rich earth brown accent)
- **Interactive State:**
  - Active floor highlighted with warm white glow and 4 dp elevation.
  - Inactive floors displayed with semi-transparent badge (opacity 0.65).
  - Uncleared line indicator pip: small badge displaying the count of remaining active lines on each floor.
  - Tapping a tab triggers an instant 200 ms vertical camera scroll to the selected floor.

### 2. Autonomous Inter-Floor Camera Tracking
- When a player taps an insect line that crosses through stairs (M151), a rabbit hole (M153), or an elevator (M154):
  - The camera automatically executes a smooth 250 ms `Curves.fastOutSlowIn` vertical parallax scroll to follow the traveling insect onto its destination floor.
  - Touch input is locked during transit to prevent race conditions.

### 3. Phase 4 Tutorial Overlay Cards
One-line non-modal notification banner presented at the top of the board during intro levels:
- **L1501:** *"Garden Terraces — The garden expands across multiple vertical floors. Tap floor tabs to switch!"*
- **L1511:** *"Root Stairs — Marching insects travel between floors through these stairs."*
- **L1631:** *"Dew-Glass Terrace — Watch below! Upper insects cast blocking shadows onto the lower terrace."*
- **L1751:** *"Rabbit Hole & Upper Canopy — Drop directly down to lower floors. Explore all 3 floors!"*
- **L1871:** *"Acorn Lift — Tap this elevator platform to raise or lower insects between floors."*

### 4. Accessibility & Touch Targets
- Each floor tab has minimum touch dimensions of $48\times 48\text{ dp}$.
- VoiceOver / TalkBack announcements: *"Floor 2 of 3, Main Garden, 4 lines remaining, active."*

## Affected Files
- `lib/features/gameplay/widgets/floor_switcher_widget.dart` (to be created)
- `lib/features/gameplay/widgets/multi_floor_viewport.dart` (to be created)
- `lib/features/gameplay/screens/gameplay_screen.dart` (changed to host multi-floor viewport)

## Design
- Matches design tokens in `specs/ui/ui-ux-screens.md`: 2D `CustomPainter` with soft-3D gradients, pre-baked drop shadows, and 48x48 dp minimum touch bounds.

## Risks
- Viewport disorientation when camera jumps between floors. Mitigated by continuous vertical parallax scrolling giving clear spatial cues.

## Open Questions
- None. UI components and navigation behaviors match `phase/phase_4/06_UI_AND_QA_PHASE_4.md` §1.

