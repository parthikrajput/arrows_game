Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, specs/ui/ui-ux-screens.md, SHARED_CORE_STANDARD.md §13, §14. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/phase-6-base-mechanics.md.

# Spec: UI — Phase 6 UI Additions (Optical HUD & Shade Feedback)

## Status
Draft

## Type
New Feature

## Goal
Design and integrate UI elements for Phase 6: sundial move-count HUD badges, shade patch sleeping/awakening feedback, optical filter color indicators, and Phase 6 tutorial notification cards.

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `specs/ui/ui-ux-screens.md`, not yet implemented.
- Current UI lacks dynamic beam intensity badges, color filter legends, and sleeping line UI lock cues.

## Proposed Change
Extend Flutter UI widgets in `lib/features/gameplay/widgets/`:

### 1. Sundial Emitter HUD Badge
- Positioned floating above active Sundial Lenses (M253):
  - Displays remaining moves in current ON/OFF phase (e.g. "Beam: 2 moves left").
  - Pulses gently on the final move before toggling state.

### 2. Shade Patch "In the Dark!" Feedback
- Shaded insect lines (M254) render with dimmed, desaturated opacity (0.5x alpha) and a floating sleeping "Zzz" icon near the head.
- Tapping a shaded line triggers a localized wobble animation with a temporary tooltip: *"In the dark! Shine sunlight here to awaken."*
- When a beam hits the line, a bright golden awakening burst plays and full color saturation is restored with an alert insect chirp.

### 3. Petal Filter Color Glows
- Color-filtered beams display a glowing chromatic aura matching their filter hue (Red, Yellow, Blue).
- Associated sunflower receivers glow with matching color rings to provide clear player affordances.

### 4. Phase 6 Tutorial Overlay Cards
One-line non-modal notification banner presented at the top of the board during intro levels:
- **L2501:** *"Sunlit Garden — Channel sunlight through prisms and petals to solve optical puzzles!"*
- **L2511:** *"Petal Filter — Pass white sunlight through colored petals to change the beam's color."*
- **L2631:** *"Twin-Sun Lock — Illuminate both receivers simultaneously to unlock this thorny gate."*
- **L2751:** *"Sundial Lens — This lens powers ON and OFF every few moves. Plan your march!"*
- **L2871:** *"Shade Patch — Insects asleep in the dark cannot move. Beam light onto them to wake them up!"*

## Affected Files
- `lib/features/gameplay/widgets/sundial_badge_widget.dart` (to be created)
- `lib/features/gameplay/widgets/shade_overlay_painter.dart` (to be created)
- `lib/features/gameplay/widgets/tutorial_banner.dart` (changed to include Phase 6 cards)

## Design
- Matches design tokens in `specs/ui/ui-ux-screens.md`: 2D `CustomPainter` with soft-3D gradients, pre-baked drop shadows, and 48x48 dp minimum touch bounds.

## Risks
- Low contrast of sleeping lines on OLED screens under night mode. Mitigated by adding an illuminated white outline around sleeping insect silhouettes.

## Open Questions
- None. UI components and optical indicators match `phase/phase_6/06_UI_AND_QA_PHASE_6.md` §1.
